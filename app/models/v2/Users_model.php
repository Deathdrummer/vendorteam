<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Users_model extends MY_Model {
	
	private $usersStaticsTable = 'users_statics';
	private $usersTable = 'users';
	private $staticsTable = 'statics';
	private $classesTable = 'classes';
	private $usersClassesTable = 'users_classes';
	private $usersListPart = 20;
	private $usersFieldsSql;
	private $allFields = [
		'color' 			=> ['title' => 'Цвет', 'cls' => 'w60px center'],
		'agreement' 		=> ['title' => 'Соглашение', 'cls' => 'w60px center', 'icon' => '<i class="fa fa-handshake-o" title="Соглашение"></i>'],
		'rank' 				=> ['title' => 'Звание', 'cls' => 'w220px'],
		'lider' 			=> ['title' => 'Лидер', 'cls' => 'w60px center', 'icon' => '<div title="Лидер"><svg class="w18px h18px darkblue"><use xlink:href="#crown"></use></svg></div>'],
		'email' 			=> ['title' => 'E-mail', 'cls' => 'w200px'],
		'reg_date' 			=> ['title' => 'Дата регистрации', 'cls' => 'w160px'],
		'stage' 			=> ['title' => 'Стаж', 'cls' => 'w100px'],
		'payment' 			=> ['title' => 'Средство платежа', 'cls' => 'w210px'],
		'birthday' 			=> ['title' => 'Дата рождения', 'cls' => 'w160px'],
		'deposit_percent' 	=> ['title' => 'Процент отчисления в депозит', 'cls' => 'w72px center', 'icon' => '<i class="fa fa-percent" title="Процент отчисления в депозит"></i>'],
		'role' 				=> ['title' => 'Роль', 'cls' => 'w170px'],
		'access' 			=> ['title' => 'Доступ', 'cls' => 'w170px'],
		//'statics' 			=> ['title' => 'Статики', 'cls' => 'w200px'],
		//'classes' 			=> ['title' => 'Клс.', 'cls' => ''],
		//'personages' 		=> ['title' => 'Перс.', 'cls' => ''],
		'nda' 				=> ['title' => 'NDA', 'cls' => 'w60px center'],
	];
	
	
	
	
	
	public function __construct() {
		parent::__construct();
		$this->usersFieldsSql = [
			'color'				=> 'u.color',
			'agreement'			=> 'u.agreement',
			'rank' 				=> 'u.rank',
			'email' 			=> 'u.email',
			'birthday' 			=> 'u.birthday',
			'reg_date' 			=> 'u.reg_date',
			'payment' 			=> 'u.payment',
			'nda' 				=> 'u.nda',
			'lider' 	 		=> 'SUM(us.lider) AS lider',
			'role' 				=> 'u.role',
			'agreement' 		=> 'u.agreement',
			'stage' 			=> 'u.stage',
			'deposit_percent'	=> 'u.deposit_percent',
			'access' 			=> 'u.access',
			//'statics' 			=> '',
			'classes' 			=> '',
			'personages' 		=> '',
		];
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function list($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			case 'all':
				//if (!isset($static) && !isset($searchStr)) return false;
				$sqlFields = isset($fields) ? $this->_getSqlFields($fields) : '';
				$staticsFields = ['main', 'lider'];
				
				$select = 'u.id, u.nickname, u.avatar, u.deleted, u.excluded, u.frozen, ';
				if (isset($fields) && !!array_intersect($staticsFields, $fields)) $select .= $this->groupConcat('us.static_id', 'us.static_id:id,us.main:main,us.lider:lider', 'statics_data');
				if ($sqlFields) $select .= $sqlFields;
				
				$this->db->select($select);
				$this->db->join($this->usersStaticsTable.' us', 'u.id = us.user_id', 'LEFT OUTER');
				
				
				if (isset($searchStr)) $this->db->like('u.'.$searchField, $searchStr, 'after');
				
				if (isset($static) && is_numeric($static)) $this->db->where(['us.static_id' => $static]);
				elseif (isset($static) && $static == 'nostatic') $this->db->where(['us.static_id' => null]);
				
				
				if (isset($ranks)) $this->db->where_in('u.rank', $ranks);
				
				
				if (isset($showLists)) {
					$this->db->group_start();
					
					$showVerify = in_array('verify', $showLists);
					$showNew = in_array('new', $showLists);
					$showExcluded = in_array('excluded', $showLists);
					$showFrozen = in_array('frozen', $showLists);
					$showDeleted = in_array('deleted', $showLists);
					
					
					if ($showVerify) {
						$this->db->or_group_start();
						$this->db->or_where('u.verification', 1);
						$this->db->where('u.deleted', 0);
						$this->db->where('u.frozen', 0);
						$this->db->where('u.excluded', 0);
						$this->db->group_end();
					}
					
					if ($showNew) {
						$this->db->or_group_start();
						$this->db->where('u.verification', 0);
						$this->db->where('u.deleted', 0);
						$this->db->group_end();
					}
					
					if ($showExcluded) {
						$this->db->or_group_start();
						$this->db->or_where('u.excluded', 1);
						$this->db->group_end();
					}
					
					if ($showFrozen) {
						$this->db->or_group_start();
						$this->db->or_where('u.frozen', 1);
						$this->db->group_end();
					}
					
					if ($showDeleted) {
						$this->db->or_group_start();
						$this->db->or_where('u.deleted', 1);
						$this->db->group_end();
					}
					
					$this->db->group_end();
				} 
				
				
				if (isset($sortField)) $this->db->order_by('u.'.$sortField, $sortOrder);
				$this->db->group_by('u.id');
				if (!$result = $this->_resultWithCount($this->usersTable.' u', $this->usersListPart, (isset($offset) ? ($offset * $this->usersListPart) : 0))) return false;
				
				//toLog($this->db->last_query());
				
				// Если в списке полей есть звание - загрузить модель 
				if (isset($fields) && in_array('rank', $fields)) $this->load->model('account_model', 'account');
				
				if (isset($fields)) {
					$result['items'] = array_map(function($row) use ($fields) {
						$user = array_splice($row, 0, 6); // забираем срец массива со статичными данными (которые всегда должны отображаться)
						if (isset($row['statics_data'])) {
						if (!$statics = json_decode(arrTakeItem($row, 'statics_data'), true)) return $row;
							$staticsIds = [];
							$main = 0;
							$lider = 0;
							foreach ($statics as $static) {
								$staticsIds[] = $static['id'];
								if ($static['main'] == 1) $main = 1;
								if ($static['lider'] == 1) $lider = 1;
							}
							
							if (in_array('statics', $fields)) $row['statics'] = $staticsIds;
							if (in_array('main', $fields)) $row['main'] = $main;
							if (in_array('lider', $fields)) $row['lider'] = $lider;
						}
						
						// если есть поле "звание" - добавить данные сл. звания
						if (in_array('rank', $fields ?? [])) {
							$row['rank'] = [
								'current'	=> $row['rank'],
								'next'		=> $this->account->getNextRankData($user['id'])
							];
						}
						$user['fields'] = arrGetByKeys($fields, $row);
						
						return $user;
					}, $result['items']);
				}
				
				setAjaxHeader(['total' => $result['total'], 'part' => $this->usersListPart]);
				return $result;
				break;
			
			
			case 'save':
				if (!isset($userId)) return false;
				if (preg_match('/\d{2,4}-\d{2}-\d{2,4}/', $value)) $value = strtotime($value);
				$this->db->where('id', $userId);
				if (!$this->db->update($this->usersTable, [$field => $value])) return false;
				return true;
				break;
			
			case 'delete':
				if (!isset($userId)) return false;
				$this->db->where('id', $userId);
				return $this->db->update($this->usersTable, ['deleted' => 1]);
				break;
			
			case 'return_deleted':
				if (!isset($userId)) return false;
				$this->db->where('id', $userId);
				return $this->db->update($this->usersTable, ['deleted' => 0]);
				break;
			
			
			case 'exclude':
				if (!isset($userId)) return false;
				$this->db->where('id', $userId);
				return $this->db->update($this->usersTable, ['excluded' => 1]);
				break;
			
			case 'return_excluded':
				if (!isset($userId)) return false;
				$this->db->where('id', $userId);
				return $this->db->update($this->usersTable, ['excluded' => 0]);
				break;
			
			case 'freeze':
				if (!isset($userId)) return false;
				$this->db->where('id', $userId);
				if (($userFrozen = $this->_row('users', 'frozen')) === false) return false;
				$this->db->where('id', $userId);
				if (!$this->db->update($this->usersTable, ['frozen' => ($userFrozen ? 0 : 1)])) return false;
				return ($userFrozen ? 1 : 2);
				break;
			
			case 'changeColor':
				if (!isset($userId)) return false;
				$this->db->where('id', $userId);
				if (!$this->db->update('users', ['color' => $color])) return false;
				return true;
				break;
			
				
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function fields($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && $args[1]) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'all':
				return isset($selectedFieldsKeys) ? arrRemoveByKeys($this->allFields, $selectedFieldsKeys) : $this->allFields;
				break;
			
			case 'selected':
				return isset($selectedFieldsKeys) ? arrGetByKeys($selectedFieldsKeys, $this->allFields) : [];
				break;
			
			case 'toThead':
				return isset($fields) ? arrGetByKeys($fields, $this->allFields) : [];
				break;
			
			case 'dataToFields':
				$data = [];
				if (in_array('statics', $fields)) {
					$data['statics'] = $this->admin_model->getStatics(true);
				}
				
				if (in_array('rank', $fields)) {
					$data['ranks'] = $this->_getRanks('name');
				}
				
				if (in_array('role', $fields)) {
					$data['roles'] = $this->admin_model->getRoles(true);
				}
				
				if (in_array('access', $fields)) {
					$data['access'] = $this->admin_model->getAccountsAccess(false, true);
				}
				
				
				return $data;
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function statics($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'all':
				$this->db->select('id, name, icon, group');
				if (!$statics = $this->_result($this->staticsTable)) return false;
				$statics = setArrKeyFromField($statics, 'id');
				$statics['nostatic'] = ['name' => 'Без статика'];
				if (!isset($selectedStatics)) return $statics;
				$selectedStaticsArr = array_fill_keys($selectedStatics, ['checked' => 1]);
				return array_replace_recursive($statics, $selectedStaticsArr);
				break;
			
			case 'tabs':
				if (!isset($selectedStatics) && !isset($searchStr)) return false;
				$noStatic = ['nostatic' => ['name' => 'Без статика']];
				
				if (isset($searchStr)) {
					$usersIds = $this->_searchUsers($searchStr, $searchField);
					$selectedStatics = $this->_getUsersStatics($usersIds);
					if (!$selectedStatics) return false;
					setAjaxHeader('current_static', reset($selectedStatics));
				}
				
				if (count($selectedStatics) == 1 && $selectedStatics[0] == 'nostatic') {
					return [
						'statics' 	=> $noStatic,
						'current' 	=> 'nostatic'
					];
				}
				
				
				$hasNoStatic = !!(in_array('nostatic', $selectedStatics) ? array_splice($selectedStatics, array_search('nostatic', $selectedStatics), 1) : false);
				$this->db->select('id, name, icon');
				$this->db->where_in('id', $selectedStatics);
				$statics = $this->_result($this->staticsTable);
				$statics = setArrKeyFromField($statics, 'id');
				
				$staticsPad = array_fill_keys($selectedStatics, ['name' => 'Статик удален']);
				$statics = array_replace($staticsPad, $statics);
				
				if ($hasNoStatic) $statics = array_replace_recursive($statics, $noStatic);
				
				return [
					'statics' 	=> $statics,
					'current' 	=> reset($selectedStatics) ?: null
				];
				break;
			
			case 'user':
				if (!isset($userId)) return false;
				$statics = $this->_getStatics();
				
				$this->db->select('static_id, IF(static_id, 1, 0) AS checked, lider, main');
				$this->db->where('user_id', $userId);
				if ($userStatics = $this->_result($this->usersStaticsTable)) {
					$userStatics = setArrKeyFromField($userStatics, 'static_id');
					$statics = array_replace_recursive($statics, $userStatics);
				}
				return $statics;
				break;
			
			case 'set':
				if (!isset($userId) ||!isset($staticId)) return false;
				$this->db->where(['user_id' => $userId, 'static_id' => $staticId]);
				
				if (isset($stat)) { // удалить или добавить статик
					if ($stat == 0) {
						$this->db->delete($this->usersStaticsTable);
						return true;
					} elseif ($stat == 1) {
						if ($this->db->count_all_results($this->usersStaticsTable) > 0) return false;
						return $this->db->insert($this->usersStaticsTable, ['user_id' => $userId, 'static_id' => $staticId]);
					}
					
				} elseif (isset($lider) || isset($main)) {
					$field = isset($lider) ? 'lider' : (isset($main) ? 'main' : '');
					$value = isset($lider) ? $lider : $main;
					if ($this->db->count_all_results($this->usersStaticsTable) > 0) {
						
						if (isset($main)) {
							$this->db->where('user_id', $userId);
							$this->db->update($this->usersStaticsTable, ['main' => 0]);
						}
						
						$this->db->where(['user_id' => $userId, 'static_id' => $staticId]);
						return $this->db->update($this->usersStaticsTable, [$field => $value]);
					} else {
						return $this->db->insert($this->usersStaticsTable, ['user_id' => $userId, 'static_id' => $staticId, $field => $value]);
					}
				}
				break;
				
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function classes($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'user':
				if (!isset($userId)) return false;
				$classes = $this->_getClasses();
				
				$this->db->select('class_id, IF(class_id, 1, 0) AS checked, mentor');
				$this->db->where('user_id', $userId);
				if ($userClasses = $this->_result($this->usersClassesTable)) {
					$userClasses = setArrKeyFromField($userClasses, 'class_id');
					$classes = array_replace_recursive($classes, $userClasses);
				}
				return $classes;
				break;
			
			case 'set':
				if (!isset($userId) ||!isset($classId)) return false;
				$this->db->where(['user_id' => $userId, 'class_id' => $classId]);
				
				if (isset($stat)) { // удалить или добавить класс
					if ($stat == 0) {
						$this->db->delete($this->usersClassesTable);
						return true;
					} elseif ($stat == 1) {
						if ($this->db->count_all_results($this->usersClassesTable) > 0) return false;
						return $this->db->insert($this->usersClassesTable, ['user_id' => $userId, 'class_id' => $classId]);
					}
					
				} elseif (isset($mentor)) {
					if ($this->db->count_all_results($this->usersClassesTable) > 0) {
						$this->db->where(['user_id' => $userId, 'class_id' => $classId]);
						return $this->db->update($this->usersClassesTable, ['mentor' => $mentor]);
					} else {
						return $this->db->insert($this->usersClassesTable, ['user_id' => $userId, 'class_id' => $classId, 'mentor' => $mentor]);
					}
				}
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function ranks($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'list':
				$ranksList = $this->_getRanks('id, name');
				$checkedRanks = isset($checkedRanks) ? array_fill_keys($checkedRanks, ['checked' => 1]) : [];
				
				$data['all_disabled'] = count($ranksList) == count($checkedRanks);
				$data['none_disabled'] = count($checkedRanks) == 0;
				$data['ranks'] = array_replace_recursive($ranksList, $checkedRanks);
				
				return $data;
				break;
			
			case 'set':
				$ranksList = $this->_getRanks('name, period');
				$userStage = $this->_getUserStage($userId);
				$setToStage = $ranksList[$newRank]['period'] - $userStage['summ'];
				$updateStage = $userStage['stage'] + $setToStage;
				
				$this->db->where('id', $userId);
				$this->db->update('users', ['stage' => $updateStage, 'rank' => $newRank]);
				$this->load->model('account_model');
				
				return [
					'rank' 	=> $ranksList[$newRank]['name'],
					'next' 	=> $this->account_model->getNextRankData($userId),
					'stage'	=> $updateStage
				];
				break;
			
			case 'update':
				$ranksList = $this->_getRanks('name, period');
				$userStage = $this->_getUserStage($userId);
				$userRank = $this->_getUserRank($userId);
				
				$updateUserRank = [];
				foreach ($ranksList as $rank) {
					$nexRank = next($ranksList) ?: false;
					if (($userStage['summ'] >= $rank['period'] && ($nexRank && $userStage['summ'] < $nexRank['period']) && $rank['id'] != $userRank) || ($userStage['summ'] >= $rank['period'] && !$nexRank && $rank['id'] != $userRank)) {
						$updateUserRank = ['rank' => $rank['id']];
					}
				}
				
				if ($updateUserRank) {
					$this->db->where('id', $userId);
					$this->db->update('users', $updateUserRank);
				}
				
				$this->load->model('account_model');
				return [
					'rank' 		=> $updateUserRank ? $ranksList[$updateUserRank['rank']]['name'] : $ranksList[$userRank]['name'],
					'next' 		=> $this->account_model->getNextRankData($userId),
					'updated' 	=> !!$updateUserRank
				];
				break;
			
			
			default: break; // no action
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function userinfo($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'get':
				if (!isset($userId)) return false;
				
				$this->db->select('u.nickname, u.avatar, u.deposit, u.rank, u.payment, '.$this->groupConcat('us.static_id', 'us.static_id:static,us.lider:lider,us.main:main', 'statics'));
				$this->db->join($this->usersStaticsTable.' us', 'u.id = us.user_id');
				$this->db->where('u.id', $userId);
				$this->db->group_by('u.id');
				if (!$userData = $this->_row($this->usersTable.' u')) return false;
				
				$this->load->model(['wallet_model' => 'wallet', 'account_model' => 'account']);
				$ranks = $this->_getRanks('name');
				
				$currentRank = arrTakeItem($userData, 'rank');
				$userData['rank'] = $this->account->getNextRankData($userId);
				$userData['rank']['current_rank'] = $ranks[$currentRank];
				
				$userStatics = setArrKeyFromField(json_decode($userData['statics'], true), 'static');
				$statics = $this->admin_model->getStatics(false, array_keys($userStatics));
				$userData['statics'] = array_replace_recursive($userStatics, $statics);
				
				
				$userData['balance'] = $this->wallet->getUserHistory($userId);
				$userData['current'] = $this->wallet->getUserBalance($userId);
				
				$visits = $this->account->getVisitsCoeffs(['period_id' => 113, 'static_id' => 1]);
				$coeffs = array_column($visits['coeffs'], 'rate_summ');
				$maxCoeff = max($coeffs);
				$userCoeff = isset($visits['coeffs'][$userId]) ? $visits['coeffs'][$userId]['rate_summ'] : false;
				$visitPercent = $userCoeff ? (100 / $maxCoeff) * $userCoeff : null;
				$userData['visits'] = $visitPercent;
				
				
				return $userData;
				break;
			
			case 'changeDeposit':
				$this->db->where('id', $userId);
				return $this->db->update('users', ['deposit' => $deposit]);
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------- Приватные методы
	
	
	
	
	/**
	 * Сгенерировать SQL select строку с полями
	 * @param массив полей
	 * @param обрезать запятую в начале строки
	 * @return 
	 */
	private function _getSqlFields($fields = false, $trim = false) {
		if (!$fields) return false;
		$sqlFields = '';
		foreach ($fields as $field) {
			if (!isset($this->usersFieldsSql[$field])) continue;
			$sqlFields .= ', '.$this->usersFieldsSql[$field];
		}
		if ($trim) return ltrim($sqlFields, ', ');
		return $sqlFields;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _searchUsers($searchStr = false, $searchField = false) {
		$this->db->select('id');
		$this->db->like($searchField, $searchStr, 'after');
		if (!$users = $this->_result($this->usersTable)) return false;
		return array_column($users, 'id');
		
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getUserStage($userId = false) {
		if (!$userId) return false;
		$this->db->select('reg_date, stage');
		$this->db->where('id', $userId);
		if (!$userData = $this->_row('users')) return false;
		
		return [
			'stage'	=> $userData['stage'],
			'summ'	=> floor((time() - $userData['reg_date']) / 86400) + $userData['stage']
		];
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getUserRank($userId = false) {
		if (!$userId) return false;
		$this->db->select('rank');
		$this->db->where('id', $userId);
		if (!$userRank = $this->_row('users', 'rank')) return false;
		return $userRank;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getUsersStatics($usersIds = false) {
		if (!$usersIds) return false;
		$noStatic = ['nostatic' => ['name' => 'Без статика']];
		
		$this->db->select('user_id, static_id');
		$this->db->where_in('user_id', $usersIds);
		$this->db->where('main', 1);
		if (!$result = $this->_result($this->usersStaticsTable)) return ['nostatic'];
		
		$usersStaticsIds = array_column($result, 'user_id');
		$statics = array_unique(array_column($result, 'static_id'));
		
		if (array_diff($usersIds, $usersStaticsIds)) array_replace($statics, $noStatic);
		return $statics;
	}
	
	
	
	
	
	
	/**
	 * Получить ID статиков по найденным участникам
	 * @param Поисковая строка
	 * @param По какому полю ищем
	 * @return массив ID статиков
	 */
	private function _getStaticsByFindedUsers($searchStr = false, $searchField = false) {
		if (!$searchStr || !$searchField) return false;
		$this->db->select('us.static_id');
		$this->db->join($this->usersTable.' u', 'u.id = us.user_id', 'LEFT OUTER');
		$this->db->where('us.main', 1);
		$this->db->like('u.'.$searchField, $searchStr, 'after');
		if (!$statics = $this->_result($this->usersStaticsTable.' us')) return false;
		//toLog($statics);
		return array_column($statics, 'static_id');
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getStatics() {
		$this->db->select('id, name, icon');
		if (!$statics = $this->_result($this->staticsTable)) return false;
		return setArrKeyFromField($statics, 'id');
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getClasses() {
		$this->db->select('id, name');
		if (!$classes = $this->_result($this->classesTable)) return false;
		return setArrKeyFromField($classes, 'id');
	}
	
	
	
	
	
	/**
	 * Получить список званий
	 * @param веернуть поля (если задать одно поле то вернет [ID => заданное поле]) По-умолчанию вернет все поля
	 * @return array
	 */
	private function _getRanks($fields = null) {
		if ($fields && is_string($fields)) $fields = preg_split("/[\s,]+/", $fields);
		$this->db->order_by('period', 'ASC');
		
		$this->db->select('id');
		if ($fields) $this->db->select(implode(', ', $fields));
		if (!$ranks = $this->_result('ranks')) return false;
		
		if ($fields && in_array('coefficient', $fields)) {
			$data = [];
			foreach ($ranks as $item) {
				$item['coefficient'] = json_decode($item['coefficient'], true);
				$data[$item['id']] = $item;
			}
			return $data;
		}
		
		if (count($fields) == 1) return setArrKeyFromField($ranks, 'id', reset($fields)); 
		return setArrKeyFromField($ranks, 'id', true);
	}
	
	
	
	
	
	
}