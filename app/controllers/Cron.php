<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Cron extends MY_Controller {
	
	// fastVPS: /usr/bin/wget -O /dev/null "http://vendorteam.ru/controller/function"
	
	
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
		$this->load->model(['users_model' => 'users', 'mininewsfeed_model' => 'mininewsfeed']);
		$newRanksUsers = $this->users->setRanksToUsers();
		
		
		//----------------------------------------------------------- Отправка уведомлений о присвоении нового звания
		if (!$ranksTemplates = $this->mininewsfeed->templates('get', 2)) return false;
		$newRanksUsers = setArrKeyfromField($newRanksUsers, 'id', 'rank');
		
		$newRanksUsersData = [];
		if ($newRanksUsers) {
			$usersData = $this->_getUsersStatics(array_keys($newRanksUsers));
			$ranksData = $this->admin_model->getRanks(true, false);
			$ranksData = setArrKeyfromField($ranksData, 'id', 'name');
			
			$date = time();
			
			foreach ($newRanksUsers as $userId => $rank) { // id rank
				if (!$userData = isset($usersData[$userId]) ? $usersData[$userId] : false) continue;
				
				$randTemplateKey = array_rand($ranksTemplates);
				$message = preg_replace_callback('/\[(\w+)\]/', function($matches) use (&$userData, &$ranksData) {
					$field = $matches[1];
					
					if ($field == 'rank') return isset($ranksData[$userData['rank']]) ? $ranksData[$userData['rank']] : '';
					return isset($userData[$field]) ? $userData[$field] : '';
				}, $ranksTemplates[$randTemplateKey]['text']);
				
				$newRanksUsersData[] = [
					'type'		=> 2,
					'icon'		=> $usersData[$userId]['avatar'],
					'text'		=> $message,
					'statics'	=> $usersData[$userId]['statics'],
					'date'		=> $date
				];
			}
		}
		
		if ($newRanksUsersData) $this->mininewsfeed->addToNewsFeed($newRanksUsersData);
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
		
		if (!$usersList = $this->users_model->getUsers(['where_in' => ['field' => 'us.static_id', 'values' => $staticsIds], 'or_where' => ['u.deleted' => 1]])) return false;
		
		$updateUsers = [];
		foreach ($usersList as $user) {
			$updateUsers[] = [
				'id' 	=> $user['id'],
				'stage' => (int)$user['stage'] - 1
			];
		}
		
		if ($updateUsers) $this->db->update_batch('users', $updateUsers, 'id');
	}
	
	
	
	
	
	
	/**
	 * Переместить уволенных участников в статик инактив
	 * @param 
	 * @return 
	 */
	public function replace_resign_users() {
		if (!$this->_isCliRequest()) redirect();
		$this->load->model('users_model');
		$resignUsersIds = $this->users_model->getResignUsersIds(true);
		$this->users_model->replaceResignUsers($resignUsersIds, 33);
	}
	
	
	
	
	
	
	
	/**
	 * Отправить оповещение в мини-лентуо дне рождения
	 * @param 
	 * @return 
	 */
	public function mininewsfeed_birthdays() {
		if (!$this->_isCliRequest()) redirect();
		$this->load->model(['users_model' => 'users', 'account_model' => 'account', 'mininewsfeed_model' => 'mininewsfeed']);
		$users = $this->users->getUsers(['where' => ['us.main' => 1, 'u.deleted' => 0, 'u.verification' => 1, 'u.excluded' => 0], 'fields' => 'id birthday']);
		if (!$users) return false;
		
		$month = date('n');
		$day = date('j');
		
		if (!$birthdayTemplates = $this->mininewsfeed->templates('get', 1)) return false;
		
		$birthdayData = [];
		foreach ($users as $userId => $userData) {
			$userMonth = date('n', $userData['birthday']);
			$userDay = date('j', $userData['birthday']);
			$randTemplateKey = array_rand($birthdayTemplates);
			
			if ($userMonth == $month && $userDay == $day) {
				$userData = $this->account->getUserData($userId);
				$date = time();
				$message = preg_replace_callback('/\[(\w+)\]/', function($matches) use (&$userData) {
					$field = $matches[1];
					return isset($userData[$field]) ? $userData[$field] : '';
				}, $birthdayTemplates[$randTemplateKey]['text']);
				
				$birthdayData[] = [
					'type'		=> 1,
					'icon'		=> $userData['avatar'],
					'text'		=> $message,
					'statics'	=> json_encode(array_keys($userData['statics'])),
					'date'		=> $date
				];
			}
		}
		
		if ($birthdayData) $this->mininewsfeed->addToNewsFeed($birthdayData);
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * отправить отложенные сообщения
	 * @param 
	 * @return 
	 */
	public function mininewsfeed_later() {
		if (!$this->_isCliRequest()) redirect();
		$this->load->model(['mininewsfeed_model' => 'mininewsfeed']);
		$this->mininewsfeed->addLaterNewsFeed();
	}
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getUsersStatics($usersIds = false) {
		if (!$usersIds) return false;
		$this->db->select('u.id, u.nickname, u.avatar, u.rank, '.$this->groupConcatValue('us.static_id', 'statics'));
		$this->db->join('users_statics us', 'u.id = us.user_id', 'LEFT OUTER');
		$this->db->where_in('u.id', $usersIds);
		$this->db->where(['u.deleted' => 0, 'u.verification' => 1]);
		$this->db->group_by('u.id');
		$query = $this->db->get('users u');
		
		if (!$usersStatics = $query->result_array()) return false;
		return setArrKeyFromField($usersStatics, 'id');
	}
	
	
	
	
	/**
	 * Добавить в запрос concat value
	 * @param поле для теста объединения (есть ли данные) false - нет поверки данных
	 * @param название поля
	 * @param уникальные значения
	 * @return string
	*/
	private function groupConcatValue($concatField = false, $fieldname = false, $distinct = false) {
		if (!$fieldname) return '';
		
		if ($concatField === false) {
			return "CAST(CONCAT('[', GROUP_CONCAT(".($distinct === true ? 'distinct' : '')." ".$fieldname."), ']') AS JSON) AS ".$fieldname;
		} else {
			return "IF(GROUP_CONCAT(".$concatField."), CAST(CONCAT('[', GROUP_CONCAT(".($distinct === true ? 'distinct' : '')." ".$concatField."), ']') AS JSON), NULL) AS ".$fieldname;
		}
	}
	
	
}