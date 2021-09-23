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
		$info = bringTypes($info);
		
		$data = [];
		switch ($actionType) {
			case 1: // Изменение статиков участника
				foreach ($info as $stat => $items) foreach ($items as $item) {
					$data['user_id'] = arrTakeItem($item, 'user_id');
					$data['statics'][$stat][] = $item;
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