<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Timesheet extends MY_Controller {
	
	private $dayOffsets;
	
	public function __construct() {
		parent::__construct();
		$this->load->model('timesheet_model');
		
		
		$this->dayOffsets = [
			0 => 0, 	// без значения
			1 => (60 * 60 * 24 * 1), // Универсальный
			2 => (60 * 60 * 24 * 1), // Европа
			3 => 0, // Америка
		];
			
		
		
		
	}
	
	
	
	
	
	/**
	 * Получить список периодов расписания
	 * @param 
	 * @return 
	 */
	public function get_timesheet_periods() {
		$toUser = $this->input->post('to_user');
		$attr = $this->input->post('attr') ?: null;
		$toOperatior = $this->input->post('to_operator');
		if ($toUser) $template = 'views/account/render/timesheet_periods_list.tpl';
		elseif ($toOperatior) $template = 'views/operator/render/timesheet_periods_list.tpl';
		else $template = 'views/admin/render/timesheet_periods_list.tpl';
		$timesheetPeriods = $this->timesheet_model->getTimesheetPeriods();
		echo $this->twig->render($template, ['timesheet_periods' => bringTypes($timesheetPeriods), 'to_user' => $toUser, 'to_operator' => $toOperatior, 'attr' => $attr]);
	}
	
	
	
	
	/**
	 * Получить период расписания
	 * @param 
	 * @return 
	 */
	public function getTimesheetPeriod($periodId = null) {
		return $this->timesheet_model->getTimesheetPeriods($periodId);
	}
	
	
	
	
	/**
	 * Добавить новый период
	 * @param 
	 * @return ID нового периода
	 */
	public function new_timesheet_period() {
		$startDatePoint = (date('l', time()) == 'Tuesday') ? strtotime('today') : strtotime("next Tuesday");
		$weeks = getDatesRange($startDatePoint, 3, 'week', '+');
		echo $this->twig->render('views/admin/render/new_timesheet_period.tpl', ['weeks' => $weeks]);
	}
	
	
	
	
	/**
	 * Сохраняет период
	 * @param 
	 * @return 
	 */
	public function save_timesheet_period() {
		$data = $this->input->post();
		echo $this->timesheet_model->saveTimesheetPeriod($data);
	}
	
	
	
	/**
	 * Копировать период
	 * @param 
	 * @return 
	 */
	public function copy_timesheet_period() {
		$data = $this->input->post();
		echo $this->timesheet_model->copyTimesheetPeriod($data);
	}
	
	
	
	/**
	 * Сохраняет период
	 * @param 
	 * @return 
	 */
	public function remove_timesheet_period() {
		$periodId = $this->input->post('period_id');
		echo $this->timesheet_model->removeTimesheetPeriod($periodId);
	}
	
	
	
	
	
	
	/**
	 * Получить расписания
	 * @param 
	 * @return 
	 */
	public function get_timesheet_data() {
		if (!$periodId = $this->input->post('period_id')) exit('0');
		
		$toOperator = $this->input->post('to_operator') ?: false;
		$staticId = $this->input->post('static_id') ?: null;
		$staticName = $this->input->post('static_name') ?: null;
		if (!$timesheetData = $this->timesheet_model->getTimesheetData($periodId, $staticId)) exit('');
		
		
		if (!$toOperator) {
			$location = isset($staticId) && isset($timesheetData['statics'][$staticId]) ? $timesheetData['statics'][$staticId]['location'] : false;
		}
		
		$locStaticOffset = $toOperator ? 0 : ($staticId ? $this->dayOffsets[$location] : 0); // смешение дней, исходя из локации статика (только для ЛК)
		$period = $this->getTimesheetPeriod($periodId);
		$timesheetData['dates'] = getDatesRange(($period['start_date'] + $locStaticOffset), 8, 'day', '+');
		$timesheetData['to_user'] = $staticId ? true : false;
		$timesheetData['static_name'] = $staticId ? $timesheetData['statics'][$staticId]['name'] : null;
		$timesheetData['static_icon'] = $staticId ? $timesheetData['statics'][$staticId]['icon'] : null;
		$timesheetData['location'] = isset($timesheetData['statics'][$staticId]['location']) ? $timesheetData['statics'][$staticId]['location'] : false;
		
		if ($toOperator) {
			$this->load->model('operator_model');
			$operatorData = $this->operator_model->getOperatorData();
			$timesheetData['access_statics'] = isset($operatorData['statics']) ? array_keys($operatorData['statics']) : null;
			echo $this->twig->render('views/operator/render/timesheet_table_data.tpl', bringTypes($timesheetData));
		} else {
			echo $this->twig->render('views/admin/render/timesheet_table_data.tpl', bringTypes($timesheetData));
		}
	}
	
	
	
	
	
	/**
	 * Форма для добавления нового рейда в расписание
	 * @param 
	 * @return 
	 */
	public function new_timesheet_raid() {
		$data = $this->input->post();
		$toOperator = $this->input->post('to_operator');
		$data['raids_types'] = $this->timesheet_model->getRaidsTypes();
		if ($toOperator) echo $this->twig->render('views/operator/render/new_timesheet_raid.tpl', $data);
		else echo $this->twig->render('views/admin/render/new_timesheet_raid.tpl', $data);
	}
	
	
	
	
	/**
	 * Добавить новый рейд в расписание
	 * @param 
	 * @return 
	 */
	public function add_timesheet_raid() {
		$postData = bringTypes($this->input->post('timesheet_raid'));
		echo $this->timesheet_model->addTimesheetRaid($postData);
	}
	
	
	
	
	
	/**
	 * Форма для добавления нового рейда в расписание
	 * @param 
	 * @return 
	 */
	public function edit_timesheet_raid() {
		if (!$params = $this->input->post('params')) exit('0');
		$toOperator = $this->input->post('to_operator');
		$data = $params;
		$data['raids_types'] = $this->timesheet_model->getRaidsTypes();
		if ($toOperator) echo $this->twig->render('views/operator/render/new_timesheet_raid.tpl', $data);
		else echo $this->twig->render('views/admin/render/new_timesheet_raid.tpl', $data);
	}
	
	
	
	
	/**
	 * Обнновить рейд в расписании
	 * @param 
	 * @return 
	 */
	public function update_timesheet_raid() {
		$postData = bringTypes($this->input->post('timesheet_raid'));
		echo $this->timesheet_model->updateTimesheetRaid($postData);
	}
	
	
	
	
	
	/**
	 * Удаление рейда из расписания
	 * @param POST данные ID
	 * @return статус
	 */
	public function remove_timesheet_raid() {
		$id = $this->input->post('id');
		echo $this->timesheet_model->removeTimesheetRaid($id);
	}
	
	
	
	
	
	
	
	
}