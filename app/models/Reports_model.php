<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Reports_model extends My_Model {
	
	private $userData = false;
	
	public function __construct() {
		parent::__construct();
		if (get_cookie('id')/*$this->session->has_userdata('id')*/) {
			$this->load->model('account_model');
			$this->userData = $this->account_model->getUserData(get_cookie('id')/*$this->session->userdata('id')*/);
		}
	}
	
	
	
	
	

	/**
	 * Получить список рейдов
	 * @param static_id ID статика
	 * @return массив статик => [ID райда => [тип райда, дата, сумма коэффициентов данного рейда]]
	 */
	public function getRaids($pData = [], $isKey = 0) {
		if (!isset($pData['period_id'])) return [];
		$periodIds = isJson($pData['period_id']) ? json_decode($pData['period_id'], true) : $pData['period_id'];
		
		$this->db->select('r.id AS raid_id, rt.name AS raid_type, r.date, s.id AS static_id, s.name AS static_name, ru.rate');
		$this->db->join('statics s', 's.id = r.static_id', 'left outer');
		$this->db->join('raids_types rt', 'rt.id = r.type', 'left outer');
		$this->db->join('raid_users ru', 'ru.raid_id = r.id');
		
		$this->db->where_in('r.period_id', $periodIds);
		$this->db->where('r.is_key', $isKey);
		if (!is_null($pData['statics'])) $this->db->where_in('r.static_id', $pData['statics']);
		$this->db->order_by('r.date', 'ASC');
		
		$query = $this->db->get('raids r');
		if (!$response = $query->result_array()) return [];
		
		
		
		
		$result = [];
		foreach ($response as $k => $item) {
			$sId = $item['static_id'] ?: 0;
			$sName = $item['static_name'] ?: null;
			$rId = $item['raid_id'];
			
			$result[$sId]['static_name'] = $sName;
			$result[$sId]['raids'][$rId]['raid_type'] = $item['raid_type'];
			$result[$sId]['raids'][$rId]['date'] = $item['date'];
			if (!isset($result[$sId]['raids'][$rId]['koeff_summ'])) $result[$sId]['raids'][$rId]['koeff_summ'] = $item['rate'];
			else $result[$sId]['raids'][$rId]['koeff_summ'] += $item['rate'];
			
			unset($response[$k]);
		}
		
		return $result;
	}
	
	
	
	
	
	
	
	
	/**
	 * Получить список ключей
	 * @param static_id ID статика
	 * @return массив статик => [ID райда => [тип райда, дата, сумма коэффициентов данного рейда]]
	 */
	public function getKeys($pData = []) {
		if (!isset($pData['period_id'])) return [];
		
		$this->db->select('r.id AS raid_id, rt.name AS raid_type, r.date, s.id AS static_id, s.name AS static_name, ru.rate');
		$this->db->join('statics s', 's.id = r.static_id', 'left outer');
		$this->db->join('keys_types rt', 'rt.id = r.type', 'left outer');
		$this->db->join('raid_users ru', 'ru.raid_id = r.id');
		
		$this->db->where(['r.period_id' => $pData['period_id'], 'r.is_key' => 1]);
		if (!is_null($pData['statics'])) $this->db->where_in('r.static_id', $pData['statics']);
		$this->db->order_by('r.date', 'ASC');
		
		$query = $this->db->get('raids r');
		if (!$response = $query->result_array()) return [];
		
		
		$result = [];
		foreach ($response as $k => $item) {
			$sId = $item['static_id'] ?: 0;
			$sName = $item['static_name'] ?: null;
			$rId = $item['raid_id'];
			
			$result[$sId]['static_name'] = $sName;
			$result[$sId]['raids'][$rId]['raid_type'] = $item['raid_type'];
			$result[$sId]['raids'][$rId]['date'] = $item['date'];
			if (!isset($result[$sId]['raids'][$rId]['koeff_summ'])) $result[$sId]['raids'][$rId]['koeff_summ'] = $item['rate'];
			else $result[$sId]['raids'][$rId]['koeff_summ'] += $item['rate'];
			
			unset($response[$k]);
		}
		return $result;
	}
	
	
	
	
	
	
	
	
	/**
	 * Получить список паттернов первого отчета
	 * @param ID паттерна
	 * @param данные [offset, limit]
	 * @param ID статика
	 * @return массив 
	 */
	public function getMainReportPatterns($patternId = null, $limOffs = null, $isKey = 0) {
		$this->db->select('rp.id, rp.variant, rp.name AS report_name, rp.period_id, rp.is_key, rps.static, rps.cash');
		if ($patternId) $this->db->where('rp.id', $patternId);
		
		$this->db->join('reports_patterns_statics rps', 'rp.id = rps.report_pattern_id');
		$this->db->where('rp.archive !=', 1);
		if ($isKey != 2) $this->db->where('rp.is_key', $isKey);
		$this->db->order_by('rp.id', 'DESC');
		$this->db->order_by('rps.id');
		$query = $this->db->get('reports_patterns rp');
		
		if (!$response = $query->result_array()) return [];
		
		$newData = [];
		foreach ($response as $k => $item) {
			$itemId = $item['id'];
			$newData[$itemId]['report_name'] = $item['report_name'];
			$newData[$itemId]['period_id'] = json_decode($item['period_id'], true);
			$newData[$itemId]['is_key'] = $item['is_key'];
			$newData[$itemId]['variant'] = $item['variant'];
			$newData[$itemId]['cash'][$item['static']] = $item['cash'];
		}
		
		if ($patternId) {
			$newData[$patternId]['pattern_id'] = $patternId;
			return $newData[$patternId];
		} 
		
		if($limOffs) {
			$returnData = array_slice($newData, $limOffs['offset'], $limOffs['limit'], true);
			unset($newData);
			return $returnData;
		}
		
		return $newData;
	}
	
	
	
	
	
	/**
	 * Паттерн в архив
	 * @param 
	 * @return 
	 */
	public function patternToArchive($patternId) {
		$this->db->where('id', $patternId);
		if ($this->db->update('reports_patterns', ['archive' => 1])) return true;
		return false;
	}
	
	
	
	
	
	
	/**
	 * Сохранить паттерн первого отчета
	 * @param массив [name, statics_cash]
	 * @return массив 
	 */
	public function saveMainReportPattern($data, $constants) {
		$this->db->insert('reports_patterns', [
			'name' 			=> $data['name'],
			'period_id' 	=> $data['period_id'],
			'variant'		=> $data['variant']
		]);
		$lastPatternId = $this->db->insert_id();
		
		if ($data['cash']) {
			$staticsData = [];
			foreach ($data['cash'] as $staticName => $cash) {
				$staticsData[] = [
					'report_pattern_id'	=> $lastPatternId,
					'static'			=> $staticName,
					'cash' 				=> $cash
				];
			}
			$this->db->insert_batch('reports_patterns_statics', $staticsData);
		}
			
		
		$paymentsData = $this->buildReportPaymentsData($constants, [
			'cash' 			=> $data['cash'],
			'period_id' 	=> $data['period_id'],
			'variant' 		=> $data['variant']
		]);
		
		if ($paymentsData) {
			$usersPaymentsData = []; $usersStaticsData = []; 
			foreach ($paymentsData as $staticId => $payments) {
				foreach($payments['users'] as $userId => $userData) {
					$usersPaymentsData[] = [
						'report_pattern_id'	=> $lastPatternId,
						'static_id' 		=> $staticId,
						'user_id' 			=> $userId,
						'debit' 			=> str_replace(' ', '', $userData['final_payment'])
					];
					
					$usersStaticsData[] = [
						'report_pattern_id'	=> $lastPatternId,
						'static_id' 		=> $staticId,
						'user_id'			=> $userId,
						'lider'				=> $userData['lider']
					];
				}
			}
			
			if ($usersPaymentsData) $this->db->insert_batch('reports_patterns_payments', $usersPaymentsData);
			if ($usersStaticsData) $this->db->insert_batch('reports_patterns_user_static', $usersStaticsData);
		}
		
		
		
		$this->db->select('u.id AS user_id, r.coefficient AS rank_coefficient');
		$this->db->join('ranks r', 'u.rank = r.id');
		$query = $this->db->get('users u');
		if ($usersRanks = $query->result_array()) {
			$usersRanksData = [];
			foreach ($usersRanks as $user) {
				$coeff = json_decode($user['rank_coefficient'], true);
				$usersRanksData[] = [
					'report_pattern_id'	=> $lastPatternId,
					'user_id'			=> $user['user_id'],
					'rank_coefficient'	=> $coeff[$data['variant']]
				];
			}
			$this->db->insert_batch('reports_patterns_ranks', $usersRanksData);
		}
		
		// Автоматически закрываем период после сохранения отчета
		return $this->closePeriod($data['period_id'], true, true);
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Сохранить паттерн отчета по ключам
	 * @param массив [name, statics_cash]
	 * @return массив 
	 */
	public function saveKeysReportPattern($data) {
		$periodId = $data['period_id'];
		$this->db->insert('reports_patterns', [
			'name' 			=> $data['name'],
			'period_id' 	=> $data['period_id'],
			'is_key'		=> 1
		]);
		$lastPatternId = $this->db->insert_id();
		
		if ($data['cash']) {
			$staticsData = [];
			foreach ($data['cash'] as $staticName => $cash) {
				$staticsData[] = [
					'report_pattern_id'	=> $lastPatternId,
					'static'			=> $staticName,
					'cash' 				=> $cash
				];
			}
			$this->db->insert_batch('reports_patterns_statics', $staticsData);
		}
			
		
		$paymentsData = $this->buildReportPaymentsKeysData([
			'cash' 			=> $data['cash'],
			'period_id' 	=> $data['period_id']
		]);
		
		if ($paymentsData) {
			$usersPaymentsData = []; $usersStaticsData = []; 
			foreach ($paymentsData as $staticId => $data) {
				foreach($data['users'] as $userId => $userData) {
					$usersPaymentsData[] = [
						'report_pattern_id'	=> $lastPatternId,
						'static_id' 		=> $staticId,
						'user_id' 			=> $userId,
						'debit' 			=> str_replace(' ', '', $userData['payment'])
					];
					
					$usersStaticsData[] = [
						'report_pattern_id'	=> $lastPatternId,
						'static_id' 		=> $staticId,
						'user_id'			=> $userId,
						'lider'				=> $userData['lider']
					];
				}
			}
			
			if ($usersPaymentsData) $this->db->insert_batch('reports_patterns_payments', $usersPaymentsData);
			if ($usersStaticsData) $this->db->insert_batch('reports_patterns_user_static', $usersStaticsData);
		}
		
		
		// Автоматически закрываем период после сохранения отчета
		return $this->closePeriod($periodId, true, true);
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getRaidUsers($periodsIds = null, $isKey = 0) {
		if (is_null($periodsIds)) return [];
		$this->db->select('ru.id, ru.rate, ru.raid_id, ru.user_id, r.static_id');
		$this->db->join('raids r', 'ru.raid_id = r.id', 'LEFT OUTER');
		$this->db->where_in('r.period_id', $periodsIds);
		$this->db->where('r.is_key', $isKey);
		$queryRu = $this->db->get('raid_users ru');
		if (!$resultRu = $queryRu->result_array()) return [];
		$raidUsers = [];
		foreach ($resultRu as $i) $raidUsers[$i['static_id']][$i['user_id']]['raids'][$i['raid_id']] = ['id' => $i['id'], 'rate' => $i['rate']];
		return $raidUsers;
	}
	
	
	
	
	
	/**
	 * Получить compounds_data
	 * @param 
	 * @return 
	 */
	private function _getCompoundsData($periodsIds = null) {
		if (is_null($periodsIds)) return [];
		$this->db->where_in('period_id', $periodsIds);
		$cDQuery = $this->db->get('compounds_data');
		if (!$cDResponse = $cDQuery->result_array()) return [];
		$compoundsData = [];
		foreach ($cDResponse as $item) {
			
			if (!isset($compoundsData[$item['static_id']][$item['user_id']]['persones_count'])) {
				$compoundsData[$item['static_id']][$item['user_id']]['persones_count'] = $item['persones_count'];
			} else {
				$compoundsData[$item['static_id']][$item['user_id']]['persones_count'] += $item['persones_count'];
			}
			
			if (!isset($compoundsData[$item['static_id']][$item['user_id']]['fine'])) {
				$compoundsData[$item['static_id']][$item['user_id']]['fine'] = $item['fine'];
			} else {
				$compoundsData[$item['static_id']][$item['user_id']]['fine'] += $item['fine'];
			}
			
			if (!isset($compoundsData[$item['static_id']][$item['user_id']]['effectiveness'])) {
				$compoundsData[$item['static_id']][$item['user_id']]['effectiveness'] = $item['effectiveness'];
			} else {
				$compoundsData[$item['static_id']][$item['user_id']]['effectiveness'] += $item['effectiveness'];
			}
			
			/*$compoundsData[$item['static_id']][$item['user_id']] = [
				'persones_count'	=> $item['persones_count'],
				'effectiveness'		=> $item['effectiveness'],
				'fine'				=> $item['fine']
			];*/
		}
		return $compoundsData;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getReportPatternsPayments($patternId) {
		if (is_null($patternId)) return [];
		$this->db->select('rpp.user_id, rpp.static_id, rpp.pay_done');
		$this->db->where('rpp.report_pattern_id', $patternId);
		$queryRpp = $this->db->get('reports_patterns_payments rpp');
		if (!$resultRpp = $queryRpp->result_array()) return [];
		
		$response = [];
		foreach ($resultRpp as $item) {
			$response[$item['static_id']][$item['user_id']] = $item['pay_done'];
		}
		return $response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
		
		
		
		
		
	/**
	 * Формирование данных для первого отчета
	 * @param Константы
	 * @param Данные паттерна
	 * @param На экспорт
	 * @param Для ключей
	 * @return static id => [static type, users => [user id => user data... raids => [raid id => rate]]]
	 */
	public function buildReportPaymentsData($constants = null, $pData = null, $toExport = false) {
		if (is_null($constants) || empty($pData['cash']) || !isset($pData['period_id'])) return false;
		
		extract($constants);
		$periodsIds = isJson($pData['period_id']) ? json_decode($pData['period_id'], true) : $pData['period_id'];
		
		$response = [];
		$raidUsers = $this->_getRaidUsers($periodsIds);
		$compoundsData = $this->_getCompoundsData($periodsIds);
		
		$this->load->model('admin_model');
		$defaultDepositPercent = $this->admin_model->getSettings('default_deposit_percent_setting'); // процент депозита по-умолчанию
		// в таблице два поля - sdp: процент депозита статика deposit_percent: процент депозита пользователя
		
		
		//---------------------------------------------------------- Формирование отчета "налету"
		if (!isset($pData['pattern_id'])) {
			$this->db->select('u.id AS user_id, u.color, u.nickname, u.deposit, u.deposit_percent, u.payment AS pay_method, u.deleted, s.name AS static_name, s.cap_simple, s.cap_lider, s.deposit_percent AS sdp, r.name AS rank_name, r.coefficient AS rank_coefficient, us.lider, us.static_id AS static');
			$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
			$this->db->join('statics s', 's.id = us.static_id', 'LEFT OUTER');
			$this->db->join('ranks r', 'u.rank = r.id', 'LEFT OUTER');
			//$this->db->where('u.deleted', 0); //========================================================
			$this->db->order_by('us.static_id ASC, us.lider DESC, u.nickname ASC');
			$query = $this->db->get('users u');
			if (!$resultUsers = $query->result_array()) return $response;
			$resultUsers = sortUsers($resultUsers); // сортировка участников по именам (сначала русские потом англ.)
			
			
			// Добавление списка рейдов к массиву участников
			foreach ($resultUsers as $key => $user) {
				$coeff = json_decode($user['rank_coefficient'], true);
				$resultUsers[$key]['rank_coefficient'] = $coeff[$pData['variant']];
				
				if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 0) continue; 
				if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 1) unset($resultUsers[$key]);
				else $resultUsers[$key]['raids'] = $raidUsers[$user['static']][$user['user_id']]['raids'];
			}
			
			
			
			// static id => сумма коэффициентов периода
			$koeffPeriodSumm = [];
			foreach ($resultUsers as $user) {
				if (empty($user['raids'])) continue;
				
				$personesCount = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['persones_count'] : 0;
				$effectiveness = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['effectiveness'] : 0;
				$fine = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['fine'] : 0;
				
				$user['rank_coefficient'] = $user['rank_coefficient'] > 0 ? $user['rank_coefficient'] : 1;
				$rateSumm = !empty($user['raids']) ? array_sum(array_column($user['raids'], 'rate')) : 0;
				$periodKoeff = ((($cVisits * $rateSumm) + ($cPersons * $personesCount) + ($cEffectiveness * $effectiveness) - ($cFine * $fine)) * $user['rank_coefficient']);
				if (! isset($koeffPeriodSumm[$user['static']])) $koeffPeriodSumm[$user['static']] = $periodKoeff;
				else $koeffPeriodSumm[$user['static']] += $periodKoeff;
			}
				
			
			// static id => [static type, users => [user id => user data... raids => [raid id => rate]]]
			foreach ($resultUsers as $user) {
				// если в кэше не задан статик - то прьосто пропускаем его, так как необходимы записи "cap_lider" и "cap_simple", которые неоткуда взять
				if (!isset($pData['cash'][$user['static']])) continue;
				$personesCount = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['persones_count'] : 0;
				$effectiveness = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['effectiveness'] : 0;
				$fine = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['fine'] : 0;
				
				if (!empty($user['raids'])) {
					$rateSumm = !empty($user['raids']) ? array_sum(array_column($user['raids'], 'rate')) : 0;
					$periodKoeff = ((($cVisits * $rateSumm) + ($cPersons * $personesCount) + ($cEffectiveness * $effectiveness) - ($cFine * $fine)) * $user['rank_coefficient']);
					$payment = $koeffPeriodSumm[$user['static']] ? ($pData['cash'][$user['static']] / $koeffPeriodSumm[$user['static']] * $periodKoeff) : 0;
				} else {
					$rateSumm = $periodKoeff = $payment = 0;
				}
				
				
				
				if (! isset($response[$user['static']]['period_koeff_summ'])) $response[$user['static']]['period_koeff_summ'] = round($periodKoeff, 3);
				else $response[$user['static']]['period_koeff_summ'] += round($periodKoeff, 3);
				
				
				// Процент, отстегивающийся в Резерв
				$persentToDeposit = $user['deposit_percent'] ?: ($user['sdp'] ?: ($defaultDepositPercent ?: 10));
				unset($user['sdp']);
				
				$depositLimit = $user['lider'] ? $user['cap_lider'] : $user['cap_simple'];
				$percentFromPayment = ($payment * ($persentToDeposit / 100)) <= $depositLimit ? ($payment * ($persentToDeposit / 100)) : $depositLimit;
				
				$deposit = $user['deposit'];
				$toDeposit = $deposit < $depositLimit ? ($depositLimit - $deposit >= $percentFromPayment ? round($percentFromPayment, 2) : round($depositLimit - $deposit, 2)) : 0;
				
				
				
				
				
				$response[$user['static']]['cash'] = $pData['cash'][$user['static']];
				$response[$user['static']]['static_name'] = $user['static_name'];
				$response[$user['static']]['users'][$user['user_id']] = [
					'nickname' 			=> $user['nickname'],
					'color'				=> $user['color'],
					'rank_name' 		=> $user['rank_name'],
					'lider'				=> $user['lider'],
					'persones_count'	=> $personesCount,
					'effectiveness'		=> $effectiveness,
					'fine' 				=> $fine,
					'koeff_summ' 		=> $rateSumm,
					'period_koeff' 		=> $periodKoeff,
					'payment' 			=> round($payment, 2),
					'deposit'			=> round($user['deposit'], 2),
					'to_deposit'		=> $toDeposit,
					'final_payment'		=> round($payment - $toDeposit, 2),
					'pay_done'			=> 0,
					'pay_method'		=> $user['pay_method'],
					'raids' 			=> !empty($user['raids']) ? $user['raids'] : []
				];
			}
			
			if ($response) ksort($response);
			return $response;
		}
		
		
		
		//---------------------------------------------------------- Формирование отчета из паттерна
		
		// pattern_id static_id user_id cash
		$depositHistories = $this->getDepositHistories(); 
		$rpp = $this->_getReportPatternsPayments($pData['pattern_id']);
		
		
		$this->db->select('u.id AS user_id, u.color, u.nickname, u.deposit, u.deposit_percent, u.payment AS pay_method, u.deleted, s.name AS static_name, s.cap_simple, s.cap_lider, s.deposit_percent AS sdp, r.name AS rank_name, rpr.rank_coefficient, rpus.lider, rpus.static_id AS static');
		$this->db->join('reports_patterns_user_static rpus', 'rpus.user_id = u.id', 'left outer');
		$this->db->join('statics s', 's.id = rpus.static_id', 'left outer');
		$this->db->join('ranks r', 'u.rank = r.id', 'left outer');
		$this->db->join('reports_patterns_ranks rpr', 'rpr.user_id = u.id');
		if (isset($pData['statics']) && !is_null($pData['statics'])) $this->db->where_in('rpus.static_id', $pData['statics']);
		$this->db->where('rpr.report_pattern_id', $pData['pattern_id']);
		$this->db->where('rpus.report_pattern_id', $pData['pattern_id']);
		//$this->db->where('u.deleted', 0); //========================================================
		$this->db->order_by('rpus.static_id ASC, rpus.lider DESC, u.nickname DESC');
		$query = $this->db->get('users u');
		if (!$resultUsers = $query->result_array()) return $response;
		
		
		$resultUsers = sortUsers($resultUsers); // сортировка участников по именам (сначала русские потом англ.)
		
		// Добавление списка рейдов к массиву участников
		foreach ($resultUsers as $key => $user) {
			if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 0) continue; 
			if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 1) unset($resultUsers[$key]);
			else $resultUsers[$key]['raids'] = $raidUsers[$user['static']][$user['user_id']]['raids'];
		}
		
		// static id => сумма коэффициентов периода
		$koeffPeriodSumm = [];
		foreach ($resultUsers as $user) {
			if (empty($user['raids'])) continue;
			$personesCount = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['persones_count'] : 0;
			$effectiveness = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['effectiveness'] : 0;
			$fine = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['fine'] : 0;
			
			$user['rank_coefficient'] = $user['rank_coefficient'] > 0 ? $user['rank_coefficient'] : 1;
			$rateSumm = !empty($user['raids']) ? array_sum(array_column($user['raids'], 'rate')) : 0;
			$periodKoeff = ((($cVisits * $rateSumm) + ($cPersons * $personesCount) + ($cEffectiveness * $effectiveness) - ($cFine * $fine)) * $user['rank_coefficient']);
			if (! isset($koeffPeriodSumm[$user['static']])) $koeffPeriodSumm[$user['static']] = $periodKoeff;
			else $koeffPeriodSumm[$user['static']] += $periodKoeff;
		}
		
		
		// static id => [static type, users => [user id => user data... raids => [raid id => rate]]]
		$response = [];
		if ($resultUsers) {
			foreach ($resultUsers as $user) {
				// если в кэше не задан статик - то прьосто пропускаем его, так как необходимы записи "cap_lider" и "cap_simple", которые неоткуда взять
				if (!isset($pData['cash'][$user['static']])) continue;
				$personesCount = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['persones_count'] : 0;
				$effectiveness = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['effectiveness'] : 0;
				$fine = isset($compoundsData[$user['static']][$user['user_id']]) ? $compoundsData[$user['static']][$user['user_id']]['fine'] : 0;
				
				if (!empty($user['raids'])) {
					$rateSumm = !empty($user['raids']) ? array_sum(array_column($user['raids'], 'rate')) : 0;
					$periodKoeff = ((($cVisits * $rateSumm) + ($cPersons * $personesCount) + ($cEffectiveness * $effectiveness) - ($cFine * $fine)) * $user['rank_coefficient']);
					$payment = $koeffPeriodSumm[$user['static']] ? ($pData['cash'][$user['static']] / $koeffPeriodSumm[$user['static']] * $periodKoeff) : 0;
				} else {
					$rateSumm = $periodKoeff = $payment = 0;
				}
				
				if (! isset($response[$user['static']]['period_koeff_summ'])) $response[$user['static']]['period_koeff_summ'] = round($periodKoeff, 3);
				else $response[$user['static']]['period_koeff_summ'] += round($periodKoeff, 3);
				
				
				// Процент, отстегивающийся в Резерв
				$persentToDeposit = $user['deposit_percent'] ?: ($user['sdp'] ?: ($defaultDepositPercent ?: 10));
				unset($user['sdp']);
				
				$depositLimit = $user['lider'] ? $user['cap_lider'] : $user['cap_simple'];
				$percentFromPayment = ($payment * ($persentToDeposit / 100)) <= $depositLimit ? ($payment * ($persentToDeposit / 100)) : $depositLimit;
				$hSumm = isset($depositHistories[$pData['pattern_id']][$user['static']][$user['user_id']]) ? ($rpp[$user['static']][$user['user_id']] == 1 ? $depositHistories[$pData['pattern_id']][$user['static']][$user['user_id']] : 0) : 0; // сумма из истории
				$deposit = ($user['deposit'] - $hSumm);
				$toDeposit = $deposit < $depositLimit ? ($depositLimit - $deposit >= $percentFromPayment ? round($percentFromPayment, 2) : round($depositLimit - $deposit, 2)) : 0;
				
				$response[$user['static']]['cash'] = $pData['cash'][$user['static']];
				$response[$user['static']]['static_name'] = $user['static_name'];
				$response[$user['static']]['users'][$user['user_id']] = [
					'nickname' 			=> $user['nickname'],
					'color' 			=> $user['color'],
					'rank_name' 		=> $user['rank_name'],
					'lider'				=> $user['lider'],
					'persones_count'	=> $personesCount,
					'effectiveness'		=> $effectiveness,
					'fine' 				=> $fine,
					'koeff_summ' 		=> $rateSumm,
					'period_koeff' 		=> $periodKoeff,
					'payment' 			=> round($payment, 2),
					'pay_method'		=> $user['pay_method'],
					'deposit'			=> round($user['deposit'], 2),
					'to_deposit'		=> $toDeposit,
					'final_payment'		=> round($payment - $toDeposit, 2),
					'pay_done'			=> isset($rpp[$user['static']][$user['user_id']]) ? $rpp[$user['static']][$user['user_id']] : 0,
					'raids' 			=> !empty($user['raids']) ? $user['raids'] : []
				];
			}
		}
		
		if ($response) ksort($response);
		
		if ($toExport && $response) {
			$dataToExport = '';
			foreach ($response as $staticId => $data) {
				$dataToExport .= iconv('UTF-8', 'windows-1251', 'Статик;Бюджет статика'."\r\n");
				//$dataToExport .= $data['static_name'].';'.number_format($data['cash'], 2, '.', ' ')."\r\n";
				$dataToExport .= $data['static_name'].';'.$data['cash']."\r\n";
				$dataToExport .= iconv('UTF-8', 'windows-1251', 'Никнейм;Выплата;Средство оплаты')."\r\n";
				foreach ($data['users'] as $userId => $userData) {
					$dataToExport .= iconv('UTF-8', 'windows-1251', $userData['nickname'].';'.str_replace('.', ',', $userData['final_payment']).';'.$userData['pay_method'])."\r\n";
				}
				$dataToExport .= "\r\n";
			}
			
			return $dataToExport;
		}
		
		return $response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Формирование данных для отчета по ключам
	 * @param Константы
	 * @param Данные паттерна
	 * @param На экспорт
	 * @param Для ключей
	 * @return static id => [static type, users => [user id => user data... raids => [raid id => rate]]]
	 */
	public function buildReportPaymentsKeysData($pData = null, $toExport = false) {
		if (empty($pData['cash']) || !isset($pData['period_id'])) return false;
		$response = [];
		
		$raidUsers = $this->_getRaidUsers($pData['period_id'], 1);
		
		//---------------------------------------------------------- Формирование отчета "налету"
		if (!isset($pData['pattern_id'])) {
			$this->db->select('u.id AS user_id, u.color, u.nickname, u.payment AS pay_method, u.deleted, s.name AS static_name, s.cap_simple, s.cap_lider, us.lider, r.name AS rank_name, us.static_id AS static');
			$this->db->join('users_statics us', 'us.user_id = u.id', 'left outer');
			$this->db->join('statics s', 's.id = us.static_id', 'left outer');
			$this->db->join('ranks r', 'u.rank = r.id', 'left outer');
			$this->db->order_by('us.static_id ASC, us.lider DESC, u.nickname ASC');
			$query = $this->db->get('users u');
			if (!$resultUsers = $query->result_array()) return $response;
			$resultUsers = sortUsers($resultUsers); // сортировка участников по именам (сначала русские потом англ.)
			
			
			// Добавление списка рейдов к массиву участников
			foreach ($resultUsers as $key => $user) {
				if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 0) continue; 
				if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 1) unset($resultUsers[$key]);
				else $resultUsers[$key]['raids'] = $raidUsers[$user['static']][$user['user_id']]['raids'];
			}
			
			// static id => сумма коэффициентов периода
			$koeffPeriodSumm = [];
			foreach ($resultUsers as $user) {
				if (empty($user['raids'])) continue;
				$rateSumm = array_sum(array_column($user['raids'], 'rate')) ?: 0;
				if (! isset($koeffPeriodSumm[$user['static']])) $koeffPeriodSumm[$user['static']] = $rateSumm;
				else $koeffPeriodSumm[$user['static']] += $rateSumm;
			}
			
			
			// static id => [static type, users => [user id => user data... raids => [raid id => rate]]]
			foreach ($resultUsers as $user) {
				// если в кэше не задан статик - то просто пропускаем его, так как необходимы записи "cap_lider" и "cap_simple", которые неоткуда взять
				if (!isset($pData['cash'][$user['static']])) continue;
				
				if (!empty($user['raids'])) {
					$rateSumm = array_sum(array_column($user['raids'], 'rate')) ?: 0;
					$payment = ($pData['cash'][$user['static']] / $koeffPeriodSumm[$user['static']]) * $rateSumm;
				} else {
					$rateSumm = $payment = 0;
				}
				
				if (!isset($response[$user['static']]['period_koeff_summ'])) $response[$user['static']]['period_koeff_summ'] = round($rateSumm, 3);
				else $response[$user['static']]['period_koeff_summ'] += round($rateSumm, 3);
				
				$response[$user['static']]['cash'] = $pData['cash'][$user['static']];
				$response[$user['static']]['static_name'] = $user['static_name'];
				$response[$user['static']]['users'][$user['user_id']] = [
					'nickname' 			=> $user['nickname'],
					'color'				=> $user['color'],
					'pay_method'		=> $user['pay_method'],
					'rank_name' 		=> $user['rank_name'],
					'lider'				=> $user['lider'],
					'koeff_summ' 		=> $rateSumm,
					'period_koeff' 		=> isset($koeffPeriodSumm[$user['static']]) ? $koeffPeriodSumm[$user['static']] : 0,
					'payment' 			=> round($payment, 2),
					'pay_done'			=> 0,
					'raids' 			=> !empty($user['raids']) ? $user['raids'] : []
				];
			}
			
			if ($response) ksort($response);
			
			return $response;
		}
		
		
		
		
		
		//---------------------------------------------------------- Формирование отчета из паттерна
		// pattern_id static_id user_id cash
		//$depositHistories = $this->getDepositHistories(); 
		$rpp = $this->_getReportPatternsPayments($pData['pattern_id']);
		
		$this->db->select('u.id AS user_id, u.color, u.nickname, u.payment AS pay_method, u.deleted, s.name AS static_name, s.cap_simple, s.cap_lider, r.name AS rank_name, rpus.lider, rpus.static_id AS static');
		$this->db->join('reports_patterns_user_static rpus', 'rpus.user_id = u.id', 'left outer');
		$this->db->join('statics s', 's.id = rpus.static_id', 'left outer');
		$this->db->join('ranks r', 'u.rank = r.id', 'left outer');
		$this->db->join('reports_patterns_ranks rpr', 'rpr.user_id = u.id');
		if (isset($pData['statics']) && !is_null($pData['statics'])) $this->db->where_in('rpus.static_id', $pData['statics']);
		//$this->db->where('rpr.report_pattern_id', $pData['pattern_id']);
		$this->db->where('rpus.report_pattern_id', $pData['pattern_id']);
		$this->db->distinct();
		$this->db->order_by('rpus.static_id ASC, rpus.lider DESC, u.nickname DESC');
		$query = $this->db->get('users u');
		if (!$resultUsers = $query->result_array()) return $response;
		
		$resultUsers = sortUsers($resultUsers); // сортировка участников по именам (сначала русские потом англ.)
		
		// Добавление списка рейдов к массиву участников
		foreach ($resultUsers as $key => $user) {
			if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 0) continue; 
			if (!isset($raidUsers[$user['static']][$user['user_id']]) && $user['deleted'] == 1) unset($resultUsers[$key]);
			else $resultUsers[$key]['raids'] = $raidUsers[$user['static']][$user['user_id']]['raids'];
		}
		
		// static id => сумма коэффициентов периода
		$koeffPeriodSumm = [];
		foreach ($resultUsers as $user) {
			if (empty($user['raids'])) continue;
			if ($user['static'] == 30) {
			}
			$rateSumm = array_sum(array_column($user['raids'], 'rate')) ?: 0;
			if (!isset($koeffPeriodSumm[$user['static']])) $koeffPeriodSumm[$user['static']] = (float)$rateSumm;
			else $koeffPeriodSumm[$user['static']] += (float)$rateSumm;
		}
		
		
		// static id => [static type, users => [user id => user data... raids => [raid id => rate]]]
		$response = [];
		if ($resultUsers) {
			foreach ($resultUsers as $user) {
				// если в кэше не задан статик - то просто пропускаем его, так как необходимы записи "cap_lider" и "cap_simple", которые неоткуда взять
				if (!isset($pData['cash'][$user['static']])) continue;
				
				if (!empty($user['raids'])) {
					$rateSumm = array_sum(array_column($user['raids'], 'rate')) ?: 0;
					$payment = ($pData['cash'][$user['static']] / $koeffPeriodSumm[$user['static']]) * $rateSumm;
				} else {
					$rateSumm = $payment = 0;
				}
				
				if (!isset($response[$user['static']]['period_koeff_summ'])) $response[$user['static']]['period_koeff_summ'] = round($rateSumm, 3);
				else $response[$user['static']]['period_koeff_summ'] += round($rateSumm, 3);
				
				$response[$user['static']]['cash'] = $pData['cash'][$user['static']];
				$response[$user['static']]['static_name'] = $user['static_name'];
				$response[$user['static']]['users'][$user['user_id']] = [
					'nickname' 			=> $user['nickname'],
					'color'				=> $user['color'],
					'rank_name' 		=> $user['rank_name'],
					'lider'				=> $user['lider'],
					'koeff_summ' 		=> $rateSumm,
					'period_koeff' 		=> isset($koeffPeriodSumm[$user['static']]) ? $koeffPeriodSumm[$user['static']] : 0,
					'payment' 			=> round($payment, 2),
					'pay_method'		=> $user['pay_method'],
					'pay_done'			=> isset($rpp[$user['static']][$user['user_id']]) ? $rpp[$user['static']][$user['user_id']] : 0,
					'raids' 			=> !empty($user['raids']) ? $user['raids'] : []
				];
			}
		}
		
		if ($response) ksort($response);
		
		if ($toExport && $response) {
			$dataToExport = '';
			foreach ($response as $staticId => $data) {
				$dataToExport .= iconv('UTF-8', 'windows-1251', 'Статик;Бюджет статика'."\r\n");
				//$dataToExport .= $data['static_name'].';'.number_format($data['cash'], 2, '.', ' ')."\r\n";
				$dataToExport .= $data['static_name'].';'.$data['cash']."\r\n";
				$dataToExport .= iconv('UTF-8', 'windows-1251', 'Никнейм;Выплата;Средство оплаты')."\r\n";
				foreach ($data['users'] as $userId => $userData) {
					$dataToExport .= iconv('UTF-8', 'windows-1251', $userData['nickname'].';'.str_replace('.', ',', $userData['payment']).';'.$userData['pay_method'])."\r\n";
				}
				$dataToExport .= "\r\n";
			}
			return $dataToExport;
		}
		
		return $response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить Резерв пользователя
	 * @param ID пользователя
	 * @return Резерв
	 */
	public function getUserDeposit($userId = null) {
		if (is_null($userId)) return false;
		$this->db->select('deposit');
		$this->db->where('id', $userId);
		$qUser = $this->db->get('users');
		if ($respUser = $qUser->row_array()) return $respUser['deposit'];
		return 0;
	}
	
	
	
	
	
	
	
	/**
	 * Сменить статус выплаты участнику
	 * @param Статус
	 * @param ID паттерна
	 * @param ID пользователя
	 * @param сумма в Резерв
	 * @return 1 или 0
	 */
	public function changePayDoneStat($stat, $patternId, $staticId, $userId, $toDeposit = null) {
		$this->db->where(['report_pattern_id' => $patternId, 'static_id' => $staticId, 'user_id' => $userId]);
		$query = $this->db->get('reports_patterns_payments');
		if (!($response = $query->row_array()) || $response['pay_done'] == $stat) return 0;
		
		$this->db->where(['report_pattern_id' => $patternId, 'static_id' => $staticId, 'user_id' => $userId]);
		$this->db->update('reports_patterns_payments', [
			'debit' 	=> $response['payout'],
			'payout' 	=> $response['debit'],
			'pay_done' 	=> $stat
		]);
		
		
		if (!is_null($toDeposit)) {
			$userDeposit = $this->getUserDeposit($userId);
			
			if ($stat == 1) {
				$this->db->where('id', $userId);
				$this->db->update('users', ['deposit' => ($userDeposit + $toDeposit)]);
				$this->setDepositHistory($patternId, $staticId, $userId, $toDeposit);
			} else {
				$lastDeposit = $this->getDepositHistory($patternId, $staticId, $userId);
				$this->db->where('id', $userId);
				$this->db->update('users', ['deposit' => ($userDeposit - $lastDeposit)]);
				$this->setDepositHistory($patternId, $staticId, $userId);
			}
		}
		
		
		return 1;
	}
	
	
	
	
	
	
	/**
	 * Добавить историю Резерва
	 * @param ID паттерна
	 * @param ID пользователя
	 * @param сумма в Резерв
	 * @return void
	 */
	private function setDepositHistory($patternId, $staticId, $userId, $toDeposit = null) {
		if (!is_null($toDeposit)) {
			$this->db->insert('deposit_history', ['report_pattern_id' => $patternId, 'static_id' => $staticId, 'user_id' => $userId, 'cash' => $toDeposit]);
		} else {
			$this->db->where(['report_pattern_id' => $patternId, 'static_id' => $staticId, 'user_id' => $userId]);
			$this->db->delete('deposit_history');
		}
	}
	
	
	
	
	
	/**
	 * Получить последнюю сумму из истории Резерва и удалить запись
	 * @param ID паттерна
	 * @param ID пользователя
	 * @return сумма
	 */
	private function getDepositHistory($patternId, $staticId, $userId) {
		$this->db->where(['report_pattern_id' => $patternId, 'static_id' => $staticId, 'user_id' => $userId]);
		$query = $this->db->get('deposit_history');
		if(!$response = $query->row_array()) return false;
		
		$this->db->where(['report_pattern_id' => $patternId, 'static_id' => $staticId, 'user_id' => $userId]);
		$this->db->delete('deposit_history');
		return $response['cash'];
	}
	
	
	
	
	
	
	/**
	 * 	Получить данные из истории Резервов
	 * @param 
	 * @return 
	 */
	public function getDepositHistories() {
		$query = $this->db->get('deposit_history dh');
		if(!$result = $query->result_array()) return [];
		$data = [];
		foreach ($result as $item) $data[$item['report_pattern_id']][$item['static_id']][$item['user_id']] = $item['cash'];
		return $data;
	}
	
	
	
	
	
	
	/**
	 * Получить список периодов
	 * @param только открытые периоды
	 * @return 
	 */
	public function getReportsPeriods($onlyOpened = false, $showToVisits = false) {
		$this->db->where('rp.archive !=', 1);
		if ($onlyOpened) $this->db->where('rp.closed !=', 1);
		if ($showToVisits) $this->db->where('rp.to_visits', 1);
		$this->db->order_by('rp.id', 'DESC');
		$this->db->limit(50);
		
		if (!$result = $this->_result('reports_periods rp')) return false;
		return setArrKeyFromField($result, 'id', true);
	}
	
	
	
	
	/**
	 * Добавить период
	 * @param имя периода
	 * @return ID созданного кластера
	 */
	public function savePeriod($name) {
		$this->db->insert('reports_periods', ['name' => $name]);
		return $this->db->insert_id();
	}
	
	
	/**
	 * Задать активный период
	 * @param ID периода
	 * @return void
	 */
	public function setActivePeriod($periodId, $zone) {
		$this->db->where('active_'.$zone, 1);
		$this->db->update('reports_periods', ['active_'.$zone => 0]);
		$this->db->where('id', $periodId);
		if ($this->db->update('reports_periods', ['active_'.$zone => 1])) {
			return 1;
		} else {
			return 0;
		}
	}
	
	
	
	
	/**
	 * Закрыть период
	 * @param ID периода
	 * @param Пометить сохраненным
	 * @param Только закрывать, даже если уже закрыт
	 * @return void
	 */
	public function closePeriod($periodId, $saved = false, $onlyClose = false) {
		$this->db->where('id', $periodId);
		$query = $this->db->get('reports_periods');
		$update = [];
		if ($response = $query->row_array()) {
			if ($response['closed'] == 0) $update['closed'] = 1;
			elseif (!$onlyClose) $update['closed'] = 0;
			if ($saved) $update['saved'] = 1;
		}
		
		if ($update) {
			$this->db->where('id', $periodId);
			$this->db->update('reports_periods', $update);
		}
	}
	
	
	
	
	
	/**
	 * Период для "мои почещения"
	 * @param ID периода
	 * @return void
	 */
	public function periodToVisits($periodId, $saved = false, $onlyClose = false) {
		$this->db->where('id', $periodId);
		$query = $this->db->get('reports_periods');
		$update = [];
		if ($response = $query->row_array()) {
			if ($response['to_visits'] == 0) $update['to_visits'] = 1;
			else $update['to_visits'] = 0;
		}
		
		if ($update) {
			$this->db->where('id', $periodId);
			$this->db->update('reports_periods', $update);
		}
	}
	
	
	
	
	
	
	
	/**
	 * В архив период
	 * @param ID периода
	 * @param Пометить сохраненным
	 * @return void
	 */
	public function periodToArchive($periodId) {
		$this->db->where('id', $periodId);
		if ($this->db->update('reports_periods', ['archive' => 1, 'closed' => 1])) return true;
		return false;
	}
	
	
	
	
	/**
	 * Задать таймер для активации периодов
	 * @param 
	 * @return 
	 */
	public function setTimerActivatePeriods($data) {
		if (!$data) return false;
		foreach ($data as $row) {
			$this->db->where(['period' => $row['period'], 'zone' => $row['zone']]);
			if ($this->db->count_all_results('reports_periods_activate') == 0) {
				$this->db->insert('reports_periods_activate', $row);
			} else {
				$this->db->where(['period' => $row['period'], 'zone' => $row['zone']]);
				$this->db->update('reports_periods_activate', ['time' => $row['time']]);
			}
		}
		return true;
	}
	
	
	
	/**
	 * Получить данные активации периодов
	 * @param 
	 * @return 
	 */
	public function getTimerActivatePeriods($period = false) {
		if ($period) {
			$this->db->where('period', $period);
			$query = $this->db->get('reports_periods_activate');
			if (!$result = $query->result_array()) return false;
			$data = [];
			foreach ($result as $item) {
				$date = $item['time'];
				$time = date('G', $item['time']);
				$data[$item['zone']] = [
					'date' => $date,
					'time' => $time
				];
			}
		} else {
			$query = $this->db->get('reports_periods_activate');
			if (!$data = $query->result_array()) return false;
		}

		return $data;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function activateReportPeriod($data) {
		$zones = [1 => 'u', 2 => 'e', 3 => 'a'];
		
		$this->db->where('id', $data['id']);
		$this->db->delete('reports_periods_activate');
		
		$this->db->update('reports_periods', ['active_'.$zones[$data['zone']] => 0]);
		$this->db->where('id', $data['period']);
		$this->db->update('reports_periods', ['active_'.$zones[$data['zone']] => 1]);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------- 2 отчет (отчет по заказам)
	
	/**
	 * Отчет по заказам
	 * @param 
	 * @return 
	 */
	public function getRaidsOrders($periodId = false) {
		$this->db->select('r.date, ro.raid_id, ro.value AS order, rt.name AS raid_type, s.name AS static_name, u.nickname AS from');
		$this->db->join('raids r', 'ro.raid_id = r.id');
		$this->db->join('raids_types rt', 'rt.id = r.type');
		$this->db->join('statics s', 'r.static_id = s.id');
		$this->db->join('users u', 'u.id = r.from_id');
		
		
		$this->db->where('r.period_id', $periodId);
		$this->db->where('r.is_key', 0);
		$this->db->order_by('r.date');
		$query = $this->db->get('raid_orders ro');
		
		if (!$rows = $query->result_array()) return [];
		
		$result = [];
		foreach ($rows as $row) {
			$result[$row['static_name']][$row['raid_id']]['from'] = $row['from'];
			$result[$row['static_name']][$row['raid_id']]['date'] = $row['date'];
			$result[$row['static_name']][$row['raid_id']]['name'] = $row['raid_type'];
			$result[$row['static_name']][$row['raid_id']]['orders'][] = $row['order'];
		}
		
		return $result;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Экспорт заказов
	 * @param 
	 * @return 
	 */
	public function exportOrders($data) {
		$this->db->where('op.id', $patternId);
		$query = $this->db->get('orders_patterns op');
		$response = $query->result_array();
		return $response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------- 3 отчет
	
	/**
	 * Получить список паттернов (диапазонов)
	 * @param 
	 * @return 
	 */
	public function getPatternsList($limOffs = []) {
		$this->db->select('rp.id, rp.name AS report_name');
		if ($limOffs) $this->db->limit($limOffs['limit'], $limOffs['offset']);
		$this->db->order_by('rp.id', 'DESC');
		$query = $this->db->get('reports_patterns rp');
		if (!$response = $query->result_array()) return [];
		$response = setArrKeyFromField($response, 'id');
		return $response;
	}
	
	
	
	
	
	
	
	/**
	 * Формирование 3 отчета
	 * @param 
	 * @return 
	 */
	public function buildPaymentsPatternsReport($patterns = null) {
		if (is_null($patterns)) return false;
		$this->db->select('rp.id, rp.name');
		$this->db->where_in('rp.id', $patterns);
		$queryRp = $this->db->get('reports_patterns rp');
		
		$patternsData = [];
		if ($respRp = $queryRp->result_array()) foreach ($respRp as $item) $patternsData[$item['id']] = $item['name'];
		
		$this->db->select('u.nickname, u.deposit, s.name AS static, u.payment AS pay_method, rpp.*');
		$this->db->join('users u', 'u.id = rpp.user_id');
		//$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->join('statics s', 's.id = rpp.static_id', 'left outer');
		$this->db->where_in('rpp.report_pattern_id', $patterns);
		$this->db->order_by('s.id', 'ASC');
		$query = $this->db->get('reports_patterns_payments rpp');
		
		$data = [];
		if ($response = $query->result_array()) {
			
			foreach ($response as $u) {
				$data[$u['static']][$u['user_id']]['nickname'] = $u['nickname'];
				$data[$u['static']][$u['user_id']]['deposit'] = $u['deposit'];
				$data[$u['static']][$u['user_id']]['pay_method'] = $u['pay_method'];
				
				if (!isset($data[$u['static']][$u['user_id']]['full'])) $data[$u['static']][$u['user_id']]['full'] = ($u['debit'] + $u['payout']);
				else $data[$u['static']][$u['user_id']]['full'] += ($u['debit'] + $u['payout']);
				
				if (!isset($data[$u['static']][$u['user_id']]['debit'])) $data[$u['static']][$u['user_id']]['debit'] = $u['debit'];
				else $data[$u['static']][$u['user_id']]['debit'] += $u['debit'];
				
				if (!isset($data[$u['static']][$u['user_id']]['payout'])) $data[$u['static']][$u['user_id']]['payout'] = $u['payout'];
				else $data[$u['static']][$u['user_id']]['payout'] += $u['payout'];
				
				if (!isset($data[$u['static']][$u['user_id']]['profit'])) $data[$u['static']][$u['user_id']]['profit'] = ($u['deposit'] + $u['debit']);
				else $data[$u['static']][$u['user_id']]['profit'] += $u['debit'];
				
				
				$data[$u['static']][$u['user_id']]['patterns'][$u['report_pattern_id']] = ($u['debit'] + $u['payout']);
			}
		}
		
		
		$newData = [];
		if ($data) {
			foreach ($data as $static => $users) {
				if (empty($users)) continue;
				foreach ($users as $userId => $userData) {
					foreach ($patternsData as $patternId => $patternName) {
						if (isset($userData['patterns'][$patternId])) {
							$newData[$static][$userId]['nickname'] = $userData['nickname'];
							$newData[$static][$userId]['deposit'] = $userData['deposit'];
							$newData[$static][$userId]['pay_method'] = $userData['pay_method'];
							$newData[$static][$userId]['full'] = $userData['full'];
							$newData[$static][$userId]['debit'] = $userData['debit'];
							$newData[$static][$userId]['payout'] = $userData['payout'];
							$newData[$static][$userId]['profit'] = $userData['profit'];
							
							$newData[$static][$userId]['patterns'][$patternId] = $userData['patterns'][$patternId];
						} else {
							$newData[$static][$userId]['patterns'][$patternId] = null;
						}
					}
				}
			}
		}
		
		return ['patterns' => $patternsData, 'data' => $newData];
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------- Заявки на оплату
	
	/**
	 * Добавить заявки на оплату
	 * @param 
	 * @return 
	 */
	public function insertUsersOrders($orders = false) {
		if (!$orders) return false;
		if (!$this->db->insert_batch('users_orders', $orders)) return false;
		return true;
	}
	
	
	/**
	 * Получить список выплат
	 * @param 
	 * @return 
	 */
	public function getPaymentRequests($params = false, $toExport = false) {
		if ($toExport) $this->db->where('paid', 0);
		
		$searchUsers = [];
		if (isset($params['search_field']) && $params['search_field'] == 'nickname') {
			$this->db->select('id');
			$this->db->like('nickname', $params['search_value'], 'both');
			$query = $this->db->get('users');
			if ($response = $query->result_array()) foreach ($response as $item) $searchUsers[] = $item['id'];
		}
		
		if ($searchUsers) $this->db->where_in('user_id', $searchUsers);
		$this->db->order_by((isset($params['field']) ? $params['field'] : 'id'), (isset($params['order']) ? $params['order'] : 'DESC'));
		$query = $this->db->get('users_orders');
		$result = $query->result_array();
		return $result;
	}
	
	
	
	
	/**
	 * Изменить статус расчета с участником
	 * @param 
	 * @return 
	 */
	public function changePaymentrequestStat($data) {
		if (!$data || !$data['id']) return false;
		$this->db->where('id', $data['id']);
		if ($this->db->update('users_orders', ['paid' => $data['paid']])) return true;
		return false;
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------- Статистика 
	/**
	 * @param 
	 * @return 
	 */
	public function setCashAndDaysToinfo($userId = null, $reportId = false, $cash = 0, $stat = 1, $isKey = false) {
		if (is_null($userId) || $cash == 0) return false;
		
		$this->db->select('statistics_cash, statistics_days, statistics_reports');
		$this->db->where('id', $userId);
		$query = $this->db->get('users');
		if (!$result = $query->row_array()) return false;
		$statisticsReports = (array)json_decode($result['statistics_reports'], true);
		
		
		if ($reportId !== false) {
			if ($stat == 1) {
				if (array_key_exists($reportId, $statisticsReports)) {
					$statisticsReports[$reportId] += 1;
					$days = 0;
				} else {
					$statisticsReports[$reportId] = 1;
					$days = $isKey ? 0 : 7;
				} 
				
				$updateData = [
					'statistics_cash' 		=> ($result['statistics_cash'] + $cash),
					'statistics_days' 		=> ($result['statistics_days'] + $days),
					'statistics_reports'	=> json_encode($statisticsReports)
				];
			
			} elseif ($stat == 0) {
				if (array_key_exists($reportId, $statisticsReports)) {
					if ($statisticsReports[$reportId] > 1) {
						$statisticsReports[$reportId] -= 1;
						$days = 0;
					} else {
						unset($statisticsReports[$reportId]);
						$days = $isKey ? 0 : 7;
					} 
				} else {
					$days = 0;
				} 
				
				$updateData = [
					'statistics_cash' 		=> ($result['statistics_cash'] - $cash),
					'statistics_days' 		=> ($result['statistics_days'] - $days),
					'statistics_reports'	=> json_encode($statisticsReports)
				];
			}
		} else {
			$updateData = ['statistics_cash' => $stat == 0 ? ($result['statistics_cash'] - $cash) : ($result['statistics_cash'] + $cash)];
		}
		
		
		$this->db->where('id', $userId);
		if ($this->db->update('users', $updateData)) return 1;
		return 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить данные для оплаты окладов
	 * @param 
	 * @return 
	*/
	public function getCoeffsToSalary($periodId = false) {
		if (!$periodId) return false;
		
		$this->db->select('r.static_id, ru.rate, ru.user_id');
		$this->db->join('raids r', 'r.id = ru.raid_id');
		$this->db->where(['r.period_id' => $periodId, 'r.is_key' => 0]);
		if (!$result = $this->_result('raid_users ru')) return false;
		
		$data = [];
		foreach ($result as $item) {
			if (!isset($data[$item['static_id']][$item['user_id']])) $data[$item['static_id']][$item['user_id']] = 0;
			$data[$item['static_id']][$item['user_id']] += $item['rate'];
		}
		
		$final = [];
		foreach ($data as $static => $row) {
			$final[$static]['max_coeff'] = max($row);
			$final[$static]['count_users'] = count($row);
		}
		
		return $final;
	}
	
	
	
	
	
	/**
	 * Сформировать и отправить данные для оплаты в "заявки на оплату"
	 * @param 
	 * @return 
	*/
	public function getSalaryOrders($data = false, $setUsersDeposit = false, $withTotal = false) {
		if (!$data['period_id'] || !$data['data']) return false;
		
		$order = arrTakeItem($data, 'order');
		$toDeposit = arrTakeItem($data, 'to_deposit');
		$comment = arrTakeItem($data, 'comment');
		$periodId = arrTakeItem($data, 'period_id');
		$coeffsData = setArrKeyFromField(arrTakeItem($data, 'data'), 'static_id');
		$statics = array_keys($coeffsData);
		
		$this->db->select('r.static_id, ru.rate, ru.user_id');
		$this->db->join('raids r', 'r.id = ru.raid_id');
		$this->db->where(['r.period_id' => $periodId, 'r.is_key' => 0]);
		$this->db->where_in('r.static_id', $statics);
		if (!$result = $this->_result('raid_users ru')) return false;
		
		$data = []; $usersIds = [];
		foreach ($result as $item) {
			if (!isset($data[$item['static_id']][$item['user_id']])) $data[$item['static_id']][$item['user_id']] = 0;
			$data[$item['static_id']][$item['user_id']] += $item['rate'];
			$usersIds[] = $item['user_id'];
		}
		
		$this->load->model('users_model');
		$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'id, nickname, avatar, payment, deposit, static, lider']);
		$usersData = setArrKeyFromField($usersData, 'id', true);
		
		if ($toDeposit) {
			$staticsData = $this->admin_model->getStatics();
			$percentToDeposit = $this->admin_model->getSettings('payment_requests_deposit_percent');
		}
		
		
		$orders = [];
		$toDepositData = [];
		foreach ($data as $staticId => $users) {
			$total[$staticId] = 0;
			foreach ($users as $userId => $coeffSumm) {
				if ($coeffSumm <= 0) continue;
				
				$summ = $coeffSumm > $coeffsData[$staticId]['coeff'] ? $coeffsData[$staticId]['summ'] : round(($coeffsData[$staticId]['summ'] / $coeffsData[$staticId]['coeff']) * $coeffSumm);
				
				if ($toDeposit) {
					$userStatic = $usersData[$userId]['static'];
					$userLider = $usersData[$userId]['lider'];
					$userDeposit = $usersData[$userId]['deposit'];
					
					$limit = $userLider ? $staticsData[$userStatic]['cap_lider'] : $staticsData[$userStatic]['cap_simple']; // лимит депозита
					$canSetToDeposit = $limit - $userDeposit > 0 ? $limit - $userDeposit : 0;
					
					$summToDeposit = ($summ / 100) * $percentToDeposit; // сумма в депозит
					
					$summToDeposit = $canSetToDeposit >= $summToDeposit ? $summToDeposit : $canSetToDeposit;
					$summToOrder = $summ - $summToDeposit; // сумма в оплату
					
					$toDepositData[$userId] = $summToDeposit; 
				} else {
					$summToOrder = $summ;
					$summToDeposit = 0;
				}
				
				$total[$staticId] += $summToOrder;
				
				$orders[] = [
					'user_id'		=> $userId,
					'nickname' 		=> $usersData[$userId]['nickname'],
					'avatar' 		=> $usersData[$userId]['avatar'],
					'payment' 		=> $usersData[$userId]['payment'],
					'static' 		=> $staticId,
					'order' 		=> $order,
					'summ' 			=> $summToOrder,
					'to_deposit'	=> $summToDeposit,
					'comment' 		=> $comment,
					'date'			=> time()
				];
			}	
		}
		
		if ($toDeposit && $setUsersDeposit) $this->users_model->setUsersDeposit($toDepositData);
		return $orders ? ($withTotal ? ['orders' => $orders, 'total' => $total] : $orders) : false;
	}
	
	
	
	
	
	
}