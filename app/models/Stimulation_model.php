<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Stimulation_model extends MY_Model {
	
	private $stimulationsTable = 'stimulations';

	public function __construct() {
		parent::__construct();
	}
	


	/**
	 * Задать коэффициент стимулирования
	 * @param данные
	 * @return статус: 1 - добавлено, 2 - обновлено
	*/
	public function set($data = false) {
		if (!$data) return false;
		$data['rating_period_id'] = $this->getActiveRatingsPeriodId();
		
		$this->db->where(['user_id' => $data['user_id'], 'rating_period_id' => $data['rating_period_id']]);
		if ($this->db->count_all_results($this->stimulationsTable) != 0) {
			$userId = arrTakeItem($data, 'user_id');
			$ratingPeriodId = arrTakeItem($data, 'rating_period_id');
			$this->db->where(['user_id' => $userId, 'rating_period_id' => $ratingPeriodId]);
			if (!$this->db->update($this->stimulationsTable, $data)) return false;
			return 2;
		}
		
		if (!$this->db->insert($this->stimulationsTable, $data)) return false;
		return 1;
	}
	
	
	

	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get($userId = false) {
		if (!$userId) return false;
		$ratingPeriodId = $this->getActiveRatingsPeriodId();
		$this->db->where(['user_id' => $userId, 'rating_period_id' => $ratingPeriodId]);
		$query = $this->db->get($this->stimulationsTable);
		if (!$result = $query->row_array()) return false;
		return $result;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getFromPeriod($ratingPeriodId = false) {
		if (!$ratingPeriodId) return false;
		$this->db->select('user_id, COUNT(user_id) AS stimulation');
		$this->db->where('rating_period_id', $ratingPeriodId);
		$this->db->group_by('user_id');
		$query = $this->db->get($this->stimulationsTable);
		if (!$result = $query->result_array()) return [];
		$data = setArrKeyFromField($result, 'user_id', false);
		return $data;
	}
	
	
	
	
	
	
	
	
	
	





}