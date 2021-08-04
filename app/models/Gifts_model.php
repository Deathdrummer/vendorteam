<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Gifts_model extends MY_Model {
	
	private $giftsTable = 'gifts';
	public function __construct() {
		parent::__construct();
		
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get($where = false) {
		if ($where) $this->db->where($where);
		if (!$result = $this->_result($this->giftsTable)) return false;
		return $result;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save($data = false) {
		if (!$data) return false;
		if (!$this->db->insert($this->giftsTable, $data)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update($this->giftsTable, $fields)) return false;
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->giftsTable)) return false;
		return true;
	}
	
	
	
	
	
}