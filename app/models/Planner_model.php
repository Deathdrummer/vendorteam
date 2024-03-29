<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Planner_model extends MY_Model {
	
	private $week = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
	private $plannerMonthes = [1 => 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];
	
	public function __construct() {
		parent::__construct();
	}
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function list($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'get':
				$countDays = date('t', strtotime("first day of ${offset} month"));
				$firstDayDate = strtotime("first day of ${offset} month");
				$current = strtotime(date('Y-m-d', time()));
				$notMonday = date('w', $firstDayDate) > 1 || date('w', $firstDayDate) == 0;
				$dayNum = date('w', $firstDayDate) ?: 7;
				
				
				$allDays = getDatesRange($firstDayDate, $countDays, 'day', '+', false, false);
				if ($notMonday) array_unshift($allDays, ...array_fill_keys(range(1, $dayNum - 1), null));
				return ['items' => $allDays, 'week' => $this->week, 'current' => $current];
				break;
				
			case 'date':
				$firstDayDate = strtotime("first day of ${offset} month");
				return json_encode(['month' => $this->plannerMonthes[date('n', $firstDayDate)], 'year' => date('Y', $firstDayDate)]);
				break;
			
			default: break; // no action
		}
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function data($data = false) {
		if (!$data) return false;
		extract(snakeToCamelcase($data));
		
		switch ($type) {
			case 'birthdays':
				$firstDayDate = strtotime("first day of ${offset} month");
				$month = date('n', $firstDayDate);
				return $this->_getBirthdaysUsers($month, $showLists ?? false);
				break;
			
			default: break; // no action
		}
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function message($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		if (isset($args[1]) && is_array($args[1])) extract(snakeToCamelcase($args[1])); // keys to uppercase
		
		switch ($action) {
			case 'send':
				$insData = [
					'title'		=> $title,
					'to'		=> json_encode([$userId => 0]),
					'message'	=> $message,
					'date'		=> time()
				];
				
				return $this->db->insert('users_messages', $insData);
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getBirthdaysUsers($month = false, $showLists = false) {
		if (!$month) return false;
		$this->db->select('id, nickname, avatar, birthday');
		//$this->db->where(['deleted' => 0, 'verification' => 1, 'excluded' => 0]);
		$this->db->where('birthday is NOT NULL');
		
		if ($showLists) {
			$this->db->group_start();
			foreach ($showLists as $item) {
				switch ($item) {
					case 'verify':
						$this->db->or_where('verification', 1);
						break;
					
					case 'new':
						$this->db->or_where('verification', 0);
						$this->db->where('deleted', 0);
						break;
					
					case 'excluded':
						$this->db->or_where('excluded', 1);
						break;
					
					case 'frozen':
						$this->db->or_where('frozen', 1);
						break;
					
					case 'deleted':
						$this->db->or_where('deleted', 1);
						break;
					
					default: break;
				}
			}
			$this->db->group_end();
		} 
		
		
		if (!$users = $this->_result('users')) return false;
		
		$usersData = [];
		foreach ($users as $user) {
			if (date('n', $user['birthday']) != $month) continue;
			$usersData[date('j', $user['birthday'])][] = $user;
		}
		ksort($usersData);
		return $usersData;
	}
	
	
	
}