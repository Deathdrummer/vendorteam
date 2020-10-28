<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Admin extends MY_Controller {
	
	public $viewsPath = 'views/admin/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model(['admin_model', 'reports_model', 'users_model']);
		
		$token = $this->admin_model->getSettings('token');
		$sesToken = $this->session->userdata('token');
		if ($token != $sesToken && $this->session->userdata('token')) $this->logout();
	}
	
	
	
	public function index() {
		if ($this->session->userdata('token') == false) {
			$this->auth();
		} else {
			$data['date'] = date('Y');
			$this->twig->display($this->viewsPath.'index', $data);
		}
	}
	
	
	
	
	/**
	 * Авторизация в админке
	 * @param 
	 * @return 
	 */
	private function auth() {
		if ($this->input->server('REQUEST_METHOD') == 'POST' && !empty($this->input->post('login')) && !empty($this->input->post('password'))) {
			$token = $this->admin_model->getSettings('token');
			if ($token == md5($this->input->post('login').$this->input->post('password'))) {
				$this->session->set_userdata('token', $token);
				redirect('admin');
			} else {
				$this->twig->display($this->viewsPath.'auth', ['error' => true]);
			}
		} else {
			$this->twig->display($this->viewsPath.'auth');
		}
	} 
	
	
	
	
	/**
	 * Выход из админки
	 * @param 
	 * @return 
	 */
	public function logout() {
		$this->session->unset_userdata('token');
		redirect('admin');
	}
	
	
	
	
	
	
	
	
	/**
	 * Сохранить настройки
	 * @param 
	 * @return 
	 */
	public function save_settings() {
		if (!$this->input->is_ajax_request()) return false;
		if (!empty($this->input->post())) {
			echo $this->admin_model->saveSettings($this->input->post());
		}
	}
	
	
	
	/**
	 * Удалить файл
	 * @param 
	 * @return 
	 */
	public function delete_file() {
		if (! $this->input->is_ajax_request()) return false;
		echo json_encode($this->admin_model->deleteFile($this->input->post('file_setting'), $this->input->post('curren_file')));
	}
	
	
	
	/**
	 * рендеринг отображения
	 * @param 
	 * @return 
	 */
	public function render() {
		if (! $this->input->is_ajax_request()) return false;
		//$settings = $this->admin_model->getSettings();
		$post = $this->input->post();
		$post['form'] = 'views/admin/form/';
		echo $this->twig->render($this->viewsPath.$post['block'], $post);
	}
	
	
	
	
	
	/**
	 * Сформировать HTML код с данными для секции админки
	 * @return html
	 */
	public function get_sections_data() {
		if (! $this->input->is_ajax_request()) return false;
		$section = $this->input->post('section');
		$params = $this->input->post('params');
		if ($section) $data = $this->getDataToSection($section, $params);
		$data['form'] = 'views/admin/form/';
		$data['date'] = date('Y');
		echo $this->twig->render($this->viewsPath.'sections/'.$section.'.tpl', (array)$data);
	}
	
	
	
	
	/**
	 * Получить данные для секции админки
	 * @param название секции
	 * @param параметры
	 * @return array
	 */
	public function getDataToSection($section, $params = false) {
		$data = $this->admin_model->getSettings();
		$data['id'] = $section;
		
		switch ($section) {
			case 'common':
				$data['users_list_pay'] = $this->admin_model->getUsersListPay();
				$data['users_list_complaints'] = $this->admin_model->getUsersListComplaints();
				$data['users_list_more'] = false;
				break;
			
			case 'users':
				$usersData = $this->users_model->getUsers($params);
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanks();
				$data['roles'] = $this->admin_model->getRoles();
				$data['accounts_access'] = $this->admin_model->getAccountsAccess(false);
				$data['raiders_colors'] = $this->admin_model->getRaidersColors();
				$data['users'] = ['new' => [], 'verify' => [], 'deleted' => []];
				$data['deposit_users'] = [];
				$data['deposit'] = ['global' => 0, 'statics' => []];
				
				$usersStatics = [];
				
				if ($usersData) {
					foreach ($usersData as $user) {
						$user['rank'] = isset($data['ranks'][$user['rank']]) ? $data['ranks'][$user['rank']]['name'] : false;
						if ($user['verification'] == 0 && $user['deleted'] == 0) {
							$data['users']['new'][0][] = $user;
						} elseif ($user['verification'] == 1 && $user['deleted'] == 0) {
							$data['users']['verify'][$user['static']][] = $user;
						} elseif ($user['deleted'] == 1) {
							$data['users']['deleted'][$user['static'] ?: 0][] = $user;
						}
						
						if ($user['static'] && !in_array($user['static'], $usersStatics)) $usersStatics[$user['static']] = false;
					}
				}
				
				$data['statics'] = array_replace_recursive($usersStatics, $data['statics']);
				
				
				
				if ($uniqueUsersData = $this->users_model->getUsers(['where' => ['us.main' => 1]])) {
					foreach ($uniqueUsersData as $user) {
						$data['deposit_users'][$user['static'] ?: 0][] = [
							'id'		=> $user['id'],
							'nickname' 	=> $user['nickname'],
							'avatar' 	=> $user['avatar'],
							'payment' 	=> $user['payment'],
							'deposit' 	=> $user['deposit']
						];
						
						$data['deposit']['global'] += (float)$user['deposit'];
						
						if (!isset($data['deposit']['statics'][$user['static'] ?: 0])) $data['deposit']['statics'][$user['static'] ?: 0] = (float)$user['deposit'];
						else $data['deposit']['statics'][$user['static'] ?: 0] += (float)$user['deposit'];
					}
				}
				
				foreach ($data['deposit_users'] as $static => $users) $data['deposit_users'][$static] = sortUsers($users);
				
				
				$data['sort_field'] = isset($params['field']) ? $params['field'] : 'u.nickname';
				$data['sort_order'] = isset($params['order']) ? $params['order'] : 'ASC';
				break;
			
			case 'personages':
				$data['game_ids'] = $this->admin_model->personagesGetGameIds(true);
				$data['personages'] = $this->admin_model->personagesGet();
				break;
			
			case 'statics':
				$data['statics'] = $this->admin_model->getStatics();
				break;
				
			case 'ranks':
				$data['ranks'] = $this->admin_model->getRanks();
				break;
				
			case 'access_levels':
				$data['access_levels'] = $this->admin_model->getAccessLevels();
				break;
			
			case 'accounts_access':
				$data['accounts_access'] = $this->admin_model->getAccountsAccess();
				break;
				
			case 'roles':
				$data['roles'] = $this->admin_model->getRoles();
				break;
				
			case 'raids_types':
				$data['raids_types'] = $this->admin_model->getRaidsTypes();
				$data['keys_types'] = $this->admin_model->getKeysTypes();
				break;
				
			case 'offtime':
				$this->load->model('offtime_model');
				$data['statics'] = $this->admin_model->getStatics();
				$data['roles'] = $this->admin_model->getRoles();
				$data['roles_limits'] = $this->offtime_model->getRolesLimits();
				
				$startDatePoint = (date('l', time()) == 'Monday') ? strtotime('today') : strtotime('last monday');
				$data['offtime']['dates'] = getDatesRange($startDatePoint - 604800, 35, 'day');
				$data['offtime']['users'] = $this->offtime_model->getOfftimeUsers();
				$data['offtime']['disabled'] = $this->offtime_model->getOfftimeDisabled();
				$data['current_date'] = strtotime('today');
				break;
			
			case 'vacation':
				$this->load->model('vacation_model', 'vacationmodel');
				$data['statics'] = $this->admin_model->getStatics();
				
				$startDatePoint = (date('l', time()) == 'Monday') ? strtotime('today') : strtotime('last monday');
				$dates = getDatesRange(($startDatePoint + (86400 * (7 * 4))), (7 * 8)); // показывать начиная с 28 дней вперед, чтобы не перекрывать выходные
		
				foreach ($dates as $d) $data['dates_to_disabled'][$this->monthes2[date('n', $d)]][] = $d;
				$data['disabled_days'] = $this->vacationmodel->getDisabledDays();
				
				$data['ranks'] = $this->admin_model->getRanks(true);
				$data['settings'] = $this->vacationmodel->getSettings(false, false);
				break;
				
			case 'newsfeed':
				$data['statics'] = $this->admin_model->getStatics(true);
				$data['feed_messages'] = $this->admin_model->getFeedMessages();
				break;
			
			case 'operators':
				$data['operators'] = $this->admin_model->getOperators();
				$data['current_date'] = strtotime('today');
				$data['week'] = $this->week;
				
				
				$startDatePoint = (date('l', time()) == 'Monday') ? strtotime('today') : strtotime('last monday');
				$dates = getDatesRange($startDatePoint, 28, 'day');
				$hourssheet = $this->admin_model->getOperatorsHourssheet($dates[0], $dates[count($dates) - 1]);
				
				$data['hourssheet'] = [];
				foreach ($data['operators'] as $oId => $oData) {
					$data['hourssheet'][$oId]['name'] = $oData['nickname'] ?: $oData['login'];
					$data['hourssheet'][$oId]['dates'] = isset($hourssheet[$oId]) ? array_replace_recursive(array_flip($dates), $hourssheet[$oId]) : array_flip($dates);
				}
				break;
			
			case 'reports':
				//$this->load->model('reports_model');
				$data['payment_requests_list'] = []; $paymentRequestsList = false;
				if ($getPaymentRequests = $this->reports_model->getPaymentRequests($params)) {
					$statics = $this->admin_model->getStatics();
					$paymentRequestsList = array_map(function($item) use ($statics) {
						$item['static_name'] = isset($statics[$item['static']]) ? $statics[$item['static']]['name'] : null;
						$item['static_icon'] = isset($statics[$item['static']]) ? $statics[$item['static']]['icon'] : null;
						unset($item['static']);
						return $item;
					}, $getPaymentRequests);
				}
				
				if ($paymentRequestsList) {
					foreach ($paymentRequestsList as $item) {
						$paid = $item['paid'] == 0 ? 'nopaid' : 'paid';
						$data['payment_requests_list'][$paid][] = $item;
					}
					$data['payment_requests_list']['paid'] = isset($data['payment_requests_list']['paid']) ? array_slice($data['payment_requests_list']['paid'], 0, 100) : false;
					$data['payment_requests_titles'] = ['nopaid' => 'Не рассчитаны', 'paid' => 'Рассчитаны'];
				}
				break;
			
			case 'guides':
				$data['chapters'] = $this->getGuideChapters();
				break;
			
			case 'statistics':
				$usersData = $this->users_model->getUsers($params);
				$data['statics'] = $this->admin_model->getStatics();
				$data['users'] = ['new' => [], 'verify' => [], 'deleted' => []];
				
				if ($usersData) {
					foreach ($usersData as $user) {
						$userCash = (float)$user['statistics_cash'];
						$userdays = (float)$user['statistics_days'];
						$user['pay'] = ((float)$userCash != 0 && (float)$userdays != 0) ? (float)$userCash / (float)$userdays * 30.437 : false;
						
						if ($user['verification'] == 0 && $user['deleted'] == 0) {
							$data['users']['new'][$user['static']][] = $user;
						} elseif ($user['verification'] == 1 && $user['deleted'] == 0) {
							$data['users']['verify'][$user['static']][] = $user;
						} elseif ($user['deleted'] == 1) {
							$data['users']['deleted'][$user['static']][] = $user;
						}
					}
				}
				
				$data['sort_field'] = isset($params['field']) ? $params['field'] : 'u.nickname';
				$data['sort_order'] = isset($params['order']) ? $params['order'] : 'ASC';
				break;
			
			case 'statistics_settings':
				$data['statics'] = $this->admin_model->getStatics();
				
				break;
		}
		
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------- Предложения и жалобы, заказ оплаты
	
	
	public function add_pay_item() {
		echo $this->admin_model->addPayItem($this->input->post());
	}
	
	public function add_complaints_item() {
		echo $this->admin_model->addComplaintsItem($this->input->post());
	}
	
	
	
	public function delete_pay_field() {
		$fields_pay_setting = $this->admin_model->getSettings('fields_pay_setting');
		unset($fields_pay_setting[$this->input->post('index')]);
		$fields_pay_setting = array_values($fields_pay_setting);
		echo $this->admin_model->setSetting('fields_pay_setting', $fields_pay_setting);
	}
	
	public function delete_complaints_field() {
		$fields_complaints_setting = $this->admin_model->getSettings('fields_complaints_setting');
		unset($fields_complaints_setting[$this->input->post('index')]);
		$fields_complaints_setting = array_values($fields_complaints_setting);
		echo $this->admin_model->setSetting('fields_complaints_setting', $fields_complaints_setting);
	}
	
	
	
	public function set_pay_field_stat() {
		echo $this->admin_model->setPayItemStat($this->input->post());
	}
	
	public function set_complaints_field_stat() {
		echo $this->admin_model->setComplaintsItemStat($this->input->post());
	}
	
	
	public function get_pay_list_more() {
		$data['fields_pay_setting'] = $this->admin_model->getSettings('fields_pay_setting');
		$data['users_list_pay'] = $this->admin_model->getPayListMore($this->input->post('offset'));
		echo json_encode($data);
	}
	
	public function get_complaints_list_more() {
		$data['fields_complaints_setting'] = $this->admin_model->getSettings('fields_complaints_setting');
		$data['users_list_complaints'] = $this->admin_model->getComplaintsListMore($this->input->post('offset'));
		echo json_encode($data);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-----------------------------------------------------------------------------------------------------------------
	
	/**
	 * Обновить данные верифицированных пользователей
	 * @param 
	 * @return 
	 */
	public function set_users_data() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post('users'));
		echo $this->users_model->setUsersData($postData);
	}
	
	
	
	/**
	 * Обновить бухгалтерию верифицированных пользователей
	 * @param 
	 * @return 
	 */
	public function set_users_accounting() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post('users'));
		echo $this->users_model->setUsersAccounting($postData);
	}
	
	
	
	
	
	
	
	/**
	 * Обновить данные пользователя
	 * @param 
	 * @return 
	 */
	public function set_user_data() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		echo $this->users_model->setUserData($postData, $postData['verification']);
	}
	
	
	
	/**
	 * Задать статистику пользователей
	 * @param 
	 * @return 
	 */
	public function set_users_stat() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post('users'));
		echo $this->users_model->setUsersStat($postData);
	}
	
	
	
	
	/**
	 * Задать статики пользователя
	 * @param 
	 * @return 
	 */
	public function set_user_statics() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		echo $this->users_model->setUserStatics($postData['user_id'], $postData['user_statics']);
	}
	
	
	
	
	/**
	 * Пометить пользователя как "удален"
	 * @param 
	 * @return 
	 */
	public function delete_user() {
		if (! $this->input->is_ajax_request()) return false;
		$userId = $this->input->post('id');
		echo $this->users_model->deleteUser($userId);
	}
	
	
	
	
	/**
	 * Обновить Резерв пользователей
	 * @param 
	 * @return 
	 */
	public function deposit_update() {
		if (! $this->input->is_ajax_request()) return false;
		$depositData = $this->input->post('deposit');
		if ($this->users_model->depositUpdate($depositData)) echo 1;
		echo 0;
	}
	
	
	
	
	
	
	public function statics_add() {
		if (!$this->input->is_ajax_request()) return false;
		if (!$staticsData = $this->input->post('statics')) exit('0');
		
		$statics = array_filter($staticsData, function($val) {return isset($val['name']) && $val['name'] != '';});
		$statics = array_map(function($item) {
			$item['stopstage'] = isset($item['stopstage']) ? $item['stopstage'] : 0;
			$item['cap_simple'] = str_replace(' ', '', $item['cap_simple']);
			$item['cap_lider'] = str_replace(' ', '', $item['cap_lider']);
			return $item;
		}, $statics);
		
		if ($this->admin_model->addStatics(bringTypes($statics))) exit('1');
		echo 0;
	}
	
	public function statics_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeStatics($id);
	}
	
	
	
	
	
	
	
	
	public function raiders_colors_add() {
		if (!$this->input->is_ajax_request()) return false;
		if (!$this->input->post('raiders_colors')) exit('0');
		$raidesColors = array_filter($this->input->post('raiders_colors'), function($val) {return isset($val['name']) && $val['name'] != '';});
		if ($this->admin_model->addRaidesColors(bringTypes($raidesColors))) exit('1');
		echo 0;
	}
	
	public function raiders_colors_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeRaidesColors($id);
	}
	
	
	
	
	
	
	
	
	
	public function ranks_add() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = array_filter($this->input->post('ranks'), function($val) {return $val['name'] != '';});
		echo $this->admin_model->addRanks(bringTypes($postData));
	}
	
	public function ranks_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeRanks($id);
	}
	
	
	
	
	public function roles_add() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = array_filter($this->input->post('roles'), function($val) {return $val['name'] != '';});
		echo $this->admin_model->addRoles(bringTypes($postData));
	}
	
	public function roles_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeRoles($id);
	}
	
	
	
	
	public function access_levels_add() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = array_filter($this->input->post('access_levels'), function($val) {return $val['name'] != '';});
		echo $this->admin_model->addAccessLevels(bringTypes($postData));
	}
	
	public function access_levels_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeAccessLevels($id);
	}
	
	
	
	
	
	public function accounts_access_add() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post('accounts_access');
		$postData = array_map(function($item) {
			if (isset($item['access'])) $item['access'] = json_encode($item['access']);
			return $item;
		}, $postData);
		echo $this->admin_model->addAccountsAccess(bringTypes($postData));
	}
	
	public function accounts_access_remove() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeAccountsAccess($id);
	}
	
	
	
	
	
	
	public function raids_types_add() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = array_filter($this->input->post('raids_types'), function($val) {return $val['name'] != '';});
		echo $this->admin_model->addRaidsTypes(bringTypes($postData));
	}
	
	public function raids_types_remove() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeRaidsTypes($id);
	}
	
	
	
	
	public function keys_types_add() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = array_filter($this->input->post('keys_types'), function($val) {return $val['name'] != '';});
		echo $this->admin_model->addKeysTypes(bringTypes($postData));
	}
	
	public function keys_types_remove() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeKeysTypes($id);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Лента новостей
	
	/**
	 * Добавить бланк для новой новости
	 * @param 
	 * @return 
	 */
	public function feed_message_add() {
		$staticId = $this->input->post('static_id');
		echo $this->twig->render($this->viewsPath.'render/feed_messages_add', ['static_id' => $staticId, 'statics' => $this->admin_model->getStatics(true)]);
	}
	
	
	
	/**
	 * Сохранить новость
	 * @param POST
	 * @return время публикации
	 */
	public function save_feed_message() {
		$data = $this->input->post();
		$response = $this->admin_model->saveFeedMessage($data);
		$month = $this->monthes[date('n', $response['date'])];
		$response['date'] = date('j', $response['date']).' '.$month.' '.date('Y', $response['date']).' г. '.date('H:i', $response['date']);
		echo json_encode($response);
	}
	
	
	
	/**
	 * Обновить новость
	 * @param POST
	 * @return статус
	 */
	public function update_feed_message() {
		$data = $this->input->post();
		echo json_encode($this->admin_model->updateFeedMessage($data));
	}
	
	
	
	/**
	 * Удалить новость
	 * @param ID новости
	 * @return статус
	 */
	public function remove_feed_message() {
		$id = $this->input->post('id');
		echo json_encode($this->admin_model->removeFeedMessage($id));
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Статики участника
	
	/**
	 * Получить список статиков участника
	 * @param ID пользователя
	 * @return HTML
	 */
	public function get_users_statics() {
		$userId = $this->input->post('user_id');
		$newSet = $this->input->post('newset');
		$userStatics = $this->users_model->getUsersStatics($userId);
		echo $this->twig->render($this->viewsPath.'render/user_statics', ['statics' => $userStatics, 'newset' => $newSet]);
	}
	
	
	
	
	/**
	 * Задать уровень доступа по-умолчанию
	 * @param 
	 * @return 
	 */
	public function set_users_access() {
		$id = $this->input->post('id');
		if (!$id) exit('0');
		if (!$this->users_model->setUsersAccess($id)) exit('0');
		$this->admin_model->setSetting('default_access_setting', $id);
		echo '1';
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Операторы
	
	public function operators_add() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = array_filter($this->input->post('operators'), function($val) {return ($val['login'] != '' || $val['password'] != '');});
		echo $this->admin_model->addOperators($postData);
	}
	
	public function operators_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeOperators($id);
	}
	
	
	
	
	
	/**
	 * Получить список статиков для разрешения
	 * @param 
	 * @return 
	 */
	public function get_operator_statics() {
		if (!$this->input->is_ajax_request()) return false;
		$hasStatics = $this->input->post('has_statics');
		$statics = $this->admin_model->getStatics(true);
		echo $this->twig->render($this->viewsPath.'render/operators_statics', ['statics' => $statics, 'has_statics' => $hasStatics]);
	}
	
	
	/**
	 * Получить список статиков для разрешения
	 * @param 
	 * @return 
	 */
	public function get_operator_access() {
		if (!$this->input->is_ajax_request()) return false;
		$hasAccess = $this->input->post('has_access');
		echo $this->twig->render($this->viewsPath.'render/operators_access', ['access' => $this->dataAccess, 'has_access' => $hasAccess]);
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get_operator_hourssheet() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		$startDatePoint = (date('l', time()) == 'Monday') ? strtotime('today') : strtotime('last monday');
		$dates = getDatesRange($startDatePoint, 28, 'day');
		$week = $this->weekShort;
		$hourssheet = $this->admin_model->getOperatorHourssheet($data['operator_id'], $data['date']);
		
		$output = [
			'hourssheet'	=> $hourssheet,
			'minutes' 		=> $this->minutes,
			'date' 			=> $data['date'],
			'dates' 		=> $dates,
			'week' 			=> $week,
			'current_date'	=> strtotime('today')
		];
		
		echo $this->twig->render($this->viewsPath.'render/operators_hourssheet', $output);
	}
	
	
	
	
	
	
	/**
	 * Добавить новую строку
	 * @param 
	 * @return 
	 */
	public function operators_hourssheet_add() {
		if (!$this->input->is_ajax_request()) return false;
		$index = $this->input->post('index');
		echo $this->twig->render($this->viewsPath.'render/operators_hourssheet_add', ['index' => $index, 'minutes' => $this->minutes]);
	}
	
	
	
	
	
	
	/**
	 * Сохранить часы работы оператора
	 * @param 
	 * @return 
	 */
	public function operators_hourssheet_save() {
		$data = $this->input->post();
		$this->admin_model->operatorsHourssheetSave($data);
		echo 1;
	}
	
	
	
	/**
	 * Удалить часы работы оператора
	 * @param 
	 * @return 
	 */
	public function operators_hourssheet_delete() {
		$id = $this->input->post('id');
		$this->admin_model->operatorsHourssheetDelete($id);
		echo 1;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Образование
	
	
	
	/**
	 * Получить список разделов
	 * @param 
	 * @return 
	 */
	public function getGuideChapters() {
		if (!$firstData = $this->admin_model->getGuideChapters()) return false;
		foreach ($firstData as $fkey => $first) {
			if (!$secondData = $this->admin_model->getGuideChapters($first['id'])) continue;
			foreach ($secondData as $skey => $second) {
				if (!$thirdData = $this->admin_model->getGuideChapters($second['id'])) continue;
				foreach ($thirdData as $tkey => $third) {
					if (!$forthData = $this->admin_model->getGuideChapters($third['id'])) continue;
					$thirdData[$tkey]['children'] = $forthData;
				}
				$secondData[$skey]['children'] = $thirdData;
			}
			$firstData[$fkey]['children'] = $secondData;
		}
		return $firstData;	
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get_guide_chapter() {
		$id = $this->input->post('id');
		$data = $this->admin_model->getGuideChapter($id);
		echo $this->twig->render($this->viewsPath.'render/guide_chapters_edit', $data);
	}
	
	
	
	
	/**
	 * Новый раздел
	 * @param 
	 * @return 
	 */
	public function guide_chapters_new() {
		$toOperator = $this->input->post('to_operator');
		if ($toOperator) echo $this->twig->render('views/operator/render/guide_chapter', ['chapters' => $this->getGuideChapters()]);
		else echo $this->twig->render($this->viewsPath.'render/guide_chapter', ['chapters' => $this->getGuideChapters()]);
	}
	
	
	
	/**
	 * Редактировать раздел
	 * @param 
	 * @return 
	 */
	public function guide_chapters_edit() {
		$id = $this->input->post('id');
		$toOperator = $this->input->post('to_operator');
		$data = $this->admin_model->getGuideChapter($id);
		if ($toOperator) echo $this->twig->render('views/operator/render/guide_chapter', array_merge($data, ['chapters' => $this->getGuideChapters()]));
		else echo $this->twig->render($this->viewsPath.'render/guide_chapter', array_merge($data, ['chapters' => $this->getGuideChapters()]));
	}
	
	
	
	
	
	/**
	 * Сохранить раздел
	 * @param 
	 * @return 
	 */
	public function guide_chapter_save() {
		$data = $this->input->post();
		$this->admin_model->guideChaptersSave($data);
		echo 1;
	}
	
	
	
	
	
	/**
	 * Удалить раздел
	 * @param 
	 * @return 
	 */
	public function guide_chapter_delete() {
		$id = $this->input->post('id');
		echo $this->admin_model->guideChapterDelete($id);
	}
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Персонажи
	
	/**
	 * @param get add save update remove
	 * @return 
	 */
	public function personages($action = false) {
		$postData = bringTypes($this->input->post());
		switch ($action) {
			case 'get':
				$gameId = isset($postData['game_id']) ? $postData['game_id'] : false;
				$fromId = isset($postData['from_id']) ? $postData['from_id'] : false;
				$popup = isset($postData['popup']) ? $postData['popup'] : false;
				$usersList = isset($postData['users_list']) ? $postData['users_list'] : false;
				
				$personages = $this->admin_model->personagesGetByGameId($gameId, $fromId);
				if ($popup) echo $this->twig->render($this->viewsPath.'render/personages/list_popup', ['personages' => $personages, 'game_id' => $gameId]);
				elseif ($usersList)  echo $this->twig->render($this->viewsPath.'render/personages/list_to_users', ['personages' => $personages]);
				else echo $this->twig->render($this->viewsPath.'render/personages/list', ['personages' => $personages, 'game_id' => $gameId]);
				break;
			
			case 'save':
				if ($this->admin_model->personagesSave($postData['personages'])) {
					echo '1';
				} else echo '0';
				break;
			
			case 'remove':
				if ($this->admin_model->personagesRemove($postData['id'])) {
					echo '1';
				} else echo '0';
				break;
			
			case 'untie':
				if ($this->admin_model->personagesUntie($postData['id'])) {
					echo '1';
				} else echo '0';
				break;
			
			case 'get_form':
				echo $this->twig->render($this->viewsPath.'render/personages/form', ['game_id' => $postData['game_id']]);
				break;
			
			case 'save_form':
				if ($insertId = $this->admin_model->personagesSaveForm($postData)) {
					echo $insertId;
				} else echo '0';
				break;
				
			default:
				echo '';
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- ID игр
	
	/**
	 * @param get add save update remove
	 * @return 
	 */
	public function game_ids($action = false) {
		$postData = bringTypes($this->input->post());
		switch ($action) {
			case 'get':
				$gameIds = $this->admin_model->gameIdsGet($postData);
				echo $this->twig->render($this->viewsPath.'render/game_ids/list', ['game_ids' => $gameIds]);
				break;
			
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/game_ids/new');
				break;
			
			case 'save':
				$fields = $postData['fields'];
				$fieldsToItem = $postData['fields_to_item'];
				$dateAdd = time();
				$fields['date_add'] = $dateAdd;
				if ($insertId = $this->admin_model->gameIdSave($fields)) {
					$fieldsToItem['id'] = $insertId;
					$fieldsToItem['date_add'] = $dateAdd;
					echo $this->twig->render('views/admin/render/game_ids/saved.tpl', $fieldsToItem);
				} else echo '0';
				break;
			
			case 'update':
				$id = $postData['id'];
				$fields = $postData['fields'];
				if ($this->admin_model->gameIdUpdate($id, $fields)) echo 1;
				else echo '0';
				break;
			
			case 'remove':
				$id = $postData['id'];
				if ($this->admin_model->gameIdRemove($id, true)) {
					echo '1';
				} else echo '0'; 
				break;
			
			case 'get_users_to_game':
				if ($query = $postData['query']) {
					$params = [
						'where' => ['us.main' => 1, 'u.deleted !=' => 1, 'u.verification !=' => 0],
						'like' 	=> ['field' => 'u.nickname', 'value' => $query, 'placed' => 'both'],
					];
				} else {
					$params = ['where' => ['us.main' => 1, 'u.deleted !=' => 1, 'u.verification !=' => 0]];
				}
				
				
				if ($postData['tied_user']) $params['where']['u.id !='] = $postData['tied_user'];
				
				if ($usersQuery = $this->users_model->getUsers($params)) {
					$statics = $this->admin_model->getStatics();
					$tiedUsers = $this->admin_model->gameIdsGetTiedUsers() ?: [];
					$usersData = [];
					foreach ($usersQuery as $user) {
						$usersData[] = [
							'id' 			=> $user['id'],
							'avatar' 		=> $user['avatar'],
							'nickname' 		=> $user['nickname'],
							'static_name'	=> isset($statics[$user['static']]) ? $statics[$user['static']]['name'] : false,
							'static_icon'	=> isset($statics[$user['static']]) ? $statics[$user['static']]['icon'] : false,
							'tied'			=> in_array($user['id'], $tiedUsers) ? true : false
						];
					}
					echo $this->twig->render('views/admin/render/game_ids/users_list.tpl', ['users' => $usersData]);
				} else echo '';
				break;
			
			case 'untie_user_to_game':
				if ($this->admin_model->gameIdUntieUser($postData['game_id'])) echo 1;
				else echo '0';
				break;
			
			case 'tie_personages_to_game_id':
				if ($this->admin_model->gameIdTiePersonages($postData['game_id'], $postData['personages_ids'])) echo 1;
				else echo '0';
				break;
			
			default:
				echo '';
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Статистика
	/**
	 * @param 
	 * @return 
	 */
	public function statistics_get_users() {
		$staticId = $this->input->post('static_id');
		$usersData = $this->users_model->getUsers(['where' => ['us.static_id' => $staticId, 'u.statistics_cash !=' => 0, 'u.statistics_days !=' => 0]]);
		echo $this->twig->render($this->viewsPath.'render/statistics_users', ['users' => $usersData]);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Заявки на оплату
	
	/**
	 * @param get add save update remove
	 * @return 
	 */
	public function paymentrequests($action = false) {
		$postData = bringTypes($this->input->post());
		switch ($action) {
			case 'main':
				echo $this->twig->render('views/admin/render/payment_requests/main.tpl');
				break;
			
			case 'get':
				$templates = $this->admin_model->paymentRequestsGet();
				echo $this->twig->render('views/admin/render/payment_requests/templates.tpl', ['templates' => $templates]);
				break;
			
			case 'add':
				echo $this->twig->render('views/admin/render/payment_requests/new.tpl');
				break;
			
			case 'save':
				$fields = $postData['fields'];
				$fieldsToItem = $postData['fields_to_item'];
				if ($insertId = $this->admin_model->paymentRequestsSave($fields)) {
					$fieldsToItem['id'] = $insertId;
					echo $this->twig->render('views/admin/render/payment_requests/saved.tpl', $fieldsToItem);
				} else echo '0';
				break;
			
			case 'update':
				$id = $postData['id'];
				$fields = $postData['fields'];
				if ($this->admin_model->paymentRequestsUpdate($id, $fields)) echo 1;
				else echo '0';
				break;
			
			case 'remove':
				$id = $postData['id'];
				if ($this->admin_model->paymentRequestsRemove($id)) {
					echo '1';
				} else echo '0'; 
				break;
			
			case 'get_users':
				$users = $this->users_model->getUsers(['where' => ['us.main' => 1, 'u.deleted' => 0, 'u.verification' => 1]]);
				$pRData = $this->admin_model->paymentRequestsGetData($postData['pr_id']);
				$statics = $this->admin_model->getStatics();
				$choosedUsers = $pRData ? array_column($pRData, 'user_id') : [];
				$usersData = [];
				foreach ($users as $user) {
					$usersData[] = [
						'id' 			=> $user['id'],
						'avatar' 		=> $user['avatar'],
						'nickname' 		=> $user['nickname'],
						'static_name'	=> isset($statics[$user['static']]) ? $statics[$user['static']]['name'] : false,
						'static_icon'	=> isset($statics[$user['static']]) ? $statics[$user['static']]['icon'] : false,
						'choosed'		=> $choosedUsers ? in_array($user['id'], $choosedUsers) : false
					];
				}
				
				echo $this->twig->render('views/admin/render/payment_requests/template_list.tpl', ['users' => setArrKeyFromField($usersData, 'id', true), 'choosed_users' => $pRData]);
				break;
			
			case 'find_users':
				if ($query = $postData['query']) {
					$params = [
						'where' => ['us.main' => 1, 'u.deleted !=' => 1, 'u.verification !=' => 0],
						'like' 	=> ['field' => 'u.nickname', 'value' => $query, 'placed' => 'both'],
					];
				} else {
					$params = ['where' => ['us.main' => 1, 'u.deleted !=' => 1, 'u.verification !=' => 0]];
				}
				
				if ($usersQuery = $this->users_model->getUsers($params)) {
					$statics = $this->admin_model->getStatics();
					$usersData = [];
					foreach ($usersQuery as $user) {
						$usersData[] = [
							'id' 			=> $user['id'],
							'avatar' 		=> $user['avatar'],
							'nickname' 		=> $user['nickname'],
							'static_name'	=> isset($statics[$user['static']]) ? $statics[$user['static']]['name'] : false,
							'static_icon'	=> isset($statics[$user['static']]) ? $statics[$user['static']]['icon'] : false,
							'choosed'		=> isset($postData['choosed']) ? in_array($user['id'], (array)$postData['choosed']) : false
						];
					}
					echo $this->twig->render('views/admin/render/payment_requests/users_list.tpl', ['users' => $usersData]);
				} else echo '';
				break;
			
			case 'save_temp_data':
				if (!$this->admin_model->paymentRequestsSaveTempData($postData['pr_id'], $postData['data'])) exit('0');
				echo '1';
				break;
			
			case 'set_checkout':
				$data = $postData['data'];
				$usersIds = array_column($data, 'user_id') ?: [];
				$this->load->model('users_model');
				$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds]]);
				$usersData = setArrKeyFromField($usersData, 'id', true);
				
				$orders = [];
				foreach ($data as $item) {
					$orders[] = [
						'user_id'	=> $item['user_id'],
						'nickname' 	=> $usersData[$item['user_id']]['nickname'],
						'avatar' 	=> $usersData[$item['user_id']]['avatar'],
						'payment' 	=> $usersData[$item['user_id']]['payment'],
						'static' 	=> $usersData[$item['user_id']]['static'],
						'order' 	=> $item['order'],
						'summ' 		=> $item['summ'],
						'comment' 	=> $item['comment'],
						'date'		=> time()
					];
				}

				if (!$this->reports_model->insertUsersOrders($orders)) exit('0');
				echo json_encode('1');
				break;
			
			default:
				echo '';
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}