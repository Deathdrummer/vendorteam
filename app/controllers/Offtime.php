<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Offtime extends MY_Controller {
	
	public function __construct() {
		parent::__construct();
		$this->load->model('offtime_model');
	}
	
	
	
	
	
	/**
	 * Установить лимиты на выходные
	 * @param 
	 * @return 
	 */
	public function set_roles_limits() {
		$data = $this->input->post('offtime_limits');
		echo $this->offtime_model->setRolesLimits($data);
	}
	
	
	
	
	
	/**
	 * Забронировать выходной
	 * @param 
	 * @return 
	 */
	public function set_offtime() {
		$data = $this->input->post();
		$history = arrTakeItem($data, 'history');
		
		$code = $this->offtime_model->setOfftime($data);
		if ($code == 1) $this->get_offtime_dates($history);
		else echo $code;
	}
	
	
	
	/**
	 * Снять бронь
	 * @param 
	 * @return 
	 */
	public function unset_offtime() {
		$id = $this->input->post('id');
		$static = $this->input->post('static');
		$history = $this->input->post('history');
		
		if ($this->offtime_model->unsetOfftime($id, $static)) {
			$this->get_offtime_dates($history);
		}
	}
	
	
	
	
	/**
	 * Формирование календаря выходных
	 * @param 
	 * @return 
	 */
	public function get_offtime_dates($history = false) {
		if (! $this->input->is_ajax_request()) return false;
		$this->load->model(['account_model', 'admin_model']);
		$static = $this->input->post('static');
		$history = $this->input->post('history') ?: 0;
		
		$startDatePoint = (date('j', time()) == 1) ? strtotime('today') : strtotime(date('d-m-Y', strtotime('first day of '.$history.' month')));

		$data['offtime_dates'] = getDatesRange($startDatePoint, date('t', $startDatePoint), 'day'); // 604800 показывать предыдущую неделю
		$data['disabled'] = $this->offtime_model->getOfftimeDisabled();
		$data['user_id'] = $this->getUserId();
		$data['statics_names'] = $this->admin_model->getStatics(true);
		$data['static'] = $static;
		$data['location'] = $this->admin_model->getStaticLocation($static);
		$data['role'] = $this->account_model->getRole();
		$data['current_date'] = strtotime('today');
		$data['history_disabled'] = $history >= 1 ? true : false;
		
		$data['users'] = $this->offtime_model->getOfftimeUsers($static);
		
		$rolesLimits = $this->offtime_model->getRolesLimits($static);
		
		if ($data['users']) {
			foreach ($data['users'] as $date => $item) {
				if (!isset($item['roles']) || empty($item['roles'])) continue;
				foreach ($item['roles'] as $role => $count) {
					if (isset($rolesLimits[$role])) {
						if ($count < $rolesLimits[$role]) {
							$data['users'][$date]['roles'][$role] = true;
						} else {
							$data['users'][$date]['roles'][$role] = false;
						}
					} else {
						$data['users'][$date]['roles'][$role] = false;
					}	
				}
			}
		}
		
		echo $this->twig->render('views/account/render/offtime_dates', $data);
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get_offtime_history() {
		$history = $this->input->post('history') ?: 0;
		$this->load->model('admin_model');
		$data['statics'] = $this->admin_model->getStatics();
		$data['roles'] = $this->admin_model->getRoles();
		$data['roles_limits'] = $this->offtime_model->getRolesLimits();
		
		$startDatePoint = (date('j', time()) == 1) ? strtotime('today') : strtotime(date('d-m-Y', strtotime('first day of '.$history.' month')));
		$data['offtime']['dates'] = getDatesRange($startDatePoint, date('t', $startDatePoint), 'day');
		$data['offtime']['users'] = $this->offtime_model->getOfftimeUsers();
		$data['offtime']['disabled'] = $this->offtime_model->getOfftimeDisabled();
		$data['current_date'] = strtotime('today');
		echo $this->twig->render('views/admin/render/offtime_history', $data);
	}
	
	
	
	
	
	
	/**
	 * Запретить день для бронирования выходных
	 * @param 
	 * @return 
	 */
	public function disable_day() {
		if (! $this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if (!$insertId = $this->offtime_model->disableDay($data)) exit('0');
		$this->offtime_model->removeUsersFromDay($data['static'], $data['date']);
		echo $insertId;
	}
	
	
	
	
	/**
	 * Разрешить день для бронирования выходных
	 * @param 
	 * @return 
	 */
	public function enable_day() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo json_encode($this->offtime_model->enableDay($id));
	}
	
	
	
	
	/**
	 * Удалить пользователя из бронирования выходных
	 * @param 
	 * @return 
	 */
	public function disable_user() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		echo $this->offtime_model->removeUsersFromDay($data['static'], $data['date'], $data['user']);
	}
	
	
	
	
	
	/**
	 * Получить забронированных пользователей
	 * @param 
	 * @return 
	 */
	/*public function get_offtime_users() {
		$offtimeUsers = $this->offtime_model->getOfftimeUsers(true);
		echo '<pre>';
			print_r($offtimeUsers);
		exit('</pre>');
	}*/
	
	
}