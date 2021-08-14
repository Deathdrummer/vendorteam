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
		$data['gifts'] = $this->gifts->crud('get', $this->post);
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
		;
		if (!$insertId = $this->gifts->crud('save', $fields)) exit('0');
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
		if (!$this->gifts->crud('update', ['id' => $id, 'fields' => $fields])) exit('0');
		echo '1';
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove() {
		if (!$this->gifts->crud('remove', $this->post['id'])) exit('0');
		echo '1';
	}
	
	
	
	
	
	
	//-----------------------------------------------------------------------
	
	
	
	
	
	
	
	/**
	 * 
	 * @param 
	 * @return 
	*/
	public function show_message() {
		$this->load->model(['account_model' => 'account']);
		$userData = $this->account->getUserData();
		$data['count'] = $this->gifts->getCountGifts($userData['id']);
		echo $this->twig->render('views/account/render/gifts/message.tpl', $data);
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get_gift() {
		$this->load->model(['account_model' => 'account']);
		$userData = $this->account->getUserData();
		$data['gift'] = $this->gifts->getGift($userData['id']);
		$data['actions'] = $this->actions;
		echo $this->twig->render('views/account/render/gifts/gift.tpl', $data);
	}
	
	
	
	
	
	
	
	/**
	 * Получить подрарок
	 * @param 
	 * @return 
	*/
	public function take_gift() {
		$this->load->model(['account_model' => 'account']);
		$userData = $this->account->getUserData();
		$giftId = $this->input->post('gift_id');
		if (!$this->gifts->takeGift($userData['id'], $giftId)) exit('0');
		echo '1';
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function gift_success() {
		$this->load->model(['account_model' => 'account']);
		$userData = $this->account->getUserData();
		$data['count'] = $this->gifts->getCountGifts($userData['id']);
		echo $this->twig->render('views/account/render/gifts/success.tpl', $data);
	}
	
	
	
	
	
	
	
	
	
	
	
	
}