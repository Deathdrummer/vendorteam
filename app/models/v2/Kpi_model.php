<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Kpi_model extends MY_Model {
	
	private $fieldsTable 		= 'kpiv2_fields';
	private $dataTable 			= 'kpiv2_data';
	private $kpiPeriodsTable	= 'kpiv2_periods';
	private $kpiAmountsTable	= 'kpiv2_amounts';
	private $kpiReportsTable	= 'kpiv2_reports';
	private $kpiReportDataTable	= 'kpiv2_report_data';
	private $raidsTable 		= 'raids';
	private $raidsUsersTable	= 'raid_users';
	private $usersTable			= 'users';
	private $usersStaticsTable	= 'users_statics';
	private $fieldsMap = [
		'id' 		=> 'account_id',
		'бустер' 	=> 'booster',
		'сервер' 	=> 'server',
		'персонаж' 	=> 'personage'
	];
	
	private $fieldsProgressMap = [
		'бустер'	=> 'booster',
		'%' 		=> 'progress',
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
				
				
				$importBuildedData = []; $boosters = [];
				foreach ($importData as $row) {
					$buildedRow = [];
					foreach ($row as $field => $value) {
						$field = mb_strtolower(trim(str_replace(['\n', '\r'], '', $field)));
						
						if (array_key_exists($field, $this->fieldsMap)) {
							$buildedRow[$this->fieldsMap[$field]] = $this->fieldsMap[$field] == 'booster' ? [$date => $value] : $value;
							if ($this->fieldsMap[$field] == 'booster') $boosters[] = mb_strtolower($value);
						} elseif ($customFields && array_key_exists($field, $customFields)) {
							$buildedRow['_custom_fields_'][$customFields[$field]] = $value;
						}
					}
					
					$hash = md5($buildedRow['account_id'].$buildedRow['server'].$buildedRow['personage']);
					$importBuildedData[$hash] = $buildedRow;
				}
				
				
				$boostersStatics = $this->_getBostersStatics($boosters);
				
				
				$dataToInsert = false; $dataToUpdate = false;
				if ($dataFromTable = $this->_getDataFromTable(array_keys($importBuildedData))) {
					
					$importedRowsToUpdate = array_intersect_key($importBuildedData, $dataFromTable);
					$replacedData = array_replace_recursive($dataFromTable, $importedRowsToUpdate);
					$dataToUpdate = array_values(array_map(function($row) use($boostersStatics) {
						$newRow['id'] = $row['id'];
						$newRow['_custom_fields_'] = json_encode($row['_custom_fields_']);
						
						$importedBooster = end($row['booster']) ?? false;
						$lastBooster = prev($row['booster']) ?? false;
						
						if ($lastBooster && $lastBooster === $importedBooster) $row['booster'] = array_slice($row['booster'], 0, (count($row['booster']) - 1), true);
						$newRow['booster'] = json_encode($row['booster']);
						
						$newRow['static'] = $boostersStatics[mb_strtolower($importedBooster)] ?? 0;
						
						return $newRow;
					}, $replacedData));
					
					$dataToInsert = array_diff_key($importBuildedData, $dataFromTable);
				
				} else {
					$dataToInsert = $importBuildedData;
				}
				
				
				$dataToInsert = array_values(array_map(function($row) use($boostersStatics) {
					$row['_custom_fields_'] = json_encode($row['_custom_fields_']);
					
					$booster = mb_strtolower(reset($row['booster'])) ?? false;
					$row['static'] = $boostersStatics[$booster] ?? 0;
					
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
			
			case 'to_find':
				$fields = [
					'account_id' 	=> 'ID аккаунта',
					'server' 		=> 'Сервер',
					'personage' 	=> 'Персонаж',
					'booster' 		=> 'Бустер'
				];
				
				if ($customFields = $this->fields('get_choosed')) {
					foreach ($customFields as $id => $row) $fields[$id] = $row['title'];
				}
				
				return $fields;
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
	public function periods($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			case 'get':
				$this->db->select('id, title, date_start, date_end');
				$this->db->order_by('id', 'DESC');
				$this->db->limit(30);
				if (!$result = $this->_result($this->kpiPeriodsTable)) return false;
				return $result;
				break;
			
			case 'add':
				$data['title'] = ucfirst(trim($title)) ?? null;
				$data['date_start'] = strtotime($dateStart) ?? null;
				$data['date_end'] = strtotime($dateEnd) ?? null;
				$data['payout_type'] = (int)$payoutType ?? null;
				$data['report_period'] = (int)$reportPeriod ?? null;
				$data['statics_koeffs'] = $staticsKoeffs ? json_encode($staticsKoeffs) : null;
				
				if (!$this->db->insert($this->kpiPeriodsTable, $data)) return false;
				$periodId = $this->db->insert_id();
				
				//if (!$this->addUsersStatics($periodId, $data['statics'])) return false;
				
				return true;
				break;
			
			case 'activatePeriod':
				if (!$periodId) return false;
				$this->db->update($this->kpiPeriodsTable, ['active' => 0]);
				$this->db->where('id', $periodId);
				return $this->db->update($this->kpiPeriodsTable, ['active' => 1]);
				break;
			
			case 'publishPeriod':
				if (!$periodId) return false;
				$this->db->update($this->kpiPeriodsTable, ['published' => 0]);
				$this->db->where('id', $periodId);
				return $this->db->update($this->kpiPeriodsTable, ['published' => 1]);
				break;
			
			case 'removeKpiPeriod':
				if (!$periodId) return false;
				
				$this->db->where('period_id', $periodId);
				$this->db->delete($this->kpiPlanFieldsTable);
				
				$this->db->where('period_id', $periodId);
				$this->db->delete($this->kpiPlanPersonagesTable);
				
				$this->db->where('period_id', $periodId);
				$this->db->delete($this->kpiProgressCustomTable);
				
				$this->db->where('period_id', $periodId);
				$this->db->delete($this->kpiProgressPersonagesTable);
				
				$this->db->where('id', $periodId);
				$this->db->delete($this->kpiPeriodsTable);
				
				return true;
				break;
			
			case 'payoutType':
				$this->db->where('id', $periodId);
				if (!$payoutType = $this->_row($this->kpiPeriodsTable, 'payout_type')) return false;
				return $payoutType;
				break;
			
			case 'reportPeriod':
				$this->db->where('id', $periodId);
				if (!$reportPeriod = $this->_row($this->kpiPeriodsTable, 'report_period')) return false;
				return $reportPeriod;
				break;
			
			case 'staticsKoeffs':
				$this->db->where('id', $periodId);
				if (!$staticsKoeffs = $this->_row($this->kpiPeriodsTable, 'statics_koeffs')) return false;
				return json_decode($staticsKoeffs, true);
				break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function amounts($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			case 'get':
				if ($payoutType ?? false) {
					$this->db->select('static_id, rank_id, amount');
					$this->db->where('payout_type', $payoutType);
					if (!$result = $this->_result($this->kpiAmountsTable)) return false;
					return arrRestructure($result, 'static_id rank_id', 'amount', true);
				} 
				
				if (!$result = $this->_result($this->kpiAmountsTable)) return false;
				return arrRestructure($result, 'static_id rank_id payout_type', 'amount', true);
				break;
			
			case 'item':
				$this->db->where(['static_id' => $staticId, 'rank_id' => $rankId, 'payout_type' => $payoutType]);
				break;
			
			case 'set':
				$this->db->where(['static_id' => $staticId, 'rank_id' => $rankId, 'payout_type' => $payoutType]);
				$tableData = $this->_row($this->kpiAmountsTable);
				
				if ($tableData) {
					$this->db->where(['static_id' => $staticId, 'rank_id' => $rankId, 'payout_type' => $payoutType]);
					return $this->db->update($this->kpiAmountsTable, ['amount' => $amount]);
				} 
				
				return $this->db->insert($this->kpiAmountsTable, [
					'static_id'		=> $staticId,
					'rank_id' 		=> $rankId,
					'amount'		=> $amount,
					'payout_type'	=> $payoutType
				]);
				break;
			
			case 'calcSumm':
				$this->db->where(['static_id' => $static, 'rank_id' => $rank, 'payout_type' => $payoutType]);
				if (($amount = $this->_row($this->kpiAmountsTable, 'amount')) === false) return 0;
				return (($amount / 100) * $progress);
				break;
			
			case 'calcProgress':
				$this->db->where(['static_id' => $static, 'rank_id' => $rank, 'payout_type' => $payoutType]);
				if (($amount = $this->_row($this->kpiAmountsTable, 'amount')) === false) return 0;
				$onePercent = $amount ? $amount / 100 : 0;
				if ($summ == 0 || $onePercent == 0) return 0;
				return $summ / $onePercent;
				break;
			
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function importProgress($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			default:
				
				$PeymentReportPeriod = $this->periods('reportPeriod', ['period_id' => $periodId]);	 // ID платежного периода
				// $periodId // ID KPI периода
				
				
				if ($importExcelFile['error'] !== 0) exit('0');
				if (!file_exists($importExcelFile['tmp_name'])) return false;
				if (!$importData = json_decode(@file_get_contents($importExcelFile['tmp_name'] ?? []), true)) return false;
				
				$importBuildedData = []; $boosters = [];
				foreach ($importData as $row) {
					$buildedRow = [];
					foreach ($row as $field => $value) {
						$field = mb_strtolower(trim(str_replace(['\n', '\r'], '', $field)));
						if (array_key_exists($field, $this->fieldsProgressMap)) {
							$buildedRow[$this->fieldsProgressMap[$field]] = is_numeric($value) ? (float)$value : mb_strtolower($value);
							if ($this->fieldsProgressMap[$field] == 'booster') $boosters[] = mb_strtolower($value);
						}
					}
					$importBuildedData[$buildedRow['booster']] = $buildedRow;
				}
				
				$boostersData = $this->_getBoostersDataFromNicknames($boosters);
				$boostersStatics = $this->_getBostersStatics($boosters);
				$payoutType = $this->periods('payoutType', ['period_id' => $periodId]);
				$amountsData = $this->amounts('get', ['payout_type' => $payoutType]); // static rank => amount
				//$periodStaticsKoeffs = $this->periods('staticsKoeffs', ['period_id' => $periodId]);
				$periodStaticsKoeffs = json_decode($staticsKoeffs, true);
				
				
				$payReportKoeffs = $this->_getPaymentReportKoeffs($PeymentReportPeriod); // static user koeff
				
				if (!$mergeData = array_replace_recursive($importBuildedData, $boostersData, $boostersStatics)) return false;
				
				
				$resultData = [];
				foreach ($mergeData as $row) {
					$static = arrTakeItem($row, 'static') ?? 0;
					if (isset($amountsData[$static]) && isset($amountsData[$static][$row['rank']])) {
						$rawSumm = ($amountsData[$static][$row['rank']] / 100) * $row['progress'];
						$koeffUser = $payReportKoeffs[$static][$row['id']] ?? 0;
						$koeffStatic = $periodStaticsKoeffs[$static] ?? $koeffUser;
						$factor = $koeffUser ? ($koeffUser / $koeffStatic) : 1;
						
						$row['koeff_user'] = $koeffUser;
						$row['koeff_static'] = $koeffStatic;
						$row['koeff'] = $koeffUser;
						$row['koeff_percent'] = $factor * 100;
						$row['summ'] = $rawSumm * $factor;
					}
					$resultData[$static][] = $row;
				}
				return $resultData;
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function data($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'all':
				if (isset($searchStr) && isset($searchField)) {
					if ($searchField == 'booster') {
						$this->db->where('booster REGEXP "([^\"])*'.$searchStr.'([^\"])*"');
					} else if (is_numeric($searchField)) {
						$this->db->where('JSON_EXTRACT(`_custom_fields_`, "$[0].\"'.$searchField.'\"") REGEXP \'^.'.$searchStr.'\'');
					}
				}
				
				if (isset($selectedStatics)) {
					if (($noStaticIndex = array_search('nostatic', $selectedStatics)) !== false) {
						array_splice($selectedStatics, $noStaticIndex, 1, 0);
					}
					$this->db->where_in('static', $selectedStatics);
				} 
				
				
				if ($showType == 'table' && isset($sortField) && in_array($sortField, ['account_id', 'server', 'personage']) ) {
					$this->db->order_by($sortField, $sortDir);
				} elseif ($showType == 'list') {
					$this->db->order_by('account_id', 'ASC');
				}
				
			
				if (!$tableData = $this->_result($this->dataTable)) return false;
				
				
				$data = [];
				foreach ($tableData as $row) {
					$customFields = $row['_custom_fields_'] ? json_decode($row['_custom_fields_'], true) : [];
					unset($row['_custom_fields_']);
					
					$bustersRow = $row['booster'] ? json_decode($row['booster'], true) : null;
					$lastDate = is_array($bustersRow) ? max(array_keys($bustersRow)) : null;
					$row['booster'] = $bustersRow[$lastDate] ?? null;
					
					if ($showType == 'list') {
						$static = arrTakeItem($row, 'static');
						$data[$static][$row['account_id']][] = $customFields ? array_replace($row, $customFields) : $row;
					} else {
						$data[] = $customFields ? array_replace($row, $customFields) : $row;
					}
				}
				
				if ($showType == 'table' && isset($sortField) && !in_array($sortField, ['account_id', 'server', 'personage']) ) {
					$sortData = arrSortByField($data, $sortField, $sortDir);
					$staticsData = [];
					foreach ($sortData as $row) {
						$st = arrTakeItem($row, 'static') ?: 0;
						$staticsData[$st][] = $row;
					}
					ksort($staticsData);
					return $staticsData;
				}
				
				if ($showType == 'table') {
					$staticsData = [];
					foreach ($data as $row) {
						$st = arrTakeItem($row, 'static') ?: 0;
						$staticsData[$st][] = $row;
					}
					ksort($staticsData);
					return $staticsData;
				}
				ksort($data);
				return $data;
				break;
			
			case 'toUser':
				$this->db->where('booster REGEXP "([^\"])*'.$booster.'([^\"])*"');
				$this->db->where_in('static', $statics);
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
				
				
				$staticsData = [];
				foreach ($data as $row) {
					$st = arrTakeItem($row, 'static') ?: 0;
					$staticsData[$st][] = $row;
				}
				ksort($staticsData);
				return $staticsData;
				break;
			
			case 'statics':
				return $this->_getStatics($staticsIds ?? false);
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function report($action = false) {
		$args = func_get_args();
		$action = (isset($args[0]) && is_string($args[0])) ? $args[0] : false;
		if ((isset($args[1]) && is_array($args[1])) || (isset($args[0]) && is_array($args[0]))) extract(snakeToCamelcase($args[1] ?? $args[0] ?? null)); // keys to camelcase
		
		switch ($action) {
			case 'get':
				$this->db->where('report_id', $reportId);
				if (!$result = $this->_result($this->kpiReportDataTable)) return false;
				$boostersIds = array_column($result, 'booster_id');
				$boostersData = $this->_getBoostersDataFromIds($boostersIds);
				$reportData = setArrKeyFromField($result, 'booster_id', true);
				return array_replace_recursive($reportData, $boostersData);
				break;
				
			case 'list':
				if (!$reports = $this->_result($this->kpiReportsTable)) return false;
				
				if ($periods = $this->periods('get')) {
					$periods = setArrKeyFromField($periods, 'id', 'title');
				}
				
				foreach ($reports as $k => $row) {
					$reports[$k]['period_name'] = $periods[$row['period_id']] ?? null;
				}
				
				return $reports;
				break;
			
			case 'save':
				// Сохраняем отчет
				$this->db->insert($this->kpiReportsTable, ['period_id' => $periodId, 'title' => $title, 'date' => time()]);
				if (!$savedReportId = $this->db->insert_id()) return false;
				
				
				$reportData = [];
				foreach ($report as $staticId => $boosters) foreach ($boosters as $boosterId => $fields) {
					$reportData[] = [
						'report_id'		=> $savedReportId,
						'booster_id'	=> $boosterId,
						'static_id'		=> $staticId,
						'progress'		=> $fields['progress'] ?: 0,
						'koeff_user'	=> $fields['koeff_user'] ?: 0,
						'koeff_static'	=> $fields['koeff_static'] ?: 0,
						'koeff_percent' => $fields['koeff_percent'] ?: 0,
						'summ'			=> $fields['summ'] ?: 0
					];
				}
				
				
				// Если данные отчета не сохранились - удаляем (откатываем) сохраненный отчет
				if (!$this->db->insert_batch($this->kpiReportDataTable, $reportData)) {
					$this->db->where('id', $savedReportId);
					$this->db->delete($this->kpiReportsTable);
					return false;
				}
				
				
				$boostersIds = array_column($reportData, 'booster_id');
				
				
				$this->load->model(['users_model' => 'users', 'reports_model' => 'reports', 'wallet_model' => 'wallet']);
				$params = ['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $boostersIds], 'fields' => 'nickname avatar payment'];
				$boostersData = $this->users->getUsers($params);
				
				$dateStr = date('j', time()).' '.$this->monthes[date('n', time())].' '.date('Y', time()).' г.';
				$date = time();
				$orders = []; $toWalletData = [];
				foreach ($reportData as $item) {	
					$orders[] = [
						'user_id' 		=> $item['booster_id'],
						'nickname' 		=> $boostersData[$item['booster_id']]['nickname'],
						'avatar' 		=> $boostersData[$item['booster_id']]['avatar'],
						'payment' 		=> $boostersData[$item['booster_id']]['payment'],
						'static' 		=> $item['static_id'],
						'order' 		=> 'KPI',
						'summ' 			=> $item['summ'],
						'to_deposit'	=> 0,
						'comment'		=> $title.' '.$dateStr,
						'date' 			=> $date
					];
					
					if (!isset($toWalletData[$item['booster_id']])) $toWalletData[$item['booster_id']] = (float)$item['summ'];
					else $toWalletData[$item['booster_id']] += (float)$item['summ'];	
				}
				
				if (!$this->reports->insertUsersOrders($orders)) return false;
				
				$this->wallet->setToWallet($toWalletData, 6, 'KPI', '+');
				
				return true;
				break;
			
			case 'export':
				$reportId = $this->uri->segment(4);
				
				$this->db->where('report_id', $reportId);
				if (!$result = $this->_result($this->kpiReportDataTable)) return false;
				$boostersIds = array_column($result, 'booster_id');
				$boostersData = $this->_getBoostersDataFromIds($boostersIds);
				$reportData = setArrKeyFromField($result, 'booster_id', true);
				
				$mergeData = array_replace_recursive($reportData, $boostersData);
				
				$data = [];
				foreach ($mergeData as $row) {
					$static = arrTakeItem($row, 'static_id');
					$data[$static][] = $row;
				}
				
				$statics = $this->_getStatics(array_keys($data) ?? false);
				
				
				$dataToExport = '';
				
				foreach ($data as $staticId => $boosters) {
					$dataToExport .= iconv('UTF-8', 'windows-1251', 'Статик: '.$statics[$staticId]['name']."\r\n");
					$dataToExport .= iconv('UTF-8', 'windows-1251', 'Бустер;Посещаемость;Прогресс;Сумма'."\r\n");
					
					foreach ($boosters as $b) {
						$dataToExport .= iconv('UTF-8', 'windows-1251', $b['nickname'].';'.$b['koeff_percent'].'%;'.$b['progress'].'%;'.str_replace('.', ',', $b['summ']).'р.')."\r\n";
					}
					$dataToExport .= "\r\n";
				}
				
				setHeadersToDownload('application/octet-stream', 'windows-1251');
				echo $dataToExport;
				break;
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
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getBostersStatics($boosters = false) {
		if (!$boosters) return false;
		$this->db->select('LOWER(u.nickname) AS nickname, us.static_id AS static');
		$this->db->join('users_statics us', 'u.id = us.user_id', 'LEFT OUTER');
		$this->db->join('statics s', 's.id = us.static_id', 'LEFT OUTER');
		$this->db->where_in('LOWER(u.nickname)', array_unique($boosters));
		$this->db->where('us.main', 1);
		if (!$usersStatics = $this->_result('users u')) return false;
		return setArrKeyFromField($usersStatics, 'nickname');
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getStatics($staticsIds = false) {
		$this->db->select('id, name, icon');
		if ($staticsIds) $this->db->where_in('id', $staticsIds);
		if (!$statics = $this->_result('statics')) return false;
		
		$data = setArrKeyFromField($statics, 'id');
		$data[0] = ['name' => 'Без статика'];
		return $data;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getBoostersDataFromNicknames($boostersNicknames = false) {
		if (!$boostersNicknames) return false;
		$this->db->select('u.id, LOWER(u.nickname) AS nickname, u.avatar, u.rank');
		$this->db->where_in('LOWER(u.nickname)', array_unique($boostersNicknames));
		if (!$boostersData = $this->_result('users u')) return false;
		return setArrKeyFromField($boostersData, 'nickname');
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getBoostersDataFromIds($boostersIds = false) {
		if (!$boostersIds) return false;
		$this->db->select('u.id, u.nickname, u.avatar, u.rank');
		$this->db->where_in('u.id', array_unique($boostersIds));
		if (!$boostersData = $this->_result('users u')) return false;
		return setArrKeyFromField($boostersData, 'id');
	}
	
	
	
	
	
	/**
	 * Получить коэффициенты платежного периода
	 * @param 
	 * @return 
	 */
	private function _getPaymentReportKoeffs($paymentRepostPeriodId = false) {
		if (!$paymentRepostPeriodId) return false;
		$this->db->select('r.static_id, ru.user_id, SUM(ru.rate) AS koeff');
		$this->db->join($this->raidsTable.' r', 'r.id = ru.raid_id', 'LEFT OUTER');
		$this->db->join($this->usersTable.' u', 'ru.user_id = u.id', 'LEFT OUTER');
		$this->db->join($this->usersStaticsTable.' us', 'u.id = us.user_id', 'LEFT OUTER');
		$this->db->where('r.period_id', $paymentRepostPeriodId);
		$this->db->where('us.main', 1);
		$this->db->where(['u.deleted' => 0, 'u.excluded' => 0, 'u.verification' => 1]);
		$this->db->group_by(['ru.user_id', 'r.static_id']);
		if (!$result = $this->_result($this->raidsUsersTable.' ru')) return false;
		return arrRestructure($result, 'static_id user_id', 'koeff', true);
	}
	
	
}