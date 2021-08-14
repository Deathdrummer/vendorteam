<?

class CI_Form_order {
	
	
	protected $CI;

    public function __construct() {
		$this->CI =& get_instance();
    }
    
    
    
    
    
    
    public function validate($postData) {

		function length($parts) {
			return "/^.{".$parts."}$/uim";
		};

		$rules = [
			'checkbox'	=> "/^(true|on)|(false|off)$/",
			'string'	=> "/^[^<>~@#$%&\n\t]+$/ui",
			'text'		=> "/^[0-9A-Za-zА-Яа-яёЁ?() !.,:;-–—'\"\n\t]+$/uim",
			'skype'		=> "/^[^{}<>]+$/ui",
			'email'		=> "/^[0-9a-zA-Z_.-]+@[a-z0-9_.-]+.[a-z]{2,10}$/",
			'phone'		=> "/^\+\d \(\d{3}\) \d{3}(-|\s)?\d{2}-\d{2}$/",
			'number'	=> "/^\d+$/"
		];


		// правило:условие|свой текст ошибки||правило2:условие2|свой текст ошибки 2||правило3|свой текст ошибки 3


		$errors = [];
		foreach ($postData as $name => $items) {
			if (! isset($items['rules']) || $items['rules'] == 'false') continue;
			
			$rulesArr = explode('||', $items['rules']);
			$indexOfempty = array_search('empty', $rulesArr); 
			if ($indexOfempty) {
				unset($rulesArr[$indexOfempty]);
				array_unshift($rulesArr, 'empty');
			}
			
			foreach ($rulesArr as $item) {
				if ($item == 'empty' && $items['value'] == '') break;
				
				$itemPart = explode('|', $item);
				$rule = $itemPart[0];
				$errorText = isset($itemPart[1]) ? $itemPart[1] : false;
				if (preg_match("/:/", $rule)) {
					$rulePart = explode(':', $rule);
					if (function_exists($rulePart[0])) {
						if (! preg_match(call_user_func($rulePart[0], $rulePart[1]), $items['value'])) {
							$errors[$name][] = $errorText;
						}
					}
				} elseif (isset($rules[$rule]) && ! preg_match($rules[$rule], $items['value'])) {
					$errors[$name][] = $errorText;
				}
			}
		}
		

		$this->sendEmail($postData);
		
		return $errors ?: 0;
	}
    
    
    
    
    
    
    
    
    private function sendEmail($postData) {
    	$dataToEmail = [];
		foreach ($postData as $name => $data) $dataToEmail[$name] = isset($data['value']) ? $data['value'] : $data;
		
		//toLog($dataToEmail);
		if (!isset($dataToEmail['from']) || !isset($dataToEmail['to'])) {
			toLog('form_order/sendEmail - ошибка! нет нужных полей для отправки E-mail');
			toLog($dataToEmail);
		}  else {
			$title = isset($dataToEmail['title']) ? $dataToEmail['title'] : 'Новое предложение или жалоба';
			
			$this->CI->load->library('email');
			$config['mailtype'] = 'html';
			$this->CI->email->initialize($config);
			
			$this->CI->email->from($dataToEmail['from'], 'Your Name');
			$this->CI->email->to($dataToEmail['to']);
			
			$this->CI->email->subject($title);
			$this->CI->email->message($this->CI->twig->render('views/'.$dataToEmail['template'], $dataToEmail));
			
			$this->CI->email->send();
		}	
    }
    
    
    
    
    

}


