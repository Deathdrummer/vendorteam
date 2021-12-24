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
			
			
			default:
				echo $this->twig->render($this->viewsPath.'fields/form');
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function table($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'boosters_history':
				$data['boosters_history'] = $this->kpiv2->table('boosters_history', $post);
				echo $this->twig->render($this->viewsPath.'table/boosters_history', $data);
				break;
			
			default:
				$data['fields'] = $this->kpiv2->fields('get_choosed');
				$data['data'] = $this->kpiv2->table('all');
				echo $this->twig->render($this->viewsPath.'table/index', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function import($action = false) {
		$post = bringTypes($this->input->post());
		$file = bringTypes($this->input->files('file'));
		switch ($action) {
			case 'form':
				echo $this->twig->render($this->viewsPath.'import/form');
				break;
			
			default:
				if ($file['error'] !== 0) exit('0');
				if (!file_exists($file['tmp_name'])) return false;
				$importData = json_decode(file_get_contents($file['tmp_name']), true);
				echo jsonResponse($this->kpiv2->table('import_data', ['import_data' => $importData]));
				break;
		}
		
	}
	
	
	
	
	
	
	
}