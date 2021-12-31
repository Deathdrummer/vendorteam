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
				echo $this->twig->render($this->viewsPath.'data/'.($post['show_type'] ?? 'table'), $data);
				break;
		}
		
	}
	
	
	
	
	
	
	
}