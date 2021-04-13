<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Users_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
		$this->load->model('admin_model');
	}
	
	
	
	/**
	 * Получиться список участников
	 * @param условия
	 * @param сортировка
	 * @param направление сортировки
	 * @return 
	 */
	public function getUsers($params = []) {
		$where = isset($params['where']) ? $params['where'] : false;
		$whereIn = isset($params['where_in']) ? $params['where_in'] : false;
		$like = isset($params['like']) ? $params['like'] : false;
		$orderField = isset($params['field']) ? $params['field'] : false;
		$orderType = isset($params['order']) ? $params['order'] : false;
		$returnFields = isset($params['fields']) ? $params['fields'] : false;
		
		$this->db->select('u.*, us.lider, us.static_id AS static');
		$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
		
		
		if ($where) $this->db->where($where);
		if ($whereIn) $this->db->where_in($whereIn['field'], $whereIn['values']);
		if ($like) $this->db->like($like['field'], $like['value'], $like['placed']);
		
		$this->db->order_by('us.static_id ASC');
		if ($orderField && $orderType) $this->db->order_by($orderField, $orderType);
		else $this->db->order_by('u.nickname ASC');
		
		$query = $this->db->get('users u');
		if (!$usersData = $query->result_array()) return false;
		
		if ($returnFields) $usersData = setArrKeyFromField($usersData, false, $returnFields);
		
		return $usersData ?: false;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список статоков пользователя с отметкой тех, в которых он состоит
	 * @param users ID
	 * @return array [id] => 45, [name] => EU Alliance, [isset] => 1
	 */
	public function getUsersStatics($usersId = null) {
		if (is_null($usersId)) return false;
		$this->db->select('static_id, lider, main');
		$this->db->where('user_id', $usersId);
		$query = $this->db->get('users_statics');
		$response = $query->result_array();
		if (!$allStatics = $this->admin_model->getStatics()) return false;
		$usersStatics = $response ? setArrKeyFromField($response, 'static_id') : [];
		
		$data = [];
		foreach ($allStatics as $staticId => $static) {
			$data[] = [
				'id' 	=> $staticId,
				'name' 	=> $static['name'],
				'has'	=> isset($usersStatics[$staticId]) ? 1 : 0,
				'lider'	=> isset($usersStatics[$staticId]) ? $usersStatics[$staticId]['lider'] : 0,
				'main'	=> isset($usersStatics[$staticId]) ? $usersStatics[$staticId]['main'] : 0
			];
		}
		return $data;
	}
	
	
	
	
	
	
	
	/**
	 * Получить ID участников заданного статика
	 * @param static ID
	 * @return array
	*/
	public function getUsersFromStatic($staticId = false, $onlyMain = false) {
		if (!$staticId) return false;
		$this->db->select('user_id');
		$this->db->where('static_id', $staticId);
		if ($onlyMain) $this->db->where('main', 1);
		if (!$result = $this->_result('users_statics')) return false;
		$staticUsers = array_column($result, 'user_id');
		return $staticUsers;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Получить ID главного статика участника
	 * @param 
	 * @return 
	 */
	public function getMainStaticId($usersId = null) {
		if (is_null($usersId)) return false;
		$this->db->select('static_id');
		$this->db->where('user_id', $usersId);
		$query = $this->db->get('users_statics');
		if (!$row = $query->row_array()) return false;
		return $row['static_id'];
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список классов пользователя с отметкой тех, в которых он состоит
	 * @param users ID
	 * @return array [id] => 45, [name] => EU Alliance, [isset] => 1
	 */
	public function getUsersClasses($usersId = null) {
		if (is_null($usersId)) return false;
		$this->db->select('class_id, mentor');
		$this->db->where('user_id', $usersId);
		$query = $this->db->get('users_classes');
		$response = $query->result_array();
		if (!$allClasses = $this->admin_model->getClasses()) return false;
		$usersClasses = $response ? setArrKeyFromField($response, 'class_id') : [];
		
		$data = [];
		foreach ($allClasses as $classId => $class) {
			$data[] = [
				'id' 		=> $classId,
				'name' 		=> $class['name'],
				'has'		=> isset($usersClasses[$classId]) ? 1 : 0,
				'mentor'	=> isset($usersClasses[$classId]) ? $usersClasses[$classId]['mentor'] : 0,
			];
		}
		return $data;
	}
	
	
	
	
	
	/**
	 * Задать статики участнику
	 * @param 
	 * @return 
	 */
	public function setUserClasses($userId, $userClasses) {
		if ($userClasses) {
			$this->db->where('user_id', $userId);
			$this->db->delete('users_classes');
		}
		
		$clData = [];
		foreach (array_keys(array_intersect_key($userClasses['part'], $userClasses['mentor'])) as $classId) {
			$clData[$classId]['part'] = $userClasses['part'][$classId];
			$clData[$classId]['mentor'] = $userClasses['mentor'][$classId];
		}
		
		$insertData = [];
		if ($clData) {
			foreach ($clData as $classId => $item) {
				if (!isset($item['part']) || $item['part'] == 0) continue;
				$insertData[] = [
					'user_id' 	=> $userId,
					'class_id'	=> $classId,
					'mentor'	=> $item['mentor']
				];	
			}
			
			if (!$insertData) {
				$this->db->where('user_id', $userId);
				$this->db->delete('users_classes');
				return 1;
			} else {
				if ($this->db->insert_batch('users_classes', $insertData)) return 1;
			}
		}
		return 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getOfftimeUsers($static = false) {
		$today = strtotime('today');
		$this->db->select('ou.user_id');
		$this->db->join('users u', 'ou.user_id = u.id');
		$this->db->where(['u.verification' => 1, 'u.deleted' => 0]);
		if ($static) $this->db->where('static', $static);
		$this->db->where('ou.date', $today);
		$query = $this->db->get('offtime_users ou');
		if ($response = $query->result_array()) return array_column($response, 'user_id');
		return false;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getUserRank($userId = false) {
		if (!$userId) return false;
		$this->db->select('r.*');
		$this->db->where('u.id', $userId);
		$this->db->join('ranks r', 'r.id = u.rank');
		$query = $this->db->get('users u');
		if (!$response = $query->row_array()) return false;
		return $response;
	}
	
	
	
	
	
	
	
	
	/**
	 * Задать данные одного участника
	 * @param данные пользователя
	 * @param статус верификации
	 * @return статус
	 */
	public function setUserData($userData, $verification = false) {
		$this->db->where('id', $userData['user_id']);
		$query = $this->db->get('users');
		if (!$tableData = $query->row_array()) return 0;
		
		
		$this->db->set([
			'nickname'		=> $userData['user_nickname'],
			'color'			=> isset($userData['user_color']) ? $userData['user_color'] : null,
			//'access_level'	=> $userData['user_access_level'],
			'role'			=> $userData['user_role'],
			'stage'			=> $userData['user_stage'],
			'payment'		=> $userData['user_payment'],
			'deposit'		=> $userData['user_deposit']
		]);
		
		if ($verification) {
			if ($tableData['deleted'] == 1) {
				$this->db->set(['verification' => 1, 'deleted' => 0]);
			} else {
				$this->db->set(['verification' => 1, 'rank' => $this->admin_model->getFirstRankId()]);
			}
		} 
		
		if ($userData['user_reg_date']) {
			$this->db->set(['reg_date' => is_numeric($userData['user_reg_date']) ? $userData['user_reg_date'] : strtotime($userData['user_reg_date'])]);
		} 
		
		$this->db->where('id', $userData['user_id']);
		if ($this->db->update('users')) {
			$this->setRankToUser($userData['user_id']);
			return 1;
		}
		return 0;
	}
	
	
	
	
	
	
	
	
	/**
	 * Задать уровень доступа по-умолчанию
	 * @param 
	 * @return 
	 */
	public function setUsersAccess($id = false) {
		if (!$id) return false;
		if (!$this->db->update('users', ['access' => $id])) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * Присвоение Звания участнику
	 * @param 
	 * @return 
	 */
	public function setRankToUser($userId = null) {
		if (is_null($userId) || (!$ranksData = $this->admin_model->getRanks(true, false))) return false;
		
		$this->db->select('u.id, u.reg_date, u.stage, u.rank');
		$this->db->where('id', $userId);
		$query = $this->db->get('users u');
		if (!$userData = $query->row_array()) return false;
		
		$now = time();
		$userPeriod = floor(($now - $userData['reg_date']) / (60 * 60 * 24)) + $userData['stage'];
		$userRank = $userData['rank'];
		
		$updateUserData = false;
		foreach ($ranksData as $key => $rank) {
			if (($userPeriod >= $rank['period'] && (isset($ranksData[$key + 1]) && $userPeriod < $ranksData[$key + 1]['period']) && $rank['id'] != $userRank) || ($userPeriod >= $rank['period'] && (!isset($ranksData[$key + 1])) && $rank['id'] != $userRank)) {
				$updateUserData = ['rank' => $rank['id']];
			}
		}
		
		if ($updateUserData) {
			$this->db->where('id', $userId);
			$this->db->update('users', $updateUserData);
		}
		
		return 1;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Задать данные участников
	 * @param 
	 * @return 
	 */
	public function setUsersData($users) {
		if (!$users) return 0;
		foreach ($users as $k => $user) {
			if (isset($user['reg_date']) && $user['reg_date']) {
				$users[$k]['reg_date'] = is_numeric($user['reg_date']) ? $user['reg_date'] : strtotime($user['reg_date']);
			} else {
				unset($users[$k]['reg_date']);
			}
		}
		
		$this->refreshUsersOfftime($users);
		$this->refreshUsersPayments($users);
		$this->db->update_batch('users', $users, 'id');
		$this->setRanksToUsers();
		return 1;
	}
	
	
	
	
	
	/**
	 * Задать бухгалтерию участников
	 * @param 
	 * @return 
	 */
	public function setUsersAccounting($users = false) {
		if (!$users) return 0;
		$this->db->update_batch('users', $users, 'id');
		return 1;
	}
	
	
	
	
	
	/**
	 * Задать статистику участников
	 * @param 
	 * @return 
	 */
	public function setUsersStat($users) {
		if (!$users) return 0;
		$this->db->update_batch('users', $users, 'id');
		return 1;
	}
	
	
	
	
	
	/**
	 * Обнулить бронирование выходных, если изменилась роль
	 * @param список участников
	 * @return 
	 */
	public function refreshUsersOfftime($users) {
		if (!$users) return false;
		$usersRoles = [];
		foreach ($users as $user) $usersRoles[$user['id']] = $user['role'];
		
		$this->db->select('id, role');
		$this->db->where_in('id', array_keys($usersRoles));
		$query = $this->db->get('users');
		if ($response = $query->result_array()) {
			$usersTable = [];
			foreach ($response as $user) $usersTable[$user['id']] = $user['role'];
			$diffUsersRoles = array_diff($usersRoles, $usersTable);
			
			if ($diffUsersRoles) {
				$this->db->where_in('user_id', array_keys($diffUsersRoles));
				$this->db->delete('offtime_users');
			}
		} 	
	}
	
	
	
	
	/**
	 * Обновить платежные данные в других таблицах
	 * @param список пользователей
	 * @return 
	 */
	public function refreshUsersPayments($users) {
		if (!$users) return false;
		$usersPayments = [];
		foreach ($users as $user)  {
			$usersPayments[] = [
				'user_id' => $user['id'],
				'payment' => isset($user['payment']) ? $user['payment'] : null,
			];
		}
			
		$this->db->update_batch('users_orders', $usersPayments, 'user_id');	
	}
	
	
	
	
	
	
	
	
	/**
	 * Обновить Резервы участников
	 * @param 
	 * @return 
	 */
	public function depositUpdate($data = false) {
		if (!$data) return false;
		foreach ($data as $k => $item) {
			if (isset($item['deposit_origin'])) unset($data[$k]['deposit_origin']);
		}
		if ($this->db->update_batch('users', $data, 'id')) return true;
		return false;
	}
	
	
	
	
	
	
	
	/**
	 * Присвоения Званий
	 * @param 
	 * @return 
	 */
	public function setRanksToUsers() {
		if (!$ranksData = $this->admin_model->getRanks(true, false)) return false;
		
		$this->db->select('u.id, u.reg_date, u.stage, u.rank');
		//$this->db->where(['verification' => 1, 'deleted' => 0]); // присваивать звания только верифицированным и не удаленным
		$query = $this->db->get('users u');
		if (!$usersList = $query->result_array()) return false;
		
		$now = time();
		$updateUsersData = [];
		foreach ($usersList as $user) {
			$userPeriod = ($now - $user['reg_date']) > 0 ? floor(($now - $user['reg_date']) / (60 * 60 * 24)) + $user['stage'] : 0;
			$userRank = $user['rank'];
			
			foreach ($ranksData as $key => $rank) {
				if (($userPeriod >= $rank['period'] && (isset($ranksData[$key + 1]) && $userPeriod < $ranksData[$key + 1]['period']) && $rank['id'] != $userRank) || ($userPeriod >= $rank['period'] && (!isset($ranksData[$key + 1])) && $rank['id'] != $userRank)) {
					$updateUsersData[$user['id']] = [
						'id' 	=> $user['id'],
						'rank'	=> $rank['id']
					];
				}
			}
		}
		
		if (! empty($updateUsersData)) {
			$this->db->update_batch('users', array_values($updateUsersData), 'id');
		}
		
		return 1;
	}
	
	
	
	
	
	
	
	
	/**
	 * Задать статики участнику
	 * @param 
	 * @return 
	 */
	public function setUserStatics($userId, $userStatics) {
		if ($userStatics) {
			$this->db->where('user_id', $userId);
			$this->db->delete('users_statics');
		}
		
		$stData = [];
		foreach (array_keys(array_intersect_key($userStatics['part'], $userStatics['lider'], $userStatics['main'])) as $staticId) {
			$stData[$staticId]['part'] = $userStatics['part'][$staticId];
			$stData[$staticId]['lider'] = $userStatics['lider'][$staticId];
			$stData[$staticId]['main'] = $userStatics['main'][$staticId];
		}
		
		$insertData = [];
		if ($stData) {
			foreach ($stData as $staticId => $item) {
				if (!isset($item['part']) || $item['part'] == 0) continue;
				$insertData[] = [
					'user_id' 	=> $userId,
					'static_id'	=> $staticId,
					'lider'		=> $item['lider'],
					'main'		=> $item['main']
				];	
			}
			
			if ($this->db->insert_batch('users_statics', $insertData)) return 1;
		}
		return 0;
	}
	
	
	
	
	
	
	/**
	 * Задать / обновить депозит участников
	 * @param 
	 * @return 
	*/
	public function setUsersDeposit($data = false) {
		if (!$data) return false;
		
		$usersIds = array_keys($data);
		
		$this->db->where_in('id', $usersIds);
		$this->db->select('id, deposit');
		if (!$tableData = $this->_result('users')) return false;
		
		$updateData = [];
		foreach ($tableData as $user) {
			$updateData[] = [
				'id' 		=> $user['id'],
				'deposit'	=> (float)$user['deposit'] + (float)$data[$user['id']]
			];
		}
		
		if ($this->db->update_batch('users', $updateData, 'id')) return true;
		return false;
	}
	
	
	
	
	/**
	 * Пометить участника как удаленного
	 * @param ID пользователя
	 * @return статус
	 */
	public function deleteUser($id) {
		$this->db->where('id', $id);
		$query = $this->db->get('users');
		if ($userData = $query->row_array()) {
			
			if (is_file('public/images/users/'.$userData['avatar'])) {
				unlink('public/images/users/'.$userData['avatar']);
			}
			
			if (is_file('public/images/users/mini/'.$userData['avatar'])) {
				unlink('public/images/users/mini/'.$userData['avatar']);
			}
			
			$this->db->where('id', $id);
			$this->db->update('users', [
				'avatar' 		=> null,
				'verification' 	=> 0,
				'deleted' 		=> 1,
				'agreement' 	=> 0
			]);
			return 1;
		}
		return 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Задать цвет участнику
	 * @param 
	 * @return 
	 */
	public function changeUserColor($userId = false, $color = false) {
		$this->db->where('id', $userId);
		if ($this->db->update('users', ['color' => $color])) return true;
		return false;
	}
	
	
	
	
	
	
	/**
	 * Получить список увольняющихся участников
	 * @param дата последнего рабочего дня была 10 дней назад
	 * @return 
	*/
	public function getResignUsersIds($daysLeft = false) {
		$this->db->select('user_id');
		if ($daysLeft) $this->db->where('date_last <=', strtotime(date('Y-m-d', strtotime('-10 days'))));
		$this->db->where('stat', 0);
		$this->db->where('done', 0);
		if (!$result = $this->_result('resign')) return false;
		return array_values(array_unique(array_column($result, 'user_id')));
	}
	
	
	/**
	 * Переместить уволенных участников в инактив
	 * @param 
	 * @return 
	*/
	public function replaceResignUsers($usersIds = false, $replaceStaticId = false) {
		if (!$usersIds || !$replaceStaticId) return false;
		
		$this->db->where_in('user_id', $usersIds);
		$this->db->delete('users_statics');
		
		$insData = [];
		foreach ($usersIds as $userId) {
			$insData[] = [
				'user_id'	=> $userId,
				'static_id'	=> $replaceStaticId,
				'main'		=> 1
			];
		}
		
		if (!$this->db->insert_batch('users_statics', $insData)) {
			toLog('replaceResignUsers -> не выполнилась!');
			return false;
		} 
		$this->db->where_in('user_id', $usersIds);
		$this->db->update('resign', ['done' => 1]);
		return true;
	}
	
	
	
}