<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Wallet_model extends MY_Model {
	
	private $walletHistoryTable = 'wallet_history';
	private $walletTitlesTable = 'wallet_titles';
	private $walletAmountsTable = 'wallet_amounts';
	private $walletCumulativeTable = 'wallet_cumulative';
	private $walletReportsTable = 'wallet_reports';
	private $walletReportsDataTable = 'wallet_reports_data';
	private $walletCurrencyTable = 'wallet_currency';
	
	private $types = [
		-2 => 'Корректировка',
		-1 => 'Отмена выплаты',
		1 => 'Сдельная выплата',
		2 => 'Премиальная выплата',
		3 => 'Ключи',
		4 => 'Премии',
		5 => 'Заявки на оплату',
		6 => 'KPI',
		7 => 'Подарок'
	];

	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	/**
	 * Внести данные в баланс кошельков \ выплатить из баланса кошельков
	 * @param платежные данные [user_id => summ]
	 * @param тип (откуда приход)
	 * @param название отчета или заявки на оплату
	 * @param + Приход \ - уход \ false без изменения саммы в балансе
	 * @param amountType на какой баланс кинуть wallet cumulative
	 * @return bool
	*/
	public function setToWallet($items = false, $type = false, $title = false, $transfer = '+', $currency = null, $amountType = 'wallet') {
		if (!$items || $type === false || !$title) return false;
		if (!$titleId = $this->_addTitle($title)) return false;
		
		$toHistoryData = []; $toAmountsData = [];
		$date = time();
		foreach ((array)$items as $userId => $item) {
			$summ = isset($item['amount']) ? round((float)$item['amount'], 1) : (($item === 0 || is_numeric($item)) ? (float)$item : 0);
			$deposit = isset($item['to_deposit']) ? round((float)$item['to_deposit'], 1) : 0;
			
			$toHistoryData[] = [
				'user_id'		=> $userId,
				'type'			=> $type,
				'title_id'		=> $titleId,
				'summ'			=> $summ,
				'deposit'		=> $deposit,
				'transfer'		=> $transfer,
				'currency'		=> $currency,
				'date'			=> $date,
				'is_cumulative'	=> $amountType == 'cumulative' ? 1 : 0,
			];
			
			// если плата - то вычитается и сумма и резерв, если зачисление - то только сумма
			$amount = $transfer == '-' ? $summ+$deposit : $summ;
			
			$toAmountsData[] = [
				'user_id'	=> $userId,
				'summ'		=> $amount,
			];
		}
		
		
		$this->_addToHistory($toHistoryData); // Добавить записи в историю
		if ($transfer !== false) $this->_addToAmounts($toAmountsData, $transfer, $amountType); // Прибавить \ отнять суммы у участников
		
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * Сформировать список сумм участников
	 * @param 
	 * @return 
	*/
	public function buildWalletPayments($usersParams = false) {
		if (!$amountsData = $this->_getAmountsData()) return false;
		$usersParams['users'] = array_keys($amountsData);
		$this->load->model('admin_model');
		
		if (!$usersData = $this->_getUsersData($usersParams)) return false;
		
		$statics = $this->admin_model->getStatics();
		
		$walletPaymentsData = []; $staticsToReport = [];
		foreach ($usersData as $userId => $user) {
			$staticId = arrTakeItem($user, 'static');
			$walletBalance = (float)$amountsData[$userId];
			$depositLimit = $user['lider'] ? (float)$statics[$staticId]['cap_lider'] : (float)$statics[$staticId]['cap_simple'];
			$percentToDeposit = (float)$statics[$staticId]['deposit_percent'];
			$maxSummToDeposit = $depositLimit - (float)$user['deposit'];
			$summToDeposit = $walletBalance > 0 ? ($walletBalance * ($percentToDeposit / 100)) : 0;
			
			$summToDeposit = ($maxSummToDeposit > 0 && $summToDeposit > 0) ? ($summToDeposit < $maxSummToDeposit ? $summToDeposit : $maxSummToDeposit) : 0;
			
			$user['wallet_balance'] = $walletBalance;
			$user['payout'] = round($walletBalance - $summToDeposit, 1);
			$user['to_deposit'] = round($summToDeposit, 1); 
			$user['percent_to_deposit'] = $percentToDeposit; 
			$user['max_to_deposit'] = round($maxSummToDeposit, 1); 
			$walletPaymentsData[$staticId][$userId] = $user;
			$staticsToReport[$staticId] = $statics[$staticId];
		}
		
		$data['statics'] = $staticsToReport;
		$data['wallet_data'] = $walletPaymentsData;
		$data['users'] = $usersParams['users'];
		return $data;
	}
	
	
	
	
	
	
	
	
	/**
	 * Обновить депозит участников
	 * @param данные в депозит участников: [user_id => summ]
	 * @return bool
	*/
	public function updateUsersDeposit($depositData = false) {
		if (!$depositData) return false;
		$this->db->select('id, deposit');
		$this->db->where_in('id', array_keys($depositData));
		if (!$tableDeposts = $this->_result('users')) return false;
		$tableDeposts = setArrKeyFromField($tableDeposts, 'id', 'deposit');
		
		$updateData = []; 
		foreach ($depositData as $userId => $deposit) {
			$toDeposit = isset($tableDeposts[$userId]) ? round((float)$tableDeposts[$userId] + (float)$deposit, 1) : round((float)$deposit, 1);
			$updateData[] = [
				'id' 		=> $userId,
				'deposit' 	=> $toDeposit
			];
		}
		
		if ($updateData) $this->db->update_batch('users', $updateData, 'id');
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * Сохранить название отчета и вернуть ID
	 * @param Название отчета
	 * @return ID сохраненного отчета
	*/
	public function saveWalletReportTitle($reportTitle = false) {
		if (!$reportTitle) return -1;
		$this->db->where('title', $reportTitle);
		if ($this->db->count_all_results($this->walletReportsTable) > 0) return -2;
		if (!$this->db->insert($this->walletReportsTable, ['title' => $reportTitle, 'date' => time()])) return -3;
		return $this->db->insert_id();
	}
	
	
	
	/**
	 * Сохранить данные отчета
	 * @param 
	 * @return 
	*/
	public function saveWalletReportData($toReportData = false) {
		if (!$toReportData) return false;
		$this->db->insert_batch($this->walletReportsDataTable, $toReportData);
		return true;
	}
	
	
	
	
	
	/**
	 * Получить список отчетов по оплатам
	 * @param 
	 * @return 
	*/
	public function getReports() {
		$this->db->order_by('id', 'DESC');
		if (!$reports = $this->_result($this->walletReportsTable)) return false;
		return $reports;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getReportData($reportId = false) {
		if (!$reportId) return false;
		$this->db->select('user_id, static_id, wallet, deposit, summ, to_deposit');
		$this->db->where('report_id', $reportId);
		if (!$data = $this->_result($this->walletReportsDataTable)) return false;
		$data = setArrKeyFromField($data, 'user_id');
		$usersIds = array_keys($data);
		
		$this->load->model('users_model', 'users');
		$usersData = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $usersIds], 'where' => ['us.main' => 1], 'fields' => 'nickname avatar static payment']);
		
		if (!$fullData = array_replace_recursive($usersData, $data)) return false;
		
		
		$dataToReport = [];
		foreach ($fullData as $userId => $item) {
			
			$reportStatic = arrTakeItem($item, 'static_id');
			$userStatic = arrTakeItem($item, 'static');
			
			$static = $reportStatic ?: $userStatic;
			
			$dataToReport[$static][$userId] = $item;
		}
		
		setAjaxHeader('paid', $this->isPaidReport($reportId));
		return $dataToReport;
	}
	
	
	
	
	
	
	
	
	/**
	 * Есть ли невыплаченные отчеты
	 * @param 
	 * @return 
	 */
	public function hasNoPayReports() {
		$this->db->where('paid', 0);
		return !!$this->db->count_all_results($this->walletReportsTable);
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function isPaidReport($reportId = false) {
		if (!$reportId) return false;
		$this->db->where('id', $reportId);
		$isPaid = $this->_row($this->walletReportsTable, 'paid');
		return (int)$isPaid;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function setPaidReport($reportId = false, $stat = 1) {
		if (!$reportId) return false;
		$this->db->where('id', $reportId);
		if (!$this->db->update($this->walletReportsTable, ['paid' => (int)$stat])) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getWalletReportCurrency($reportId = false) {
		if (!$reportId) return false;
		$this->db->where('id', $reportId);
		$isPaid = $this->_row($this->walletReportsTable, 'currency');
		return (float)$isPaid;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function setWalletReportCurrency($reportId = false, $currency = false) {
		if (!$reportId || !$currency) return false;
		$this->db->where('id', $reportId);
		if (!$this->db->update($this->walletReportsTable, ['currency' => (float)$currency])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getUserHistory($userId = false, $amountType = 'wallet') {
		if (!$userId) return false;
		$this->db->join($this->walletTitlesTable.' wt', 'wt.id = wh.title_id');
		$this->db->where('wh.user_id', $userId);
		
		if ($amountType == 'wallet') $this->db->where('wh.is_cumulative', 0);
		else if ($amountType == 'cumulative') $this->db->where('wh.is_cumulative', 1);
		
		//$this->db->order_by('wh.id', 'DESC');
		if (!$userHistory = $this->_result($this->walletHistoryTable.' wh')) return false;
		
		$userGlobalSumm = 0;
		foreach ($userHistory as $k => $item) {
			$totalSumm = (float)$item['summ'] + (float)$item['deposit'];
			$userHistory[$k]['current_balance'] = $item['transfer'] == '+' ? ($userGlobalSumm += $totalSumm) : ($userGlobalSumm -= $totalSumm);
		}
		
		$data['history'] = $userHistory;
		$data['types'] = $this->types;
		
		return $data;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getUserBalance($userId = false) {
		if (!$userId) return false;
		$this->db->select('summ');
		$this->db->where('user_id', $userId);
		if (!$userBalanse = $this->_row($this->walletAmountsTable)) return false;
		return $userBalanse;
	}
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getUserCumulativeBalance($userId = false) {
		if (!$userId) return false;
		$this->db->select('summ');
		$this->db->where('user_id', $userId);
		if (!$userBalanse = $this->_row($this->walletCumulativeTable)) return false;
		return $userBalanse;
	}
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getAllUsersHstory() {
		$this->db->select('user_id, '.$this->groupConcat(false, 'id, summ, deposit, transfer', 'history'));
		$this->db->group_by('user_id');
		if (!$usersHistory = $this->_result($this->walletHistoryTable)) return false;
		
		$usersData = [];
		foreach ($usersHistory as $user) {
			if (!$history = $user['history']) continue;
			if (!$history = json_decode($history, true)) continue;
			if (!$history = arrSortByField($history, 'id', 'ASC')) continue;
			
			$finalSumm = 0;
			foreach ($history as $item) {
				if ($item['transfer'] == '+') {
					$finalSumm += ($item['summ'] + $item['deposit']);
				} elseif($item['transfer'] == '-') {
					$finalSumm -= ($item['summ'] + $item['deposit']);
				}
			}
			
			$usersData[$user['user_id']] = round($finalSumm, 1);
		}
		
		return $usersData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------------------
	
	
	
	/**
	 * Добавить название отчета и вернуть ID записи
	 * @param Название отчета
	 * @return ID записи
	*/
	private function _addTitle($title = false) {
		if (!$title) return false;
		if (!$this->db->insert($this->walletTitlesTable, ['title' => $title])) return false;
		return $this->db->insert_id();
	}
	
	
	
	/**
	 * Добавить записи в историю
	 * @param записи истории
	 * @return bool
	*/
	private function _addToHistory($toHistoryData = false) {
		if (!$toHistoryData) return false;
		$this->db->insert_batch($this->walletHistoryTable, $toHistoryData);
		return true;
	}
	
	
	
	
	/**
	 * Прибавить\отнять суммы у участников
	 * @param массив [user_id => summ]
	 * @param +/-
	 * @return bool
	*/
	private function _addToAmounts($toAmountsData = false, $transfer = false, $amountType = null) {
		if (!$toAmountsData || !$transfer) return false;
		$toAmountsData = setArrKeyFromField($toAmountsData, 'user_id', 'summ');
		
		$table = $this->walletAmountsTable;
		
		if ($amountType == 'cumulative') $table = $this->walletCumulativeTable;
		
		
		$amountsTableData = $this->_result($table) ?: [];
		if ($amountsTableData) $amountsTableData = setArrKeyFromField($amountsTableData, 'user_id', 'summ');
		
		
		$updateAmountsData = array_intersect_key($toAmountsData, $amountsTableData);
		$insertAmountsData = array_diff_key($toAmountsData, $amountsTableData);
		
		
		$update = [];
		if ($updateAmountsData) {
			foreach ($updateAmountsData as $userId => $summ) {
				$tableSumm = isset($amountsTableData[$userId]) ? (float)$amountsTableData[$userId] : 0;
				$update[] = [
					'user_id'	=> $userId,
					'summ'		=> $transfer == '+' ? ($tableSumm + $summ) : ($tableSumm - $summ < 0 ? 0 : round($tableSumm - $summ, 1))
				];
				//toLog(date('Y-m-d H:i').' Добавление суммы в баланс, участник: '.$userId.' было: '.$tableSumm.($transfer == '+' ? ' прибавляется: ' : ' отнимается: ').$summ.' стало: '.($transfer == '+' ? ($tableSumm + $summ) : ($tableSumm - $summ < 0 ? 0 : round($tableSumm - $summ, 1))));
			}
		}
		
		$insert = [];
		if ($insertAmountsData) {
			foreach ($insertAmountsData as $userId => $summ) {
				$insert[] = [
					'user_id'	=> $userId,
					'summ'		=> $transfer == '+' ? $summ : -$summ
				];
			}
		}
		
		
		if ($update) $this->db->update_batch($table, $update, 'user_id');
		if ($insert) $this->db->insert_batch($table, $insert);
		
		return true;
	}
	
	
	
	
	/**
	 * Получить список сумм учасников
	 * @param 
	 * @return array [user_id => summ]
	*/
	private function _getAmountsData() {
		$this->db->select('user_id, summ');
		if (!$amountsData = $this->_result($this->walletAmountsTable)) return false;
		$amountsData = setArrKeyFromField($amountsData, 'user_id', 'summ');
		return $amountsData;
	}
	
	
	
	
	
	/**
	 * Получить список участников для списка платежей
	 * @param параметры
	 * @return array
	*/
	private function _getUsersData($params = false) {
		if ($params && is_array($params)) extract($params);
		
		$this->db->where('us.main', 1);
		
		if ($states) {
			$this->db->group_start();
			foreach ($states as $k => $state) {
				$this->db->or_where('u.'.$state, 1);
			}
			$this->db->group_end();
		} 
		
		if ($users) $this->db->where_in('u.id', $users);
		if ($statics) $this->db->where_in('us.static_id', $statics);
		if ($ranks) $this->db->where_in('u.rank', $ranks);
		if ($roles) $this->db->where_in('u.role', $roles);
		
		
		
		$this->db->select('u.id, u.nickname, u.avatar, u.deposit, us.lider, us.static_id AS static');
		$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
		$this->db->join('statics s', 's.id = us.static_id', 'LEFT OUTER');
		
		$this->db->order_by('us.static_id', 'ASC');
		$this->db->order_by('u.nickname',  'ASC');
		
		
		if (!$usersData = $this->_result('users u')) {/*toLog($this->db->last_query());*/ return false;}
		$usersData = setArrKeyFromField($usersData, 'id');
		return $usersData ?: false;
	}
	
	
	
	
}