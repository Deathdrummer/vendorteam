<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');


class Gifts extends MY_Controller {
	
	private $viewsPath = 'views/admin/';
	private $post;
	private $actions = [
		'stage'		=> 'Прибавка к стажу',
		'balance'	=> 'Прибавка к балансу'
	]; 
	
	public function __construct() {
		parent::__construct();
		$this->post = bringTypes($this->input->post());
		$this->load->model('gifts_model', 'gifts');
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function init() {
		echo $this->twig->render($this->viewsPath.'render/gifts/init.tpl');
	}
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get() {
		$data['actions'] = $this->actions;
		$data['gifts'] = $this->gifts->get($this->post);
		echo $this->twig->render($this->viewsPath.'render/gifts/list.tpl', $data);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function add() {
		$this->load->model('admin_model', 'admin');
		$data['actions'] = $this->actions; 
		$data['default_percent'] = $this->admin->getSettings('gift_default_percent'); 
		toLog($data['default_percent']);
		echo $this->twig->render($this->viewsPath.'render/gifts/new.tpl', $data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save() {
		$fields = $this->post['fields'];
		$fields['section'] = $this->post['section'];
		$fieldsToItem = $this->post['fields_to_item'];
		$fieldsToItem['actions'] = $this->actions;
		
		if (!$insertId = $this->gifts->save($fields)) exit('0');
		$fieldsToItem['id'] = $insertId;
		echo $this->twig->render($this->viewsPath.'render/gifts/item.tpl', $fieldsToItem);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update() {
		$id = $this->post['id'];
		$fields = $this->post['fields'];
		if (!$this->gifts->update($id, $fields)) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove() {
		if (!$this->gifts->remove($this->post['id'])) exit('0');
		echo '1';
	}
	
	
	
}