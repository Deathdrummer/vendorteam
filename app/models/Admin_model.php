<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Admin_model extends My_Model {
	
	
	private $imgDir = 'public/images/';
	private $secretKey = 'Novbragoz77';
	
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	/**
	 * Сохранение настроек
	 * @param 
	 * @return 
	 */
	public function saveSettings($post = false) {
		if (!$post) return 0;
		$return = 1;
		$post = bringTypes($post);
		
		foreach ($post as $param => $value) {
			if (is_array($value)) $post[$param] = json_encode($value);
		}
		
		
		//----------------------------------------------------------- auth
		$newToken = false;
		if (!empty($post['auth_login_setting']) && !empty($post['auth_pass_setting'])) {
			if (!empty($post['secret_key_setting']) && $post['secret_key_setting'] == $this->secretKey) {
				$newToken = md5($post['auth_login_setting'].$post['auth_pass_setting']);
			}
		}
		unset($post['auth_login_setting'], $post['auth_pass_setting'], $post['secret_key_setting']);
		
		
		$query = $this->db->get('settings');
		$result = $query->result_array();
		
		$oldData = []; $issetToken = false;
		if ($result) {
			foreach ($result as $item) {
				if ($item['param'] == 'token_setting') $issetToken = true;
				$oldData[$item['param']] = $item['value'];
			} 
		}
		
		$oldData = bringTypes($oldData);
		
		//$removeFields = array_diff_key($oldData, $post);
		$newFields = array_diff_key($post, $oldData);
		$updateFields = array_diff_assoc($post, $oldData);
		
		
		/*$deleteOldFields = [];
		foreach ($removeFields as $param => $value) $deleteOldFields[] = $param;
		
		
		if (! empty($deleteOldFields)) {
			$this->db->where_in('param', $deleteOldFields);
			$this->db->delete('settings');
		}*/
		
		
		$insertNewFields = [];
		foreach ($newFields as $param => $value) {
			if ($value == '') continue;
			$insertNewFields[] = [
				'param' => $param,
				'value' => $value,
				'json'	=> isJson($value) ? 1 : 0
			];
			unset($updateFields[$param]);
		}
		
		if (!$issetToken && $newToken) {
			$insertNewFields[] = [
				'param' => 'token_setting',
				'value' => $newToken,
				'json'	=> 0
			];
		}
		
		
		
		if (!empty($insertNewFields)) $this->db->insert_batch('settings', $insertNewFields);
		
		
		$updateNewFields = [];
		foreach ($updateFields as $param => $value) {
			if ($value == '') continue;
			$updateNewFields[] = [
				'param' => $param,
				'value' => $value,
				'json'	=> isJson($value) ? 1 : 0
			];
		}
		
		if ($issetToken && $newToken) {
			$updateNewFields[] = [
				'param' => 'token_setting',
				'value' => $newToken,
				'json'	=> 0
			];
			$return = 2;
		}
		
		if (!empty($updateNewFields)) $this->db->update_batch('settings', $updateNewFields, 'param');
		
		return $return;
	}
	
	
	
	
	
	
	/**
	 * Получить значение из настроек
	 * @param одна или несколько настроек в массиве
	 * @return 
	 */
	public function getSettings($setting = null) {
		if (!is_null($setting) && is_array($setting)) {
			foreach ($setting as $k => $param) {
				if (substr($param, -8) != '_setting') $setting[$k] = $param.'_setting';
			}
			$this->db->where_in('param', $setting);
		} elseif (!is_null($setting) && !is_array($setting)) {
			if (substr($setting, -8) != '_setting') $setting.='_setting';
			$this->db->where('param', $setting);
			$this->db->or_where('param', $setting.'_setting');
		}
		
		$query = $this->db->get('settings');
		if (!$result = $query->result_array()) return false;
		
		$result = bringTypes($result);
		
		$settingsData = [];
		foreach ($result as $k => $item) {
			if ($item['json'] && isJson($item['value'])) {
				$settingsData[$item['param']] = json_decode($item['value'], true);
			} else {
				$settingsData[$item['param']] = $item['value'];
			}
		}
		if (!is_null($setting) && !is_array($setting) && isset($settingsData[$setting])) return $settingsData[$setting];
		//if (!is_null($setting) && !is_array($setting) && isset($settingsData[$setting.'_setting'])) return $settingsData[$setting.'_setting'];
		return empty($settingsData) ? false : $settingsData;
	}
	
	
	
	
	
	/**
	 * Удалить значение настройкаи
	 * @param 
	 * @return 
	 */
	public function deleteSetting($param, $subparam) {
		if ($subparam) {
			$this->db->where('param', $param);
			$query = $this->db->get('settings');
			$res = $query->row_array();
			$resValue = json_decode($res['value'], true);
			
			eval('unset($resValue'. $subparam . ');');
			
			$this->db->where('param', $param);
			$this->db->set('value', json_encode($resValue));
			return $this->db->update('settings');
		} else {
			$this->db->where('param', $param);
			return $this->db->delete('settings');
		}
	}
	
	
	
	
	
	/**
	 * Установить значение настройки
	 * @param 
	 * @return 
	 */
	public function setSetting($param, $value) {
		if (is_array($value)) $value = json_encode($value);
		
		$this->db->where('param', $param);
		if ($this->db->count_all_results('settings') == 0) {
			$this->db->insert('settings', ['param' => $param, 'value' => $value]);
		} else {
			$this->db->set('value', $value);
			$this->db->where('param', $param);
			$this->db->update('settings');
		}
		
		return 1;
	}
	
	
	
	
	
	
	
	/**
	 * Сохранить
	 * @param 
	 * @return 
	*/
	public function setUsersField($userId = false, $field = false, $value = false) {
		$this->db->where('id', $userId);
		if (!$this->db->update('users', [$field => $value])) return false;
		return true;
	}
	
	
	
	/**
	 * Сохранить
	 * @param 
	 * @return 
	*/
	public function setLidersField($userId = false, $field = false, $value = false) {
		if (!$userId) return false;
		$this->db->where('id', $userId);
		if (!$this->db->update('users', [$field => $value])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * Удалить файл
	 * @param 
	 * @return 
	 */
	public function deleteFile($fileSetting, $correntFile) {
		if ($correntFile == 'none.png' || $correntFile == 'video.png') return 1;
		
		$setting = explode('[', $fileSetting);
		array_walk($setting, function(&$item, $key) {
			$item = rtrim($item, ']');
			if ($key > 0) {
				if (! is_numeric($item)) $item = '[\''.$item.'\']';
				else $item = '['.$item.']';
			}	
		});
		
		$mainSetting = array_shift($setting);
		$data = $this->getSettings($mainSetting);
		$setting = implode('', $setting);
		$dataProto = eval('return $data'. $setting . ';');
		
		if ($dataProto['path']) unlink($this->imgDir.$dataProto['path'].$dataProto['name']);
		else unlink($this->imgDir.$dataProto['name']);
		$this->deleteSetting($mainSetting, $setting);
		return 2;
	}
	
	
	
	
	
	
	
	public function addPayItem($data = false) {
		if (!$data) return false;
		$this->db->insert('pay_items', ['data' => json_encode($data)]);
		return 1;
	}
	
	
	public function addComplaintsItem($data) {
		$this->db->insert('complaints_items', ['data' => json_encode($data)]);
		return 1;
	}
		
	
	
	
	
	
	public function getUsersListPay($userId = false) {
		$this->db->order_by('id', 'DESC');
		$query = $this->db->get('pay_items');
		if (!$allData = $query->result_array()) return false;
		$statics = $this->getStatics();
		
		
		
		$data = ['actual' => [], 'archive' => []]; $itemsToRemove = [];
		foreach ($allData as $item) {
			$temp = json_decode($item['data'], true);
			if (!isset($temp['user_id']) && $temp['stat'] == 0) $itemsToRemove[] = $item['id'];
			
			$staticId = isset($temp['static']) ? $temp['static'] : 0;
			$temp['static'] = isset($statics[$staticId]) ? $statics[$staticId]['name'] : false;
			$temp['static_icon'] = isset($statics[$staticId]) ? 'public/filemanager/'.$statics[$staticId]['icon'] : false;
			
			if (($userId && isset($temp['user_id']) && $temp['user_id'] != $userId) || ($userId && !isset($temp['user_id']))) continue;
			if ($userId && $temp['stat'] == 1) continue;
			
			$data[$temp['stat'] == 0 ? 'actual' : 'archive'][$item['id']] = $temp;
		}
		
		if ($itemsToRemove) {
			toLog('getUsersListPay -> найдены у удалены пустые записи!');
			toLog($itemsToRemove);
			$this->db->where_in('id', $itemsToRemove);
			$this->db->delete('pay_items');
		}
		
		
		$data['archive'] = array_values(array_slice($data['archive'], 0, 50, true));
		return $userId ? $data['actual'] : $data;
	}
	
	
	
	public function getUsersListComplaints() {
		$this->db->order_by('id', 'DESC');
		$query = $this->db->get('complaints_items');
		if (!$allData = $query->result_array()) return false;
		$statics = $this->getStatics(true);
		$data = ['actual' => [], 'archive' => []];
		foreach ($allData as $item) {
			$temp = json_decode($item['data'], true);
			$temp['static'] = isset($statics[$temp['static']]) ? $statics[$temp['static']] : null;
			$data[$temp['stat'] == 0 ? 'actual' : 'archive'][$item['id']] = $temp;
		}
		$data['archive'] = array_slice($data['archive'], 0, 50, true);
		return $data;
	}
	
	
	
	
	
	
	
	
	public function setPayItemStat($data) {
		$this->db->where('id', $data['id']);
		$query = $this->db->get('pay_items');
		$response = $query->result_array();
		$tdata = json_decode($response[0]['data'], true);
		$tdata['stat'] = $data['stat'];
		
		$this->db->set('data', json_encode($tdata));
		$this->db->where('id', $data['id']);
		$this->db->update('pay_items');
		return 1;
	}
	
	
	
	public function setComplaintsItemStat($data) {
		$this->db->where('id', $data['id']);
		$query = $this->db->get('complaints_items');
		$response = $query->result_array();
		$tdata = json_decode($response[0]['data'], true);
		$tdata['stat'] = $data['stat'];
		
		$this->db->set('data', json_encode($tdata));
		$this->db->where('id', $data['id']);
		$this->db->update('complaints_items');
		return 1;
	}
	
	
	
	
	public function getPayListMore($offset) {
		$query = $this->db->get('pay_items', 30, $offset);
		$response = $query->result_array();
		
		if (! empty($response)) {
			$list = [];
			foreach ($response as $value) {
				$list[$value['id']] = json_decode($value['data'], true);
			}
			return $list;
		}
		return false;
	}
	
	
	
	public function getComplaintsListMore($offset) {
		$query = $this->db->get('complaints_items', 30, $offset);
		$response = $query->result_array();
		
		if (! empty($response)) {
			$list = [];
			foreach ($response as $value) {
				$list[$value['id']] = json_decode($value['data'], true);
			}
			return $list;
		}
		return false;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	
	//------------------------------------------------------------------------------------------------ Статики
	
	/**
	 * Получить список статиков
	 * @param только имена статиков [static id => static name]
	 * @param Вернуть данные заданного статика
	 * @return [static id => static name] или [static id => static data]
	 */
	public function getStatics($nameOnly = false, $staticId = null) {
		$this->db->select('s.*, (SELECT COUNT(us.id) FROM users_statics us JOIN users u ON us.user_id = u.id WHERE s.id = us.static_id AND u.deleted = 0 AND us.main = 1) AS count_users');
		if (is_array($staticId)) $this->db->where_in('s.id', $staticId);
		elseif (!is_null($staticId)) $this->db->where('s.id', $staticId);
		$this->db->order_by('id', 'ASC');
		$query = $this->db->get('statics s');
		if (!$response = $query->result_array()) return false;
		$data = [];
		if ($nameOnly) {
			foreach ($response as $item) {
				$data[$item['id']] = $item['name'];
			}
		} else {
			foreach ($response as $key => $item) {
				$sId = $item['id'];
				unset($item['id']);
				$data[$sId] = $item;
			}
		}
		
		if (!is_null($staticId) && !is_array($staticId)) {
			$data[$staticId]['id'] = $staticId;
			return $data[$staticId];
		}
		return $data;
	}
	
	
	
	
	
	/**
	 * Получить список статиков с запросами LIKE & WHERE
	 * @param массив данных по поиску LIKE
	 * @param массив данных по поиску WHERE
	 * @param фильтровать пустые статики (в которых не найдено ни одного участника)
	 * @param только имена статиков [static id => static name]
	 * @param Вернуть данные заданного статика
	 * @return [static id => static name] или [static id => static data]
	 */
	public function filterStatics($like = [], $where = [], $filterEmptyStatics = true, $nameOnly = false, $staticId = null) {
		$query = '';
		
		if ($where) {
			foreach ($where as $wField => $wValue) {
				if (!$wValue) continue;
				$query .= ' AND '.$wField.' = '.$wValue;
			}
		}
		
		if ($like) {
			foreach ($like as $lField => $lValue) {
				if (!$lValue) continue;
				$query .= ' AND '.$lField.' LIKE \''.$lValue.'%\' ESCAPE \'!\'';
			}
		}
		
		
		
		$this->db->select('s.*, (SELECT COUNT(us.id) FROM users_statics us JOIN users u ON us.user_id = u.id WHERE s.id = us.static_id AND u.deleted = 0 AND us.main = 1'.$query.') AS count_users');
		if (is_array($staticId)) $this->db->where_in('s.id', $staticId);
		elseif (!is_null($staticId)) $this->db->where('s.id', $staticId);
		$this->db->order_by('id', 'ASC');
		
		if (!$result = $this->_result('statics s')) return false;
		
		if ($filterEmptyStatics) {
			$result = array_filter($result, function($item) {
				return $item['count_users'] > 0;
			});
		}
		
		
		$data = [];
		if ($nameOnly) {
			foreach ($result as $item) {
				$data[$item['id']] = $item['name'];
			}
		} else {
			foreach ($result as $key => $item) {
				$sId = $item['id'];
				unset($item['id']);
				$data[$sId] = $item;
			}
		}
		
		if (!is_null($staticId) && !is_array($staticId)) {
			$data[$staticId]['id'] = $staticId;
			return $data[$staticId];
		}
		return $data;
	}
	
	
	
	
	

	/**
	 * Добавить, обновить список статиков
	 * @param 
	 * @return 
	*/
	public function addStatics($postData) {
		$tableStatics = $this->getStatics() ?: [];
		if ($newStatics = array_diff_key($postData, $tableStatics)) {
			if ($newStatics = array_filter($newStatics)) {
				$this->db->insert_batch('statics', array_values($newStatics));
			}
			
		}
		
		if ($updateStatics = array_intersect_key($postData, $tableStatics)) {
			foreach ($updateStatics as $key => $item) $updateStatics[$key]['id'] = $key;
			$this->db->update_batch('statics', array_values($updateStatics), 'id');
		}
		
		return 1;
	}
	
	
	
	public function removeStatics($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('statics')) {
			return 1;
		}
	}
	
	
	
	
	
	/**
	 * Получить локацию статика
	 * @param 
	 * @return 
	 */
	public function getStaticLocation($staticId) {
		$map = [
			1 => [
				'name' 			=> 'Универсальный',
				'location' 		=> 1,
				'timeoffset' 	=> 0
			], 
			2 => [
				'name' 			=> 'Европа',
				'location' 		=> 2,
				'timeoffset' 	=> 0
			], 
			3 => [
				'name' 			=> 'Америка',
				'location' 		=> 3,
				'timeoffset' 	=> 86400
			], 
		];
		
		$this->db->select('location');
		$this->db->where('id', $staticId);
		$query = $this->db->get('statics');
		if (!$response = $query->row_array()) return false;
		return isset($map[$response['location']]) ? $map[$response['location']] : false;
	}
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Цвета
	
	/**
	 * Получить список цветов
	 * @param только имена статиков [static id => static name]
	 * @param Вернуть данные заданного статика
	 * @return [static id => static name] или [static id => static data]
	 */
	public function getRaidersColors() {
		$query = $this->db->get('raiders_colors');
		if (!$response = $query->result_array()) return false;
		$data = [];
		foreach ($response as $key => $item) {
			$sId = $item['id'];
			unset($item['id']);
			$data[$sId] = $item;
		}
		return $data;
	}
	
	
	
	/**
	 * Добавить, обновить список цветов
	 * @param 
	 * @return 
	 */
	public function addRaidesColors($postData) {
		$tableStatics = $this->getStatics() ?: [];
		if ($newStatics = array_diff_key($postData, $tableStatics)) {
			if ($newStatics = array_filter($newStatics)) {
				$this->db->insert_batch('raiders_colors', array_values($newStatics));
			}
			
		}
		
		if ($updateStatics = array_intersect_key($postData, $tableStatics)) {
			foreach ($updateStatics as $key => $item) $updateStatics[$key]['id'] = $key;
			$this->db->update_batch('raiders_colors', array_values($updateStatics), 'id');
		}
		
		return 1;
	}
	
	
	
	public function removeRaidesColors($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('raiders_colors')) {
			return 1;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Звания
	/**
	 * Получить список званий
	 * @param сортировать по количеству дней по возрастанию
	 * @param в качестве ключей - ID
	 * @return array
	 */
	public function getRanks($sortAsPeriod = false, $setIdAsKey = true) {
		if ($sortAsPeriod) $this->db->order_by('period', 'ASC');
		$query = $this->db->get('ranks');
		if (!$ranksData = $query->result_array()) return [];
		
		
		if ($setIdAsKey) {
			$data = [];
			foreach ($ranksData as $item) {
				$id = arrTakeItem($item, 'id');
				$item['coefficient'] = json_decode($item['coefficient'], true);
				$data[$id] = $item;
			}
		} else {
			$data = $ranksData;
		}
		
		return $data;
	}
	
	
	
	public function addRanks($postData) {
		$tableRanks = $this->getRanks();
		$newRanks = array_diff_key($postData, $tableRanks);
		$updateRanks = array_intersect_key($postData, $tableRanks);
		
		$newRanks = array_filter($newRanks);
		
		if ($updateRanks) {
			foreach ($updateRanks as $key => $item) $updateRanks[$key]['id'] = $key;
			$this->db->update_batch('ranks', array_values($updateRanks), 'id');
		}
		
		if ($newRanks) {
			$this->db->insert_batch('ranks', array_values($newRanks));
		}
		return 1;
	}
	
	
	public function removeRanks($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('ranks')) {
			return 1;
		}
		return 0;
	}
	
	
	/**
	 * Получить ID первого звания
	 * @param 
	 * @return 
	 */
	public function getFirstRankId() {
		$this->db->select_min('id');
		$query = $this->db->get('ranks');
		if ($response = $query->row_array()) {
			return $response['id'];
		}
		return false;
	}
	
	
	
	
	/**
	 * Получить список званий заданных статиков
	 * @param статики
	 * @return array
	 */
	public function getStaticsRanks($staticsIds = false) {
		$this->db->select('r.id AS rank_id, r.name');
		$this->db->join('users u', 'u.rank = r.id', 'LEFT OUTER');
		$this->db->join('users_statics us', 'us.user_id = u.id', 'LEFT OUTER');
		$this->db->where_in('us.static_id', (array)$staticsIds);
		$this->db->distinct();
		$this->db->order_by('r.id', 'ASC');
		
		if (!$result = $this->_result('ranks r')) return false;
		
		$ranksData = [];
		foreach ($result as $row) {
			$ranksData[$row['rank_id']] = $row['name'];
		}
		
		return $ranksData;
	}
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Звания РЛ
	/**
	 * Получить список званий
	 * @param сортировать по количеству дней по возрастанию
	 * @param в качестве ключей - ID
	 * @return array
	 */
	public function getRanksLiders() {
		//if ($sortAsPeriod) $this->db->order_by('period', 'ASC');
		$query = $this->db->get('ranks_liders');
		if (!$ranksData = $query->result_array()) return [];
		
		$data = [];
		foreach ($ranksData as $item) {
			$id = arrTakeItem($item, 'id');
			//$item['coefficient'] = json_decode($item['coefficient'], true);
			$data[$id] = $item;
		}
		
		return $data;
	}
	
	
	
	public function addRanksLiders($postData = false) {
		$tableRanks = $this->getRanksLiders();
		$newRanks = array_diff_key($postData, $tableRanks);
		$updateRanks = array_intersect_key($postData, $tableRanks);
		
		$newRanks = array_filter($newRanks);
		
		if ($updateRanks) {
			foreach ($updateRanks as $key => $item) $updateRanks[$key]['id'] = $key;
			$this->db->update_batch('ranks_liders', array_values($updateRanks), 'id');
		}
		
		if ($newRanks) {
			$this->db->insert_batch('ranks_liders', array_values($newRanks));
		}
		return 1;
	}
	
	
	public function removeRanksLiders($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('ranks_liders')) {
			return 1;
		}
		return 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Роли
	/**
	 * Получить список ролей
	 * @return 
	*/
	public function getRoles() {
		$query = $this->db->get('roles');
		$rolesData = $query->result_array();
		
		$tableRoles = [];
		foreach ($rolesData as $item) {
			$itemId = $item['id'];
			unset($item['id']);
			$tableRoles[$itemId] = $item;
		}
		return $tableRoles;
	}
	
	
	public function addRoles($postData) {
		$tableRoles = $this->getRoles();
		$newRoles = array_diff_key($postData, $tableRoles);
		$updateRoles = array_intersect_key($postData, $tableRoles);
		
		$newRoles = array_filter($newRoles);
		
		if ($updateRoles) {
			foreach ($updateRoles as $key => $item) $updateRoles[$key]['id'] = $key;
			$this->db->update_batch('roles', array_values($updateRoles), 'id');
		}
		
		if ($newRoles) {
			$this->db->insert_batch('roles', array_values($newRoles));
		}
		return 1;
	}
	
	
	public function removeRoles($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('roles')) {
			return 1;
		}
	}
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Классы
	
	public function getClasses() {
		$query = $this->db->get('classes');
		if (!$response = $query->result_array()) return false;
		$data = [];

		foreach ($response as $key => $item) {
			$sId = $item['id'];
			unset($item['id']);
			$data[$sId] = $item;
		}
		return $data;
	}
	
	
	
	

	/**
	 * Добавить, обновить список статиков
	 * @param 
	 * @return 
	*/
	public function addClasses($postData) {
		$tableClasses = $this->getClasses() ?: [];
		if ($newClasses = array_diff_key($postData, $tableClasses)) {
			if ($newClasses = array_filter($newClasses)) {
				$this->db->insert_batch('classes', array_values($newClasses));
			}
			
		}
		
		if ($updateClasses = array_intersect_key($postData, $tableClasses)) {
			foreach ($updateClasses as $key => $item) $updateClasses[$key]['id'] = $key;
			$this->db->update_batch('classes', array_values($updateClasses), 'id');
		}
		
		return 1;
	}
	
	
	
	public function removeClasses($id) {
		$this->db->where('id', $id);
		if (!$this->db->delete('classes')) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Наставничество
	/**
	 * @param 
	 * @return 
	 */
	public function getMentorsRequests($requestId = false) {
		$statuses = [
			0 => 'Отказано',
			1 => 'Одобрено'
		];
		
		$this->db->select('mr.id, mr.user_id, mr.mentor_id, mr.date, mr.status, mr.done, c.name AS class_name');
		$this->db->join('classes c', 'c.id = mr.class', 'LEFT OUTER');
		$this->db->order_by('mr.id', 'DESC');
		$query = $this->db->get('mentors_requests mr');
		if (!$result = $query->result_array()) return false;
		
		$allUsersIds = array_unique(array_merge(array_column($result, 'user_id'), array_column($result, 'mentor_id')));
		
		$this->db->select('u.id, u.nickname, u.avatar, s.name AS static');
		$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->join('statics s', 's.id = us.static_id', 'LEFT OUTER');
		
		
		$this->db->where('us.main', 1);
		$this->db->where_in('u.id', $allUsersIds);
		$query = $this->db->get('users u');
		if (!$usersData = $query->result_array()) return false;
		$usersData = setArrKeyFromField($usersData, 'id');
		
		$mentorsRequests = [];
		foreach ($result as $item) {
			$item['status'] = $item['status'];
			$item['status_text'] = is_null($item['status']) ? 'На рассмотрении' : $statuses[$item['status']];
			$item['user'] = isset($usersData[$item['user_id']]) ? $usersData[$item['user_id']] : null;
			$item['mentor'] = isset($usersData[$item['mentor_id']]) ? $usersData[$item['mentor_id']] : null;
			$stat = is_null($item['done']) ? 'active' : 'archive';
			$mentorsRequests[$stat][] = $item;
		}
		
		return $mentorsRequests;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getRequestPayData($requestId = false) {
		if (!$requestId) return false;
		$this->db->select('mr.id, mr.mentor_id AS user_id, mr.mentor_static AS static, s.name AS static_name, u.nickname, u.avatar, u.payment');
		$this->db->where('mr.id', $requestId);
		$this->db->join('users u', 'u.id = mr.mentor_id', 'LEFT OUTER');
		$this->db->join('statics s', 's.id = mr.mentor_static', 'LEFT OUTER');
		$query = $this->db->get('mentors_requests mr');
		if (!$reqData = $query->row_array()) return false;
		return $reqData;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function changeMentorsRequestStat($id = false, $status = false) {
		if (!$id || $status === false) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('mentors_requests', ['status' => $status])) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function addRequestToPay($data = false) {
		if (!$data) return false;
		$reqId = $data['id'];
		unset($data['id']);
		$data['date'] = time();
		if (!$this->db->insert('users_orders', $data)) return false;
		
		$ratingPeriodId = $this->getActiveRatingsPeriodId();
		$this->db->where('id', $reqId);
		if (!$this->db->update('mentors_requests', ['period_id' => $ratingPeriodId, 'done' => time()])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Уровни доступа
	public function getAccountsAccess($decode = true) {
		$query = $this->db->get('accounts_access');
		$accountsAccessData = $query->result_array();
		
		$defaultAccess = $this->getSettings('default_access_setting');
		
		$tableAccountsAccess = [];
		foreach ($accountsAccessData as $item) {
			$itemId = $item['id'];
			unset($item['id']);
			if ($itemId == $defaultAccess) $item['default'] = 1;
			if ($decode) $item['access'] = json_decode($item['access'], true);
			$tableAccountsAccess[$itemId] = $item;
		}
		return $tableAccountsAccess;
	}
	
	
	public function addAccountsAccess($postData) {
		$tableAccountsAccess = $this->getAccountsAccess(false);
		$newAccountsAccess = array_diff_key($postData, $tableAccountsAccess);
		$updateAccountsAccess = array_intersect_key($postData, $tableAccountsAccess);
		
		$newAccountsAccess = array_filter($newAccountsAccess);
		
		if ($updateAccountsAccess) {
			foreach ($updateAccountsAccess as $key => $item) $updateAccountsAccess[$key]['id'] = $key;
			$this->db->update_batch('accounts_access', array_values($updateAccountsAccess), 'id');
		}
		
		if ($newAccountsAccess) {
			$this->db->insert_batch('accounts_access', array_values($newAccountsAccess));
		}
		return 1;
	}
	
	
	public function removeAccountsAccess($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('accounts_access')) {
			return 1;
		}
	}
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Рейды
	public function getRaidsTypes() {
		$query = $this->db->get('raids_types');
		$raidsTypesData = $query->result_array();
		
		$tableRaidsTypes = [];
		foreach ($raidsTypesData as $item) {
			$itemId = $item['id'];
			unset($item['id']);
			$tableRaidsTypes[$itemId] = $item;
		}
		return $tableRaidsTypes;
	}
	
	
	public function addRaidsTypes($postData) {
		$tableRaidsTypes = $this->getRaidsTypes();
		$newRaidsTypes = array_diff_key($postData, $tableRaidsTypes);
		$updateRaidsTypes = array_intersect_key($postData, $tableRaidsTypes);
		
		
		if ($updateRaidsTypes) {
			foreach ($updateRaidsTypes as $key => $item) $updateRaidsTypes[$key]['id'] = $key;
			$this->db->update_batch('raids_types', array_values($updateRaidsTypes), 'id');
		}
		
		if ($newRaidsTypes) {
			$this->db->insert_batch('raids_types', array_values($newRaidsTypes));
		}
		return 1;
	}
	
	
	public function removeRaidsTypes($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('raids_types')) {
			return 1;
		}
	}
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Ключи
	public function getKeysTypes() {
		$query = $this->db->get('keys_types');
		$keysTypesData = $query->result_array();
		
		$tableKeysTypes = [];
		foreach ($keysTypesData as $item) {
			$itemId = $item['id'];
			unset($item['id']);
			$tableKeysTypes[$itemId] = $item;
		}
		return $tableKeysTypes;
	}
	
	
	public function addKeysTypes($postData) {
		$tableKeysTypes = $this->getKeysTypes();
		$newKeysTypes = array_diff_key($postData, $tableKeysTypes);
		$updateKeysTypes = array_intersect_key($postData, $tableKeysTypes);
		
		
		if ($updateKeysTypes) {
			foreach ($updateKeysTypes as $key => $item) $updateKeysTypes[$key]['id'] = $key;
			$this->db->update_batch('keys_types', array_values($updateKeysTypes), 'id');
		}
		
		if ($newKeysTypes) {
			$this->db->insert_batch('keys_types', array_values($newKeysTypes));
		}
		return 1;
	}
	
	
	public function removeKeysTypes($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('keys_types')) {
			return 1;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить сообщения для ленты новостей
	 * @param лимит новостей для каждого статика
	 * @return 
	 */
	public function getFeedMessages($limit = false) {
		$this->db->order_by('id', 'DESC');
		$query = $this->db->get('feed_messages');
		$data = [];
		if ($response = $query->result_array()) {
			foreach ($response as $item) {
				$static = $item['static'];
				unset($item['static']);
				$data[$static][] = $item;
			}
			if ($limit) {
				foreach ($data as $static => $news) {
					$data[$static] = array_slice($news, 0, $limit);
				}
			}
		}
		
		return $data;
	}
	
	
	
	
	/**
	 * Получить сообщения для ленты новостей опредеоенного статика
	 * @param ID статика
	 * @return 
	 */
	public function getFeedMessagesStatic($statics) {
		if (!$statics) return false;
		$this->db->where_in('static', $statics);
		$this->db->order_by('static', 'ASC');
		$this->db->order_by('id', 'DESC');
		$query = $this->db->get('feed_messages');
		if (!$response = $query->result_array()) return false;
		
		$staticsMessages = [];
		foreach ($response as $item) {
			$staticId = $item['static'];
			unset($item['static']);
			$staticsMessages[$staticId][] = $item;
		}
		return $staticsMessages;
	}
	
	
	
	
	
	
	/**
	 * Сохранить сообщение для ленты новостей
	 * @param данные сообщения
	 * @return ID и дата
	 */
	public function saveFeedMessage($data) {
		$date = time();
		$insert = [
			'static' 	=> $data['static'],
			'title' 	=> $data['title'],
			'icon' 		=> $data['icon'],
			'message' 	=> $data['message'],
			'date' 		=> $date,
		];
		
		$this->db->insert('feed_messages', $insert);
		$insertId = $this->db->insert_id();
		
		if (isset($data['clone_to_statics']) && ($cloneToStatics = $data['clone_to_statics'])) {
			$cloneData = [];
			foreach ($cloneToStatics as $stId) {
				$cloneData[] = [
					'static' 	=> $stId,
					'title' 	=> $data['title'],
					'icon' 		=> $data['icon'],
					'message' 	=> $data['message'],
					'date' 		=> $date,
				];
			}
			$this->db->insert_batch('feed_messages', $cloneData);
		}
		
		return ['id' => $insertId, 'date' => $date];
	}
	
	
	
	
	
	/**
	 * Обновить сообщение для ленты новостей
	 * @param данные сообщения
	 * @return статус
	 */
	public function updateFeedMessage($data) {
		$this->db->where('id', $data['id']);
		if ($this->db->update('feed_messages', ['title' => $data['title'], 'icon' => $data['icon'], 'message' => $data['message']])) {
			return 1;
		}
		return 0;
	}
	
	
	
	
	
	
	
	/**
	 * Удалить сообщение ленты новостей
	 * @param ID сообщения
	 * @return статус
	 */
	public function removeFeedMessage($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('feed_messages')) {
			return 1;
		}
		return 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Операторы
	public function getOperators() {
		$this->load->library('encryption');
		$query = $this->db->get('operators');
		$operatorsData = $query->result_array();
		
		$tableOperators = [];
		foreach ($operatorsData as $item) {
			$itemId = $item['id'];
			unset($item['id']);
			$item['password'] = $this->encryption->decrypt($item['password']);
			$tableOperators[$itemId] = $item;
		}
		return $tableOperators;
	}
	
	
	public function addOperators($postData) {
		$this->load->library('encryption');
		$tableOperators = $this->getOperators();
		$newOperators = array_diff_key($postData, $tableOperators);
		$updateOperators = array_intersect_key($postData, $tableOperators);
		
		
		if ($updateOperators) {
			foreach ($updateOperators as $key => $item) {
				$updateOperators[$key]['password'] = $this->encryption->encrypt($item['password']);
				$updateOperators[$key]['id'] = $key;
			} 
			$this->db->update_batch('operators', array_values($updateOperators), 'id');
		}
		
		if ($newOperators) {
			foreach ($newOperators as $key => $item) {
				$newOperators[$key]['password'] = $this->encryption->encrypt($item['password']);
			}
			$this->db->insert_batch('operators', array_values($newOperators));
		}
		return 1;
	}
	
	
	public function removeOperators($id) {
		$this->db->where('id', $id);
		if ($this->db->delete('operators')) {
			return 1;
		}
	}
	
	
	
	
	
	
	/**
	 * Получить расписание работы всех операторов
	 * @param дата начала периода
	 * @param дата окончания периода
	 * @return 
	 */
	public function getOperatorsHourssheet($dateStart = false, $dateEnd = false) {
		if (!$dateStart || !$dateEnd) return false;
		
		$this->db->where(['date >=' => $dateStart, 'date <=' => $dateEnd]);
		$query = $this->db->get('operators_hourssheet');
		if (!$response = $query->result_array()) return false;
		
		$data = [];
		foreach ($response as $item) {
			$operatorId = $item['operator_id'];
			$date = $item['date'];
			unset($item['operator_id'], $item['date']);
			$data[$operatorId][$date][] = $item;
		}
		
		return $data;
	}
	
	
	
	
	
	/**
	 * Получить расписание работы оператора 
	 * @param ID оператора
	 * @param дата
	 * @return 
	 */
	public function getOperatorHourssheet($operatorId = false, $date = false) {
		if (!$operatorId || !$date) return false;
		
		$this->db->where(['operator_id' => $operatorId, 'date' => $date]);
		$this->db->order_by('id', 'ASC');
		$query = $this->db->get('operators_hourssheet');
		if (!$response = $query->result_array()) return false;
		return $response;
	}
	
	
	
	
	
	/**
	 * Сохранить расписание работы оператора
	 * @param 
	 * @return 
	 */
	public function operatorsHourssheetSave($data = false) {
		if (!$data) return false;
		
		if (isset($data['hourssheet']['has']) && !empty($data['hourssheet']['has'])) {
			$update = [];
			foreach ($data['hourssheet']['has'] as $id => $item) {
				$item['id'] = $id;
				$update[] = $item;
			}
			
			$this->db->update_batch('operators_hourssheet', $update, 'id');
		}
		
		
		if (isset($data['hourssheet']['new']) && !empty($data['hourssheet']['new'])) {
			
			foreach ($data['hourssheet']['new'] as $key => $item) {
				$data['hourssheet']['new'][$key]['operator_id'] = $data['operator_id'];
				$data['hourssheet']['new'][$key]['date'] = $data['date'];
			}
			
			if (isset($data['clone_dates']) && !empty($data['clone_dates'])) {
				$cloneUpdate = [];
				foreach ($data['hourssheet']['new'] as $item) {
					foreach ($data['clone_dates'] as $date) {
						$item['date'] = $date;
						$cloneUpdate[] = $item;
					}
				}
				$this->db->insert_batch('operators_hourssheet', $cloneUpdate);
			}
			
			$this->db->insert_batch('operators_hourssheet', $data['hourssheet']['new']);
		}
	}
	
	
	
	
	/**
	 * Удалить часы работы оператора
	 * @param 
	 * @return 
	 */
	public function operatorsHourssheetDelete($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		$this->db->delete('operators_hourssheet');
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Разделы
	
	
	/**
	 * Получить список разделов
	 * @param ID родительской категории
	 * @return 
	 */
	public function getGuideChapters($parentId = 0) {
		$this->db->select('id, title');
		$this->db->where('parent_id', $parentId);
		$this->db->order_by('sort', 'ASC');
		$query = $this->db->get('guides');
		if (!$response = $query->result_array()) return false;
		return $response;
	}
	
	
	/**
	 * Получить данные раздела
	 * @param id
	 * @return id parent_id title content
	 */
	public function getGuideChapter($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		$query = $this->db->get('guides');
		if (!$response = $query->row_array()) return false;
		return $response;
	}
	
	
	
	/**
	 * Сохранить раздел
	 * @param 
	 * @return 
	 */
	public function guideChaptersSave($data) {
		if (!$data) return false;
		if (isset($data['update']) && $data['update'] == 1) {
			$this->db->where('id', $data['id']);
			$this->db->update('guides', ['parent_id' => $data['parent_id'], 'title' => $data['title'], 'content' => $data['content'], 'sort' => $data['sort']]);
		} else {
			$this->db->insert('guides', $data);
		}
		return true;
	}
	
	
	/**
	 * Удалить раздел
	 * @param 
	 * @return 
	 */
	public function guideChapterDelete($id) {
		if (!$id) return false;

		function getChildrenChapters($id) {
			static $chapters = [];
			if ($childChapters = Admin_model::_getChapters($id)) {
				foreach ($childChapters as $chapter) {
					$chapters[] = $chapter;
					getChildrenChapters($chapter);
				}
			}
			return $chapters;
		}
		
		$chapters = getChildrenChapters($id);
		array_unshift($chapters, $id);
		
		$this->db->where_in('id', $chapters);
		if ($this->db->delete('guides')) return true;
		return false;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public static function _getChapters($id) {
		$CI =& get_instance();
		$CI->db->select('id');
		$CI->db->where('parent_id', $id);
		$query = $CI->db->get('guides');
		if (!$response = $query->result_array()) return false;
		$chaptersIds = [];
		foreach ($response as $item) $chaptersIds[] = $item['id'];
		return $chaptersIds;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Персонажи
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesGet($userId = null) {
		$this->db->select('up.*, u.avatar AS user_avatar, u.nickname AS user_nickname');
		$this->db->join('users u', 'up.from_id = u.id', 'left outer');
		if (!is_null($userId)) $this->db->where('from_id', $userId);
		else $this->db->where('game_id', null);
		$query = $this->db->get('users_personages up');
		$result = $query->result_array();
		return $result;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesGetByGameId($gameId = false, $fromId = false) {
		$this->db->select('up.*, u.avatar AS user_avatar, u.nickname AS user_nickname');
		$this->db->join('users u', 'up.from_id = u.id', 'left outer');
		if ($gameId) $this->db->where('game_id', $gameId);
		if ($fromId) {
			$this->db->where('from_id', $fromId);
			$this->db->where('game_id is NULL', NULL, FALSE);
		}
		$this->db->order_by('up.id', 'ASC');
		$query = $this->db->get('users_personages up');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesGetGameIds($userId = false) {
		if (!$userId) return false;
		$this->db->select('up.game_id');
		$this->db->where('up.game_id !=', null);
		if (is_numeric($userId)) $this->db->where('up.from_id !=', $userId);
		$pQuery = $this->db->get('users_personages up');
		$ids = [];
		if ($pResult = $pQuery->result_array()) $ids = array_values(array_unique(array_column($pResult, 'game_id')));
		
		$this->db->select('pgi.id, pgi.game_id');
		if ($ids) $this->db->where_not_in('pgi.id', $ids);
		$query = $this->db->get('personages_game_ids pgi');
		$result = $query->result_array();
		return $result ?: false;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesSave($data = false) {
		if (!$data) return false;
		foreach ($data as $k => $item) {
			if (!isset($item['game_id'])) unset($data[$k]);
		}
		if ($this->db->update_batch('users_personages', array_values(bringTypes($data)), 'id')) return true;
		return false;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesRemove($id = false) {
		if (!$id) return false;
		$this->load->model('kpi_model', 'kpi');
		
		$this->kpi->removePersonages($id);
		
		$this->db->where('id', $id);
		if ($this->db->delete('users_personages')) return true;
		return false;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesUntie($id = false) {
		if (!$id) return false;
		$this->load->model('kpi_model', 'kpi');
		
		$this->kpi->removePersonages($id);
		
		$this->db->where('id', $id);
		if ($this->db->update('users_personages', ['game_id' => null])) return true;
		return false;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function personagesSaveForm($data = false) {
		if (!$data) return false;
		if ($this->db->insert('users_personages', $data)) return $this->db->insert_id();
		return false;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- ID игр
	
	/**
	 * @param 
	 * @return place
	 */
	public function gameIdsGet($data = false) {
		$searchByNicknameIds = false;
		if (isset($data['field']) && $data['field'] == 'u.nickname' && !empty($data['search'])) {
			$this->db->like('nickname', $data['search']);
			$this->db->select('id');
			$uQuery = $this->db->get('users');
			if ($uResult = $uQuery->result_array()) {
				$searchByNicknameIds = array_column($uResult, 'id');
			}
		}

		$this->db->select('pgi.id, pgi.game_id, pgi.user_id, COUNT(up.id) AS personages_count, pgi.date_add, pgi.date_end, u.id AS user_id, u.nickname, u.avatar');
		$this->db->join('users_personages up', 'up.game_id = pgi.id', 'left outer');
		$this->db->join('users u', 'u.id = pgi.user_id', 'left outer');
		
		
		
		if ($searchByNicknameIds) $this->db->where_in('user_id', $searchByNicknameIds);
		elseif (isset($data['field']) && isset($data['search'])) $this->db->like($data['field'], $data['search'], isset($data['place']) ? $data['place'] : 'both');
		if (isset($data['where'])) {
			foreach ($data['where'] as $rule) {
				$method = $rule['method'];
				$this->db->$method($rule['rule'], $rule['value']);
			}
		} 
				
		$this->db->group_by('pgi.id');
		$this->db->order_by('pgi.id', 'ASC');
		$query = $this->db->get('personages_game_ids pgi');
		if (!$result = $query->result_array()) return false;
		
		$data = [];
		foreach ($result as $k => $item) {
			$data[$item['id']] = $item;
			unset($result[$k]);
		}
		
		return array_values($data) ?: false;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function gameIdSave($fields = false) {
		if (!$fields['game_id']) return false;
		
		$date = time();
		$insert = [
			'game_id' 	=> $fields['game_id'],
			'date_add' 	=> $date
		];
		
		if ($fields['extend']) $insert['date_end'] = $date + ($fields['extend'] * 24 * 60 * 60);
		
		if ($this->db->insert('personages_game_ids', $insert)) return $this->db->insert_id();
		return false;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function gameIdRemove($id = false, $removePersonages = false) {
		if (!$id) return false;
		$this->load->model('kpi_model', 'kpi');
		$this->db->where('id', $id);
		if ($this->db->delete('personages_game_ids')) {
			$this->db->select('id');
			$this->db->where('game_id', $id);
			if (!$personagesToRemove = $this->_result('users_personages')) return false;
			$personagesToRemove = array_column($personagesToRemove, 'id');
			
			$this->kpi->removePersonages($personagesToRemove); // удаление персонажей из KPI
			
			$this->db->where_in('id', $personagesToRemove);
			if ($removePersonages) {
				if ($this->db->delete('users_personages')) return true;
			} else {
				if ($this->db->update('users_personages', ['game_id' => null])) return true;
			}
		} 
		return false;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function gameIdUpdate($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		
		$update = ['game_id' => $fields['game_id']];
		
		if (isset($fields['user_id']) && $fields['user_id']) $update['user_id'] = $fields['user_id'];
		
		if ($fields['extend']) {
			$countMs = ($fields['extend'] * 24 * 60 * 60);
			$date = strtotime('today');
			
			$this->db->where('id', $id);
			$query = $this->db->get('personages_game_ids');
			if (!$result = $query->row_array()) return false;
			$statedDate = $result['date_end'];
			
			if ($statedDate <= $date) {
				$update['date_end'] = $date + $countMs;
			} else {
				$update['date_end'] = $statedDate + $countMs;
			}
			
		}
		
		$this->db->where('id', $id);
		if ($this->db->update('personages_game_ids', $update)) return true;
		return false;
	}
	
	
	
	
	
	public function gameIdsGetTiedUsers() {
		$this->db->select('user_id');
		$this->db->where('user_id !=', null);
		$query = $this->db->get('personages_game_ids');
		if (!$result = $query->result_array()) return false;
		$data = array_keys(setArrKeyFromField($result, 'user_id'));
		return $data ?: false;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function gameIdUntieUser($gameId = false) {
		if (!$gameId) return false;
		$this->db->where('id', $gameId);
		$this->db->set('user_id', null);
		if ($this->db->update('personages_game_ids')) return true;
		return false;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function gameIdTiePersonages($gameId = false, $personagesIds = false) {
		if (!$gameId || !$personagesIds) return false;
		$this->db->where_in('id', $personagesIds);
		$this->db->set('game_id', $gameId);
		if ($this->db->update('users_personages')) return true;
		return false;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Заявки на оплату шаблоны
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function paymentRequestsGet() {
		$query = $this->db->get('payment_requests_templates');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function paymentRequestsGetData($prId) {
		//$this->db->select('prd.*, u.avatar, u.nickname, us.static_id AS static');
		//$this->db->join('users u', 'prd.user_id = u.id');
		//$this->db->join('users_statics us', 'us.user_id = u.id');
		$this->db->where(['prd.pr_id' => $prId]);
		$query = $this->db->get('payment_requests_data prd');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function paymentRequestsSave($data = false) {
		if (!$data) return false;
		if (!$this->db->insert('payment_requests_templates', $data)) return false;
		return $this->db->insert_id();
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function paymentRequestsUpdate($id = false, $data = false) {
		if (!$id || !$data) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('payment_requests_templates', $data)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function paymentRequestsRemove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if ($this->db->delete('payment_requests_templates')) return true;
		return false;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function paymentRequestsSaveTempData($prId, $data) {
		$this->db->where('pr_id', $prId);
		$this->db->delete('payment_requests_data');
		if ($this->db->insert_batch('payment_requests_data', $data)) {
			return true;
		}
	}
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Добавить оплату в историю
	
	/**
	 * @param 
	 * @return 
	*/
	public function globalDepositHistoryAdd($data = false, $batch = false) {
		if (!$data) return false;
		if ($batch)  {
			if (!$this->db->insert_batch('global_deposit_history', $data)) return false;
			return true;
		} else {
			if (!$this->db->insert('global_deposit_history', $data)) return false;
			return $this->db->insert_id();
		}
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function globalDepositHistoryGet() {
		$reasons = [
			1 => 'Выплата резерва',
			2 => 'Начисление из отчета',
			3 => 'Третья причина',
		];
		
		$statuses = [
			0 => 'Возврат',
			1 => 'Выплата'
		];
		$this->load->model('users_model');
		
		$this->db->order_by('date', 'DESC');
		$query = $this->db->get('global_deposit_history');
		if (!$result = $query->result_array()) return false;
		$historyUsers = array_column($result, 'user_id');
		
		
		$usersData = $this->users_model->getUsers(['where_in' => ['field' => 'u.id', 'values' => $historyUsers]]);
		$usersData = setArrKeyFromField($usersData, 'id', false, ['nickname', 'avatar']);
		
		$history = [];
		foreach ($result as $item) {
			$item['reason'] = $reasons[$item['reason']];
			$item['stat'] = $statuses[$item['stat']];
			$item['nickname'] = $usersData[$item['user_id']]['nickname'];
			$item['avatar'] = $usersData[$item['user_id']]['avatar'];
			$history[] = $item;
		}
		return $history;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------- Заявки на увольнение
	
	/**
	 * Получить список заявок
	 * @param 
	 * @return 
	 */
	public function getResigns() {
		$this->db->order_by('id', 'DESC');
		if (!$resignsList = $this->_result('resign')) return false;
		
		$this->load->model('users_model', 'users');
		$userIds = array_unique(array_column($resignsList, 'user_id'));
		
		$usersData = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $userIds], 'where' => ['us.main' => 1]]);
		$usersData = setArrKeyFromField($usersData, 'id');
		$statics = $this->getStatics();
		$operators = $this->getOperators();
		
		$finaData = [];
		foreach ($resignsList as $k => $item) {
			if (!isset($usersData[$item['user_id']])) continue;
			$item['nickname'] = $usersData[$item['user_id']]['nickname'];
			$item['date_reg'] = $usersData[$item['user_id']]['reg_date'];
			$item['avatar'] = $usersData[$item['user_id']]['avatar'];
			$item['static'] = $statics[$usersData[$item['user_id']]['static']]['name'];
			if ($item['stat'] == 0) $item['from'] = $item['from'] != 0 ? $operators[$item['from']]['nickname'] : 0;
			$finaData[$item['new']][$item['stat']][] = $item;
		}
		
		return $finaData;
	}
	
	
	
	
	
	
	/**
	 * Изменить статус заявки
	 * @param 
	 * @return 
	 */
	public function changeResignStat($data = false) {
		if (!$data) return false;
		$this->db->where('id', $data['id']);
		$from = $data['from'] == 'admin' ? 0 : $data['from'];
		$update = ['new' => 0, 'stat' => $data['stat'], 'from' => $from];
		if ($data['stat'] == 0) $update['date_success'] = time();
		if (isset($data['summ']) && $data['summ']) $update['summ'] = $data['summ'];
		if (isset($data['summ_to_balance']) && $data['summ_to_balance']) $update['summ_to_balance'] = $data['summ_to_balance'];
		if (!$this->db->update('resign', $update)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function insertResignOrder($order = false) {
		if (!$order) return false;
		if (!$this->db->insert('users_orders', $order)) return false;
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function showResign($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$data = $this->_row('resign')) return false;
		$this->load->model('users_model');
		$userData = $this->users_model->getUsers(['where' => ['u.id' => $data['user_id'], 'us.main' => 1]]);
		
		$static = $this->getStatics(false, $userData[0]['static']);
		
		$data['user_id'] = $userData[0]['id'];
		$data['nickname'] = $userData[0]['nickname'];
		$data['avatar'] = $userData[0]['avatar'];
		$data['reg_date'] = $userData[0]['reg_date'];
		$data['deposit'] = $userData[0]['deposit'];
		$data['static'] = $static;
		
		return $data;
	}
	
	
	
	
	/**
	 * Изменить дату последнего рабочего дня
	 * @param 
	 * @return 
	 */
	public function changeResignLastday($id = false, $date = false) {
		if (!$id || !$date) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('resign', ['date_last' => strtotime(date('Y-m-d', strtotime($date)))])) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * Обработать заявку
	 * @param 
	 * @return 
	*/
	public function setViedResign($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('resign', ['new' => 0, 'notify' => 1])) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function removeResign($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete('resign')) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function setOrderToBalance($order = false) {
		if (!$order) return false;
		if (!$this->db->insert('balance', $order)) return false;
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getBalance() {
		if (!$result = $this->_result('balance')) return false;
		$statics = $this->getStatics();
		$balance = ['items' => [], 'total' => 0];
		foreach ($result as $row) {
			if ($row['reset'] == 0) $balance['total'] += (int)$row['summ'];
			$row['static'] = $statics[$row['static']];
			$balance['items'][] = $row;
		}
		return $balance;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getBalanceHistory() {
		$this->db->order_by('id', 'DESC');
		if (!$result = $this->_result('balance_history')) return false;
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function resetBalance() {
		$this->db->select('SUM(summ)');
		$this->db->where('reset', 0);
		if (!$totalSumm = $this->_row('balance')) return 0;
		
		$insData = [
			'summ' => $totalSumm,
			'date' => time(),
		];
		
		if (!$this->db->insert('balance_history', $insData)) return -1;
		
		$this->db->where('reset', 0);
		if (!$this->db->update('balance', ['reset' => 1])) return -2;
		return 1;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function changeNdaStat($data = false) {
		$this->db->where('id', $data['user_id']);
		if (!$this->db->update('users', ['nda' => $data['stat']])) return false;
		return true;
	}
	
	
	
	
	
	
	
	//----------------------------------------------- Стоп-лист
	/**
	 * @param 
	 * @return 
	*/
	public function getStopList($type = false) {
		$this->db->select('id, item_id');
		if (!$type) $this->db->select('type');
		if ($type) $this->db->where('type', $type);
		if (!$result = $this->_result('stop_list')) return false;
		
		if ($type) return $result;
		
		$data = [];
		foreach ($result as $row) {
			$tp = arrTakeItem($row, 'type');
			$data[$tp][] = $row;
		}
		return $data;
	}
	
	
	
	/**
	 * Добавить записи в стоп-лист
	 * @param 
	 * @return 
	*/
	public function insertInStopList($itemsIds = false, $type = false) {
		if (!$itemsIds || !$type) return false;
		
		$insIds = [];
		foreach ($itemsIds as $id) {
			if ($this->db->insert('stop_list', ['item_id' => $id,'type' => $type])) {
				$insIds[$id] = $this->db->insert_id();
			}
		}
		
		return $insIds ?: false;
	}
	
	
	
	
	/**
	 * Удалить запись из стоп-листа
	 * @param 
	 * @return 
	*/
	public function removeFromStopList($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete('stop_list')) return false;
		return true;
	}
	
	
	
}