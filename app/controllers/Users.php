<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Users extends MY_Controller {
	
	private $viewsPath = 'views/admin/render/usersv2/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model('v2/users_model', 'usersV2');
	}
	
	
	
	
	
	
	/**
	 * Список участников
	 * @param 
	 * @return 
	 */
	public function list($action = false) {
		$post = bringTypes($this->input->post());
		
		switch ($action) {
			case 'save':
				if (!$this->usersV2->list('save', $post)) exit('0');
				echo '1';
				break;
			
			case 'delete':
				if (!$this->usersV2->list('delete', $post)) exit('0');
				echo '1';
				break;
			
			case 'return_deleted':
				if (!$this->usersV2->list('return_deleted', $post)) exit('0');
				echo '1';
				break;
			
			case 'exclude':
				if (!$this->usersV2->list('exclude', $post)) exit('0');
				echo '1';
				break;
			
			case 'return_excluded':
				if (!$this->usersV2->list('return_excluded', $post)) exit('0');
				echo '1';
				break;
				
			default:
				$usersData = $this->usersV2->list('all', $post);
				$data['users'] = $usersData;
				
				$dataToFields = [];
				if (isset($post['fields'])) {
					$dataToFields = $this->usersV2->fields('dataToFields', $post);
				}
				
				$data = array_merge($data, $dataToFields, ['is_main_admin' => !get_cookie('slaveadmin')]);
				echo $this->twig->render($this->viewsPath.'list.tpl', $data);
				break;
		}		
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function colors($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'change':
				if (!$this->usersV2->list('changeColor', $post)) exit('0');
				echo '1';
				break;
			
			default: 
				$this->load->model('account_model', 'account');
				$raidersColors = $this->account->getRaidersColors();
				$attrName = $post['attr'] ?: false;
				echo $this->twig->render('views/account/render/raiders_colors', ['raiders_colors' => $raidersColors, 'attr' => $attrName]);
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
			case 'to_head':
				$fieldstoThead = $this->usersV2->fields('toThead', $post);
				echo json_encode($fieldstoThead);
				break;
			
			default:
				$data['fields'] = $this->usersV2->fields('all', $post);
				$data['selected_fields'] = $this->usersV2->fields('selected', $post);
				echo $this->twig->render($this->viewsPath.'fields/list.tpl', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function statics($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'tabs':
				$statics = $this->usersV2->statics('tabs', $post);
				$data['statics'] = $statics['statics'];
				$data['current_static'] = $statics['current'] ?: $post['current_static'];
				echo $this->twig->render($this->viewsPath.'statics/tabs.tpl', $data);
				break;
			
			case 'user':
				$data['statics'] = $this->usersV2->statics('user', $post);
				echo $this->twig->render($this->viewsPath.'statics/user.tpl', $data);
				break;
			
			case 'set':
				if (!$this->usersV2->statics('set', $post)) exit('0');
				echo '1';
				break;
			
			default:
				$data['statics'] = $this->usersV2->statics('all', $post);
				echo $this->twig->render($this->viewsPath.'statics/list.tpl', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function classes($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'set':
				if (!$this->usersV2->classes('set', $post)) exit('0');
				echo '1';
				break;
			
			default:
				$data['classes'] = $this->usersV2->classes('user', $post);
				echo $this->twig->render($this->viewsPath.'classes/user.tpl', $data);
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function userinfo($action = false) {
		$post = bringTypes($this->input->post());
		switch ($action) {
			case 'change_deposit':
				echo jsonResponse($this->usersV2->userinfo('changeDeposit', $post));
				break;
			
			default:
				$data = $this->usersV2->userinfo('get', $post);
				echo $this->twig->render($this->viewsPath.'user.tpl', $data);
			break;
		}
		
	}
	
	
	
	
	
	
}