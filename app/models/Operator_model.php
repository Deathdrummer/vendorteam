<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Operator_model extends MY_Model {
	
	private $operatorId = false;
	
	public function __construct() {
		parent::__construct();
		$this->operatorId = get_cookie('operator_id'); //$this->session->userdata('operator_id');
	}
	
	
	
	
	/**
	 * Получить данные аккаунта оператора
	 * @param 
	 * @return 
	 */
	public function getOperatorData($where = false) {
		if (!$where) $this->db->where('id', $this->operatorId);
		elseif (is_array($where)) $this->db->where($where);
		$query = $this->db->get('operators');
		if (!$data = $query->row_array()) return false;
		$data['access'] = json_decode($data['access'], true);
		$accessStatics = json_decode($data['statics'], true);
		$data['statics'] = [];
		if ($statics = $this->admin_model->getStatics(true)) {
			
			$data['statics'] = array_intersect_key($statics, array_flip($accessStatics));
		}
		
		return $data;
	}
	
	
	/**
	 * Задать данные оператора
	 * @param 
	 * @return 
	 */
	public function setOperatorData($setData) {
		$this->db->where('id', $this->operatorId);
		if ($this->db->count_all_results('operators') == 0) return false;
		$this->db->where('id', $this->operatorId);
		$this->db->set($setData);
		if ($this->db->update('operators')) return true;
		return false;
	}
	
	
	
	
	/**
	 * Получить список несохраненных периодов
	 * @param ID периода
	 * @return 
	 */
	public function getReportsPeriods($periodId = false) {
		if (!$periodId) {
			//$this->db->where('saved !=', 1);
			$this->db->where('archive !=', 1);
			$this->db->order_by('id', 'DESC');
			$query = $this->db->get('reports_periods');
			return $query->result_array();
		}
		
		$this->db->where('id', $periodId);
		$query = $this->db->get('reports_periods');
		return $query->row_array();
	}
	
	
	/**
	 * Получить название активного периода
	 * @param 
	 * @return 
	 */
	public function getActiveReportsPeriod() {
		$this->db->where(['active' => 1, 'closed' => 0]);
		$query = $this->db->get('reports_periods');
		if ($response = $query->row_array()) {
			return [
				'id'	=> $response['id'],
				'name' 	=> $response['name'],
			];
		} else {
			return 0;
		}
	}
	
	
	
	
	
	
	/**
	 * Получить список типов рейдов
	 * @param 
	 * @return 
	 */
	public function getRaidsTypes() {
		$this->db->select('id, name');
		$query = $this->db->get('raids_types');
		if (!$response = $query->result_array()) return false;
		$data = [];
		foreach ($response as $item) {
			$data[$item['id']] = $item['name'];
		}
		return $data;
	}
	
	
	
	
	/**
	 * Получить список типов ключей
	 * @param 
	 * @return 
	 */
	public function getKeysTypes() {
		$this->db->select('id, name');
		$query = $this->db->get('keys_types');
		if (!$response = $query->result_array()) return false;
		$data = [];
		foreach ($response as $item) {
			$data[$item['id']] = $item['name'];
		}
		return $data;
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
		if ($isKey !== false) $this->db->where('rp.is_key', $isKey);
		$this->db->order_by('rp.id', 'DESC');
		$this->db->order_by('rps.id');
		$query = $this->db->get('reports_patterns rp');
		
		if (!$response = $query->result_array()) return [];
		
		$newData = [];
		foreach ($response as $k => $item) {
			$itemId = $item['id'];
			$newData[$itemId]['report_name'] = $item['report_name'];
			$newData[$itemId]['period_id'] = $item['period_id'];
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
	 * Редактировать коэффициенты пользователей в рейдах
	 * @param 
	 * @return 
	 */
	public function editRaidKoeff($koeffData = false) {
		if (!$koeffData) return false;
		$this->db->update_batch('raid_users', $koeffData, 'id');
		return true;
	}
	
	
	/**
	 * Редактировать типы рейдов
	 * @param 
	 * @return 
	 */
	public function editRaidTypes($rTypesData = false) {
		if (!$rTypesData) return false;
		$this->db->update_batch('raids', $rTypesData, 'id');
		return true;
	}
	
	
	
	
	
	
	/**
	 * Удалить рейд
	 * @param 
	 * @return 
	 */
	public function deleteRaid($raidId) {
		$this->db->where('raid_id', $raidId);
		$this->db->delete('raid_orders');
		
		$this->db->where('raid_id', $raidId);
		$this->db->delete('raid_users');
		
		$this->db->where('id', $raidId);
		$this->db->delete('raids');
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	/*private function _getRaidUsers($periodId = null, $isKey = 0) {
		if (is_null($periodId)) return [];
		$this->db->select('ru.rate, ru.raid_id, ru.user_id, r.static_id');
		$this->db->join('raids r', 'ru.raid_id = r.id');
		$this->db->where('r.period_id', $periodId);
		$this->db->where('r.is_key', $isKey);
		$queryRu = $this->db->get('raid_users ru');
		if (!$resultRu = $queryRu->result_array()) return [];
		$raidUsers = [];
		foreach ($resultRu as $i) $raidUsers[$i['static_id']][$i['user_id']]['raids'][$i['raid_id']] = $i['rate'];
		return $raidUsers;
	}*/
	
	
	
	
	
	
	/**
	 * Получить compounds_data
	 * @param 
	 * @return 
	 */
	private function _getCompoundsData($periodId = null) {
		if (is_null($periodId)) return [];
		$this->db->where('period_id', $periodId);
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
		$this->db->select('rpp.user_id, rpp.pay_done');
		$this->db->where('rpp.report_pattern_id', $patternId);
		$queryRpp = $this->db->get('reports_patterns_payments rpp');
		if (!$resultRpp = $queryRpp->result_array()) return [];
		return setArrKeyFromField($resultRpp, 'user_id');
	}
	
	
	
	
	/**
	 * 	Получить данные из истории Резервов
	 * @param 
	 * @return 
	 */
	public function _getDepositHistories() {
		$query = $this->db->get('deposit_history dh');
		if(!$result = $query->result_array()) return [];
		$data = [];
		foreach ($result as $item) $data[$item['report_pattern_id']][$item['static_id']][$item['user_id']] = $item['cash'];
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------- Заказы
	/**
	 * Отчет по заказам
	 * @param 
	 * @return 
	 */
	public function getRaidsOrders($periodId = false) {
		$this->db->select('r.date, ro.raid_id, ro.id As order_id, ro.value AS order, rt.name AS raid_type, s.id AS static_id, s.name AS static_name, u.nickname AS from');
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
			$result[$row['static_id']][$row['raid_id']]['from'] = $row['from'];
			$result[$row['static_id']][$row['raid_id']]['date'] = $row['date'];
			$result[$row['static_id']][$row['raid_id']]['name'] = $row['raid_type'];
			$result[$row['static_id']][$row['raid_id']]['orders'][$row['order_id']] = $row['order'];
		}
		return $result;
	}
	
	
	
	
	
	/**
	 * Обновить заказы
	 * @param 
	 * @return 
	 */
	public function updateRaidsOrders($data) {
		return $this->db->update_batch('raid_orders', $data, 'id');
	}
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------- Сообщения и жалобы
	
	/**
	 * @param 
	 * @return 
	 */
	public function getMessages() {
		$this->db->select('mto.id, mto.type, mto.message, mto.date, mto.stat, u.avatar AS from_avatar, u.nickname AS from_nickname, u.email AS from_email');
		$this->db->where('to', $this->operatorId);
		$this->db->join('users u', 'u.id = mto.from');
		$this->db->order_by('mto.date', 'DESC');
		$query = $this->db->get('messages_to_operators mto');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	
	
	
	/**
	 * Изменить статус сообщения или жалобы
	 * @param 
	 * @return 
	 */
	public function changeMessageStat($data) {
		$this->db->where('id', $data['id']);
		return $this->db->update('messages_to_operators', ['stat' => $data['stat']]);
	}
	
	
	
	
	
	
	
}