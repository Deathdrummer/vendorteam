<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Vacation extends MY_Controller {
	
	public function __construct() {
		parent::__construct();
		$this->load->model('vacation_model', 'vacationmodel');
	}
	
	
	
	
	/**
	 * Формирование календаря отпусков
	 * @param 
	 * @return 
	 */
	public function get_vacation_dates() {
		if (!$this->input->is_ajax_request()) return false;
		$static = $this->input->post('static');
		$shift = $this->input->post('shift') ?: 0;
		$userId = get_cookie('id'); //$this->session->userdata('id');
		
		$this->load->model('users_model', 'usersmodel');
		$userRank = $this->usersmodel->getUserRank($userId) ?: false;
		$settings = $this->vacationmodel->getSettings($static);
		
		if (!is_array($settings['enabled_ranks']) || !in_array($userRank['id'], $settings['enabled_ranks'])) exit('');
		
		$countWeeks = 8; // Количество недель для показа
		$shiftWeeks = $shift; // Смещение (недель) относительно последнего понедельника
		$disabledWeekDays = $settings['disabled_week'] ?: false; // Запрещенные дни недели
		$disabledMonthDays = $settings['disabled_month'] ?: false; // Запрещенные дни месяца
		$oneDayUsersLimit = $settings['parallel']; // лимит одновременного бронирования
		$vacationsLimit = $settings['limit']; // лимит бронирования в год
		$vacationsParty = $settings['party']; // лимит партии
		$vacationsSpace = $settings['space']; // промежуток между партиями
		
		
		$startDatePoint = (date('l', time()) == 'Monday') ? strtotime('today') : strtotime('last monday');
		$enableDatePoint = (date('l', time()) == 'Monday') ? strtotime('today') + (86400 * (7 * 4)) : strtotime('last monday') + (86400 * (7 * 4));
		$dates = getDatesRange(($startDatePoint + (86400 * (7 * $shiftWeeks))), (7 * $countWeeks)); // показывать начиная с 28 дней вперед, чтобы не перекрывать выходные
		
		$vacationUsers = $this->vacationmodel->getVacationUsers($static);
		$disabledStaticDates = $this->vacationmodel->getDisabledDays($static);
		
		$data['dates'] = [];
		$data['disabled_dates'] = $disabledStaticDates ?: [];
		foreach ($dates as $d) {
			$m = date('n', $d);
			$data['dates'][$this->monthes2[$m]][] = $d;
			
			if ($disabledWeekDays && in_array(date('N', $d), $disabledWeekDays)) $data['disabled_dates'][] = $d;
			if ($disabledMonthDays && in_array(date('j', $d), $disabledMonthDays)) $data['disabled_dates'][] = $d;
		}
		
		
		$dDates = [];
		if ($vacationUsers) {
			foreach ($vacationUsers as $user) {
				if (!$user['dates']) continue;
				foreach ($user['dates'] as $date) {
					if (!isset($dDates[$date])) $dDates[$date] = 0;
					$dDates[$date] += 1;
				}
			}
		}
			
		
		$dDates = array_filter($dDates, function($item) use($oneDayUsersLimit) {
			return $item >= $oneDayUsersLimit;
		});
		$data['disabled_dates'] = array_unique(array_merge($data['disabled_dates'], array_keys($dDates)));
		
		
		$countOfYear = $this->vacationmodel->getUserVacationsCountOfYear($userId);
		$data['vacations_limit'] = $vacationsLimit - $countOfYear; 
		$data['vacations_space'] = $vacationsSpace; 
		$data['vacations_party'] = $vacationsParty;
		
		$data['static'] = $static;
		$data['user_id'] = $userId;
		$data['statics_names'] = $this->admin_model->getStatics(true);
		$data['location'] = $this->admin_model->getStaticLocation($static);
		$data['vacation_users'] = $vacationUsers;
		$data['vacation_dates'] = $dates;
		$data['enabled_point'] = $enableDatePoint;
		$data['current_date'] = strtotime('today');
		
		echo $this->twig->render('views/account/render/vacation_dates', $data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function set_vacation_date() {
		if (!$this->input->is_ajax_request()) return false;
		$pData = $this->input->post();
		if ($this->vacationmodel->setVacationDate($pData)) echo '1';
		else echo '0';
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function unset_vacation_date() {
		if (!$this->input->is_ajax_request()) return false;
		$pData = $this->input->post();
		if ($this->vacationmodel->unsetVacationDate($pData)) echo '1';
		else echo '0';
	}
	
	
	
	
	
	
	
	
	/**
	 * Отрендерить форму с запрещенными днями
	 * @param 
	 * @return 
	 */
	public function get_disabled_days() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		
		$data = [
			'static' 		=> $data['static_html'],
			'week_days' 	=> json_decode($data['week_days'], true),
			'month_days' 	=> json_decode($data['month_days'], true),
			'week_names' 	=> $this->weekShort
		];
		
		echo $this->twig->render('views/admin/render/vacation/disabled_days', $data);
	}
	
	
	
	
	/**
	 * Отрендерить форму с разрешенными званиями
	 * @param 
	 * @return 
	 */
	public function get_enabled_ranks() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		$this->load->model('admin_model', 'adminmodel');
		
		$data = [
			'static' 		=> $data['static_html'],
			'enabled_ranks'	=> json_decode($data['enabled_ranks'], true),
			'ranks'			=> $this->adminmodel->getRanks(true, true)
		];
		
		echo $this->twig->render('views/admin/render/vacation/enabled_ranks', $data);
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function save_settings() {
		if (!$this->input->is_ajax_request()) return false;
		$pData = $this->input->post('vacation_settings');
		if (!$this->vacationmodel->saveSettings($pData)) echo 0;
		else echo 1;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------- admin
	
	
	
	/**
	 * Получить данные для админки
	 * @param 
	 * @return 
	 */
	public function get_data_to_admin() {
		if (!$this->input->is_ajax_request()) return false;
		
		$this->load->model('users_model', 'usersmodel');
		$users = $this->usersmodel->getUsers(['where' => ['verification' => 1, 'deleted' => 0]]);
		$usersData = [];
		if ($users) {
			foreach ($users as $user) {
				$usersData[$user['static']][$user['id']] = [
					'user_id' 	=> $user['id'],
					'nickname' 	=> $user['nickname'],
					'avatar' 	=> $user['avatar'],
					'dates'		=> []
				];
			}
		}
		
		
		$post = $this->input->post();
		$settings = $this->vacationmodel->getSettings();
		$vacationUsers = $this->vacationmodel->getVacationUsers();
		$disabledStaticDates = $this->vacationmodel->getDisabledDays();
		$staticsNames = $this->admin_model->getStatics(true);
		
		$countWeeks = 6; // Количество недель для показа
		$shiftWeeks = $post['weeks_shift'] ?: 0; // Смещение (недель) относительно последнего понедельника
		
		$startDatePoint = (date('l', time()) == 'Monday') ? strtotime('today') : strtotime('last monday');
		$dates = getDatesRange(($startDatePoint + (86400 * (7 * $shiftWeeks))), (7 * $countWeeks)); // показывать начиная с 28 дней вперед, чтобы не перекрывать выходные
		
		$vacationUsers = array_replace_recursive($usersData, $vacationUsers);
		$data = [];
		if ($vacationUsers) {
			foreach ($vacationUsers as $staticId => $users) {
				$disabledWeekDays = isset($settings[$staticId]) ? $settings[$staticId]['disabled_week'] : false; // Запрещенные дни недели
				$disabledMonthDays = isset($settings[$staticId]) ? $settings[$staticId]['disabled_month'] : false; // Запрещенные дни месяца
				$oneDayUsersLimit = isset($settings[$staticId]) ? $settings[$staticId]['parallel'] : 0; // лимит одновременного бронирования
				$vacationsLimit = isset($settings[$staticId]) ? $settings[$staticId]['limit'] : 0; // лимит бронирования в год
				$vacationsParty = isset($settings[$staticId]) ? $settings[$staticId]['party'] : 0; // лимит партии
				$vacationsSpace = isset($settings[$staticId]) ? $settings[$staticId]['space'] : 0; // промежуток между партиями
			
			
				$data['dates'][$staticId] = [];
				$data['disabled_dates'][$staticId] = [];
				$data['disabled_static_dates'][$staticId] = isset($disabledStaticDates[$staticId]) ? $disabledStaticDates[$staticId] : [];
				foreach ($dates as $d) {
					$m = date('n', $d);
					$data['dates'][$staticId][$this->monthes2[$m]][] = $d;
					
					if ($disabledWeekDays && in_array(date('N', $d), $disabledWeekDays)) {
						$data['disabled_dates'][$staticId][] = $d;
					}
					
					if ($disabledMonthDays && in_array(date('j', $d), $disabledMonthDays)) {
						$data['disabled_dates'][$staticId][] = $d;
					}
				}
				
				
				$dDates = [];
				foreach ($users as $user) {
					if (!$user['dates']) continue;
					foreach ($user['dates'] as $date) {
						if (!isset($dDates[$date])) $dDates[$date] = 0;
						$dDates[$date] += 1;
					}
				}
				
				$dDates = array_filter($dDates, function($item) use($oneDayUsersLimit) {
					return $item >= $oneDayUsersLimit;
				});
				$data['disabled_dates'][$staticId] = array_unique(array_merge($data['disabled_dates'][$staticId], array_keys($dDates)));
				
				//$data[$staticId]['location'] = $this->admin_model->getStaticLocation($staticId);
				$data['vacation_users'][$staticId] = $users;
				$data['vacation_dates'][$staticId] = $dates;
			}
		}
		
		echo $this->twig->render('views/admin/render/vacation/vacation_dates', array_merge($data, ['statics_names' => $staticsNames]));
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function days_action() {
		if (!$this->input->is_ajax_request()) return false;
		
		$data = $this->input->post();
		
		switch ($data['action']) {
			case 'set':
				if (!$this->vacationmodel->setDays($data['days'])) echo '0';
				else echo '1';
				break;
			
			case 'confirm':
				if (!$this->vacationmodel->confirmDays($data['days'])) echo '0';
				else echo '1';
				break;
			
			case 'remove':
				if (!$this->vacationmodel->removeDays($data['days'])) echo '0';
				else echo '1';
				break;
		}
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function disabled_enabled_days() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		$func = $data['disabled'] ? 'enabledStaticDay' : 'disabledStaticDay';
		if (!$this->vacationmodel->$func($data['static_id'], $data['day'])) echo '0';
		else echo '1';
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function g_disabled_enabled_days() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		
		// action items
		// globalEnabledDay
		// globalDisabledDay
		
		
		
		
		
		
		$func = $data['action'] == 'set' ? 'globalSetDisabledDay' : 'globalRemoveDisabledDay';
		if (!$this->vacationmodel->$func($data['items'])) echo '0';
		else echo '1';
	}
	
	
	
	
	
	
}