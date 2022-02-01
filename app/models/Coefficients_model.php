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
	public function data($action = false) {
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