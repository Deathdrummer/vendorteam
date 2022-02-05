<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Coefficients_model extends MY_Model {
	
	private $raidsTable = 'raids';
	private $raidsUsersTable = 'raid_users';
	private $reportsPeriodsTable = 'reports_periods';
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function period($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			case 'periods':
				$this->db->order_by('id', 'DESC');
				if (!$periods = $this->_result('reports_periods')) return false;
				return $periods;
				break;
			
			default:
				if (!$periodId) $periodId = $this->_getLastPeriodId();
				
				$this->db->select('cd.user_id, cd.persones_count, cd.effectiveness, cd.fine');
				$this->db->where(['cd.period_id' => $periodId, 'cd.static_id' => $staticId]);
				$queryCd = $this->db->get('compounds_data cd');
				
				$resData = [];
				$respCd = [];
				if ($respCd = $queryCd->result_array()) {
					$respCd = setArrKeyFromField($respCd, 'user_id');
				}
				
				
				$this->db->select('u.id, u.avatar, u.nickname, u.color, EXISTS (SELECT 1 FROM resign r WHERE r.user_id = u.id AND r.date_last > '.time().') AS is_resign');
				$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
				$this->db->where(['us.static_id' => $staticId, 'verification' => 1, 'deleted' => 0, 'excluded' => 0]);
				$queryU = $this->db->get('users u');
				if (!$respU = $queryU->result_array()) return false;
				$respU = setArrKeyFromField($respU, 'id');
				
				$resData = array_replace_recursive($respU, array_intersect_key($respCd, $respU)); // тут нет исключенных
				
				$this->db->select('ru.id, r.id AS raid_id, r.date, ru.user_id, ru.rate, rt.name');
				$this->db->where(['r.period_id' => $periodId, 'r.static_id' => $staticId, 'r.is_key' => 0]);
				$this->db->where_in('ru.user_id', array_keys($resData)); // исключить из рейдов исключенных
				$this->db->join('raid_users ru', 'ru.raid_id = r.id');
				$this->db->join('raids_types rt', 'rt.id = r.type', 'left outer');
				$queryR = $this->db->get('raids r');
				
				
				
				$rData = []; $raids = [];
				foreach ($queryR->result_array() as $item) {
					$raids[$item['raid_id']] = [
						'name' => $item['name'],
						'date' => $item['date'],
					];
					$rData[$item['user_id']]['raids'][$item['raid_id']] = ['id' => $item['id'], 'rate' => $item['rate']];
					
					if (!isset($rData[$item['user_id']]['rate_summ'])) $rData[$item['user_id']]['rate_summ'] = $item['rate'];
					else $rData[$item['user_id']]['rate_summ'] += $item['rate']; 
				}
				
				
				$compoundsData = array_replace_recursive($resData, $rData);
				
				$periodName = $this->_getPeriodName($periodId);
				
				return ['compounds_data' => $compoundsData, 'raids' => $raids, 'period_name' => $periodName];
				
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function user($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			default:
				$this->db->select('cd.period_id, cd.user_id, cd.static_id, cd.persones_count, cd.effectiveness, cd.fine');
				$this->db->where('cd.user_id', $userId);
				if ($periods) $this->db->where_in('cd.period_id', $periods);
				$this->db->order_by('cd.period_id', 'DESC');
				if (!$queryCd = $this->_result('compounds_data cd')) return false;
				
				$compoundsData = [];
				foreach ($queryCd as $row) {
					$rowPeriodId = arrTakeItem($row, 'period_id');
					$rowStaticId = arrTakeItem($row, 'static_id');
					$compoundsData[$rowStaticId][$rowPeriodId] = $row;
				}
				
				$this->db->select('ru.id, r.period_id, r.static_id, r.id AS raid_id, r.date, ru.rate, r.type');
				$this->db->where(['ru.user_id' => $userId, 'r.is_key' => 0]);
				if ($periods) $this->db->where_in('r.period_id', $periods);
				$this->db->join('raid_users ru', 'ru.raid_id = r.id');
				if (!$queryR = $this->_result('raids r')) return false;
				
				$raids = []; $allRaidsCount = 0;
				foreach ($queryR as $item) {
					if (!isset($raids[$item['static_id']][$item['period_id']]['summ_coeffs'])) $raids[$item['static_id']][$item['period_id']]['summ_coeffs'] = $item['rate'] ?: 0;
					else $raids[$item['static_id']][$item['period_id']]['summ_coeffs'] += $item['rate'] ?: 0;
					$raids[$item['static_id']][$item['period_id']]['raids'][$item['raid_id']] = $item;
					$allRaidsCount += 1;
				}
				
				
				$periodsData = array_replace_recursive($compoundsData, $raids);
				
				return ['data' => $periodsData, 'raids_count' => $allRaidsCount];
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPeriodsNames($periodsIds = false, $order = 'ASC') {
		if ($periodsIds) $this->db->where_in('id', $periodsIds);
		$this->db->select('id, name AS period_name');
		$this->db->order_by('id', $order);
		if (!$periodsNames = $this->_result('reports_periods')) return false;
		return setArrKeyFromField($periodsNames, 'id');
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-----------------------------------------------------------------------------
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getLastPeriodId() {
		$this->db->order_by('id', 'DESC');
		if (!$periodId = $this->_row('reports_periods', 'id')) return false;
		return $periodId;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getPeriodName($periodId = false) {
		if (!$periodId) return false;
		$this->db->where('id', $periodId);
		if (!$periodName = $this->_row('reports_periods', 'name')) return false;
		return $periodName;
	}
	
	
	
	
}