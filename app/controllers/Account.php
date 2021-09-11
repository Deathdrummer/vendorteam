<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Account extends MY_Controller {
	
	private $userData = [];
	private $settings = [];
	private $userId = false;
	
	
	public function __construct() {
		parent::__construct();
		
		$this->load->model(['account_model' => 'account', 'admin_model' => 'admin']);
		$this->userId = get_cookie('id'); //$this->session->userdata();
		if (!$this->isset_user() || $this->is_deleted_user()) {
			delete_cookie('id'); //$this->session->unset_userdata('id');
			if (!$this->input->is_ajax_request()) redirect();
			else exit('0');
		}
		
		$this->settings = $this->admin->getSettings();
		$this->userData = $this->account->getUserData();
	}
	
	
	
	
	public function index() {
		// вставляем SVG спрайт
		$this->userData['svg_sparite'] = getSprite('public/svg/sprite.svg');
		
		$this->load->model(['wallet_model' => 'wallet', 'gifts_model' => 'gifts', 'mininewsfeed_model' => 'mininewsfeed']);
		
		$this->userData['set_rating_statics'] = $this->account->getRatingNotifications();
		
		$this->account->getUserRating();
		
		$this->userData['is_user_info'] = 1;
		if ($this->userData['avatar'] == '' || is_null($this->userData['avatar']) || $this->userData['avatar'] == 'deleted.jpg' || $this->userData['nickname'] == '') {
			$this->userData['is_user_info'] = 0;
		}
		
		$this->userData['is_verify_user'] = $this->is_verify_user();
		$this->userData['is_lider'] = $this->is_lider();
		$this->userData['deposit'] = $this->get_deposit();
		$this->userData['rating'] = $this->account->getUserRating(true);
		$this->userData['rank'] = $this->get_rank_data();
		$this->userData['pay_method'] = $this->get_pay_method();
		$this->userData['role'] = $this->get_role();
		$this->userData['friends'] = $this->get_friends();
		$this->userData['agreement'] = $this->get_agreement_stat();
		$this->userData['feed_messages'] = $this->admin->getFeedMessagesStatic(array_keys($this->userData['statics']));
		$this->userData['balance'] = $this->wallet->getUserBalance($this->userData['id']);
		$this->userData['mini_newsfeed'] = $this->mininewsfeed->getNewsFeedList();
		
		
		//------------------------------------------ задать куки если накопленный процент больше или равен заданному проценту
		$userGiftsPercent = $this->gifts->getUserPercent($this->userData['id']);
		if ($userGiftsPercent >= $this->settings['gift_min_percents_setting']) {
			$this->gifts->generateGifts($this->userData['id'], 'bonus');
		}
		
		if ($countGifts = $this->gifts->hasUserGifts($this->userData['id'])) {
			set_cookie('gifts', $countGifts, 0);
		} else {
			delete_cookie('gifts');
		}
		
		if ($this->account->hasBirthDay()) {
			set_cookie('birthday', 1, 0);
		}
		
		
		
		$this->userData['is_resignation'] = $this->account->isResignation();
		$this->userData['resign_notify'] = $this->account->getResignNotifiy();
		
		$outData = array_merge((array)$this->userData, (array)$this->settings);
		
		$this->twig->display('views/account/index.tpl', $outData);
	}
	
	
	
	
	/**
	 * Выйти из личного кабинета
	 * @param 
	 * @return 
	*/
	public function logout() {
		delete_cookie('id'); //$this->session->unset_userdata('id');
		delete_cookie('token'); //$this->session->unset_userdata('token');
		redirect();
	}
	
	
	
	
	
	
	
	
	/**
	 * Увольнение
	 * @param 
	 * @return 
	*/
	public function resign($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$postData = bringTypes($this->input->post());
		switch ($action) {
			case 'get_form':
				$date = strtotime('+14 day', time());
				$data = [
					'current_date'			=> date('Y-m-d', time()),
					'current_date_format'	=> date('j', time()).' '.$this->monthes[date('n', time())].' '.date('Y', time()).' г.',
					'last_date'				=> date('Y-m-d', $date),
					'last_date_format'		=> date('j', $date).' '.$this->monthes[date('n', $date)].' '.date('Y', $date).' г.',
				];
				$data['resign_text'] = isset($this->settings['resign_popup_text_setting']) ? $this->settings['resign_popup_text_setting'] : '';
				echo $this->twig->render('views/account/render/resign_form', $data);
				break;
			
			case 'calc_enddate':
				$date = strtotime('+14 day', strtotime($postData['date']));
				$data = [
					'current_date'			=> date('Y-m-d', strtotime($postData['date'])),
					'last_date'				=> date('Y-m-d', $date),
					'last_date_format'		=> date('j', $date).' '.$this->monthes[date('n', $date)].' '.date('Y', $date).' г.',
				];
				echo json_encode($data);
				break;
			
			case 'set_resign':
				$data = [
					'user_id'		=> $this->userData['id'],
					'reason'		=> $postData['reason'],
					'comment'		=> $postData['comment'],
					'date_add'		=> time(),
					'date_resign'	=> strtotime($postData['date_resign']),
					'date_last'		=> strtotime($postData['date_last'])
				];
				
				if (!$this->account->setResign($data)) exit('0');
				echo '1';
				break;
			
			default:
				break;
		}
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
		if ($firstData = $this->admin->getGuideChapters()) {
			foreach ($firstData as $fkey => $first) {
				if (!$secondData = $this->admin->getGuideChapters($first['id'])) continue;
				foreach ($secondData as $skey => $second) {
					if (!$thirdData = $this->admin->getGuideChapters($second['id'])) continue;
					foreach ($thirdData as $tkey => $third) {
						if (!$forthData = $this->admin->getGuideChapters($third['id'])) continue;
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
		$data = $this->admin->getGuideChapter($id);
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
		if ($upData) $this->account->setAccountData($upData);
		
		
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
			
			$this->account->setAccountData(['avatar' => $this->upload->data('file_name')]);

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
		return $this->account->issetUser();
	} 
	
	
	/**
	 * Верифицирован ли пользователь
	 * @param 
	 * @return 
	 */
	public function is_verify_user() {
		return $this->account->isVerifyUser();
	} 
	
	
	
	/**
	 * Удален ли пользователь
	 * @param 
	 * @return 
	 */
	public function is_deleted_user() {
		return $this->account->isDeletedUser();
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
		$raidersColors = $this->account->getRaidersColors();
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
		return $this->account->getDeposit();
	}
	
	
	
	
	/**
	 * Получить Рейтинг пользователя
	 * @param 
	 * @return 
	 */
	public function get_rating() {
		$rating = $this->account->getUserRating();
		$rating['rating_desc'] = $this->settings['rating_desc_setting'];
		echo $this->twig->render('views/account/render/rating', $rating);
	}
	
	
	
	
	
	
	/**
	 * Получить звание и количество дней до присвоения следующего звания
	 * @param 
	 * @return 
	 */
	public function get_rank_data() {
		$rankName = $this->account->getRankData();
		$nextRank = $this->account->getNextRankData();
		
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
		$nextRank = $this->account->getPayMethod();
	}
	
	
	
	
	
	/**
	 * Получить роль пользователя
	 * @param 
	 * @return 
	 */
	public function get_role() {
		return $this->account->getRoleName();
	}
	
	
	
	
	
	/**
	 * Получить статус соглашения с договором
	 * @param 
	 * @return 
	 */
	public function get_agreement_stat() {
		if (! $this->input->is_ajax_request()) {
			return $this->account->getAgreementStat();
		} else {
			echo $this->account->getAgreementStat() ? 0 : 1;
		}
	}
	
	
	
	
	
	/**
	 * Получить важную информацию
	 * @param 
	 * @return 
	 */
	public function get_important_info() {
		$info = $this->admin->getSettings('important_info') ?: '';
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
			$agreementData = $this->admin->getSettings('agreement_liders');
		} else {
			$agreementData = $this->admin->getSettings('agreement');
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
		echo $this->account->setAgreementStat($stat);
	}
	
	
	
	
	
	/**
	 * Важная информация
	 * @param 
	 * @return 
	 */
	public function get_info() {
		$agreement = $this->get_agreement_data(false);
		$info = $this->admin->getSettings('important_info');
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
		echo json_encode($this->admin->getSettings());
	}
	
	
	
	
	
	/**
	 * Получить список пользователей статиков
	 * @param 
	 * @return array [static ID => data]
	 */
	public function get_friends() {
		$friends = $this->account->getUsers(false, ['verification' => 1, 'deleted' => 0, 'excluded' => 0], false, true);
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
		$staticUsers = $this->account->getUsers($postData['static'], ['verification' => 1, 'deleted' => 0, 'excluded' => 0], true);
		$raidsTypes = $this->account->getRaidsTypes();
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

		$staticUsers = $this->account->getUsers($postData['static'], ['verification' => 1, 'deleted' => 0/*, 'agreement' => 1*/], true);
		$keysTypes = $this->account->getKeysTypes();
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
		$post = bringTypes($this->input->post());
		$attr = isset($post['attr']) ? $post['attr'] : null;
		$onlyOpened = isset($post['only_opened']) ? $post['only_opened'] : true;
		$showToVisits = isset($post['to_visits']) ? $post['to_visits'] : false;
		$reportsPeriods = $this->reports_model->getReportsPeriods($onlyOpened, $showToVisits);
		echo $this->twig->render('views/account/render/reports_periods.tpl', ['periods' => $reportsPeriods, 'attr' => $attr]);
	}
	
	
	
	
	/**
	 * Получить пользователей для состава команды
	 * @param 
	 * @return 
	 */
	public function get_users_to_compound() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$data = $this->account->getUsersToCompound($postData);
		$raidsTypes = $this->admin->getRaidsTypes();
		
		$settings = isset($this->settings['compound_users_setting'][$postData['static_id']]) ? $this->settings['compound_users_setting'][$postData['static_id']] : null;
		echo $this->twig->render('views/account/render/compound_users', ['compounds_data' => $data['compounds_data'], 'raids' => $data['raids'], 'is_lider' => $postData['is_lider'], 'raids_types' => $raidsTypes, 'settings' => $settings]);
	}
	
	
	
	
	/**
	 * Получить пользователей для ключей
	 * @param 
	 * @return 
	 */
	public function get_users_to_keys() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$data = $this->account->getUsersToKeys($postData);
		echo $this->twig->render('views/account/render/keys_users', [
			'keys_data' 		=> $data['keys_data'],
			'keys_types' 		=> $this->account->getKeysTypes(),
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
		echo json_encode($this->account->getRaidsTypes());
	}
	
	
	
	
	
	/**
	 * Добавить рейд
	 * @param 
	 * @return 
	 */
	public function add_raid() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		echo json_encode($this->account->addRaid($postData));
	}
	
	
	
	/**
	 * Добавить ключ
	 * @param 
	 * @return 
	 */
	public function add_key() {
		if (!$this->input->is_ajax_request()) return false;
		$postData = bringTypes($this->input->post());
		echo json_encode($this->account->addKey($postData));
	}
	
	
	
	
	
	
	/**
	 * Редактировать коэффициент пользователя в рейде
	 * @param 
	 * @return 
	 */
	public function edit_key_data() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if ($this->account->editKeyKoeff($data['koeffs']) && $this->account->editKeyTypes($data['k_types'])) echo '1';
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
	
		
		$this->account->editRaidKoeff(json_decode($data['koeffs'], true));
		$this->account->editRaidTypes(json_decode($data['r_types'], true));
		
		echo json_encode($this->account->setCompound($data['compound_users'], $data['period_id'], $data['static_id']));
	}	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function edit_raid_koeff() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		if (!$this->account->editRaidKoeff($data, true)) exit('0');
		echo '1';
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function edit_raid_type() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		if (!$this->account->editRaidTypes($data, true)) exit('0');
		echo '1';
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function set_compound_item() {
		if (!$this->input->is_ajax_request()) return false;
		$data = bringTypes($this->input->post());
		if (!$this->account->setCompoundItem($data)) exit('0');
		echo '1';
	}
	
	
	// $periodId = false, $staticId = false, $userId == false, $compoundData = false
	
	
	
	
	
	/**
	 * Получить активный период
	 * @param 
	 * @return 
	 */
	public function get_active_period($static = false) {
		if (!$static = $this->input->post('static')) return false;
		$activeperiod = $this->account->getActiveReportsPeriod($static);
		echo json_encode($activeperiod);
	}
	
	
	
	
	
	
	
	/** Получить список операторов для ЛК
	 * @param 
	 * @return 
	 */
	public function get_operators() {
		if (!$this->input->is_ajax_request()) return false;
		$operators = $this->account->getOperators();
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
		if ($this->account->operatorSendMess($data)) exit('1');
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
		
		$data['statistics']['lider'] = $this->account->statisticsGet($staticMain);
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
	 * Наставничество
	 * @param 
	 * @return 
	 */
	public function mentors($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$postData = bringTypes($this->input->post());
		switch ($action) {
			case 'get':
				$mentors = $this->account->getMentors();
				echo $this->twig->render('views/account/render/mentors.tpl', ['mentors' => $mentors]);
				break;
			
			case 'show_classes': //отобразить классы ментора
				echo $this->twig->render('views/account/render/mentors_classes.tpl', ['classes' => json_decode($postData['classes'], true)]);
				break;
			
			case 'add_request': // кинуть заявку
				$this->load->model('users_model');
				$mainStaticId = $this->users_model->getMainStaticId($postData['mentor_id']);
				
				$addRequestData = [
					'user_id'		=> $this->userData['id'],
					'user_static'	=> $this->userData['main_static'],
					'mentor_id'		=> $postData['mentor_id'],
					'mentor_static'	=> $mainStaticId,
					'class'			=> $postData['class_id'],
					'date'			=> time()
				];
				
				if (!$this->account->addMentorsRequest($addRequestData)) exit('0');
				echo '1';
				break;
			
			default:
				break;
		}
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
				$gameIds = $this->account->personagesGetGamesIds() ?: [];
				echo $this->twig->render('views/account/render/personages/main.tpl', ['games_ids' => $gameIds]);
				break;
			
			case 'get':
				$personages = $this->account->personagesGet(false, true) ?: [];
				echo $this->twig->render('views/account/render/personages/list.tpl', ['personages' => $personages]);
				break;
			
			case 'add':
				echo $this->twig->render('views/account/render/personages/new.tpl');
				break;
			
			case 'save':
				$fields = $this->input->post('fields');
				$fieldsToItem = $this->input->post('fields_to_item');
				if ($insertId = $this->account->personagesSave($fields)) {
					$fieldsToItem['id'] = $insertId; 
					echo $this->twig->render('views/account/render/personages/saved.tpl', $fieldsToItem);
				} else echo '';
				break;
				
			case 'update':
				$fields = $this->input->post('fields');
				$id = $this->input->post('id');
				if ($this->account->personagesUpdate($id, $fields)) echo '1';
				else echo '';
				break;
			
			case 'remove':
				$id = $this->input->post('id');
				if ($this->account->personagesRemove($id)) {
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
		if ($getPaymentRequests = $this->account->getPaymentRequests()) {
			
			$statics = $this->admin->getStatics();
			
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
		
		$usersListPay = $this->admin->getUsersListPay($this->userData['id']);
		
		echo $this->twig->render('views/account/render/payment_requests.tpl', [
			'payment_requests_list' 	=> $paymentRequestsData,
			'payment_requests_titles' 	=> ['nopaid' => 'Не рассчитаны', 'paid' => 'Рассчитаны'],
			'users_list_pay'			=> $usersListPay,
			'fields_pay_setting'		=> $this->admin->getSettings('fields_pay')
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------- рейтинг
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get_users_for_rating() {
		if (!$this->input->is_ajax_request()) return false;
		$staticId = $this->input->post('static_id');
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
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save_data_for_rating() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if (!$this->account->saveDataForRating($data)) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	
	
	/**
	 * Напомнить о выставлении коэффициентов для рейтинга
	 * @param 
	 * @return 
	*/
	public function get_rating_notifications() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		echo $this->twig->render('views/account/render/rating_notifications.tpl', $data);
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить коэффициенты посещаемости
	 * @param 
	 * @return 
	*/
	public function get_visits_coeffs() {
		if (!$this->input->is_ajax_request()) return false;
		$periodId = $this->input->post('period_id');
		$accountStatics = isset($this->userData['statics']) ? array_keys($this->userData['statics']) : false;
		if (!$accountStatics) exit('0');
		
		$data = [];
		foreach ($accountStatics as $static) {
			$data[$static] = $this->account->getVisitsCoeffs(['period_id' => $periodId, 'static_id' => $static]);
		}
		
		$raidsTypes = $this->admin->getRaidsTypes();
		
		echo $this->twig->render('views/account/render/visits_coeffs', ['coeffs_data' => $data, 'raids_types' => $raidsTypes, 'statics' => $this->userData['statics']]);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Моя премия
	 * @param 
	 * @return 
	*/
	public function rewards($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$this->load->model('rewards_model', 'rewards');
		switch ($action) {
			case 'get_periods':
				
				$rewardsPeriods = $this->rewards->getRewardsPeriods();
				//toLog($rewardsPeriods);
				echo $this->twig->render('views/account/render/rewards/periods_list.tpl', ['periods' => $rewardsPeriods]);
				break;
			
			case 'get_report':
				$rewardPeriodId = $this->input->post('period_id');
				$staticId = $this->input->post('static_id');
				
				$periodData = $this->rewards->getPeriod($rewardPeriodId);
				$summData = $this->rewards->getTotalStaticSumm($rewardPeriodId, $staticId);
				
				
				$data['cash'][$staticId] = $summData;
				$data['period_id'] = $periodData['reports_periods'];
				$data['variant'] = 2;
				$data['statics'] = [$staticId];
				$data['ranks'] = $this->rewards->getRewardsRanks($rewardPeriodId);
				
				$this->load->model('reports_model', 'reports');
				$mainReportData = $this->reports->buildReportPaymentsData($this->constants[2], $data, false);
				$total = $mainReportData[$staticId]['users'][$this->userData['id']]['payment'];
				
				echo $this->twig->render('views/account/render/rewards/total_summ.tpl', ['total' => $total, 'period' => $periodData['title']]);
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
	public function get_balance() {
		if (!$userId = $this->userData['id']) exit('');
		$this->load->model('wallet_model', 'wallet');
		$data = $this->wallet->getUserHistory($userId);
		$data['balance'] = $this->wallet->getUserBalance($userId);
		echo $this->twig->render('views/account/render/wallet/history.tpl', $data);
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function kpiplan($action = false) {
		if (!$action) return false;
		$this->load->model('kpi_model', 'kpi');
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'get_periods':
				$data['periods'] = $this->kpi->getPeriods();
				
				echo $this->twig->render('views/account/render/kpiplan/periods.tpl', $data);
				break;
			
			case 'get_user_progress':
				$this->load->model(['admin_model' => 'admin', 'users_model' => 'users']);
				$periodData = $this->kpi->getPeriod($post['kpi_period_id']);
				
				if (!$formdata = $this->kpi->getUserProgressForm($periodData, $post['user_id'])) exit('');
				if (!$statistics = $this->kpi->calcUserStatistics($post['kpi_period_id'], $post['user_id'])) exit('');
				$data['custom_fields'] = $this->kpi->getPeriodCustomFields($periodData['custom_fields']);
				
				$progress = $this->kpi->getProgressTasks($periodData['id']);
				$data['progress'] = isset($progress[$post['user_id']]) ? $progress[$post['user_id']] : [];
				
				$data['statics'] = $this->admin->getStatics(true, array_keys($formdata));
				$data['ranks'] = $this->admin->getRanks();
				$usersIds = [$post['user_id']];
				
				$data['personages'] = $this->users->getUsersPersonages($usersIds, true);
				$data['formdata'] = $formdata;
				$data['statistics'] = $statistics;
				$data['user_id'] = $post['user_id'];
				$data['default_text'] = $this->admin->getSettings('kpi_default_text');
				$data['period_title'] = $post['period_title'];
				$data['period_date'] = $post['period_date'];
				$data['types'] = [1 => 'Плановые', 2 => 'Бонусные'];
				
				echo $this->twig->render('views/account/render/kpiplan/user.tpl', $data);
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function birthday($action = false) {
		if (!$action) return false;
		$post = bringTypes($this->input->post());
		
		switch ($action) {
			case 'get_form':
				echo $this->twig->render('views/account/render/forms/birthday_form.tpl');
				break;
			
			case 'set':
				if (!$this->account->setBirthDay($post['date'])) exit('0');
				delete_cookie('birthday');
				echo '1';
				break;
			
			default: break;
		}
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function paymentorder($action = false) {
		if (!$action) return false;
		$this->load->model(['admin_model' => 'admin']);
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'get_form':
				
				$data['fields'] = $this->admin->getSettings('fields_pay');
				$data['title'] = $this->admin->getSettings('left_popup_title');
				echo $this->twig->render('views/account/render/forms/payment_order.tpl', $data);
				break;
			
			case 'add':
				$userData = $this->account->getUserData($this->userData['id']);
				$post['stat'] = 0;
				$post['date'] = time().'000';
				$post['user_id'] = $this->userData['id'];
				$post['nickname'] = $userData['nickname'];
				$post['static'] = $userData['main_static'];
				
				echo $this->admin->addPayItem($post);
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
}