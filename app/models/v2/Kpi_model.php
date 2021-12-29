<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Kpi_model extends MY_Model {
	
	private $fieldsTable = 'kpiv2_fields';
	private $dataTable = 'kpiv2_data';
	private $fieldsMap = [
		'id' 		=> 'account_id',	
		'бустер' 	=> 'booster',
		'сервер' 	=> 'server',		
		'персонаж' 	=> 'personage'	
	];
	
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function import($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			case 'init':
				break;
			
			default:
				if ($importExcelFile['error'] !== 0) exit('0');
				if (!file_exists($importExcelFile['tmp_name'])) return false;
				if (!$importData = json_decode(@file_get_contents($importExcelFile['tmp_name'] ?? []), true)) return false;
				
				$customFields = $this->_getFieldsMap(); // [title => id] кастомные поля, созданные на сайте и их ID 
				$tableLastBoosters = $this->_getLastBoosters(); // [id => booster]
				$date = time();
				
				
				$importBuildedData = [];
				foreach ($importData as $row) {
					$buildedRow = [];
					foreach ($row as $field => $value) {
						$field = mb_strtolower(trim(str_replace(['\n', '\r'], '', $field)));
						
						if (array_key_exists($field, $this->fieldsMap)) {
							$buildedRow[$this->fieldsMap[$field]] = $this->fieldsMap[$field] == 'booster' ? [$date => $value] : $value;
						} elseif ($customFields && array_key_exists($field, $customFields)) {
							$buildedRow['_custom_fields_'][$customFields[$field]] = $value;
						}
					}
					
					$hash = md5($buildedRow['account_id'].$buildedRow['server'].$buildedRow['personage']);
					$importBuildedData[$hash] = $buildedRow;
				}
				
				$dataToInsert = false; $dataToUpdate = false;
				if ($dataFromTable = $this->_getDataFromTable(array_keys($importBuildedData))) {
					
					$importedRowsToUpdate = array_intersect_key($importBuildedData, $dataFromTable);
					$replacedData = array_replace_recursive($dataFromTable, $importedRowsToUpdate);
					$dataToUpdate = array_values(array_map(function($row) {
						$newRow['id'] = $row['id'];
						$newRow['_custom_fields_'] = json_encode($row['_custom_fields_']);
						
						$importedBooster = end($row['booster']) ?? false;
						$lastBooster = prev($row['booster']) ?? false;
						
						if ($lastBooster && $lastBooster === $importedBooster) $row['booster'] = array_slice($row['booster'], 0, (count($row['booster']) - 1), true);
						$newRow['booster'] = json_encode($row['booster']);
						
						return $newRow;
					}, $replacedData));
					
					$dataToInsert = array_diff_key($importBuildedData, $dataFromTable);
				
				} else {
					$dataToInsert = $importBuildedData;
				}
				
				
				$dataToInsert = array_values(array_map(function($row) {
					$row['_custom_fields_'] = json_encode($row['_custom_fields_']);
					$row['booster'] = json_encode($row['booster']);
					return $row;
				}, $dataToInsert));
				
				
				if ($dataToInsert) $this->db->insert_batch($this->dataTable, $dataToInsert);
				if ($dataToUpdate) if ($dataToUpdate) $this->db->update_batch($this->dataTable, $dataToUpdate, 'id');
				return true;
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function fields($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'get':
				$this->db->where('choosed', null);
				$this->db->order_by('id', 'DESC');
				if (!$fields = $this->_result($this->fieldsTable)) return false;
				return setArrKeyFromField($fields, 'id');
				break;
			
			case 'get_choosed':
				$this->db->where('choosed', 1);
				$this->db->order_by('sort', 'ASC');
				if (!$fields = $this->_result($this->fieldsTable)) return false;
				return setArrKeyFromField($fields, 'id');
				break;
				
			case 'add':
				return $this->db->insert($this->fieldsTable, ['title' => $fieldTitle, 'width' => $fieldWidth, 'type' => $fieldType, 'center' => $fieldCenter]);
				break;
			
			case 'edit':
				$this->db->select('id, title, width, type, center');
				$this->db->where('id', $id);
				if (!$row = $this->_row($this->fieldsTable)) return false;
				return $row;
				break;
			
			case 'update':
				$this->db->where('id', $id);
				return $this->db->update($this->fieldsTable, ['title' => $fieldTitle, 'width' => $fieldWidth, 'type' => $fieldType, 'center' => $fieldCenter]);
				break;
			
			case 'set_choosed':
				$this->db->update($this->fieldsTable, ['choosed' => null, 'sort' => null]);
				if (isset($fields)) $this->db->update_batch($this->fieldsTable, $fields, 'id');
				return true;
				break;
			
			case 'remove':
				$this->db->where('id', $id);
				return $this->db->delete($this->fieldsTable);
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function table($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'all':
				if (!$tableData = $this->_result($this->dataTable)) return false;
				$data = [];
				foreach ($tableData as $row) {
					$customFields = $row['_custom_fields_'] ? json_decode($row['_custom_fields_'], true) : [];
					unset($row['_custom_fields_']);
					
					$bustersRow = $row['booster'] ? json_decode($row['booster'], true) : null;
					$lastDate = is_array($bustersRow) ? max(array_keys($bustersRow)) : null;
					$row['booster'] = $bustersRow[$lastDate] ?? null;
					
					$data[] = $customFields ? array_replace($row, $customFields) : $row;
				}
				
				return $data;
				break;
			
			case 'boosters':
				$this->db->select('id, booster');
				if (!$fields = $this->_result($this->dataTable)) return false;
				foreach ($fields as $k => $row) $fields[$k]['booster'] = $row['booster'] ? json_decode($row['booster'], true) : null;
				return setArrKeyFromField($fields, 'id', 'booster');
				break;
			
			case 'custom_fields':
				$this->db->select('id, custom_fields');
				if (!$fields = $this->_result($this->dataTable)) return false;
				foreach ($fields as $k => $row) $fields[$k]['custom_fields'] = $row['custom_fields'] ? json_decode($row['custom_fields'], true) : null;
				return setArrKeyFromField($fields, 'id', 'custom_fields');
				break;
			
			case 'boosters_history':
				$this->db->select('booster');
				$this->db->where('id', $id);
				if (!$boostersData = $this->_row($this->dataTable, 'booster')) return false;
				$boostersData = json_decode($boostersData, true);
				krsort($boostersData);
				return $boostersData;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------
	
	
	
	
	/**
	 * Получить массив полей и их ID
	 * @param 
	 * @return 
	 */
	private function _getFieldsMap() {
		$this->db->select('id, LOWER(title) AS title');
		$this->db->where('choosed', 1);
		if (!$fields = $this->_result($this->fieldsTable)) return false;
		return setArrKeyFromField($fields, 'title', 'id');
	}
	
	
	
	
	
	/**
	 * Получить хэш данные из таблицы
	 * @param 
	 * @return 
	 */
	private function _getDataFromTable($hashArr = false) {
		if (!$hashArr) return false;
		$md5 = 'md5(CONCAT(`account_id`, `server`, `personage`))';
		$this->db->select("id, $md5 AS hash, booster, _custom_fields_");
		$this->db->where_in($md5, $hashArr);
		if (!$result = $this->_result($this->dataTable)) return false;
		foreach ($result as $k => $row) {
			$result[$k]['_custom_fields_'] = json_decode($row['_custom_fields_'], true);
			$result[$k]['booster'] = json_decode($row['booster'], true);
		} 
		return setArrKeyFromField($result, 'hash');
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getLastBoosters() {
		$this->db->select('id, booster');
		if (!$fields = $this->_result($this->dataTable)) return false;
		
		$result = [];
		foreach ($fields as $row) {
			$bustersRow = $row['booster'] ? json_decode($row['booster'], true) : null;
			$lastDate = is_array($bustersRow) ? max(array_keys($bustersRow)) : null;
			$result[$row['id']] = $bustersRow[$lastDate] ?? null;
		}
		return $result;
	}
	
	
}