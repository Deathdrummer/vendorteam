<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Vacation_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	/**
	 * Получение списка пользователей для формирования календаря отпусков
	 * @param вернуть ли данные для статика. По-умолчанию false
	 * @return date => [user_id => data]
	 */
	public function getVacationUsers($currentStatic = false) {
		$this->db->select('vu.id, vu.user_id, vu.date, vu.confirmed, u.nickname, u.avatar');
		if (!$currentStatic) $this->db->select('vu.static_id');
		$this->db->join('users u', 'u.id = vu.user_id');
		if ($currentStatic) $this->db->where('vu.static_id', $currentStatic);
		$query = $this->db->get('vacation_users vu');
		$response = $query->result_array() ?: false;
		
		$data = [];
		
		if ($currentStatic) {
			$this->load->model('users_model', 'usersmodel');
			$userData = $this->usersmodel->getUsers(['where' => ['u.id' => $this->getUserId()]])[0];
			$data[$userData['id']]['user_id'] = $userData['id'];
			$data[$userData['id']]['nickname'] = $userData['nickname'];
			$data[$userData['id']]['dates'] = [];
			
			if ($response) {
				foreach ($response as $user) {
					$data[$user['user_id']]['user_id'] = $user['user_id'];
					$data[$user['user_id']]['nickname'] = $user['nickname'];
					$data[$user['user_id']]['avatar'] = $user['avatar'];
					$data[$user['user_id']]['dates'][$user['date']] = $user['confirmed'];
				}
			}
			
			return $data;
		}
		
		if ($response) {
			foreach ($response as $user) {
				$data[$user['static_id']][$user['user_id']]['user_id'] = $user['user_id'];
				$data[$user['static_id']][$user['user_id']]['nickname'] = $user['nickname'];
				$data[$user['static_id']][$user['user_id']]['avatar'] = $user['avatar'];
				$data[$user['static_id']][$user['user_id']]['dates'][$user['date']] = $user['confirmed'];
			}
		}
		return $data;
	}
	
	
	
	
	
	
	
	/**
	 * Получить количество дней отпуска за текущий год
	 * @param 
	 * @return 
	 */
	public function getUserVacationsCountOfYear($userId = false) {
		if (!$userId) return false;
		$startPoint = mktime(0, 0, 0, 1, 1, date('Y'));
		$endPoint = mktime(0, 0, 0, 1, 1, date('Y') + 1);
		
		$this->db->where('user_id', $userId);
		$this->db->where('date >=', $startPoint);
		$this->db->where('date <', $endPoint);
		return $this->db->count_all_results('vacation_users') ?: 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function setVacationDate($data = false) {
		if (!$data) return false;
		
		$insert = [];
		foreach ($data['dates'] as $date) {
			$insert[] = [
				'user_id' 	=> $data['user_id'],
				'static_id' => $data['static_id'],
				'date' 		=> $date
			];
		}
		
		if (!$this->db->insert_batch('vacation_users', $insert)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function unsetVacationDate($data = false) {
		if (!$data) return false;
		$this->db->where('user_id', $data['user_id']);
		$this->db->where('static_id', $data['static_id']);
		$this->db->where_in('date', $data['dates']);
		
		if (!$this->db->delete('vacation_users')) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function setDays($days = false) {
		if (!$days) return false;
		if (!$this->db->insert_batch('vacation_users', $days)) return false;
		return true;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function confirmDays($days = false) {
		if (!$days) return false;
		foreach ($days as $k => $day) {
			if ($this->db->count_all_results() == 0) {
				$this->db->where($day);
				$this->db->update('vacation_users', ['confirmed' => 1]);
			} else {
				$day['confirmed'] = 1;
				$this->db->insert('vacation_users', $day);
			}
		}
		return true;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function removeDays($days = false) {
		if (!$days) return false;
		foreach ($days as $k => $day) {
			$this->db->where($day);
		}
		$this->db->delete('vacation_users');
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function enabledStaticDay($static = false, $day = false) {
		if (!$static || !$day) return false;
		$this->db->where(['static_id' => $static, 'day' => $day]);
		if (!$this->db->delete('vacation_disabled')) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function disabledStaticDay($static = false, $day = false) {
		if (!$static || !$day) return false;
		if (!$this->db->insert('vacation_disabled', ['static_id' => $static, 'day' => $day])) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function globalSetDisabledDay($data = false) {
		if (!$data) return false;
		if (!$this->db->insert_batch('vacation_disabled', $data)) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function globalRemoveDisabledDay($data = false) {
		if (!$data) return false;
		foreach ($data as $item) $this->db->or_where($item);
		if (!$this->db->delete('vacation_disabled')) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getDisabledDays($static = false) {
		if ($static) $this->db->where('static_id', $static);
		$query = $this->db->get('vacation_disabled');
		if (!$result = $query->result_array()) return false;
		$data = [];
		if ($static) {
			foreach ($result as $item) {
				$data[] = $item['day'];
			}
		} else {
			foreach ($result as $item) {
				$data[$item['static_id']][] = $item['day'];
			}
		}
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getSettings($staticId = false, $jdecode = true) {
		if ($staticId) $this->db->where('static_id', $staticId);
		$query = $this->db->get('vacation_settings');
		$strType = $staticId ? 'row_array' : 'result_array';
		if (!$response = $query->$strType()) return false;
		
		if ($staticId) {
			if ($jdecode) {
				$response['disabled_week'] = json_decode($response['disabled_week'], true);
				$response['disabled_month'] = json_decode($response['disabled_month'], true);
				$response['enabled_ranks'] = json_decode($response['enabled_ranks'], true);
			}
			
			return $response;
		}
		
		if ($jdecode) {
			foreach ($response as $k => $item) {
				$response[$k]['disabled_week'] = json_decode($item['disabled_week'], true);
				$response[$k]['disabled_month'] = json_decode($item['disabled_month'], true);
				$response[$k]['enabled_ranks'] = json_decode($item['enabled_ranks'], true);
			}
		}
		
		return setArrKeyFromField($response, 'static_id', true);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function saveSettings($data = false) {
		if (!$data) return false;
		$this->db->empty_table('vacation_settings');
		if (!$this->db->insert_batch('vacation_settings', $data)) return false;
		return true;
	}
	
}
