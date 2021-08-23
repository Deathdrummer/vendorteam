<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Kpi extends MY_Controller {
	
	public $viewsPath = 'views/admin/';
	
	public function __construct() {
		parent::__construct();
		if ($this->uri->uri_string != 'kpi/clear' && $this->uri->segment(3) != 'export' && !$this->input->is_ajax_request()) return false;
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
				$data['type'] = $post['type'];
				$data['attr'] = isset($post['attr']) ? $post['attr'] : 'kpiopenform';
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
			
			case 'remove_period':
				if (!$this->kpi->removeKpiPeriod($post['period_id'])) exit('');
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
				
				$data['types'] = [1 => 'Плановые', 2 => 'Бонусные'];
				
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
				
				$tasksListData = [];
				if ($tasksList) foreach ($tasksList as $tId => $task) $tasksListData[$task['type']][$tId] = $task;
				$types = [1 => 'Плановые', 2 => 'Бонусные'];
				if (!$this->kpi->saveTasks($post['period_id'], $post['user_id'], $post['personage_id'], $tasks)) exit('');
				echo $this->twig->render($this->viewsPath.'render/kpi/personages_tasks/list.tpl', ['tasks_list' => $tasksListData, 'types' => $types]);
				break;
			
			case 'save_from_template':
				if (!$tasksFromTemplate = $this->kpi->getActiveTemplate($post['from'])) exit('');
				
				$tasksIds = array_column($tasksFromTemplate, 'task_id');
				
				$tasks = $this->kpi->getPersonagesTasks($tasksIds);
				$tasks = setArrKeyFromField($tasks['items'], 'id', 'task');
				
				$tasksListData = [];
				if ($tasksFromTemplate) {
					foreach ($tasksFromTemplate as $tId => $task) {
						$tasksListData[1][$tId] = $task;
						$tasksListData[1][$tId]['task'] = $tasks[$task['task_id']];
					} 
				}
				
				$types = [1 => 'Плановые', 2 => 'Бонусные'];
				
				if (!$this->kpi->saveTasks($post['period_id'], $post['user_id'], $post['personage_id'], $tasksFromTemplate)) exit('0');
				
				echo $this->twig->render($this->viewsPath.'render/kpi/personages_tasks/list.tpl', ['tasks_list' => $tasksListData, 'types' => $types]);
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
				$periodData = isset($post['period_id']) ? $this->kpi->getPeriod($post['period_id']) : $this->kpi->getActivePeriod();
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
				$data['types'] = [1 => 'Плановые', 2 => 'Бонусные'];
				
				echo $this->twig->render($this->viewsPath.'render/kpi/progressplan/form.tpl', $data);
				break;
			
			case 'check_task':
				$periodData = isset($post['period_id']) ? $this->kpi->getPeriod($post['period_id']) : $this->kpi->getActivePeriod();
				if (!$this->kpi->checkProgressTask($periodData['id'], $post)) exit('0');
				echo '1';
				break;
			
			case 'check_custom':
				$periodData = isset($post['period_id']) ? $this->kpi->getPeriod($post['period_id']) : $this->kpi->getActivePeriod();
				if (!$this->kpi->checkProgressCustom($periodData['id'], $post)) exit('0');
				echo '1';
				break;
			
			case 'remove_personage':
				if (!$this->kpi->removeDeletedPersonage($post['personage_id'])) exit('0');
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
	public function statistics($action = false, $params = false) {
		$post = bringTypes($this->input->post()) ?: $params;
		if (!$action) return false;
		
		switch ($action) {
			case 'get_periods':
				$data['periods'] = $this->kpi->getPeriods();
				$data['single'] = isset($post['single']) ? 1 : 0;
				echo $this->twig->render($this->viewsPath.'render/kpi/statistics/periods.tpl', $data);
				break;
				
			case 'calc_statistics':
				if(!$periods = $post['periods']) return false;
				$this->load->model('users_model', 'users');
				
				$ndaCoeff = $this->admin_model->getSettings('nda_coeff');
				$ranks = $this->admin_model->getRanks();
				$ranksLiders = $this->admin_model->getRanksLiders();
				$amountsData = $this->kpi->getAmounts();
				
				$calcData = []; $payoutData = [];
				foreach ($periods as $periodId) {
					if (!$period = $this->kpi->getPeriod($periodId)) continue;
					
					$scoresPersonages = isset($period['scores']['personages']) ? (float)$period['scores']['personages'] : 0;
					$scoresVisits = isset($period['scores']['visits']) ? (float)$period['scores']['visits'] : 0;
					$scoresFine = isset($period['scores']['fine']) ? (float)$period['scores']['fine'] : 0;
					$scoresCustom = isset($period['scores']['customfields']) ? (float)$period['scores']['customfields'] : 0;
					
					$allScrores = $scoresPersonages + $scoresVisits + $scoresFine + $scoresCustom;
					$oneScorePercent = 100 / $allScrores;
					
					$scoresPersonagesPercent = $scoresPersonages ? round($scoresPersonages * $oneScorePercent, 3) : false; // макс. проц. активность на персонажах
					$scoresVisitsPercent = $scoresVisits ? round($scoresVisits * $oneScorePercent, 3) : false; // макс. проц. Посещаемость
					$scoresFinePercent = $scoresFine ? round($scoresFine * $oneScorePercent, 3) : false; // макс. проц. штрафы
					$scoresCustomPercent = $scoresCustom ? round($scoresCustom * $oneScorePercent, 3) : false; // макс. проц. доп. поля
					
					
					
					// ----------------------------------------------------------------------------------------
					
					if ($scoresPersonagesPercent && ($usersPersonagesData = $this->kpi->getPersonagesToStat($period))) {
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
					
					if ($usersFieldsData = $this->kpi->getFieldsToStat($period)) {
						
						foreach($usersFieldsData as $userId => $fields) {
							$visitsField = arrTakeItem($fields, 'visits');
							$fineField = arrTakeItem($fields, 'fine');
							
							if ($scoresVisitsPercent) {
								$visitsNeed = (isset($visitsField['need']) && $visitsField['need'] > 0) ? $visitsField['need'] : false;
								$visitsFact = isset($visitsField['fact']) ? $visitsField['fact'] : 0;
								
								if (!$visitsNeed) {
									$calcData[$userId]['visits'] = 0;
								} else {
									$donePercentVisits = $visitsNeed ? round(($visitsFact / $visitsNeed) * $scoresVisitsPercent, 3) : 0;
									$calcData[$userId]['visits'] = $donePercentVisits > $scoresVisitsPercent ? $scoresVisitsPercent : $donePercentVisits;
								}	
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
					
					$finalData = [];
					foreach ($calcData as $userId => $row) {
						$finalData[$userId] = array_sum($calcData[$userId]);
					}
					
					
					if ($finalData && ($usersIds = array_keys($finalData))) {
						$params = [
							'where' => ['us.main' => 1, 'u.deleted' => 0],
							'where_in' => ['field' => 'u.id', 'values' => $usersIds],
							'fields' => 'nickname avatar static rank rank_lider nda payment'
						];
						$users = $this->users->getUsers($params);
						
						foreach ($finalData as $userId => $scores) {
							if (!isset($users[$userId])) continue;
							$userStatic = $users[$userId]['static'];
							$userRank = $users[$userId]['rank'];
							$userRankLider = isset($users[$userId]['rank_lider']) && isset($ranksLiders[$users[$userId]['rank_lider']]) ? (float)$ranksLiders[$users[$userId]['rank_lider']]['coefficient'] : 1;
							
							$amount = isset($amountsData[$userStatic][$userRank][$period['payout_type']]) ? $amountsData[$userStatic][$userRank][$period['payout_type']] : 0;
							$amount = $amount ? round($amount / count($periods), 2) : 0;
							$payout = 0;
							
							if ($amount) {
								$payout = $amount ? (($amount / 100) * $scores) : 0;
								$payout = $payout * ($users[$userId]['nda'] ?: $ndaCoeff);
								$payout = $payout > $amount ? $amount : $payout;
							}
							
							
							if (!isset($payoutData[$userStatic][$userId])) {
								$payoutData[$userStatic][$userId] = [
									'nickname' 		=> $users[$userId]['nickname'],
									'avatar' 		=> $users[$userId]['avatar'],
									'rank'			=> $ranks[$userRank]['name'],
									'nda'			=> $users[$userId]['nda'] ? 1 : 0,
									'payment'		=> $users[$userId]['payment'],	
									'payout_all'	=> round($payout * $userRankLider)
								];
							} else {
								$payoutData[$userStatic][$userId]['payout_all'] += round($payout * $userRankLider);
							}
								
							
							$payoutData[$userStatic][$userId]['periods'][$periodId] = [
								'summ'		=> $amount,
								'persent'	=> round($scores, 1),
								'payout'	=> round($payout * $userRankLider),
							];
						}
					}
					
				}
				
				ksort($payoutData);
				
				$data['report'] = $payoutData;
				$data['statics'] = $this->admin_model->getStatics(true);
				$kpiPeriods = $this->kpi->getPeriods($periods);
				$data['kpi_periods'] = $kpiPeriods['items'];
				$data['kpi_periods_ids'] = $periods;
				
				if (isset($post['export']) && $post['export']) return $data;
				echo $this->twig->render($this->viewsPath.'render/kpi/statistics/report.tpl', $data);
				break;
			
			
			case 'get_reports_list':
				$data['reports'] = $this->kpi->getReports();
				echo $this->twig->render($this->viewsPath.'render/kpi/statistics/reports.tpl', $data);
				break;
			
			case 'get_report':
				$data['statics'] = $this->admin_model->getStatics(true);
				$data['ranks'] = $this->admin_model->getRanks();
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
				
			case 'export':
				$reportId = $this->uri->segment(4);
				$report = $this->kpi->getReportInfo($reportId);
				$periods = json_decode($report['periods'], true);
				$periods = array_column($periods, 'id');
				$data = $this->statistics('calc_statistics', ['periods' => $periods, 'export' => 1]);
				
				$dataToExport = ''; $periodsStr = ''; $kpiPeriods = setArrKeyfromField($data['kpi_periods'], 'id');
				foreach ($kpiPeriods as $period) $periodsStr .= ';'.$period['title'];
				$dataToExport .= iconv('UTF-8', 'windows-1251', 'Участник;Статик;NDA;Платежные реквизиты'.$periodsStr.';Итого к выплате'."\r\n");
				
				foreach ($data['report'] as $staticId => $users) foreach ($users as $userId => $userData) {
					$periodsRow = '';
					foreach ($data['kpi_periods_ids'] as $periodId) $periodsRow .= ';'.$userData['periods'][$periodId]['payout'];
					
					$dataToExport .= iconv('UTF-8', 'windows-1251', $userData['nickname'].';'.$data['statics'][$staticId].';'.$userData['nda'].';'.$userData['payment'].$periodsRow.';'.str_replace('.', ',', $userData['payout_all']))."\r\n";
				}
				
				setHeadersToDownload('application/octet-stream', 'windows-1251');
				echo $dataToExport;
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Статистика выполнения задач
	 * @param 
	 * @return 
	*/
	public function statisticsbonus($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get_periods':
				$data['periods'] = $this->kpi->getBonusReportsPeriods();
				echo $this->twig->render($this->viewsPath.'render/kpi/statisticsbonus/periods.tpl', $data);
				break;
			
			case 'get_report':
				$data['report'] = $this->kpi->getBonusReport($post['period_id']);
				$data['statics'] = $this->admin_model->getStatics(true);
				$data['is_saved'] = 1;
				echo $this->twig->render($this->viewsPath.'render/kpi/statisticsbonus/report.tpl', $data);
				break;
				
			case 'save':
				if (!$this->kpi->saveBonusReport($post['period_id'], $post['report_data'])) exit('0');
				echo '1';
				break;
			
			case 'send_users_percents':
				if (!$this->kpi->sendUsersPercents($post['period_id'])) exit('0');
				echo '1';
				break;
			
			case 'calc_statistics':
				if(!$periodId = $post['period']) return false;
				$this->load->model('users_model', 'users');
				
				$ndaCoeff = $this->admin_model->getSettings('nda_coeff');
				$ranks = $this->admin_model->getRanks();
				$amountsData = $this->kpi->getAmounts();
				
				$calcData = []; $calcDataOver = []; // сверх проценты
				if (!$period = $this->kpi->getPeriod($periodId)) return false;
				
				$scoresPersonages = isset($period['scores']['personages']) ? (float)$period['scores']['personages'] : 0;
				$scoresVisits = isset($period['scores']['visits']) ? (float)$period['scores']['visits'] : 0;
				$scoresFine = isset($period['scores']['fine']) ? (float)$period['scores']['fine'] : 0;
				$scoresCustom = isset($period['scores']['customfields']) ? (float)$period['scores']['customfields'] : 0;
				
				$allScrores = $scoresPersonages + $scoresVisits + $scoresFine + $scoresCustom;
				$oneScorePercent = 100 / $allScrores;
				
				$scoresPersonagesPercent = $scoresPersonages ? round($scoresPersonages * $oneScorePercent, 3) : false; // макс. проц. активность на персонажах
				$scoresVisitsPercent = $scoresVisits ? round($scoresVisits * $oneScorePercent, 3) : false; // макс. проц. Посещаемость
				$scoresFinePercent = false; //$scoresFine ? round($scoresFine * $oneScorePercent, 3) : false; // макс. проц. штрафы
				$scoresCustomPercent = $scoresCustom ? round($scoresCustom * $oneScorePercent, 3) : false; // макс. проц. доп. поля
				
				
				
				// ----------------------------------------------------------------------------------------
				
				if ($scoresPersonagesPercent) {
					if ($usersPersonagesData = $this->kpi->getPersonagesToStat($period, 1)) {
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
							$calcData[$userId]['personages'] = ($donePercentPersonages - $scoresPersonagesPercent) > 0 ? ($donePercentPersonages - $scoresPersonagesPercent) : 0;
						}
					}
					
					if ($usersPersonagesBonusData = $this->kpi->getPersonagesToStat($period, 2)) {
						$allBonusScrores = []; $doneBonusScores = [];
						foreach ($usersPersonagesBonusData as $userId => $personages) foreach ($personages as $pId => $tasks) foreach ($tasks as $tId => $task) {
							$done = isset($task['done']) ? $task['done'] : 0;
							$repeats = $task['repeats'];
							$score = $task['score'];
							
							if (!isset($allBonusScrores[$userId])) $allBonusScrores[$userId] = ($repeats * $score);
							else $allBonusScrores[$userId] += ($repeats * $score);
							
							if (!isset($doneBonusScores[$userId])) $doneBonusScores[$userId] = ($done * $score);
							else $doneBonusScores[$userId] += ($done * $score);
						}
						
						foreach ($allBonusScrores as $userId => $scores) {
							$donePercentPersonages = round(($doneBonusScores[$userId] / $scores) * $scoresPersonagesPercent, 3);
							
							if (!isset($calcData[$userId]['personages'])) $calcData[$userId]['personages'] = $donePercentPersonages;
							else $calcData[$userId]['personages'] += $donePercentPersonages;
						}
					}
					
				}
				
				
				// ----------------------------------------------------------------------------------------
				
				if ($usersFieldsData = $this->kpi->getFieldsToStat($period)) {
					
					foreach($usersFieldsData as $userId => $fields) {
						$visitsField = arrTakeItem($fields, 'visits');
						$fineField = arrTakeItem($fields, 'fine');
						
						if ($scoresVisitsPercent) {
							$visitsNeed = (isset($visitsField['need']) && $visitsField['need'] > 0) ? $visitsField['need'] : false;
							$visitsFact = isset($visitsField['fact']) ? $visitsField['fact'] : 0;
							
							if (!$visitsNeed) {
								$calcData[$userId]['visits'] = 0;
							} else {
								$donePercentVisits = $visitsNeed ? round(($visitsFact / $visitsNeed) * $scoresVisitsPercent, 3) : 0;
								$calcData[$userId]['visits'] = $donePercentVisits > $scoresVisitsPercent ? $donePercentVisits - $scoresVisitsPercent : 0;
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
								$calcData[$userId]['custom'] = $donePercentCustom > $scoresCustomPercent ? $donePercentCustom - $scoresCustomPercent : 0;
							}
						}
					}
				}
				
				
				
				// ----------------------------------------------------------------------------------------
				
				
				foreach ($calcData as $userId => $row) {
					$calcData[$userId]['total'] = array_sum($calcData[$userId]);
				}
				
				
				if ($calcData && ($usersIds = array_keys($calcData))) {
					$params = [
						'where' => ['us.main' => 1, 'u.deleted' => 0],
						'where_in' => ['field' => 'u.id', 'values' => $usersIds],
						'fields' => 'nickname avatar static rank nda payment'
					];
					$users = $this->users->getUsers($params);
					
					foreach ($calcData as $userId => $persents) {
						if (!isset($users[$userId])) continue;
						$userStatic = $users[$userId]['static'];
						$userRank = $users[$userId]['rank'];
						
						$finalData[$userStatic][$userId] = [
							'nickname' 		=> $users[$userId]['nickname'],
							'avatar' 		=> $users[$userId]['avatar'],
							'rank'			=> $ranks[$userRank]['name'],
							'nda'			=> $users[$userId]['nda'] ? 1 : 0,
							'payment'		=> $users[$userId]['payment'],
							'percents'		=> $persents
						];
					}
				}
				
			
				ksort($finalData);
				
				$data['report'] = $finalData;
				$data['statics'] = $this->admin_model->getStatics(true);
				$kpiPeriod = $this->kpi->getPeriods($periodId);
				$data['kpi_periods'] = $kpiPeriod['items'];
				$data['kpi_period_id'] = $periodId;
				echo $this->twig->render($this->viewsPath.'render/kpi/statisticsbonus/report.tpl', $data);
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	/**
	 * Статистика выполнения задач
	 * @param 
	 * @return 
	*/
	public function templates($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'list':
				$data['templates'] = $this->kpi->getTemplates($post['from']);
				echo $this->twig->render($this->viewsPath.'render/kpi/templates/list.tpl', $data);
				break;
			
			case 'form':
				$data['tasks'] = $this->kpi->getTasks();
				if (isset($post['id'])) {
					$data['title'] = $this->kpi->getTemplateTitle($post['id']);
					$data['template_tasks'] = $this->kpi->getTemplateTasks($post['id']);
				} 
				echo $this->twig->render($this->viewsPath.'render/kpi/templates/form.tpl', $data);
				break;
				
			
			case 'activate':
				//$data['tasks'] = $this->kpi->getTasks();
				if (!$this->kpi->activateTemplate($post['id'], $post['from'])) exit(0);
				echo '1';
				break;
			
			case 'save':
				if (!$this->kpi->saveTemplate($post['title'], $post['tasks'])) exit(0);
				echo '1';
				break;
			
			case 'update':
				if (!$this->kpi->updateTemplate($post['id'], $post['title'], $post['tasks'])) exit(0);
				echo '1';
				break;
			
			case 'remove':
				if (!$this->kpi->removeTemplate($post['id'])) exit(0);
				echo '1';
				break;
			
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function clear() {
		$this->kpi->clearDeletedPersonages();
	}
	
	
	
}