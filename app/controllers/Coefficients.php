<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Coefficients extends MY_Controller {
	
	private $viewsPath = 'views/admin/render/coefficients/';
	
	public function __construct() {
		parent::__construct(['directAccess' => [['function' => 'index', 'action' => 'foo']], 'base' => 'admin#coefficients']);
		$this->load->model('coefficients_model', 'coefficients');
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function index() {
		echo 'hello';
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function data($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'statics':
				$data['statics'] = $this->admin_model->getStatics();
				echo $this->twig->render($this->viewsPath.'statics.tpl', $data);
				break;
			
			case 'periods':
				$data['periods'] = $this->coefficients->data('periods');
				echo $this->twig->render($this->viewsPath.'periods.tpl', $data);
				break;
			
			
			default:
				$coefficients = $this->coefficients->data($post);
				
				$data = [
					'compounds_data' 	=> $coefficients['compounds_data'],
					'raids' 			=> $coefficients['raids'],
					'raids_types' 		=> $this->admin_model->getRaidsTypes()
				];
				
				setAjaxHeader('period_name', $coefficients['period_name']);
				echo $this->twig->render($this->viewsPath.'data.tpl', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	/*public function () {
		if (!$this->input->is_ajax_request()) return false;
		$postData = $this->input->post();
		$data = $this->account->getUsersToCompound($postData);
		$raidsTypes = $this->admin->getRaidsTypes();
		
		$settings = isset($this->settings['compound_users_setting'][$postData['static_id']]) ? $this->settings['compound_users_setting'][$postData['static_id']] : null;
		echo $this->twig->render('views/account/render/compound_users', ['compounds_data' => $data['compounds_data'], 'raids' => $data['raids'], 'is_lider' => $postData['is_lider'], 'raids_types' => $raidsTypes, 'settings' => $settings]);
	
	}*/
}