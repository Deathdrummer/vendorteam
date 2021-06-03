<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Test {
	
	private $CI;
	
	public function __construct() {
		$this->CI =& get_instance();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get() {
		return $this->CI->config->item('base_url');
	}
	
	
	
	
	
}