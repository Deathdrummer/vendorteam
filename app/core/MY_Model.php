<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class MY_Model extends CI_Model {
	
	public function __construct() {
		parent::__construct();
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
	
	
	
	
	
	
	
	/**
	 * Получить данные из таблицы + количество записей без лимитов
	 * @param название таблицы
	 * @param лимит
	 * @param смещение
	 * @return array [data, total]
	*/
	protected function _resultWithCount($table = false, $limit = false, $offset = 0) {
		if (!$table) return false;
		$query = $this->db->get_compiled_select($table, false);
		if ($limit) $this->db->limit($limit, $offset);
		$respone = $this->db->query($query);
		$count = $respone->result_id->num_rows ?: null;
		
		$itemsQuery = $this->db->get();
		$items = $itemsQuery->result_array();
		
		return [
			'items'	=> $items,
			'total' => $count
		];
	}
	
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	/**
	 * Добавить в запрос concat
	 * @param поле для теста (есть ли данные)
	 * @param все поля "название поля1":"поле в таблице1","название поля2":"поле в таблице2". Если оба названия схожи - то просто одно название
	 * @param название поля при выводе данных
	 * @param уникальные значения
	 * @return string
	*/
	protected function groupConcat($concatTest = false, $concatData = false, $fieldname = false, $distinct = false) {
		if (!$concatTest || !$concatData || !$fieldname) return '';
		
		$finalConcat = '';
		if ($cData = preg_split("/,\s+/", $concatData)) {
			foreach ($cData as $k => $item) {
				$item = explode(':', $item);
				$finalConcat .= "'$item[0]'".", ".(isset($item[1]) ? $item[1] : $item[0]).", ";
			}
		}
		
		return "IF(GROUP_CONCAT(".$concatTest."), CAST(CONCAT('[', GROUP_CONCAT(".($distinct ? 'distinct' : '')." JSON_OBJECT(".rtrim($finalConcat, ', ').")), ']') AS JSON), NULL) AS ".$fieldname;
	}
	
	
	
	
	
	
	
	/**
	 * Добавить в запрос concat value
	 * @param поле для теста объединения
	 * @param название поля
	 * @param уникальные значения
	 * @return string
	*/
	protected function groupConcatValue($concatField = false, $fieldname = false, $distinct = false) {
		if (!$concatField || !$fieldname) return '';
		return "IF(GROUP_CONCAT(".$concatField."), CAST(CONCAT('[', GROUP_CONCAT(".($distinct === true ? 'distinct' : '')." ".$concatField."), ']') AS JSON), NULL) AS ".$fieldname;
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