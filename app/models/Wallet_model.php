<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Wallet_model extends MY_Model {
	
	private $walletTable = 'wallet';
	private $walletTitlesTable = 'wallet_titles';
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	/**
	 * Внести данные в баланс кошельков
	 * @param платежные данные [user_id => summ]
	 * @param тип (откуда приход)
	 * @param название отчета или заявки на оплату
	 * @return bool
	*/
	public function setToWallet($items = false, $type = false, $title = false, $transfer = '+') {
		if (!$items || !$type || !$title) return false;
		if (!$titleId = $this->_addTitle($title)) return false;
		
		
		$insData = [];
		$date = time();
		foreach ((array)$items as $userId => $summ) {
			$insData[] = [
				'user_id'	=> $userId,
				'type'		=> $type,
				'title_id'	=> $titleId,
				'summ'		=> $summ,
				'transfer'	=> $transfer,
				'date'		=> $date,
			];
		}
		
		$this->db->insert_batch($this->walletTable, $insData);
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------------------
	
	
	
	/**
	 * Добавить название отчета и вернуть ID записи
	 * @param Название отчета
	 * @return ID записи
	*/
	private function _addTitle($title = false) {
		if (!$title) return false;
		if (!$this->db->insert($this->walletTitlesTable, ['title' => $title])) return false;
		return $this->db->insert_id();
	}
	
}