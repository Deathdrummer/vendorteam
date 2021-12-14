<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Planner extends MY_Controller {
	
	private $viewsPath = 'views/admin/render/planner/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model('planner_model', 'planner');
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function list($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'date':
				echo $this->planner->list('date', $post);
				break;
			
			default:
				$data = $this->planner->list('get', $post);
				$data['data'] = $this->planner->data($post);
				echo $this->twig->render($this->viewsPath.'list', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function message($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'send':
				echo jsonResponse($this->planner->message('send', $post));
				break;
			
			default:
				echo $this->twig->render($this->viewsPath.'message_form', $post);
				break;
		}
		
	}
	
	
	
}