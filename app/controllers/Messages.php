<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Messages extends MY_Controller {
	
	private $viewsPath = 'views/admin/render/usersmessages/';
	private $viewsPathAccount = 'views/account/render/usersmessages/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model('messages_model', 'messages');
	}
	
	
	
	
	
	/**
	 * Заглушка
	 * @param 
	 * @return 
	*/
	public function index() {
		redirect('account', 'location', 301);
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Сообщения от админа к участникам
	 * @param 
	 * @return 
	*/
	public function admin($action = false) {
		if (!$action) return false;
		$post = bringTypes($this->input->post());
		
		switch ($action) {
			case 'list':
				$data['messages'] = $this->messages->get();
				echo $this->twig->render($this->viewsPath.'list.tpl', $data);
				break;
			
			case 'form':
				$this->load->model(['admin_model' => 'admin']);
				$data['statics'] = $this->admin->getStatics(true);
				if (isset($post['id'])) {
					$data['message'] = $this->messages->get($post['id']);
					$data['edit'] = 1;
				} 
				
				if (isset($post['users'])) {
					$users = arrRestructure($post['users'], 'static id');
					$data['message']['to'] = $users;
				}
				
				echo $this->twig->render($this->viewsPath.'form.tpl', $data);
				break;
			
			case 'add':
				if (!$this->messages->add($post['users'], $post['title'], $post['message'])) exit('0');
				echo '1';
				break;
			
			case 'update':
				if (!$this->messages->update($post['id'], $post['users'], $post['title'], $post['message'])) exit('0');
				echo '1';
				break;
				
			case 'remove':
				if (!$this->messages->remove($post['id'])) exit('0');
				echo '1';
				break;
				
				
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Сообщения от админа к участникам
	 * @param 
	 * @return 
	*/
	public function account($action = false) {
		if (!$action) return false;
		$post = bringTypes($this->input->post());
		
		switch ($action) {
			case 'status':
				$data = $this->messages->getStat($post['user_id']);
				echo json_encode($data);
				break;
			
			case 'list':
				$data['messages'] = $this->messages->getListToUser($post['user_id']);
				echo $this->twig->render($this->viewsPathAccount.'list.tpl', $data);
				break;
			
			case 'get':
				$data = $this->messages->getItemToUser($post['id'], $post['user_id']);
				echo $this->twig->render($this->viewsPathAccount.'message.tpl', $data);
				break;
			
			case 'set_read':
				if (!$this->messages->setStat($post['id'], $post['user_id'])) exit('0');
				echo '1';
				break;
			
			
			
			
			
				
				
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
}