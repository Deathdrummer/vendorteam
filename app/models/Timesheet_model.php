<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Timesheet_model extends My_Model {
	
	private $userData = false;
	
	public function __construct() {
		parent::__construct();
		if ($userId = $this->getUserId()) {
			$this->load->model('account_model');
			$this->userData = $this->account_model->getUserData($userId/*$this->session->userdata('id')*/);
		}
	}
	
	
	
	
	/**
	 * Получить список периодов расписания
	 * @param ID периода
	 * @return array
	 */
	public function getTimesheetPeriods($periodId = null) {
		if (!is_null($periodId)) $this->db->where('id', $periodId);
		$query = $this->db->get('timesheet_periods');
		if (!is_null($periodId)) $response = $query->row_array();
		else $response = $query->result_array();
		return $response;
	}
	
	
	
	
	/**
	 * Сохранить период расписания
	 * @param 
	 * @return 
	 */
	public function saveTimesheetPeriod($data) {
		$this->db->insert('timesheet_periods', ['name' => $data['name'], 'start_date' => $data['start_date']]);
		return $this->db->insert_id();
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function copyTimesheetPeriod($data = false) {
		if (!$data) return false;
		$this->db->where('period', $data['period_id']);
		if (!$copiedData = $this->_result('timesheet')) return false;
		
		$this->db->insert('timesheet_periods', ['name' => $data['name'], 'start_date' => $data['start_date']]);
		$newPeriodId = $this->db->insert_id();
		
		$dataToCopy = [];
		foreach ($copiedData as $item) {
			unset($item['id']);
			$item['period'] = $newPeriodId;
			$dataToCopy[] = $item;
		}
		
		if (!$this->db->insert_batch('timesheet', $dataToCopy)) return false;
		return true;
	}
	
	
	
	/**
	 * Удалить период расписания
	 * @param 
	 * @return 
	 */
	public function removeTimesheetPeriod($periodId) {
		$this->db->where('id', $periodId);
		$this->db->delete('timesheet_periods');
		
		$this->db->where('period', $periodId);
		$this->db->delete('timesheet');
		return 1;
	}
	
	
	
	
	/**
	 * Получить список типов рейдов
	 * @param 
	 * @return 
	 */
	public function getRaidsTypes() {
		$query = $this->db->get('raids_types');
		$response = $query->result_array();
		return (array)$response;
	}
	
	
	
	
	
	/**
	 * Получить данные выбранного периода
	 * @param ID периода
	 * @param ID статика(ов)
	 * @return array
	 */
	public function getTimesheetData($periodId = null, $staticId = null) {
		if (is_null($periodId)) return false;
		$this->db->select('t.*, t.id AS tid, rt.id AS raid_id, rt.name AS raid_name, rt.end_name AS raid_end_name, rt.color');
		$this->db->where('t.period', $periodId);
		if (!is_null($staticId)) $this->db->where('t.static', $staticId);
		$this->db->join('raids_types rt', 'rt.id = t.raid_type', 'LEFT OUTER');
		$this->db->order_by('tid', 'ASC');
		$query = $this->db->get('timesheet t');
		$response = $query->result_array();
		
		
		$stData = $this->admin_model->getStatics(false, $staticId);
		if ($staticId) $timesheet['statics'][$staticId] = $stData;
		else $timesheet['statics'] = $stData;
		
		
		
		$timesheet['timesheet'] = [];
		if ($response) {
			foreach ($response as $t) {
				$day = $t['day'];
				$static = $t['static'];
				unset($t['period'], $t['day'], $t['static']);
				$timesheet['timesheet'][$static][$day][] = $t;
			}
		}
			
		return $timesheet;
	}
	
	
	
	
	
	
	/**
	 * Добавить новый рейд в расписание
	 * @param Данные
	 * @return статус
	 */
	public function addTimesheetRaid($data) {
		if (isset($data['clone']) && !empty($data['clone'])) {
			$days = array_keys($data['clone']);
			array_unshift($days, $data['day']);
			$insert = [];
			foreach ($days as $day) {
				$insert[] = [
					'period' 		=> $data['period'],
					'day' 			=> $day,
					'static' 		=> $data['static'],
					'raid_type' 	=> $data['raid'],
					'time_start_h'	=> $data['time_start']['h'],
					'time_start_m'	=> $data['time_start']['m'],
					'duration'		=> ($data['duration']['h'] * 60) + $data['duration']['m']
				];
			}
			if ($this->db->insert_batch('timesheet', $insert)) return 1;
			else return 0;
		}
		
		$this->db->set([
			'period' 		=> $data['period'],
			'day' 			=> $data['day'],
			'static' 		=> $data['static'],
			'raid_type' 	=> $data['raid'],
			'time_start_h'	=> $data['time_start']['h'],
			'time_start_m'	=> $data['time_start']['m'],
			'duration'		=> ($data['duration']['h'] * 60) + $data['duration']['m']
		]);
		
		if ($this->db->insert('timesheet')) return 1;
		else return 0;
	}
	
	
	
	
	
	
	/**
	 * Обновить рейд в расписании
	 * @param Данные
	 * @return статус
	 */
	public function updateTimesheetRaid($data) {
		
		if (isset($data['edit']) && !empty($data['edit'])) {
			$editIds = array_keys($data['edit']);
			$update[] = [
				'id'			=> $data['id'],
				'raid_type' 	=> $data['raid'],
				'time_start_h'	=> $data['time_start']['h'],
				'time_start_m'	=> $data['time_start']['m'],
				'duration'		=> ($data['duration']['h'] * 60) + $data['duration']['m']
			];
			foreach ($editIds as $id) {
				$update[] = [
					'id'			=> $id,
					'raid_type' 	=> $data['raid'],
					'time_start_h'	=> $data['time_start']['h'],
					'time_start_m'	=> $data['time_start']['m'],
					'duration'		=> ($data['duration']['h'] * 60) + $data['duration']['m']
				];
			}
			if ($this->db->update_batch('timesheet', $update, 'id') !== false) return 1;
			else return 0;
		}
		
		
		
		$this->db->where('id', $data['id']);
		$updata = [
			'raid_type' 	=> $data['raid'],
			'time_start_h'	=> $data['time_start']['h'],
			'time_start_m'	=> $data['time_start']['m'],
			'duration'		=> ($data['duration']['h'] * 60) + $data['duration']['m']
		];
		
		if ($this->db->update('timesheet', $updata) !== false) return 1;
		else return 0;
	}
	
	
	
	
	
	
	
	/**
	 * Удаление рейда из расписания
	 * @param ID рейда
	 * @return статус
	 */
	public function removeTimesheetRaid($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('timesheet')) return 1;
		else return 0;
	}
	
	
	
	
}