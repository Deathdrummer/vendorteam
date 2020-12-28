<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class MY_Model extends CI_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	
	/**
	 * Добавить в запрос concat
	 * @param поле для теста (есть ли данные)
	 * @param все поля
	 * @param название поля
	 * @return string
	*/
	protected function groupConcat($concatTest = false, $concatData = false, $fieldname = false) {
		if (!$concatTest || !$concatData || !$fieldname) return '';
		
		$finalConcat = '';
		if ($cData = preg_split("/,\s+/", $concatData)) {
			if (count($cData) == 1) $finalConcat = "GROUP_CONCAT(distinct ".reset($cData).")";
			else {
				foreach ($cData as $k => $item) {
					if ($k == 0 || $k % 2 == 0) $item = "'$item'";
					$finalConcat .= $item.', ';
				}
				$finalConcat = "GROUP_CONCAT(distinct JSON_OBJECT(".rtrim($finalConcat, ', ')."))";
			}
		}
		
		return "IF(GROUP_CONCAT(".$concatTest."), CAST(CONCAT('[', ".$finalConcat.", ']') AS JSON), NULL) AS ".$fieldname;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Получить все значения заданного поля
	 * @param название таблицы
	 * @param название поля
	 * @return массив значений поля
	*/
	protected function _getField($table = false, $field = false) {
		if (!$table || !$field) return false;
		$this->db->select($field);
		$query = $this->db->get($table);
		$fieldData = [];
		if ($result = $query->result_array()) {
			foreach ($result as $item) {
				$fieldData[] = $item[$field];
			}
		}
		return $fieldData;
	}
	
	
	
	
	/**
	 * Выполнить запрос к БД с возвратом множества записей
	 * @param название таблицы
	 * @param качестве ключа вернуть поле
	 * @param перемешать массив
	 * @return array
	*/
	protected function _result($table = false, $fieldAsKey = false, $rand = false) {
		if (!$table) return false;
		$query = $this->db->get($table);
		if (!$result = $query->result_array()) return false;
		if ($rand) shuffle($result);
		if ($fieldAsKey) return arrSetKeyFromField($result, $fieldAsKey, true);
		return $result;
	}
	
	
	
	/**
	 * Выполнить запрос к БД с возвратом одной записи
	 * @param название таблицы
	 * @param вернуть поле
	 * @return array или значение заданного поля
	*/
	protected function _row($table = false, $returnField = false) {
		if (!$table) return false;
		if ($returnField) $this->db->select($returnField);
		$query = $this->db->get($table);
		if (!$result = $query->row_array()) return false;
		if ($returnField && isset($result[$returnField])) return $result[$returnField];
		if (count($result) == 1) return current($result);
		return $result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------
	
	
	
	
	
	/**
	 * Получить данные периода рейтингов
	 * @param true - текущий (активный) период, ID периода
	 * @return 
	*/
	protected function getActiveRatingsPeriod($periodId = false) {
		if ($periodId === false) return false;
		if ($periodId !== true) $this->db->where('id', $periodId);
		else $this->db->where('active', 1);
		$query = $this->db->get('ratings_periods');
		if (!$result = $query->row_array()) return false;
		$result['reports_periods'] = json_decode($result['reports_periods'], true);
		
		$this->db->select('id, name');
		$this->db->where_in('id', $result['reports_periods']);
		$this->db->order_by('id', 'DESC');
		$rpQuery = $this->db->get('reports_periods');
		if (!$rpResult = $rpQuery->result_array()) return false;
		$result['reports_periods'] = array_reverse(setArrKeyFromField($rpResult, 'id', false, 'name'), true) ?: false;
		return $result;
	}
	
	
	
	
	
	
	/**
	 * Получить ID активного периода рейтингов
	 * @param 
	 * @return 
	*/
	protected function getActiveRatingsPeriodId() {
		$this->db->select('id');
		$this->db->where('active', 1);
		$query = $this->db->get('ratings_periods');
		if (!$result = $query->row_array()) return false;
		return $result['id'];
	}
	
	
	
	
	
	
	
	
}