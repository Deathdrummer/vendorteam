<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Log extends MY_Controller {
	
	
	public function index() {
		echo '<div id="logButtonsBlock" style="position: fixed; top: 7px; left: calc(50% - 150px); padding: 5px; background-color: #fff; border: 1px solid #aaa; opacity: 0.4">';
		echo 	'<button style="height: 40px; padding-left: 30px;padding-right: 30px;margin-right: 10px;cursor: pointer;" onclick="location.reload();">Перезагрузить</button>';
		echo 	'<form action="log/clear" style="display: inline"><input type="submit" style="height: 40px; padding-left: 30px;padding-right: 30px;cursor: pointer;" value="Очистить" /></form>';
		echo '</div>';
		echo '<style>body {background:#efefef;} pre {height: calc(100% - 75px);} #logButtonsBlock {transition: opacity 0.16s;} #logButtonsBlock:hover {opacity: 1!important;}</style>';
		
		
		$myLog = @file_get_contents(APPPATH.'/logs/log.lg');
		$sysLog = @file_get_contents(BASEPATH.'/logs/log.lg');
		
		
		echo '<div style="white-space:nowrap;">';
		echo 	'<div style="float:left; padding: 60px 10px 10px; width: calc(50% - 25px);box-shadow:0 0 0 10px #efefef inset;">';
		echo 		'<pre style="margin: 0; word-break: break-all; white-space: pre; overflow-x: scroll; font-size: 12px;background:#fff;">';
						foreach (explode('||', $myLog) as $item) {
							if ($item == '') continue;
							if ($this->isJson($item)) {
								print_r(json_decode($item, true));
							} else {
								echo $item.'<br>';
							}
						}
		echo 		'</pre>';	
		echo 	'</div>';
		
		echo 	'<div style="float:right; padding: 60px 10px 10px; width: calc(50% - 25px);box-shadow:0 0 0 10px #efefef inset;">';
		echo 		'<pre style="margin: 0; word-break: break-all; white-space: pre; overflow-x: scroll; font-size: 12px;background:#fff;">';
						foreach (explode('||', $sysLog) as $item) {
							if ($item == '') continue;
							if ($this->isJson($item)) {
								print_r(json_decode($item, true));
							} else {
								echo $item.'<br>';
							}
						}
		echo 		'</pre>';
		echo 	'</div>';
		echo '</div>';			
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function clear() {
		file_put_contents(APPPATH.'/logs/log.lg', '');
		file_put_contents(BASEPATH.'/logs/log.lg', '');
		redirect('/log');
	}
	
	
	
	
	private function isJson($string) {
		json_decode($string);
		return (json_last_error() == JSON_ERROR_NONE);
	}
	
	
	
}