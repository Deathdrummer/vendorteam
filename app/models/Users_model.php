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
		$orWhere = isset($params['or_where']) ? $params['or_where'] : false;
		$whereIn = isset($params['where_in']) ? $params['where_in'] : false;
		$whereNotIn = isset($params['where_not_in']) ? $params['where_not_in'] : false;
		$like = isset($params['like']) ? $params['like'] : false;
		$orLike = isset($params['or_like']) ? $params['or_like'] : false;
		$orderField = isset($params['field']) ? $params['field'] : false;
		$orderType = isset($params['order']) ? $params['order'] : false;
		$returnFields = isset($params['fields']) ? $params['fields'] : false;
		
		$this->db->select('u.*, us.lider, us.static_id AS static, s.name AS static_name, s.icon AS static_icon');
		$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
		$this->db->join('statics s', 's.id = us.static_id', 'LEFT OUTER');
		
		
		if ($where) $this->db->where($where);
		if ($whereIn) $this->db->where_in($whereIn['field'], $whereIn['values']);
		if ($whereNotIn) $this->db->where_not_in($whereNotIn['field'], $whereNotIn['values']);
		if ($orWhere) $this->db->or_where($orWhere);
		if ($like) $this->db->like($like['field'], $like['value'], (isset($like['placed']) ? $like['placed'] : 'both'));
		if ($orLike) $this->db->or_like($orLike['field'], $orLike['value'], (isset($orLike['placed']) ? $orLike['placed'] : 'both'));
		
		$this->db->order_by('us.static_id ASC');
		if ($orderField && $orderType) $this->db->order_by($orderField, $orderType);
		else $this->db->order_by('u.nickname ASC');
		
		$query = $this->db->get('users u');
		if (!$usersData = $query->result_array()) return false;
		if ($returnFields) $usersData = setArrKeyFromField($usersData, 'id', true, $returnFields);
		
		
		return $usersData ?: false;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getRaidLiders() {
		$this->db->select('u.id, u.avatar, u.nickname, u.rank_lider, us.lider, '.$this->groupConcatValue('us.static_id', 'statics'));
		$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
		$this->db->where('us.lider', 1);
		$this->db->group_by('u.id');
		
		if (!$result = $this->_result('users u')) return false;
		
		$lidersData = [];
		foreach ($result as $row) {
			$row['statics'] = json_decode($row['statics'], true);
			$lidersData[] = $row;
		}
		
		return $lidersData;
		
	}
	
	
	
	
	
	
	
	/**
	 * Получить ID участников по званиям и\или статикам
	 * @param 
	 * @return 
	*/
	public function getRanksStaticsUsers($ranks = false, $statics = false, $orderBy = 'u.rank') {
		if (!$ranks) return false;
		
		$this->db->select('u.id AS user_id, u.rank, s.id AS static_id');
		$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
		$this->db->join('statics s', 's.id = us.static_id', 'LEFT OUTER');
		$this->db->where_in('u.rank', $ranks);
		if ($statics) $this->db->where_in('us.static_id', $statics);
		$this->db->order_by($orderBy, 'ASC');
		if (!$result = $this->_result('users u')) return false;
		
		$data = [];
		foreach ($result as $row) {
			$data[$row['static_id']][$row['user_id']] = $row['rank'];
		}
		return $data;
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
	 * Получить список персонажей
	 * @param ID участника
	 * @param Вернуть только тех, у кого указан ID игры
	 * @return array [iser_id => [personage_id => data]] или [personage_id => data]
	*/
	public function getUsersPersonages($userId = false, $onlyWithGameId = false) {
		$this->db->select('id, user_id');
		if ($userId && is_numeric($userId)) {
			$this->db->where('user_id', $userId);
		} elseif ($userId && is_array($userId)) {
			$this->db->where_in('user_id', $userId);
		} 
		if ($onlyWithGameId) $this->db->where('game_id IS NOT NULL');
		if (!$usersGamesIds = $this->_result('personages_game_ids')) return false;
		
		$usersgamesMap = setArrKeyFromField($usersGamesIds, 'id', 'user_id');
		$usersGamesIds = array_column($usersGamesIds, 'id');
		
		$this->db->select('up.*, pgi.game_id AS game_id_name');
		$this->db->join('personages_game_ids pgi', 'pgi.id = up.game_id', 'LEFT OUTER');
		$this->db->where_in('up.game_id', $usersGamesIds);
		if (!$usersPersonages = $this->_result('users_personages up')) return false;
		
		
		$uPData = [];
		
		if ($userId && is_numeric($userId)) {
			foreach ($usersPersonages as $row) {
				$personageId = arrTakeItem($row, 'id');
				$uPData[$personageId][] = $row;
			}
			return $uPData;
		}
		
		foreach ($usersPersonages as $row) {
			$userId = $usersgamesMap[$row['game_id']];
			//$fromId = arrTakeItem($row, 'from_id');
			$personageId = arrTakeItem($row, 'id');
			$uPData[$userId][$personageId] = $row;
		}
		
		return $uPData;
	}
	
	
	
	
	
	
	
	/**
	 * Задать данные участников
	 * @param 
	 * @return 
	 */
	public function setUsersData($users = false) {
		if (!$users) return 0;
		
		$toAdminAction = [];
		foreach ($users as $k => $user) {
			if (isset($user['reg_date']) && $user['reg_date']) {
				$users[$k]['reg_date'] = is_numeric($user['reg_date']) ? $user['reg_date'] : strtotime($user['reg_date']);
			} else {
				unset($users[$k]['reg_date']);
			}
			
			if (isset($user['birthday']) && $user['birthday']) {
				$users[$k]['birthday'] = is_numeric($user['birthday']) ? $user['birthday'] : strtotime($user['birthday']);
			} else {
				unset($users[$k]['birthday']);
			}
			
			if (isset($user['payment_origin']) && isset($user['payment'])) {
				if ($user['payment_origin'] != $user['payment']) {
					$toAdminAction[] = [
						'user_id'		=> $user['id'],
						'payment_old'	=> $user['payment_origin'],
						'payment_new'	=> $user['payment']
					];
				}
			}
				
			
			unset($users[$k]['payment_origin']);
		}
		
		$this->refreshUsersOfftime($users);
		//$this->refreshUsersPayments($users); обновить платежные данные участников
		
		
		if ($toAdminAction) $this->adminaction->setAdminAction(4, $toAdminAction);
		
		$this->db->update_batch('users', $users, 'id');
		$this->setRanksToUsers();
		return 1;
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
			//'deposit'		=> $userData['user_deposit']
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
			if ($verification && $tableData['deleted'] == 1) $this->adminaction->setAdminAction(3, ['user_id' => $userData['user_id'], 'stat' => 1]);
			
			if ($tableData['payment'] != $userData['user_payment']) {
				$this->adminaction->setAdminAction(4, [['user_id' => $userData['user_id'], 'payment_old' => $tableData['payment'], 'payment_new' => $userData['user_payment']]]);
			}
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
		
		if (isset($data['id'])) {
			if (isset($data['deposit_origin'])) unset($data['deposit_origin']);
			if (isset($data['payment_origin'])) unset($data['payment_origin']);
			$this->db->where('id', $data['id']);
			if (!$this->db->update('users', $data)) return false;
			return true;
		}
		
		foreach ($data as $k => $item) {
			if (isset($item['deposit_origin'])) unset($data[$k]['deposit_origin']);
			if (isset($item['payment_origin'])) unset($item['payment_origin']);
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
		$this->db->where(['u.verification' => 1, 'u.deleted' => 0]); // присваивать звания только верифицированным и не удаленным
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
		
		if (!empty($updateUsersData)) {
			$this->db->update_batch('users', array_values($updateUsersData), 'id');
		}
		
		return $updateUsersData;
	}
	
	
	
	
	
	
	
	
	/**
	 * Задать статики участнику
	 * @param 
	 * @return 
	 */
	public function setUserStatics($userId, $userStatics) {
		if ($userStatics) {
			$this->db->where('user_id', $userId);
			$tableStatics = $this->_result('users_statics');
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
			
			if (!$this->db->insert_batch('users_statics', $insertData)) return 0;
			$this->adminaction->setAdminAction(1, ['before' => $tableStatics, 'after' => $insertData]);
			return 1;
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
	 * Задать / обновить депозит участника
	 * @param ID участника
	 * @param сумма, которую нужно зачислить или вычесть. TRUE - обнулить резерв
	 * @return 
	*/
	public function setUserDeposit($userId = false, $summ = false) {
		if (!$userId || !$summ) return false;
		
		if ($summ === true) {
			$this->db->where('id', $userId);
			if (!$this->db->update('users', ['deposit' => 0])) return false;
			return true;
		}
		
		$this->db->where('id', $userId);
		$this->db->select('id, deposit');
		if (!$tableUser = $this->_row('users')) return false;
		
		if (!$this->db->update('users', ['deposit' => (float)$tableUser['deposit'] + (float)$summ])) return false;
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * Пометить участника как удаленного
	 * @param ID пользователя
	 * @return статус
 	*/
	public function deleteUser($id = false) {
		if (!$id) return false;
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
			if (!$this->db->update('users', ['avatar' => null, 'verification' => 0, 'deleted' => 1, 'agreement' => 0])) return 0;
			$this->adminaction->setAdminAction(3, ['user_id' => $id, 'stat' => 0]);
			return 1;
		}
		return 0;
	}
	
	
	
	
	
	/**
	 * Пометить участника как отстраненного
	 * @param ID пользователя
	 * @return статус
 	*/
	public function excludeUser($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('users', ['excluded' => 1])) return 0;
		$this->adminaction->setAdminAction(2, ['user_id' => $id, 'stat' => 0]);
		return 1;
	}
	
	
	
	
	/**
	 * Восстановить отстраненного участника
	 * @param ID пользователя
	 * @return статус
 	*/
	public function includeUser($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('users', ['excluded' => 0])) return 0;
		$this->adminaction->setAdminAction(2, ['user_id' => $id, 'stat' => 1]);
		return 1;
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