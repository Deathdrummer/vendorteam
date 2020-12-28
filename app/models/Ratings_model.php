<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Ratings_model extends My_Model {
	
	private $ratingsDataTable = 'ratings_data';
	private $ratingsPeriodsTable = 'ratings_periods';
	private $ratingsHistoryTable = 'ratings_history';
	private $ratingsNotifyTable = 'ratings_notifycations';
	private $historyTypes = [
		1 => 'Активность',
		2 => 'Личный скилл',
		3 => 'Штрафы',
		4 => 'Коэффициент посещений',
		5 => 'Выговоры',
		6 => 'Форс мажорные выходныые',
		7 => 'Стимулирование',
	];
	private $historyFrom = [
		0 => 'Админ'
	];


	public function __construct() {
		parent::__construct();
		
	}
	
	
	
	
	
	
	/**
	 * Получить созраненные периоды (бланки)
	 * @param 
	 * @return 
	*/
	public function getPeriods($order = 'DESC') {
		$this->db->order_by('id', $order);
		$this->db->limit(30);
		$query = $this->db->get($this->ratingsPeriodsTable);
		if (!$result = $query->result_array()) return false;
		
		$this->db->select('id, name');
		$pQuery = $this->db->get('reports_periods');
		if (!$pResult = $pQuery->result_array()) return false;
		$periods = setArrKeyFromField($pResult, 'id', false, 'name');
		
		$data = [];
		foreach ($result as $row) {
			$row['reports_periods'] = json_decode($row['reports_periods'], true);
			foreach ($row['reports_periods'] as $k => $periodId) {
				$row['reports_periods'][$k] = $periods[$periodId];
			}
			$data[] = $row;
		}
		return $data ?: false;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getReportsPeriods() {
		$this->db->select('id, name');
		$this->db->order_by('id', 'DESC');
		$this->db->limit(50);
		$query = $this->db->get('reports_periods');
		return $query->result_array();
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function addPeriod($postData = false) {
		if (!$postData) return false;
		$insData = [
			'title' 			=> $postData['title'],
			'reports_periods' 	=> json_encode($postData['periods']),
			'visits_date'		=> strtotime($postData['visits_date']),
			'date' 				=> time()
		];
		if (!$this->db->insert($this->ratingsPeriodsTable, $insData)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Задать активный период
	 * @param 
	 * @return 
	*/
	public function setActivePeriod($ratingPeriodId = false) {
		if (!$ratingPeriodId) return false;
		$this->db->update($this->ratingsPeriodsTable, ['active' => 0]);
		$this->db->where('id', $ratingPeriodId);
		if (!$this->db->update($this->ratingsPeriodsTable, ['active' => 1])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * Сохранить период
	 * @param 
	 * @return 
	*/
	/*public function savePeriod($ratingPeriodId = false) {
		if (!$ratingPeriodId) return false;
		$this->load->model(['reprimands_model' => 'reprimands', 'forcemajeure_model' => 'forcemajeure', 'stimulation_model' => 'stimulation']);
		
		$forcemajeure = $this->forcemajeure->getFromPeriod($ratingPeriodId);
		$reprimands = $this->reprimands->getFromPeriod($ratingPeriodId);
		$stimulation = $this->stimulation->getFromPeriod($ratingPeriodId);
		
		$this->db->where('period_id', $ratingPeriodId);
		if (!$result = $this->_result($this->ratingsDataTable)) return false;
		$ratingsData = setArrKeyFromField($result, 'user_id', true);
		
		$ratingsData = array_replace_recursive($ratingsData, $forcemajeure, $reprimands, $stimulation);
		
		if (!$this->db->update_batch($this->ratingsDataTable, $ratingsData, 'id')) return false;
		return true;
	}*/
	
	
	
	
	
	
	
	
	/**
	 * Получить данные для отчета
	 * @param 
	 * @return 
	*/
	public function getReport($ratingPeriodId = false) {
		if (!$ratingPeriodId) return false;
		
		$this->load->model(['reprimands_model' => 'reprimands', 'forcemajeure_model' => 'forcemajeure', 'stimulation_model' => 'stimulation']);
		$forcemajeure = $this->forcemajeure->getFromPeriod($ratingPeriodId);
		$reprimands = $this->reprimands->getFromPeriod($ratingPeriodId);
		$stimulation = $this->stimulation->getFromPeriod($ratingPeriodId);
		$mentors = $this->_getMentorsPeriodList($ratingPeriodId);
		
		$this->db->select('rd.*, u.nickname, u.avatar, ra.name AS role, ro.name AS rank');
		$this->db->join('users u', 'u.id = rd.user_id', 'LEFT OUTER');
		$this->db->join('roles ro', 'u.role = ro.id', 'LEFT OUTER');
		$this->db->join('ranks ra', 'u.rank = ra.id', 'LEFT OUTER');
		$this->db->where('rd.period_id', $ratingPeriodId);
		if (!$result = $this->_result($this->ratingsDataTable.' rd')) return false;
		$ratingsData = setArrKeyFromField($result, 'user_id', true);
		$ratingsData = array_replace_recursive($ratingsData, $forcemajeure, $reprimands, $stimulation, $mentors);
		
		$data = [];
		foreach ($ratingsData as $item) {
			if (!isset($item['static_id'])) continue;
			$data[$item['static_id']][] = $item;
		}
		
		return $data;
	}
	
	
	
	
	/**
	 * Получить список завершенных менторств
	 * @param ID периода
	 * @return array
	*/
	protected function _getMentorsPeriodList($periodId = false) {
		if (!$periodId) return false;
		$this->db->select('mentor_id, COUNT(id) AS mentor');
		$this->db->where(['period_id' => $periodId, 'done !=' => 'null']);
		$this->db->group_by('mentor_id');
		if (!$result = $this->_result('mentors_requests')) return false;
		$data = setArrKeyFromField($result, 'mentor_id');
		return $data;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Сохранить отчет
	 * @param 
	 * @return 
	*/
	public function saveReport($data = false) {
		if (!$data) return false;
		if (!$this->db->update_batch($this->ratingsDataTable, array_values($data), 'id')) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * Персонажи и ошибки участника за последние 4 сохраненных периода выплат
	 * @param ID периода
	 * @return array
	*/
	public function getPeriodsInfo($periodId = false) {
		if (!$periodId) return false;
		
		$ratingsPeriodData = $this->getActiveRatingsPeriod($periodId);
		
		$this->db->select('cd.period_id, cd.static_id, cd.user_id, cd.persones_count, cd.fine');
		$this->db->join('users_statics us', 'us.user_id = cd.user_id');
		$this->db->where('us.main', 1);
		$this->db->where_in('cd.period_id', array_keys($ratingsPeriodData['reports_periods']));
		$this->db->order_by('cd.period_id', 'ASC');
		$personesQuery = $this->db->get('compounds_data cd');
		if (!$personesResult = $personesQuery->result_array()) return false;
		
		$data = ['periods_names' => $ratingsPeriodData['reports_periods'], 'data' => []];
		foreach ($personesResult as $item) {
			$data['data'][$item['static_id']][$item['user_id']][$item['period_id']] = [
				'persones'	=> $item['persones_count'],
				'fine' 		=> $item['fine']
			];
		}
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getUsersForRating() {
		$this->db->select('u.id, us.static_id, u.nickname, u.avatar, ra.name AS role, ro.name AS rank');
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->join('roles ro', 'u.role = ro.id', 'LEFT OUTER');
		$this->db->join('ranks ra', 'u.rank = ra.id', 'LEFT OUTER');
		$this->db->where('u.deleted', 0);
		$this->db->where('u.verification', 1);
		$this->db->where('us.main', 1);
		$query = $this->db->get('users u');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	
	
	
	
	/**
	 * Получить уже созраненные данные по заданному периоду и статику
	 * @param 
	 * @return 
	*/
	public function getSavedRatingsdata($periodId = false, $staticId = false) {
		if (!$periodId || !$staticId) return false;
		$this->db->where(['period_id' => $periodId, 'static_id' => $staticId]);
		
		$query = $this->db->get('ratings_data');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	
	
	
	
	
	/**
	 * Получить список пользователей статиков, вернуть пользователей по главному статику в котором состоит участник 
	 * @return array users[static => users]
	*/
	public function getUsers() {
		
		$ratingsPeriodId = $this->getActiveRatingsPeriodId();
		$select = '';
		if ($ratingsPeriodId) {
			$select = ', (SELECT COUNT(f.id) FROM forcemajeure f WHERE f.user_id = u.id AND rating_period_id = '.$ratingsPeriodId.') AS forcemajeure, (SELECT COUNT(r.id) FROM reprimands r WHERE r.user_id = u.id AND rating_period_id = '.$ratingsPeriodId.') AS reprimands, (SELECT s.index FROM stimulations s WHERE s.user_id = u.id AND rating_period_id = '.$ratingsPeriodId.') AS stimulation';
		}
		
		$this->db->select('u.id, u.nickname, u.avatar, us.static_id, ra.name AS role, ro.name AS rank'.$select);
		$this->db->join('roles ro', 'u.role = ro.id', 'LEFT OUTER');
		$this->db->join('ranks ra', 'u.rank = ra.id', 'LEFT OUTER');
		$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
		$this->db->where('u.deleted', 0);
		$this->db->where('u.verification', 1);
		$this->db->where('us.main', 1);
		$query = $this->db->get('users u');
		if (!$response = $query->result_array()) return false;
		
		$users = [];
		foreach ($response as $item) {
			$staticId = arrTakeItem($item, 'static_id');
			$users[$staticId][] = $item;
		}
		return $users;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Добавить в историю действие по рейтингам
	 * @param from: от кого положительные числа - пользователь, отрицательные - оператор, 0 - админ
	 * @param to: кому
	 * @param type: тип
	 * @param data: ID записи
	 * @param status: статус записи
	 * @return void
	*/
	public function addToRatingHistory($data = false, $multiple = false) {
		if (!$data) return false;
		
		if ($multiple) {
			$insData = [];
			foreach ($data as $item) {
				$item['date'] = time();
				if (!isJson($item['data'])) $item['data'] = json_encode($item['data']);
				$insData[] = $item;
			}
			
			if (!$this->db->insert_batch($this->ratingsHistoryTable, $insData)) return false;
			return true;
		}
		
		$data['date'] = time();
		if (!isJson($data['data'])) $data['data'] = json_encode($data['data']);
		if (!$this->db->insert($this->ratingsHistoryTable, $data)) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * Получить список истории действий по рейтингу
	 * @param смещение
	 * @return array
	*/
	public function getRatingHistory($data = false, $types = 'coeffs') {
		$limit = 30;
		$this->db->select('rh.*, u.nickname, u.avatar, ra.name AS role, ro.name AS rank');
		$this->db->join('users u', 'rh.to = u.id');
		$this->db->join('roles ro', 'u.role = ro.id', 'LEFT OUTER');
		$this->db->join('ranks ra', 'u.rank = ra.id', 'LEFT OUTER');
		if (isset($data['search']) && $data['search']) $this->db->like('u.nickname', $data['search'], 'both');
		
		if ($types == 'coeffs') $this->db->where_in('rh.type', [1, 2, 3, 4]);
		elseif ($types == 'others') $this->db->where_in('rh.type', [5, 6, 7]);
		$this->db->order_by('rh.id', 'DESC');
		
		if (isset($data['offset']) && $data['offset']) $this->db->limit($limit, ($limit * $data['offset']));
		else $this->db->limit($limit);
		
		if (!$result = $this->_result($this->ratingsHistoryTable.' rh')) return false;
		
		$data = [];
		foreach ($result as $item) {
			$item['data'] = json_decode($item['data'], true);
			$item['from'] = $this->historyFrom[$item['from']];
			$item['type'] = $this->historyTypes[$item['type']];
			$data[] = $item; 
		}
		
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить статистику заполнения коэффиентов
	 * @param 
	 * @return 
	*/
	public function getRatingStatistics() {
		if (!$ratingsPeriodId = $this->getActiveRatingsPeriodId()) return false;
		
		
		$this->db->select('static_id, '.$this->groupConcat('period_id', 'period_id', 'periods'));
		//$this->db->where('period_id', $ratingsPeriodId);
		$this->db->group_by('static_id');
		//$this->db->order_by('periods', 'DESC');
		if (!$result = $this->_result($this->ratingsDataTable)) return false;
		
		$data = [];
		foreach ($result as $item) {
			$data[$item['static_id']] = json_decode($item['periods'], true);
		}
		return $data;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Добавить в таблицу данные для оповещения РЛ
	 * @param 
	 * @return 
	*/
	public function notifyRaidliders($periodId = false) {
		if (!$periodId) return false;
		$this->db->select('user_id, static_id');
		$this->db->where('lider', 1);
		if (!$result = $this->_result('users_statics')) return false;
		
		$insData = array_map(function($item) use($periodId) {
			$item['period_id'] = $periodId;
			return $item;
		}, $result);
		
		$this->db->truncate($this->ratingsNotifyTable);
		if (!$this->db->insert_batch($this->ratingsNotifyTable, $insData)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
}