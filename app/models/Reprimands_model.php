<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Reprimands_model extends MY_Model {
	
	private $reprimandsTable = 'reprimands';

	public function __construct() {
		parent::__construct();
	}
	


	/**
	 * Получить список
	 * @param 
	 * @return 
	*/
	public function get($userId = false, $periodId = false) {
		if (!$userId) return false;
		$ratingPeriodId = $periodId ?: $this->getActiveRatingsPeriodId();
		
		$this->db->where(['rating_period_id' => $ratingPeriodId, 'user_id' => $userId]);
		$query = $this->db->get($this->reprimandsTable);
		if (!$result = $query->result_array()) return false;
		
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getItem($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		$result = $this->_row($this->reprimandsTable);
		return $result;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getFromPeriod($ratingPeriodId = false) {
		if (!$ratingPeriodId) return false;
		$this->db->select('user_id, COUNT(user_id) AS reprimands');
		$this->db->where('rating_period_id', $ratingPeriodId);
		$this->db->group_by('user_id');
		$query = $this->db->get($this->reprimandsTable);
		if (!$result = $query->result_array()) return [];
		$data = setArrKeyFromField($result, 'user_id', false);
		return $data;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function add($data = false) {
		if (!$data) return false;
		$data['rating_period_id'] = $this->getActiveRatingsPeriodId();
		$data['date'] = strtotime($data['date']);
		if (!$this->db->insert($this->reprimandsTable, $data)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update($data = false) {
		if (!$data) return false;
		$id = arrTakeItem($data, 'id');
		$this->db->where('id', $id);
		$rowData = $this->_row($this->reprimandsTable);
		
		$updateData = array_replace_recursive($rowData, $data);
		$updateData['date'] = strtotime($updateData['date']);
		$this->db->where('id', $id);
		if (!$this->db->update($this->reprimandsTable, $updateData)) return false;
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->reprimandsTable)) return false;
		return true;
	}
	
	
	
	
	

}