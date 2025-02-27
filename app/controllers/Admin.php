<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Admin extends MY_Controller {
	
	public $viewsPath = 'views/admin/';
	private $adminId = false;
	private $adminPermissions = false;
	
	public function __construct() {
		parent::__construct();
		$this->load->model(['admin_model', 'reports_model', 'users_model']);
		
		if (get_cookie('slaveadmin')) {
			$this->adminId = decrypt(get_cookie('token'));
			
			if ($admins = $this->admin_model->admins('get')) {
				$adminsIds = array_column($admins, 'id');
				$admins = setArrKeyfromField($admins, 'id');
			}
			
			if ($this->adminId && !isset($admins[$this->adminId])) $this->logout();
			
			$this->adminPermissions = isset($admins[$this->adminId]) ? explode(',', $admins[$this->adminId]['permissions']) : [];
			
			if (!in_array($this->adminId, $adminsIds)) $this->logout();
		} else {
			$token = $this->admin_model->getSettings('token');
			$sesToken = get_cookie('token');
			if ($token != $sesToken && get_cookie('token')) $this->logout();
		}
	}
	
	
	
	public function index() {
		if (get_cookie('token') == false) {
			$this->auth();
		} else {
			if ($this->adminId) {
				
				$sectionsData  = [];
				foreach ($this->adminSections as $sectionTitle => $sectionsList) foreach ($sectionsList as $url => $title) {
					if (in_array($url, $this->adminPermissions)) $sectionsData[$sectionTitle][$url] = $title;
				}
				$data['sections'] = $sectionsData;
			} else {
				$data['sections'] = $this->adminSections;
			}
			
			$data['date'] = date('Y');
			
			$data['svg_sparite'] = getSprite('public/svg/sprite.svg'); // вставляем SVG спрайт
			$this->twig->display($this->viewsPath.'index', $data);
		}
	}
	
	
	
	
	/**
	 * Авторизация в админке
	 * @param 
	 * @return 
	 */
	private function auth() {
		$method = $this->input->server('REQUEST_METHOD');
		$login = $this->input->post('login');
		$password = $this->input->post('password');
		$admins = $this->admin_model->admins('get');
		
		if ($method == 'POST' && !empty($login) && !empty($password)) {
			if (in_array($login, array_column($admins, 'nickname'))) {
				$index = getIndexFromFieldValue($admins, 'nickname', $login);
				set_cookie('token', encrypt($admins[$index]['id']), 31536000);
				set_cookie('slaveadmin', 1, 31536000);
				redirect('admin');
			} else {
				$token = $this->admin_model->getSettings('token');
				if ($token == md5($login.$password)) {
					set_cookie('token', $token, 31536000);
					redirect('admin');
				} else {
					$this->twig->display($this->viewsPath.'auth', ['error' => true]);
				}
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
		delete_cookie('token');
		delete_cookie('slaveadmin');
		redirect('admin');
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Администраторы
	 * @param 
	 * @return 
	*/
	public function admins($action = false) {
		if (!$action) return false;
		$post = $this->input->post();
		
		switch ($action) {
			case 'get':
				$data['list'] = $this->admin_model->admins('get');
				echo $this->twig->render($this->viewsPath.'render/admins/list', $data);
				break;
			
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/admins/item');
				break;
			
			case 'save':
				$fieldsToItem = $post['fields'];
				if (!$insertId = $this->admin_model->admins('save', $post['fields'])) exit('0');
				$fieldsToItem['id'] = $insertId;
				echo $this->twig->render($this->viewsPath.'render/admins/item.tpl', $fieldsToItem);
				break;
			
			case 'update':
				if (!$this->admin_model->admins('update', $post)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->admin_model->admins('remove', $post)) exit('0');
				echo '1';
				break;
			
			case 'permissions':
				$data['sections'] = $this->adminSections;
				$data['permissions'] = $post['permissions'];
				echo $this->twig->render($this->viewsPath.'render/admins/permissions', $data);
				break;
			
			default: break;
		}
		
	}
	
	
	
	
	
	
	
	/**
	 * Операции дминистраторов
	 * @param 
	 * @return 
	*/
	public function adminsactions($action = false) {
		if (!$action) return false;
		$post = $this->input->post();
		
		switch ($action) {
			case 'all':
				$list = $this->admin_model->adminsactions('all', $post);
				$data['admins'] = setArrKeyFromField($this->admin_model->admins('get'), 'id');
				$data['admins'][0]['nickname'] = 'Главный администратор';
				$data['types'] = $this->adminActions;
				
				$finalData = [];
				if ($list) {
					foreach ($list as $k => $item) {
						$type = $item['type'];
						$info = arrTakeItem($item, 'info');
						
						switch ($type) {
							case '1': // Изменение статиков участника
								$ranks = $this->admin_model->getRanks();
								$userData = $this->users_model->getUsers(['where' => ['u.id' => $info['user_id'], 'us.main' => 1], 'fields' => 'avatar nickname static_name static_icon rank']);
								$userData = $userData ? reset($userData) : false;
								$userData['rank'] = is_array($userData) && isset($ranks[$userData['rank']]['name']) ? $ranks[$userData['rank']]['name'] : false;
								$list[$k]['user'] = isset($userData) ? $userData : false;
								
								$allStatics = []; $staticsIds = [];
								foreach ($info['statics'] as $period => $statics) {
									if ($statics) {
										foreach ($statics as $static) {
											$allStatics[$period][$static['static_id']] = [
												'main'	=> $static['main'],
												'lider' => $static['lider']
											];
											$staticsIds[] = $static['static_id'];
										}
									} else {
										$allStatics[$period] = null;
									}
								}
								
								$list[$k]['periods'] = ['before' => 'До', 'after' => 'После'];
								$list[$k]['statics_data'] = $this->admin_model->getStatics(false, array_unique($staticsIds));
								$list[$k]['statics'] = $allStatics;
								break;
							
							case '2': // Исключение/возврат исключенного участника
								$ranks = $this->admin_model->getRanks();
								$userData = $this->users_model->getUsers(['where' => ['u.id' => $info['user_id'], 'us.main' => 1], 'fields' => 'avatar nickname static_name static_icon rank']);
								$userData = $userData ? reset($userData) : false;
								$userData['rank'] = is_array($userData) && isset($ranks[$userData['rank']]['name']) ? $ranks[$userData['rank']]['name'] : false;
								
								$list[$k]['user'] = $userData;
								$list[$k]['stat'] = $info['stat'];
								break;
							
							case '3': // Удаление/возврат удаленного участника
								$ranks = $this->admin_model->getRanks();
								$userData = $this->users_model->getUsers(['where' => ['u.id' => $info['user_id'], 'us.main' => 1], 'fields' => 'avatar nickname static_name static_icon rank']);
								$userData = $userData ? reset($userData) : false;
								$userData['rank'] = is_array($userData) && isset($ranks[$userData['rank']]['name']) ? $ranks[$userData['rank']]['name'] : false;
								
								$list[$k]['user'] = $userData;
								$list[$k]['stat'] = $info['stat'];
								break;
							
							case '4': // Изменение платежных данных участника
								$usersIds = array_column($info, 'user_id');
								$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'avatar nickname static_name static_icon rank']);
								
								$list[$k]['ranks'] = $this->admin_model->getRanks();
								$list[$k]['users_data'] = $usersData;
								$list[$k]['users'] = setArrKeyfromField($info, 'user_id');
								break;
							
							case '5': // Создание/удаление заявок на оплату
								$payRequestTypes = [
									'simple' 			=> 'Новая заявка на оплату', // [type, order, users]
									'template' 			=> 'Новая заявка из шаблона ', // [type, title, users]
									'salary_orders' 	=> 'Расчет окладов', // [type, order, users]
									'addictpay_orders' 	=> 'Дополнительные выплаты', // [type, order, users]
									'remove' 			=> 'Удаление заявки на оплату', // [type, order, user_id]
									'raidliders_orders' => 'Выплаты рейд-лидерам' // [type, order, users]
								];
								
								
								if (isset($info['users']) && $info['users']){
									$usersIds = array_column($info['users'], 'user_id');
									$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'avatar nickname static_name static_icon rank payment']);
									
									$list[$k]['ranks'] = $this->admin_model->getRanks();
									$list[$k]['users'] = $info['users'];
									$list[$k]['users_data'] = $usersData;
								}
								
								
								if (in_array($info['type'], ['simple', 'salary_orders', 'addictpay_orders', 'raidliders_orders'])) {
									$list[$k]['info'] = 'Номер заказа: <strong>'.$info['order'].'</strong>';
								
								} elseif ($info['type'] == 'template') {
									$list[$k]['info'] = 'Шаблон: '.$info['title'];
								
								} elseif ($info['type'] == 'remove') {
									$ranks = $this->admin_model->getRanks();
									$userData = $this->users_model->getUsers(['where' => ['u.id' => $info['user_id'], 'us.main' => 1], 'fields' => 'avatar nickname static_name static_icon rank']);
									$userData = $userData ? reset($userData) : false;
									$userData['rank'] = is_array($userData) && isset($ranks[$userData['rank']]['name']) ? $ranks[$userData['rank']]['name'] : false;
									
									$list[$k]['info'] = 'Номер заказа: <strong>'.$info['order'].'</strong>';
									$list[$k]['user'] = $userData;
								}
								
								
								$list[$k]['pr_type'] = $info['type'];
								$list[$k]['pr_types_names'] = $payRequestTypes;
								break;
							
							case '6': // Начисление/списание резерва, изменение плат. данных
								$userId = arrTakeItem($info, 'user_id');
								$list[$k] = array_merge($list[$k], $info);
								
								$ranks = $this->admin_model->getRanks();
								$userData = $this->users_model->getUsers(['where' => ['u.id' => $userId, 'us.main' => 1], 'fields' => 'avatar nickname static_name static_icon rank']);
								$userData = $userData ? reset($userData) : false;
								$userData['rank'] = is_array($userData) && isset($ranks[$userData['rank']]['name']) ? $ranks[$userData['rank']]['name'] : false;
									
								$list[$k]['user'] = $userData;
								break;
							
							case '7': // Списание баланса
								$usersIds = array_column($info['users'], 'user_id');
								$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'avatar nickname static_name static_icon rank payment']);
								
								$list[$k]['ranks'] = $this->admin_model->getRanks();
								$list[$k]['users'] = $info['users'];
								$list[$k]['users_data'] = $usersData;
								$list[$k]['total_summ'] = $info['total_summ'];
								break;
								
							default: break;
						}
						
						$date = date('Y-m-d', $item['date']);
						$finalData[$date][] = $list[$k];
					}
				}
				
				$data['list'] = $finalData;
				
				echo $this->twig->render($this->viewsPath.'render/adminsactions/list', $data);
				break;
			
			case 'dates':
				$data['dates'] = $this->admin_model->adminsactions('dates');
				echo $this->twig->render($this->viewsPath.'render/adminsactions/dates', $data);
				break;
			
			case 'admins':
				$data['admins'] = $this->admin_model->admins('get');
				echo $this->twig->render($this->viewsPath.'render/adminsactions/admins', $data);
				break;
			
			case 'actions':
				$data['actions'] = $this->adminActions;
				echo $this->twig->render($this->viewsPath.'render/adminsactions/actions', $data);
				break;
				
			case 'search_users':
				$this->load->model('users_model', 'users');
				$usersData = $this->users->getUsers(['like' => ['field' => 'u.nickname', 'value' => $post['string']], 'fields' => 'id nickname']);
				$usersList = setArrKeyfromField($usersData, 'id');
				$data['users'] = $usersList;
				echo $this->twig->render($this->viewsPath.'render/adminsactions/users', $data);
				break;
			
			
			
			default: break;
		}
		
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
		
		if (!$section) {
			if ($this->adminPermissions) {
				$sectionsData  = [];
				foreach ($this->adminSections as $sectionTitle => $sectionsList) foreach ($sectionsList as $url => $title) {
					if (in_array($url, $this->adminPermissions)) $sectionsData[$sectionTitle][$url] = $title;
				}
				$data['sections'] = $sectionsData;
			} else {
				$data['sections'] = $this->adminSections;
			}
				
			exit($this->twig->render($this->viewsPath.'empty.tpl', $data));
		} 
		
		if ($this->adminPermissions && !in_array($section, $this->adminPermissions)) exit($this->twig->render($this->viewsPath.'access_denied.tpl'));
		
		if (!$section || (!$data = $this->getDataToSection($section, $params))) exit('');
		$data['form'] = 'views/admin/form/';
		$data['date'] = date('Y');
		$data['main_admin'] = !$this->adminId;
		if ($this->adminId) $data['permissions'] = $this->adminPermissions;
		
		if (!file_exists('public/'.$this->viewsPath.'sections/'.$section.'.tpl')) exit('');
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
				$data['resigns'] = $this->admin_model->getResigns();
				$data['stop_list'] = $this->admin_model->getStopList();
				
				$data['statics'] = $this->admin_model->getStatics();
				if ($data['stop_list']['addictpay']) {
					$users = $this->users_model->getUsers([
						'where' 	=> ['us.main' => 1],
						'where_in' 	=> ['field' => 'u.id',
						'values' 	=> array_column($data['stop_list']['addictpay'], 'item_id')],
						'fields'	=> 'nickname avatar static_name static_icon'
					]);
					$data['users'] = $users;
				}
				break;
			
			case 'users':
				$usersData = $this->users_model->getUsers(array_replace_recursive((array)$params, ['where' => ['us.main' => 1]]));
				$newUsersData = $this->users_model->getUsers(array_replace_recursive((array)$params, ['where' => ['u.deleted' => 0, 'u.verification' => 0, 'u.excluded' => 0]]));
				$usersData = array_merge($usersData, $newUsersData);
				
				$usersAmounts = $this->users_model->getUsersAmounts();
				
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanks();
				$data['roles'] = $this->admin_model->getRoles();
				$data['classes'] = $this->admin_model->getClasses();
				$data['accounts_access'] = $this->admin_model->getAccountsAccess(false);
				$data['raiders_colors'] = $this->admin_model->getRaidersColors();
				$data['users'] = ['new' => [], 'verify' => [], 'excluded' => [], 'deleted' => []];
				$data['deposit_users'] = [];
				$data['deposit'] = ['global' => 0, 'statics' => []];
				$data['deposit_history'] = $this->admin_model->globalDepositHistoryGet();
				$data['balance'] = $this->admin_model->getBalance();
				$data['balance_history'] = $this->admin_model->getBalanceHistory();
				
				$usersStatics = [];
				
				if ($usersData) {
					foreach ($usersData as $user) {
						$user['rank'] = isset($data['ranks'][$user['rank']]) ? $data['ranks'][$user['rank']]['name'] : false;
						
						$user['amount'] = $usersAmounts[$user['id']]['amount'] ?? null;
						$user['cumulative'] = $usersAmounts[$user['id']]['cumulative'] ?? null;
						
						if (!isset($data['cumulative'][$user['static']])) $data['cumulative'][$user['static']] = 0;
						$data['cumulative'][$user['static']] += $usersAmounts[$user['id']]['cumulative'] ?? 0;
						
						//if (!isset($data['cumulative']['total'])) $data['cumulative']['total'] = 0;
						//$data['cumulative']['total'] += $usersAmounts[$user['id']]['cumulative'] ?? 0;
						
						if ($user['verification'] == 0 && $user['deleted'] == 0) {
							$data['users']['new'][0][] = $user;
						} elseif ($user['verification'] == 1 && $user['deleted'] == 0 && $user['excluded'] == 0) {
							$data['users']['verify'][$user['static']][] = $user;
						} elseif ($user['verification'] == 1 && $user['excluded'] == 1 && $user['deleted'] == 0) {
							$data['users']['excluded'][$user['static']][] = $user;
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
			
			case 'users_addict':
				if ($usersData = $this->users_model->getUsers($params)) {
					$data['statics'] = $this->admin_model->getStatics();
					$data['ranks'] = $this->admin_model->getRanks();
					
					$data['users'] = [];
					foreach ($usersData as $user) {
						if ($user['verification'] == 0 && $user['deleted'] == 0) $userStat = 'new';
						elseif ($user['deleted'] == 1) $userStat = 'deleted'; 
						elseif ($user['verification'] == 1 && $user['deleted'] == 0) $userStat = 'active'; 
						
						$static = arrTakeItem($user, 'static') ?: 0;
						$userId = arrTakeItem($user, 'id');
						$data['users'][$userStat][$static][$userId] = $user;
					}
				}
				break;
			
			case 'raidliders':
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanksLiders();
				$data['liders'] = $this->users_model->getRaidLiders();
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
				$data['ranks_liders'] = $this->admin_model->getRanksLiders();
				break;
				
			case 'accounts_access':
				$data['accounts_access'] = $this->admin_model->getAccountsAccess();
				break;
				
			case 'roles':
				$data['roles'] = $this->admin_model->getRoles();
				break;
			
			case 'classes':
				$data['classes'] = $this->admin_model->getClasses();
				break;
			
			case 'mentors':
				$data['mentors_requests'] = $this->admin_model->getMentorsRequests();
				break;
				
			case 'raids_types':
				$data['raids_types'] = $this->admin_model->getRaidsTypes();
				$data['keys_types'] = $this->admin_model->getKeysTypes();
				break;
			
			case 'ratings':
				
				break;
				
			case 'offtime':
				$this->load->model('offtime_model');
				$data['statics'] = $this->admin_model->getStatics();
				$data['roles'] = $this->admin_model->getRoles();
				$data['roles_limits'] = $this->offtime_model->getRolesLimits();
				
				$startDatePoint = (date('j', time()) == 1) ? strtotime('today') : strtotime(date('d-m-Y', strtotime('first day of 0 month')));
				$data['offtime']['dates'] = getDatesRange($startDatePoint, date('t', $startDatePoint), 'day');
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
				$data['payment_requests_list'] = []; $paymentRequestsList = [];
				if ($getPaymentRequests = $this->reports_model->getPaymentRequests($params)) {
					$statics = $this->admin_model->getStatics();
					$paymentRequestsList = array_map(function($item) use ($statics) {
						$item['static_name'] = isset($statics[$item['static']]) ? $statics[$item['static']]['name'] : null;
						$item['static_icon'] = isset($statics[$item['static']]) ? $statics[$item['static']]['icon'] : null;
						unset($item['static']);
						return $item;
					}, $getPaymentRequests);
				}
				
				$data['payment_requests_list'] = array_slice($paymentRequestsList, 0, 500);

				/*if ($paymentRequestsList) {
					foreach ($paymentRequestsList as $item) {
						$paid = $item['paid'] == 0 ? 'nopaid' : 'paid';
						$data['payment_requests_list'][$paid][] = $item;
					}
					$data['payment_requests_list']['paid'] = isset($data['payment_requests_list']['paid']) ? array_slice($data['payment_requests_list']['paid'], 0, 100) : false;
				}*/
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
			
			case 'personal_gifts':
				$users = $this->users_model->getUsers(array_replace_recursive((array)$params, ['where' => ['us.main' => 1, 'deleted' => 0, 'verification' => 1], 'fields' => 'id avatar nickname rank static']));
				$this->load->model('gifts_model', 'gifts');
				$giftsCounts = $this->gifts->personalgifts('get_gifts_counts');
				
				$giftsCounts = setArrKeyfromField($giftsCounts, 'user_id');
				
				$usersData = [];
				foreach ($users as $user) {
					$static = arrTakeItem($user, 'static');
					$user['counts'] = isset($giftsCounts[$user['id']]) ? $giftsCounts[$user['id']]: 0;
					$usersData[$static][] = $user;
				}
				
				$data['users'] = $usersData;
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanks();
				break;
		}
		
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get_cumulative_balance() {
		if (!$userId = $this->input->post('user_id')) exit('');
		$this->load->model('wallet_model', 'wallet');
		$data = $this->wallet->getUserHistory($userId, 'cumulative');
		$data['balance'] = $this->wallet->getUserCumulativeBalance($userId);
		echo $this->twig->render('views/account/render/wallet/history_cumulative.tpl', $data);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------- Предложения и жалобы, заказ оплаты
	
	
	
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
	 * Форма удаления или отстронения участника
	 * @param 
	 * @return 
	*/
	public function get_delete_user_form() {
		echo $this->twig->render($this->viewsPath.'render/delete_user');
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
	 * @param 
	 * @return 
	*/
	public function exclude_user() {
		if (! $this->input->is_ajax_request()) return false;
		$userId = $this->input->post('id');
		echo $this->users_model->excludeUser($userId);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function include_user() {
		if (! $this->input->is_ajax_request()) return false;
		$userId = $this->input->post('id');
		echo $this->users_model->includeUser($userId);
	}
	
	
	
	
	/**
	 * Обновить Резерв пользователей
	 * @param 
	 * @return 
	 */
	public function deposit_update() {
		if (! $this->input->is_ajax_request()) return false;
		if (!$depositData = $this->input->post()) exit('0');
		
		if (!$this->users_model->depositUpdate($depositData)) exit('0');
		
		
		$deposit = is_numeric($depositData['deposit']) ? (float)$depositData['deposit'] : 0;
		$depositOrigin = is_numeric($depositData['deposit_origin']) ? (float)$depositData['deposit_origin'] : 0;
		
		$globalHistoryData[] = [
			'user_id'	=> $depositData['id'],
			'summ'		=> ($depositOrigin - $deposit),
			'date'		=> time(),
			'reason'	=> 1
		];
		
		$this->admin_model->globalDepositHistoryAdd($globalHistoryData, true);
		
		$dataToAdmin = [
			'user_id' 		=> $depositData['id'],
			'payment_old' 	=> $depositData['payment_origin'],
			'payment_new' 	=> $depositData['payment'],
			'deposit_old' 	=> $depositOrigin,
			'deposit_new' 	=> $deposit
		];
		
		$this->adminaction->setAdminAction(6, $dataToAdmin);
		echo 1;
	}
	
	
	
	
	
	
	
	
	/**
	 * Задать значение для поля участника
	 * @param 
	 * @return 
	*/
	public function set_user_field() {
		if (!$this->input->is_ajax_request()) return false;
		
		$data = bringTypes($this->input->post());
		
		if (!$this->admin_model->setUsersField($data['user_id'], $data['field'], $data['value'])) exit('0');
		echo '1';
	}
	
	
	
	
	/**
	 * Задать значение для поля рейд-лидера
	 * @param 
	 * @return 
	*/
	public function set_lider_field() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		if (!$this->admin_model->setLidersField($data['user_id'], $data['field'], $data['value'])) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	public function statics_add() {
		if (!$this->input->is_ajax_request()) return false;
		if (!$staticsData = $this->input->post('statics')) exit('0');
		
		$statics = array_filter($staticsData, function($val) {return isset($val['name']) && $val['name'] != '';});
		$statics = array_map(function($item) {
			$item['stopstage'] = isset($item['stopstage']) ? $item['stopstage'] : 0;
			$item['active'] = isset($item['active']) ? $item['active'] : 0;
			$item['payformat'] = isset($item['payformat']) ? $item['payformat'] : null;
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
		if (!$this->input->is_ajax_request()) return false;
		$formData = bringTypes($this->input->post());
		
		if (isset($formData['ranks']) && $formData['ranks']) {
			$ranks = array_filter($formData['ranks'], function($val) {return $val['name'] != '';});
			
			$renksData = [];
			foreach ($ranks as $id => $item) {
				if ($item['name'] == '') continue;
				$item['coefficient'] = json_encode($item['coefficient']);
				$renksData[$id] = $item;
			}
			$this->admin_model->addRanks(bringTypes($renksData));
		}
		
		if (isset($formData['ranks_liders']) && $formData['ranks_liders']) {
			$ranksLiders = array_filter($formData['ranks_liders'], function($val) {return $val['name'] != '';});
			$ranksLidersData = [];
			foreach ($ranksLiders as $id => $item) {
				if ($item['name'] == '') continue;
				//$item['coefficient'] = json_encode($item['coefficient']);
				$ranksLidersData[$id] = $item;
			}
			$this->admin_model->addRanksLiders(bringTypes($ranksLidersData));
		}	
		echo '1';
	}
	
	
	public function ranks_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeRanks($id);
	}
	
	
	
	public function ranks_liders_remove() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeRanksLiders($id);
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
	
	
	
	
	
	
	
	/**
	 * Получить список статиков участника
	 * @param ID пользователя
	 * @return HTML
	 */
	public function get_users_classes() {
		$userId = $this->input->post('user_id');
		$newSet = $this->input->post('newset');
		$userClasses = $this->users_model->getUsersClasses($userId);
		echo $this->twig->render($this->viewsPath.'render/user_classes', ['classes' => $userClasses, 'newset' => $newSet]);
	}
	
	
	
	/**
	 * Задать классы пользователя
	 * @param 
	 * @return 
	 */
	public function set_user_classes() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		echo $this->users_model->setUserClasses($postData['user_id'], $postData['user_classes']);
	}
	
	
	
	
	public function classes_add() {
		if (! $this->input->is_ajax_request()) return false;
		$postData = array_filter($this->input->post('classes'), function($val) {return $val['name'] != '';});
		echo $this->admin_model->addClasses(bringTypes($postData));
	}
	
	public function classes_remove() {
		if (! $this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		echo $this->admin_model->removeClasses($id);
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
			
			case 'update':
				if ($this->admin_model->personagesUpdate($postData)) {
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
				$data = bringTypes($postData['data']);
				$tempTitle = arrTakeItem($postData, 'title');
				
				//$toDeposit = $postData['to_deposit'];
				$usersIds = array_column($data, 'user_id') ?: [];
				$this->load->model('users_model');
				$usersData = $this->users_model->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'id, nickname, avatar, payment, deposit, static, lider']);
				$usersData = setArrKeyFromField($usersData, 'id', true);
				
				/*if ($toDeposit) {
					$staticsData = $this->admin_model->getStatics();
					$percentToDeposit = $this->admin_model->getSettings('payment_requests_deposit_percent');
				}*/
				
				$orders = []; $toWalletData = [];
				//$toDepositData = [];
				foreach ($data as $user) {
					/*if ($toDeposit) {
						$userStatic = $usersData[$user['user_id']]['static'];
						$userLider = $usersData[$user['user_id']]['lider'];
						$userDeposit = $usersData[$user['user_id']]['deposit'];
						
						
						$limit = $userLider ? $staticsData[$userStatic]['cap_lider'] : $staticsData[$userStatic]['cap_simple']; // лимит депозита
						$canSetToDeposit = $limit - $userDeposit > 0 ? $limit - $userDeposit : 0;
						
						$summToDeposit = ($user['summ'] / 100) * $percentToDeposit; // сумма в депозит
						
						$summToDeposit = $canSetToDeposit >= $summToDeposit ? $summToDeposit : $canSetToDeposit;
						$summToOrder = $user['summ'] - $summToDeposit; // сумма в оплату
						
						$toDepositData[$user['user_id']] = $summToDeposit; 
					} else {
						$summToOrder = $user['summ'];
						$summToDeposit = 0;
					}*/
					
					$summToOrder = $user['summ'];
					$summToDeposit = 0;
					
					$orders[] = [
						'user_id'		=> $user['user_id'],
						'nickname' 		=> $usersData[$user['user_id']]['nickname'],
						'avatar' 		=> $usersData[$user['user_id']]['avatar'],
						'payment' 		=> $usersData[$user['user_id']]['payment'],
						'static' 		=> $usersData[$user['user_id']]['static'],
						'order' 		=> $user['order'],
						'summ' 			=> $summToOrder, // $user['summ']
						'to_deposit'	=> $summToDeposit,
						'comment' 		=> $user['comment'],
						'date'			=> time()
					];
					
					if (!isset($toWalletData[$user['user_id']])) {
						$toWalletData[$user['user_id']]['amount'] = $summToOrder;
						$toWalletData[$user['user_id']]['to_deposit'] = $summToDeposit;
					} else {
						$toWalletData[$user['user_id']]['amount'] += $summToOrder;
						$toWalletData[$user['user_id']]['to_deposit'] += $summToDeposit;
					}
				}
				
				$this->load->model('wallet_model');
				$this->wallet_model->setToWallet($toWalletData, 5, $user['order'], '+');

				if (!$this->reports_model->insertUsersOrders($orders)) exit('0');
				
				$this->adminaction->setAdminAction(5, ['type' => 'template', 'title' => $tempTitle, 'users' => $orders]);
				//if ($toDeposit) $this->users_model->setUsersDeposit($toDepositData);
				echo json_encode('1');
				break;
			
			default:
				echo '';
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Наставничество
	 * @param 
	 * @return 
	 */
	public function mentors($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$postData = bringTypes($this->input->post());
		switch ($action) {
			case 'change_stat': // сменить статус заявки
				if (!$this->admin_model->changeMentorsRequestStat($postData['id'], $postData['stat'])) exit('0');
				echo '1';
				break;
				
				
			case 'get_pay_blank': // отправить заяку на оплату
				$requestData = $this->admin_model->getRequestPayData($postData['id']);
				echo $this->twig->render('views/admin/render/mentors_request_pay.tpl', $requestData);
				break;
			
			case 'set_to_pay': // отправить заяку на оплату
				if (!$this->admin_model->addRequestToPay($postData)) exit('0');
				echo '1';
				break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Рейтинги
	 * @param 
	 * @return 
	 */
	public function ratings($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$postData = bringTypes($this->input->post());
		$this->load->model('ratings_model', 'ratings');
		switch ($action) {
			case 'get_periods': // получить список периодов
				$ratingsPeriods = $this->ratings->getPeriods();
				echo $this->twig->render('views/admin/render/ratings/periods_list.tpl', ['ratings_periods' => $ratingsPeriods]);
				break;
			
			case 'new_period': // новый период
				$this->load->model('reports_model');
				$reportsPeriods = $this->ratings->getReportsPeriods();
				echo $this->twig->render('views/admin/render/ratings/periods_new.tpl', ['reports_periods' => $reportsPeriods]);
				break;
			
			case 'add_period': // добавить период
				$this->ratings->addPeriod($postData);
				$ratingsPeriods = $this->ratings->getPeriods();
				echo $this->twig->render('views/admin/render/ratings/periods_list.tpl', ['ratings_periods' => $ratingsPeriods]);
				break;
			
			case 'set_active_period': // задать активный период
				if ($this->ratings->setActivePeriod($postData['id'])) exit('0');
				echo '1';
				break;
			
			case 'set_referencepoint_period': // задать точку отсчета для расчета рейтинга
				if ($this->ratings->setReferencepointPeriod($postData['id'])) exit('0');
				echo '1';
				break;
				
				
				
			case 'get_report': // получить отчет
				$periodInfo = $this->ratings->getPeriodsInfo($postData['period_id']);
				$report = $this->ratings->getReport($postData['period_id']);
				$statics = $this->admin_model->getStatics(true);
				$data = [
					'report' 	=> $report,
					'statics' 	=> $statics,
					'info'		=> $periodInfo
				];
				echo $this->twig->render('views/admin/render/ratings/ratings_report.tpl', $data);
				break;
			
			case 'save_report': // Сохранить отчет
				if (!$this->ratings->saveReport($postData['data'])) exit('0');
				echo '1';
				break;
			
			case 'get_users_list': // Получить список участников для выставления данных
				$data['users'] = $this->ratings->getUsers($postData);
				$data['statics'] = $this->admin_model->getStatics(true);
				echo $this->twig->render('views/admin/render/ratings/users_list.tpl', $data);
				break;
			
			case 'history_add': // записать данные в историю
				$history = [];
				
				foreach ($postData['history'] as $item) {
					$history[] = [
						'from'	=> $item['from'],
						'to'	=> $item['to'],
						'type'	=> $item['type'],
						'data'	=> $item['data']
					];
				}
				$stat = $this->ratings->addToRatingHistory($history, true);
				if (!$stat) exit('0');
				echo '1';
				break;
			
			case 'get_rating_history': // Получить список истории
				$data['history']['coeffs'] = $this->ratings->getRatingHistory($postData, 'coeffs');
				$data['history']['others'] = $this->ratings->getRatingHistory($postData, 'others');
				$data = [];
				echo $this->twig->render('views/admin/render/ratings/history.tpl', $data);
				break;
			
			case 'get_statistics': // Получить статистику заполнения коэффиентов
				$data['statics'] = $this->admin_model->getStatics();
				$data['periods'] = $this->ratings->getPeriods('ASC');
				$data['statistics'] = $this->ratings->getRatingStatistics();
				echo $this->twig->render('views/admin/render/ratings/statistics.tpl', $data);
				break;
			
			case 'notify_raidliders': // Отправить оповещениея рейд-лидерам
				if (!$this->ratings->notifyRaidliders($postData['period_id'])) exit('0');
				echo '1';
				break;
				
			case 'get_coeffs_info': // Получить информацию по коэффициентам
				$this->load->model('account_model', 'account');
				$staticId = $postData['static_id'];
				if (!$activeRatingsPeriodsData = $this->account->getActiveRatingsPeriod(true)) exit('');
				
				if ($savedData = $this->account->getSavedRatingsdata($activeRatingsPeriodsData['id'], $staticId)) {
					$data = $this->account->getPeriodsInfo($staticId, $activeRatingsPeriodsData);
					$data['users'] = $this->account->getUsersForRating($staticId);
					$data['visits'] = setArrKeyFromField($savedData, 'user_id', false, 'visits');
					$data['saved'] = setArrKeyFromField($savedData, 'user_id', false, 'activity, skill');
					
					$data['ratings_period'] = $activeRatingsPeriodsData['id'];
					$data['static_id'] = $staticId;
					
				} else {
					$data = $this->account->getPeriodsInfo($staticId, $activeRatingsPeriodsData);
					$data['users'] = $this->account->getUsersForRating($staticId);
					$data['visits'] = $this->account->getUserVisitsRate(['static_id' => $staticId, 'period' => $activeRatingsPeriodsData]);
					$data['ratings_period'] = $activeRatingsPeriodsData['id'];
					$data['static_id'] = $staticId;
				}
				
				echo $this->twig->render('views/account/render/users_for_rating.tpl', $data);
				break;
			
			case 'correct_coeffs_info': // Скорректировать информацию по коэффициентам
				$this->load->model('account_model', 'account');
				if (!$this->account->saveDataForRating($postData)) exit('0');
				echo '1';
				break;	
			
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Премии
	 * @param 
	 * @return 
	*/
	public function rewards($action = false, $arg = false) {
		if ((!$this->input->is_ajax_request() || !$action) && $action != 'export') return false;
		$postData = bringTypes($this->input->post());
		$this->load->model(['rewards_model' => 'rewards', 'reports_model' => 'reports']);
		switch ($action) {
			case 'get_periods': // получить список периодов
				$rewardsPeriods = $this->rewards->getPeriods();
				echo $this->twig->render('views/admin/render/rewards/periods_list.tpl', ['rewards_periods' => $rewardsPeriods]);
				break;
			
			case 'new_period': // новый период
				$reportsPeriods = $this->reports->getReportsPeriods();
				echo $this->twig->render('views/admin/render/rewards/period_form.tpl', ['reports_periods' => $reportsPeriods]);
				break;
			
			case 'add_period': // добавить период
				$this->rewards->addPeriod($postData);
				$rewardsPeriods = $this->rewards->getPeriods();
				echo $this->twig->render('views/admin/render/rewards/periods_list.tpl', ['rewards_periods' => $rewardsPeriods]);
				break;
			
			case 'edit_period': // добавить период
				$periodData = $this->rewards->getPeriod($postData['period_id']);
				$reportsPeriods = $this->reports->getReportsPeriods();
				if ($reportsPeriods) {
					foreach ($reportsPeriods as $pkey => $period) {
						if (in_array($period['id'], $periodData['reports_periods'])) $reportsPeriods[$pkey]['choosed'] = 1;
					}
				}
				echo $this->twig->render('views/admin/render/rewards/period_form.tpl', array_merge($periodData, ['reports_periods' => $reportsPeriods]));
				break;
			
			case 'update_period': // обновить период
				$this->rewards->updatePeriod($postData);
				$rewardsPeriods = $this->rewards->getPeriods();
				echo $this->twig->render('views/admin/render/rewards/periods_list.tpl', ['rewards_periods' => $rewardsPeriods]);
				break;
				
			case 'change_stat': // изменить статус периода
				if ($this->rewards->changePeriodStat($postData)) exit('0');
				echo '1';
				break;
			
			case 'get_statics_form': // Задать бюджет статиков
				$statics = $this->rewards->getStatics();
				$rewards = $this->rewards->getStaticsSumm($postData['period_id']);
				$periods = $this->rewards->getRewardReportsPeriods($postData['period_id']);
				echo $this->twig->render('views/admin/render/rewards/statics_form.tpl', ['statics' => $statics, 'periods' => $periods, 'rewards' => $rewards]);
				break;
				
			case 'set_statics_summ': // Сохранить бюджет статиков
				if ($this->rewards->setStaticsSumm($postData)) exit('0');
				echo '1';
				break;
			
			case 'set_to_wallet': // Отправить суммы в кошельки участников
				$this->load->model('wallet_model', 'wallet');
				$rewardsPayments = $this->get_rewards_report($postData['period_id']);
				
				if (!$this->wallet->setToWallet($rewardsPayments, 4, $postData['report_title'], '+')) exit('0');
				$this->rewards->setWalletStat($postData['period_id'], 1);
				echo '1';
				break;
			
			
			case 'get_report': // получить отчет
				$statics = $this->rewards->getStatics();
				$reportsPeriods = $this->reports->getReportsPeriods();
				$report = $this->rewards->getReportData($postData['period_id'], $statics, $reportsPeriods);
				echo $this->twig->render('views/admin/render/rewards/report.tpl', $report);
				break;
			
			case 'get_static_report':
				$post = bringTypes($this->input->post());
				$this->load->model('users_model', 'users');
				
				$rewardPeriodId = $post['period_id'];
				
				$staticId = $post['static_id'];
				$periodData = $this->rewards->getPeriod($rewardPeriodId);
				$summData = $this->rewards->getStaticsSumm($rewardPeriodId, $staticId);
				
				$staticsSumm = 0;
				foreach ($summData as $period => $summ) $staticsSumm += $summ;
							
				$data['cash'][$staticId] = $staticsSumm;
				$data['period_id'] = $periodData['reports_periods'];
				$data['variant'] = 2;
				$data['ranks'] = $this->rewards->getRewardsRanks($rewardPeriodId);
				
				$staticReport = $this->reports->buildReportPaymentsData($this->constants[2], $data);
				
				if (!$staticReport = isset($staticReport[$staticId]) ? $staticReport[$staticId] : false) exit('');
				foreach ($staticReport['users'] as $userId => $user) unset($staticReport['users'][$userId]['raids']);
				
				$staticReport['static'] = $this->admin_model->getStatics(false, $staticId);
				$staticReport['users_data'] = $this->users->getUsers(['where' => ['us.static_id' => $staticId, 'deleted' => 0, 'verification' => 1], 'fields' => 'avatar']);
				
				echo $this->twig->render('views/admin/render/rewards/static_report.tpl', $staticReport);
				break;
				
			case 'export':
				$rewardPeriodId = $arg;
				$periodData = $this->rewards->getPeriod($rewardPeriodId);
				$summData = $this->rewards->getStaticsSumm($rewardPeriodId);
				
				$staticsSumm = [];
				foreach ($summData as $period) {
					foreach ($period as $staticId => $summ) {
						if (!isset($staticsSumm[$staticId])) $staticsSumm[$staticId] = $summ;
						else $staticsSumm[$staticId] += $summ;
					}
				}
				
				$data['cash'] = $staticsSumm;
				$data['period_id'] = $periodData['reports_periods'];
				$data['variant'] = 2;
				$data['ranks'] = $this->rewards->getRewardsRanks($rewardPeriodId);
				
				$dataToExport = $this->reports->buildReportPaymentsData($this->constants[2], $data);
				
				$export = '';
				foreach ($dataToExport as $staticId => $data) {
					$export .= iconv('UTF-8', 'windows-1251', 'Статик;Бюджет статика'."\r\n");
					//$export .= $data['static_name'].';'.number_format($data['cash'], 2, '.', ' ')."\r\n";
					$export .= $data['static_name'].';'.$data['cash']."\r\n";
					$export .= iconv('UTF-8', 'windows-1251', 'Никнейм;Выплата;Средство оплаты')."\r\n";
					foreach ($data['users'] as $userId => $userData) {
						unset($userData['raids']);
						$export .= iconv('UTF-8', 'windows-1251', $userData['nickname'].';'.str_replace('.', ',', $userData['payment']).';'.$userData['pay_method'])."\r\n";
					}
					$export .= "\r\n";
				}
				
				setHeadersToDownload('application/octet-stream', 'windows-1251');
				echo $export;
				break;
				
				
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Выговоры
	 * @param 
	 * @return 
	 */
	public function reprimands($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$postData = bringTypes($this->input->post());
		$this->load->model(['reprimands_model' => 'reprimands', 'ratings_model' => 'ratings']);
		switch ($action) {
			case 'get_list': // получить список Форс мажорных выходных
				$list = $this->reprimands->get($postData['user_id']);
				echo $this->twig->render('views/admin/render/ratings/reprimands/list.tpl', ['list' => $list]);
				break;
			
			case 'new': // новый Форс мажорный выходной
				echo $this->twig->render('views/admin/render/ratings/reprimands/form.tpl');
				break;
			
			case 'add':
				if (!$this->reprimands->add($postData)) exit('0');
				$userId = arrTakeItem($postData, 'user_id');
				$postData['date'] = strtotime($postData['date']);
				$stat = $this->ratings->addToRatingHistory([
					'from' 		=> 0,
					'to' 		=> $userId,
					'type' 		=> 5,
					'data' 		=> $postData,
					'status'	=> 1
				]);
				
				if (!$stat) exit('0');
				echo '1';
				break;
			
			case 'edit':
				$data = $this->reprimands->getItem($postData['id']);
				echo $this->twig->render('views/admin/render/ratings/reprimands/form.tpl', $data);
				break;
			
			case 'update':
				if (!$this->reprimands->update($postData)) exit('0');
				$userId = arrTakeItem($postData, 'user_id');
				$postData['date'] = strtotime($postData['date']);
				$stat = $this->ratings->addToRatingHistory([
					'from' 		=> 0,
					'to' 		=> $userId,
					'type' 		=> 5,
					'data' 		=> $postData,
					'status'	=> 2
				]);
				
				if (!$stat) exit('0');
				echo '1';
				break;
			
			case 'remove_form':
				echo $this->twig->render('views/admin/render/ratings/reprimands/remove_form.tpl');
				break;
			
			 case 'remove': // ID, message
			 	$itemData = $this->reprimands->getItem($postData['id']);
			 	
			 	if (!$this->reprimands->remove($postData['id'])) exit('0');
			 	$itemData['data'] = [
			 		'message' 	=> $postData['message'],
			 		'date' 		=> $itemData['date']
			 	];
			 	$stat = $this->ratings->addToRatingHistory([
					'from' 		=> 0,
					'to' 		=> $itemData['user_id'],
					'type' 		=> 5,
					'data' 		=> $itemData['data'],
					'status'	=> -1
				]);
				
				if (!$stat) exit('0');
				echo '1';
			 	break;
				
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Форс мажорные выходные
	 * @param 
	 * @return 
	 */
	public function forcemajeure($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$postData = bringTypes($this->input->post());
		$this->load->model(['forcemajeure_model' => 'forcemajeure', 'ratings_model' => 'ratings']);
		switch ($action) {
			case 'get_list': // получить список Форс мажорных выходных
				$list = $this->forcemajeure->get($postData['user_id']);
				echo $this->twig->render('views/admin/render/ratings/forcemajeure/list.tpl', ['list' => $list]);
				break;
			
			case 'new': // новый Форс мажорный выходной
				echo $this->twig->render('views/admin/render/ratings/forcemajeure/form.tpl');
				break;
			
			case 'add':
				if (!$this->forcemajeure->add($postData)) exit('0');
				$userId = arrTakeItem($postData, 'user_id');
				$postData['date'] = strtotime($postData['date']);
				$stat = $this->ratings->addToRatingHistory([
					'from' 		=> 0,
					'to' 		=> $userId,
					'type' 		=> 6,
					'data' 		=> $postData,
					'status'	=> 1
				]);
				
				if (!$stat) exit('0');
				echo '1';
				break;
			
			case 'edit':
				$data = $this->forcemajeure->getItem($postData['id']);
				echo $this->twig->render('views/admin/render/ratings/forcemajeure/form.tpl', $data);
				break;
			
			case 'update':
				if (!$this->forcemajeure->update($postData)) exit('0');
				$userId = arrTakeItem($postData, 'user_id');
				$postData['date'] = strtotime($postData['date']);
				$stat = $this->ratings->addToRatingHistory([
					'from' 		=> 0,
					'to' 		=> $userId,
					'type' 		=> 6,
					'data' 		=> $postData,
					'status'	=> 2
				]);
				
				if (!$stat) exit('0');
				echo '1';
				break;
			
			case 'remove_form':
				echo $this->twig->render('views/admin/render/ratings/forcemajeure/remove_form.tpl');
				break;
			
			 case 'remove': // ID, message
			 	$itemData = $this->forcemajeure->getItem($postData['id']);
			 	
			 	if (!$this->forcemajeure->remove($postData['id'])) exit('0');
			 	$itemData['data'] = [
			 		'message' 	=> $postData['message'],
			 		'date' 		=> $itemData['date']
			 	];
			 	$stat = $this->ratings->addToRatingHistory([
					'from' 		=> 0,
					'to' 		=> $itemData['user_id'],
					'type' 		=> 6,
					'data' 		=> $itemData['data'],
					'status'	=> -1
				]);
				
				if (!$stat) exit('0');
				echo '1';
			 	break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Стимулирование
	 * @param 
	 * @return 
	 */
	public function stimulation($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$postData = bringTypes($this->input->post());
		$this->load->model(['stimulation_model' => 'stimulation', 'ratings_model' => 'ratings']);
		switch ($action) {
			case 'get_form': // получить список Форс мажорных выходных
				$data = $this->stimulation->get($postData['user_id']) ?: $postData;
				echo $this->twig->render('views/admin/render/ratings/stimulation/form.tpl', $data ?: []);
				break;
			
			case 'set':
				if (($status = $this->stimulation->set($postData)) === false) exit('0');
				$userId = arrTakeItem($postData, 'user_id');
				
				$stat = $this->ratings->addToRatingHistory([
					'from' 		=> 0,
					'to' 		=> $userId,
					'type' 		=> 7,
					'data' 		=> $postData,
					'status' 	=> $status
				]);
				
				if (!$stat) exit('0');
				echo '1';
				break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	/**
	 * Изменить статус увольнения
	 * @param 
	 * @return 
	 */
	public function change_resign_stat() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		$this->load->model('users_model', 'users');
		
		if (isset($postData['order'])) {
			$userData = $this->users->getUsers(['where' => ['u.id' => $postData['order']['user_id'], 'us.main' => 1]]);
			$order = [
				'user_id'		=> $postData['order']['user_id'],
				'nickname' 		=> $userData[0]['nickname'],
				'avatar' 		=> $userData[0]['avatar'],
				'payment' 		=> $userData[0]['payment'],
				'static' 		=> $userData[0]['static'],
				'order' 		=> $postData['order']['order'],
				'summ' 			=> (float)$postData['order']['summ'],
				'to_deposit' 	=> 0,
				'comment' 		=> $postData['order']['comment'],
				'date'			=> time()
			];
			
			$summToBalance = (float)$postData['order']['full_summ'] - (float)$postData['order']['summ'];
			if ($summToBalance > 0) {
				$orderToBalance = [
					'user_id'		=> $postData['order']['user_id'],
					'nickname' 		=> $userData[0]['nickname'],
					'avatar' 		=> $userData[0]['avatar'],
					'static' 		=> $userData[0]['static'],
					'summ' 			=> $summToBalance,
					'comment' 		=> $postData['order']['comment_to_balance'],
					'date'			=> time()
				];
				if (!$this->admin_model->setOrderToBalance($orderToBalance)) exit(-3);
			}
			
			$this->load->model('wallet_model');
			$this->wallet_model->setToWallet([$postData['order']['user_id'] => (float)$postData['order']['summ']], 5, $postData['order']['order'], '+');
			
			if (!$this->admin_model->insertResignOrder($order)) exit('-1'); // отправить заявку на оплату
			if (!$this->users_model->setUserDeposit($postData['order']['user_id'], true)) exit('-2'); // обнулить депозит участника
			
		}
		
		if (!$this->admin_model->changeResignStat($postData['resign'])) exit('0'); // изменить статус заявки на увольнения
		
		echo '1';
	}
	
	
	
	
	
	
	/**
	 * Показать информацию об увольнении
	 * @param 
	 * @return 
	 */
	public function show_resign() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		$data['disableedit'] = $this->input->post('disableedit');
		$data['resign'] = $this->admin_model->showResign($id);
		
		echo $this->twig->render('views/admin/render/resign_info.tpl', $data);
	}
	
	
	
	/**
	 * Изменить дату последнего рабочего дня
	 * @param 
	 * @return 
	*/
	public function change_resign_lastday() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		if (!$this->admin_model->changeResignLastday($postData['id'], $postData['date'])) exit('0');
		echo '1';
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove_resign() {
		if (!$this->input->is_ajax_request()) return false;
		$resignId = $this->input->post('id');
		if (!$this->admin_model->removeResign($resignId)) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Показать форму для выплаты резерва и удержания в баланс
	 * @param 
	 * @return 
	 */
	public function pay_deposit_form() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		$data['disableedit'] = $this->input->post('disableedit');
		$data['resign'] = $this->admin_model->showResign($id);
		$data['pattern'] = $this->admin_model->getSettings('resign');
		echo $this->twig->render('views/admin/render/pay_deposit_form.tpl', $data);
	}
	
	
	
	
	
	
	
	/**
	 * Обработать заявку
	 * @param 
	 * @return 
	*/
	public function set_vieved() {
		if (!$this->input->is_ajax_request()) return false;
		$id = $this->input->post('id');
		if (!$this->admin_model->setViedResign($id)) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	
	
	/**
	 * Списать баланс
	 * @param 
	 * @return 
	*/
	public function reset_balance() {
		echo $this->admin_model->resetBalance();
	}
	
	
	
	
	
	
	
	/**
	 * Изменить статус NDA соглашения
	 * @param 
	 * @return 
	*/
	public function change_nda_stat() {
		if (!$this->input->is_ajax_request()) return false;
		$post = bringTypes($this->input->post());
		if (!$this->admin_model->changeNdaStat($post)) exit('0');
		echo '1';
		
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function stoplist($action = false) {
		if (!$action) return false;
		$post = bringTypes($this->input->post());
		$this->load->model('users_model', 'users');
		
		switch ($action) {
			case 'get_users':
				$usersData = [];
				if ($stopListItems = $this->admin_model->getStopList('addictpay')) {
					$usersIds = array_column($stopListItems, 'item_id');
					$users = $this->users->getUsers(['where' => ['us.main' => 1], 'where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'id static']);
					foreach ($users as $user) {
						$usersData[] = [
							'user'		=> (int)$user['id'],
							'static'	=> (int)$user['static']
						];
					}
				}
				
				echo json_encode($usersData);
				break;
			
			case 'remove_user':
				if (!$this->admin_model->removeFromStopList($post['id'])) exit('0');
				echo '1';
				break;
			
			case 'insert_users':
				if (isset($post['users']) && $post['users']) {
					$usersIds = array_column($post['users'], 'id');
					if ($insData = $this->admin_model->insertInStopList($usersIds, 'addictpay')) {
						foreach ($insData as $itemId => $insItem) {
							$post['users'][$itemId]['ins_id'] = $insItem;
						}
					}
				}
				
				echo $this->twig->render('views/admin/render/stoplist/addictpay_users.tpl', $post);
				break;
			
			
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function statistics($action = false) {
		if (!$action) return false;
		$post = bringTypes($this->input->post());
		$this->load->model('reports_model', 'reports');
		//$this->load->model('users_model', 'users');
		switch ($action) {
			case 'get_statics':
				$data['statics'] = $statics = $this->admin_model->getStatics();
				echo $this->twig->render('views/admin/render/statistics/statics.tpl', $data);
				break;
			
			case 'get_reports':
				$data['reports'] = $this->reports->getMainReportPatternsTitles();
				echo $this->twig->render('views/admin/render/statistics/reports.tpl', $data);
				break;
			
			case 'get_ranks':
				$data['ranks'] = $this->admin_model->getStaticsRanks($post['statics']);
				echo $this->twig->render('views/admin/render/statistics/rakns.tpl', $data);
				break;
				
			case 'get_calendar_reports':
				$reportsIds = $this->reports->getCalendarReportsIds();
				
				$type = $post['type'] ?: 1;
				if ($type == 1) { // сохр. отчеты
					$data['reports'] = $this->reports->getMainReportPatternsTitles();
					if ($reportsIds[1]) $data['reports']['items'] = array_diff_key($data['reports']['items'], array_flip($reportsIds[1]));
					
				} elseif ($type == 2) { // премиальные отчеты
					$data['reports'] = $this->reports->getRewardsPeriodsTitles();
					if ($reportsIds[2]) $data['reports']['items'] = array_diff_key($data['reports']['items'], array_flip($reportsIds[2]));
				}
				$data['type'] = $type;
				
				echo $this->twig->render('views/admin/render/statistics/reports.tpl', $data);
				break;
			
			case 'statics_amount_report': // Отчет "Доход статиков"
				$reports = $this->reports->getMainReportPatterns();
				$reports2 = $this->reports->getMainReportPatterns(null, null, 1);
				
				$allReports = array_replace($reports, $reports2);
				ksort($allReports);
				
				
				$statics = $this->admin_model->getStatics(false, $post['statics']);
				$reportsTitles = $this->reports->getMainReportPatternsTitles($post['reports']);
				
				if (!$choosedReports = array_intersect_key($allReports, array_flip($post['reports']))) exit('');
				
				
				$reportData = []; $staticsData = array_flip($post['statics']);
				foreach ($choosedReports as $reportId => $report) {
					$hasInPost = array_diff_key($staticsData, $report['cash']);
					$hasInReports = array_intersect_key($report['cash'], $staticsData);
					$hasInPost = array_combine(array_keys($hasInPost), array_fill(0, count($hasInPost), null));
					$cashData = array_replace($hasInPost, $hasInReports);
					ksort($cashData);
					
					foreach ($cashData as $staticId => $cash) {
						$reportData[$staticId][$reportId] = $cash;
					}
				}
				
				$totals = [];
				foreach ($reportData as $staticId => $reportsAmounts) {
					if (array_sum($reportsAmounts) == 0) {
						$totals[$staticId]['summ'] = null;
						$totals[$staticId]['median'] = null;
						$totals[$staticId]['avg'] = null;
						continue;
					} 
					
					$totals[$staticId]['summ'] = array_sum($reportsAmounts);
					$totals[$staticId]['avg'] = floor(array_sum($reportsAmounts) / count($reportsAmounts));
					
					$reportsAmounts = array_values($reportsAmounts);
					sort($reportsAmounts);
					
					if (count($reportsAmounts) % 2 != 0) {
						$totals[$staticId]['median'] = $reportsAmounts[floor(count($reportsAmounts) / 2)];
					} else {
						$florVal = $reportsAmounts[floor(count($reportsAmounts) / 2) - 1];
						$ceilVal = $reportsAmounts[floor(count($reportsAmounts) / 2)];
						$totals[$staticId]['median'] = floor(($florVal + $ceilVal) / 2);
					}
				}
				
				$data['report'] = $reportData;
				$data['statics'] = $statics;
				$data['reports_titles'] = $reportsTitles;
				$data['totals'] = $totals;
				
				echo $this->twig->render('views/admin/render/statistics/statics_amount_report.tpl', $data);
				break;
			
			case 'users_amount_report': // Отчет "Доход участников"
				$monthesDates = [];
				if (isset($post['timepoints']) && $post['timepoints']) {
					foreach ($post['timepoints'] as $timePoint) {
						$monthesDates[$timePoint] = [
							'start' => $timePoint, 
							'end' 	=> strtotime("first day of +1 month", $timePoint)
						];
					}
				}
				
				$calendarReports = $this->reports->getCalendarReports($post['timepoints'], true);
				
				$reportData = []; $reportsTitles = [];
				foreach ($calendarReports as $timePoint => $reports) {
					$paymentReports = isset($reports[1]) ? $reports[1] : false;
					$rewardsPeriods = isset($reports[2]) ? $reports[2] : false;
					
					$reportsPayments = $this->reports->getReportPatternsPayments(array_keys($post['users']), $paymentReports);
					$rewardsPayments = $this->get_rewards_report($rewardsPeriods, array_keys($post['users']));
					$usersOrders = $this->reports->getUsersOrders($monthesDates[$timePoint], array_keys($post['users']));
					
					$combineReports = array_filter(array_replace_recursive((array)$reportsPayments, (array)$rewardsPayments));
					if ($combineReports) {
						foreach ($combineReports as $userId => $reportsSummData) {
							$reportData[$userId][(string)$timePoint] = array_sum($reportsSummData) ?: 0;
						}
					}
					
					if ($usersOrders) {
						foreach ($usersOrders as $userId => $orders) {
							if (!isset($reportData[$userId][(string)$timePoint])) $reportData[$userId][(string)$timePoint] = (float)array_sum($orders);
							else $reportData[$userId][(string)$timePoint] += (float)array_sum($orders);
						}
					}
						
					$reportsTitles[] = $timePoint;
				}
				
				
				$totals = [];
				foreach ($reportData as $userId => $data) {
					if (array_sum($data) == 0) {
						$totals[$userId]['summ'] = null;
						$totals[$userId]['median'] = null;
						$totals[$userId]['avg'] = null;
						continue;
					} 
					
					$totals[$userId]['summ'] = array_sum($data);
					$totals[$userId]['avg'] = floor(array_sum($data) / count($data));
					
					$data = array_values($data);
					sort($data);
					
					if (count($data) % 2 != 0) {
						$totals[$userId]['median'] = $data[floor(count($data) / 2)];
					} else {
						$florVal = $data[floor(count($data) / 2) - 1];
						$ceilVal = $data[floor(count($data) / 2)];
						$totals[$userId]['median'] = floor(($florVal + $ceilVal) / 2);
					}
				}
				
				
				$data['users'] = $post['users'];
				$data['report'] = $reportData;
				$data['reports_titles'] = $reportsTitles;
				$data['totals'] = $totals;
				
				echo $this->twig->render('views/admin/render/statistics/users_amount_report.tpl', $data);
				break;
			
			case 'ranks_amount_report': // Отчет "Доход по званиям" statics -> ranks -> monthes
				$monthesDates = [];
				if (isset($post['timepoints']) && $post['timepoints']) {
					foreach ($post['timepoints'] as $timePoint) {
						$monthesDates[$timePoint] = [
							'start' => $timePoint, 
							'end' 	=> strtotime("first day of +1 month", $timePoint)
						];
					}
				}
				
				$statics = $this->admin_model->getStatics(true);
				$ranks = $this->admin_model->getRanks(true);
				$calendarReports = $this->reports->getCalendarReports($post['timepoints'], true);
				
				$this->load->model('users_model', 'users');
				$ranksStaticsData = $this->users->getRanksStaticsUsers($post['ranks'], $post['statics']);
				
				$reportData = []; $reportsTitles = []; // static -> user -> [timepoint => summ]
				foreach ($ranksStaticsData as $staticId => $ranksData) {
					$usersIds = array_keys($ranksData);
					foreach ($calendarReports as $timePoint => $reports) {
						$paymentReports = isset($reports[1]) ? $reports[1] : false;
						$rewardsPeriods = isset($reports[2]) ? $reports[2] : false;
						
						$reportsPayments = $this->reports->getReportPatternsPayments($usersIds, $paymentReports);
						$rewardsPayments = $this->get_rewards_report($rewardsPeriods, $usersIds);
						$usersOrders = $this->reports->getUsersOrders($monthesDates[$timePoint], $usersIds);
						
						
						$combineReports = array_filter(array_replace_recursive((array)$reportsPayments, (array)$rewardsPayments));
						if ($combineReports) {
							foreach ($combineReports as $userId => $reportsSummData) {
								if (!isset($reportData[$staticId][$ranksStaticsData[$staticId][$userId]][(string)$timePoint])) $reportData[$staticId][$ranksStaticsData[$staticId][$userId]][(string)$timePoint] = array_sum($reportsSummData) ?: 0;
								else $reportData[$staticId][$ranksStaticsData[$staticId][$userId]][(string)$timePoint] += array_sum($reportsSummData) ?: 0; 
							}
						}
						
						if ($usersOrders) {
							foreach ($usersOrders as $userId => $orders) {
								if (!isset($reportData[$staticId][$ranksStaticsData[$staticId][$userId]][(string)$timePoint])) $reportData[$staticId][$ranksStaticsData[$staticId][$userId]][(string)$timePoint] = (float)array_sum($orders);
								else $reportData[$staticId][$ranksStaticsData[$staticId][$userId]][(string)$timePoint] += (float)array_sum($orders);
							}
						}
							
						$reportsTitles[$timePoint] = $timePoint;
					}
					
				}
					
				
				
				$totals = [];
				foreach ($reportData as $staticId => $ranksData) foreach ($ranksData as $rankId => $data) {
					if (array_sum($data) == 0) {
						$totals[$staticId][$rankId]['summ'] = null;
						$totals[$staticId][$rankId]['median'] = null;
						$totals[$staticId][$rankId]['avg'] = null;
						continue;
					} 
					
					$totals[$staticId][$rankId]['summ'] = array_sum($data);
					$totals[$staticId][$rankId]['avg'] = floor(array_sum($data) / count($data));
					
					$data = array_values($data);
					sort($data);
					
					if (count($data) % 2 != 0) {
						$totals[$staticId][$rankId]['median'] = $data[floor(count($data) / 2)];
					} else {
						$florVal = $data[floor(count($data) / 2) - 1];
						$ceilVal = $data[floor(count($data) / 2)];
						$totals[$staticId][$rankId]['median'] = floor(($florVal + $ceilVal) / 2);
					}
				}
				
				
				$data['statics'] = $statics;
				$data['ranks'] = $ranks;
				$data['report'] = $reportData;
				$data['reports_titles'] = array_values($reportsTitles);
				$data['totals'] = $totals;
				
				echo $this->twig->render('views/admin/render/statistics/ranks_amount_report.tpl', $data);
				break;
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get_rewards_report($rewardsPeriodsIds = false, $usersIds = false) {
		if (!$rewardsPeriodsIds) return false;
		$this->load->model('rewards_model', 'rewards');
			
		$result = [];
		foreach ((array)$rewardsPeriodsIds as $rewardPeriodId) {
			$rewardPeriodData = $this->rewards->getRewardsPeriodData($rewardPeriodId);
			
			$summData = $this->rewards->getStaticsSumm($rewardsPeriodsIds, $rewardPeriodData['statics']);
			
			$staticsSumm = [];
			foreach ($summData as $period => $statics) foreach ($statics as $staticId => $summ) {
				if (!isset($staticsSumm[$staticId])) $staticsSumm[$staticId] = $summ;
				else $staticsSumm[$staticId] += $summ;
			}
			
			
			$data['cash'] = $staticsSumm;
			$data['period_id'] = $rewardPeriodData['reports_periods'];
			$data['variant'] = 2;
			$data['ranks'] = $this->rewards->getRewardsRanks($rewardsPeriodsIds);

			$reportData = $this->reports->buildReportPaymentsData($this->constants[2], $data);
			
			
			foreach ($reportData as $staticId => $reportData) foreach ($reportData['users'] as $userId => $user) {
				$result[$rewardPeriodId][$userId] = $user['payment'];
			} 
		}
		
		if ($usersIds) {
			foreach ($result as $reportId => $usersPayments) {
				$result[$reportId] = array_intersect_key($usersPayments, (array)array_flip($usersIds));
			}
		}
			
		
		$finalData = [];
		foreach ($result as $reportId => $usersPayments) foreach ($usersPayments as $userId => $payment) {
			if (!is_array($rewardsPeriodsIds)) $finalData[$userId] = $payment;
			else $finalData[$userId][$reportId] = $payment;
		}
				
		return $finalData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function calendar($action = false) {
		if (!$action) return false;
		$this->load->model('reports_model', 'reports');
		$post = bringTypes($this->input->post());
		
		switch ($action) {
			case 'get_calendar':
				$startYear = 2019; // ----------------------------- год начала
				$startDate = strtotime('01-01-'.$startYear);
				$countYears =  date('Y') - ($startYear - 1);
				
				$monthesDates = [];
				for ($month = 0; $month < ($countYears * 12); $month++) {
					$datePoint = strtotime("first day of $month month", $startDate);
					$monthesDates[date('Y', $datePoint)][] = [
						'timepoint'	=> $datePoint,
						'month'	=> $this->monthes2[date('n', $datePoint)]
					];
				}
				
				$data['calendar'] = $monthesDates;
				$data['reports'] = $this->reports->getCalendarReports();
				echo $this->twig->render('views/admin/render/calendar/monthes_grid.tpl', $data);
				break;
				
			case 'get_table':	
				$startYear = 2019; // ----------------------------- год начала
				$startDate = strtotime('01-01-'.$startYear);
				$countYears =  date('Y') - ($startYear - 1);
				
				$monthesDates = [];
				for ($month = 0; $month < ($countYears * 12); $month++) {
					$datePoint = strtotime("first day of $month month", $startDate);
					$monthesDates[date('Y', $datePoint)][] = [
						'timepoint'	=> $datePoint,
						'month'	=> $this->monthes2[date('n', $datePoint)]
					];
				}
				$data['calendar'] = $monthesDates;
				
				echo $this->twig->render('views/admin/render/calendar/table.tpl', $data);
				break;
				
			case 'add_reports':
				
				if (!$this->reports->addCalendarReports($post['type'], $post['timepoint'], $post['reports'])) exit('0');
				echo '1';
				break;
			
			case 'remove_report':
				if (!$this->reports->removeCalendarReport($post['type'], $post['timepoint'], $post['report'])) exit('0');
				echo '1';
				break;
			
			
			
			default:
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * менеджер участников
	 * @param 
	 * @return 
	*/
	public function usersmanager($action = false) {
		if (!$action) return false;
		$post = bringTypes($this->input->post());
		$this->load->model('users_model', 'users');
		$data = [];
		switch ($action) {
			case 'init':
				$data['statics'] = $this->admin_model->getStatics();
				$data['count_all_users'] = array_sum(array_column($data['statics'], 'count_users'));
				$data['choose_type'] = $post['choose_type'];
				$data['ranks'] = $this->admin_model->getRanks(false, true);
				
				echo $this->twig->render('views/admin/render/usersmanager/main.tpl', $data);
				break;
			
			case 'get_statics':
				$data['statics'] = $this->admin_model->filterStatics(['u.nickname' => $post['nickname']], ['u.rank' => $post['rank']]);
				$data['count_all_users'] = array_sum(array_column($data['statics'], 'count_users'));
				echo $this->twig->render('views/admin/render/usersmanager/statics.tpl', $data);
				break;
			
			case 'get_users':
				if (!$post['static_id']) exit('0');
				
				
				$params = [
					'where' => [
						'us.static_id' => $post['static_id'],
						'us.main' => 1,
						'deleted' => 0,
						'verification' => 1
					],
					'fields' => 'id nickname avatar static'
				];
				
				if ($post['nickname']) $params['like'] = ['field' => 'u.nickname', 'value' => $post['nickname'], 'placed' => 'after'];
				if ($post['rank']) $params['where']['u.rank'] = $post['rank'];
				
				$users = $this->users->getUsers($params);
				
				if ($users && isset($post['choosed_users_ids']) && $post['choosed_users_ids']) {
					$choosedUsersTemp = array_combine($post['choosed_users_ids'], array_fill(0, count($post['choosed_users_ids']), ['choosed' => 1]));
					$choosedUsers = array_intersect_key($choosedUsersTemp, $users);
					$users = array_replace_recursive($users, $choosedUsers);
				}
				
				$data['users'] = $users;
				$data['choose_type'] = $post['choose_type'];
				
				echo $this->twig->render('views/admin/render/usersmanager/users.tpl', $data);
				break;
			
			case 'get_users_full':
				$usersIds = array_column($post['users'], 'user');
				
				$params = [
					'where' => ['us.main' => 1, 'deleted' => 0, 'verification' => 1],
					'where_in' => ['field' => 'u.id', 'values' => $usersIds]
				];
				
				if ($post['fields']) $params['fields'] = 'id '.$post['fields'];
				if (!$users = $this->users->getUsers($params)) exit('');
				echo json_encode($users);
				break;
			
			
			case 'check_all_users':
				
				$params = [
					'where' => [
						'us.main' => 1,
						'deleted' => 0,
						'verification' => 1
					],
					'fields' => 'id nickname avatar static'
				];
				
				if ($post['nickname']) $params['like'] = ['field' => 'u.nickname', 'value' => $post['nickname'], 'placed' => 'after'];
				if ($post['rank']) $params['where']['u.rank'] = $post['rank'];
				
				$users = $this->users->getUsers($params);
				
				$data = [];
				foreach ($users as $user) {
					$data[] = [
						'user' 	=> $user['id'],
						'static' => $user['static'],
					];
				}
				echo json_encode($data);
				break;
			
			default: break;
		}
		return $data ?: [];
	}
	
	
	
	
	
	
	
	
	/**
	 * Персональные подарки участникам
	 * @param 
	 * @return 
	*/
	public function personalgifts($action = false) {
		if (!$action) return false;
		$post = bringTypes($this->input->post());
		$this->load->model('gifts_model', 'gifts');
		$data = [];
		$data['actions'] = $this->giftsActions;
		$data['sections'] = [
			'bonus' 	=> 'Бонус',
			'personal' 	=> 'Персональный'
		];
		
		switch ($action) {
			case 'get_user_list':
				$data['gifts'] = $this->gifts->personalgifts('get_to_user', $post['user_id']);
				$data['user_id'] = $post['user_id'];
				echo $this->twig->render('views/admin/render/personalgifts/user_list.tpl', $data);
				break;
			
			case 'get':
				$data['gifts'] = $this->gifts->personalgifts('get');
				$data['message'] = $post['message'] ?? false;
				echo $this->twig->render('views/admin/render/personalgifts/list.tpl', $data);
				break;
			
			case 'add':
				if (!$this->gifts->personalgifts('add', $post)) exit('0');
				echo '1';
				break;
			
			case 'change_gift_value':
				if (!$this->gifts->personalgifts('change_gift_value', $post)) exit('0');
				echo '1';
				break;
			
			case 'remove_gift':
				if (!$this->gifts->personalgifts('remove_gift', $post)) exit('0');
				echo '1';
				break;
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function change_user_amount() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if (!isset($data['user_id'])) return false;
		
		$this->load->model(['users_model', 'wallet_model']);
		
		# создал эту функцию, а оказалось, что setToWallet все делает, что нужно
		//if (!$this->users_model->changeUserAmount($data['user_id'], $data['wallet'], $data['summ'], $data['operation'])) exit('0');
		
		
		$operations = [
			'plus' 		=> '+',
			'minus' 	=> '-',
			'exchange' 	=> '-',
		];
		
		$wType = [
			'plus' 		=> 8,
			'minus' 	=> -3,
			'exchange' 	=> -3,
		];
		
		
		$reportTitle = [
			'plus' => 'Начисление на накопительный счет',
			'minus' => 'Списание с накопительного счета',
			'exchange' => 'Списание с накопительного счета',
		];
		
		
		if ($data['wallet'] == 'amount') {
			// тут ничего нет, потому что операций с основным балансом тут нет.
		} elseif ($data['wallet'] == 'cumulative') {
			$this->wallet_model->setToWallet([$data['user_id'] => $data['summ']], $wType[$data['operation']], $reportTitle[$data['operation']], $operations[$data['operation']] ?? false, null, 'cumulative');
			
			if ($data['operation'] == 'exchange') {
				$this->wallet_model->setToWallet([$data['user_id'] => $data['summ']], 8, 'Начисление с накопительного счета', '+');
			}
		}
		
		echo '1';
	}
	
	
	
	
	
	
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function change_users_amounts() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if (!isset($data['users_amounts'])) return false;
		
		$usersAmounts = json_decode($data['users_amounts'], true);
		
		$this->load->model(['users_model', 'wallet_model']);
		
		# создал эту функцию, а оказалось, что setToWallet все делает, что нужно
		//if (!$this->users_model->changeUserAmount($data['user_id'], $data['wallet'], $data['summ'], $data['operation'])) exit('0');
		
		
		$operations = [
			'plus' 		=> '+',
			'minus' 	=> '-',
			'exchange' 	=> '-',
		];
		
		$wType = [
			'plus' 		=> 8,
			'minus' 	=> -3,
			'exchange' 	=> -3,
		];
		
		
		$reportTitle = [
			'plus' => 'Начисление на накопительный счет',
			'minus' => 'Списание с накопительного счета',
			'exchange' => 'Списание с накопительного счета',
		];
		
		
		if ($data['wallet'] == 'amount') {
			// тут ничего нет, потому что операций с основным балансом тут нет.
		} elseif ($data['wallet'] == 'cumulative') {
			foreach ($usersAmounts as $userId => $summ) {
				$this->wallet_model->setToWallet([$userId => $summ], $wType[$data['operation']], $reportTitle[$data['operation']], $operations[$data['operation']] ?? false, null, 'cumulative');
				
				if ($data['operation'] == 'exchange') {
					$this->wallet_model->setToWallet([$userId => $summ], 8, 'Начисление с накопительного счета', '+');
				}
			}
		}
		
		echo '1';
	}
	
	
	
	
	
	
	
	
	
	
	
}