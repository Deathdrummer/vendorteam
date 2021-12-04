<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Account_model extends My_Model {
	
	
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
		if (!$userId = decrypt(get_cookie('id'))/*$this->session->userdata('id')*/) return false;
		$this->userData = $this->getUserData($userId/*$this->session->userdata('id')*/);
	}
	
	
	
	
	
	
	
	/**
	 * Получить данные пользователя
	 * @param 
	 * @return 
	*/
	public function getUserData($userId = null) {
		if ((!is_null($userId) && $this->userData && $userId == $this->userData['id']) || (is_null($userId) && $this->userData)) return $this->userData;
		
		$this->db->select('u.*, aa.access');
		$this->db->join('accounts_access aa', 'aa.id = u.access', 'left outer');
		$this->db->where('u.id', $userId);
		
		$query = $this->db->get('users u');
		if ($response = $query->row_array()) {
			$response['access'] = json_decode($response['access'], true);
			unset($response['password']);
			$this->db->select('us.static_id, s.name, s.icon, us.lider, us.main, s.stopstage, s.payformat');
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
		$this->db->select('u.id, u.nickname, u.avatar, u.color, us.static_id, EXISTS (SELECT 1 FROM resign r WHERE r.user_id = u.id AND r.date_last > '.time().') AS is_resign');
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
		if ($this->db->count_all_results('users') > 0) return true;
		return false;
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
	 * Получить список статиков пользователя
	 * @return 
	*/
	public function getStatics() {
		if (!isset($this->userData['statics'])) return false;
		return $this->userData['statics'];
	}
	
	
	
	
	/**
	 * Получить список ID статиков пользователя
	 * @return 
	*/
	public function getStaticsIds() {
		if (!isset($this->userData['statics'])) return false;
		return array_keys($this->userData['statics']);
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
	public function getNextRankData($userId = false) {
		$this->db->select('u.reg_date, u.stage, u.rank');
		$this->db->where('u.id', ($userId ?: $this->userData['id']));
		if (!$userData = $this->_row('users u')) return false;
		
		$userDays = floor((time() - $userData['reg_date']) / (60 * 60 * 24)) ?: 1;
		$stageDaysCount = ($countDays = floor((time() - $userData['reg_date']) / (60 * 60 * 24)) + $userData['stage']) > 0 ? $countDays : 1;
		
		$this->db->select('r.name, r.period');
		$this->db->where('r.period >', $stageDaysCount);
		$this->db->order_by('r.period', 'ASC');
		if (!$nextRank = $this->_row('ranks r')) return false;
		
		return [
			'count_days' 	=> $nextRank['period'] - $stageDaysCount,
			'next_rank'		=> $nextRank['name']
		];
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
	public function getUsersToCompound($data = false) {
		if (!$data) return false;
		$this->db->select('cd.user_id, cd.persones_count, cd.effectiveness, cd.fine');
		$this->db->where(['cd.period_id' => $data['period_id'], 'cd.static_id' => $data['static_id']]);
		$queryCd = $this->db->get('compounds_data cd');
		
		$resData = [];
		$respCd = [];
		if ($respCd = $queryCd->result_array()) {
			$respCd = setArrKeyFromField($respCd, 'user_id');
		}
		
		
		$this->db->select('u.id, u.avatar, u.nickname, u.color, EXISTS (SELECT 1 FROM resign r WHERE r.user_id = u.id AND r.date_last > '.time().') AS is_resign');
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->where(['us.static_id' => $data['static_id'], 'verification' => 1, 'deleted' => 0, 'excluded' => 0]);
		$queryU = $this->db->get('users u');
		if (!$respU = $queryU->result_array()) return false;
		$respU = setArrKeyFromField($respU, 'id');
		
		$resData = array_replace_recursive($respU, array_intersect_key($respCd, $respU)); // тут нет исключенных
		
		$this->db->select('ru.id, r.id AS raid_id, r.date, ru.user_id, ru.rate, rt.name');
		$this->db->where(['r.period_id' => $data['period_id'], 'r.static_id' => $data['static_id'], 'r.is_key' => 0]);
		$this->db->where_in('ru.user_id', array_keys($resData)); // исключить из рейдов исключенных
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
	 * Получить коэффициенты посещений
	 * @param 
	 * @return 
	*/
	public function getVisitsCoeffs($data = false) {
		if (!$data) return false;
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
		
		return ['coeffs' => array_replace_recursive($resData, $rData), 'raids' => $raids];
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить состав команды для ключей
	 * @param 
	 * @return 
	*/
	public function getUsersToKeys($data) {
		$this->db->select('u.id, u.avatar, u.nickname, u.color, EXISTS (SELECT 1 FROM resign r WHERE r.user_id = u.id AND r.date_last > '.time().') AS is_resign');
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->where(['us.static_id' => $data['static_id'], 'verification' => 1, 'deleted' => 0, 'excluded' => 0]);
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
	 * @param 
	 * @return 
	*/
	public function setCompoundItem($data = false) {
		if (!$data['period_id'] || !$data['static_id'] || !$data['user_id'] || !$data['field'] || $data['value'] === false) return false;	
		$this->db->where(['period_id' => $data['period_id'], 'static_id' => $data['static_id'], 'user_id' => $data['user_id']]);
		if ($this->db->count_all_results('compounds_data') != 0) {
			$this->db->where(['period_id' => $data['period_id'], 'static_id' => $data['static_id'], 'user_id' => $data['user_id']]);
			return $this->db->update('compounds_data', [$data['field'] => $data['value']]);
		}
		return $this->db->insert('compounds_data', [ 'period_id' => $data['period_id'], 'static_id' => $data['static_id'], 'user_id' => $data['user_id'], $data['field'] => $data['value']]);
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
		$this->db->join('users_personages up', 'up.game_id = pgi.id', 'LEFT OUTER');
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
	public function editRaidKoeff($koeffData = false, $single = false) {
		if (!$koeffData) return false;
		if ($single) {
			$id = arrTakeItem($koeffData, 'id');
			$this->db->where('id', $id);
			return $this->db->update('raid_users', $koeffData);
		} 
		
		$this->db->update_batch('raid_users', $koeffData, 'id');
		return true;
	}
	
	
	
	/**
	 * Редактировать типы рейдов
	 * @param 
	 * @return 
	*/
	public function editRaidTypes($rTypesData = false, $single = false) {
		if (!$rTypesData) return false;
		if ($single) {
			$id = arrTakeItem($rTypesData, 'id');
			$this->db->where('id', $id);
			return $this->db->update('raids', $rTypesData);
		}
		$this->db->update_batch('raids', $rTypesData, 'id');
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список менторов
	 * @param 
	 * @return 
	*/
	public function getMentors() {
		$userClasses = $this->getUsersClasses();
		
		// CAST(CONCAT('[', GROUP_CONCAT(distinct JSON_OBJECT('id', us.static_id, 'name', s.name)), ']') AS JSON) AS statics,
		$this->db->select("u.id, u.nickname, u.avatar, ra.name AS role, ro.name AS rank, IF(GROUP_CONCAT(us.static_id), CAST(CONCAT('[', GROUP_CONCAT(distinct JSON_OBJECT('id', us.static_id, 'name', s.name)), ']') AS JSON), NULL) AS statics, IF(GROUP_CONCAT(uc.class_id), CAST(CONCAT('[', GROUP_CONCAT(distinct JSON_OBJECT('id', uc.class_id, 'name', cls.name, 'mentor', uc.mentor)), ']') AS JSON), NULL) AS classes");
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->join('statics s', 's.id = us.static_id', 'LEFT OUTER');
		$this->db->join('users_classes uc', 'uc.user_id = u.id', 'LEFT OUTER');
		$this->db->join('classes cls', 'uc.class_id = cls.id', 'LEFT OUTER');
		$this->db->join('roles ro', 'u.role = ro.id', 'LEFT OUTER');
		$this->db->join('ranks ra', 'u.rank = ra.id', 'LEFT OUTER');
		
		//$this->db->where('uc.mentor', 1);
		$this->db->where('u.id !=', $this->userData['id']);
		$this->db->where('u.verification', 1);
		$this->db->where('u.deleted', 0);
		
		//$this->db->where_in('us.static_id', array_keys($this->userData['statics']));
		//$this->db->where_in('uc.class_id', array_keys($userClasses));
		
		$this->db->group_by('u.id');
		$query = $this->db->get('users u');
		if (!$response = $query->result_array()) return false;
		
		$mentors = [];
		foreach ($response as $item) {
			$item['statics'] = $item['statics'] ? json_decode($item['statics'], true) : null;
			$item['classes'] = $item['classes'] ? json_decode($item['classes'], true) : null;
			$userStatics = $item['statics'] ? setArrKeyFromField($item['statics'], 'id') : null;
			$userClasses = $item['classes'] ? setArrKeyFromField($item['classes'], 'id') : null;
			$myStatics = array_keys((array)$this->userData['statics']);
			$myClasses = array_keys((array)$this->getUsersClasses($this->userData['id']));
			$grouping = ($userStatics && $myStatics && array_intersect(array_keys($userStatics), $myStatics)) ? 'inner' : 'outer';
			
			
			$mentorClasses = []; $mentorClassesToMe = [];
			if ($userClasses) {
				foreach ($userClasses as $uClsId => $uClsData) {
					if ($uClsData['mentor'] == 1 && in_array($uClsId, $myClasses)) {
						$uClsData['mentor_to_me'] = 1;
						$mentorClassesToMe[$uClsId] = [
							'user_id' 		=> $item['id'],
							'class_name'	=> $uClsData['name']
						];
					}
					$mentorClasses[$uClsId] = $uClsData;
				}
			}
			
			if ($mentorClasses) {
				$item['classes'] = $mentorClasses;
			}
			
			if ($mentorClassesToMe) {
				$item['classes_to_me'] = $mentorClassesToMe;
			}
			
			
			if ($grouping == 'inner') {
				$mentors[$grouping][] = $item;
			} elseif ($userClasses && $myClasses && ($cls = array_values(array_intersect(array_keys((array)$userClasses), (array)$myClasses)))) {
				if (array_sum(array_column($mentorClasses, 'mentor')) > 0) $mentors[$grouping][] = $item;
			}
			
		}
		
		return $mentors;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function getUsersClasses($userId = false) {
		$userId = $userId ?: $this->userData['id'];
		$this->db->select('cls.*');
		$this->db->where('uc.user_id', $userId);
		$this->db->join('classes cls', 'uc.class_id = cls.id', 'LEFT OUTER');
		$query = $this->db->get('users_classes uc');
		if (!$response = $query->result_array()) return false;
		$classes = setArrKeyFromField($response, 'id');
		return $classes;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function addMentorsRequest($addRequestData = false) {
		if (!$addRequestData) return false;
		if (!$this->db->insert('mentors_requests', $addRequestData)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------- рейтинг
	
	
	/**
	 * Получить данные периода рейтингов
	 * @param true - текущий (активный) период, ID периода
	 * @return 
	*/
	public function getActiveRatingsPeriod($periodId = false) {
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
	 * Получить коэффициент посещения за год, где коэффициент больше 0.5
	 * @param static_id - ID статика, возвращает массив ID участника => коэффициент
	 * @param static_id user_id - ID участника, возвращает коэффициент
	 * @param void - возвращает коэффициент текущего участника
	 * @return mixed
	*/
	public function getUserVisitsRate($params = []) {
		$this->load->model('ratings_model', 'ratings');
		if (!$periods = $this->ratings->getRatingsReportsPeriods()) return []; // all & last
		
		$all = $this->_getRates($periods['all'], $params);
		$last = $this->_getRates($periods['last'], $params, true);
		
		$intersect = array_intersect_key($all, $last);
		$keysOnlyAll = array_diff_key($all, $intersect);
		$keysOnlyLast = array_diff_key($last, $intersect);
		
		$mergeData = [];
		if ($intersect) {
			foreach ($intersect as $userId => $rates) {
				if (isset($last[$userId])) $mergeData[$userId] = array_merge($rates, $last[$userId]);
			}
		}
			
		$mergeData = array_replace($mergeData, $keysOnlyAll, $keysOnlyLast);
		
		$finalData = [];
		foreach ($mergeData as $userId => $rates) {
			$countItems = count($rates);
			$countmatch = array_filter($rates, function($item) {return $item > 0;});
			$finalData[$userId] = $countItems ? round(count($countmatch) / ($countItems / 100), 2) : 0;
		}
		
		
		if (isset($params['user_id'])) return $finalData[$params['user_id']];
		return $finalData;
	}
	
	
	
	
	
	
	
	/**
	 * Получить коэффициенты посещений
	 * @param 
	 * @return 
	*/
	private function _getRates($periods = false, $params = [], $x5 = false) {
		if (!$periods) return [];
		$staticUsers = false;
		if (isset($params['static_id'])) {
			$this->load->model('users_model', 'users');
			$staticUsers = $this->users->getUsersFromStatic($params['static_id'], true);
		}
		
		$this->db->select('ru.user_id, ru.rate');
		$this->db->join('raid_users ru', 'ru.raid_id = r.id');
		$this->db->where('r.static_id', $params['static_id']);
		$this->db->where_in('r.period_id', $periods);
		if (!$params) $this->db->where('ru.user_id', $this->userData['id']);
		elseif ($staticUsers) $this->db->where_in('ru.user_id', $staticUsers);
		elseif (isset($params['user_id'])) $this->db->where('ru.user_id', $params['user_id']); 
		
		if (!$result = $this->_result('raids r')) return [];
		
		$data = $staticUsers ? array_fill_keys($staticUsers, []) : []; 
		foreach ($result as $item) {
			if ($x5) for ($i = 0; $i < 5; $i++) $data[$item['user_id']][] = $item['rate'];
			else $data[$item['user_id']][] = $item['rate'];
		}
		
		return $data;
	}
	
	
	
	
	
	/**
	 * Персонажи и ошибки участника за последние 4 сохраненных периода выплат
	 * @param ID статика
	 * @return array
	*/
	public function getPeriodsInfo($staticId = false, $period = false) {
		if (!$staticId || !$period) return false;
		$this->db->select('id, name');
		$this->db->where_in('id', array_keys($period['reports_periods']));
		$this->db->order_by('id', 'DESC');
		$query = $this->db->get('reports_periods');
		if (!$result = $query->result_array()) return false;
		$periodsNames = array_reverse(setArrKeyFromField($result, 'id', false, 'name'), true);
		
		$savedData = false;
		if ($savedData = $this->getSavedRatingsdata($period['id'], $staticId)) {
			$savedData = setArrKeyFromField($savedData, 'user_id', false);
		}
		
		$this->db->select('cd.period_id, cd.user_id, cd.persones_count, cd.fine');
		$this->db->join('users_statics us', 'us.user_id = cd.user_id');
		$this->db->where('us.main', 1);
		$this->db->where('cd.static_id', $staticId);
		$this->db->where_in('cd.period_id', array_keys($period['reports_periods']));
		$this->db->order_by('cd.period_id', 'ASC');
		$personesQuery = $this->db->get('compounds_data cd');
		if (!$personesResult = $personesQuery->result_array()) return false;
		
		$data = ['periods_names' => $periodsNames, 'data' => []];
		foreach ($personesResult as $item) {
			if ($savedData && isset($savedData[$item['user_id']])) {
				$data['data'][$item['user_id']]['fine_summ'] = $savedData[$item['user_id']]['fine'];
			} else {
				if (!isset($data['data'][$item['user_id']]['fine_summ'])) $data['data'][$item['user_id']]['fine_summ'] = 0;
				$data['data'][$item['user_id']]['fine_summ'] += (float)$item['fine'];
			}
				
			
			$data['data'][$item['user_id']][$item['period_id']] = [
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
	public function getUsersForRating($staticId = false) {
		if (!$staticId) return false;
		$this->db->select('u.id, u.nickname, u.avatar, ra.name AS role, ro.name AS rank, EXISTS (SELECT 1 FROM resign r WHERE r.user_id = u.id AND r.date_last > '.time().') AS is_resign');
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->join('roles ro', 'u.role = ro.id', 'LEFT OUTER');
		$this->db->join('ranks ra', 'u.rank = ra.id', 'LEFT OUTER');
		$this->db->where('us.static_id', $staticId);
		$this->db->where('u.deleted', 0);
		$this->db->where('u.verification', 1);
		$this->db->where('us.main', 1);
		$query = $this->db->get('users u');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	
	
	
	
	/**
	 * Получить уже сохраненные данные по заданному периоду и статику
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
	 * @param 
	 * @return 
	*/
	public function saveDataForRating($data = false) {
		if (!$data) return false;
		
		$periodId = arrTakeItem($data, 'period_id');
		$staticId = arrTakeItem($data, 'static_id');
		$data = $data['data'];
		
		$this->db->where(['period_id' => $periodId, 'static_id' => $staticId]);
		if ($this->db->count_all_results('ratings_data') > 0) {
			if (!$this->db->update_batch('ratings_data', $data, 'user_id')) return false;
			return true;
		}
		
		if (!$this->db->insert_batch('ratings_data', $data)) return false;
		$this->_notificationDone($staticId, $periodId);
		return true;
	}
	
	
	
	
	
	
	/**
	 * Записать в уведомления статус сохранения коэффициентов
	 * @param 
	 * @return 
	*/
	protected function _notificationDone($staticId = false, $periodId = false) {
		$this->db->where(['static_id' => $staticId, 'period_id' => $periodId]);
		if (!$this->db->update('ratings_notifycations', ['status' => 1])) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * Получить список Рейдлидеров
	 * @param 
	 * @return user ID => [static ID => static name]
	*/
	public function getRatingNotifications() {
		if (!$periodId = $this->getActiveRatingsPeriodId()) return false;
		
		$this->db->select('rn.static_id, s.name, s.icon');
		$this->db->join('statics s', 's.id = rn.static_id', 'LEFT OUTER');
		$this->db->where(['rn.period_id' => $periodId, 'rn.user_id' => $this->userData['id'], 'rn.status' => 0]);
		if (!$result = $this->_result('ratings_notifycations rn')) return false;
		
		$data = setArrKeyFromField($result, 'static_id', false);
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Детальная информация по рейтингу
	
	/**
	 * activity 		Активность 				- 
	 * skill 			Личный скилл 			- 
	 * fine 			Штрафы 					- 
	 * visits 			Коэффициент посещений 	- экв
	 * reprimands 		Выговоры 				- 
	 * forcemajeure 	ФМ 						- 0:20 1:15 2:5 3+:0
	 * stimulations 	Наставники 				- 1:5 2-3:10 4+:20
	 * mentors 		Стимулирование 			- 1:5 2:10 3:15 4:18 5:20
	 * @param 
	 * @return 
	*/
	public function getUserRating($onlyRating = false) {
		if (!$periodId = $this->getActiveRatingsPeriodId()) return false;
		if (!$userId = $this->userData['id']) return false;
		if (!$coeffsSettings = $this->admin_model->getSettings('rating_coeffs')) return false;
		
		$ratingsData = $this->_getRatingsData($periodId, $userId);
		$ratingsData['reprimands'] = $this->_getReprimands($periodId, $userId);
		$ratingsData['forcemajeure'] = $this->_getForcemajeure($periodId, $userId);
		$ratingsData['stimulations'] = $this->_getStimulations($periodId, $userId);
		$ratingsData['mentors'] = $this->_getMentorsData($periodId, $userId);
		
		
		$coeffsMap = [];
		foreach ($coeffsSettings as $field => $cData) {
			if (!$cData = explode("\n", $cData)) return false;
			$cData = array_filter($cData, function($item) {return trim($item);});
			$coeffsMap[$field] = array_map(function($item) {
				$split = explode(':', $item);
				return [
					'index' => isset($split[0]) ? $split[0] : null,
					'value' => isset($split[1]) ? $split[1] : null
				];
			}, $cData);
		}
		
		
		$finalData = [];
		foreach ($ratingsData as $name => $item) {
			//echo $name.' -> '.$item.'<br/>';
			$coeff = $ratingsData[$name];
			$coeffMap = $coeffsMap[$name];
			if (!$coeffMap) continue;
			
			foreach ($coeffMap as $k => $mapItem) {
				$mapItem = bringTypes($mapItem);
				$endItem = isset($coeffMap[$k+1]) ? $coeffMap[$k+1] : false;
				if ($endItem && ($coeff >= $mapItem['index'] && $coeff < $endItem['index'])) $finalData[$name] = $mapItem['value'];
				elseif ($coeff >= $mapItem['index']) $finalData[$name] = $mapItem['value'];
			}
			
			
			/*if (in_array($name, ['activity', 'skill', 'fine', 'visits', 'reprimands'])) {
				foreach ($coeffMap as $k => $mapItem) {
					$mapItem = bringTypes($mapItem);
					$endItem = isset($coeffMap[$k+1]) ? $coeffMap[$k+1] : false;
					if ($endItem && ($coeff >= $mapItem['index'] && $coeff < $endItem['index'])) $finalData[$name] = $mapItem['value'];
					elseif ($coeff >= $mapItem['index']) $finalData[$name] = $mapItem['value'];
				}
			} elseif (in_array($name, [])) {
				$mapItem = bringTypes(reset($coeffMap));
				$finalData[$name] = round(($mapItem['value'] / $mapItem['index']) * $coeff, 2);
			}*/
		}
		
		if ($onlyRating) return array_sum($finalData);
		$finalData['rating'] = array_sum($finalData);
		return $finalData;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function setResign($data = false) {
		if (!$data) return false;
		if (!$this->db->insert('resign', $data)) return false;
		return true;
	}
	
	
	
	/**
	 * Получить обработанную заявку на увольнение
	 * @param 
	 * @return 
	*/
	public function getResignNotifiy() {
		$this->db->where('user_id', $this->userData['id']);
		$this->db->where(['new' => 0, 'stat' => 1, 'notify' => 1]);
		if (!$result = $this->_row('resign')) return false;
		return $result;
	}
	
	
	
	
	/**
	 * Подал ли учасник заявку на увольнение
	 * @param 
	 * @return 
	*/
	public function isResignation() {
		$this->db->where('user_id', $this->userData['id']);
		if ($this->db->count_all_results('resign') == 0) return false;
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function hasBirthDay() {
		$this->db->select('birthday');
		$this->db->where('id', $this->userData['id']);
		$bDay = $this->_row('users', 'birthday');
		return is_null($bDay);
	}
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function setBirthDay($date = false) {
		if (!$date) return false;
		$date = strtotime($date);
		$this->db->where('id', $this->userData['id']);
		if (!$this->db->update('users', ['birthday' => $date])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getRatingsData($periodId = false, $userId = false) {
		if (!$periodId) return false;
		$this->db->select('activity, skill, fine, visits');
		$this->db->where('user_id', $userId);
		//$this->db->where('period_id !=', $periodId);
		$this->db->order_by('period_id', 'ASC');
		if (!$result = $this->_result('ratings_data')) return false;
		$data = array_merge($result, array_fill(0, 4, end($result)));
		
		$countItems = count($data);
		$activity = 0;
		$skill = 0;
		$fine = 0;
		$visits = 0;
		foreach ($data as $row) {
			$activity += $row['activity'];
			$skill += $row['skill'];
			$fine += $row['fine'];
			$visits += $row['visits'];
		}
		
		return [
			'activity' 	=> round(($activity / $countItems), 2),
			'skill' 	=> round(($skill / $countItems), 2),
			'fine' 		=> round(($fine / $countItems), 2),
			'visits' 	=> round(($visits / $countItems), 2)
		];
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getReprimands($periodId = false, $userId = false) {
		$this->db->select('COUNT(user_id) AS reprimands');
		$this->db->where('user_id', $userId);
		//$this->db->where('rating_period_id !=', $periodId);
		$this->db->order_by('rating_period_id', 'ASC');
		$this->db->group_by('rating_period_id');
		if (!$result = $this->_result('reprimands')) return false;
		$data = array_merge($result, array_fill(0, 4, end($result)));
		
		$countItems = count($data);
		$reprimands = 0;
		foreach ($data as $row) {
			$reprimands += $row['reprimands'];
		}
		
		return round(($reprimands / $countItems), 2);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getForcemajeure($periodId = false, $userId = false) {
		$this->db->select('COUNT(user_id) AS forcemajeure');
		$this->db->where('user_id', $userId);
		//$this->db->where('rating_period_id !=', $periodId);
		$this->db->order_by('rating_period_id', 'ASC');
		$this->db->group_by('rating_period_id');
		if (!$result = $this->_result('forcemajeure')) return false;
		$data = array_merge($result, array_fill(0, 4, end($result)));
		
		$countItems = count($data);
		$forcemajeure = 0;
		foreach ($data as $row) {
			$forcemajeure += $row['forcemajeure'];
		}
		
		return round(($forcemajeure / $countItems), 2);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getStimulations($periodId = false, $userId = false) {
		$this->db->select('index AS stimulation');
		$this->db->where('user_id', $userId);
		//$this->db->where('rating_period_id !=', $periodId);
		$this->db->order_by('rating_period_id', 'ASC');
		if (!$result = $this->_result('stimulations')) return false;
		$data = array_merge($result, array_fill(0, 4, end($result)));
		
		$countItems = count($data);
		$stimulations = 0;
		foreach ($data as $row) {
			$stimulations += $row['stimulation'];
		}
		
		return round(($stimulations / $countItems), 2);
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getMentorsData($periodId = false, $userId = false) {
		$this->db->select('COUNT(mentor_id) AS mentor');
		$this->db->where([/*'period_id !=' => $periodId, */'mentor_id' => $userId, 'done !=' => 'null']);
		$this->db->order_by('period_id', 'ASC');
		$this->db->group_by('period_id');
		if (!$result = $this->_result('mentors_requests')) return false;
		$data = array_merge($result, array_fill(0, 4, end($result)));
		
		$countItems = count($data);
		$mentors = 0;
		foreach ($data as $row) {
			$mentors += $row['mentor'];
		}
		
		return round(($mentors / $countItems), 2);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------- Технические функции
	
	/**
	 * Скорректировать стаж
	 * эта функция применяется на акуальной таблице users а возвращает SQL строки для обновления таблицы, в которой слетели значения stage
	 * для этого нужно иметь таблицу users с правильными значениями stage
	 * @param прибавить к отрицательному стажу
	 * @return 
	*/
	public function correctUsersStages($append = false) {
		$this->db->select('id, stage');
		//$this->db->where('stage !=', 0);
		$query = $this->db->get('users');
		$result = $query->result_array();
		
		if ($append) {
			foreach ($result as $k => $row) {
				if ($row['stage'] < 0) {
					$result[$k]['stage'] = $row['stage'] - $append;
				}
			}
		}
			
		
		$resultParts = array_chunk($result, 100);
		
		$queryData = '';
		foreach ($resultParts as $part) {
			$this->db->update_batch('users', $part, 'id'); 
			$queryData .= $this->db->last_query().';'."\r\n";
		}
		
		return $queryData;
	}
	
	
}