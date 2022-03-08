<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Reports extends MY_Controller {
	
	
	private $walletReportToLog = false;
	private $viewsPath = 'views/admin/render/reports/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model(['reports_model', 'admin_model', 'account_model']);
	}
	
	
	
	
	
	
	/**
	 * Формирование первого отчета
	 * @param POST data или нет
	 * @return 
	 */
	public function get_main_report() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		
		if (isset($postData['pattern_id'])) {
			$data = $this->reports_model->getMainReportPatterns($postData['pattern_id']);
		} else {
			$postData['cash'] = json_decode($postData['cash'], true);
			$data = $postData;
		}
		
		// Если Для пользователя - получить список его статиков и передать в функцию
		$data['statics'] = null;
		if (isset($postData['to_user'])) {
			$this->load->model('account_model');
			if (!$userData = $this->account_model->getUserData()) exit('');
			$data['statics'] = is_array($userData['statics']) ? array_keys($userData['statics']) : null;
		}
		
		$mainReportData = $this->buildMainReport($data);
		$mainReportData['pattern_id'] = isset($postData['pattern_id']) ? $postData['pattern_id'] : null;
		$mainReportData['to_user'] = isset($postData['to_user']) ? $userData['id'] : false;
		$mainReportData['statics'] = isset($postData['to_user']) ? $userData['statics'] : false;
		
		if ($mainReportData['to_user']) echo $this->twig->render('views/account/render/main_report.tpl', $mainReportData);
		else echo $this->twig->render('views/admin/render/main_report.tpl', $mainReportData);
	}
	
	
	
	
	
	
	/**
	 * Формирование данных первого отчета
	 * @param 
	 * @return 
	 */
	private function buildMainReport($data = false) {
		if (!$data) return false;
		$constants = $this->constants[$data['variant']];
		return [
			'raids'		=> $this->reports_model->getRaids($data),
			'report'	=> $this->reports_model->buildReportPaymentsData($constants, $data, false)
		];
	}
	
	
	
	
	
	/**
	 * Получение списка статиков для присвоения бюджетов
	 * @param 
	 * @return 
	 */
	public function get_statics_to_cash() {
		if (!$this->input->is_ajax_request()) return false;
		$setCash = json_decode($this->input->post('set_cash'), true);
		$reportStatics = $this->admin_model->getStatics(true);
		echo $this->twig->render('views/admin/render/reports_statics_cash.tpl', ['report_statics' => $reportStatics, 'set_cash' => $setCash]);
	}
	
	
	
	
	
	/**
	 * Сохранение паттерна первого отчета
	 * @param 
	 * @return 
	 */
	public function save_main_report_pattern() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$postData['cash'] = json_decode($postData['cash'], true);
		$this->reports_model->saveMainReportPattern($postData, $this->constants[$postData['variant']]);
		echo 1;
	}
	
	
	
	

	/**
	 * Получение списка паттернов для первого отчета
	 * @param 
	 * @return 
	 */
	public function get_main_reports_patterns() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		if (!$reportsPatterns = $this->reports_model->getMainReportPatterns(null, $postData, (isset($postData['to_user']) && $postData['to_user'] ? 2 : 0))) exit('');
		
		if (isset($postData['to_user']) && $postData['to_user']) {
			$toUserData = [];
			foreach ($reportsPatterns as $patternId => $data) {
				$isKey = $data['is_key'] == 1 ? 'keys' : 'raids';
				$toUserData[$isKey][$patternId] = $data;
			}
			
			echo $this->twig->render('views/account/render/reports_patterns.tpl', [
				'reports_patterns' 	=> bringTypes($toUserData),
				'titles'			=> ['keys' => 'Ключи', 'raids' => 'Рейды'],
				'statics'			=> $this->admin_model->getStatics()
			]);
		} else {
			echo $this->twig->render('views/admin/render/reports_patterns.tpl', [
				'reports_patterns' 	=> bringTypes($reportsPatterns),
				'statics'			=> $this->admin_model->getStatics()
			]);
		}
	}
	
	
	
	
	/**
	 * Экспорт данных первого отчета
	 * @param ID паттерна
	 * @return 
	 */
	public function export_payments($patternId, $variant = 1) {
		$pData = $this->reports_model->getMainReportPatterns($patternId);
		$dataToExport = $this->reports_model->buildReportPaymentsData($this->constants[$variant], $pData, true);
		setHeadersToDownload('application/octet-stream', 'windows-1251');
		echo $dataToExport;
	}
	
	
	
	
	
	
	/**
	 * Паттерн в архив
	 * @param 
	 * @return 
	 */
	public function pattern_to_archive() {
		$patternId = $this->input->post('pattern_id');
		$this->reports_model->patternToArchive($patternId);
		echo 1;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Изменить статус выплаты участника
	 * @param POST данные
	 * @return void
	 */
	public function change_paydone_stat() {
		$pData = bringTypes($this->input->post());
		if ($this->reports_model->changePayDoneStat($pData['stat'], $pData['pattern_id'], $pData['static_id'], $pData['user_id'], $pData['to_deposit'])) {
			$this->admin_model->globalDepositHistoryAdd([
				'user_id'	=> $pData['user_id'],
				'summ'		=> $pData['to_deposit'],
				'date'		=> time(),
				'reason'	=> 2,
				'stat'		=> $pData['stat'],
			]);
			echo $this->reports_model->setCashAndDaysToinfo($pData['user_id'], $pData['pattern_id'], $pData['cash'], $pData['stat']);
		} else echo 0;
	}
	
	
	
	
	
	
	/**
	 * Изменить статус выплаты участников
	 * @param 
	 * @return 
	 */
	public function change_paydone_stat_all() {
		$pData = bringTypes($this->input->post());
		if ($pData['data']) {
			foreach ($pData['data'] as $i) {
				if ($this->reports_model->changePayDoneStat($i['stat'], $i['pattern_id'], $i['static_id'], $i['user_id'], $i['to_deposit'])) {
					$this->reports_model->setCashAndDaysToinfo($i['user_id'], $i['pattern_id'], $i['cash'], $i['stat']);
				}
			}
			echo 1;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список кластеров
	 * @param 
	 * @return 
	 */
	public function get_reports_periods() {
		$periods = $this->reports_model->getReportsPeriods();
		$toOrders = $this->input->post('to_orders') || 0;
		$edit = $this->input->post('edit') || 0;
		echo $this->twig->render('views/admin/render/reports_periods_list.tpl', [
			'periods' 	=> bringTypes($periods),
			'to_orders' => $toOrders,
			'edit' 		=> $edit
		]);
	}
	
	
	
	/**
	 * Получить список вариантов отчета
	 * @param 
	 * @return 
	 */
	public function get_report_variants() {
		echo $this->twig->render('views/admin/render/reports_variants.tpl');
	}
	
	
	
	
	
	
	
	/**
	 * Добавить новый кластер
	 * @param 
	 * @return ID нового кластера
	 */
	public function new_period() {
		echo $this->twig->render('views/admin/render/new_period.tpl');
	}
	
	
	
	/**
	 * Сохранить кластер
	 * @param 
	 * @return 
	 */
	public function save_period() {
		$name = $this->input->post('name');
		echo $this->reports_model->savePeriod($name);
	}
	
	
	
	/**
	 * Задать активный период
	 * @param 
	 * @return 
	 */
	public function set_active_period() {
		$periodId = $this->input->post('id');
		$zone = $this->input->post('zone');
		$this->reports_model->setActivePeriod($periodId, $zone);
		echo 1;
	}
	
	
	
	
	/** 
	 * Получить форму для активации периода
	 * @param 
	 * @return 
	 */
	public function get_periods_activate_block() {
		$period = $this->input->get('period');
		$data = $this->reports_model->getTimerActivatePeriods($period);
		echo $this->twig->render('views/admin/render/reports_periods_activate.tpl', ['data' => $data]);
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function set_timer_activate_periods() {
		if (!$postData = $this->input->post('data')) return false;
		$period = $this->input->post('period');
		$data = [];
		foreach ($postData as $item) {
			$itemData = $item['date'] ? strtotime($item['date']) : strtotime('today');
			$itemTime = $item['time'] ? ($item['time'] * 60 * 60) : 0;
			$data[] = [
				'zone' 		=> $item['zone'],
				'time'		=> ($itemData + $itemTime),
				'period' 	=> $period
			];
		}
		if (empty($data)) exit('2');
		if (!$res = $this->reports_model->setTimerActivatePeriods($data)) exit('0');
		echo 1;
	}
	
	
	
	
	
	
	
	
	/**
	 * Закрыть период
	 * @param 
	 * @return 
	 */
	public function close_period() {
		$periodId = $this->input->post('id');
		$this->reports_model->closePeriod($periodId);
		echo 1;
	}
	
	
	
	/**
	 * Показать период в "мои посещения"
	 * @param 
	 * @return 
	 */
	public function period_to_visits() {
		$periodId = $this->input->post('id');
		$this->reports_model->periodToVisits($periodId);
		echo 1;
	}
	
	
	
	
	/**
	 * Период в архив
	 * @param 
	 * @return 
	 */
	public function period_to_archive() {
		$periodId = $this->input->post('id');
		$this->reports_model->periodToArchive($periodId);
		echo 1;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- 2 отчет
	
	public function set_orders_report() {
		if (!$this->input->is_ajax_request()) return false;
		$periodId = $this->input->post('period_id');
		
		$response = $this->reports_model->getRaidsOrders($periodId);
		echo $this->twig->render('views/admin/render/orders_report.tpl', ['orders_data' => bringTypes($response)]);
	}
	
	
	
	
	public function export_orders($periodId = null) {
		if (is_null($periodId)) exit('');
		
		//setHeadersToDownload('application/octet-stream', 'UTF-8');
		//$data = $this->reports_model->getOrdersReportPatterns($patternId);
		//toLog($data);
		
		
		$response = $this->reports_model->getRaidsOrders($periodId);
		if (!$response) exit('');
		
		
		
		//iconv('UTF-8', 'windows-1251', );
		
		
		$exportData = '';
		foreach ($response as $static => $data) {
			$exportData .= iconv('UTF-8', 'windows-1251', $static)."\r\n\r\n";
			foreach ($data as $raid) {
				$exportData .= iconv('UTF-8', 'windows-1251', 'Автор; Дата; Тип рейда')."\r\n\r\n";
				$exportData .= iconv('UTF-8', 'windows-1251', $raid['from'].';'.date('Y-m-d H:i', $raid['date']).';'.$raid['name'])."\r\n\r\n";
				$exportData .= iconv('UTF-8', 'windows-1251', 'Список заказов')."\r\n";
				foreach ($raid['orders'] as $item)  {
					$exportData .= iconv('UTF-8', 'windows-1251', $item)."\r\n";
				}
				$exportData .= "\r\n\r\n\r\n";
			}
				
		}
		
		//setHeadersToDownload('application/octet-stream', 'windows-1251');
		echo $exportData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- 3 отчет
	
	
	/**
	 * Получить список паттернов (диапазонов)
	 * @param 
	 * @return 
	 */
	public function get_patterns_list() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$reportsPatterns = $this->reports_model->getPatternsList($postData);
		echo $this->twig->render('views/admin/render/patterns_to_choose.tpl', ['patterns_list' => bringTypes($reportsPatterns), 'append' => $postData['offset'] > 0]);
	}
	
	
	
	
	/**
	 * Сформировать 3 отчет
	 * @param POST данные: ID паттернов
	 * @return 
	 */
	public function build_payments_patterns_report() {
		$patterns = $this->input->post('patterns');
		$response = $this->reports_model->buildPaymentsPatternsReport($patterns);
		echo $this->twig->render('views/admin/render/payment_patterns_report.tpl', ['patterns' => bringTypes($response['patterns']), 'data' => bringTypes($response['data'])]);
	}
	
	
	
	
	/**
	 * Экспорт 3 отчета
	 * @param 
	 * @return 
	 */
	public function download_payments_patterns_report($patterns = false) {
		$patterns = explode('|', $patterns);
		$response = $this->reports_model->buildPaymentsPatternsReport($patterns);
		
		$exportData = '';
		
		foreach ($response['data'] as $static => $users) {
			$exportData .= iconv('UTF-8', 'windows-1251', $static)."\r\n";
			$exportData .= iconv('UTF-8', 'windows-1251', 'Никнейм; Резерв; Не выплачено; Платежные реквизиты')."\r\n";
			foreach ($users as $user) {
				$exportData .= iconv('UTF-8', 'windows-1251', $user['nickname'].';'.str_replace('.', ',', $user['deposit']).';'.str_replace('.', ',', $user['debit']).';'.$user['pay_method'])."\r\n";
			}
			$exportData .= "\r\n\r\n";
		}
		echo $exportData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- Заявки на оплату
	
	
	/**
	 * Получить список участников для оформления заявки на оплату
	 * @param 
	 * @return 
	 */
	public function get_users() {
		$query = $this->input->post('query') ?: false;
		$start = $this->input->post('start') ?: false;
		$this->load->model('users_model');
		
		$params = $query ? ['where' => ['us.main' => 1], 'like' => ['field' => 'u.nickname', 'value' => $query, 'placed' => 'both']] : ['where' => ['us.main' => 1]];
		if ($usersData = $this->users_model->getUsers($params)) {
			$statics = $this->admin_model->getStatics();
			foreach($usersData as $k => $user) {
				$usersData[$k]['static_id'] = $user['static'];
				$usersData[$k]['static'] = [
					'name' => isset($statics[$user['static']]['name']) ? $statics[$user['static']]['name'] : 'Статик удален',
					'icon' => isset($statics[$user['static']]['icon']) ? $statics[$user['static']]['icon'] : 'Общее/deleted_mini.jpg'
				];
			}
		}
		
		if (!$this->input->is_ajax_request()) return $usersData;
		echo $this->twig->render('views/admin/render/users_list', ['users' => $usersData, 'start' => $start]);
	}
	
	
	
	
	
	/**
	 * Получить список участников для оформления заявки на оплату
	 * @param 
	 * @return 
	 */
	public function get_pay_blank() {
		$post = $this->input->post();
		echo $this->twig->render('views/admin/render/users_list', ['data' => $post, 'blank' => 1]);
	}
	
	
	/**
	 * Добавить заявки на оплату
	 * @param 
	 * @return 
	 */
	public function set_users_orders() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		
		$this->load->model('users_model');
		$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $data['users']], 'fields' => 'id, nickname, avatar, payment, deposit, static, lider']);
		
		/*if (isset($data['to_deposit']) && $data['to_deposit']) {
			$staticsData = $this->admin_model->getStatics();
			$percentToDeposit = $this->admin_model->getSettings('payment_requests_deposit_percent');
		}*/
		
		$orders = []; $toWalletData = []; $date = time();
		//$toDepositData = [];
		foreach ($usersData as $user) {
			/*if (isset($data['to_deposit']) && $data['to_deposit']) {
				$limit = $user['lider'] ? $staticsData[$user['static']]['cap_lider'] : $staticsData[$user['static']]['cap_simple']; // лимит депозита
				$canSetToDeposit = $limit - $user['deposit'] > 0 ? $limit - $user['deposit'] : 0;
				
				$summToDeposit = ($data['summ'] / 100) * $percentToDeposit; // сумма в депозит
				
				$summToDeposit = $canSetToDeposit >= $summToDeposit ? $summToDeposit : $canSetToDeposit;
				$summToOrder = $data['summ'] - $summToDeposit; // сумма в оплату
				
				$toDepositData[$user['id']] = $summToDeposit; 
			} else {
				$summToOrder = $data['summ'];
				$summToDeposit = 0;
			}*/
			
			$summToOrder = (float)$data['summ'];
			$summToDeposit = 0;
			
			
			$orders[] = [
				'user_id'		=> $user['id'],
				'nickname' 		=> $user['nickname'],
				'avatar' 		=> $user['avatar'],
				'payment' 		=> $user['payment'],
				'static' 		=> $user['static'],
				'order' 		=> $data['order'],
				'summ' 			=> $summToOrder,
				'to_deposit' 	=> $summToDeposit,
				'comment' 		=> $data['comment'],
				'date'			=> $date
			];
			
			
			if (!isset($toWalletData[$user['id']])) {
				$toWalletData[$user['id']]['amount'] = $summToOrder;
				$toWalletData[$user['id']]['to_deposit'] = $summToDeposit;
			} else {
				$toWalletData[$user['id']]['amount'] += $summToOrder;
				$toWalletData[$user['id']]['to_deposit'] += $summToDeposit;
			}
		}
		
		$this->load->model('wallet_model');
		$this->wallet_model->setToWallet($toWalletData, 5, $data['order'], '+');
		
		if (!$this->reports_model->insertUsersOrders($orders)) exit('0');
		$this->adminaction->setAdminAction(5, ['type' => 'simple', 'order' => $data['order'], 'users' => $orders]);
		//if (isset($data['to_deposit']) && $data['to_deposit']) $this->users_model->setUsersDeposit($toDepositData);
		echo json_encode('1');
	}
	
	
	
	
	
	
	
	/**
	 * Изменить статус расчета с участником
	 * @param 
	 * @return 
	 */
	public function change_paymentrequest_stat() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		
		$userId = $data['user_id'];
		$cash = $data['summ'];
		$stat = $data['paid'];
		$this->reports_model->setCashAndDaysToinfo($userId, false, $cash, $stat);
		
		if (!$this->reports_model->changePaymentrequestStat($data)) exit('0');
		echo json_encode('1');
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function paymentrequests_save_summ() {
		$data = $this->input->post();
		if (!$this->reports_model->paymentRequestsUpdateSumm($data['id'], $data['summ'])) exit('0');
		echo '1';
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function paymentrequests_remove() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		if (!$this->reports_model->paymentRequestsRemove($id)) exit('0');
		echo '1';
	}
	
	
	
	
	/**
	 * Экспорт заявок на оплату в CSV
	 * @param 
	 * @return 
	 */
	public function paymentrequest_export() {
		$dataToExport = '';
		
		if ($paymentRequests = $this->reports_model->getPaymentRequests(false, true)) {
			$statics = $this->admin_model->getStatics();
			foreach($paymentRequests as $k => $pr) {
				$paymentRequests[$k]['static'] = $statics[$pr['static']]['name'];
			}
		} else {
			exit($dataToExport);
		}
		
		$dataToExport .= iconv('UTF-8', 'windows-1251', 'Никнейм;Сумма заказа (руб);Способ оплаты')."\r\n";
		foreach ($paymentRequests as $pr) {
			$dataToExport .= iconv('UTF-8', 'windows-1251', $pr['nickname'].';'.str_replace('.', ',', $pr['summ']).';'.$pr['payment']);
			$dataToExport .= "\r\n";
		}
		
		setHeadersToDownload('application/octet-stream', 'windows-1251');
		echo $dataToExport;
	}
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- Рассчет окладов
	
	/**
	 * @param 
	 * @return 
	*/
	public function get_periods_to_salary() {
		if (!$this->input->is_ajax_request()) return false;
		$data['periods'] = $this->reports_model->getReportsPeriods();
		echo $this->twig->render('views/admin/render/salary/periods.tpl', $data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get_salary_form() {
		if (!$this->input->is_ajax_request()) return false;
		$periodId = $this->input->post('period_id');
		$periodTitle = $this->input->post('period_title');
		$data['statics'] = $this->admin_model->getStatics();
		$data['data'] = $this->reports_model->getCoeffsToSalary($periodId);
		$data['period_title'] = $periodTitle;
		
		echo $this->twig->render('views/admin/render/salary/form.tpl', $data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function calc_salary_orders() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		if (!$orders = $this->reports_model->getSalaryOrders($data, false, true)) exit('');
		
		$calcData = [];
		$statics = $this->admin_model->getStatics(true);
		foreach ($orders['orders'] as $item) {
			$static = arrTakeItem($item, 'static');
			$calcData[$static][] = $item;
		}
		
		echo $this->twig->render('views/admin/render/salary/calc.tpl', ['data' => $calcData, 'total' => $orders['total'], 'statics' => $statics]);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function set_salary_orders() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		if (!$orders = $this->reports_model->getSalaryOrders($data, true)) exit('0');
		if (!$this->reports_model->insertUsersOrders($orders)) exit('0');
		$this->adminaction->setAdminAction(5, ['type' => 'salary_orders', 'order' => $data['order'], 'users' => $orders]);
		echo '1';
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- Дополнительные выплаты
	
	/**
	 * @param 
	 * @return 
	*/
	public function get_addictpay_form() {
		if (!$this->input->is_ajax_request()) return false;
		$data['statics'] = $this->admin_model->getStatics();
		echo $this->twig->render('views/admin/render/addictpay/form.tpl', $data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function calc_addictpay() {
		$post = $this->input->post();
		$this->load->model(['users_model', 'admin_model']);
		
		$stopListUsersIds = false;
		if ($stopList = $this->admin_model->getStopList('addictpay')) { // получить стоп-лист участников для дополнительных выплат
			$stopListUsersIds = array_column($stopList, 'item_id');
		}
		
		$params = ['where_in' => ['field' => 'us.static_id', 'values' => $post['statics']], 'where' => ['us.main' => 1, 'u.deleted' => 0, 'u.verification' => 1]];
		if ($stopListUsersIds) $params['where_not_in'] = ['field' => 'u.id', 'values' => $stopListUsersIds];
		$usersData = $this->users_model->getUsers($params);
		
		$ranks = $this->admin_model->getRanks();
		$statics = $this->admin_model->getStatics();
		
		$users = []; $totals = [];
		foreach ($usersData as $user) {
			$toDeposit = $post['to_deposit'] ? (((int)$ranks[$user['rank']]['additional_pay'] / 100) * (int)$statics[$user['static']]['deposit_percent']) : 0; // сумма в депозит
			$summ = $post['to_deposit'] ? ((int)$ranks[$user['rank']]['additional_pay'] - $toDeposit) : (int)$ranks[$user['rank']]['additional_pay'];
			
			if (!isset($totals[$user['static']]) && $user['agreement']) $totals[$user['static']] = $summ;
			elseif ($user['agreement']) $totals[$user['static']] += $summ;
			
			$users[$user['static']][] = [
				'user_id'		=> $user['id'],
				'nickname' 		=> $user['nickname'],
				'agreement' 	=> $user['agreement'],
				'avatar' 		=> $user['avatar'],
				'rank' 			=> $ranks[$user['rank']]['name'],
				'summ' 			=> $summ,
				'to_deposit'	=> $toDeposit
			];
		}
		
		$data['users_data'] = $users;
		$data['statics'] = $statics;
		$data['totals'] = $totals;
		
		echo $this->twig->render('views/admin/render/addictpay/orders.tpl', $data);
	}
	
	
	
	
	
	
	/**
	 * Отправить в заявки на оплаты
	 * @param 
	 * @return 
	*/
	public function set_addictpay_orders() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		if (!$data['users']) exit('0');
		
		$usersIds = array_column($data['users'], 'user');
		$this->load->model('users_model');
		$usersData = $this->users_model->getUsers(['where_in' => ['field' => 'u.id', 'values' => $usersIds, 'where' => ['us.main' => 1, 'u.deleted' => 0, 'u.verification' => 1]]]);
		$usersData = setArrKeyFromField($usersData, 'id');
		
		
		$orders = []; $toWalletData = [];
		//$toDepositData = [];
		foreach ($data['users'] as $user) {
			//$toDepositData[$user['user']] = $user['to_deposit']; 
			
			$orders[] = [
				'user_id'		=> $user['user'],
				'nickname' 		=> $usersData[$user['user']]['nickname'],
				'avatar' 		=> $usersData[$user['user']]['avatar'],
				'payment' 		=> $usersData[$user['user']]['payment'],
				'static' 		=> $usersData[$user['user']]['static'],
				'order' 		=> $data['order'],
				'summ' 			=> $user['summ'],
				'to_deposit' 	=> $user['to_deposit'],
				'comment' 		=> $data['comment'],
				'date'			=> time()
			];
			
			if (!isset($toWalletData[$user['user']])) {
				$toWalletData[$user['user']]['amount'] = (float)$user['summ'];
				$toWalletData[$user['user']]['to_deposit'] = (float)$user['to_deposit'];
			} else {
				$toWalletData[$user['user']]['amount'] += (float)$user['summ'];
				$toWalletData[$user['user']]['to_deposit'] += (float)$user['to_deposit'];
			}
		}
		
		$this->load->model('wallet_model');
		$this->wallet_model->setToWallet($toWalletData, 5, $data['order'], '+');
		
		if (!$this->reports_model->insertUsersOrders($orders)) exit('0');
		$this->adminaction->setAdminAction(5, ['type' => 'addictpay_orders', 'order' => $data['order'], 'users' => $orders]);
		//if ($data['to_deposit']) $this->users_model->setUsersDeposit($toDepositData);
		echo '1';
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- Ключи
	
	
	/**
	 * Формирование отчета по ключам
	 * @param POST data или нет
	 * @return 
	 */
	public function get_keys_report() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		
		if (isset($postData['pattern_id'])) {
			$data = $this->reports_model->getMainReportPatterns($postData['pattern_id'], null, 1);
		} else {
			$postData['cash'] = json_decode($postData['cash'], true);
			$data = $postData;
		}
		
		// Если Для пользователя - получить список его статиков и передать в функцию
		$data['statics'] = null;
		if (isset($postData['to_user'])) {
			$this->load->model('account_model');
			if (!$userData = $this->account_model->getUserData()) exit('');
			$data['statics'] = is_array($userData['statics']) ? array_keys($userData['statics']) : null;
		}
		$keysReportData = $this->_buildKeysReport($data);
		$keysReportData['pattern_id'] = isset($postData['pattern_id']) ? $postData['pattern_id'] : null;
		$keysReportData['to_user'] = isset($postData['to_user']) ? $userData['id'] : false;
		$keysReportData['statics'] = isset($postData['to_user']) ? $userData['statics'] : false;
		
		if ($keysReportData['to_user']) echo $this->twig->render('views/account/render/keys_report.tpl', $keysReportData);
		else echo $this->twig->render('views/admin/render/keys_report.tpl', $keysReportData);
	}
	
	
	
	
	
	
	/**
	 * Формирование данных первого отчета
	 * @param 
	 * @return 
	 */
	private function _buildKeysReport($data) {
		return [
			'raids'		=> $this->reports_model->getKeys($data),
			'report'	=> $this->reports_model->buildReportPaymentsKeysData($data, false)
		];
	}
	
	
	
	
	
	
	
	/**
	 * Сохранение паттерна первого отчета
	 * @param 
	 * @return 
	 */
	public function save_keys_report_pattern() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$postData['cash'] = json_decode($postData['cash'], true);
		$this->reports_model->saveKeysReportPattern($postData);
		echo 1;
	}
	
	
	
	

	/**
	 * Получение списка паттернов для первого отчета
	 * @param 
	 * @return 
	 */
	public function get_keys_reports_patterns() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		if (!$reportsPatterns = $this->reports_model->getMainReportPatterns(null, $postData, 1)) exit('');
		if (isset($postData['to_user']) && $postData['to_user']) {
			echo $this->twig->render('views/account/render/reports_patterns.tpl', [
				'reports_patterns' 	=> bringTypes($reportsPatterns),
				'statics'			=> $this->admin_model->getStatics(),
				'is_key'			=> $postData['is_key']
			]);
		} else {
			echo $this->twig->render('views/admin/render/reports_patterns.tpl', [
				'reports_patterns' 	=> bringTypes($reportsPatterns),
				'statics'			=> $this->admin_model->getStatics(),
				'is_key'			=> 1
			]);
		}
	}
	
	
	
	
	/**
	 * Экспорт данных первого отчета
	 * @param ID паттерна
	 * @return 
	 */
	public function export_keys_payments($patternId) {
		$pData = $this->reports_model->getMainReportPatterns($patternId, null, 1);
		$dataToExport = $this->reports_model->buildReportPaymentsKeysData($pData, true);
		setHeadersToDownload('application/octet-stream', 'windows-1251');
		echo $dataToExport;
	}
	
	
	
	
	
	
	/**
	 * Паттерн в архив
	 * @param 
	 * @return 
	 */
	public function pattern_key_to_archive() {
		$patternId = $this->input->post('pattern_id');
		$this->reports_model->patternToArchive($patternId);
		echo 1;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Изменить статус выплаты участника
	 * @param POST данные
	 * @return void
	 */
	public function change_paydone_key_stat() {
		$pData = bringTypes($this->input->post());
		if ($this->reports_model->changePayDoneStat($pData['stat'], $pData['pattern_id'], $pData['static_id'], $pData['user_id'])) {
			echo $this->reports_model->setCashAndDaysToinfo($pData['user_id'], $pData['pattern_id'], $pData['cash'], $pData['stat'], true);
		} else echo 0;
	}
	
	
	
	
	
	
	/**
	 * Изменить статус выплаты участников
	 * @param 
	 * @return 
	 */
	public function change_paydone_key_stat_all() {
		$pData = bringTypes($this->input->post());
		if ($pData['data']) {
			foreach ($pData['data'] as $i) {
				if ($this->reports_model->changePayDoneStat($i['stat'], $i['pattern_id'], $i['static_id'], $i['user_id'])) {
					$this->reports_model->setCashAndDaysToinfo($i['user_id'], $i['pattern_id'], $i['cash'], $i['stat'], true);
				}
			}
			echo 1;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- Выплата баланса
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function wallet($action = false, $reportId = false) {
		if (!$reportId && !$this->input->is_ajax_request()) return false;
		if (!$action) return false;
		$this->load->model('wallet_model', 'wallet');
		$postData = bringTypes($this->input->post());
		
		switch ($action) {
			case 'get_params_to_build': // окно с выбором параметров для формирования списка выплат
				$this->load->model('admin_model', 'admin');
				$data['statics'] = $this->admin->getStatics(true);
				$data['ranks'] = $this->admin->getRanks(false, true);
				$data['roles'] = $this->admin->getRoles(true);
				
				echo $this->twig->render('views/admin/render/wallet/build_list_params.tpl', $data);
				break;
				
			case 'build_payments': // сформировать список сумм
				if (!$data = $this->wallet->buildWalletPayments($postData)) exit('');
				echo $this->twig->render('views/admin/render/wallet/report.tpl', $data);
				break;
			
			case 'get_save_blank':
				$hasNoPayReports = $this->wallet->hasNoPayReports();
				if ($hasNoPayReports) exit('');
				echo $this->twig->render('views/admin/render/wallet/save_blank.tpl');
				break;
			
			case 'save_report':
				if (!isset($postData['paydata']) || !$postData['paydata']) exit('-1');
				if (!$postData['title']) exit('-2');
				if (($reportId = $this->wallet->saveWalletReportTitle($postData['title'])) < 0) exit((string)$reportId);
				
				$usersIds = array_column($postData['paydata'], 'user_id');
				if ($usersIds) {
					$this->load->model('users_model', 'users');
					$usersStatics = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $usersIds], 'where' => ['us.main' => 1], 'fields' => 'static']);
				}
				
				$toReportData = [];
				foreach ($postData['paydata'] as $payUser) {
					$wallet = (float)$payUser['wallet'];
					$deposit = (float)$payUser['deposit'];
					$amountSumm = (float)$payUser['payout'];
					$depositSumm = (float)$payUser['to_deposit'];
					$userId = (int)$payUser['user_id'];
					
					
					$toReportData[] = [
						'report_id'		=> $reportId,
						'user_id'		=> $userId,
						'static_id'		=> isset($usersStatics[$userId]) ? $usersStatics[$userId] : 0,
						'wallet'		=> $wallet,
						'deposit'		=> $deposit,
						'summ'			=> $amountSumm,
						'to_deposit'	=> $depositSumm,
					];
				}
				
				
				// Отправить данные в сохраненный отчет
				if ($toReportData) $this->wallet->saveWalletReportData($toReportData);
				
				echo '1';
				break;
				
			case 'set_payout': // выплатить суммы и сохранить отчет
				$reportId = (int)$postData['report_id'];
				$paydata = $this->wallet->getReportData($postData['report_id']); // Получить данные из сохраненного очета
				
				
				$amountsData = []; $toDepositdata = []; $toReportData = [];
				foreach ($paydata as $staticId => $users) foreach ($users as $userId => $payUser) {
					$amountSumm = (float)$payUser['summ'];
					$depositSumm = (float)$payUser['to_deposit'];
					//$amountCurrencySumm = (float)$payUser['summ'] * (float)$postData['currency'];
					//$depositCurrencySumm = (float)$payUser['to_deposit'] * (float)$postData['currency'];
					
					if ($amountSumm > 0) {
						$amountsData[$userId] = [
							'amount'		=> $amountSumm,
							'to_deposit'	=> $depositSumm,
						];
					} 
					
					if ($depositSumm > 0) $toDepositdata[$userId] = $depositSumm;
					
					$toReportData[] = [
						'report_id'		=> $reportId,
						'user_id'		=> $userId,
						'static_id'		=> $staticId ?: 0,
						'summ'			=> $amountSumm,
						'to_deposit'	=> $depositSumm,
					];
				}
				
				if ($this->walletReportToLog) {
					toLog('--------- Списание баланса -----------');
					toLog('Отправить данные в сохраненный отчет');
					toLog($toReportData);
				}
					
				// Отправить данные в сохраненный отчет
				if ($toReportData) $this->wallet->saveWalletReportData($toReportData);
				
				if ($this->walletReportToLog) {
					toLog('--------- Списание баланса -----------');
					toLog('отправить выплаты в историю');
					toLog($amountsData);
				}
					
				// отправить выплаты в историю
				if ($amountsData) $this->wallet->setToWallet($amountsData, null, $postData['title'], '-', (float)$postData['currency']);
				
				if ($this->walletReportToLog) {
					toLog('--------- Списание баланса -----------');
					toLog('отправить в резерв');
					toLog($toDepositdata);
				}
					
				// отправить в резерв
				if ($toDepositdata) $this->wallet->updateUsersDeposit($toDepositdata);
				
				// Сохранить курс для текущего отчета
				$this->wallet->setWalletReportCurrency($reportId, (float)$postData['currency']);
				
				// Установить статус отчета "Выплачен"
				$this->wallet->setPaidReport($reportId);
				
				echo '1';
				break;
			
			case 'get_reports': // получить список сохраненных отчетов по выплатам
				$data['reports'] = $this->wallet->getReports();
				echo $this->twig->render('views/admin/render/wallet/reports_list.tpl', $data);
				break;
			
			case 'get_saved_report': // Сформировать отчет / Экспортировать отчет
				$this->load->model('admin_model', 'admin');
				if (!$report = $this->wallet->getReportData($postData['report_id'] ?: $reportId)) exit('');
				
				$data['statics'] = $this->admin->getStatics(true, array_keys($report));
				
				if ($reportId) {
					$dataToExport = '';
					foreach ($report as $staticId => $users) {
						$dataToExport .= iconv('UTF-8', 'windows-1251', 'Статик'."\r\n");
						$dataToExport .= $data['statics'][$staticId]."\r\n";
						
						$dataToExport .= iconv('UTF-8', 'windows-1251', 'Никнейм;Выплата;Отправлено в резерв;Платежные данные')."\r\n";
						foreach ($users as $userId => $userData) {
							$dataToExport .= iconv('UTF-8', 'windows-1251', $userData['nickname'].';'.str_replace('.', ',', $userData['summ']).';'.str_replace('.', ',', $userData['to_deposit']).';'.str_replace('.', ',', $userData['payment']))."\r\n";
						}
						$dataToExport .= "\r\n";
					}
					
					setHeadersToDownload('application/octet-stream', 'windows-1251');
					exit($dataToExport);
				}
				
				$isPaid = $this->wallet->isPaidReport($postData['report_id']);
				if ($isPaid) {
					$data['report_currency'] = $this->wallet->getWalletReportCurrency($postData['report_id']);
					$data['paid'] = 1;
				}
				
				$data['report'] = $report;
				echo $this->twig->render('views/admin/render/wallet/saved_report.tpl', $data);
				break;
			
			case 'get_user_history': // получить историю кошелька участника
				$userId = $this->input->post('user_id');
				$data = $this->wallet->getUserHistory($userId);
				echo $this->twig->render('views/admin/render/wallet/history.tpl', $data);
				break;
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------ Заполнить таблицу с суммами выплат РЛ
	
	/**
	 * @param 
	 * @return 
	*/
	public function raidliderspay($action = false) {
		if (!$this->input->is_ajax_request()) return false;
		if (!$action) return false;
		$postData = bringTypes($this->input->post());
		
		switch ($action) {
			case 'form':
				$this->load->model('admin_model', 'admin');
				$data['statics'] = $this->admin->getStatics();
				$data['ranks'] = $this->admin->getRanks();
				$data['ranks_liders'] = $this->admin->getRanksLiders();
				$data['summs'] = $this->reports_model->getRraidLiderPaySumms();
				echo $this->twig->render('views/admin/render/raid_liders_pays', $data);
				break;
			
			case 'save':
				if (!$this->reports_model->saveRaidLiderPaySumm($postData)) exit('0');
				echo '1';
				break;
			
			case 'pay_form':
				$this->load->model(['users_model' => 'users', 'admin_model' => 'admin']);
				
				$lidersIds = $this->users->getRaidLiders(true);
				$usersData = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $lidersIds], 'where' => ['u.deleted' => 0, 'u.verification' => 1, 'us.main' => 1], 'fields' => 'id nickname avatar rank rank_lider static']);
				
				$lidersData = [];
				if ($usersData) {
					foreach ($usersData as $user) {
						$static = arrTakeItem($user, 'static');
						$liderId = arrTakeItem($user, 'id');
						$lidersData[$static][$liderId] = $user;
					}
				}
				
				$data['raidliders'] = $lidersData;
				$data['ranks'] = $this->admin->getRanks();
				$data['ranks_liders'] = $this->admin->getRanksLiders();
				$data['statics'] = $this->admin->getStatics();
				$data['summs'] = $this->reports_model->getRraidLiderPaySumms();
				echo $this->twig->render('views/admin/render/raid_liders_form', $data);
				break;
			
			case 'payout':
				if (!$postData['liders']) exit('0');
				$lidersIds = array_column($postData['liders'], 'user_id');
				$this->load->model('users_model', 'users');
				$usersData = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $lidersIds]]);
				$usersData = setArrKeyFromField($usersData, 'id');
				
				
				$orders = []; $toWalletData = [];
				foreach ($postData['liders'] as $user) {
					$orders[] = [
						'user_id'		=> $user['user_id'],
						'nickname' 		=> $usersData[$user['user_id']]['nickname'],
						'avatar' 		=> $usersData[$user['user_id']]['avatar'],
						'payment' 		=> $usersData[$user['user_id']]['payment'],
						'static' 		=> $usersData[$user['user_id']]['static'],
						'order' 		=> $postData['order'],
						'summ' 			=> $user['summ'],
						'to_deposit' 	=> 0,
						'comment' 		=> $postData['comment'],
						'date'			=> time()
					];
					
					if (!isset($toWalletData[$user['user_id']])) {
						$toWalletData[$user['user_id']]['amount'] = (float)$user['summ'];
						$toWalletData[$user['user_id']]['to_deposit'] = 0;
					} else {
						$toWalletData[$user['user']]['amount'] += (float)$user['summ'];
						$toWalletData[$user['user']]['to_deposit'] += 0;
					}
				}
				
				$this->load->model('wallet_model');
				$this->wallet_model->setToWallet($toWalletData, 5, $postData['order'], '+');
				
				if (!$this->reports_model->insertUsersOrders($orders)) exit('0');
				$this->adminaction->setAdminAction(5, ['type' => 'raidliders_orders', 'order' => $postData['order'], 'users' => $orders]);
				echo '1';
				break;
				
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function importpaymentrequests($action = false) {
		$post = bringTypes($this->input->post());
		$importedFile = bringTypes($this->input->files('file')) ?? false;
		switch ($action) {
			case 'submit':
				echo jsonResponse($this->reports_model->importPaymentRequests('insertData', $post));
				break;
			
			default:
				$response = $this->reports_model->importPaymentRequests(['imported_file' => $importedFile]);
				if (is_numeric($response)) exit($response);
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanks();
				$data['import_data'] = $response;
				echo $this->twig->render($this->viewsPath.'imported_data_form.tpl', $data);
				break;
		}
		
	}
	
	
		
	
	
	
	
	
}