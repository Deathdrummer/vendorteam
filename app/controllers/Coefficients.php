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
	public function period($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'statics_tabs':
				$data['statics'] = $this->coefficients->period('statics', $post);
				echo $this->twig->render($this->viewsPath.'statics_tabs.tpl', $data);
				break;
			
			case 'periods':
				$data = $this->coefficients->period('periods', $post);
				
				$data = array_replace_recursive((array)$post, $data);
				echo $this->twig->render($this->viewsPath.'periods.tpl', $data);
				break;
			
			
			default:
				$coefficients = $this->coefficients->period($post);
				
				$data = [
					'compounds_data' 	=> $coefficients['compounds_data'],
					'raids' 			=> $coefficients['raids'],
					'raids_types' 		=> $this->admin_model->getRaidsTypes()
				];
				
				setAjaxHeader('period_name', cyrillicEncode($coefficients['period_name']));
				echo $this->twig->render($this->viewsPath.'data.tpl', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function user($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			default:
				toLog($post);
				$params['user_id'] = arrTakeItem($post, 'user_id');
				$params['periods'] = arrTakeItem($post, 'periods');
				
				if (!is_file('public/images/users/mini/'.$post['avatar'])) $post['avatar'] = 'public/images/user_mini.jpg';
				else $post['avatar'] = 'public/images/users/mini/'.$post['avatar'];
				
				$post['nickname'] = cyrillicEncode($post['nickname']);
				setAjaxHeader($post);
				
				$data['compounds'] = $this->coefficients->user($params);
				$data['raids_types'] = $this->admin_model->getRaidsTypes();
				$data['statics'] = $this->admin_model->getStatics();
				$data['periods_names'] = $this->coefficients->getPeriodsNames(false, 'DESC');
				
				echo $this->twig->render($this->viewsPath.'user.tpl', $data);
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