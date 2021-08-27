<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Messages_model extends MY_Model {
	
	
	private $usersMesagesTable = 'users_messages';
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get($id = false) {
		if ($id) {
			$this->db->where('id', $id);
			if (!$message = $this->_row($this->usersMesagesTable)) return false;
			$tableUsers = json_decode($message['to'], true);
			$this->load->model('users_model', 'users');
			$usersData = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => array_keys($tableUsers)], 'where' => ['us.main' => 1, 'u.deleted' => 0], 'fields' => 'id nickname avatar static']);
			
			$usersToForm = [];
			foreach ($tableUsers as $userId => $stat) {
				$usersToForm[$userId] = $usersData[$userId];
				$usersToForm[$userId]['stat'] = $stat;
			}
			
			$message['to'] = arrRestructure($usersToForm, 'static id');
			return $message;
		}
		
		
		$this->db->order_by('id', 'DESC');
		if (!$result = $this->_result($this->usersMesagesTable)) return false;
		
		$messages = [];
		foreach ($result as $row) {
			$users = json_decode($row['to'], true);
			$countDone = array_count_values($users);
			$row['users_done'] = isset($countDone[1]) ? $countDone[1] : 0;
			$row['users_all'] = count($users);
			unset($row['to']);
			$messages[] = $row;
		}
		return $messages;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getStat($userId = false) {
		if (!$userId) return false;
		$this->db->select("JSON_CONTAINS(JSON_KEYS(um.to), '\"".$userId."\"') AS allitems, JSON_CONTAINS(um.to, '{\"".$userId."\": 0}') AS statitems");
		/*if ($stat) {
			$this->db->where("JSON_CONTAINS(JSON_KEYS(um.to), '\"".$userId."\"')");
		} else {
			$this->db->where("JSON_CONTAINS(um.to, '{\"".$userId."\": ".$stat."}')");
		}*/
		$this->db->group_by('um.id');
		if (!$res = $this->_result($this->usersMesagesTable.' um')) return false;
		
		
		$all = array_sum(array_column($res, 'allitems'));
		$stat = array_sum(array_column($res, 'statitems'));
		
		return ['all' => $all, 'unread' => $stat];
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function setStat($id = false, $userId = false) {
		if (!$id || !$userId) return false;
		
		$this->db->where('id', $id);
		if (!$message = $this->_row($this->usersMesagesTable)) return false;
		$to = json_decode($message['to'], true);
		if (!isset($to[$userId])) return false;
		$to[$userId] = 1;
		$message['to'] = json_encode($to);
		
		$this->db->where('id', $id);
		if (!$this->db->update($this->usersMesagesTable, $message)) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * 
	 * @param 
	 * @return 
	*/
	public function getListToUser($userId = false) {
		if (!$userId) return false;
		$this->db->select('id, title, to');
		$this->db->where("JSON_CONTAINS(JSON_KEYS(um.to), '\"".$userId."\"')");
		if (!$res = $this->_result($this->usersMesagesTable.' um')) return false;
		
		$data = [];
		foreach ($res as $k => $row) {
			$to = json_decode($row['to'], true);
			$stat = isset($to[$userId]) ? $to[$userId] : null;
			unset($row['to']);
			
			if (!is_null($stat)) $data[$stat][] = $row;
		}
		
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getItemToUser($id = false, $userId = false) {
		if (!$id || !$userId) return false;
		$this->db->where('id', $id);
		if (!$message = $this->_row($this->usersMesagesTable)) return false;
		$user = $this->_getUserData($userId);
		
		$message['message'] = preg_replace_callback('/\[(\w+)\]/', function($matches) use (&$user) {
			$field = $matches[1];
			
			if ($field == 'statics') {
				$stStr = '';
				foreach ($user['statics'] as $static) $stStr .= $static['name'].', ';
				return rtrim($stStr, ', ');
			}
			
			if ($field == 'main_static') {
				return $user['statics'][$user['main_static']]['name'];
			}
			
			if ($field == 'rank') {
				$ranks = $this->_getRanks();
				return $ranks[$user['rank']]['name'];
			}
			
			if ($field == 'birthday') {
				$date = $user['birthday'];
				return date('j', $date).' '.$this->monthes[date('n', $date)].' '.date('Y', $date).' г.';
			}
			
			if ($field == 'avatar') {
				return '<img src="/public/images/users/'.$user['avatar'].'" class="avatar w100px h100px" />';
			}
			
			return $user[$field];
		}, $message['message']);
		
		
		return $message;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function add($users = false, $title = false, $message = false) {
		if (!$users || !$title || !$message) return false;
		
		$users = array_combine($users, array_fill(0, count($users), 0));
		$users = json_encode($users);
		
		$insData = [
			'title'		=> $title,
			'to'		=> $users,
			'message'	=> $message,
			'date'		=> time()
		];
		
		if (!$this->db->insert($this->usersMesagesTable, $insData)) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update($id = false, $users = false, $title = false, $message = false) {
		if (!$id || !$users || !$title || !$message) return false;
		
		$this->db->select('to');
		$this->db->where('id', $id);
		if (!$tableUsers = $this->_row($this->usersMesagesTable, 'to')) return false;
		$tableUsers = json_decode($tableUsers, true);
		$formUsers = array_flip($users);
		
		$updateUsers = array_intersect_key($tableUsers, $formUsers);
		$users = json_encode($updateUsers);
		
		$upData = [
			'title'		=> $title,
			'to'		=> $users,
			'message'	=> $message,
			'date'		=> time()
		];
		
		$this->db->where('id', $id);
		if (!$this->db->update($this->usersMesagesTable, $upData)) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->usersMesagesTable)) return false;
		return true;
	} 
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * CRUD
	 * @param 
	 * @return 
	*/
	/*public function usersMessages($action = false) {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				if ($data) $this->db->where($data);
				if (!$result = $this->_result($this->usersMesagesTable)) return false;
				return $result;
				break;
			
			default: break;
		}
	}*/
	
	
	
	
	
	
	//------------------------------------------------------
	/**
	 * @param 
	 * @return 
	*/
	private function _getUserData($userId = false) {
		$this->load->model('account_model', 'account');
		$userData = $this->account->getUserData($userId);
		return $userData;
	}
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getRanks() {
		$this->load->model('admin_model', 'admin');
		return $this->admin->getRanks(0);
	}
	
	
}