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
	private $kpiReportsDataTable = 'kpi_reports_data';
	private $kpiReportsPlanesTable = 'kpi_reports_planes';
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	/**
	 * Получить список KPI периодов
	 * @param 
	 * @return 
	*/
	public function getPeriods($periodsIds = false) {
		if ($periodsIds) $this->db->where_in('id', $periodsIds);
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
	public function getPersonagesTasks() {
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
		$this->db->select('user_id, visits, fine, custom_fields');
		$this->db->where('period_id', $periodId);
		if ($userId) $this->db->where('user_id', $userId);
		if (!$tableData = $this->_result($this->kpiPlanFieldsTable)) return false;
		
		
		if ($periodCustomFields = $this->getPeriod($periodId, 'custom_fields')) {
			$periodCustomFields = json_decode($periodCustomFields, true);
			$periodCustomFields = array_column($periodCustomFields, 'name');
			$periodCustomFields = array_combine(array_keys(array_flip($periodCustomFields)), array_fill(0, count($periodCustomFields), null));
		}
		
		$usersParams = [];
		foreach ($tableData as $item) {
			$userId = arrTakeItem($item, 'user_id');
			$customFields = (isset($item['custom_fields']) && isJSON($item['custom_fields'])) ? json_decode($item['custom_fields'], true) : false;
			if ($periodCustomFields && $customFields) $item['custom_fields'] = array_replace($periodCustomFields, $customFields);
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
		$this->db->select('ut.task_id, ut.user_id, ut.personage_id, pt.task, ut.repeats');
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
			$tasksData[$userId][$personageId][$taskId] = $row;
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
		$this->db->select('task_id, repeats');

		if ($periodId) $this->db->where('period_id', $periodId);
		if ($personageId) $this->db->where('personage_id', $personageId);
		if (!$tasksList = $this->_result($this->kpiPlanPersonagesTable)) return false;
		$tasksData = [];
		foreach ($tasksList as $row) {
			$tasksData[$row['task_id']] = $row['repeats'];
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
	public function checkProgressTask($activePeriodId = false, $data = false) {
		if (!$data || !$activePeriodId) return false;
		
		$this->db->where(['period_id' => $activePeriodId, 'user_id' => $data['user_id'], 'personage_id' => $data['personage_id'], 'task_id' => $data['task_id']]);
		$tableData = $this->_row($this->kpiProgressPersonagesTable);
		
		if ($tableData) {
			$this->db->where(['period_id' => $activePeriodId, 'user_id' => $data['user_id'], 'personage_id' => $data['personage_id'], 'task_id' => $data['task_id']]);
			return $this->db->update($this->kpiProgressPersonagesTable, ['done' => $data['value']]);
		} 
		
		return $this->db->insert($this->kpiProgressPersonagesTable, [
			'period_id'		=> $activePeriodId,
			'user_id'		=> $data['user_id'],
			'personage_id'	=> $data['personage_id'],
			'task_id'		=> $data['task_id'],
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
			$restructureData[$item['user_id']][$item['personage_id']][$item['task_id']] = $item['done'];
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
	public function getPersonagesToStat($period = false) {
		$planPersonages = $this->_getPlanPersonages($period['id']);
		$tasksPersonages = $this->_getTasksPersonages($period['id']);
		$progressPersonages = $this->_getProgressPersonages($period['id']);
		
		$planPregressData = $progressPersonages ? array_replace_recursive($planPersonages, $progressPersonages) : $planPersonages;
		
		if ($planPregressData) {
			foreach ($planPregressData as $userId => $personages) foreach ($personages as $personageId => $tasks) foreach ($tasks as $taskId => $taskData) {
				//$planPregressData[$userId][$personageId][$taskId]['name'] = isset($tasksPersonages[$taskId]['task'])? $tasksPersonages[$taskId]['task'] : null;
				$planPregressData[$userId][$personageId][$taskId]['score'] = isset($tasksPersonages[$taskId]['score'])? $tasksPersonages[$taskId]['score'] : null;
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
			
			
			if (!$item['custom_fields'] || (!$customFields = json_decode($item['custom_fields'], true))) continue;
			foreach ($customFields as $field => $need) $customFields[$field] = ['need' => $need];
			
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
		if (!$usersData = $this->users->getUsers($params)) return false;;
		
		foreach ($reportData as $staticId => $users) foreach ($users as $userId => $userData) {
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
		
		$orders = [];
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
		}		
		
		if (!$this->reports->insertUsersOrders($orders)) return false;
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
	private function _getPlanPersonages($periodId = false) {
		if (!$periodId) return false;
		$this->db->where('period_id', $periodId);
		if (!$planPersonages = $this->_result($this->kpiPlanPersonagesTable)) return false;
		$planPersonages = arrRestructure($planPersonages, 'user_id personage_id task_id', 'repeats done:0');
		return $planPersonages;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getProgressPersonages($periodId = false) {
		$this->db->where('period_id', $periodId);
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