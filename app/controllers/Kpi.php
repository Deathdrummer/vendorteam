<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Kpi extends MY_Controller {
	
	public $viewsPath = 'views/admin/';
	
	public function __construct() {
		parent::__construct();
		if (!$this->input->is_ajax_request()) return false;
		$this->load->model('kpi_model', 'kpi');
	}
	
	
	
	
	
	
	/**
	 * CRUD периоды
	 * @param 
	 * @return 
	*/
	public function periods($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				$this->load->model(['admin_model' => 'admin', 'reports_model' => 'reports']);
				$data['statics'] = $this->admin->getStatics(true);
				$data['reports_periods'] = $this->reports->getReportsPeriods();
				$data['periods'] = $this->kpi->getPeriods();
				echo $this->twig->render($this->viewsPath.'render/kpi/periods/list.tpl', $data);
				break;
			
			case 'new':
				$this->load->model(['reports_model' => 'reports', 'admin_model' => 'admin']);
				$data['periods'] = $this->reports->getReportsPeriods();
				$data['statics'] = $this->admin->getStatics(true);
				echo $this->twig->render($this->viewsPath.'render/kpi/periods/form.tpl', $data);
				break;
			
			case 'add':
				$post = bringTypes($this->input->post());
				if (!$this->kpi->addPeriod($post)) exit('0');
				echo '1';
				break;
			
			case 'activate_period':
				$post = bringTypes($this->input->post());
				if (!$this->kpi->activatePeriod($post['period_id'], $post['stat'])) exit('0');
				echo '1';
				break;
			
			case 'publish_period':
				$post = bringTypes($this->input->post());
				if (!$this->kpi->publishPeriod($post['period_id'], $post['stat'])) exit('0');
				echo '1';
				break;
				
			case 'add_custom_field':
				$data['custom_tasks'] = $this->kpi->getCustomTasks();
				echo $this->twig->render($this->viewsPath.'render/kpi/custom_fields/item.tpl', $data);
				break;
				
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * CRUD задачи для персонажей
	 * @param 
	 * @return 
	*/
	public function plan($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get_form': // Получить форму для заполнения значения для KPI плана
				$this->load->model(['admin_model' => 'admin', 'users_model' => 'users']);
				$periodData = $this->kpi->getPeriod((int)$post['period_id']);
				$search = isset($post['search']) ? $post['search'] : null;
				
				if (!$formdata = $this->kpi->getPlanForm($periodData, $search)) exit('');
				
				$hasPersonages = is_array($periodData['fields']) && in_array('personages', $periodData['fields']);
				$hasVisits = is_array($periodData['fields']) && in_array('visits', $periodData['fields']);
				$hasFine = is_array($periodData['fields']) && in_array('fine', $periodData['fields']);
				
				
				$usersIds = [];
				foreach ($formdata as $stId => $users) {
					$usersIds = array_merge($usersIds, array_keys($users));
				}
				
				if ($hasPersonages) $data['personages'] = $this->users->getUsersPersonages($usersIds, true);
				$data['statics'] = $this->admin->getStatics(true);
				$data['ranks'] = $this->admin->getRanks();
				$data['formdata'] = $formdata;
				$data['has_fields'] = ['personages' => $hasPersonages, 'visits' => $hasVisits, 'fine' => $hasFine];
				
				if ($periodData['custom_fields']) {
					$customTasks = $this->kpi->getCustomTasksToForm($periodData['custom_fields']);
					
					$customFields = [];
					foreach ($periodData['custom_fields'] as $customField) {
						$name = arrTakeItem($customField, 'name');
						$customField['title'] = $customTasks[$customField['custom_task_id']]['task'];
						$customField['type'] = $customTasks[$customField['custom_task_id']]['type'];
						unset($customField['custom_task_id']);
						$customFields[$name] = $customField;
					}
					
					$data['custom_fields'] = $customFields;
				}
				
				echo $this->twig->render($this->viewsPath.'render/kpi/plan/form.tpl', $data);
				break;
			
			case 'save_param': // Сохранить значение параметра формы плана
				if (!$this->kpi->saveFormParam($post['period_id'], $post['user_id'], $post['param'], $post['value'])) exit('0');
				echo '1';
				break;
			
			case 'save_custom_param': // Сохранить значение кастомного параметра формы плана
				if (!$this->kpi->saveCustomFormParam($post['period_id'], $post['user_id'], $post['field'], $post['value'])) exit('0');
				echo '1';
				break;
			
			
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	/**
	 * CRUD задачи для персонажей
	 * @param 
	 * @return 
	*/
	public function tasks($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'init':
				echo $this->twig->render($this->viewsPath.'render/kpi/tasks/init.tpl');
				break;
			
			case 'get':
				$data['tasks'] = $this->kpi->getPersonagesTasks();
				echo $this->twig->render($this->viewsPath.'render/kpi/tasks/list.tpl', $data);
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/kpi/tasks/new.tpl');
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				
				if (!$insertId = $this->kpi->saveTask($fields)) exit('0');
				$fieldsToItem['id'] = $insertId;
				echo $this->twig->render($this->viewsPath.'render/kpi/tasks/item.tpl', $fieldsToItem);
				break;
				
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				if (!$this->kpi->updateTask($id, $fields)) exit('0');
				echo '1';
				break;
				
			case 'remove':
				if (!$this->kpi->removeTask($post['id'])) exit('0');
				echo '1';
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * CRUD задачи для кастомных полей
	 * @param 
	 * @return 
	*/
	public function customtasks($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'init':
				echo $this->twig->render($this->viewsPath.'render/kpi/customtasks/init.tpl');
				break;
			
			case 'get':
				$data['customtasks'] = $this->kpi->getCustomTasks();
				echo $this->twig->render($this->viewsPath.'render/kpi/customtasks/list.tpl', $data);
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/kpi/customtasks/new.tpl');
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				
				if (!$insertId = $this->kpi->saveCustomTask($fields)) exit('0');
				$fieldsToItem['id'] = $insertId;
				echo $this->twig->render($this->viewsPath.'render/kpi/customtasks/item.tpl', $fieldsToItem);
				break;
				
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				if (!$this->kpi->updateCustomTask($id, $fields)) exit('0');
				echo '1';
				break;
				
			case 'remove':
				if (!$this->kpi->removeCustomTask($post['id'])) exit('0');
				echo '1';
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function personages_tasks($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get_form':
				$data['tasks'] = $this->kpi->getTasks();
				$data['personage_tasks'] = $this->kpi->getPersonageTasks($post['period_id'], $post['personage_id']);
				echo $this->twig->render($this->viewsPath.'render/kpi/personages_tasks/form.tpl', $data);
				break;
			
			case 'save_tasks':
				$tasks = isset($post['tasks']) ? $post['tasks'] : false;
				$tasksList = isset($post['to_list']) ? $post['to_list'] : null;
				
				if (!$this->kpi->saveTasks($post['period_id'], $post['user_id'], $post['personage_id'], $tasks)) exit('');
				echo $this->twig->render($this->viewsPath.'render/kpi/personages_tasks/list.tpl', ['tasks_list' => $tasksList]);
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Достижения KPI плана
	 * @param 
	 * @return 
	*/
	public function progressplan($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get_form':
				$this->load->model(['admin_model' => 'admin', 'users_model' => 'users']);
				$periodData = $this->kpi->getActivePeriod();
				$search = isset($post['search']) ? $post['search'] : null;
				if (!$formdata = $this->kpi->getProgressForm($periodData, $search)) exit('');
				
				$data['custom_fields'] = $this->kpi->getPeriodCustomFields($periodData['custom_fields']);
				
				$data['progress'] = $this->kpi->getProgressTasks($periodData['id']);
				$data['statics'] = $this->admin->getStatics(true, array_keys($formdata));
				$data['ranks'] = $this->admin->getRanks();
				$usersIds = [];
				foreach ($formdata as $stId => $users) {
					$usersIds = array_merge($usersIds, array_keys($users));
				}
				
				$data['personages'] = $this->users->getUsersPersonages($usersIds, true);
				$data['formdata'] = $formdata;
				
				echo $this->twig->render($this->viewsPath.'render/kpi/progressplan/form.tpl', $data);
				break;
			
			case 'check_task':
				$periodData = $this->kpi->getActivePeriod();
				if (!$this->kpi->checkProgressTask($periodData['id'], $post)) exit('0');
				echo '1';
				break;
			
			case 'check_custom':
				$periodData = $this->kpi->getActivePeriod();
				if (!$this->kpi->checkProgressCustom($periodData['id'], $post)) exit('0');
				echo '1';
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Суммы выплат по званиям и статикам
	 * @param 
	 * @return 
	*/
	public function amounts($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get_form':
				$this->load->model(['admin_model' => 'admin']);
				$ranksData = $this->admin->getRanks(true, false);
				
				$data['ranks'] = setArrKeyfromField($ranksData, 'id', 'name');
				$data['statics'] = $this->admin->getStatics(true);
				$data['amounts'] = $this->kpi->getAmounts();
				
				echo $this->twig->render($this->viewsPath.'render/kpi/amounts/form.tpl', $data);
				break;
			
			case 'set_amount':
				if (!$this->kpi->setAmount($post)) exit('0');
				echo '1';
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	/**
	 * Статистика выполнения задач
	 * @param 
	 * @return 
	*/
	public function statistics($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get_periods':
				$data['periods'] = $this->kpi->getPeriods();
				echo $this->twig->render($this->viewsPath.'render/kpi/statistics/periods.tpl', $data);
				break;
				
			case 'calc_statistics':
				if(!$periods = $post['periods']) return false;
				
				$ndaCoeff = $this->admin_model->getSettings('nda_coeff');
				$ranks = $this->admin_model->getRanks();
				$amountsData = $this->kpi->getAmounts();
				
				$payoutData = [];
				foreach ($periods as $periodId) {
					if (!$period = $this->kpi->getPeriod($periodId)) continue;
					
					if (isset($period['scores']['personages']) && ($personagesScores = $period['scores']['personages'])) {
						if (!$usersPersonagesData = $this->kpi->getPersonagesToStat($period)) return false;
						
						$allScrores = []; $doneScores = [];
						foreach ($usersPersonagesData as $userId => $personages) foreach ($personages as $pId => $tasks) foreach ($tasks as $tId => $task) {
							$done = isset($task['done']) ? $task['done'] : 0;
							$repeats = $task['repeats'];
							$score = $task['score'];
							
							if (!isset($allScrores[$userId])) $allScrores[$userId] = ($repeats * $score);
							else $allScrores[$userId] += ($repeats * $score);
							
							if (!isset($doneScores[$userId])) $doneScores[$userId] = ($done * $score);
							else $doneScores[$userId] += ($done * $score);
						}
						
						$personagesCalc = [];
						foreach ($allScrores as $userId => $scores) {
							$personagesCalc[$userId] = round(($doneScores[$userId] / $scores) * $personagesScores, 3);
						}
					}
					
						
					
					if (!$usersFieldsData = $this->kpi->getFieldsToStat($period)) return false;
					
					
					$visitsScores = isset($period['scores']['visits']) ? $period['scores']['visits'] : false;
					$fineScores = isset($period['scores']['fine']) ? $period['scores']['fine'] : false;
					
					
					$fieldsCalc = []; $needValues = [];
					foreach($usersFieldsData as $userId => $fields) {
						if ($visitsScores) {
							$visitsNeed = (isset($fields['visits']['need']) && $fields['visits']['need'] > 0) ? $fields['visits']['need'] : false;
							$visitsFact = isset($fields['visits']['fact']) ? $fields['visits']['fact'] : 0;
							$fieldsCalc[$userId]['visits'] = $visitsNeed ? round(($visitsFact / $visitsNeed) * $visitsScores, 3) : 0;
						}
							
						if ($fineScores) {
							$fineNeed = (isset($fields['fine']['need']) && $fields['fine']['need'] > 0) ? $fields['fine']['need'] : false;
							$fineFact = isset($fields['fine']['fact']) ? $fields['fine']['fact'] : 0;
							$fieldsCalc[$userId]['fine'] = $fineNeed ? round(($fineFact / $fineNeed) * $fineScores, 3) : 0;
						}
						
						
						$fieldsCalc[$userId]['personages'] = isset($personagesCalc[$userId]) ? $personagesCalc[$userId] : 0;
						
						foreach ($fields as $field => $fData) {
							if (in_array($field, ['visits', 'fine'])) continue;
							
							if ($fData['type'] == 'koeff') {
								$calcItem = (isset($fData['done']) && $fData['done'] > 0) ? ($fData['done'] * $fData['score']) : 0;
							} elseif ($fData['type'] == 'bool') {
								$calcItem = (isset($fData['done']) && $fData['done'] == 1 ) ? $fData['score'] : 0;
							}
							
							$fieldsCalc[$userId][$field] = $calcItem;
							
							// need values
							$needValues[$userId]['visits'] = $visitsScores;
							$needValues[$userId]['fine'] = $fineScores;
							$needValues[$userId]['personages'] = $fieldsCalc[$userId]['personages'] ? $personagesScores : 0;
							$needValues[$userId][$field] = $fData['type'] == 'koeff' ? ($fData['need'] * $fData['score']) : $fData['score'];
						}
						
					}
					
					$finalData = [];
					foreach ($fieldsCalc as $userId => $row) {
						$finalData[$userId] = round(array_sum($fieldsCalc[$userId]) / array_sum($needValues[$userId]) * 100, 2);
					}
					
					
					
					
					$this->load->model('users_model', 'users');
					$usersIds = array_keys($finalData);
					
					$params = [
						'where' => ['us.main' => 1, 'u.deleted' => 0],
						'where_in' => ['field' => 'u.id', 'values' => $usersIds],
						'fields' => 'nickname avatar static rank nda payment'
					];
					
					$users = $this->users->getUsers($params);
					
					
					
					foreach ($finalData as $userId => $scores) {
						$amount = isset($amountsData[$users[$userId]['static']][$users[$userId]['rank']]) ? $amountsData[$users[$userId]['static']][$users[$userId]['rank']] : 0;
						$amount = round($amount / count($periods), 3);
						$payout = 0;
						
						if ($amount) {
							$payout = $amount ? ($amount / 100) * $scores : 0;
							$payout = $payout * ($users[$userId]['nda'] ? 1 : $ndaCoeff);
						}
						
						if (!isset($payoutData[$users[$userId]['static']][$userId])) {
							$payoutData[$users[$userId]['static']][$userId] = [
								'nickname' 		=> $users[$userId]['nickname'],
								'avatar' 		=> $users[$userId]['avatar'],
								'rank'			=> $ranks[$users[$userId]['rank']]['name'],
								'nda'			=> $users[$userId]['nda'] ? 1 : 0,
								'payment'		=> $users[$userId]['payment'],	
								'payout_all'	=> round($payout, 2)
							];
						} else {
							$payoutData[$users[$userId]['static']][$userId]['payout_all'] += $payout;
						}
							
						
						$payoutData[$users[$userId]['static']][$userId]['periods'][$periodId] = [
							'summ'		=> $amount,
							'persent'	=> $scores,
							'payout'	=> $payout,
						];
					}
					
				}
				
				$data['report'] = $payoutData;
				$data['statics'] = $this->admin_model->getStatics(true);
				$kpiPeriods = $this->kpi->getPeriods($periods);
				$data['kpi_periods'] = $kpiPeriods['items'];
				$data['kpi_periods_ids'] = $periods;
				
				echo $this->twig->render($this->viewsPath.'render/kpi/statistics/report.tpl', $data);
				break;
			
			case 'get_reports_list':
				$data['reports'] = $this->kpi->getReports();
				echo $this->twig->render($this->viewsPath.'render/kpi/statistics/reports.tpl', $data);
				break;
			
			case 'get_report':
				$data['statics'] = $this->admin_model->getStatics(true);
				$data['report'] = $this->kpi->getReport($post['report_id']);
				$data['kpi_periods'] = $post['periods'];
				$data['saved_report'] = 1;
				echo $this->twig->render($this->viewsPath.'render/kpi/statistics/report.tpl', $data);
				break;
			
			case 'save':
				$kpiPeriods = $this->kpi->getPeriods(json_decode($post['periods'], true));
				
				$kpiPeriodsToSave = [];
				foreach ($kpiPeriods['items'] as $period) {
					$kpiPeriodsToSave[] = [
						'id' 	=> $period['id'],
						'title' => $period['title'],
					];
				}
				
				if (!$this->kpi->saveReport($post['title'], $post['report'], $kpiPeriodsToSave)) exit('0');
				echo '1';
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
}