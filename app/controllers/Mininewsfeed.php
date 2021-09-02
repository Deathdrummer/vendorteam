<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Mininewsfeed extends MY_Controller {
	
	private $post;
	private $viewsTemplatesPath = 'views/admin/render/mininewsfeed/templates/';
	private $viewsListPath = 'views/admin/render/mininewsfeed/list/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model('mininewsfeed_model', 'mininewsfeed');
		$this->post = bringTypes($this->input->post());
	}
	
	
	
	
	
	
	
	/**
	 * Шаблоны
	 * @param 
	 * @return 
	 */
	public function templates($action = false) {
		if (!$action) return false;
		$data = [];
		
		switch ($action) {
			case 'init':
				$data['list_id'] = $this->post['list_id'];
				$data['btn_id'] = $this->post['btn_id'];
				echo $this->twig->render($this->viewsTemplatesPath.'init.tpl', $data);
				break;
			
			case 'get':
				$data['types'] = $this->miniFeedTypes;
				$data['newsfeedlist'] = $this->mininewsfeed->get($this->post['type']);
				echo $this->twig->render($this->viewsTemplatesPath.'list.tpl', $data);
				break;
			
			case 'add':
				$data['types'] = $this->miniFeedTypes;
				echo $this->twig->render($this->viewsTemplatesPath.'item.tpl');
				break;
			
			case 'save':
				$fields = $this->post['fields'];
				$fields['type'] = $this->post['type'];
				if (!$insertId = $this->mininewsfeed->save($fields)) exit('0');
				$fieldsToItem = $this->post['fields_to_item'];
				$fieldsToItem['id'] = $insertId;
				echo $this->twig->render($this->viewsTemplatesPath.'item.tpl', $fieldsToItem);
				break;
			
			case 'update':
				$id = $this->post['id'];
				$fields = $this->post['fields'];
				if (!$this->mininewsfeed->update($id, $fields)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->mininewsfeed->remove($this->post['id'])) exit('0');
				echo '1';
				break;
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	//---------------------------------------------------------
	
	
	
	/**
	 * Вывести список событий
	 * @param 
	 * @return 
	 */
	public function list() {
		if (!$newsFeedList = $this->mininewsfeed->list()) exit('');
		
		$statics = array_column($newsFeedList, 'statics');
		$statics = call_user_func_array('array_merge', $statics);
		
		$this->load->model('admin_model', 'admin');
		$staticsData = $this->admin->getStatics(false, array_unique($statics));
		
		echo $this->twig->render($this->viewsListPath.'list.tpl', ['list' => $newsFeedList, 'statics' => $staticsData]);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function account_list() {
		$data['mini_newsfeed'] = $this->mininewsfeed->getNewsFeedList();
		echo $this->twig->render('views/account/render/mininewsfeed/list.tpl', $data);
	}
	
	
	/**
	 * Форма создания и редактирования события
	 * @param 
	 * @return 
	 */
	public function form() {
		$this->load->model('admin_model', 'admin');
		
		if (isset($this->post['id'])) {
			$data = $this->mininewsfeed->item($this->post['id']);
		}
		
		$data['allstatics'] = $this->admin->getStatics();
		echo $this->twig->render($this->viewsListPath.'form.tpl', $data);
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function add() {
		if (!$this->mininewsfeed->addToList($this->post)) exit('0');
		echo '1';
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update() {
		if (!$this->mininewsfeed->updateListItem($this->post)) exit('0');
		echo '1';
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove() {
		if (!$this->mininewsfeed->removeFromList($this->post['id'])) exit('0');
		echo '1';
	}
	
	
}