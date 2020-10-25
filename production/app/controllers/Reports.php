<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Reports extends MY_Controller {
	
	protected $constants;
	
	public function __construct() {
		parent::__construct();
		$this->load->model(['reports_model', 'admin_model', 'account_model']);
		
		$constData = $this->admin_model->getSettings('constants');
		$this->constants = [
			'cVisits' 			=> $constData['visits'],
			'cPersons' 			=> $constData['persons'],
			'cEffectiveness'	=> $constData['effectiveness'],
			'cFine' 			=> $constData['fine']
		];
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
	private function buildMainReport($data) {
		return [
			'raids'		=> $this->reports_model->getRaids($data),
			'report'	=> $this->reports_model->buildReportPaymentsData($this->constants, $data, false)
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
		$this->reports_model->saveMainReportPattern($postData, $this->constants);
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
		if (!$reportsPatterns = $this->reports_model->getMainReportPatterns(null, $postData, 2)) exit('');
		
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
	public function export_payments($patternId) {
		$pData = $this->reports_model->getMainReportPatterns($patternId);
		$dataToExport = $this->reports_model->buildReportPaymentsData($this->constants, $pData, true);
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
	 * Закрыть период
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
		$data = $this->input->post();
		$this->load->model('users_model');
		$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $data['users']]]);
		
		$orders = array_map(function($item) use ($data) {
			return [
				'user_id'	=> $item['id'],
				'nickname' 	=> $item['nickname'],
				'avatar' 	=> $item['avatar'],
				'payment' 	=> $item['payment'],
				'static' 	=> $item['static'],
				'order' 	=> $data['order'],
				'summ' 		=> $data['summ'],
				'comment' 	=> $data['comment'],
				'date'		=> time()
			];
		}, $usersData);
		
		if (!$this->reports_model->insertUsersOrders($orders)) exit('0');
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
	
	
	
	
	
	
	
	
	
	
}