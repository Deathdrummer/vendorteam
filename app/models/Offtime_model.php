<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Offtime_model extends My_Model {
	
	private $userData = false;
	
	public function __construct() {
		parent::__construct();
		if (get_cookie('id')/*$this->session->has_userdata('id')*/) {
			$this->load->model('account_model');
			$this->userData = $this->account_model->getUserData(get_cookie('id')/*$this->session->userdata('id')*/);
		}
	}
	
	
	
	
	
	/**
	 * Получить лимиты ролей
	 * @param 
	 * @return 
	 */
	public function getRolesLimits($currentStatic = false) {
		if ($currentStatic) {
			$this->load->model('account_model');
			$this->db->where('ol.static', $currentStatic);
		} 
		
		$query = $this->db->get('offtime_limits ol');
		
		$tableData = [];
		if ($response = $query->result_array()) {
			foreach ($response as $item) {
				if ($currentStatic) $tableData[$item['role']] = $item['limit'];
				else $tableData[$item['role']][$item['static']] = $item['limit'];
			}
		}
		
		return $tableData;
	}
	
	
	
	
	
	/**
	 * Установить лимиты ролей
	 * @param 
	 * @return 
	 */
	public function setRolesLimits($data) {
		$tData = $this->_result('offtime_limits');
		
		$tableData = [];
		if ($tData) {
			foreach ($tData as $item) {
				$tableData[$item['role'].'|'.$item['static']] = [
					'id' 	=> $item['id'],
					'limit' => $item['limit']
				];
			}
		}
		
		$newData = [];
		foreach ($data as $roleId => $rData) foreach ($rData as $staticId => $limit) {
			$newData[$roleId.'|'.$staticId] = $limit;
		}
		
		
		$diff = array_diff_key($newData, $tableData); // новые записи
		$intersect = array_intersect_key($newData, $tableData); // существующие записи
		
		foreach ($intersect as $roleStatic => $limit) {
			$intersect[$roleStatic] = [
				'id' 	=> $tableData[$roleStatic]['id'],
				'limit' => $limit
			];
		}
		
		$insertData = [];
		foreach ($diff as $roleStatic => $limit) {
			$rs = explode('|', $roleStatic);
			$insertData[] = [
				'role' 		=> $rs[0],
				'static' 	=> $rs[1],
				'limit' 	=> $limit
			];
		}
		if ($insertData) $this->db->insert_batch('offtime_limits', $insertData);
		
		$updateData = [];
		foreach ($intersect as $roleStatic => $item) {
			$rs = explode('|', $roleStatic);
			$updateData[] = [
				'id'		=> $item['id'],
				'role' 		=> $rs[0],
				'static' 	=> $rs[1],
				'limit' 	=> $item['limit']
			];
		}
		if ($updateData) $this->db->update_batch('offtime_limits', $updateData, 'id');
		
		return 1;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Забронировать выходной
	 * @param 
	 * @return 
	 */
	public function setOfftime($data) {
		if ($data['static'] == 0) return 0;
		$this->load->model('admin_model');
		$offtimeUserMonthLimit = $this->admin_model->getSettings('offtime_user_limit'); // лимит выходных на одного в месяц
		$periodStart = strtotime(date('Y-m-d', strtotime('first day of 0 month', $data['date'])));
		$periodEnd = strtotime(date('Y-m-d', strtotime('first day of next month', $data['date'])));
		$data['date'] = strtotime(date('Y-m-d', $data['date']));
		
		
		$rolesLimits = $this->getRolesLimits($data['static']);
		$roleLimit = isset($rolesLimits[$data['role']]) ? $rolesLimits[$data['role']] : 0;
		$staticLimit = isset($rolesLimits[0]) ? $rolesLimits[0] : 0;
		
		
		// лимит на роль в день
		$this->db->where([
			'static' 	=> $data['static'],
			'role' 		=> $data['role'],
			'date' 		=> $data['date']
		]);
		$countRolesUsersOfDay = $this->db->count_all_results('offtime_users');
		if ($countRolesUsersOfDay >= $roleLimit) {
			return -1;
		}
		
		
		// лимит на все роли одного статика в день
		$this->db->where([
			'static' 	=> $data['static'],
			'date' 		=> $data['date']
		]);
		$countStaticUsersOfDay = $this->db->count_all_results('offtime_users');
		if ($countStaticUsersOfDay >= $staticLimit) {
			return -2;
		} 
		
		
		// лимит на количество выходных в месяц
		$this->db->where([
			'user_id' 	=> $data['user_id'],
			'static'	=> $data['static'],
			'date >=' 	=> $periodStart,
			'date <' 	=> $periodEnd
		]);
		if ($this->db->count_all_results('offtime_users') >= $offtimeUserMonthLimit) return -3;
		
		
		$this->db->where([
			'user_id' 	=> $data['user_id'],
			'static' 	=> $data['static'],
			'date' 		=> $data['date']
		]);
		
		// если у этого участника в этот день уже есть выходной
		if ($this->db->count_all_results('offtime_users') > 0) return -4;
		if (!$this->db->insert('offtime_users', $data)) return false;
		return 1;
	}
	
	
	
	
	
	
	
	/**
	 * Снять бронь 
	 * @param 
	 * @return 
	 */
	public function unsetOfftime($id, $static) {
		$this->db->where(['id' => $id, 'static' => $static]);
		$this->db->delete('offtime_users');
		return true;
	}
	
	
	
	
	
	
	/**
	 * Получение списка пользователей для формирование календаря выходных
	 * @param вернуть ли данные для статика. По-умолчанию false
	 * @return date => [user_id => data]
	 */
	public function getOfftimeUsers($currentStatic = false) {
		$this->db->select('ou.id, ou.user_id, ou.date, r.id AS role_id, r.name AS role_name, u.nickname');
		if (! $currentStatic) $this->db->select('ou.static');
		$this->db->join('roles r', 'r.id = ou.role');
		$this->db->join('users u', 'u.id = ou.user_id');
		if ($currentStatic) $this->db->where('ou.static', $currentStatic);
		//$this->db->group_by('ou.id');
		$query = $this->db->get('offtime_users ou');
		if(!$response = $query->result_array()) return [];
		
		$data = [];
		if ($currentStatic) {
			foreach ($response as $item) {
				$userId = $item['user_id'];
				$date = $item['date'];
				unset($item['user_id'], $item['date']);
				$data[$date]['users'][$userId] = $item;
				if (!isset($data[$date]['roles'][$item['role_id']])) $data[$date]['roles'][$item['role_id']] = 1;
				else $data[$date]['roles'][$item['role_id']] += 1;
			}
		} else {
			foreach ($response as $item) {
				$static = $item['static'];
				$userId = $item['user_id'];
				$date = $item['date'];
				unset($item['user_id'], $item['date'], $item['static']);
				$data[$static][$date][$userId] = $item;
			}
		}
		
		return $data;
	}
	
	
	
	
	
	/**
	 * Получение списка запрещенных дней
	 * @param 
	 * @return 
	 */
	public function getOfftimeDisabled() {
		$query = $this->db->get('offtime_disable od');
		if (!$response = $query->result_array()) return [];
		
		$data = [];
		foreach ($response as $item) {
			$data[$item['static']][$item['date']] = $item['id'];
		}
		return $data;
	}
	
	
	
	
	
	/**
	 * Добавить запрещенный для выходных день
	 * @param массив статик и дата
	 * @return ID вставленной записи
	 */
	public function disableDay($data) {
		$this->db->insert('offtime_disable', ['static' => $data['static'], 'date' => $data['date']]);
		return $this->db->insert_id();
	}
	
	
	
	
	
	/**
	 * Разрешить день для выходных
	 * @param ID вставленной записи
	 * @return массив статик и дата
	 */
	public function enableDay($id) {
		$this->db->where('id', $id);
		$query = $this->db->get('offtime_disable');
		$resonse = $query->row_array();
		
		$this->db->where('id', $id);
		if ($this->db->delete('offtime_disable')) {
			return $resonse;
		}
	}
	
	
	
	
	
	/**
	 * Удалить всех участников из заданной даты
	 * @param 
	 * @return 
	 */
	public function removeUsersFromDay($static, $date, $userId = false) {
		$this->db->where(['static' => $static, 'date' => $date]);
		if ($userId) $this->db->where('user_id', $userId);
		if ($this->db->delete('offtime_users')) return 1;
		return 0;
	}
	
	
	
	
	
	
	
	
	/**
	 * Нигде не используется
	 * @param 
	 * @return 
	 */
	public function getOfftimeUserLimit() {
		$this->load->model('admin_model');
		$offtimeUserLimit = $this->admin_model->getSettings('offtime_user_limit');
		
		$periodStart = strtotime(date('Y-m-d', strtotime('first day of 0 month')));
		$periodEnd = strtotime(date('Y-m-d', strtotime('first day of next month')));
		
		$this->db->where([
			'user_id' 	=> get_cookie('id'), //$this->session->userdata('id'),
			'date >=' 	=> $periodStart,
			'date <' 	=> $periodEnd
		]);
		
		return $this->db->count_all_results('offtime_users') < $offtimeUserLimit ? true : false;
	}
	
	
	
	
	
	
}