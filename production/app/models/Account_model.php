<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Account_model extends CI_Model {
	
	
	private $userData = false;
	private $locations = [
		1 => [
			'code' => 'u',
			'name' => 'Универсальный'
		],
		2 => [
			'code' => 'e',
			'name' => 'Европа'
		],
		3 => [
			'code' => 'a',
			'name' => 'Америка'
		]
	];
	
	public function __construct() {
		parent::__construct();
		if (!$this->session->userdata('id')) return false;
		$this->userData = $this->getUserData($this->session->userdata('id'));
	}
	
	
	
	
	
	
	/**
	 * Получить данные пользователя
	 * @param 
	 * @return 
	 */
	public function getUserData($userId = null) {
		if ($this->userData) return $this->userData;
		if (is_null($userId)) return false;
		
		$this->db->select('u.*, aa.access');
		$this->db->join('accounts_access aa', 'aa.id = u.access', 'left outer');
		$this->db->where('u.id', $userId);
		
		$query = $this->db->get('users u');
		if ($response = $query->row_array()) {
			$response['access'] = json_decode($response['access'], true);
			unset($response['password']);
			$this->db->select('us.static_id, s.name, s.icon, us.lider, us.main, s.stopstage');
			$this->db->join('statics s', 's.id = us.static_id', 'left outer');
			$this->db->where('us.user_id', $userId);
			$sQuery = $this->db->get('users_statics us');
			
			$response['statics'] = [];
			$response['main_static'] = null;
			
			if ($sResponse = $sQuery->result_array()) {
				foreach ($sResponse as $item) {
					$stId = $item['static_id'] ?: 0;
					unset($item['static_id']);
					if (!$item['name']) $item['name'] = null;
					$response['statics'][$stId] = $item;
					if ($item['main'] == 1) $response['main_static'] = $stId;
				}
			}
			return $response;
		}
		return false;
	}
	
	
	
	
	
	
	
	
	/**
	 * Получить список пользователей статика(ов)
	 * @param вернуть пользователей по определенному статику или всех статиков, в которых состоит участник
	 * @param условия 
	 * @param вернуть и себя тоже (только для аккаунта)
	 * @return array [static => data] или data
	 */
	public function getUsers($currentStatic = false, $where = false, $self = false, $fullInfo = false) {
		$this->db->select('u.id, u.nickname, u.avatar, u.color, us.static_id');
		if ($fullInfo) {
			$this->db->select('ra.name AS role, ro.name AS rank');
			$this->db->join('roles ro', 'u.role = ro.id');
			$this->db->join('ranks ra', 'u.rank = ra.id');
		}
		$this->db->join('users_statics us', 'us.user_id = u.id');
		if (!$self) $this->db->where('u.id !=', $this->userData['id']);
		if ($where && is_array($where)) $this->db->where($where);
		if (!$currentStatic && $this->userData['statics']) $this->db->where_in('us.static_id', array_keys($this->userData['statics']));
		else $this->db->where('us.static_id', $currentStatic);
		//$this->db->order_by('nickname', 'ASC');
		
		$query = $this->db->get('users u');
		if (!$response = $query->result_array()) return false;
		
		$users = [];
		if (!$currentStatic) {
			foreach ($response as $item) {
				$staticId = $item['static_id'];
				unset($item['static_id']);
				$users[$staticId][] = $item;
			}
			return $users;
		} elseif (is_numeric($currentStatic)) {
			return $response;
		}
		
		return false;
	}
	
	
	
	
	
	
	
	
	/**
	 * Задать данные аккаунта
	 * @param 
	 * @return 
	 */
	public function setAccountData($setData) {
		$this->db->where('id', $this->userData['id']);
		if ($this->db->count_all_results('users') == 0) return false;
		$this->db->where('id', $this->userData['id']);
		$this->db->set($setData);
		if ($this->db->update('users')) return true;
		return false;
	}
	
	
	
	
	/**
	 * Задать данные аккаунта
	 * @param 
	 * @return 
	 */
	public function isVerifyUser() {
		if ($this->userData['verification'] == 1) return true;
		else return false;
	}
	
	
	
	/**
	 * Существует ли пользователь
	 * @param 
	 * @return 
	 */
	public function issetUser() {
		$this->db->where('id', $this->userData['id']);
		if ($this->db->count_all_results('users') == 0) return false;
		return true;
	}
	
	
	
	/**
	 * Удален ли пользователь
	 * @param 
	 * @return 
	 */
	public function isDeletedUser() {
		$this->db->where('id', $this->userData['id']);
		$query = $this->db->get('users');
		
		if (!$response = $query->row_array()) return true;
		if ($response['deleted'] == 1) return true;
		return false;
	}
	
	
	
	
	
	
	
	/**
	 * Получить основной статик пользователя
	 * @param 
	 * @return 
	 */
	public function getMainStatic() {
		return isset($this->userData['main_static']) ? $this->userData['main_static'] : 0;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getStaticLocation($staticId = false) {
		if (!$staticId) return false;
		$this->db->select('location');
		$this->db->where('id', $staticId);
		$sQuery = $this->db->get('statics');
		$sResponse = $sQuery->row_array();
		return $this->locations[$sResponse['location']];
	}
	
	
	
	
	/**
	 * Получить Резерв пользователя
	 * @param 
	 * @return 
	 */
	public function getDeposit() {
		return isset($this->userData['deposit']) ? $this->userData['deposit'] : 0;
	}
	
	
	
	
	/**
	 * Получить ID роли пользователя
	 * @param 
	 * @return 
	 */
	public function getRole() {
		return isset($this->userData['role']) ? $this->userData['role'] : false;
	}
	
	
	
	
	/**
	 * Получить роль пользователя
	 * @param 
	 * @return 
	 */
	public function getRoleName() {
		$this->db->select('r.name AS role');
		$this->db->join('roles r', 'u.role = r.id');
		$this->db->where('u.id', $this->userData['id']);
		$query = $this->db->get('users u');
		$response = $query->row_array();
		return isset($response['role']) ? $response['role'] : false;
	}
	
	
	
	
	/**
	 * Получить звание
	 * @param 
	 * @return 
	 */
	public function getRankData() {
		$this->db->select('r.name AS rank');
		$this->db->join('ranks r', 'u.rank = r.id');
		$this->db->where('u.id', $this->userData['id']);
		$query = $this->db->get('users u');
		$response = $query->row_array();
		return isset($response['rank']) ? $response['rank'] : false;
	}
	
	
	
	
	/**
	 * Получить количество дней до присвоения следующего звания
	 * @param 
	 * @return 
	 */
	public function getNextRankData() {
		$this->db->select('u.reg_date, u.stage, u.rank');
		$this->db->where('u.id', $this->userData['id']);
		$queryU = $this->db->get('users u');
		$respUser = $queryU->row_array();
		
		$regCountDays = floor((time() - $respUser['reg_date']) / (60 * 60 * 24)) + $respUser['stage'];
		
		$this->db->order_by('r.period', 'ASC');
		$this->db->select('r.name, r.period');
		$query = $this->db->get('ranks r');
		
		$data = [];
		if ($ranks = $query->result_array()) {
			foreach ($ranks as $rank) {
				if ($regCountDays < $rank['period']) {
					$data['count_days'] = $rank['period'] - $regCountDays;
					$data['next_rank'] = $rank['name'];
					break;
				}
			}
		}
		
		return $data;
	}
	
	
	
	
	
	
	
	
	/**
	 * Получить способ оплаты участнику
	 * @param 
	 * @return 
	 */
	public function getPayMethod() {
		return isset($this->userData['payment']) ? $this->userData['payment'] : false;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить статус соглашения с договором
	 * @param 
	 * @return 
	 */
	public function getAgreementStat() {
		if ($this->userData['verification'] == 0) {
			return false;
		} elseif ($this->userData['agreement'] == 1) {
			return false;
		} else {
			return true;
		}
	}
	
	
	
	
	
	
	/**
	 * Задать статус соглашения с договором
	 * @param 
	 * @return 
	 */
	public function setAgreementStat($stat) {
		$this->db->where('id', $this->userData['id']);
		if ($this->db->update('users', ['agreement' => $stat])) {
			return 1;
		}
		return 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получть список цветов для рейдеров
	 * @param 
	 * @return 
	 */
	public function getRaidersColors() {
		$this->db->select('name, color');
		$query = $this->db->get('raiders_colors');
		return $query->result_array()?: [];
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список типов рейдов
	 * @param 
	 * @return 
	 */
	public function getRaidsTypes() {
		$query = $this->db->get('raids_types');
		$data = [];
		if ($response = $query->result_array()) {
			foreach ($response as $item) {
				$data[$item['id']] = $item['name'];
			}
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
	 * Получить состав команды
	 * @param 
	 * @return 
	 */
	public function getUsersToCompound($data) {
		$this->db->select('cd.user_id, cd.persones_count, cd.effectiveness, cd.fine');
		$this->db->where(['cd.period_id' => $data['period_id'], 'cd.static_id' => $data['static_id']]);
		$queryCd = $this->db->get('compounds_data cd');
		
		$resData = [];
		$respCd = [];
		if ($respCd = $queryCd->result_array()) {
			$respCd = setArrKeyFromField($respCd, 'user_id');
		}
		
		$this->db->select('u.id, u.avatar, u.nickname, u.color');
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->where(['us.static_id' => $data['static_id'], 'verification' => 1, 'deleted' => 0]);
		$queryU = $this->db->get('users u');
		if (!$respU = $queryU->result_array()) return false;
		$respU = setArrKeyFromField($respU, 'id');
		
		$resData = array_replace_recursive($respU, array_intersect_key($respCd, $respU));
		
		
		$this->db->select('ru.id, r.id AS raid_id, r.date, ru.user_id, ru.rate, rt.name');
		$this->db->where(['r.period_id' => $data['period_id'], 'r.static_id' => $data['static_id'], 'r.is_key' => 0]);
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
		
		return ['compounds_data' => array_replace_recursive($resData, $rData), 'raids' => $raids];
	}
	
	
	
	
	
	
	/**
	 * Получить состав команды для ключей
	 * @param 
	 * @return 
	 */
	public function getUsersToKeys($data) {
		$this->db->select('u.id, u.avatar, u.nickname, u.color');
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->where(['us.static_id' => $data['static_id'], 'verification' => 1, 'deleted' => 0]);
		$queryU = $this->db->get('users u');
		if (!$respU = $queryU->result_array()) return false;
		$resData = setArrKeyFromField($respU, 'id');
		
		
		$this->db->select('r.id AS raid_id, r.date, ru.user_id, ru.rate, kt.name');
		$this->db->where(['r.period_id' => $data['period_id'], 'r.static_id' => $data['static_id'], 'r.is_key' => 1]);
		$this->db->join('raid_users ru', 'ru.raid_id = r.id');
		$this->db->join('keys_types kt', 'kt.id = r.type', 'left outer');
		$queryR = $this->db->get('raids r');
		
		$rData = []; $keys = []; $summKoeff = []; $allSummKoeff = 0;
		foreach ($queryR->result_array() as $item) {
			$keys[$item['raid_id']] = [
				'name' => $item['name'],
				'date' => $item['date'],
			];
			$rData[$item['user_id']]['keys'][$item['raid_id']] = $item['rate'];
			
			
			if (!isset($summKoeff[$item['raid_id']])) $summKoeff[$item['raid_id']] = $item['rate'];
			else $summKoeff[$item['raid_id']] += $item['rate'];
			
			$allSummKoeff += $item['rate']; 
			
			
			if (!isset($rData[$item['user_id']]['rate_summ'])) $rData[$item['user_id']]['rate_summ'] = $item['rate'];
			else $rData[$item['user_id']]['rate_summ'] += $item['rate']; 
		}
		
		return ['keys_data' => array_replace_recursive($resData, $rData), 'keys' => $keys, 'summ_koeff' => $summKoeff, 'all_summ_koeff' => $allSummKoeff];
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Добавить рейд
	 * @param 
	 * @return 
	 */
	public function addRaid($data) {
		$periodId = $data['period_id'];
		$staticId = $data['static_id'];
		$raidType = $data['raid_type'];
		$raidUsers = $data['raid_users']; // appearance rate
		
		
		$raidOrdersComment = array_pop($data['raid_orders']);
		$raidOrders = array_filter($data['raid_orders'], function($item) {return trim($item) !== "";});
		if (trim($raidOrdersComment) != '') {
			array_push($raidOrders, $raidOrdersComment);
		} else {
			array_push($raidOrders, 'Нет комментария');
		}
		
		$this->db->insert('raids', [
			'from_id'		=> $this->userData['id'],
			'static_id'		=> $staticId,
			'period_id'		=> $periodId,
			'type'			=> $raidType,
			'date'			=> time()
		]);
		
		$lastRaidId = $this->db->insert_id();
		
		
		if ($raidOrders) {
			$raidOrdersData = [];
			foreach ($raidOrders as $order) {
				$raidOrdersData[] = [
					'raid_id'	=> $lastRaidId,
					'value'		=> $order
				];
			}
			$this->db->insert_batch('raid_orders', array_values($raidOrdersData));
		}
			
		
		if ($raidUsers) {
			$raidOrdersUsers = [];
			foreach ($raidUsers as $userId => $userData) {
				$raidOrdersUsers[] = [
					'raid_id'		=> $lastRaidId,
					'user_id'		=> $userId,
					'appearance'	=> isset($userData['appearance']) ? $userData['appearance'] : 0,
					'rate'			=> $userData['rate']
				];
			}
			$this->db->insert_batch('raid_users', array_values($raidOrdersUsers));
		}
		
		return 1;
	}
	
	
	
	
	
	
	
	
	/**
	 * Добавить ключ
	 * @param 
	 * @return 
	 */
	public function addKey($data) {
		$periodId = $data['period_id'];
		$staticId = $data['static_id'];
		$keyType = $data['key_type'];
		$keyUsers = $data['key_users']; // appearance rate
		
		
		$this->db->insert('raids', [
			'from_id'		=> $this->userData['id'],
			'static_id'		=> $staticId,
			'period_id'		=> $periodId,
			'type'			=> $keyType,
			'date'			=> time(),
			'is_key'		=> 1
		]);
		
		$lastKeyId = $this->db->insert_id();
		
		if ($keyUsers) {
			$keyOrdersUsers = [];
			foreach ($keyUsers as $userId => $userData) {
				$keyOrdersUsers[] = [
					'raid_id'		=> $lastKeyId,
					'user_id'		=> $userId,
					'appearance'	=> isset($userData['appearance']) ? $userData['appearance'] : 0,
					'rate'			=> $userData['rate']
				];
			}
			$this->db->insert_batch('raid_users', array_values($keyOrdersUsers));
		}
		
		return 1;
	}
	
	
	
	
	
	
	
	/**
	 * Редактировать коэффициенты пользователей в рейдах
	 * @param 
	 * @return 
	 */
	public function editKeyKoeff($koeffData = false) {
		if (!$koeffData) return false;
		foreach ($koeffData as $koeff) {
			$this->db->where(['user_id' => $koeff['user_id'], 'raid_id' => $koeff['raid_id']]);
			$this->db->update('raid_users', ['rate' => $koeff['koeff']]);
		}
		return true;
	}
	
	
	/**
	 * Редактировать типы рейдов
	 * @param 
	 * @return 
	 */
	public function editKeyTypes($kTypesData = false) {
		if (!$kTypesData) return false;
		$this->db->update_batch('raids', $kTypesData, 'id');
		return true;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Обновить состав команды
	 * @param 
	 * @return 
	 */
	public function setCompound($compoundUsers = [], $periodId, $staticId) {
		$this->db->select('cd.user_id, cd.persones_count, cd.effectiveness, cd.fine');
		$this->db->where(['cd.period_id' => $periodId, 'cd.static_id' => $staticId]);
		$queryCD = $this->db->get('compounds_data cd');
		
		$respCD = [];
		if ($respCD = $queryCD->result_array()) {
			$respCD = setArrKeyFromField($respCD, 'user_id');
		}
		
		$newData = array_diff_key($compoundUsers, $respCD);
		$updateData = array_intersect_key($compoundUsers, $respCD);
		
		if ($newData) {
			$insert = [];
			foreach ($newData as $userId => $userData) {
				$insert[] = [
					'period_id'			=> $periodId,
					'static_id'			=> $staticId,
					'user_id'			=> $userId,
					'persones_count'	=> $userData['persones_count'],
					'effectiveness'		=> $userData['effectiveness'],
					'fine'				=> $userData['fine']
				];
			}
			$this->db->insert_batch('compounds_data', array_values($insert), 'user_id');
		}
		
		if ($updateData) {
			$update = [];
			foreach ($updateData as $userId => $userData) {
				$update[] = [
					'user_id'			=> $userId,
					'persones_count'	=> $userData['persones_count'],
					'effectiveness'		=> $userData['effectiveness'],
					'fine'				=> $userData['fine']
				];
			}
			
			$this->db->where(['period_id' => $periodId, 'static_id' => $staticId]);
			$this->db->update_batch('compounds_data', array_values($update), 'user_id');
		}
		
		return 1;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить название активного периода
	 * @param 
	 * @return 
	 */
	public function getActiveReportsPeriod($staticId = false) {
		if (!$staticId) return false;
		$location = $this->getStaticLocation($staticId);
		$this->db->where(['active_'.$location['code'] => 1, 'closed' => 0]);
		$query = $this->db->get('reports_periods');
		if ($response = $query->row_array()) {
			return [
				'id'	=> $response['id'],
				'name' 	=> $response['name'],
			];
		}
		return 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/** Получить список операторов для ЛК
	 * @param 
	 * @return 
	 */
	public function getOperators() {
		$this->db->where('nickname !=', '');
		$this->db->where('avatar !=', '');
		$this->db->select('id, nickname, avatar, statics');
		$query = $this->db->get('operators o');
		if (!$operatorsData = $query->result_array()) return false;
		$operatorsData = array_map(function($item) {
			$item['statics'] = json_decode($item['statics'], true);
			return $item;
		}, setArrKeyFromField($operatorsData, 'id'));
		
		
		$this->db->select('operator_id AS id, date, time_start_h AS h_start, time_start_m AS m_start, time_end_h AS h_end, time_end_m AS m_end');
		$this->db->where_in('date', [strtotime('today'), strtotime('today') + 86400]);
		$query = $this->db->get('operators_hourssheet');
		
		if ($operatorsHS = $query->result_array()) {
			
			$hoursSheet = [];
			foreach ($operatorsHS as $item) {
				$date = strtotime('today') == $item['date'] ? 'today' : 'tomorrow';
				$hoursSheet[$item['id']][$date][] = $item;
			}
		}
			
		foreach ($operatorsData as $id => $data) {
			$operatorsData[$id]['hourssheet'] = isset($hoursSheet[$id]) ? $hoursSheet[$id] : null;
		}
		return $operatorsData;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function operatorSendMess($data) {
		if (!$data) return false;
		$insert = [
			'from' 		=> $data['from'],
			'to' 		=> $data['to'],
			'type' 		=> $data['type'],
			'message' 	=> $data['message'],
			'date' 		=> time()
		];
		
		if (!$this->db->insert('messages_to_operators', $insert)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Статистика зарплаты
	 * @param 
	 * @return 
	 */
	public function statisticsGet($static = false) {
		if (!$static) return false;
		$this->db->select('u.id, u.nickname, u.avatar, s.name AS static_name, s.icon AS static_icon, u.statistics_cash AS cash, u.statistics_days AS days');
		$this->db->join('users u', 'u.id = us.user_id');
		$this->db->join('statics s', 's.id = us.static_id');
		$this->db->where('us.static_id', $static);
		$query = $this->db->get('users_statics us');
		$result = $query->result_array();
		
		$data = []; $maxPay = 0;
		foreach ($result as $item) {
			if ((float)$item['cash'] == 0 || (float)$item['days'] == 0) continue;
			$pay = (float)$item['cash'] / (float)$item['days'] * 30.437;
			if ($maxPay < $pay) {
				$data = [
					'user_id' 		=> $item['id'],
					'nickname' 		=> $item['nickname'],
					'avatar' 		=> $item['avatar'],
					'pay'			=> $pay
				];
			}
		}
		
		return $data ?: false;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesGetGamesIds() {
		if (!$this->userData['id']) return false;
		$this->db->select('pgi.game_id, pgi.date_end, up.nick, up.armor, up.server');
		$this->db->join('users_personages up', 'up.game_id = pgi.id');
		$this->db->where('pgi.user_id', $this->userData['id']);
		$query = $this->db->get('personages_game_ids pgi');
		if (!$response = $query->result_array()) return false;
		
		$data = [];
		foreach ($response as $k => $item) {
			$data[$item['game_id']]['game_id'] = $item['game_id'];
			$data[$item['game_id']]['date_end'] = $item['date_end'];
			$data[$item['game_id']]['active'] = $item['date_end'] > time();
			$data[$item['game_id']]['personages'][] = [
				'nick' 		=> $item['nick'],
				'armor' 	=> $item['armor'],
				'server' 	=> $item['server']
			];
			unset($response[$k]);
		}
		
		return array_values($data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesGet($userId = false, $onlyNew = false) {
		$this->db->where('from_id', ($userId ?: $this->userData['id']));
		if ($onlyNew !== false) $this->db->where('game_id', null);
		$query = $this->db->get('users_personages');
		$result = $query->result_array();
		return $result;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesSave($fields = false) {
		if (!$fields) return false;
		$this->db->set($fields);
		$this->db->set(['from_id' => $this->userData['id']]);
		if ($this->db->insert('users_personages')) {
			//return true;
			return $this->db->insert_id();
			//$this->db->select_max('id');
			//$query = $this->db->get('users_personages', ['from_id' => $this->userData['id']]);
			//$response = $query->row_array();
			//return $response['id'];
		}
		return false;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesUpdate($id = false, $fields = false) {
		if (!$fields || !$id) return false;
		$this->db->set($fields);
		$this->db->where('id', $id);
		if ($this->db->update('users_personages')) return true;
		return false;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesRemove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if ($this->db->delete('users_personages')) return true;
		return false;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список выплат
	 * @param 
	 * @return 
	 */
	public function getPaymentRequests($params = false, $toExport = false) {
		$this->db->where('user_id', $this->userData['id']);
		$this->db->order_by('id', 'DESC');
		$query = $this->db->get('users_orders');
		if (!$result = $query->result_array()) return false;
		return $result;
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
	
	
	
	
}