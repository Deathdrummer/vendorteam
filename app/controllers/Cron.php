<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Cron extends MY_Controller {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	/**
	 * Обновить звания участников
	 * @param 
	 * @return 
	 */
	public function update_users_ranks() {
		if (!$this->_isCliRequest()) redirect();
		$this->load->model('users_model');
		$usersList = $this->users_model->setRanksToUsers();
	}
	
	
	
	
	/**
	 * Активация периодов
	 * @param 
	 * @return 
	 */
	public function change_activate_periods_stat() {
		if (!$this->_isCliRequest()) redirect();
		$this->load->model('reports_model');
		if (!$data = $this->reports_model->getTimerActivatePeriods()) return false;
		$now = time();
		foreach ($data as $item) {
			if ($item['time'] <= $now) $this->reports_model->activateReportPeriod($item);
		}
	}
	
	
	
	
	
	/**
	 * Задать стаж пользователям из статиков с приостановленным стажем
	 * @param 
	 * @return 
	 */
	public function set_users_stages() {
		if (!$this->_isCliRequest()) redirect();
		$this->load->model(['users_model', 'admin_model']);
		if (!$statics = $this->admin_model->getStatics()) return false;
		$staticsIds = [];
		foreach ($statics as $ctId => $static) {
			if ($static['stopstage'] == 1) $staticsIds[] = $ctId;
		}
		if (!$staticsIds) return false;
		
		if (!$usersList = $this->users_model->getUsers(['where_in' => ['field' => 'us.static_id', 'values' => $staticsIds]])) return false;
		
		$updateUsers = [];
		foreach ($usersList as $user) {
			$updateUsers[] = [
				'id' 	=> $user['id'],
				'stage' => (int)$user['stage'] - 1
			];
		}
		
		if ($updateUsers) $this->db->update_batch('users', $updateUsers, 'id');
	}
	
	
	
	
}