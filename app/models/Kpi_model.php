<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Kpi_model extends MY_Model {
	
	private $kpiPeriodsTable = 'kpi_periods';
	private $kpiTasksCustomTable = 'kpi_tasks_custom';
	private $kpiTasksPersonagesTable = 'kpi_tasks_personages';
	private $kpiPlanFieldsTable = 'kpi_plan_fields';
	private $kpiPlanPersonagesTable = 'kpi_plan_personages';
	private $kpiAmountsTable = 'kpi_amounts';
	private $kpiProgressCustomTable = 'kpi_progress_custom';
	private $kpiProgressPersonagesTable = 'kpi_progress_personages';
	private $kpiReportsTable = 'kpi_reports';
	private $kpiReportsBonusDoneTable = 'kpi_reports_bonus_done';
	private $kpiReportsBonusDataTable = 'kpi_reports_bonus_data';
	private $kpiReportsDataTable = 'kpi_reports_data';
	private $kpiReportsPlanesTable = 'kpi_reports_planes';
	private $kpiTemplatesTable = 'kpi_templates_titles';
	private $kpiTemplatesDataTable = 'kpi_templates_data';
	private $kpiUsersStaticsTable = 'kpi_users_statics';
	
	private $kpiPeriodsPart = 4;
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	/**
	 * Получить список KPI периодов
	 * @param 
	 * @return 
	*/
	public function getPeriods($periodsIds = false, $offset = false) {
		if ($periodsIds) $this->db->where_in('id', $periodsIds);
		if ($offset !== false) $this->db->limit($this->kpiPeriodsPart, ($offset * $this->kpiPeriodsPart));
		$this->db->order_by('id', 'DESC');
		
		if (!$result = $this->_resultWithCount($this->kpiPeriodsTable)) return false;
		$periodsData = [];
		foreach ($result['items'] as $item) {
			if (!isset($item['statics'])) continue;
			$item['statics'] = json_decode($item['statics'], true);
			$periodsData[] = $item;
		}
		$result['items'] = $periodsData;
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getPeriod($periodId = false, $returnField = false) {
		if (!$periodId) return false;
		$this->db->where('id', $periodId);
		$periodData = $this->_row($this->kpiPeriodsTable, $returnField);
		if ($returnField) return $periodData;
		if (isset($periodData['statics'])) $periodData['statics'] = json_decode($periodData['statics'], true);
		if (isset($periodData['fields'])) $periodData['fields'] = json_decode($periodData['fields'], true);
		if (isset($periodData['custom_fields'])) $periodData['custom_fields'] = json_decode($periodData['custom_fields'], true);
		if (isset($periodData['scores'])) $periodData['scores'] = json_decode($periodData['scores'], true);
		return $periodData;
	}
	
	
	
	/**
	 * Получить данные активного периода
	 * @param вернуть конкретное поле
	 * @return 
	*/
	public function getActivePeriod($returnField = false) {
		if ($returnField) $this->db->select($returnField);
		$this->db->where('active', 1);
		if (!$periodData = $this->_row($this->kpiPeriodsTable)) return false;
		
		if ($returnField) return !isJSON($periodData) ? json_decode($returnField, true) : $returnField;
		
		if (isset($periodData['statics'])) $periodData['statics'] = json_decode($periodData['statics'], true);
		if (isset($periodData['fields'])) $periodData['fields'] = json_decode($periodData['fields'], true);
		if (isset($periodData['custom_fields'])) $periodData['custom_fields'] = json_decode($periodData['custom_fields'], true);
		if (isset($periodData['scores'])) $periodData['scores'] = json_decode($periodData['scores'], true);
		
		return $periodData;
	}
	
	
	
	
	/**
	 * Получить список кастомных полей заданного периода
	 * @param 
	 * @return 
	*/
	public function getPeriodCustomFields($customFields = false) {
		if (!$customFields) return false;
		$tasks = array_column($customFields, 'custom_task_id');
		$this->db->select('id, task, type');
		$this->db->where_in('id', $tasks);
		if (!$tasksData = $this->_result($this->kpiTasksCustomTable)) return false;
		$tasksData = setArrKeyFromField($tasksData, 'id');
		
		$customFieldsData = [];
		foreach ($customFields as $field) {
			$customFieldsData[$field['name']] = [
				'task' => $tasksData[$field['custom_task_id']]['task'],
				'type' => $tasksData[$field['custom_task_id']]['type'],
			];
		}
		return $customFieldsData ?: false;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function addPeriod($data = false) {
		if (!$data) return false;
		$data['date_start'] = strtotime($data['date_start']);
		$data['date_end'] = strtotime($data['date_end']);
		$data['statics'] = json_encode($data['statics']);
		if (isset($data['scores'])) $data['scores'] = json_encode($data['scores']);
		if (isset($data['fields'])) $data['fields'] = json_encode(array_filter($data['fields']));
		if (isset($data['custom_fields'])) $data['custom_fields'] = json_encode(array_filter($data['custom_fields']));
		
		if (!$this->db->insert($this->kpiPeriodsTable, $data)) return false;
		$periodId = $this->db->insert_id();
		
		if (!$this->addUsersStatics($periodId, $data['statics'])) return false;
		
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * Активировать KPI период
	 * @param 
	 * @return 
	*/
	public function activatePeriod($periodId = false, $stat = null) {
		if (!$periodId) return false;
		$this->db->update($this->kpiPeriodsTable, ['active' => 0]);
		$this->db->where('id', $periodId);
		return $this->db->update($this->kpiPeriodsTable, ['active' => 1]);
	}
	
	
	
	
	/**
	 * Опубликовать KPI период
	 * @param 
	 * @return 
	*/
	public function publishPeriod($periodId = false, $stat = null) {
		if (!$periodId) return false;
		$this->db->update($this->kpiPeriodsTable, ['published' => 0]);
		$this->db->where('id', $periodId);
		return $this->db->update($this->kpiPeriodsTable, ['published' => 1]);
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function removeKpiPeriod($periodId = false) {
		if (!$periodId) return false;
		
		$this->db->where('period_id', $periodId);
		$this->db->delete($this->kpiPlanFieldsTable);
		
		$this->db->where('period_id', $periodId);
		$this->db->delete($this->kpiPlanPersonagesTable);
		
		$this->db->where('period_id', $periodId);
		$this->db->delete($this->kpiProgressCustomTable);
		
		$this->db->where('period_id', $periodId);
		$this->db->delete($this->kpiProgressPersonagesTable);
		
		$this->db->where('id', $periodId);
		$this->db->delete($this->kpiPeriodsTable);
		
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- perconages tasks
	
	/**
	 * @param 
	 * @return 
	 */
	public function addUsersStatics($periodId = false, $staticsIds = false) {
		if (!$periodId || !$staticsIds) return false;
		$staticsIds = json_decode($staticsIds, true);
		
		$this->db->select('static_id, '.$this->groupConcatValue(false, 'user_id', true));
		$this->db->where_in('static_id', $staticsIds);
		$this->db->group_by('static_id');
		if (!$result = $this->_result('users_statics')) return false;
		
		$dataToTable = [];
		foreach ($result as $row) {
			$dataToTable[] = [
				'period_id' => $periodId,
				'static_id' => $row['static_id'],
				'users' 	=> $row['user_id'],
			];
		}
		
		if (!$dataToTable) return false;
		$this->db->insert_batch($this->kpiUsersStaticsTable, $dataToTable);
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return [user => static]
	 */
	public function getUsersStatics($periodId = false) {
		if (!$periodId) return false;
		$this->db->where('period_id', $periodId);
		if (!$result = $this->_result($this->kpiUsersStaticsTable)) return false;
		
		$data = [];
		foreach ($result as $row) {
			$users = json_decode($row['users'], true);
			$arr = array_combine($users, array_fill(0, count($users), $row['static_id']));
			$data = array_replace($data, $arr);
		}
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- perconages tasks
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getPersonagesTasks($tasksIds = false) {
		if ($tasksIds) $this->db->where_in('id', $tasksIds);
		$this->db->order_by('_sort', 'ASC');
		if (!$result = $this->_resultWithCount($this->kpiTasksPersonagesTable)) return false;
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function saveTask($data = false) {
		if (!$data) return false;
		if (!$this->db->insert($this->kpiTasksPersonagesTable, $data)) return false;
		return $this->db->insert_id();
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function updateTask($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update($this->kpiTasksPersonagesTable, $fields)) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function removeTask($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->kpiTasksPersonagesTable)) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * Получить полный список задач для персонажей
	 * @param 
	 * @return 
	*/
	public function getTasks() {
		$this->db->order_by('_sort', 'ASC');
		if (!$tasks = $this->_result($this->kpiTasksPersonagesTable)) return false;
		$tasks = setArrKeyFromField($tasks, 'id', true);
		return $tasks;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- custom tasks
	
	/**
	 * @param 
	 * @return 
	*/
	public function getCustomTasks($periodFields = false) {
		if ($periodFields) {
			$customTasksIds = array_column($periodFields, 'custom_task_id');
			$this->db->where_in('id', $customTasksIds);
		}
		$this->db->order_by('_sort', 'ASC');
		if (!$result = $this->_resultWithCount($this->kpiTasksCustomTable)) return false;
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getCustomTasksToForm($periodFields = false) {
		if ($periodFields) {
			$customTasksIds = array_column($periodFields, 'custom_task_id');
			$this->db->where_in('id', $customTasksIds);
		}
		if (!$result = $this->_result($this->kpiTasksCustomTable)) return false;
		$result = setArrKeyFromField($result, 'id');
		return $result;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function saveCustomTask($data = false) {
		if (!$data) return false;
		if (!$this->db->insert($this->kpiTasksCustomTable, $data)) return false;
		return $this->db->insert_id();
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function updateCustomTask($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update($this->kpiTasksCustomTable, $fields)) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function removeCustomTask($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->kpiTasksCustomTable)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- plan
	
	
	
	
	/**
	 * Получить форму для заполнения значений плана
	 * @param Данные периода
	 * @return 
	*/
	public function getPlanForm($periodData = false, $search = null) {
		if (!$periodData) return false;
		$this->load->model('users_model', 'users');
		$personagesField = is_array($periodData['fields']) && in_array('personages', $periodData['fields']);
		
		$params = ['where' => ['us.main' => 1, 'u.deleted' => 0], 'where_in' => ['field' => 'us.static_id', 'values' => $periodData['statics']], 'fields' => 'nickname avatar static rank'];
		if ($search) {
			$params['like'] = [
				'field' => 'u.nickname',
				'value' => $search,
				'placed' => 'both'
			];
		}
		
		if (!$users = $this->users->getUsers($params)) exit('');
		
		if ($personagesField) $usersTasks = $this->getUsersTasks($periodData['id']);
		
		$usersParams = $this->getUsersParams($periodData['id']);
		
		
		$usersData = [];
		foreach ($users as $userId => $userData) {
			$static = arrTakeItem($userData, 'static');
			if ($personagesField) $userData['tasks'] = isset($usersTasks[$userId]) ? $usersTasks[$userId] : null;
			$userData['params'] = isset($usersParams[$userId]) ? $usersParams[$userId] : null;
			$usersData[$static][$userId] = $userData;
		}
		return $usersData;
	}
	
	
	
	
	
	/**
	 * Сохрание измененное значение параметра формы плана
	 * @param 
	 * @return 
	*/
	public function saveFormParam($periodId = false, $userId = false, $param = false, $value = null) {
		if (!$periodId || !$userId || !$param || is_null($value)) return false;
		$this->db->where(['period_id' => $periodId, 'user_id' => $userId]);
		$data = $this->_row($this->kpiPlanFieldsTable);
		
		if ($data) {
			$this->db->where(['period_id' => $periodId, 'user_id' => $userId]);
			return $this->db->update($this->kpiPlanFieldsTable, [$param => $value]);
		} 
		
		$insertStat = $this->db->insert($this->kpiPlanFieldsTable, [
			'period_id' => $periodId,
			'user_id'	=> $userId,
			$param 		=> $value
		]);
		return $insertStat;
	}
	
	
	
	
	
	
	/**
	 * Сохрание измененное значение кастомного параметра формы плана
	 * @param 
	 * @return 
	*/
	public function saveCustomFormParam($periodId = false, $userId = false, $field = false, $value = null) {
		if (!$periodId || !$userId || !$field || is_null($value)) return false;
		$this->db->where(['period_id' => $periodId, 'user_id' => $userId]);
		$row = $this->_row($this->kpiPlanFieldsTable);

		if ($row) {
			$customFields = json_decode($row['custom_fields'], true);
			$customFields[$field] = $value;
			$customFields = json_encode($customFields);
			
			$this->db->where(['period_id' => $periodId, 'user_id' => $userId]);
			return $this->db->update($this->kpiPlanFieldsTable, ['custom_fields' => $customFields]);
		} 
		
		$insertStat = $this->db->insert($this->kpiPlanFieldsTable, [
			'period_id'		=> $periodId,
			'user_id'		=> $userId,
			'custom_fields'	=> json_encode([$field => $value])
		]);
		return $insertStat;
	}
	
	
	
	
	
	
	
	/**
	 * Получить список параметров участников для формы
	 * @param ID периода
	 * @param ID участника
	 * @return [user_id => [visits, fine]]
	*/
	public function getUsersParams($periodId = false, $userId = false) {
		if (!$periodId) return false;
		
		$periodData = $this->getPeriod($periodId);
		$params = ['where' => ['us.main' => 1, 'u.deleted' => 0], 'where_in' => ['field' => 'us.static_id', 'values' => $periodData['statics']], 'fields' => 'id'];
		if (!$users = $this->users->getUsers($params)) exit('');
		
		$usersData = [];
		foreach ($users as $uid) {
			$usersData[$uid] = [
				'user_id'		=> $uid,
            	'visits'		=> null,
            	'fine'			=> null,
            	'custom_fields'	=> null
			];
		}
		
		$this->db->select('user_id, visits, fine, custom_fields');
		$this->db->where('period_id', $periodId);
		if ($userId) $this->db->where('user_id', $userId);
		if (!$tableData = $this->_result($this->kpiPlanFieldsTable)) return false;
		$tableData = setArrKeyFromField($tableData, 'user_id', true);
		$tableData = array_replace_recursive($usersData, $tableData);
		
		
		if ($periodCustomFields = $this->getPeriod($periodId, 'custom_fields')) {
			$periodCustomFields = json_decode($periodCustomFields, true);
			$periodCustomFields = array_column($periodCustomFields, 'name');
			$periodCustomFields = array_combine(array_keys(array_flip($periodCustomFields)), array_fill(0, count($periodCustomFields), null));
		}
		
		$usersParams = [];
		foreach ($tableData as $item) {
			$userId = arrTakeItem($item, 'user_id');
			$customFields = (isset($item['custom_fields']) && isJSON($item['custom_fields'])) ? json_decode($item['custom_fields'], true) : [];
			if ($periodCustomFields) $item['custom_fields'] = array_replace($periodCustomFields, $customFields);
			$usersParams[$userId] = $item;
		}
		
		return $usersParams;
	}
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	/**
	 * Получить список задач для участника
	 * @param 
	 * @return 
	*/
	public function getUsersTasks($periodId = false, $userId = false) {
		if (!$periodId) return false;
		$this->db->select('ut.task_id, ut.user_id, ut.personage_id, pt.task, ut.type, ut.repeats');
		$this->db->join($this->kpiTasksPersonagesTable.' pt', 'pt.id = ut.task_id', 'LEFT OUTER');
		if ($periodId) $this->db->where('period_id', $periodId);
		if ($userId) $this->db->where('user_id', $userId);
		$this->db->order_by('pt._sort', 'ASC');
		if (!$tasksList = $this->_result($this->kpiPlanPersonagesTable.' ut')) return false;
		
		$tasksData = [];
		foreach ($tasksList as $row) {
			$userId = arrTakeItem($row, 'user_id');
			$personageId = arrTakeItem($row, 'personage_id');
			$taskId = arrTakeItem($row, 'task_id');
			$type = arrTakeItem($row, 'type');
			$tasksData[$userId][$personageId][$type][$taskId] = $row;
		}
		
		return $tasksData;
	}
	
	
	
	
	
	
	
	/**
	 * Получить задачи персонажа
	 * @param ID периода
	 * @param ID персонажа
	 * @return 
	*/
	public function getPersonageTasks($periodId = false, $personageId = false) {
		if (!$periodId || !$personageId) return false;
		$this->db->select('task_id, type, repeats');

		if ($periodId) $this->db->where('period_id', $periodId);
		if ($personageId) $this->db->where('personage_id', $personageId);
		if (!$tasksList = $this->_result($this->kpiPlanPersonagesTable)) return false;
		$tasksData = [];
		foreach ($tasksList as $row) {
			$tasksData[$row['type']][$row['task_id']] = $row['repeats'];
		}
		return $tasksData;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function saveTasks($periodId = false, $userId = false, $personageId = false, $tasks = false) {
		if (!$periodId || !$userId || !$personageId) return false;
		
		$this->db->where(['period_id' => $periodId, 'user_id' => $userId, 'personage_id' => $personageId]);
		$tasksList = $this->_result($this->kpiPlanPersonagesTable);
		$tableTasksIds = $tasksList ?  array_column($tasksList, 'task_id') : [];
		
		$this->db->where(['period_id' => $periodId, 'user_id' => $userId, 'personage_id' => $personageId]);
		if (!$this->db->delete($this->kpiPlanPersonagesTable)) return false;
		if (!$tasks) return true;
									
		$dataToTable = [];
		foreach ($tasks as $task) {
			if (in_array($task['task_id'], $tableTasksIds)) unset($tableTasksIds[array_search($task['task_id'], $tableTasksIds)]);
			
			$dataToTable[] = [
				'period_id'		=> $periodId,
				'user_id'		=> $userId,
				'personage_id'	=> $personageId,
				'task_id'		=> $task['task_id'],
				'type'			=> $task['type'],
				'repeats'		=> $task['repeats']
			];
		}
		
		if ($dataToTable) $this->db->insert_batch($this->kpiPlanPersonagesTable, $dataToTable);
		
		if ($tableTasksIds) $this->removeProgressTasks($periodId, $userId, $personageId, $tableTasksIds);
		
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- progress
	
	
	
	
	
	
	
	
	/**
	 * Получить форму для заполнения достижений
	 * @param данные активного периода
	 * @return 
	*/
	public function getProgressForm($activePeriodData = false, $search = null) {
		if (!$activePeriodData) return false;
		
		if (!$formData = $this->getPlanForm($activePeriodData, $search)) return false;
		$fines = $this->_getUsersFines($activePeriodData['report_period']);
		$koeffs = $this->_getUsersVisits($activePeriodData['report_period']);
		$customFieldsData = $this->_getCustomFieldsData($activePeriodData['id']);
		
		foreach ($formData as $staticId => $users) foreach ($users as $userId => $userData) {
			if (isset($userData['params']['visits'])) {
				$formData[$staticId][$userId]['visits'] = [
					'need' => $userData['params']['visits'],
					'fact' => isset($koeffs[$userId]) ? $koeffs[$userId] : null
				];
			}
				
			if ($userData['params']['fine']) {
				$formData[$staticId][$userId]['fine'] = [
					'need' => $userData['params']['fine'],
					'fact' => isset($fines[$userId]) ? $fines[$userId] : null
				];
			}
			
			if ($planCustomFields = $userData['params']['custom_fields']) {
				foreach ($planCustomFields as $field => $needValue) {
					$formData[$staticId][$userId]['custom_fields'][$field] = [
						'need' => $needValue,
						'fact' => isset($customFieldsData[$userId][$field]) ? $customFieldsData[$userId][$field] : null
					];
				}
			} elseif ($customFieldsData) {
				foreach ($customFieldsData as $userId => $customFields) foreach ($customFields as $field => $value) {
					$formData[$staticId][$userId]['custom_fields'][$field] = [
						'need' => 1,
						'fact' => $value
					];
				}
			}
			
			unset($formData[$staticId][$userId]['params']);
		}
		return $formData;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить форму для заполнения достижений
	 * @param данные активного периода
	 * @return 
	*/
	public function getUserProgressForm($periodData = false, $uId = null) {
		if (!$periodData) return false;
		
		if (!$formData = $this->getPlanForm($periodData)) return false;
		
		$fines = $this->_getUsersFines($periodData['report_period']);
		$koeffs = $this->_getUsersVisits($periodData['report_period']);
		$customFieldsData = $this->_getCustomFieldsData($periodData['id']);
		
		foreach ($formData as $staticId => $users) foreach ($users as $userId => $userData) {
			if ($userId == $uId) {
				if (isset($userData['params']['visits'])) {
					$formData[$staticId][$userId]['visits'] = [
						'need' => $userData['params']['visits'],
						'fact' => isset($koeffs[$userId]) ? $koeffs[$userId] : null
					];
				}
					
				if ($userData['params']['fine']) {
					$formData[$staticId][$userId]['fine'] = [
						'need' => $userData['params']['fine'],
						'fact' => isset($fines[$userId]) ? $fines[$userId] : null
					];
				}
				
				if ($planCustomFields = $userData['params']['custom_fields']) {
					foreach ($planCustomFields as $field => $needValue) {
						$formData[$staticId][$userId]['custom_fields'][$field] = [
							'need' => $needValue,
							'fact' => isset($customFieldsData[$userId][$field]) ? $customFieldsData[$userId][$field] : null
						];
					}
				}
				unset($formData[$staticId][$userId]['params']);
				return $formData[$staticId][$userId];
			}
			
		}
	}
	
	
	
	
	
	
	
	
	/**
	 * Сохранить выставленные данные
	 * @param Данные из формы
	 * @param ID активного периода
	 * @return 
	*/
	public function checkProgressTask($periodId = false, $data = false) {
		if (!$data || !$periodId) return false;
		
		$this->db->where([
			'period_id' 	=> $periodId,
			'user_id' 		=> $data['user_id'],
			'personage_id' 	=> $data['personage_id'],
			'task_id' 		=> $data['task_id'],
			'type' 			=> $data['type']
		]);
		$tableData = $this->_row($this->kpiProgressPersonagesTable);
		
		if ($tableData) {
			$this->db->where([
				'period_id' 	=> $periodId,
				'user_id' 		=> $data['user_id'],
				'personage_id' 	=> $data['personage_id'],
				'task_id' 		=> $data['task_id'],
				'type' 			=> $data['type']
			]);
			return $this->db->update($this->kpiProgressPersonagesTable, ['done' => $data['value']]);
		} 
		
		return $this->db->insert($this->kpiProgressPersonagesTable, [
			'period_id'		=> $periodId,
			'user_id'		=> $data['user_id'],
			'personage_id'	=> $data['personage_id'],
			'task_id'		=> $data['task_id'],
			'type'			=> $data['type'],
			'done'			=> $data['value']
		]);
	}
	
	
	
	
	
	
	/**
	 * Сохранить выставленные данные
	 * @param Данные из формы
	 * @param ID активного периода
	 * @return 
	*/
	public function checkProgressCustom($activePeriodId = false, $data = false) {
		if (!$data || !$activePeriodId) return false;
		
		$this->db->where(['period_id' => $activePeriodId, 'user_id' => $data['user_id'], 'field' => $data['field']]);
		$tableData = $this->_row($this->kpiProgressCustomTable);
		
		if ($tableData) {
			$this->db->where(['period_id' => $activePeriodId, 'user_id' => $data['user_id'], 'field' => $data['field']]);
			return $this->db->update($this->kpiProgressCustomTable, ['done' => $data['value']]);
		} 
		
		return $this->db->insert($this->kpiProgressCustomTable, [
			'period_id'	=> $activePeriodId,
			'user_id'	=> $data['user_id'],
			'field'		=> $data['field'],
			'done'		=> $data['value']
		]);
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить выставленные данные
	 * @param ID активного периода
	 * @param параметры (массив)
	 * @return array [user_id => [personage_id => [task_id => done]]]
	*/
	public function getProgressTasks($activePeriodId = false, $whereParams = false) {
		if (!$activePeriodId) return false;
		$this->db->where('period_id', $activePeriodId);
		if ($whereParams) $this->db->where($whereParams);
		if (!$data = $this->_result($this->kpiProgressPersonagesTable)) return false;
		$restructureData = [];
		foreach ($data as $item) {
			$restructureData[$item['user_id']][$item['personage_id']][$item['type']][$item['task_id']] = $item['done'];
		}
		return $restructureData;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function removeProgressTasks($periodId = false, $userId = false, $personageId = false, $tasksIds = false) {
		if (!$periodId || !$userId || !$personageId || !$tasksIds) return false;
		$this->db->where(['period_id' => $periodId, 'user_id' => $userId, 'personage_id' => $personageId]);
		$this->db->where_in('task_id', $tasksIds);
		$this->db->delete($this->kpiProgressPersonagesTable);
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить суммы к выплате
	 * @param 
	 * @return 
	*/
	public function getAmounts() {
		if (!$result = $this->_result($this->kpiAmountsTable)) return false;
		$amountsData = [];
		foreach ($result as $item) {
			$amountsData[$item['static_id']][$item['rank_id']][$item['payout_type']] = $item['amount'];
		}
		return $amountsData;
	}
	
	
	
	
	
	/**
	 * Задать сумму к выплате
	 * @param 
	 * @return 
	*/
	public function setAmount($data = false) {
		if (!$data) return false;
		
		$this->db->where(['static_id' => $data['static_id'], 'rank_id' => $data['rank_id'], 'payout_type' => $data['payout_type']]);
		$tableData = $this->_row($this->kpiAmountsTable);
		
		if ($tableData) {
			$this->db->where(['static_id' => $data['static_id'], 'rank_id' => $data['rank_id'], 'payout_type' => $data['payout_type']]);
			return $this->db->update($this->kpiAmountsTable, ['amount' => $data['amount']]);
		} 
		
		return $this->db->insert($this->kpiAmountsTable, [
			'static_id'		=> $data['static_id'],
			'rank_id' 		=> $data['rank_id'],
			'amount'		=> $data['amount'],
			'payout_type'	=> $data['payout_type']
		]);
	}
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- statistics
	
	/**
	 * @param 
	 * @return 
	*/
	public function getPersonagesToStat($period = false, $type = 1) {
		$planPersonages = $this->_getPlanPersonages($period['id'], $type);
		$tasksPersonages = $this->_getTasksPersonages($period['id']);
		$progressPersonages = $this->_getProgressPersonages($period['id'], $type);
		
		$planPregressData = $progressPersonages ? array_replace_recursive($planPersonages, $progressPersonages) : $planPersonages;
		
		if ($planPregressData) {
			foreach ($planPregressData as $userId => $personages) foreach ($personages as $personageId => $tasks) foreach ($tasks as $taskId => $taskData) {
				//$planPregressData[$userId][$personageId][$taskId]['name'] = isset($tasksPersonages[$taskId]['task'])? $tasksPersonages[$taskId]['task'] : null;
				$planPregressData[$userId][$personageId][$taskId]['score'] = isset($tasksPersonages[$taskId]['score']) ? $tasksPersonages[$taskId]['score'] : null;
			}
		}
		
		return $planPregressData;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getFieldsToStat($period = false) {
		if (!$period) return false;
		
		$fine = $this->_getUsersFines($period['report_period']);
		$visits = $this->_getUsersVisits($period['report_period']);
		
		$customTasks = $this->_getCustomTasksToStat($period['custom_fields']);
		$customProgress = $this->_getCustomProgressToStat($period['id']);
		
		$this->db->where('period_id', $period['id']);
		if (!$result = $this->_result($this->kpiPlanFieldsTable)) return false;
		
		$planFieldsData = [];
		foreach ($result as $item) {
			
			if (isset($item['visits'])) {
				$planFieldsData[$item['user_id']]['visits'] = [
					'need' => $item['visits'],
					'fact' => isset($visits[$item['user_id']]) ? $visits[$item['user_id']] : 0
				];
			}
			
			if (isset($item['fine'])) {
				$planFieldsData[$item['user_id']]['fine'] = [
					'need' => $item['fine'],
					'fact' => isset($fine[$item['user_id']]) ? $fine[$item['user_id']] : 0
				];
			}
			
			$customFields = [];
			if ($item['custom_fields'] && (!$customFields = json_decode($item['custom_fields'], true))) {
				foreach ($customFields as $field => $need) $customFields[$field] = ['need' => $need];
			}
			
			$planFieldsData[$item['user_id']] = isset($planFieldsData[$item['user_id']]) ? array_merge((array)$planFieldsData[$item['user_id']], $customFields) : $customFields;
			$planFieldsData[$item['user_id']] = array_replace_recursive($planFieldsData[$item['user_id']], $customTasks);
			if (isset($customProgress[$item['user_id']])) $planFieldsData[$item['user_id']] = array_replace_recursive($planFieldsData[$item['user_id']], $customProgress[$item['user_id']]);
		}
		
		return $planFieldsData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- отчеты
	
	/**
	 * @param 
	 * @return 
	*/
	public function getReports() {
		$this->db->order_by('id', 'DESC');
		if (!$reports = $this->_result($this->kpiReportsTable)) return false;
		return $reports;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getReportInfo($reportId = false) {
		if (!$reportId) return false;
		$this->db->where('id', $reportId);
		if (!$data = $this->_row($this->kpiReportsTable)) return false;
		return $data;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getReport($reportId = false) {
		if (!$reportId) return false;
		
		$reportData = $this->_getReportData($reportId);
		$reportPlanes = $this->_getReportPlanes($reportId);
		
		$usersIds = [];
		foreach ($reportData as $stId => $users) $usersIds = array_merge($usersIds, array_keys($users));
		$this->load->model('users_model', 'users');
		$params = [
			'where' => ['us.main' => 1, 'u.deleted' => 0],
			'where_in' => ['field' => 'u.id', 'values' => $usersIds],
			'fields' => 'nickname avatar static rank'
		];
		if (!$usersData = $this->users->getUsers($params)) return false;
		
		foreach ($reportData as $staticId => $users) foreach ($users as $userId => $userData) {
			if (!isset($usersData[$userId])) continue;
			$reportData[$staticId][$userId]['nickname'] = $usersData[$userId]['nickname'];
			$reportData[$staticId][$userId]['avatar'] = $usersData[$userId]['avatar'];
			$reportData[$staticId][$userId]['rank'] = $usersData[$userId]['rank'];
			$reportData[$staticId][$userId]['static'] = $usersData[$userId]['static'];
			$reportData[$staticId][$userId]['periods'] = $reportPlanes[$staticId][$userId];
		}
		return $reportData;
	}
	
	
	
	// 1. в депозит ничего не отправлять, потому что это делается через выплаты
	// 2. номер заказа: KPI
	// 3. комментрий: название KPI плана и дата
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function saveReport($title = false, $report = false, $periods = false) {
		if (!$title || !$report) return false;
		
		if (!$reportId = $this->_saveReport($title, $periods)) return false;
		
		$reportData = []; $planes = []; $usersIds = [];
		foreach ($report as $staticId => $users) foreach ($users as $userId => $userData) {
			$usersIds[] = $userId;
			
			$reportData[] = [
				'report_id'		=> $reportId,
				'static_id'		=> $staticId,
				'user_id'		=> $userId,
				'payment'		=> $userData['payment'],
				'payout'		=> str_replace(',', '.', $userData['payout']),
				'nda'			=> $userData['nda']
			];
			
			foreach ($userData['planes'] as $planId => $planData) {
				$planes[] = [
					'report_id'	=> $reportId,
					'static_id'	=> $staticId,
					'user_id'	=> $userId,
					'plan_id'	=> $planId,
					'summ'		=> str_replace(',', '.', $planData['summ']),
					'persent'	=> str_replace(',', '.', $planData['persent']),
					'payout'	=> str_replace(',', '.', $planData['payout']),
				];
			}
		}
		
		
		$this->db->insert_batch($this->kpiReportsDataTable, $reportData);
		$this->db->insert_batch($this->kpiReportsPlanesTable, $planes);
		
		
		$this->load->model(['users_model' => 'users', 'reports_model' => 'reports']);
		$params = ['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'nickname avatar'];
		$usersData = $this->users->getUsers($params);
		
		$date = date('j', time()).' '.$this->monthes[date('n', time())].' '.date('Y', time()).' г.';
		
		$orders = []; $toWalletData = [];
		foreach ($reportData as $item) {	
			$orders[] = [
				'user_id' 		=> $item['user_id'],
				'nickname' 		=> $usersData[$item['user_id']]['nickname'],
				'avatar' 		=> $usersData[$item['user_id']]['avatar'],
				'payment' 		=> $item['payment'],
				'static' 		=> $item['static_id'],
				'order' 		=> 'KPI',
				'summ' 			=> $item['payout'],
				'to_deposit'	=> 0,
				'comment'		=> $title.' '.$date,
				'date' 			=> time()
			];
			
			if (!isset($toWalletData[$item['user_id']])) $toWalletData[$item['user_id']] = (float)$item['payout'];
			else $toWalletData[$item['user_id']] += (float)$item['payout'];	
		}	
		
		if (!$this->reports->insertUsersOrders($orders)) return false;
		
		$this->load->model('wallet_model');
		$this->wallet_model->setToWallet($toWalletData, 6, 'KPI', '+');
		
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function calcUserStatistics($periodId = false, $uId = false) {
		if (!$periodId || !$uId) return false;
		$this->load->model(['admin_model' => 'admin', 'users_model' => 'users']);
				
		$ndaCoeff = $this->admin->getSettings('nda_coeff');
		$ranks = $this->admin->getRanks();
		$ranksLiders = $this->admin->getRanksLiders();
		$amountsData = $this->getAmounts();
		
		$calcData = [];

		if (!$period = $this->getPeriod($periodId)) return false;
		
		$scoresPersonages = isset($period['scores']['personages']) ? (float)$period['scores']['personages'] : 0;
		$scoresVisits = isset($period['scores']['visits']) ? (float)$period['scores']['visits'] : 0;
		$scoresFine = isset($period['scores']['fine']) ? (float)$period['scores']['fine'] : 0;
		$scoresCustom = isset($period['scores']['customfields']) ? (float)$period['scores']['customfields'] : 0;
		
		$allScrores = $scoresPersonages + $scoresFine + $scoresCustom;
		$oneScorePercent = 100 / $allScrores;
		
		$scoresPersonagesPercent = $scoresPersonages ? round($scoresPersonages * $oneScorePercent, 3) : false; // макс. проц. активность на персонажах
		$scoresVisitsPercent = $scoresVisits ? round($scoresVisits * $oneScorePercent, 3) : false; // макс. проц. Посещаемость
		$scoresFinePercent = $scoresFine ? round($scoresFine * $oneScorePercent, 3) : false; // макс. проц. штрафы
		$scoresCustomPercent = $scoresCustom ? round($scoresCustom * $oneScorePercent, 3) : false; // макс. проц. доп. поля
		
		
		
		
		// ----------------------------------------------------------------------------------------
		$usersVisitsPercents = [];
		if ($usersFieldsData = $this->getFieldsToStat($period)) {
			
			foreach($usersFieldsData as $userId => $fields) {
				$visitsField = arrTakeItem($fields, 'visits');
				$fineField = arrTakeItem($fields, 'fine');
				
				if ($scoresVisitsPercent) {
					$visitsNeed = (isset($visitsField['need']) && $visitsField['need'] > 0) ? $visitsField['need'] : false;
					$visitsFact = isset($visitsField['fact']) ? $visitsField['fact'] : 0;
					
					$usersVisitsPercents[$userId] = ($visitsFact == 0 || $visitsNeed == 0) ? 0 : round($visitsFact / $visitsNeed, 3);
					
					
					/*if (!$visitsNeed) {
						$calcData[$userId]['visits'] = 0;
					} else {
						$donePercentVisits = $visitsNeed ? round(($visitsFact / $visitsNeed) * $scoresVisitsPercent, 3) : 0;
						$calcData[$userId]['visits'] = $donePercentVisits > $scoresVisitsPercent ? $scoresVisitsPercent : $donePercentVisits;
					}*/
				}
					
				if ($scoresFinePercent) {
					$fineNeed = (isset($fineField['need']) && $fineField['need'] > 0) ? $fineField['need'] : false;
					$fineFact = isset($fineField['fact']) ? $fineField['fact'] : 0;
					
					if (!$fineNeed) {
						$calcData[$userId]['fine'] = 0;
					} else {
						$fineIndex = ($i = -$fineNeed + $fineFact) > 0 ? $i  : 0;
						$calcIndex = (($fineNeed - $fineIndex) / $fineNeed) * $scoresFinePercent;
						$donePercentFine = $calcIndex < $scoresFinePercent ? $calcIndex : $scoresFinePercent;
						$calcData[$userId]['fine'] = $donePercentFine > 0 ? $donePercentFine : 0;
					}
				}
				
				
				//----------------------------------------- Кастомные поля
				$allCustomScrores = []; $doneCustomScores = [];
				if ($scoresCustomPercent) {
					foreach ($fields as $field => $fData) {
						$done = isset($fData['done']) ? $fData['done'] : 0;
						$need = $fData['type'] == 'koeff' ? $fData['need'] : 1;
						$score = $fData['score'];
						
						if (!isset($allCustomScrores[$userId])) $allCustomScrores[$userId] = ($need * $score);
						else $allCustomScrores[$userId] += ($need * $score);
						
						if (!isset($doneCustomScores[$userId])) $doneCustomScores[$userId] = ($done * $score);
						else $doneCustomScores[$userId] += ($done * $score);
					}
					
					foreach ($allCustomScrores as $userId => $scores) {
						$donePercentCustom = round(($doneCustomScores[$userId] / $scores) * $scoresCustomPercent, 3);
						$calcData[$userId]['custom'] = $donePercentCustom > $scoresCustomPercent ? $scoresCustomPercent : $donePercentCustom;
					}
				}
			}
		}
		
		
		
		
		// ----------------------------------------------------------------------------------------
		
		if ($scoresPersonagesPercent && ($usersPersonagesData = $this->getPersonagesToStat($period))) {
			$allScrores = []; $doneScores = [];
			foreach ($usersPersonagesData as $userId => $personages) foreach ($personages as $pId => $tasks) foreach ($tasks as $tId => $task) {
				if (!isset($task['repeats'])) continue;
				$done = isset($task['done']) ? $task['done'] : 0;
				$repeats = $task['repeats'];
				$score = $task['score'];
				
				if (!isset($allScrores[$userId])) $allScrores[$userId] = ($repeats * $score);
				else $allScrores[$userId] += ($repeats * $score);
				
				if (!isset($doneScores[$userId])) $doneScores[$userId] = ($done * $score);
				else $doneScores[$userId] += ($done * $score);
			}
			
			foreach ($allScrores as $userId => $scores) {
				$donePercentPersonages = round(($doneScores[$userId] / $scores) * $scoresPersonagesPercent, 3);
				$calcData[$userId]['personages'] = $donePercentPersonages > $scoresPersonagesPercent ? $scoresPersonagesPercent : $donePercentPersonages;
			}
			
			//суммируется общее кодичество баллов умноженное на кол-во повторний
			//и откуда какая задача выполнена те баллы и высчитываются
		}
		
		
		
		
		
		// ----------------------------------------------------------------------------------------
		
		$finalData = []; $payoutData = [];
		foreach ($calcData as $userId => $row) {
			$finalData[$userId] = array_sum($calcData[$userId]);
		}
		
		$userStatic = '';
		if ($finalData && ($usersIds = array_keys($finalData))) {
			$params = [
				'where' => ['us.main' => 1, 'u.deleted' => 0],
				'where_in' => ['field' => 'u.id', 'values' => $usersIds],
				'fields' => 'static rank rank_lider nda payment'
			];
			$users = $this->users->getUsers($params);
			
			if (!isset($finalData[$uId])) return false;
			$scores = $finalData[$uId];
			
			$userStatic = isset($users[$uId]['static']) ? $users[$uId]['static'] : 'Статик не задан';
			$userRank = isset($users[$uId]['rank']) ? $users[$uId]['rank'] : 'Звание не задано';
			$userRankLider = isset($users[$uId]['rank_lider']) && isset($ranksLiders[$users[$uId]['rank_lider']]) ? (float)$ranksLiders[$users[$uId]['rank_lider']]['coefficient'] : 1;
			
			$amount = isset($amountsData[$userStatic][$userRank][$period['payout_type']]) ? $amountsData[$userStatic][$userRank][$period['payout_type']] : 0;
			$payout = 0;
			
			if ($amount) {
				$payout = $amount ? (($amount / 100) * $scores) : 0;
				$payout = $payout * ($users[$uId]['nda'] ?: $ndaCoeff);
				$payout = $payout > $amount ? $amount : $payout;
			}
			
			
			$visitsCoeff = isset($usersVisitsPercents[$uId]) ? $usersVisitsPercents[$uId] : 0;
			
			if (!isset($payoutData[$userStatic][$uId])) {
				$payoutData[$userStatic][$uId] = [
					'rank'			=> $ranks[$userRank]['name'],
					'nda'			=> $users[$uId]['nda'] ? 1 : 0,
					'payment'		=> $users[$uId]['payment'],	
					'payout_all'	=> round($payout * $userRankLider * $visitsCoeff)
				];
			} else {
				$payoutData[$userStatic][$uId]['payout_all'] += round($payout * $userRankLider * $visitsCoeff);
			}
				
			
			
			$payoutData[$userStatic][$uId]['periods'][$periodId] = [
				'summ'		=> $amount,
				'persent'	=> round($scores * $visitsCoeff, 1),
				'payout'	=> round($payout * $userRankLider * $visitsCoeff),
			];
			
		}
			
		
		return isset($payoutData[$userStatic][$uId]['periods'][$periodId]) ? $payoutData[$userStatic][$uId]['periods'][$periodId] : false;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 
	 * @param 
	 * @return 
	*/
	public function removePersonages($personagesIds = false) {
		if (!$personagesIds) return false;
		$this->db->where_in('personage_id', $personagesIds);
		$this->db->delete($this->kpiPlanPersonagesTable);
		
		$this->db->where_in('personage_id', $personagesIds);
		$this->db->delete($this->kpiProgressPersonagesTable);
		return true;
	}
	
	
	
	
	
	
	/**
	 * Удалить из отчета удаленного персонажа
	 * @param 
	 * @return 
	*/
	public function removeDeletedPersonage($personageId = false) {
		if (!$personageId) return false;
		$this->db->where('personage_id', $personageId);
		if (!$this->db->delete($this->kpiPlanPersonagesTable)) {
			toLog('!!! Не удалось удалить персонажей из '.$this->kpiPlanPersonagesTable);
		}
		
		
		$this->db->where('personage_id', $personageId);
		if (!$this->db->delete($this->kpiProgressPersonagesTable)) {
			toLog('!!! Не удалось удалить персонажей из '.$this->kpiProgressPersonagesTable);
		}
		
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * Удалить из отчета всех удаленных персонажей
	 * @param 
	 * @return 
	*/
	public function clearDeletedPersonages() {
		$this->db->select('id');
		if (!$usersPersonages = $this->_result('users_personages')) return false;
		
		//$usersPersonages = array_column($usersPersonages, 'id');
		
		$usersPersonages = array_combine(array_column($usersPersonages, 'id'), array_fill(0, count($usersPersonages), null));
		
		
		
		/*echo '<pre>';
			print_r($usersPersonages);
		exit('</pre>');*/
		
		
		
		$this->db->select('personage_id, '.$this->groupConcatValue('id', 'id'));
		$this->db->group_by('personage_id');
		if (!$progressPersonages = $this->_result('kpi_progress_personages')) return false;
		$progressPersonages = setArrKeyFromField($progressPersonages, 'personage_id', 'id'); // [personage_id => ids]
		
		/*echo '<pre>';
			print_r($progressPersonages);
		exit('</pre>');*/
		
		
		
		$this->db->select('personage_id, '.$this->groupConcatValue('id', 'id'));
		$this->db->group_by('personage_id');
		if (!$planPersonages = $this->_result('kpi_plan_personages')) return false;
		$planPersonages = setArrKeyFromField($planPersonages, 'personage_id', 'id'); // [personage_id => ids]
		
		
		$planDiff = array_diff_key($planPersonages, $usersPersonages);
		//$progressDiff = array_diff_key($progressPersonages, $usersPersonages);
		
		
		echo count($usersPersonages);
		echo '<br>';
		echo count($planPersonages);
		echo '<br>';
		echo count($planDiff);
		
		echo '<pre>';
			print_r($planDiff);
		exit('</pre>');
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getBonusReportsPeriods() {
		$this->db->select('period_id');
		$this->db->group_by('period_id');
		if (!$periods = $this->_result($this->kpiReportsBonusDataTable)) return false;
		$periods = array_column($periods, 'period_id');
		
		$this->db->select('pt.id, pt.title, COUNT(rbd.period_id) AS done');
		$this->db->join($this->kpiReportsBonusDoneTable.' rbd', 'rbd.period_id = pt.id', 'LEFT OUTER');
		$this->db->where_in('pt.id', $periods);
		if (!$periodsData = $this->_result($this->kpiPeriodsTable.' pt')) return false;
		
		return $periodsData;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getBonusReport($periodId = false) {
		if (!$periodId) return false;
		$this->load->model(['admin_model' => 'admin', 'users_model' => 'users']);
		$this->db->where_in('period_id', $periodId);
		if (!$result = $this->_result($this->kpiReportsBonusDataTable)) return false;
		$usersIds = array_column($result, 'user_id');
		
		
		$params = [
			'where' => ['us.main' => 1, 'u.deleted' => 0],
			'where_in' => ['field' => 'u.id', 'values' => $usersIds],
			'fields' => 'nickname avatar static rank nda payment'
		];
		$users = $this->users->getUsers($params);
		
		
		$finalData = [];
		foreach ($result as $row) {
			$staticId = $users[$row['user_id']]['static'];
			$finalData[$staticId][$row['user_id']] = [
				'user_id' 		=> $row['user_id'],
				'nickname' 		=> $users[$row['user_id']]['nickname'],
				'avatar' 		=> $users[$row['user_id']]['avatar'],
				'nda'			=> $users[$row['user_id']]['nda'],
				'payment' 		=> $users[$row['user_id']]['payment'],
				'static' 		=> $staticId,
				'percents'		=> [
					'visits'		=> $row['visits'],
					'custom'		=> $row['custom'],
					'personages'	=> $row['personages'],
					'total'			=> $row['total']
				]
			];
		}
		
		return $finalData;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function saveBonusReport($periodId = false, $data = false) {
		if (!$periodId || !$data) return false;
		
		$this->db->where('period_id', $periodId);
		$this->db->delete($this->kpiReportsBonusDataTable);
		
		$date = time();
		foreach ($data as $k => $row) {
			$data[$k]['period_id'] = $periodId;
			$data[$k]['date'] = $date;
		}
		
		$this->db->insert_batch($this->kpiReportsBonusDataTable, $data);
		return true;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function sendUsersPercents($periodId = false) {
		if (!$periodId) return false;
		$this->db->select('user_id, total');
		$this->db->where('period_id', $periodId);
		if (!$bonusesData = $this->_result($this->kpiReportsBonusDataTable)) return false;
		$bonusesData = setArrKeyFromField($bonusesData, 'user_id', 'total');
		
		$usersPercents = $this->_getUsersBonusPercents();
		
		$insData = []; $upData = [];
		foreach ($bonusesData as $userId => $percents) {
			if (isset($usersPercents[$userId])) {
				$upData[] = [
					'user_id'	=> $userId,
					'percent' 	=> ($usersPercents[$userId] + $percents)
				];
			} else {
				$insData[] = [
					'user_id'	=> $userId,
					'percent' => $percents
				];
			}
		}
		
		if ($insData) {
			$this->db->insert_batch('users_bonus_percents', $insData);
		}
		
		if ($upData) {
			$this->db->update_batch('users_bonus_percents', $upData, 'user_id');
		}
		
		$this->db->insert($this->kpiReportsBonusDoneTable, ['period_id' => $periodId]);
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getTemplates($from = false) {
		if ($from === false) return false;
		if (!$result = $this->_result($this->kpiTemplatesTable)) return false;
		
		foreach ($result as $k => $row) {
			$activeData = json_decode($row['active'], true);
			$result[$k]['active'] = is_array($activeData) && in_array($from, $activeData);
		}
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getTemplateTitle($id = false) {
		if (!$id) return false;
		$this->db->select('title');
		$this->db->where('id', $id);
		if (!$templateTitle = $this->_row($this->kpiTemplatesTable, 'title')) return false;
		return $templateTitle;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getTemplateTasks($id = false) {
		if (!$id) return false;
		$this->db->select('task_id, repeats');
		$this->db->where('template_id', $id);
		if (!$templateData = $this->_result($this->kpiTemplatesDataTable)) return false;
		$templateData = setArrKeyfromField($templateData, 'task_id', 'repeats');
		return $templateData;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function activateTemplate($id = false, $from = false) {
		if (!$id || $from === false) return false;
		if (!$result = $this->_result($this->kpiTemplatesTable)) return false;
		
		$updateData = [];
		foreach ($result as $row) {
			$activeData = json_decode($row['active'], true) ?: [];
			$findIndex = array_search($from, $activeData);
			
			if ($findIndex !== false && $id != $row['id']) array_splice($activeData, $findIndex, 1);
			elseif ($findIndex === false && $id == $row['id']) array_push($activeData, $from);
			
			$row['active'] = $activeData ? json_encode($activeData) : null;
			$updateData[] = $row;
		}
		
		$this->db->update_batch($this->kpiTemplatesTable, $updateData, 'id');
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getActiveTemplate($from = false) {
		if ($from === false) return false;
		$this->db->select('id');
		$this->db->where($this->jsonSearch($from, 'active'));
		if (!$templateId = $this->_row($this->kpiTemplatesTable, 'id')) return false;
		

		$this->db->select('id, task_id, repeats');
		$this->db->where('template_id', $templateId);
		if (!$templateData = $this->_result($this->kpiTemplatesDataTable)) return false;
		
		$tasksData = [];
		foreach ($templateData as $item) {
			$id = arrTakeItem($item, 'id');
			$item['type'] = 1;
			$tasksData[$id] = $item;
		}
		return $tasksData;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function saveTemplate($title = false, $tasks = false) {
		if (!$title || !$tasks) return false;
		
		$this->db->insert($this->kpiTemplatesTable, ['title' => $title]);
		$templateId = $this->db->insert_id();
		
		$insTasksData = [];
		foreach ($tasks as $task) {
			$insTasksData[] = [
				'template_id'	=> $templateId,
				'task_id' 		=> $task['task_id'],
				'repeats'		=> $task['repeats']
			];
		}
		
		$this->db->insert_batch($this->kpiTemplatesDataTable, $insTasksData);
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function updateTemplate($id = false, $title = false, $tasks = false) {
		if (!$id || !$title || !$tasks) return false;
		
		$this->db->where('id', $id);
		$this->db->update($this->kpiTemplatesTable, ['title' => $title]);
		
		$this->db->where('template_id', $id);
		if (!$this->db->delete($this->kpiTemplatesDataTable)) return false;
		
		$insTasksData = [];
		foreach ($tasks as $task) {
			$insTasksData[] = [
				'template_id'	=> $id,
				'task_id' 		=> $task['task_id'],
				'repeats'		=> $task['repeats']
			];
		}
		
		$this->db->insert_batch($this->kpiTemplatesDataTable, $insTasksData);
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function removeTemplate($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->kpiTemplatesTable)) return false;
		
		$this->db->where('template_id', $id);
		if (!$this->db->delete($this->kpiTemplatesDataTable)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------- 
	
	
	// $this->kpiPeriodsTable = 'kpi_periods';
	// $this->kpiAmountsTable = 'kpi_amounts';
	
	// $this->kpiReportsTable = 'kpi_reports';
	// $this->kpiReportsDataTable = 'kpi_reports_data';
	// $this->kpiReportsPlanesTable = 'kpi_reports_planes';
	
	// $this->kpiPlanPersonagesTable = 'kpi_plan_personages';
	// $this->kpiProgressPersonagesTable = 'kpi_progress_personages';
	// $this->kpiTasksPersonagesTable = 'kpi_tasks_personages';
	
	// $this->kpiPlanFieldsTable = 'kpi_plan_fields';
	// $this->kpiProgressCustomTable = 'kpi_progress_custom';
	// $this->kpiTasksCustomTable = 'kpi_tasks_custom';
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getUsersBonusPercents() {
		if (!$usersPercents = $this->_result('users_bonus_percents')) return false;
		$usersPercents = setArrKeyFromField($usersPercents, 'user_id', 'percent');
		return $usersPercents;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getReportData($reportId = false) {
		if (!$reportId) return false;
		$this->db->where('report_id', $reportId);
		
		if (!$result = $this->_result($this->kpiReportsDataTable)) return false;
		$result = arrRestructure($result, 'static_id, user_id', 'payment, payout, nda');
		return $result;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function _getReportPlanes($reportId = false) {
		if (!$reportId) return false;
		$this->db->where('report_id', $reportId);
		
		if (!$result = $this->_result($this->kpiReportsPlanesTable)) return false;
		$result = arrRestructure($result, 'static_id, user_id plan_id', 'summ persent payout');
		return $result;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _saveReport($title = false, $periods = false) {
		if (!$title) return false;
		$periods = json_encode($periods);
		if (!$this->db->insert($this->kpiReportsTable, ['title' => $title, 'periods' => $periods])) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	
	
	/**
	 * Получить данные о кастомных задачах
	 * @param ID задач
	 * @return 
	*/
	private function _getCustomTasksToStat($customFields = false) {
		$customTasksIds = $customFields ? array_column($customFields, 'custom_task_id') : false;
		$periodCustomFields = $customFields ? setArrKeyfromField($customFields, 'custom_task_id', true) : [];
		
		$this->db->select('id, type, task, score');
		if ($customTasksIds) $this->db->where_in('id', (array)$customTasksIds);
		if (!$result = $this->_result($this->kpiTasksCustomTable)) return false;
		$result = setArrKeyFromField($result, 'id');
		$mergeTasksData = array_replace_recursive($result, $periodCustomFields);
		return setArrKeyFromField($mergeTasksData, 'name');
	}
	
	
	
	/**
	 * Получить данные о выполнении кастомных задач
	 * @param ID задач
	 * @return 
	*/
	private function _getCustomProgressToStat($periodId = false) {
		if (!$periodId) return false;
		$this->db->select('user_id, field, done');
		
		$this->db->where('period_id', $periodId);
		
		if (!$result = $this->_result($this->kpiProgressCustomTable)) return false;
		$result = arrRestructure($result, 'user_id, field');
		return $result;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getPlanPersonages($periodId = false, $type = 1) {
		if (!$periodId) return false;
		$this->db->where('period_id', $periodId);
		$this->db->where('type', $type);
		if (!$planPersonages = $this->_result($this->kpiPlanPersonagesTable)) return false;
		$planPersonages = arrRestructure($planPersonages, 'user_id personage_id task_id', 'repeats done:0');
		return $planPersonages;
	}
	
	
	
	
	
	/**
	 * @param ID периода
	 * @param тип 1 - плановые, 2 - бонусные
	 * @return 
	*/
	private function _getProgressPersonages($periodId = false, $type = 1) {
		$this->db->where('period_id', $periodId);
		$this->db->where('type', $type);
		if (!$progressPersonages = $this->_result($this->kpiProgressPersonagesTable)) return false;
		$progressPersonages = arrRestructure($progressPersonages, 'user_id personage_id task_id', 'done');
		return $progressPersonages;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getTasksPersonages($periodId = false) {
		$this->db->where('period_id', $periodId);
		if (!$planPersonages = $this->_result($this->kpiPlanPersonagesTable)) return false;
		$tasksIds = array_column($planPersonages, 'task_id');
		if ($tasksIds) $this->db->where_in('id', $tasksIds);
		$this->db->order_by('id', 'ASC');
		if (!$taskskData = $this->_result($this->kpiTasksPersonagesTable)) return false;
		$taskskData = setArrKeyfromField($taskskData, 'id');
		return $taskskData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить ошибки участников
	 * @param 
	 * @return 
	*/
	private function _getUsersFines($reportPeriodId = false) {
		if (!$reportPeriodId) return false;
		$this->db->select('user_id, fine');
		$this->db->where(['period_id' => $reportPeriodId]);
		$finesData = $this->_result('compounds_data');
		
		$finesData = setArrKeyFromField($finesData, 'user_id', 'fine');
		return $finesData;
	}
	
	
	
	/**
	 * Получить коэффициенты участников
	 * @param 
	 * @return 
	*/
	private function _getUsersVisits($reportPeriodId = false) {
		if (!$reportPeriodId) return false;
		$this->db->select('ru.user_id, ru.rate');
		$this->db->where(['r.period_id' => $reportPeriodId, 'r.is_key' => 0]);
		$this->db->join('raid_users ru', 'ru.raid_id = r.id');
		if (!$raidsData = $this->_result('raids r')) return false;
		
		$koeffsData = [];
		foreach ($raidsData as $item) {
			if (!isset($koeffsData[$item['user_id']])) $koeffsData[$item['user_id']] = $item['rate'];
			else $koeffsData[$item['user_id']] += $item['rate']; 
		}
		return $koeffsData;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getCustomFieldsData($activePeriodId = false) {
		if (!$activePeriodId) return false;
		$this->db->where('period_id', $activePeriodId);
		if (!$result = $this->_result($this->kpiProgressCustomTable)) return false;
		
		$customFieldsData = [];
		foreach ($result as $row) {
			$customFieldsData[$row['user_id']][$row['field']] = $row['done'];
		}
		return $customFieldsData;
	}
	
	
	
	
	
	
	
	
	
	
}