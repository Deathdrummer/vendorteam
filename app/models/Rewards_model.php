<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Rewards_model extends MY_Model {
	
	private $rewardsPeriodsTable = 'rewards_periods';
	private $rewardsStaticsTable = 'rewards_statics';
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	/**
	 * Получить сохраненные периоды (бланки)
	 * @param 
	 * @return 
	*/
	public function getPeriods($order = 'DESC') {
		$this->db->order_by('id', $order);
		$this->db->limit(30);
		$query = $this->db->get($this->rewardsPeriodsTable);
		if (!$result = $query->result_array()) return false;
		
		$reportsPeriods = $this->_getReportsPeriods();
		
		$data = [];
		foreach ($result as $row) {
			$rowPeriods = json_decode($row['reports_periods'], true);
			$row['reports_periods'] = array_intersect_key($reportsPeriods, array_flip($rowPeriods));
			$data[] = $row;
		}
		
		return $data ?: false;
	}
	
	
	
	
	
	
	/**
	 * Получить данные периода
	 * @param
	 * @return 
	*/
	public function getPeriod($periodId = false) {
		if (!$periodId) return false;
		$this->db->where('id', $periodId);
		$periodData = $this->_row($this->rewardsPeriodsTable);
		$periodData['reports_periods'] = json_decode($periodData['reports_periods'], true);
		return $periodData;
	}
	
	
	
	
	/**
	 * Получить плетежные периоды из премиального периода
	 * @param 
	 * @return 
	*/
	public function getRewardsPeriodData($rewardsPeriodId = false) {
		if (!$rewardsPeriodId) return false;
		$this->db->select('rp.reports_periods, rs.static_id');
		$this->db->join('rewards_statics rs', 'rs.reward_period_id = rp.id');
		$this->db->where('rp.id', $rewardsPeriodId);
		$periodsData = $this->_result($this->rewardsPeriodsTable.' rp');
		
		$reportsPeriods = []; $statics = [];
		foreach ($periodsData as $row) {
			$reportsPeriods[] = json_decode($row['reports_periods'], true);
			$statics[] = $row['static_id'];
		}
		
		$reportsPeriods = call_user_func_array('array_merge', $reportsPeriods);
		
		return [
			'reports_periods'	=> array_values(array_unique($reportsPeriods)),
			'statics'			=> array_values(array_unique($statics))
		];
	}
	
	
	
	
	
	
	/**
	 * Получить список платежных периодов
	 * @param
	 * @return 
	*/
	public function getReportsPeriods() {
		$this->db->select('id, name');
		$this->db->order_by('id', 'DESC');
		$this->db->limit(50);
		if (!$data = $this->_result('reports_periods')) return false;
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список премиальных периодов
	 * @param только активные
	 * @return 
	*/
	public function getRewardsPeriods($onlyActve = true) {
		if ($onlyActve) $this->db->where('stat', 1);
		if (!$result = $this->_result($this->rewardsPeriodsTable)) return false;
		return $result;
	}
	
	

	
	
	/**
	 * Добавить новый период
	 * @param 
	 * @return 
	*/
	public function addPeriod($postData = false) {
		if (!$postData) return false;
		$insData = [
			'title' 			=> $postData['title'],
			'reports_periods' 	=> json_encode($postData['periods']),
			'date' 				=> time()
		];
		if (!$this->db->insert($this->rewardsPeriodsTable, $insData)) return false;
		return true;
	}
	
	
	
	
	/**
	 * Добавить новый период
	 * @param 
	 * @return 
	*/
	public function updatePeriod($postData = false) {
		if (!$postData) return false;
		$upData = [
			'title' 			=> $postData['title'],
			'reports_periods' 	=> json_encode($postData['periods'])
		];
		$this->db->where('id', $postData['period_id']);
		if (!$this->db->update($this->rewardsPeriodsTable, $upData)) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * Изменить статус периода и заморозить звания
	 * @param 
	 * @return 
	*/
	public function changePeriodStat($postData = false) {
		
		$stat = $postData['stat'];
		
		if ($stat) {
			$this->db->select('reports_periods');
			$this->db->where('id', $postData['period_id']);
			if (!$reportsPeriods = $this->_row($this->rewardsPeriodsTable)) return false;
			$reportsPeriods = json_decode($reportsPeriods, true);
			
			$this->db->select('ru.user_id');
			$this->db->join('raids r', 'ru.raid_id = r.id', 'LEFT OUTER');
			$this->db->where_in('r.period_id', (array)$reportsPeriods);
			$this->db->where('r.is_key', 0);
			if ($raidsUsers = $this->_result('raid_users ru')) {
				$raidsUsersIds = array_column($raidsUsers, 'user_id');
				$raidsUsersIds = array_values(array_unique($raidsUsersIds));
				
				$this->db->select('u.id AS user_id, r.coefficient AS rank_coefficient');
				$this->db->join('ranks r', 'u.rank = r.id', 'LEFT OUTER');
				$this->db->where_in('u.id', $raidsUsersIds);
				if ($usersData = $this->_result('users u')) {
					$usersRanks = [];
					foreach ($usersData as $user) {
						$rank = json_decode($user['rank_coefficient'], true);
						$usersRanks[] = [
							'reward_period_id'	=> $postData['period_id'],
							'user_id' 			=> $user['user_id'],
							'rank_coefficient' 	=> (float)$rank[2]
						];
					}
					
					if ($usersRanks) {
						$this->db->where('reward_period_id', $postData['period_id']);
						$this->db->delete('rewards_ranks');
						$this->db->insert_batch('rewards_ranks', $usersRanks);
					}
				}
			}
			
		}
		
		$this->db->where('id', $postData['period_id']);
		if (!$this->db->update($this->rewardsPeriodsTable, ['stat' => $stat])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * Получить списсок статиков с Окладно-премиальным форматом оплаты
	 * @param 
	 * @return 
	*/
	public function getStatics() {
		$this->db->where('payformat', 1);
		if (!$statics = $this->_result('statics')) return false;
		return setArrKeyFromField($statics, 'id');
	}
	
	
	
	
	
	
	/**
	 * Получить платежные периоды премиального периода
	 * @param
	 * @return 
	*/
	public function getRewardReportsPeriods($rewardPeriodId = false) {
		if (!$rewardPeriodId) return false;
		$this->db->where('id', $rewardPeriodId);
		$reportsPeriods = $this->_row($this->rewardsPeriodsTable, 'reports_periods');
		$reportsPeriods = json_decode($reportsPeriods, true);
		
		$appPeriods = $this->_getReportsPeriods();
		$rewardReportsPeriods = array_intersect_key($appPeriods, array_flip($reportsPeriods));
		return $rewardReportsPeriods;
	}
	
	
	
	
	
	
	
	
	/**
	 * Получить суммы статиков
	 * @param 
	 * @return 
	*/
	public function getStaticsSumm($rewardPeriodId = false, $staticId = false) {
		if (!$rewardPeriodId) return false;
		if (is_array($rewardPeriodId)) $this->db->where_in('reward_period_id', $rewardPeriodId);
		else $this->db->where('reward_period_id', $rewardPeriodId);
		
		if ($staticId && is_array($staticId)) $this->db->where_in('static_id', $staticId);
		elseif ($staticId) $this->db->where('static_id', $staticId);
		
		if (!$amounts = $this->_result($this->rewardsStaticsTable)) return false;
		
		$data = [];
		if ($staticId && !is_array($staticId)) {
			foreach ($amounts as $item) {
				$data[$item['report_period_id']] = $item['summ'];
			}
		} else {
			foreach ($amounts as $item) {
				$data[$item['report_period_id']][$item['static_id']] = $item['summ'];
			}
		}
		
		return $data;
	}
	
	
	
	
	
	
	/**
	 * Получить общую сумму статика
	 * @param 
	 * @return 
	*/
	public function getTotalStaticSumm($rewardPeriodId = false, $staticId = false) {
		if (!$rewardPeriodId || !$staticId) return false;
		$this->db->select('SUM(summ) AS total_summ');
		$this->db->where('reward_period_id', $rewardPeriodId);
		$this->db->where('static_id', $staticId);
		if (!$totalSumm = $this->_row($this->rewardsStaticsTable)) return false;
		return $totalSumm;
	}
	
	
	
	
	
	
	/**
	 * Задать суммы статиков
	 * @param 
	 * @return 
	*/
	public function setStaticsSumm($data = false) {
		if (!$data) return false;
		
		$insData = [];
		foreach ($data['amounts'] as $peroidId => $statics) {
			foreach ($statics as $staticId => $summ) {
				$insData[] = [
					'reward_period_id'	=> $data['reward_period_id'],
					'report_period_id'	=> $peroidId,
					'static_id'			=> $staticId,
					'summ'				=> $summ
				];
			}
				
		}
		
		$this->db->where('reward_period_id', $data['reward_period_id']);
		$this->db->delete($this->rewardsStaticsTable);
		
		$this->db->insert_batch($this->rewardsStaticsTable, $insData);		
	}
	
	
	
	
	
	
	/**
	 * Изменить статус
	 * @param ID премиального периода
	 * @param статус
	 * @return bool
	*/
	public function setWalletStat($rewardPeriodId = false, $stat = true) {
		if (!$rewardPeriodId || !$stat) return false;
		$this->db->where('id', $rewardPeriodId);
		if (!$this->db->update('rewards_periods', ['to_wallet' => ($stat === true ? 1 : $stat)])) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * Сформировать отчет
	 * @param ID периода
	 * @return 
	*/
	public function getReportData($rewardPeriodId = false, $statics, $reportsPeriods) {
		if (!$rewardPeriodId) return false;
		$this->db->where('reward_period_id', $rewardPeriodId);
		if (!$result = $this->_result('rewards_statics')) return false;
		
		$data = [
			'report' => [],
			'periods' => [],
			'statics' => [],
			'total_statics' => [],
			'total_periods' => []
		];
		foreach ($result as $row) {
			$data['report'][$row['static_id']][$row['report_period_id']] = $row['summ'];
			
			if (!isset($data['periods'][$row['report_period_id']])) $data['periods'][$row['report_period_id']] = $reportsPeriods[$row['report_period_id']];
			if (!isset($data['statics'][$row['static_id']])) $data['statics'][$row['static_id']] = $statics[$row['static_id']];
			
			
			if (!isset($data['total_periods'][$row['report_period_id']])) $data['total_periods'][$row['report_period_id']] = $row['summ'];
			else $data['total_periods'][$row['report_period_id']] += $row['summ'];
			
			if (!isset($data['total_statics'][$row['static_id']])) $data['total_statics'][$row['static_id']] = $row['summ'];
			else $data['total_statics'][$row['static_id']] += $row['summ'];
			
		}
		
		return $data;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getRewardsRanks($rewardPeriodId = false) {
		if (!$rewardPeriodId) return false;
		
		if (is_array($rewardPeriodId)) $this->db->where_in('reward_period_id', $rewardPeriodId);
		else $this->db->where('reward_period_id', $rewardPeriodId);
		
		if (!$data = $this->_result('rewards_ranks')) return false;
		return setArrKeyFromField($data, 'user_id', 'rank_coefficient');
	}
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	/**
	 * Получить список платежных периодов
	 * @param 
	 * @return 
	*/
	private function _getReportsPeriods() {
		$this->db->select('id, name');
		if (!$result = $this->_result('reports_periods')) return false;
		return setArrKeyFromField($result, 'id', false, 'name');
	}
	
	
	
	
	
	
}