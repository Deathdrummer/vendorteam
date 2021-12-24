<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Kpi_model extends MY_Model {
	
	private $fieldsTable = 'kpiv2_fields';
	private $dataTable = 'kpiv2_data';
	
	public function __construct() {
		parent::__construct();
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
			
			case 'get_map':
				$this->db->select('id, LOWER(title) AS title');
				$this->db->where('choosed', 1);
				if (!$fields = $this->_result($this->fieldsTable)) return false;
				return setArrKeyFromField($fields, 'title', 'id');
				break;
				
			case 'add':
				return $this->db->insert($this->fieldsTable, ['title' => $fieldTitle, 'width' => $fieldWidth]);
				break;
			
			case 'edit':
				$this->db->select('id, title, width');
				$this->db->where('id', $id);
				if (!$row = $this->_row($this->fieldsTable)) return false;
				return $row;
				break;
			
			case 'update':
				$this->db->where('id', $id);
				return $this->db->update($this->fieldsTable, ['title' => $fieldTitle, 'width' => $fieldWidth]);
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
					$customFields = json_decode($row['custom_fields'], true);
					unset($row['custom_fields']);
					
					
					$bustersRow = $row['booster'] ? json_decode($row['booster'], true) : null;
					$lastDate = is_array($bustersRow) ? max(array_keys($bustersRow)) : null;
					$row['booster'] = $bustersRow[$lastDate] ?? null;
					
					
					$data[] = array_replace($row, $customFields);
				}
				
				return $data;
				break;
			
			case 'import_data':
				$constFields = [
					'id' 		=> 'account_id',	
					'сервер' 	=> 'server',		
					'персонаж' 	=> 'personage', 	
					'бустер' 	=> 'booster'
				];
				
				
				$customFields = $this->fields('get_map'); // [title => id]
				$md5TableFields = $this->table('md5'); // [md5 => id]
				$tableLastBooster = $this->table('last_boosters'); // [id => booster]
				$tableBoosters = $this->table('boosters'); // [id, booster]
				$tableCustomFields = $this->table('custom_fields'); // [id, custom_fields]
				
				$dataToInsert = []; $dataToUpdate = []; $updateBoosters = [];
				foreach ($importData as $k => $importRow) {
					$buildRow = [];
					foreach ($importRow as $name => $value) {
						$name = mb_strtolower(trim(str_replace(['\n', '\r'], '', $name)));
						if (array_key_exists($name, $constFields)) $buildRow[$constFields[$name]] = $value;
						elseif (array_key_exists($name, $customFields)) $buildRow['custom_fields'][$customFields[$name]] = $value;
					}
					
					$importFieldsMd5 = md5($buildRow['account_id'].$buildRow['server'].$buildRow['personage']);
					
					if (in_array($importFieldsMd5, array_keys($md5TableFields))) { // update
						$booster = $buildRow['booster'];
						unset($buildRow['account_id'], $buildRow['server'], $buildRow['personage'], $buildRow['booster']);
						$rowId = $md5TableFields[$importFieldsMd5];
						
						if ($booster !== $tableLastBooster[$rowId]) $updateBoosters[$rowId] = $booster;
						
						$buildCustomFields = isset($buildRow['custom_fields']) ? json_encode(array_replace((array)$tableCustomFields[$rowId], $buildRow['custom_fields'])) : false;
						
						if ($buildCustomFields) {
							$buildRow['id'] = $rowId;
							$buildRow['custom_fields'] = $buildCustomFields;
							$dataToUpdate[] = $buildRow;
						} 
						
					} else { // insert
						$date = time();
						$booster = $buildRow['booster'];
						$buildRow['custom_fields'] = $buildRow['custom_fields'] ? json_encode($buildRow['custom_fields']) : null;
						$buildRow['booster'] = json_encode([$date => $booster]);
						$dataToInsert[] = $buildRow;
					} 
				}
				
				
				if ($dataToInsert) $this->db->insert_batch($this->dataTable, $dataToInsert);
				if ($dataToUpdate) $this->db->update_batch($this->dataTable, $dataToUpdate, 'id');
				if ($updateBoosters) {
					$date = time();
					$boostersToUpdate = [];
					foreach ($updateBoosters as $id => $booster) {
						$tableBoosters[$id][$date] = $booster;
						$boostersToUpdate[] = [
							'id' 		=> $id,
							'booster'	=> json_encode($tableBoosters[$id])
						];
					}
					
					if ($boostersToUpdate) $this->db->update_batch($this->dataTable, $boostersToUpdate, 'id');
				}
							
				return true;
				break;
			
			case 'md5':
				$this->db->select('id, md5(CONCAT(`account_id`, `server`, `personage`)) AS md5');
				if (!$fields = $this->_result($this->dataTable)) return false;
				return setArrKeyFromField($fields, 'md5', 'id');
				break;
			
			case 'boosters':
				$this->db->select('id, booster');
				if (!$fields = $this->_result($this->dataTable)) return false;
				foreach ($fields as $k => $row) $fields[$k]['booster'] = $row['booster'] ? json_decode($row['booster'], true) : null;
				return setArrKeyFromField($fields, 'id', 'booster');
				break;
			
			case 'last_boosters':
				$this->db->select('id, booster');
				if (!$fields = $this->_result($this->dataTable)) return false;
				
				$result = [];
				foreach ($fields as $row) {
					$bustersRow = $row['booster'] ? json_decode($row['booster'], true) : null;
					$lastDate = is_array($bustersRow) ? max(array_keys($bustersRow)) : null;
					$result[$row['id']] = $bustersRow[$lastDate] ?? null;
				}
				return $result;
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
	
	
	
	
}