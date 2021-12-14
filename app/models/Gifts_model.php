<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Gifts_model extends MY_Model {
	
	private $giftsTable = 'gifts';
	private $usersGiftsTable = 'users_gifts';
	
	public function __construct() {
		parent::__construct();
		
	}
	
	
	
	 
	
	/**
	 * CRUD
	 * @param 
	 * @return 
	*/
	public function crud($action = false) {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				if ($data) $this->db->where($data);
				if (!$result = $this->_result($this->giftsTable)) return false;
				return $result;
				break;
			
			case 'save':
				if (!$data) return false;
				if (!$this->db->insert($this->giftsTable, $data)) return false;
				return $this->db->insert_id();
				break;
			
			case 'update':
				if (!$data) return false;
				$this->db->where('id', $data['id']);
				if (!$this->db->update($this->giftsTable, $data['fields'])) return false;
				return true;
				break;
			
			case 'remove':
				if (!$data) return false;
				$this->db->where('id', $data);
				if (!$this->db->delete($this->giftsTable)) return false;
				return true;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Персональные подарки
	 * @param 
	 * @return 
	*/
	public function personalgifts($action = false) {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get_to_user':
				$this->db->where('user_id', $data);
				if (!$result = $this->_result($this->usersGiftsTable)) return false;
				return $result;
				break;
			
			case 'get_gifts_counts':
				$this->db->select('user_id, count(*) AS total, SUM(case when date_taking IS NULL then 1 else 0 end) AS waiting, SUM(case when date_taking IS NOT NULL then 1 else 0 end) AS taking');
				$this->db->group_by('user_id');
				if (!$result = $this->_result($this->usersGiftsTable)) return false;
				return $result;
				break;
			
			case 'get':
				$this->db->where('section', 'personal');
				if (!$result = $this->_result($this->giftsTable)) return false;
				return $result;
				break;
			
			case 'add':
				$giftsFromForm = setArrKeyFromField($data['gifts'], 'id', 'count');
				$giftsIds = array_keys($giftsFromForm);
				$this->db->where_in('id', $giftsIds);
				if (!$result = $this->_result($this->giftsTable)) return false;
				
				$date = time();
				$giftsToAdd = [];
				foreach ($result as $gift) {
					$countGifts = $giftsFromForm[$gift['id']] > 1 ? $giftsFromForm[$gift['id']] : 1;
					for ($i = 0; $i < $countGifts; $i++) { 
						$value = rand($gift['items_from'], $gift['items_to']);
						$giftsToAdd[] = [
							'user_id'		=> $data['user_id'],
							'section'		=> 'personal',
							'title'			=> $gift['title'],
							'action'		=> $gift['action'],
							'value'			=> $value,
							'message'		=> $data['message'] ?? null,
							'date_generate'	=> $date
						];
					}	
				}
				if ($giftsToAdd) $this->db->insert_batch($this->usersGiftsTable, $giftsToAdd);
				return true;
				break;
				
			case 'change_gift_value':
				$this->db->where('id', $data['id']);
				if (!$this->db->update($this->usersGiftsTable, ['value' => $data['value']])) return false;
				return true;
				break;
				
			case 'remove_gift':
				$this->db->where('id', $data['id']);
				if (!$this->db->delete($this->usersGiftsTable)) return false;
				return true;
				break;
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	/**
	 * Получить накопленные проценты участника
	 * @param 
	 * @return 
	*/
	public function getUserPercent($userId = false) {
		if (!$userId) return false;
		$this->db->where('user_id', $userId);
		if (!$percent = $this->_row('users_bonus_percents', 'percent')) return false;
		return $percent;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function hasUserGifts($userId = false) {
		if (!$userId) return false;
		$this->db->where('user_id', $userId);
		$this->db->where('date_taking IS NULL');
		return $this->db->count_all_results('users_gifts');
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getCountGifts($userId = false) {
		if (!$userId) return false;
		$this->db->where('user_id', $userId);
		$this->db->where('date_taking IS NULL');
		return $this->db->count_all_results('users_gifts');
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function generateGifts($userId = false, $section = false) {
		if (!$userId || !$section) return false;
		$percent = $this->getUserPercent($userId);
		if (!$gifts = $this->_getGifts('kpi')) return false;
		$gifts = setArrKeyFromField($gifts, 'id', true);
		
		$giftsMap = [];
		foreach ($gifts as $gift) {
			$fill = array_fill(0, $gift['chance'], $gift['id']);
			$giftsMap = array_merge($giftsMap, $fill);
		}
		shuffle($giftsMap);
		
		function _chooseGift($arr = false) {
			if (!$arr) return false;
			$randKey = array_rand($arr, 1);
			return $randKey;
		}
			
		
		$hasPercent = true;
		$chosenGifts = [];
		while($hasPercent) {
			if ($percent - $gift['percents'] >= 0) {
				$percent = $percent - $gift['percents'];
				$index = _chooseGift($giftsMap);
				$chosenGifts[] = $gifts[$giftsMap[$index]];
			} else {
				$hasPercent = false;
			}
		}
		
		$giftsToUser = [];
		$date = time();
		foreach ($chosenGifts as $gift) {
			$value = rand($gift['items_from'], $gift['items_to']);
			
			$giftsToUser[] = [
				'user_id'		=> $userId,
				'section'		=> $section,
				'title' 		=> $gift['title'],
				'action' 		=> $gift['action'],
				'value' 		=> $value,
				'date_generate'	=> $date
			];
		}
		
		$this->_setUserPercent($userId, $percent);
		$this->_insertGiftsToTable($giftsToUser);
		
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getGift($userId = false) {
		if (!$userId) return false;
		$this->db->where('user_id', $userId);
		$this->db->where('date_taking IS NULL');
		$this->db->order_by('id', 'ASC');
		if (!$giftRow = $this->_row('users_gifts')) return false;
		return $giftRow;
	}
	
	
	
	
	
	
	/**
	 * Присвоить подарок
	 * @param 
	 * @return 
	*/
	public function takeGift($userId = false, $giftId = false) {
		if (!$userId || !$giftId) return false;
		
		$giftData = $this->_getGift($userId, $giftId);
		if (!$this->_runGiftAction($userId, $giftId, $giftData['action'], $giftData['value'])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getGifts($section = false) {
		if (!$section) return false;
		$this->db->select('id, title, chance, percents, action, items_from, items_to');
		$this->db->where('section', $section);
		if (!$gifts = $this->_result('gifts')) return false;
		return $gifts;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _getGift($userId = false, $giftId = false) {
		if (!$userId || !$giftId) return false;
		$this->db->where(['id' => $giftId, 'user_id' => $userId]);
		if (!$gift = $this->_row('users_gifts')) return false;
		return $gift;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	private function _insertGiftsToTable($gifts = false) {
		if (!$gifts) return false;
		$this->db->insert_batch('users_gifts', $gifts);
		return true;
	}
	
	
	
	
	/**
	 * Задать бонусные проценты участника
	 * @param 
	 * @return 
	*/
	private function _setUserPercent($userId = false, $percent = null) {
		if (!$userId || is_null($percent)) return false;
		$this->db->where('user_id', $userId);
		if (!$this->db->update('users_bonus_percents', ['percent' => $percent])) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * Запустить выполнение функциипо типу подарка и сменить статус подарка
	 * @param ID участника
	 * @param тип действия
	 * @param значение (дни или сумма)
	 * @return 
	*/
	private function _runGiftAction($userId = false, $giftId = false, $action = false, $value = false) {
		if (!$userId || !$giftId || !$action || !$value) return false;
		
		$date = time();
		switch ($action) {
			case 'stage':
				$this->db->where('id', $userId);
				if (($userStage = $this->_row('users', 'stage')) === false) return false;
				$this->db->where('id', $userId);
				if (!$this->db->update('users', ['stage' => (int)$userStage+(int)$value])) return false;
				break;
			
			case 'balance':
				$this->load->model(['wallet_model' => 'wallet', 'reports_model' => 'reports', 'account_model' => 'account']);
				
				$userData = $this->account->getUserData($userId);
				
				$orders[] = [
					'user_id'		=> $userId,
					'nickname' 		=> $userData['nickname'],
					'avatar' 		=> $userData['avatar'],
					'payment' 		=> $userData['payment'],
					'static' 		=> $userData['main_static'],
					'order' 		=> 'KPI бонус',
					'summ' 			=> $value,
					'to_deposit'	=> 0,
					'comment' 		=> 'Подарок за перевыпонение KPI плана',
					'date'			=> $date
				];
				
				if (!$this->reports->insertUsersOrders($orders)) return false;
				$this->wallet->setToWallet([$userId => $value], 7, 'Бонус за перевыполнение KPI плана', '+');
				break;
			
			default: break;
		}
		

		$this->db->where(['id' => $giftId, 'user_id' => $userId]);
		if (!$this->db->update('users_gifts', ['date_taking' => $date])) return false;
		return true;
	}
	
	
	
	
	
}