<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class MY_Model extends CI_Model {
	
	protected $monthes = [1 => 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
	protected $timezoneOffset;
	
	public function __construct() {
		parent::__construct();
		
		$this->timezoneOffset = date('Z'); // смещение временной зоны в секундах
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
		if ($fieldAsKey) return setArrKeyFromField($result, $fieldAsKey, true);
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
	 * @param поле для теста (есть ли данные) false - нет поверки данных
	 * @param все поля "поле в таблице1":"название поля1",поле в таблице2":"название поля2", ... Если оба названия схожи - то просто одно название
	 * @param название поля при выводе данных
	 * @param уникальные значения
	 * @return string
	*/
	protected function groupConcat($concatTest = false, $concatData = false, $fieldname = false, $distinct = false) {
		if (!$concatData || !$fieldname) return '';
		
		$finalConcat = '';
		if ($cData = preg_split("/[\s,]+/", $concatData)) {
			foreach ($cData as $k => $item) {
				$item = explode(':', $item);
				if (isset($item[1])) $finalConcat .= "'$item[1]'".", ".$item[0].", ";
				else $finalConcat .= "'$item[0]'".", ".$item[0].", ";
			}
		}
		
		if ($concatTest === false) {
			return "CAST(CONCAT('[', GROUP_CONCAT(".($distinct ? 'distinct' : '')." JSON_OBJECT(".rtrim($finalConcat, ', ').")), ']') AS JSON) AS ".$fieldname;
		} else {
			return "IF(GROUP_CONCAT(".$concatTest."), CAST(CONCAT('[', GROUP_CONCAT(".($distinct ? 'distinct' : '')." JSON_OBJECT(".rtrim($finalConcat, ', ').")), ']') AS JSON), NULL) AS ".$fieldname;
		}
	}
	
	
	
	
	
	
	
	/**
	 * Добавить в запрос concat value
	 * @param поле для теста объединения (есть ли данные) false - нет поверки данных
	 * @param название поля dв таблице:название поля на выходе
	 * @param уникальные значения
	 * @return string
	*/
	protected function groupConcatValue($concatField = false, $fieldname = false, $distinct = false) {
		if (!$fieldname) return '';
		
		$fieldData = explode(':', $fieldname);
		$fieldname = $fieldData[0];
		$outputField = isset($fieldData[1]) ? $fieldData[1] : $fieldData[0];
		
		if ($concatField === false) {
			return "CAST(CONCAT('[', GROUP_CONCAT(".($distinct === true ? 'distinct' : '')." ".$fieldname."), ']') AS JSON) AS ".$outputField;
		} else {
			return "IF(GROUP_CONCAT(".$concatField."), CAST(CONCAT('[', GROUP_CONCAT(".($distinct === true ? 'distinct' : '')." ".$concatField."), ']') AS JSON), NULL) AS ".$outputField;
		}
	}
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Все значения из списка. Пример: $this->db->where($this->jsonSearchAll(items, field));
	 * @param искомые значения mixed
	 * @param поле таблицы в котором искать
	 * @return string
	 */
	public function jsonSearchAll($items = false, $field = false) {
		if (!is_array($items) && preg_match('/\s/', $items)) $items = preg_split("/?,\s+/", $items);
		$str = '';
		if (is_array($items)) {
			foreach ($items as $item) {
				if (is_integer($item)) $str .= $item.', ';
				else $str .= '"'.$item.'", ';
			}
		} else {
			if (is_integer($items)) $str .= $items.', ';
			else $str .= '"'.$items.'", ';
		}
		
		return "JSON_CONTAINS(".$field.", '[".rtrim($str, ', ')."]')";
	}
	
	
	
	
	/**
	 * Любое из значений списка. Пример: $this->db->where($this->jsonSearch(items, field));
	 * @param искомые значения mixed
	 * @param поле таблицы в котором искать
	 * @return string
	 */
	public function jsonSearch($items = false, $field = false) {
		if (!is_array($items) && preg_match('/\s/', $items)) $items = preg_split("/?,\s+/", $items);
		$str = '(';
		
		if (is_array($items)) {
			foreach ($items as $item) {
				if (is_numeric($item)) $str .= "JSON_CONTAINS(".$field.", '[".$item."]') OR ";
				else $str .= "JSON_CONTAINS(".$field.", '[\"".$item."\"]') OR ";
			} 
		} else {
			if (is_numeric($items)) $str .= "JSON_CONTAINS(".$field.", '[".$items."]') OR ";
			else $str .= "JSON_CONTAINS(".$field.", '[\"".$items."\"]') OR ";
		}
		
		$str = rtrim($str, ' OR ').')';
		
		return $str != '()' ? $str : '';
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
	
	
	
	
	
	
	protected function getAdminId() {
		if ($token = get_cookie('token')) return decrypt($token);
		return 0;
	}
	
	
	protected function _isCliRequest() {
		return (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/Wget\//', $_SERVER['HTTP_USER_AGENT']));
	}
	
	
	
	
	// 
	/*SELECT user_id,
    count(*) AS total,
    SUM(case when date_taking IS NULL then 1 else 0 end) AS count_waiting,
    SUM(case when date_taking IS NOT NULL then 1 else 0 end) AS count_taking
	FROM users_gifts
	GROUP BY user_id*/
	
	
	
}