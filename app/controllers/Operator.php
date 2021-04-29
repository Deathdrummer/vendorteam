<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Operator extends MY_Controller {
	
	public $viewsPath = 'views/operator/';
	private $operatorId = false;
	private $operatorData;
	
	public function __construct() {
		parent::__construct();
		$this->load->model(['admin_model', 'operator_model', 'reports_model']);
		$this->operatorId = get_cookie('operator_id'); //$this->session->userdata('operator_id');
		$this->operatorData = $this->operator_model->getOperatorData();
	}
	
	
	
	public function index() {
		if (get_cookie('operator_id')/*$this->session->userdata('operator_id')*/ == false) {
			$this->auth();
		} else {
			if (!$this->operatorData) $this->logout();
			
			$data['nickname'] = $this->operatorData['nickname'];
			$data['avatar'] = $this->operatorData['avatar'];
			$data['access_statics'] = array_intersect_key((array)$this->admin_model->getStatics(), (array)$this->operatorData['statics']);
			$data['access'] = $this->operatorData['access'];
			$data['data_access'] = $this->dataAccess;
			
			$this->twig->display('views/operator/index', $data);
		}
	}
	
	
	
	
	/**
	 * Авторизация в ЛК оператора
	 * @param 
	 * @return 
	 */
	private function auth() {
		if ($this->input->server('REQUEST_METHOD') == 'POST' && !empty($this->input->post('login')) && !empty($this->input->post('password'))) {
			$operatorAuthData = $this->operator_model->getOperatorData(['login' => $this->input->post('login')]);
			$this->load->library('encryption');
			$decodePass = $this->encryption->decrypt($operatorAuthData['password']);
			
			if ($decodePass == $this->input->post('password')) {
				set_cookie('operator_id', $operatorAuthData['id'], 31536000); //$this->session->set_userdata('operator_id', $operatorAuthData['id']);
				redirect('operator');
			} else {
				$this->twig->display('views/operator/auth', ['auth' => 1, 'auth_error' => 1]);
			}
		} else {
			$this->twig->display('views/operator/auth', ['auth' => 1]);
		}
	} 
	
	
	
	
	/**
	 * Выход из ЛК оператора
	 * @param 
	 * @return 
	 */
	public function logout() {
		delete_cookie('operator_id'); //$this->session->unset_userdata('operator_id');
		redirect('operator');
	}
	
	
	
	
	
	/**
	 * Получить данные оператора
	 * @param 
	 * @return 
	 */
	public function get_operator_data() {
		if (!file_exists('public/images/operators/'.$this->operatorData['avatar'])) $this->operatorData['avatar'] = false;
		echo $this->twig->render('views/operator/render/operator_data', $this->operatorData);
	}
	
	
	
	
	
	
	/**
	 * Задать данные оператора
	 * @param 
	 * @return 
	 */
	public function set_operator_data() {
		$postData = bringTypes($this->input->post());
		if (empty($postData) && empty($_FILES)) exit('0');
		$avatar = $this->input->files('operator_avatar');
		
		$jsonData = [];
		if ($postData['operator_nick']) {
			$this->operator_model->setOperatorData(['nickname' => $postData['operator_nick']]);
			$jsonData['nickname'] = $postData['operator_nick'];
		}
		
		
		if ($avatar['error'] == 0) {
			if (is_file('public/images/operators/'.$this->operatorData['avatar'])) {
				unlink('public/images/operators/'.$this->operatorData['avatar']);
			}
			
			if (is_file('public/images/operators/mini/'.$this->operatorData['avatar'])) {
				unlink('public/images/operators/mini/'.$this->operatorData['avatar']);
			}
			
			
			$this->load->library('upload', [
	        	'upload_path' 	=> 'public/images/operators',
	        	'file_name'		=> $this->operatorId,
				'allowed_types'	=> 'gif|jpg|jpeg|png',
				'max_size'  	=> 3000,
				'max_width'   	=> 4000,
				'max_height'   	=> 4000,
				'overwrite'		=> true,
				'quality'		=> 50
	        ]);
	        
	        if (!$this->upload->do_upload('operator_avatar')) {
				$error = array('error' => $this->upload->display_errors());
				exit(json_encode($error));
	        } 
	        
        	$this->operator_model->setOperatorData(['avatar' => $this->upload->data('file_name')]);

			$this->load->library('image_lib', [
				'image_library' 	=> 'gd2',
				'source_image'		=> $this->upload->data('full_path'),
				'maintain_ratio'	=> true,
				'width'        		=> 400,
				'height'      		=> 400
			]);

			$this->image_lib->resize();
			$this->image_lib->clear();
        	$this->image_lib->initialize([
				'image_library' 	=> 'gd2',
				'source_image'		=> $this->upload->data('full_path'),
				'maintain_ratio'	=> true,
				'width'        		=> 60,
				'height'      		=> 60,
				'new_image'			=> 'public/images/operators/mini/'.$this->operatorId.$this->upload->data('file_ext')
			]);
        	$this->image_lib->resize();
        	
        	$jsonData['avatar'] = 'public/images/operators/'.$this->upload->data('file_name');
		}
		
		echo json_encode($jsonData);
	}
	
	
	
	
	
	/**
	 * Вывести контент на страницу
	 * @param Название секции
	 * @return 
	 */
	public function render($section) {
		$data = [];
		$params = $this->input->post() ?: false;
		
		$data['access_statics'] = $this->operatorData['statics'];
		$data['access'] = $this->operatorData['access'];
		
		switch ($section) {
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
				$data['feed_messages'] = $this->admin_model->getFeedMessages(2);
				
				break;
			
			case 'users':
				$this->load->model('users_model');
				$usersData = $this->users_model->getUsers($params);
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanks();
				$data['roles'] = $this->admin_model->getRoles();
				$data['users'] = ['new' => [], 'verify' => [], 'deleted' => []];
				
				if ($usersData) {
					foreach ($usersData as $user) {
						$user['rank'] = isset($data['ranks'][$user['rank']]) ? $data['ranks'][$user['rank']]['name'] : false;
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
			
			case 'accounting':
				$this->load->model('users_model');
				$usersData = $this->users_model->getUsers($params);
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanks();
				$data['roles'] = $this->admin_model->getRoles();
				$data['users'] = [];
				
				if ($usersData) {
					foreach ($usersData as $user) {
						$user['rank'] = isset($data['ranks'][$user['rank']]) ? $data['ranks'][$user['rank']]['name'] : false;
						if ($user['verification'] == 1 && $user['deleted'] == 0) {
							$data['users'][$user['static']][] = $user;
						}
					}
				}
				
				$data['sort_field'] = isset($params['field']) ? $params['field'] : 'u.nickname';
				$data['sort_order'] = isset($params['order']) ? $params['order'] : 'ASC';
				
				break;
				
			case 'paymentrequests':
				$this->load->model('reports_model');
				$data['payment_requests_list'] = []; $paymentRequestsList = false;
				if ($getPaymentRequests = $this->reports_model->getPaymentRequests($params)) {
					$statics = $this->admin_model->getStatics();
					$paymentRequestsList = array_map(function($item) use ($statics) {
						$item['static_name'] = isset($statics[$item['static']]) ? $statics[$item['static']]['name'] : 'Статик не существует';
						$item['static_icon'] = isset($statics[$item['static']]) ? $statics[$item['static']]['icon'] : 'public/images/deleted.jpg';
						unset($item['static']);
						return $item;
					}, $getPaymentRequests);
				}
				
				if ($paymentRequestsList) {
					foreach ($paymentRequestsList as $item) {
						$paid = $item['paid'] == 0 ? 'nopaid' : 'paid';
						$data['payment_requests_list'][$paid][] = $item;
					}
					$data['payment_requests_list']['paid'] = array_slice($data['payment_requests_list']['paid'], 0, 100);
					$data['payment_requests_titles'] = ['nopaid' => 'Не рассчитаны', 'paid' => 'Рассчитаны'];
				}
				break;
			
			case 'messages':
				if ($messages = $this->operator_model->getMessages()) {
					$this->load->helper('string');
					foreach ($messages as $item) {
						$item['message'] = strip_quotes($item['message']);
						
						$data['messages'][$item['type']][$item['stat'] == 0 ? 'actual' : 'archive'][] = $item;
					}
				}
				break;
			
			case 'guides':
				$data['chapters'] = [];
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
				$data['chapters'] = $firstData;
				break;
			
			case 'importantinfo':
				$data['important_info_setting'] = $this->admin_model->getSettings('important_info_setting');
				break;
				
			case 'paymentcomplaint':
				$data['users_list_pay'] = $this->admin_model->getUsersListPay();
				$data['users_list_complaints'] = $this->admin_model->getUsersListComplaints();
				$fieldsNames = $this->admin_model->getSettings(['fields_complaints', 'fields_pay']);
				$data['fields_complaints_setting'] = $fieldsNames['fields_complaints_setting'];
				$data['fields_pay_setting'] = $fieldsNames['fields_pay_setting'];
				break;
			
			case 'personages':
				$data['game_ids'] = $this->admin_model->personagesGetGameIds(true);
				$data['personages'] = $this->admin_model->personagesGet();	
				break;
			
			case 'resigns':
				$data['resigns'] = $this->admin_model->getResigns();
			
			default: 
				break;	
		}
		
		
		echo $this->twig->render('views/operator/sections/'.$section.'.tpl', $data);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------------------- Рейды
	
	
	/**
	 * Формирование первого отчета
	 * @param POST data или нет
	 * @return 
	 */
	public function get_main_report($params = false) {
		if (!$this->input->is_ajax_request() && !$params) return false;
		$postData = $params ?: $this->input->post();
		if ($params) $postData['variant'] = 1;
		
		if (isset($postData['pattern_id'])) {
			$data = $this->operator_model->getMainReportPatterns($postData['pattern_id']);
		} else {
			$postData['cash'] = json_decode($postData['cash'], true);
			$data = $postData;
		}
		
		$data['statics'] = array_keys($this->operatorData['statics']);
		$raidsReportData = $this->_buildMainReport($data);
		
		$raidsReportData['pattern_id'] = isset($postData['pattern_id']) ? $postData['pattern_id'] : null;
		$raidsReportData['raids_types'] = $this->operator_model->getRaidsTypes();
		$raidsReportData['access_statics'] = $this->operatorData['statics'];
		$raidsReportData['access'] = $this->operatorData['access'];
		
		if ($raidsReportData['report']) {
			foreach ($raidsReportData['report'] as $staticId => $sData) {
				$raidsReportData['add_raid_access'][$staticId] = true;
				foreach ($sData['users'] as $user) {
					if (isset($user['pay_done']) && $user['pay_done'] == 1) {
						$raidsReportData['add_raid_access'][$staticId] = false;
						break;
					}
				}	
			}
		}
			
		
		if ($params) return $this->twig->render('views/operator/render/raids_report.tpl', $raidsReportData);
		echo $this->twig->render('views/operator/render/raids_report.tpl', $raidsReportData);
	}
	
	
	
	/**
	 * Формирование данных первого отчета
	 * @param 
	 * @return 
	 */
	private function _buildMainReport($data = false) {
		if (!$data) return false;
		$constants = $this->constants[1];
		return [
			'raids'		=> $this->reports_model->getRaids($data),
			'report'	=> $this->reports_model->buildReportPaymentsData($constants, $data, false)
		];
	}
	
	
	
	
	
	/**
	 * Получение списка статиков для присвоения бюджетов
	 * @param 
	 * @return 
	 */
	public function get_statics_to_cash() {
		if (!$this->input->is_ajax_request()) return false;
		$setCash = json_decode($this->input->post('set_keys_cash'), true);
		echo $this->twig->render('views/operator/render/operator_statics_cash.tpl', ['statics' => $this->operatorData['statics'], 'set_cash' => $setCash]);
	}
	
	
	/**
	 * Получить список периодов
	 * @param 
	 * @return 
	 */
	public function get_reports_periods() {
		$periods = $this->operator_model->getReportsPeriods();
		echo $this->twig->render('views/operator/render/operator_periods_list.tpl', ['periods' => bringTypes($periods)]);
	}
	
	
	
	
	/**
	 * Получить список периодов
	 * @param 
	 * @return 
	 */
	public function get_period() {
		$periodId = $this->input->post('period_id');
		$period = $this->operator_model->getReportsPeriods($periodId);
		echo json_encode($period);
	}
	
	
	
	
	
	/**
	 * Получение списка паттернов для первого отчета
	 * @param 
	 * @return 
	 */
	public function get_main_reports_patterns() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$reportsPatterns = $this->operator_model->getMainReportPatterns(null, $postData);
		echo $this->twig->render('views/operator/render/reports_patterns.tpl', ['reports_patterns' => bringTypes($reportsPatterns)]);
	}
	
	
	
	
	
	/**
	 * Редактировать коэффициент пользователя в рейде
	 * @param 
	 * @return 
	 */
	public function edit_raid_data() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if ($this->operator_model->editRaidKoeff($data['koeffs']) && $this->operator_model->editRaidTypes($data['r_types'])) {
			echo $this->get_main_report($data['report']);
		}
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function delete_raid() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		$this->operator_model->deleteRaid($data['raid_id']);
		unset($data['raid_id']);
		if ($data['is_key']) echo $this->get_keys_report($data);
		else echo $this->get_main_report($data);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------- Ключи
	
	/**
	 * Формирование первого отчета
	 * @param POST data или нет
	 * @return 
	 */
	public function get_keys_report($params = false) {
		if (!$this->input->is_ajax_request() && !$params) return false;
		$postData = $params ?: $this->input->post();
		
		if (isset($postData['pattern_id'])) {
			$data = $this->operator_model->getMainReportPatterns($postData['pattern_id'], null, 1);
		} else {
			$postData['cash'] = json_decode($postData['cash'], true);
			$data = $postData;
		}
		
		$data['statics'] = array_keys($this->operatorData['statics']);
		$keysReportData = $this->_buildKeysReport($data);
		$keysReportData['pattern_id'] = isset($postData['pattern_id']) ? $postData['pattern_id'] : null;
		$keysReportData['keys_types'] = $this->operator_model->getKeysTypes();
		$keysReportData['access_statics'] = $this->operatorData['statics'];
		$keysReportData['access'] = $this->operatorData['access'];
		
		if ($keysReportData['report']) {
			foreach ($keysReportData['report'] as $staticId => $sData) {
				$keysReportData['add_raid_access'][$staticId] = true;
				foreach ($sData['users'] as $user) {
					if (isset($user['pay_done']) && $user['pay_done'] == 1) {
						$keysReportData['add_raid_access'][$staticId] = false;
						break;
					}
				}	
			}
		}
			
		
		if ($params) return $this->twig->render('views/operator/render/keys_report.tpl', $keysReportData);
		echo $this->twig->render('views/operator/render/keys_report.tpl', $keysReportData);
	}
	
	
	
	/**
	 * Формирование данных первого отчета
	 * @param 
	 * @return 
	 */
	private function _buildKeysReport($data) {
		return [
			'raids'		=> $this->reports_model->getKeys($data),
			'report'	=> $this->reports_model->buildReportPaymentsKeysData($data, false)
		];
	}
	
	
	
	
	
	/**
	 * Получение списка статиков для присвоения бюджетов
	 * @param 
	 * @return 
	 */
	/*public function get_statics_to_cash() {
		if (!$this->input->is_ajax_request()) return false;
		$setCash = json_decode($this->input->post('set_cash'), true);
		echo $this->twig->render('views/operator/render/operator_statics_cash.tpl', ['statics' => $this->operatorData['statics'], 'set_cash' => $setCash]);
	}*/
	
	
	/**
	 * Получить список периодов
	 * @param 
	 * @return 
	 */
	/*public function get_reports_periods() {
		$periods = $this->operator_model->getReportsPeriods();
		echo $this->twig->render('views/operator/render/operator_periods_list.tpl', ['periods' => bringTypes($periods)]);
	}*/
	
	
	
	
	/**
	 * Получить список периодов
	 * @param 
	 * @return 
	 */
	/*public function get_period() {
		$periodId = $this->input->post('period_id');
		$period = $this->operator_model->getReportsPeriods($periodId);
		echo json_encode($period);
	}*/
	
	
	
	
	
	/**
	 * Получение списка паттернов для первого отчета
	 * @param 
	 * @return 
	 */
	public function get_keys_reports_patterns() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$reportsPatterns = $this->operator_model->getMainReportPatterns(null, $postData, 1);
		echo $this->twig->render('views/operator/render/reports_patterns.tpl', ['reports_patterns' => bringTypes($reportsPatterns), 'is_key' => 1]);
	}
	
	
	
	
	
	/**
	 * Редактировать коэффициент пользователя в ключе
	 * @param 
	 * @return 
	 */
	public function edit_key_data() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if ($this->operator_model->editRaidKoeff($data['koeffs']) && $this->operator_model->editRaidTypes($data['k_types'])) {
			echo $this->get_keys_report($data['report']);
		}
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	/*public function delete_raid() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		$this->operator_model->deleteRaid($data['raid_id']);
		unset($data['raid_id']);
		echo $this->get_main_report($data);
	}*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------- Заказы
	public function set_orders_report($pId = false) {
		if (!$this->input->is_ajax_request()) return false;
		$periodId = $this->input->post('period_id') ?: $pId;
		$response = $this->operator_model->getRaidsOrders($periodId);
		$response['access_statics'] = $this->operatorData['statics'];
		if ($pId) return $this->twig->render('views/operator/render/raids_orders.tpl', ['orders_data' => $response]);
		echo $this->twig->render('views/operator/render/raids_orders.tpl', ['orders_data' => $response]);
	}
	
	
	
	
	
	/**
	 * Обновить заказ
	 * @param 
	 * @return 
	 */
	public function update_orders() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		$this->operator_model->updateRaidsOrders($data['data']);
		echo 1;
	}
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------- Выходные
	/**
	 * @param 
	 * @return 
	 */
	public function get_offtime_history() {
		$history = $this->input->post('history');
		$this->load->model(['admin_model', 'offtime_model']);
		$data['statics'] = $this->admin_model->getStatics();
		$data['access_statics'] = $this->operatorData['statics'];
		$data['roles'] = $this->admin_model->getRoles();
		$data['roles_limits'] = $this->offtime_model->getRolesLimits();
		
		$startDatePoint = (date('l', time()) == 'Monday') ? strtotime('today '.$history.' week') : strtotime('last Monday of '.$history.' week');
		$data['offtime']['dates'] = getDatesRange($startDatePoint - 604800, 35, 'day');
		$data['offtime']['users'] = $this->offtime_model->getOfftimeUsers();
		$data['offtime']['disabled'] = $this->offtime_model->getOfftimeDisabled();
		$data['current_date'] = strtotime('today');
		echo $this->twig->render('views/operator/render/offtime_history', $data);
	}
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------- Лента новостей
	public function newsfeed_add() {
		$staticId = $this->input->post('static_id');
		echo $this->twig->render('views/operator/render/feed_messages_add.tpl', ['static_id' => $staticId]); //admin
	}
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------- Сообщения и жалобы
	
	/**
	 * Изменить статус сообщения или жалобы
	 * @param 
	 * @return 
	 */
	public function change_message_stat() {
		$data = $this->input->post();
		if (!$this->operator_model->changeMessageStat($data)) exit('0');
		echo json_encode('1');
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Изменить статус расчета с участником
	 * @param 
	 * @return 
	 */
	public function change_paymentrequest_stat() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if (!$this->reports_model->changePaymentrequestStat($data)) exit('0');
		echo json_encode('1');
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
	
	
	
	
	
	
	
	
	
	
	
	
	
}