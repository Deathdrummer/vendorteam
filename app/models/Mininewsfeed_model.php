<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Mininewsfeed_model extends MY_Model {
	
	private $templatesTable = 'mininewsfeed_templates'; // type title text
	private $newsFeedTable = 'mininewsfeed_data'; // type title text
	
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get($type = false) {
		if (!$type) return false;
		$this->db->where('type', $type);
		if (!$data = $this->_result($this->templatesTable)) return false;
		return $data;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save($data = false) {
		if (!$data) return false;
		if (!$this->db->insert($this->templatesTable, $data)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update($this->templatesTable, $fields)) return false;
		return true;
	}
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->templatesTable)) return false;
		return true;
	}
	
	
	
	
	
	
	
	//------------------------------------------------------------------
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function list() {
		$this->db->order_by('id', 'DESC');
		if (!$newsFeedList = $this->_result($this->newsFeedTable)) return false;
		
		foreach ($newsFeedList as $k => $item) {
			$newsFeedList[$k]['statics'] = json_decode($item['statics'], true);
		}
		return $newsFeedList;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function item($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$newsFeedItem = $this->_row($this->newsFeedTable)) return false;
		$newsFeedItem['statics'] = json_decode($newsFeedItem['statics'], true);
		return $newsFeedItem;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function addToList($data = false) {
		if (!$data) return false;
		$data['type'] = 3;
		$data['date'] = time();
		if (!$this->db->insert($this->newsFeedTable, $data)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function updateListItem($data = false) {
		if (!$data) return false;
		$data['date'] = time();
		$this->db->where('id', $data['id']);
		if (!$this->db->update($this->newsFeedTable, $data)) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function removeFromList($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->newsFeedTable)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------
	
	
	
	/**
	 * Добавить сообщения в ленту (CRON)
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
	public function getNewsFeedList() {
		$this->load->model('account_model', 'account');
		
		$userData = $this->account->getUserData();
		$statics = array_keys($userData['statics']);
		
		$this->db->where($this->jsonSearch($statics, 'statics'));
		if (!$newsFeedList = $this->_result($this->newsFeedTable)) return false;
		return $newsFeedList;
	}
	
	
	
	
	
	
}