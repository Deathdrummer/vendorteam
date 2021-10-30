<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Pollings extends MY_Controller {
	
	
	private $viewsPath = 'views/admin/render/pollings/';
	private $answersTypes = [
		1 => 'одиночный',
		2 => 'множественный',
		3 => 'кастомный',
	];
	
	public function __construct() {
		parent::__construct();
		$this->load->model('pollings_model', 'pollings');
	}
	
	
	
	
	
	
	/**
	 * Удаление опроса
	 * @param 
	 * @return 
	*/
	public function pollings($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				$data['pollings'] = $this->pollings->pollings('all');
				$data['minutes'] = $this->minutes;
				echo $this->twig->render($this->viewsPath.'list', $data);
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'new');
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				
				$date = time();
				$fields['date'] = $date;
				$fieldsToItem['date'] = $date;
				
				if (!$insertId = $this->pollings->pollings('save', $fields)) exit('0');
				$fieldsToItem['id'] = $insertId;
				$fieldsToItem['minutes'] = $this->minutes;
				echo $this->twig->render($this->viewsPath.'item', $fieldsToItem);
				break;
				
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				
				if (!$this->pollings->pollings('update', ['id' => $id, 'fields' => $fields])) exit('0');
				echo '1';
				break;
				
			case 'remove':
				if (!$this->pollings->pollings('remove', $post)) exit('0');
				echo '1';
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Вопросы
	 * @param 
	 * @return 
	*/
	public function questions($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'all':
				$data['answerstypes'] = $this->answersTypes;
				$data['questions'] = $this->pollings->questions('all', $post);
				echo $this->twig->render($this->viewsPath.'questions', $data);
				break;
			
			case 'sort':
				if (!$this->pollings->questions('sort', $post)) exit('0');
				echo '1';
				break;
			
			case 'form':
				if ($post['question_id']) {
					$data = $this->pollings->questions('get', $post);
				}
				$data['answers_types'] = $this->answersTypes;
				
				echo $this->twig->render($this->viewsPath.'question_form', $data);
				break;
			
			case 'add':
				if (!$this->pollings->questions('add', $post)) exit('0');
				echo '1';
				break;
			
			case 'update':
				if (!$this->pollings->questions('update', $post)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->pollings->questions('remove', $post)) exit('0');
				echo '1';
				break;
				
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	/**
	 * Вопросы
	 * @param 
	 * @return 
	*/
	public function variants($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'all':
				$data['answerstypes'] = $this->answersTypes;
				$data['questions'] = $this->pollings->variants('all', $post);
				echo $this->twig->render($this->viewsPath.'questions', $data);
				break;
				
			case 'new':
				echo $this->twig->render($this->viewsPath.'question_variant', $post);
				break;
				
			case 'sort':
				if (!$this->pollings->variants('sort', $post)) exit('0');
				echo '1';
				break;
			
			case 'form':
				echo $this->twig->render($this->viewsPath.'question_form');
				break;
			
				
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Участники
	 * @param 
	 * @return 
	*/
	public function users($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				if (!$usersIds = $this->pollings->users('get', $post)) exit('0');
				$this->load->model('users_model', 'users');
				$users = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'static']);
				
				if (!$users) exit('');
				$usersData = [];
				foreach ($users as $userId => $staticId) {
					$usersData[] = [
						'user' 		=> $userId,
						'static' 	=> $staticId,
					];
				}
				echo json_encode($usersData);
				break;
				
			case 'set':
				$post['users'] = $post['users'] ? array_keys($post['users']) : [];
				$this->pollings->users('set', $post);
				$this->load->model('users_model', 'users');
				
				$data['users'] = $post['users'] ? $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $post['users']], 'fields' => 'nickname']) : false;
				echo $this->twig->render($this->viewsPath.'users', $data);
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Статикии
	 * @param 
	 * @return 
	*/
	public function statics($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				$this->load->model('admin_model', 'admin');
				if (!$allStatics = $this->admin->getStatics()) return false;
				$data['statics'] = $allStatics;
				$data['choosed_statics'] = $this->pollings->statics('get', $post);
				
				echo $this->twig->render($this->viewsPath.'statics', $data);
				break;
				
			case 'set':
				$this->pollings->statics('set', $post);
				
				$allStatics = [];
				if (!empty($post['statics'])) {
					$this->load->model('admin_model', 'admin');
					$allStatics = $this->admin->getStatics(true, $post['statics']);
				}
				$data['statics'] = $allStatics;
				echo $this->twig->render($this->viewsPath.'statics_minilist', $data);
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------- Личный кабинет
	
	/**
	 * Аккаунт
	 * @param 
	 * @return 
	*/
	public function account($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case 'all':
				$data['pollings'] = $this->pollings->account('all', $post);
				echo $this->twig->render($this->viewsPath.'account/list', $data);
				break;
			
			case 'questions':
				$pollingData = $this->pollings->account('get', $post);
				echo json_encode($pollingData);
				break;
			
			case 'question':
				echo $this->twig->render($this->viewsPath.'account/question', $post);
				//$pollingData = $this->pollings->account('get', $post);
				//echo json_encode($pollingData);
				break;
			
			case 'save':
				if (!$this->pollings->account('save', $post)) exit('0');
				echo '1';
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------- Статистика
	/**
	 * Статистика
	 * @param 
	 * @return 
	*/
	public function statistics($action = false) {
		$post = bringTypes($this->input->post());
		if (!$action) return false;
		
		switch ($action) {
			case '':
				$data['common'] = $this->pollings->statistics('common', $post);
				echo $this->twig->render($this->viewsPath.'');
				break;
				
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------- Приватные функции
	
	/**
	 * @param 
	 * @return 
	 */
	public function status() {
		$data = bringTypes($this->input->post());
		if (!$this->pollings->setStatus($data['polling_id'], $data['status'])) exit('0');
		echo '1';
	}
	
	
	

	
	
	
}