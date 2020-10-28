<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Main_model extends CI_Model {
	
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	/**
	 * Регистрация
	 * @param 
	 * @return 
	 */
	public function getReg($email, $password) {
		$this->db->where('email', $email);
		$count = $this->db->count_all_results('users');
		
		$this->load->model('admin_model');
		$access = $this->admin_model->getSettings('default_access_setting');
		
		if ($count == 0) {
			$this->db->insert('users', ['email' => $email, 'password' => md5($password), 'reg_date' => time(), 'access' => $access]);
			return 1;
		} else {
			return 0;
		}
	}
	
	
	
	/**
	 * Авторизация
	 * @param 
	 * @return 
	 */
	public function getAuth($email, $password) {
		$this->db->where(['email' => $email, 'password' => md5($password)]);
		$query = $this->db->get('users');
		if ($userData = $query->row_array()) {
			return $userData;
		}
		return false;
	}
	
	
	
	/**
	 * Сброс пароля
	 * @param 
	 * @return 
	 */
	public function resetPass($email, $password) {
		$this->db->where('email', $email);
		$count = $this->db->count_all_results('users');
		
		if ($count == 1) {
			$this->db->where('email', $email);
			$this->db->set(['password' => md5($password)]);
			$this->db->update('users');
			return 1;
		} else {
			return 0;
		}
	}
	
	
	
	
	
	
}