<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Adminaction {
	
	private $CI;
	private $table = 'admins_actions';
	
	public function __construct() {
		$this->CI =& get_instance();
	}
	
	
	
	
	/**
	 * Записать действие администратора
	 * @param Тип действия integer
	 * @param данные в произвольном виде mixed
	 * @return 
	 */
	public function setAdminAction($actionType = false, $info = false) {
		if (!$actionType || !$info) return false;
		if (isJson($info)) $info = json_decode($info, true);
		$info = bringTypes($info) ?: false;
		
		$data = [];
		switch ($actionType) {
			case 1: // Изменение статиков участника
				if ($info) {
					foreach ($info as $period => $statics) { // период (до после) => статики
						if ($statics) {
							foreach ($statics as $static) {
								$data['user_id'] = arrTakeItem($static, 'user_id');
								$data['statics'][$period][] = $static;
							}
						} else {
							$data['statics'][$period] = null;
						}	
					} 
				}
				break;
			
			case 2: // Исключить/вернуть исключенного участника
				$data = $info;
				break;
				
			case 3: // Удалить/вернуть удаленного участника
				$data = $info;
				break;
			
			case 4: // Изменить платежные данные участника
				$data = $info;
				break;
			
			case 5: // Создание/удаление/изменение заявок на оплату
				// simple - новая заявка на оплату [type, order]
				// template - новая заявка из шаблона [type, title]
				// salary_orders - Рассчитать оклады [type, order]
				// addictpay_orders - Дополнительные выплаты [type, order]
				// remove - удалить заявку на оплату
				
				if (isset($info['users'])) {
					$usersData = [];
					foreach ($info['users'] as $item) {
						$usersData[] = [
							'user_id'	=> $item['user_id'],
							'summ' 		=> $item['summ']
						];
					}
					$info['users'] = $usersData;
				}
				
				$data = $info;
				break;
			
			case 6: // резерв начисление списание изменение плат. данных
				$data = $info;
				break;
			
			case 7: // баланс - списание 
				$data = $info;
				break;
			
			
			
			default: break;
		}
		
		$insData = [
			'admin_id' 	=> $this->getAdminId(),
			'type' 		=> $actionType,
			'info'		=> !isJson($data) ? json_encode($data) : $data,
			'date' 		=> time()
		];
		
		if (!$this->CI->db->insert($this->table, $insData)) return false;
		return true;
	}
	
	
	
	
	protected function getAdminId() {
		if ($token = get_cookie('token')) return decrypt($token);
		return 0;
	}
	
}