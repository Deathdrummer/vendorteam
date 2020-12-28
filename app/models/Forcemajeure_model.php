<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Forcemajeure_model extends MY_Model {
	
	private $forcemajeureTable = 'forcemajeure';

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
		$query = $this->db->get($this->forcemajeureTable);
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
		$result = $this->_row($this->forcemajeureTable);
		return $result;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getFromPeriod($ratingPeriodId = false) {
		if (!$ratingPeriodId) return false;
		$this->db->select('user_id, COUNT(user_id) AS forcemajeure');
		$this->db->where('rating_period_id', $ratingPeriodId);
		$this->db->group_by('user_id');
		$query = $this->db->get($this->forcemajeureTable);
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
		if (!$this->db->insert($this->forcemajeureTable, $data)) return false;
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
		$rowData = $this->_row($this->forcemajeureTable);
		
		$updateData = array_replace_recursive($rowData, $data);
		$updateData['date'] = strtotime($updateData['date']);
		$this->db->where('id', $id);
		if (!$this->db->update($this->forcemajeureTable, $updateData)) return false;
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->forcemajeureTable)) return false;
		return true;
	}
	
	
	
	

}