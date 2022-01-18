<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Kpiv2 extends MY_Controller {
	
	private $viewsPath = 'views/admin/render/kpi/v2/';
	
	public function __construct() {
		parent::__construct();
		
		$this->load->model('v2/kpi_model', 'kpiv2');
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function import($action = false) {
		$post = bringTypes($this->input->post());
		$importExcelFile = bringTypes($this->input->files('file')) ?? false;
		switch ($action) {
			case 'form':
				echo $this->twig->render($this->viewsPath.'import/form');
				break;
			
			default:
				echo jsonResponse($this->kpiv2->import(['import_excel_file' => $importExcelFile]));
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function fields($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'all':
				$data['fields'] = $this->kpiv2->fields('get');
				echo $this->twig->render($this->viewsPath.'fields/fields', $data);
				break;
			
			case 'choosed':
				$data['fields'] = $this->kpiv2->fields('get_choosed');
				echo $this->twig->render($this->viewsPath.'fields/fields', $data);
				break;
				
			case 'new':
				echo $this->twig->render($this->viewsPath.'fields/field_form');
				break;
			
			case 'add':
				if (!$this->kpiv2->fields('add', $post)) exit('0');
				echo '1';
				break;
			
			case 'edit':
				$data = $this->kpiv2->fields('edit', $post);
				echo $this->twig->render($this->viewsPath.'fields/field_form', $data);
				break;
			
			case 'update':
				if (!$this->kpiv2->fields('update', $post)) exit('0');
				echo '1';
				break;
			
			case 'set_choosed':
				if (!$this->kpiv2->fields('set_choosed', $post)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->kpiv2->fields('remove', $post)) exit('0');
				echo '1';
				break;
			
			case 'to_find':
				$data['fields'] = $this->kpiv2->fields('to_find');
				echo $this->twig->render($this->viewsPath.'fields/select', $data);
				break;
			
			
			default:
				echo $this->twig->render($this->viewsPath.'fields/form');
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * KPI периоды
	 * @param 
	 * @return 
	*/
	public function periods($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
			
				//$this->kpiv2->periods('get');
			
				/*$this->load->model(['admin_model' => 'admin', 'reports_model' => 'reports']);
				$data['statics'] = $this->admin_model->getStatics(true);
				$data['reports_periods'] = $this->reports->getReportsPeriods();
				$data['periods'] = $this->kpiv2->getPeriods();
				$data['type'] = $post['type'];
				$data['attr'] = isset($post['attr']) ? $post['attr'] : 'kpiopenform';
				echo $this->twig->render($this->viewsPath.'periods/list.tpl', $data);*/
				break;
			
			case 'new':
				$this->load->model(['reports_model' => 'reports']);
				$data['periods'] = $this->reports->getReportsPeriods();
				$data['statics'] = $this->admin_model->getStatics();
				echo $this->twig->render($this->viewsPath.'periods/form.tpl', $data);
				break;
			
			case 'add':
				echo jsonResponse($this->kpiv2->periods('add', $post));
				break;
			
			case 'activate_period':
				$post = bringTypes($this->input->post());
				if (!$this->kpiv2->activatePeriod($post['period_id'], $post['stat'])) exit('0');
				echo '1';
				break;
			
			case 'publish_period':
				$post = bringTypes($this->input->post());
				if (!$this->kpiv2->publishPeriod($post['period_id'], $post['stat'])) exit('0');
				echo '1';
				break;
				
			case 'add_custom_field':
				$data['custom_tasks'] = $this->kpiv2->getCustomTasks();
				echo $this->twig->render($this->viewsPath.'render/kpi/custom_fields/item.tpl', $data);
				break;
			
			case 'remove_period':
				if (!$this->kpiv2->removeKpiPeriod($post['period_id'])) exit('');
				echo '1';
				break;
				
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Суммы выплат по званиям и статикам
	 * @param 
	 * @return 
	*/
	public function amounts($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get_form':
				$ranksData = $this->admin_model->getRanks(true, false);
				
				$data['ranks'] = setArrKeyfromField($ranksData, 'id', 'name');
				$data['statics'] = $this->admin_model->getStatics(true);
				$data['amounts'] = $this->kpiv2->amounts('get');
				
				echo $this->twig->render($this->viewsPath.'amounts/form.tpl', $data);
				break;
			
			case 'set_amount':
				echo jsonResponse($this->kpiv2->amounts('set', $post));
				break;
			
			case 'calc_summ':
				echo $this->kpiv2->amounts('calcSumm', $post);
				break;
			
			case 'calc_progress':
				echo $this->kpiv2->amounts('calcProgress', $post);
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function import_progress($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'form':
				$data['periods'] = $this->kpiv2->periods('get', $post);
				$data['statics'] = $this->admin_model->getStatics();
				
				echo $this->twig->render($this->viewsPath.'import_progress/form', $data);
				break;
			
			case 'statics_koeffs':
				$data['statics'] = $this->admin_model->getStatics();
				$data['koeffs'] = $this->kpiv2->periods('staticsKoeffs', $post);
				echo $this->twig->render($this->viewsPath.'import_progress/statics_koeffs', $data);
				break;
			
			default:
				$importExcelFile = bringTypes($this->input->files('file')) ?? false;
				if (!$post['period_id'] || !$post['statics_koeffs'] || !$importExcelFile) exit('0');
				if ($importExcelFile['type'] !== 'application/json')  exit('-1');
				if ($importExcelFile['error'] !== 0) exit('-1');
				
				$post['import_excel_file'] = $importExcelFile;
				
				if (!$progressData = $this->kpiv2->importProgress($post)) exit('-2');
				
				
				$data['data'] = $progressData;
				$data['payout_type'] = $this->kpiv2->periods('payoutType', $post);
				$data['statics'] = $this->kpiv2->data('statics', ['statics_ids' => array_keys($data['data'])]);
				$data['amounts'] = $this->kpiv2->amounts('get'); // static_id rank_id payout_type => amount
				$data['ranks'] = $this->admin_model->getRanks();
				
				echo $this->twig->render($this->viewsPath.'import_progress/data', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function report($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'get':
				if (!$report = $this->kpiv2->report('get', $post)) exit(0);
				$reportData = [];
				foreach ($report as $row) {
					$static = arrTakeItem($row, 'static_id');
					$reportData[$static][] = $row;
				}
				
				$data['report'] = $reportData;
				$data['statics'] = $this->admin_model->getStatics();
				$data['ranks'] = $this->admin_model->getRanks();
				echo $this->twig->render($this->viewsPath.'report/data', $data);
				break;
			
			case 'save':
				echo jsonResponse($this->kpiv2->report('save', $post));
				break;
			
			case 'list':
				$data['list'] = $this->kpiv2->report('list');
				echo $this->twig->render($this->viewsPath.'report/list', $data);
				break;
			
			case 'export':
				$this->kpiv2->report('export');
				break;
			
			default:
				echo $this->twig->render($this->viewsPath.'report/form');
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function data($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'boosters_history':
				$data['boosters_history'] = $this->kpiv2->data('boosters_history', $post);
				echo $this->twig->render($this->viewsPath.'data/boosters_history', $data);
				break;
				
			default:
				$data['fields'] = $this->kpiv2->fields('get_choosed');
				$data['data'] = $this->kpiv2->data('all', $post);
				$data['statics'] = $this->kpiv2->data('statics');
				
				echo $this->twig->render($this->viewsPath.'data/'.($post['show_type'] ?? 'table'), $data);
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}