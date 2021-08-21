<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');


class Gifts extends MY_Controller {
	
	private $viewsPath = 'views/admin/';
	private $post;
	
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
		$fields = isset($this->post['fields']) ? $this->post['fields'] : null;
		echo $this->twig->render($this->viewsPath.'render/gifts/init.tpl', ['fields' => $fields]);
	}
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get() {
		$data['actions'] = $this->giftsActions;
		$fields = arrTakeItem($this->post, 'fields');
		$data['gifts'] = $this->gifts->crud('get', $this->post);
		$data['fields'] = $fields;
		echo $this->twig->render($this->viewsPath.'render/gifts/list.tpl', $data);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function add() {
		$this->load->model('admin_model', 'admin');
		$data['actions'] = $this->giftsActions; 
		$data['default_percent'] = $this->admin->getSettings('gift_default_percent'); 
		$data['fields'] = isset($this->post['fields']) ? $this->post['fields'] : null;
		echo $this->twig->render($this->viewsPath.'render/gifts/new.tpl', $data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save() {
		$fields = $this->post['fields'];
		$fields['section'] = $this->post['section'];
		$fieldsToItem['gift'] = $this->post['fields_to_item'];
		$fieldsToItem['actions'] = $this->giftsActions;
		if (!$insertId = $this->gifts->crud('save', $fields)) exit('0');
		$fieldsToItem['id'] = $insertId;
		$fieldsToItem['fields'] = isset($this->post['fields_items']) ? $this->post['fields_items'] : null;
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
		$data['actions'] = $this->giftsActions;
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