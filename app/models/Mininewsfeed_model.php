<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Mininewsfeed_model extends MY_Model {
	
	private $templatesTable = 'mininewsfeed_templates'; // type title text
	private $newsFeedTable = 'mininewsfeed_data'; // 
	private $newsFeedLaterTable = 'mininewsfeed_later'; // 
	
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	/**
	 * Шаблоны
	 * @param 
	 * @return 
	*/
	public function templates($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				if (!$data) return false;
				$this->db->where('type', $data);
				if (!$data = $this->_result($this->templatesTable)) return false;
				return $data;
				break;
			
			case 'save':
				if (!$data) return false;
				if (!$this->db->insert($this->templatesTable, $data)) return false;
				return $this->db->insert_id();
				break;
			
			case 'update':
				if (!$data) return false;
				$this->db->where('id', $data['id']);
				if (!$this->db->update($this->templatesTable, $data['fields'])) return false;
				return true;
				break;
			
			case 'remove':
				if (!$data) return false;
				$this->db->where('id', $data);
				if (!$this->db->delete($this->templatesTable)) return false;
				return true;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	//------------------------------------------------------------------
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function list($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				$this->db->order_by('id', 'DESC');
				if (!$newsFeedList = $this->_result($this->newsFeedTable)) return false;
				
				foreach ($newsFeedList as $k => $item) {
					$newsFeedList[$k]['statics'] = json_decode($item['statics'], true);
				}
				return $newsFeedList;
				break;
			
			case 'item':
				if (!isset($data['id'])) return false;
				$this->db->where('id', $data['id']);
				if (!$newsFeedItem = $this->_row($this->newsFeedTable)) return false;
				$newsFeedItem['statics'] = json_decode($newsFeedItem['statics'], true);
				return $newsFeedItem;
				break;
			
			case 'add':
				if (!$data) return false;
				$data['type'] = 3;
				
				// отправка сразу
				unset($data['later_date'], $data['later_hours'], $data['later_minutes']);
				
				$data['date'] = time();
				if (!$this->db->insert($this->newsFeedTable, $data)) return false;
				return true;
				break;
			
			case 'update':
				if (!$data) return false;
				$data['date'] = time();
				$this->db->where('id', $data['id']);
				if (!$this->db->update($this->newsFeedTable, $data)) return false;
				return true;
				break;
			
			case 'remove':
				if (!isset($data['id'])) return false;
				$this->db->where('id', $data['id']);
				if (!$this->db->delete($this->newsFeedTable)) return false;
				return true;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	//------------------------------------------------------------------
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function later($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				$this->db->order_by('id', 'DESC');
				if (!$newsFeedLater = $this->_result($this->newsFeedLaterTable)) return false;
				
				foreach ($newsFeedLater as $k => $item) {
					$newsFeedLater[$k]['statics'] = json_decode($item['statics'], true);
				}
				return $newsFeedLater;
				break;
			
			case 'item':
				if (!isset($data['id'])) return false;
				$this->db->where('id', $data['id']);
				if (!$newsFeedLaterItem = $this->_row($this->newsFeedLaterTable)) return false;
				$newsFeedLaterItem['statics'] = json_decode($newsFeedLaterItem['statics'], true);
				return $newsFeedLaterItem;
				break;
			
			case 'add':
				if (!$data) return false;
				$data['type'] = 3;
				
				$date = strtotime($data['later_date']);
				$hours = $data['later_hours'] ? ($data['later_hours'] * 60 * 60) : 0;
				$minutes = $data['later_minutes'] ? ($data['later_minutes'] * 60) : 0;
				
				$data['date'] = $date + $hours + $minutes;
				
				unset($data['later_date'], $data['later_hours'], $data['later_minutes']);
				if (!$this->db->insert($this->newsFeedLaterTable, $data)) return false;
				return true;
				break;
			
			case 'update':
				if (!$data) return false;
				
				$date = strtotime($data['later_date']);
				$hours = $data['later_hours'] ? ($data['later_hours'] * 60 * 60) : 0;
				$minutes = $data['later_minutes'] ? ($data['later_minutes'] * 60) : 0;
				
				$data['date'] = $date + $hours + $minutes;
				
				unset($data['later_date'], $data['later_hours'], $data['later_minutes']);
				$this->db->where('id', $data['id']);
				if (!$this->db->update($this->newsFeedLaterTable, $data)) return false;
				return true;
				break;
			
			case 'remove':
				if (!isset($data['id'])) return false;
				$this->db->where('id', $data['id']);
				if (!$this->db->delete($this->newsFeedLaterTable)) return false;
				return true;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	//------------------------------------------------------------------
	
	
	
	
	
	
	/**
	 * CRON функция
	 * Добавить сообщения в ленту из отложенных
	 * @param 
	 * @return 
	 */
	public function addLaterNewsFeed() {
		$this->db->select('id, type, icon, text, statics');
		$date = time();
		$this->db->where('date <', $date);
		if (!$miniNewsFeedLater = $this->_result($this->newsFeedLaterTable)) return false;
		
		
		$miniNewsIdsToDelete = []; $miniNewsFeedLaterData = [];
		foreach ($miniNewsFeedLater as $item) {
			$miniNewsIdsToDelete[] = arrTakeItem($item, 'id');
			$item['date'] = $date;
			$miniNewsFeedLaterData[] = $item;
		}
		
		$this->db->insert_batch($this->newsFeedTable, $miniNewsFeedLaterData);
		
		$this->db->where_in('id', $miniNewsIdsToDelete);
		$this->db->delete($this->newsFeedLaterTable);
	}
	
	
	
	
	
	
	
	/**
	 * CRON функция
	 * Добавить сообщения в ленту
	 * @param icon text statics
	 * @return 
	*/
	public function addToNewsFeed($data = false) {
		if (!$data) return false;
		
		if (is_array($data)) {
			$this->db->insert_batch($this->newsFeedTable, $data);
			return true;
		}
		
		if (!$this->db->insert($this->newsFeedTable, $data)) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * Вывести события в ленту (ЛК)
	 * @param 
	 * @return 
	*/
	public function getNewsFeedList($staticId = false) {
		$this->load->model('account_model', 'account');
		
		if ($staticId) {
			if (!$where = $this->jsonSearch([(int)$staticId], 'statics')) return false;
		} else {
			if (!$userData = $this->account->getUserData()) return false;
			if (!isset($userData['statics']) || empty($userData['statics'])) return false;
			$statics = array_keys($userData['statics']);
			if (!$where = $this->jsonSearch($statics, 'statics')) return false;
		}
		
		$this->db->order_by('id', 'DESC');
		$this->db->where($where);
		
		if (!$newsFeedList = $this->_result($this->newsFeedTable)) return false;
		return $newsFeedList;
	}
	
	
	
	
	
	
}