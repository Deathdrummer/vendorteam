<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Account extends MY_Controller {
	
	private $userData = [];
	private $settings = [];
	private $userId = false;
	
	
	public function __construct() {
		parent::__construct();
		
		$this->load->model(['account_model', 'admin_model']);
		$this->userId = $this->session->userdata('id');
		if (!$this->isset_user() || $this->is_deleted_user()) {
			$this->session->unset_userdata('id');
			if (!$this->input->is_ajax_request()) redirect();
			else exit('0');
		}
		
		$this->settings = $this->admin_model->getSettings();
		$this->userData = $this->account_model->getUserData();
	}
	
	
	
	
	
	
	public function index() {
		// вставляем SVG спрайт
		$this->userData['svg_sparite'] = getSprite('public/svg/sprite.svg');
		
		$this->userData['is_user_info'] = 1;
		if ($this->userData['avatar'] == '' || is_null($this->userData['avatar']) || $this->userData['avatar'] == 'deleted.jpg' || $this->userData['nickname'] == '') {
			$this->userData['is_user_info'] = 0;
		}
		
		$this->userData['is_verify_user'] = $this->is_verify_user();
		$this->userData['is_lider'] = $this->is_lider();
		$this->userData['deposit'] = $this->get_deposit();
		$this->userData['rank'] = $this->get_rank_data();
		$this->userData['pay_method'] = $this->get_pay_method();
		$this->userData['role'] = $this->get_role();
		$this->userData['friends'] = $this->get_friends();
		$this->userData['agreement'] = $this->get_agreement_stat();
		$this->userData['feed_messages'] = $this->admin_model->getFeedMessagesStatic(array_keys($this->userData['statics']));
		
		$outData = array_merge((array)$this->userData, (array)$this->settings);
		
		$this->twig->display('views/account/index.tpl', $outData);
	}
	
	
	
	
	/**
	 * Выйти из личного кабинета
	 * @param 
	 * @return 
	 */
	public function logout() {
		$this->session->unset_userdata('id');
		redirect();
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function guides() {
		$data = [];
		// вставляем SVG спрайт
		$data['svg_sparite'] = getSprite('public/svg/sprite.svg');
		
		$data['chapters'] = false;
		if ($firstData = $this->admin_model->getGuideChapters()) {
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
		}
		
		$this->twig->display('views/account/guides', $data);
	}
	
	
	
	
	
	/**
	 * Получить данные раздела Guides
	 * @param id
	 * @return id parent_id title content
	 */
	public function get_guide_chapter() {
		$id = $this->input->post('id');
		$data = $this->admin_model->getGuideChapter($id);
		echo $data['content'];
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get_account_data() {
		$data = [];
		$data['user_avatar'] = $this->userData['avatar'];
		$data['user_nickname'] = $this->userData['nickname'];
		$data['user_color'] = $this->userData['color'];
		$data['lider'] = $this->input->post('lider');
		
		echo $this->twig->render('views/account/render/user_data', $data);
	}
	
	
	
		
	
	
	
	
	/**
	 * Обновить данные аккаунта
	 * @param 
	 * @return 
	 */
	public function update_account_data() {
		$postData = bringTypes($this->input->post());
		if (empty($postData) && empty($_FILES)) exit('0');
		$avatar = $this->input->files('user_avatar');
		
		$upData = [];
		
		if (isset($postData['user_nick']) && $postData['user_nick']) {
			$upData['nickname'] = $postData['user_nick'];
		} 
		if (isset($postData['user_color']) && $postData['user_color']) {
			$upData['color'] = $postData['user_color'];
		} 
		if ($upData) $this->account_model->setAccountData($upData);
		
		
		if ($avatar['error'] == 0) {
			if (is_file('public/images/users/'.$this->userData['avatar'])) {
				unlink('public/images/users/'.$this->userData['avatar']);
			}
			
			if (is_file('public/images/users/mini/'.$this->userData['avatar'])) {
				unlink('public/images/users/mini/'.$this->userData['avatar']);
			}
			
			$this->load->library('upload', [
	        	'upload_path' 	=> 'public/images/users',
	        	'file_name'		=> $this->userData['id'],
				'allowed_types'	=> 'gif|jpg|jpeg|png',
				'max_size'  	=> 3000,
				'max_width'   	=> 4000,
				'max_height'   	=> 4000,
				'overwrite'		=> true,
				'quality'		=> '50%'
	        ]);
	        
	        if (! $this->upload->do_upload('user_avatar')) {
				$error = array('error' => $this->upload->display_errors());
				exit(json_encode($error));
	        } 
	        
        	$this->account_model->setAccountData(['avatar' => $this->upload->data('file_name')]);

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
				'new_image'			=> 'public/images/users/mini/'.$this->userData['id'].$this->upload->data('file_ext')
			]);
        	$this->image_lib->resize();
        	
        	$upData['avatar'] = 'public/images/users/'.$this->upload->data('file_name');
		}
		
		echo json_encode($upData);
	}
	
	
	
	
	
	
	
	
	/**
	 * Существует ли пользователь
	 * @param 
	 * @return 
	 */
	public function isset_user() {
		return $this->account_model->issetUser();
	} 
	
	
	/**
	 * Верифицирован ли пользователь
	 * @param 
	 * @return 
	 */
	public function is_verify_user() {
		return $this->account_model->isVerifyUser();
	} 
	
	
	
	/**
	 * Удален ли пользователь
	 * @param 
	 * @return 
	 */
	public function is_deleted_user() {
		return $this->account_model->isDeletedUser();
	} 
	
	
	
	/**
	 * Является ли пользователь лидером хотя бы в одном статике
	 * @param 
	 * @return bool
	 */
	public function is_lider() {
		if (!isset($this->userData['statics']) || empty($this->userData['statics'])) return 0;
		$isLider = false;
		foreach ($this->userData['statics'] as $id => $sData) {
			if ($sData['lider'] == 1) {
				$isLider = true;
				break;
			} 
		}
		return $isLider;
	}
	
	
	
	
	
	
	/**
	 * Получить список статиков участника
	 * @param 
	 * @return 
	 */
	public function get_statics() {
		if (!isset($this->userData['statics']) || empty($this->userData['statics'])) exit('');
		$attrName = $this->input->post('attr') ?: false;
		$statics = [];
		foreach ($this->userData['statics'] as $id => $sData) {
			$statics[$id] = [
				'name' => $sData['name'],
				'icon' => $sData['icon']
			];
		}
		echo $this->twig->render('views/account/render/statics', ['statics' => $statics, 'attr' => $attrName]);
	}
	
	
	
	
	
	/**
	 * Получить список цветов для рейдеров
	 * @param 
	 * @return 
	 */
	public function get_raiders_colors() {
		$raidersColors = $this->account_model->getRaidersColors();
		$attrName = $this->input->post('attr') ?: false;
		echo $this->twig->render('views/account/render/raiders_colors', ['raiders_colors' => $raidersColors, 'attr' => $attrName]);
	}
	
	
	
	
	
	
	/**
	 * Получить список статиков, в которых участник - лидер
	 * @param 
	 * @return 
	 */
	public function get_lider_statics() {
		if (!isset($this->userData['statics']) || empty($this->userData['statics']) || !$this->is_lider()) exit('');
		$attrName = $this->input->post('attr') ?: false;
		$liderStatics = [];
		foreach ($this->userData['statics'] as $id => $sData) {
			if ($sData['lider'] == 1) $liderStatics[$id] = $sData['name'];
		}
		echo $this->twig->render('views/account/render/statics', ['statics' => $liderStatics, 'attr' => $attrName]);
	}
	
	
	
	
	
	
	/**
	 * Получить Резерв пользователя
	 * @param 
	 * @return 
	 */
	public function get_deposit() {
		return $this->account_model->getDeposit();
	}
	
	
	
	
	
	/**
	 * Получить звание и количество дней до присвоения следующего звания
	 * @param 
	 * @return 
	 */
	public function get_rank_data() {
		$rankName = $this->account_model->getRankData();
		$nextRank = $this->account_model->getNextRankData();
		
		return [
			'rank_name' => $rankName,
			'next_rank' => $nextRank
		];
	}
	
	
	
	
	
	/**
	 * Получить способ оплаты участнику
	 * @param 
	 * @return 
	 */
	public function get_pay_method() {
		$nextRank = $this->account_model->getPayMethod();
	}
	
	
	
	
	
	/**
	 * Получить роль пользователя
	 * @param 
	 * @return 
	 */
	public function get_role() {
		return $this->account_model->getRoleName();
	}
	
	
	
	
	
	/**
	 * Получить статус соглашения с договором
	 * @param 
	 * @return 
	 */
	public function get_agreement_stat() {
		if (! $this->input->is_ajax_request()) {
			return $this->account_model->getAgreementStat();
		} else {
			echo $this->account_model->getAgreementStat() ? 0 : 1;
		}
	}
	
	
	
	
	
	/**
	 * Получить важную информацию
	 * @param 
	 * @return 
	 */
	public function get_important_info() {
		$info = $this->admin_model->getSettings('important_info') ?: '';
		echo $this->twig->render('views/account/render/important_info', ['info' => $info]);
	}
	
	
	
	
	
	
	/**
	 * Получить содержание договора
	 * @param 
	 * @return 
	 */
	public function get_agreement_data($ajax = true) {
		$data = '';
		if ($this->is_lider()) {
			$agreementData = $this->admin_model->getSettings('agreement_liders');
		} else {
			$agreementData = $this->admin_model->getSettings('agreement');
		}
		
		if (!$ajax) return $agreementData;
		echo $agreementData;
	}
	
	
	
	
	
	
	/**
	 * Установить статус соглашения с договором
	 * @param 
	 * @return 
	 */
	public function set_agreement_stat() {
		$stat = $this->input->post('stat');
		echo $this->account_model->setAgreementStat($stat);
	}
	
	
	
	
	
	/**
	 * Важная информация
	 * @param 
	 * @return 
	 */
	public function get_info() {
		$agreement = $this->get_agreement_data(false);
		$info = $this->admin_model->getSettings('important_info');
		$isLider = $this->is_lider();
		
		foreach ($info as $k => $item) {
			if (!$item['stat']) unset($info[$k]);
			if (!isset($item['for'])) continue;
			if ($item['for'] == 3 && !$isLider) unset($info[$k]);
			if ($item['for'] == 2 && $isLider) unset($info[$k]);
		}
		
		echo $this->twig->render('views/account/render/important_info', ['agreement' => $agreement, 'info' => array_values($info)]);
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить настройки
	 * @param 
	 * @return 
	 */
	public function get_settings() {
		if (!$this->input->is_ajax_request()) return false;
		echo json_encode($this->admin_model->getSettings());
	}
	
	
	
	
	
	/**
	 * Получить список пользователей статиков
	 * @param 
	 * @return array [static ID => data]
	 */
	public function get_friends() {
		$friends = $this->account_model->getUsers(false, ['verification' => 1, 'deleted' => 0/*, 'agreement' => 1*/], false, true);
		return $friends;
	}
	
	
	
	
	
	
	/**
	 * Получить данные для создания рейда
	 * @param 
	 * @return 
	 */
	public function get_new_raid_data() {
		$this->load->model('users_model');
		$postData = $this->input->post();
		$staticUsers = $this->account_model->getUsers($postData['static'], ['verification' => 1, 'deleted' => 0/*, 'agreement' => 1*/], true);
		$raidsTypes = $this->account_model->getRaidsTypes();
		$adminUsers = $this->getAdminUsers();
		$offtimeUsers = $this->users_model->getOfftimeUsers($postData['static']);
		echo $this->twig->render('views/account/render/new_raid', ['users' => $staticUsers, 'offtime_users' => $offtimeUsers, 'admin_users' => $adminUsers, 'raids_types' => $raidsTypes, 'period' => $postData['period']]);
	}
	
	
	
	
	
	/**
	 * Получить данные для создания ключа
	 * @param 
	 * @return 
	 */
	public function get_new_key_data() {
		$this->load->model('users_model');
		$postData = $this->input->post();

		$staticUsers = $this->account_model->getUsers($postData['static'], ['verification' => 1, 'deleted' => 0/*, 'agreement' => 1*/], true);
		$keysTypes = $this->account_model->getKeysTypes();
		$adminUsers = $this->getAdminUsers();
		$offtimeUsers = $this->users_model->getOfftimeUsers($postData['static']);
		echo $this->twig->render('views/account/render/new_key', [
			'users' 			=> $staticUsers,
			'offtime_users' 	=> $offtimeUsers,
			'admin_users' 		=> $adminUsers,
			'keys_types' 		=> $keysTypes,
			'period' 			=> $postData['period']
		]);
	}
	
	
	
	
	
	
	/**
	 * Получить список периодов для состава команды
	 * @param 
	 * @return 
	 */
	public function get_reports_periods() {
		if (!$this->input->is_ajax_request()) return false;
		$this->load->model('reports_model');
		$reportsPeriods = $this->reports_model->getReportsPeriods(true);
		echo $this->twig->render('views/account/render/reports_periods.tpl', ['periods' => $reportsPeriods]);
	}
	
	
	
	
	/**
	 * Получить пользователей для состава команды
	 * @param 
	 * @return 
	 */
	public function get_users_to_compound() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$data = $this->account_model->getUsersToCompound($postData);
		$raidsTypes = $this->admin_model->getRaidsTypes();
		echo $this->twig->render('views/account/render/compound_users', ['compounds_data' => $data['compounds_data'], 'raids' => $data['raids'], 'is_lider' => $postData['is_lider'], 'raids_types' => $raidsTypes]);
	}
	
	
	
	
	/**
	 * Получить пользователей для ключей
	 * @param 
	 * @return 
	 */
	public function get_users_to_keys() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$data = $this->account_model->getUsersToKeys($postData);
		echo $this->twig->render('views/account/render/keys_users', [
			'keys_data' 		=> $data['keys_data'],
			'keys_types' 		=> $this->account_model->getKeysTypes(),
			'keys' 				=> $data['keys'],
			'summ_koeff'		=> $data['summ_koeff'], 
			'all_summ_koeff'	=> $data['all_summ_koeff'], 
			'is_lider' 			=> $postData['is_lider']
		]);
	}
	
	
	
	/**
	 * Получить типы рейдов
	 * @param 
	 * @return 
	 */
	public function get_raids_types() {
		if (!$this->input->is_ajax_request()) return false;
		echo json_encode($this->account_model->getRaidsTypes());
	}
	
	
	
	
	
	/**
	 * Добавить рейд
	 * @param 
	 * @return 
	 */
	public function add_raid() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		echo json_encode($this->account_model->addRaid($postData));
	}
	
	
	
	/**
	 * Добавить ключ
	 * @param 
	 * @return 
	 */
	public function add_key() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		echo json_encode($this->account_model->addKey($postData));
	}
	
	
	
	
	
	
	/**
	 * Редактировать коэффициент пользователя в рейде
	 * @param 
	 * @return 
	 */
	public function edit_key_data() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if ($this->account_model->editKeyKoeff($data['koeffs']) && $this->account_model->editKeyTypes($data['k_types'])) echo '1';
		else echo 0;
	}
	
	
	
	
	
	
	
	/**
	 * Обновить состав команды
	 * @param 
	 * @return 
	 */
	public function set_compound() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
	
		
		$this->account_model->editRaidKoeff(json_decode($data['koeffs'], true));
		$this->account_model->editRaidTypes(json_decode($data['r_types'], true));
		
		echo json_encode($this->account_model->setCompound($data['compound_users'], $data['period_id'], $data['static_id']));
	}	
	
	
	
	
	
	
	
	
	/**
	 * Получить активный период
	 * @param 
	 * @return 
	 */
	public function get_active_period($static = false) {
		if (!$static = $this->input->post('static')) return false;
		$activeperiod = $this->account_model->getActiveReportsPeriod($static);
		echo json_encode($activeperiod);
	}
	
	
	
	
	
	
	
	/** Получить список операторов для ЛК
	 * @param 
	 * @return 
	 */
	public function get_operators() {
		if (!$this->input->is_ajax_request()) return false;
		$operators = $this->account_model->getOperators();
		echo $this->twig->render('views/account/render/operators_list', ['operators' => $operators]);
	}
	
	
	
	/**
	 * Написать сообщение оператору
	 * @param 
	 * @return 
	 */
	public function operator_new_mess() {
		$type = $this->input->post('type');
		$operatorId = $this->input->post('id');
		$operatorNickname = $this->input->post('nickname');
		echo $this->twig->render('views/account/render/mess_to_operator', ['type' => $type, 'id' => $operatorId, 'nickname' => $operatorNickname]);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function operator_send_mess() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		$data['from'] = $this->userData['id'];
		if ($this->account_model->operatorSendMess($data)) exit('1');
		echo json_encode('0');
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить статисьтку по средней зарплате
	 * @param 
	 * @return 
	 */
	public function statistics_get() {
		$userId = $this->userData['id'];
		$staticMain = $this->userData['main_static'];
		$cash = $this->userData['statistics_cash'];
		$days = $this->userData['statistics_days'];
		
		$data['static'] = [
			'name'	=> $this->userData['statics'][$staticMain]['name'],
			'icon'	=> $this->userData['statics'][$staticMain]['icon']
		];
		
		$paySelf = ((float)$cash != 0 && (float)$days != 0) ? (float)$cash / (float)$days * 30.437 : false;
		$data['statistics']['self'] = [
			'user_id'	=> $userId,
			'nickname'	=> $this->userData['nickname'],
			'avatar'	=> $this->userData['avatar'],
			'pay'		=> $paySelf
		];
		
		$data['statistics']['lider'] = $this->account_model->statisticsGet($staticMain);
		$data['statistics']['customer'] = false;

		if ($customerId = $this->settings['statistics_setting'][$staticMain]['customer']['id']) {
			$this->load->model('users_model');
			$customUser = $this->users_model->getUsers(['where' => ['u.id' => $customerId]]);
			$customerCash = (float)$customUser[0]['statistics_cash'];
			$customerDays = (float)$customUser[0]['statistics_days'];
			$payCustomer = ((float)$customerCash != 0 && (float)$customerDays != 0) ? (float)$customerCash / (float)$customerDays * 30.437 : false;
			$data['statistics']['customer'] = [
				'user_id'	=> $customUser[0]['id'],
				'nickname'	=> $customUser[0]['nickname'],
				'avatar'	=> $customUser[0]['avatar'],
				'pay'		=> $payCustomer
			];
		}
		
		$selfId = $data['statistics']['self']['user_id'];
		$liderId = $data['statistics']['lider']['user_id'];
		$customerId = $data['statistics']['customer']['user_id'];
		
		if ($selfId == $liderId || $selfId == $customerId) unset($data['statistics']['self']);
		if ($liderId == $customerId) unset($data['statistics']['lider']);
		
		$data['text'] = $this->settings['statistics_setting'][$staticMain]['text'];
		$data['image'] = $this->settings['statistics_setting'][$staticMain]['image'];
		
		echo $this->twig->render('views/account/render/statistics.tpl', $data);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Функция работы с персонажами
	 * @param 
	 * @return 
	 */
	public function personages($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		
		switch ($action) {
			case 'main':
				$gameIds = $this->account_model->personagesGetGamesIds() ?: [];
				echo $this->twig->render('views/account/render/personages/main.tpl', ['games_ids' => $gameIds]);
				break;
			
			case 'get':
				$personages = $this->account_model->personagesGet(false, true) ?: [];
				echo $this->twig->render('views/account/render/personages/list.tpl', ['personages' => $personages]);
				break;
			
			case 'add':
				echo $this->twig->render('views/account/render/personages/new.tpl');
				break;
			
			case 'save':
				$fields = $this->input->post('fields');
				$fieldsToItem = $this->input->post('fields_to_item');
				if ($insertId = $this->account_model->personagesSave($fields)) {
					$fieldsToItem['id'] = $insertId; 
					echo $this->twig->render('views/account/render/personages/saved.tpl', $fieldsToItem);
				} else echo '';
				break;
				
			case 'update':
				$fields = $this->input->post('fields');
				$id = $this->input->post('id');
				if ($this->account_model->personagesUpdate($id, $fields)) echo '1';
				else echo '';
				break;
			
			case 'remove':
				$id = $this->input->post('id');
				if ($this->account_model->personagesRemove($id)) {
					echo '1';
				} else echo '0'; 
				break;
			
			default:
				echo '';
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get_payment_requests() {
		$paymentRequestsData = [];
		if ($getPaymentRequests = $this->account_model->getPaymentRequests()) {
			$statics = $this->admin_model->getStatics();
			
			$paymentRequestsList = array_map(function($item) use ($statics) {
				$item['static_name'] = isset($statics[$item['static']]) ? $statics[$item['static']]['name'] : 'Статик удален';
				$item['static_icon'] = isset($statics[$item['static']]) ? $statics[$item['static']]['icon'] : '';
				unset($item['static']);
				return $item;
			}, (array)$getPaymentRequests);
			
			foreach ($paymentRequestsList as $item) {
				$paid = $item['paid'] == 0 ? 'nopaid' : 'paid';
				$paymentRequestsData[$paid][] = $item;
			}
			$paymentRequestsData['paid'] = isset($paymentRequestsData['paid']) ? array_slice($paymentRequestsData['paid'], 0, 100) : false;
		}
		
		$usersListPay = $this->admin_model->getUsersListPay($this->userData['id']);
		
		echo $this->twig->render('views/account/render/payment_requests.tpl', [
			'payment_requests_list' 	=> $paymentRequestsData,
			'payment_requests_titles' 	=> ['nopaid' => 'Не рассчитаны', 'paid' => 'Рассчитаны'],
			'users_list_pay'			=> $usersListPay,
			'fields_pay_setting'		=> $this->admin_model->getSettings('fields_pay')
		]);
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Изменить цвет пользователя
	 * @param 
	 * @return 
	 */
	public function change_user_color() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		$this->load->model('users_model');
		if ($this->users_model->changeUserColor($data['user_id'], $data['color'])) echo '1';
		else echo '';
	}
	
	
	
	
	
	
	
}