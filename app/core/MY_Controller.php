<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class MY_Controller extends CI_Controller {
	
	protected $monthes = [1 => 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
	protected $monthes2 = [1 => 'январь', 'февраль', 'март', 'апрель', 'май', 'июнь', 'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь'];
	protected $monthesShort = [1 => 'янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
	protected $monthesShort2 = [1 => 'янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
	protected $week = [1 => 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
	protected $weekShort = [1 => 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
	protected $minutes;
	protected $constants;
	protected $dataAccess;
	protected $adminSections;
	protected $imgFileExt = ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'ico'];
	protected $fileTypes = ['png','jpg','jpeg','jpe','gif','ico','bmp','svg','psd','rar','zip','mp4','mov','avi','mpeg','txt','rtf','djvu','pdf','doc','docx','xls','xlsx','mp3','wma','wmv'];
	private $adminsActionsTable = 'admins_actions';
	
	protected $giftsActions = [
		'stage'		=> 'Прибавка к стажу',
		'balance'	=> 'Прибавка к балансу'
	];
	
	protected $miniFeedTypes = [
		1	=> 'День рождения',
		2 	=> 'Пошение звания',
		3 	=> 'Оповещение от администрации'
	]; 
	
	
	
	public function __construct() {
		parent::__construct();
		$this->load->model('admin_model');
		$constData = $this->admin_model->getSettings('constants');
		foreach ($constData as $variant => $data) {
			$this->constants[$variant] = [
				'cVisits' 			=> $data['visits'],
				'cPersons' 			=> $data['persons'],
				'cEffectiveness'	=> $data['effectiveness'],
				'cFine' 			=> $data['fine']
			];
		}
		
		$this->minutes = range(0, 55, 5);
		
		
		
		
		//----------------------------------------------------------------  Разделы админ. панели
		$this->adminSections = [
			'Общее' => [
				'common' 				=> [
					'title'	=> 'Общие настройки',
					'items'	=> [
						'common' 				=> 'Главное',
						'fieldsPay' 			=> 'Поля для формы оплаты',
						'fieldsComplaints' 		=> 'Поля для предложений и жалоб',
						'usersListPay' 			=> 'Список "Заказ Оплаты"',
						'usersListComplaints' 	=> 'Список "Предложения и Жалобы"',
						'resignsList' 			=> 'Заявки на увольнение',
						'constants' 			=> 'Константы и шаблоны',
						'agreement' 			=> 'Договор',
						'importantInfo' 		=> 'Важная информация',
						'commonMessage' 		=> 'Cообщение для НЕверифицированных',
						'skype' 				=> 'Скайп',
						'links' 				=> 'Ссылки',
						'stopList' 				=> 'Стоп-лист',
						'tabSctions' 			=> 'Разделы'
					],
				],
				'guides' 				=> 'Образование',
				'mentors' 				=> 'Наставничество',
				'personal_gifts' 		=> 'Персональные подарки',
				'newsfeed' 				=> 'Лента новостей',
				'messages_to_users' 	=> 'Сообщения участникам',
				'mininewsfeed' 			=> 'Важные события',
				'filemanager' 			=> 'Файлменеджер'
			],
			'Списки' => [
				'users' 				=> [
					'title'	=> 'Участники',
					'items'	=> [
						'verifyUsers'	=> 'Верифицированные',
						'newUsers'		=> 'Новые',
						'excludedUsers'	=> 'Отстраненные',
						'deletedUsers'	=> 'Удаленные',
						'depositUsers'	=> 'Резерв',
						'balance'		=> 'Баланс',
						'colorsUsers'	=> 'Цвета рейдеров',
					],],
				'users_addict' 			=> 'Участники доп.',
				'raidliders' 			=> 'Рейд-лидеры',
				'personages' 			=> 'Персонажи',
				'operators' 			=> 'Операторы',
				'admins' 				=> 'Администраторы',
				'statics' 				=> 'Статики',
				'ranks' 				=> 'Звания',
				'roles' 				=> 'Роли',
				'classes' 				=> 'Классы',
				'raids_types' 			=> 'Типы рейдов и ключей',
				'accounts_access' 		=> 'Уровни доступа аккаунтов'
			],
			'Расписания' => [
				'ratings' 				=> 'Рейтинги',
				'timesheet'				=> 'Расписание',
				'offtime'				=> 'Выходные',
				'vacation'				=> 'Отпуска'
			],
			'Статистика и отчеты' => [
				'reports'				=> [
					'title'	=> 'Отчеты',
					'items'	=> [
						'main'				=> 'Выплаты участникам',
						'rewards'			=> 'Премии',
						'second'			=> 'Список заказов',
						'paymentsPatterns'	=> 'Payment Brago',
						'paymentRequests'	=> 'Заявки на оплату',
						'keys'				=> 'Ключи',
						'wallet'			=> 'Выплата баланса',
						
					],
				],
				'kpi_planes'			=> 'KPI планы',
				'statistics_amounts'	=> 'Статистика (доходы)',
				'statistics'			=> 'Статистика (участники)',
				'statistics_settings'	=> 'Статистика (настройки)'
			],
		];
		
		
		
		
		
		
		//----------------------------------------------------------------  Разделы админ. панели
		$this->adminActions = [
			1 => 'Изменение статиков участника',
			2 => 'Исключить/вернуть исключенного участника',
			3 => 'Удалить/вернуть удаленного участника',
			4 => 'Изменить платежные данные участника',
		];
		
		
		
		
		
		
		//----------------------------------------------------------------  Кабинет оператора
		$this->dataAccess = [
			1 => [
				'id'	=> 'raids',
				'url'	=> 'raids',
				'title' => 'Рейды',
				'desc' 	=> 'Доступ на создание/редактирование рейдов в статиках',
				'icon'	=> 'bullhorn'
			],
			13 => [
				'id'	=> 'keys',
				'url'	=> 'keys',
				'title' => 'Ключи',
				'desc' 	=> 'Доступ на создание/редактирование ключей в статиках',
				'icon'	=> 'bullhorn'
			],
			2 => [
				'id'	=> 'orders',
				'url'	=> 'orders',
				'title' => 'Заказы',
				'desc' 	=> 'Доступ на создание/редактирование рейдов в статиках',
				'icon'	=> ''
			],
			3 => [
				'id'	=> 'timesheet',
				'url'	=> 'timesheet',
				'title' => 'Расписание',
				'desc' 	=> 'Доступ на редактирование и создание расписания',
				'icon'	=> 'calendar'
			],
			4 => [
				'id'	=> 'offtime',
				'url'	=> 'offtime',
				'title' => 'Выходные',
				'desc' 	=> 'Доступ на открытие/закрытие выходных дней',
				'icon'	=> 'calendar-plus-o'
			],
			14 => [
				'id'	=> 'vacation',
				'url'	=> 'vacation',
				'title' => 'Отпуска',
				'desc' 	=> 'Доступ на создание/подтверждение отпускных дней',
				'icon'	=> 'calendar-plus-o'
			],
			5 => [
				'id'	=> 'newsfeed',
				'url'	=> 'newsfeed',
				'title' => 'Лента новостей',
				'desc' 	=> 'Доступ на рекдактирование и создание новостей',
				'icon'	=> 'newspaper-o'
			],
			6 => [
				'id'	=> 'users',
				'url'	=> 'users',
				'title' => 'Участники и статики',
				'desc' 	=> 'Доступ на присваивание статиков и ротация людей между статиками',
				'icon'	=> 'users'
			],
			7 => [
				'id'	=> 'accounting',
				'url'	=> 'accounting',
				'title' => 'Бухгалтерия',
				'desc' 	=> 'Доступ к платёжной информации, подтверждение оплаты в сохранённых отчетах, редактирование средства оплаты и Резерва.',
				'icon'	=> 'credit-card'
			],
			8 => [
				'id'	=> 'paymentrequests',
				'url'	=> 'paymentrequests',
				'title' => 'Заявки на оплату',
				'desc' 	=> 'Доступ к созданию и изменению статуса заявок на дополнительную оплату участникам.',
				'icon'	=> 'credit-card'
			],
			9 => [
				'id'	=> 'guides',
				'url'	=> 'guides',
				'title' => 'Образование',
				'desc' 	=> 'Доступ к созданию и изменению разделов образования',
				'icon'	=> 'graduation-cap'
			],
			10 => [
				'id'	=> 'importantinfo',
				'url'	=> 'importantinfo',
				'title' => 'Важная информация',
				'desc' 	=> 'Доступ к созданию и изменению разделов важной информации',
				'icon'	=> 'info-circle'
			],
			11 => [
				'id'	=> 'paymentcomplaint',
				'url'	=> 'paymentcomplaint',
				'title' => 'Оплата и жалобы',
				'desc' 	=> 'Доступ к созданию и изменению списка "Заказ оплаты" и "Предложения и жалобы"',
				'icon'	=> 'commenting-o'
			],
			12 => [
				'id'	=> 'personages',
				'url'	=> 'personages',
				'title' => 'Персонажи',
				'desc' 	=> 'Доступ к усверждению и редактированию персонажей',
				'icon'	=> 'optin-monster'
			],
			15 => [
				'id'	=> 'ratings',
				'url'	=> 'ratings',
				'title' => 'Форс мажор, Выговоры, Стимулирование Заявки на увольнение',
				'desc' 	=> 'Доступ к модерации "Форс мажор, Выговоры, Стимулирование, Заявки на увольнение"',
				'icon'	=> 'optin-monster'
			],
			16 => [
				'id'	=> 'kpi',
				'url'	=> 'kpi',
				'title' => 'KPI планы',
				'desc' 	=> 'Доступ к KPI планам',
				'icon'	=> 'optin-monster'
			],
			17 => [
				'id'	=> 'users_addict',
				'url'	=> 'users_addict',
				'title' => 'Список участников',
				'desc' 	=> 'Список участников',
				'icon'	=> 'optin-monster'
			],
			18 => [
				'id'	=> 'messgestousers',
				'url'	=> 'messges_to_users',
				'title' => 'Уведомления',
				'desc' 	=> 'Уведомления',
				'icon'	=> 'commenting-o'
			]
		];




		
		
		//--------------------------------------------------------------------------- Twig фильтры
		$this->twig->addFilter('d', function($date, $isShort = false) {
			if ($isShort) return date('j', $date).' '.$this->monthesShort[date('n', $date)].' '.date('y', $date).' г.';
			return date('j', $date).' '.$this->monthes[date('n', $date)].' '.date('Y', $date).' г.';
		});
		
		$this->twig->addFilter('t', function($time) {
			return date('H:i', $time);
		});
		
		$this->twig->addFilter('week', function($date) {
			$weekDay = date('N', $date);
			return $this->week[$weekDay];
		});
		
		$this->twig->addFilter('month', function($date, $type = 'short', $case = 'n') { // short full n g
			$m = date('n', $date);
			if ($type == 'short') return $case == 'n' ? $this->monthesShort2[$m] : $this->monthesShort[$m];
			if ($type == 'full') return $case == 'n' ? $this->monthes2[$m] : $this->monthes[$m];
			
		});
		
		
		$this->twig->addFilter('padej', function($num, $variants = ['день', 'дня', 'дней'], $variantsEng = ['day', 'day', 'days']) {
			$lang = get_cookie('language') ?: 'ru';
			$v = $lang == 'ru' ? $variants : ($variantsEng ?: $variants);
			if (in_array($num, explode(' ', '11 12 13 14')) || in_array(substr($num, -1), explode(' ', '5 6 7 8 9 0'))) return $v[2];
			elseif (in_array(substr($num, -1), explode(' ', '2 3 4'))) return $v[1];
			elseif (substr($num, -1) == '1') return $v[0];
		});
		
		$this->twig->addFilter('postfix', function($fileName, $postfix) {
			if (! $fileName || ! $postfix) return '';
			$fileData = explode('.', $fileName);
			return implode('.', [$fileData[0].$postfix, $fileData[1]]);
		});
		
		$this->twig->addFilter('postfix_setting', function($postfix, $default = '_setting') {
			return isset($postfix) ? ($postfix == 0 ? '' : $postfix) : $default;
		});
		
		$this->twig->addFilter('floor', function($str) {
			return floor($str);
		});
		
		$this->twig->addFilter('add_zero', function($str) {
			return substr('0'.$str, -2);
		});
		
		
		$this->twig->addFilter('chunk', function($arr, $size, $preserveKeys = false) {
			return array_chunk($arr, $size, $preserveKeys);
		});
		
		
		$this->twig->addFilter('chunktoparts', function($arr, $parts, $preserveKeys = false) {
			$size = ceil(count($arr) / $parts);
			return array_chunk($arr, $size, $preserveKeys);
		});
		
		
		
		$this->twig->addFilter('filename', function($path, $return = 0) {
			if (!$path) return false;
			$fileName = explode('/', $path);
			$fileName = array_pop($fileName);
			$fileName = explode('.', $fileName);
			$e = array_pop($fileName);
			$n = implode('.', $fileName);
			return $return == 1 ? $n : ($return == 2 ? $e : $n.'.'.$e);
		});
		
		
		$this->twig->addFilter('is_img_file', function($ext) {
			return in_array($ext, $this->imgFileExt);
		});
		
		
		$this->twig->addFilter('is_file', function($filename, $nofile = '') {
			$file = preg_replace('/https?:\/\/\w+.\w{2,4}\//', '', $filename);
			return is_file($file) ? $filename : $nofile;
		});
		
		
		$this->twig->addFilter('no_file', function($filename, $nofile = '') {
			$filePath = str_replace(base_url(), '', $filename);
			$filePath = explode('?', $filePath);
			return is_file($filePath[0]) ? $filename : $nofile;
		});
		
		$this->twig->addFilter('trimstring', function($string, $length = 10, $end = '...') {
			return mb_strimwidth($string, 0, $length, $end);
		});
		
		
		$this->twig->addFilter('ext', function($fileName, $ext = 'tpl') {
			$f = explode('.', $fileName)[0];
			return $f.'.'.$ext;
		});
		
		$this->twig->addFilter('addtag', function($str, $find, $tag = 'span') {
			return str_replace($find, '<'.$tag.'>'.$find.'</'.$tag.'>', $str);
		});
		
		
		$this->twig->addFilter('phonecode', function($str, $tag = 'span') {
			$countNums = strpos($str, ' ') - (strpos($str, '+') !== false ? 1 : 0);
			return preg_replace('/(\+?\d{'.$countNums.'} \(\d{3}\))(.+)/iu', '<'.$tag.'>$1</'.$tag.'>$2', $str);
		});
		
		$this->twig->addFilter('freshfile', function($str) {
			return $str.'?'.time();
		});
		
		
		$this->twig->addFilter('decodedirsfiles', function($str) {
			if (!$str) return false;   
	        $search = ["***", "&#39;", "&quot;", "&#39;", "&quot;", "___", "---", "==="];
	        $replace = [DIRECTORY_SEPARATOR, "\'", "\"", "'", '"', " ", ".", ","];
	        return str_replace($search, $replace, $str);
		});
		
		
		
		$this->twig->addFilter('sortusers', function($arr, $field = 'nickname') {
			if (!$arr || !$field) return false;
	        uasort($arr, function($a, $b) use ($field) {
	        	if (!isset($a[$field]) || !isset($b[$field])) return 0;
			    if (preg_match('/[а-яё.]+/ui', $a[$field]) && preg_match('/[a-z.]+/ui', $b[$field])) {
			        return -1;
			    } elseif (preg_match('/[a-z.]+/ui', $a[$field]) && preg_match('/[а-яё.]+/ui', $b[$field])) {
			        return 1;
				} else {
			        return $a[$field] < $b[$field] ? -1 : 1;
			    }
			});
			return $arr;
		});
		
		
		$this->twig->addFilter('ksort', function($arr) {
			if (!$arr) return false;
			ksort($arr);
			return $arr;
		});
		
		
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getAdminUsers() {
		$users = $this->admin_model->getSettings('admin_users');
		if ($users = preg_split('/\n|\r\n?/', $users)) {
			foreach ($users as $k => $user) {
				$users[$k] = trim($user);
			}
		}
		return $users;
	}
	
	
	
	
	
	/**
	 * Записать действие администратора
	 * @param Тип действия integer
	 * @param данные в произвольном виде mixed
	 * @return 
	 */
	public function setAdminAction($actionType = false, $info = false) {
		if (!$actionType || !$info) return false;
		
		if (!isJson($info)) $info = json_encode($info);
		
		$insData = [
			'admin_id' 	=> $this->getAdminId(),
			'type' 		=> $actionType,
			'info'		=> $info,
			'date' 		=> time()
		];
		
		if (!$this->db->insert($this->adminsActionsTable, $insData)) return false;
		return true;
	}
	
	
	
	
	
	protected function getAdminId() {
		if ($token = get_cookie('token')) return decrypt($token);
		return 0;
	}
	
	
	protected function _isCliRequest() {
		return (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/Wget\//', $_SERVER['HTTP_USER_AGENT']));
	}
	
}