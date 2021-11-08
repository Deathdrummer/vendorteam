<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Mininewsfeed extends MY_Controller {
	
	private $post;
	private $viewsTemplatesPath = 'views/admin/render/mininewsfeed/templates/';
	private $viewsListPath = 'views/admin/render/mininewsfeed/list/';
	
	public function __construct() {
		parent::__construct();
		$this->load->model('mininewsfeed_model', 'mininewsfeed');
		$this->post = bringTypes($this->input->post()) ?: null;
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
				echo $this->twig->render($this->viewsTemplatesPath.'init.tpl', $this->post);
				break;
			
			case 'get':
				$data['types'] = $this->miniFeedTypes;
				if ($this->post['type'] == 2) $data['ranks'] = $this->admin_model->getRanks();
				$data['newsfeedlist'] = $this->mininewsfeed->templates('get', $this->post['type']);
				echo $this->twig->render($this->viewsTemplatesPath.'list.tpl', $data);
				break;
			
			case 'add':
				$data['types'] = $this->miniFeedTypes;
				$data['type'] = $this->post['type'];
				if ($this->post['type'] == 2) $data['ranks'] = $this->admin_model->getRanks();
				echo $this->twig->render($this->viewsTemplatesPath.'item.tpl', $data);
				break;
			
			case 'save':
				$data = $this->post['fields'];
				$data['type'] = $this->post['type'];
				if (!$insertId = $this->mininewsfeed->templates('save', $data)) exit('0');
				$fieldsToItem = $this->post['fields_to_item'];
				$fieldsToItem['id'] = $insertId;
				$fieldsToItem['type'] = $this->post['type'];
				if ($this->post['type'] == 2) $fieldsToItem['ranks'] = $this->admin_model->getRanks();
				echo $this->twig->render($this->viewsTemplatesPath.'item.tpl', $fieldsToItem);
				break;
			
			case 'update':
				if (!$this->mininewsfeed->templates('update', $this->post)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->mininewsfeed->templates('remove', $this->post['id'])) exit('0');
				echo '1';
				break;
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	//---------------------------------------------------------
	
	
	
	/**
	 * Форма создания и редактирования события
	 * @param 
	 * @return 
	 */
	public function form() {
		$this->load->model('admin_model', 'admin');
		if (isset($this->post['id'])) {
			if ($this->post['edit_later']) $data = $this->mininewsfeed->later('item', $this->post);
			else $data = $this->mininewsfeed->list('item', $this->post);
			
			if (!$data) exit('<p class="empty center">Это событие уже отправлено!</p>');
			
			$date = $data['date'] + $this->timezoneOffset; // добавляем для правильного отображения даты в списке
			$hoursMinutes = $date % 86400;
			$data['date'] = $date - $hoursMinutes;
			$data['form_hours'] = floor($hoursMinutes / (60 * 60)); 
			$data['form_minutes'] = ($hoursMinutes % (60 * 60)) / 60;
		}
		
		
		$data['allstatics'] = $this->admin->getStatics();
		$data['minutes'] = $this->minutes;
		$data['edit_later'] = $this->post['edit_later'];
		echo $this->twig->render($this->viewsListPath.'form.tpl', $data);
	}
	
	
	
	
	
	
	
	/**
	 * Отправленные события
	 * @param 
	 * @return 
	*/
	public function list($action = false) {
		if (!$action) return false;
		
		switch ($action) {
			case 'get': // Вывести список событий
				if (!$newsFeedList = $this->mininewsfeed->list('get')) exit('');
				
				$statics = array_column($newsFeedList, 'statics');
				$statics = call_user_func_array('array_merge', $statics);
				
				$this->load->model('admin_model', 'admin');
				$staticsData = $this->admin->getStatics(false, array_unique($statics));
				
				echo $this->twig->render($this->viewsListPath.'list.tpl', ['list' => $newsFeedList, 'statics' => $staticsData]);
				break;
			
			
			case 'add':
				if (!$this->mininewsfeed->list('add', $this->post)) exit('0');
				echo '1';
				break;
			
			
			case 'update':
				if (!$this->mininewsfeed->list('update', $this->post)) exit('0');
				echo '1';
				break;
			
			
			case 'remove':
				if (!$this->mininewsfeed->list('remove', $this->post)) exit('0');
				echo '1';
				break;
			
			
			default: break;
		}
		
	}
	
	
	
	
	
	
	
	/**
	 * Отложенные события
	 * @param 
	 * @return 
	*/
	public function later($action = false) {
		if (!$action) return false;
		
		switch ($action) {
			case 'get': // Вывести список отложенных событий
				if (!$newsFeedListLater = $this->mininewsfeed->later('get')) exit('');
				
				$statics = array_column($newsFeedListLater, 'statics');
				$statics = call_user_func_array('array_merge', $statics);
				
				$this->load->model('admin_model', 'admin');
				$staticsData = $this->admin->getStatics(false, array_unique($statics));
				
				echo $this->twig->render($this->viewsListPath.'list.tpl', ['list' => $newsFeedListLater, 'statics' => $staticsData, 'later' => 1]);
				break;
			
			
			case 'add':
				if (!$this->mininewsfeed->later('add', $this->post)) exit('0');
				echo '1';
				break;
			
			
			case 'update':
				if (!$this->mininewsfeed->later('update', $this->post)) exit('0');
				echo '1';
				break;
			
			
			case 'remove':
				if (!$this->mininewsfeed->later('remove', $this->post)) exit('0');
				echo '1';
				break;
			
			
			default: break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function account_list() {
		$staticId = $this->input->post('static_id') ?: false;
		$newsFeedList = $this->mininewsfeed->getNewsFeedList($staticId);
		$data['mini_newsfeed'] = $newsFeedList;
		echo $this->twig->render('views/account/render/mininewsfeed/list.tpl', $data);
	}
	
	
	
	
}