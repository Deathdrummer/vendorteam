<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Main extends MY_Controller {
	
	public function __construct() {
		parent::__construct();
		$this->load->model(['admin_model', 'main_model']);
	}
	
	
	/**
	 * Гловная страница
	 * @param 
	 * @return 
	 */
	public function index() {
		$data = $this->admin_model->getSettings();

		$data['is_auth'] = get_cookie('id')/*$this->session->userdata('id')*/ ? true : false;
		
		if ($data['is_auth']) redirect('account', 'location', 301);
		
		if ($data['is_auth']) {
			$this->load->model('users_model');
			$userData = $this->users_model->getUsers(['where' => ['u.id' => get_cookie('id')/*$this->session->userdata('id')*/]]);
			$data['avatar'] = 'public/images/users/mini/'.$userData[0]['avatar'];
		}
		
		$this->twig->display('views/account/start', $data);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function fail() {
		echo '<h1 style="text-align: center; font-size: 50px; color: red; margin-top: 100px; font-family: verdana;">Произошло перенаправление из-за сбоя сессии</h1>';
	}
	
	
	
	/**
	 * Страница 404
	 * @param 
	 * @return 
	 */
	public function error() {
		if ($this->input->is_ajax_request()) return false;
		$data = $this->admin_model->getSettings();
		$this->twig->display('views/account/error', $data);
	}
	
	
	

	
	/**
	 * Авторизация
	 * @param 
	 * @return 
	 */
	public function auth() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if (isset($data['template']) && $data['template'] == 1) {
			exit($this->twig->render('views/account/render/auth.tpl'));
		}
		
		if ($data['email'] == '' || $data['password'] == '') exit('0');
		if ($userData = $this->main_model->getAuth($data['email'], $data['password'])) {
			if ($userData['deleted'] == 1) exit('2'); // Если пользователь удален
			set_cookie('id', $userData['id'], 31536000); //$this->session->set_userdata('id', $userData['id']);
			exit('1');
		}
		exit('0');
	}
	
	
	
	
	/**
	 * Регистрация
	 * @param 
	 * @return 
	 */
	public function reg() {
		if (!$this->input->is_ajax_request()) return false;
		$data = $this->input->post();
		if (isset($data['template']) && $data['template'] == 1) {
			exit($this->twig->render('views/account/render/reg.tpl'));
		}
		
		$regEmail = $data['email'];
		$regPassword = $data['password'];
		if ($regEmail == '') exit('0');
		if (! preg_match("/^[0-9a-zA-Z_.-]+@[a-z0-9_.-]+.[a-z]{2,10}$/", $regEmail)) exit('1');
		if (! $this->main_model->getReg($regEmail, $regPassword)) exit('2');
		
		$this->load->library('email');
		$config['mailtype'] = 'html';
		//$config['protocol'] = 'smtp';
		$this->email->initialize($config);
		
		$emailTitle = $this->admin_model->getSettings('email_title');
		$emailFrom = $this->admin_model->getSettings('email_from');
		
		$this->email->from($emailFrom);
		$this->email->to($regEmail);

		$this->email->subject($emailTitle.' | Регистрация');
		$this->email->message($this->twig->render('views/account/email/registration', ['email' => $regEmail, 'password' => $regPassword]));
		$this->email->send();
		echo '3';
	}
	
	
	
	
	
	
	/**
	 * Сброс пароля
	 * @param 
	 * @return 
	 */
	public function reset_pass() {
		if (! $this->input->is_ajax_request()) return false;
		$email = $this->input->post('email');
		$newPassword = $this->input->post('new_password');
		
		if ($email == '') exit('0');
		if (! preg_match("/^[0-9a-zA-Z_.-]+@[a-z0-9_.-]+.[a-z]{2,10}$/", $email)) exit('1');
		
		if (! $this->main_model->resetPass($email, $newPassword)) exit('2');
		
		$emailTitle = $this->admin_model->getSettings('email_title');
		$emailFrom = $this->admin_model->getSettings('email_from');
		$smtp = $this->admin_model->getSettings('setting_smtp');
		
		$this->load->library('email');
		$this->email->initialize([
			'mailtype' 		=> 'html',
			'protocol' 		=> 'smtp',
			'priority' 		=> 1,
			'smtp_host' 	=> $smtp['host'],
			'smtp_user' 	=> $smtp['user'],
			'smtp_pass' 	=> $smtp['pass'],
			'smtp_port' 	=> $smtp['port'],
			'smtp_crypto' 	=> $smtp['crypto']
		]);
		


		$this->email->from($emailFrom);
		$this->email->to($email);
		

		$this->email->subject($emailTitle.' | Новый пароль');
		$this->email->message($this->twig->render('views/account/email/reset_pass', ['email' => $email, 'password' => $newPassword]));
		
		if (!$this->email->send()) {
			toLog($this->email->print_debugger());
		}
		
		echo '3';
	}
	
	
	
	
	
	
	
	/**
	 * Валидация данных
	 * @param 
	 * @return 
	 */
	public function form_order() {
		$this->load->library('form_order');
		$postData = $this->input->post();
		echo json_encode($this->form_order->validate($postData));
	}
	
	
	
}