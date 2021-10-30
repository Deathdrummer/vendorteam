<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Pollings_model extends MY_Model {
	
	private $pollingsTable = 'pollings';
	private $pollingQuestionsTable = 'pollings_questions';
	private $pollingQuestionsVariantsTable = 'pollings_questions_variants';
	private $pollingAnswersTable = 'pollings_answers';
	
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	
	/**
	 * CRUD
	 * @param 
	 * @return 
	*/
	public function pollings($action = false) {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'all':
				$this->load->model(['users_model' => 'users', 'admin_model' => 'admin']);
				
				$this->db->select('p.*, '.$this->groupConcatValue(false, 'pq.id:count_questions', true));
				$this->db->join($this->pollingQuestionsTable.' pq', 'p.id = pq.polling_id', 'LEFT OUTER');
				$this->db->group_by('p.id');
				$this->db->order_by('p._sort', 'DESC');
				if (!$result = $this->_result($this->pollingsTable.' p')) return false;	
				
				$usersAnswers = $this->_getAnsweredUsers(); // получить данные по ответившим участникам
				
				$rowsData = [];
				foreach ($result as $row) {
					if ($row['users']) {
						$usersIds = json_decode($row['users'], true);
						$usersData = $this->users->getUsers(['where_in' => ['field' => 'u.id', 'values' => $usersIds], 'fields' => 'nickname avatar']);
						$row['users'] = $usersData;
					}
					
					if ($row['statics']) {
						$staticsIds = json_decode($row['statics'], true);
						$staticsData = $this->admin->getStatics(false, $staticsIds);
						$row['statics'] = $staticsData;
					}
					
					$row['count_questions'] = count(json_decode($row['count_questions'], true) ?: []);
					
					$row['count_users_answers'] = 0;
					if (isset($usersAnswers[$row['id']])) {
						foreach ($usersAnswers[$row['id']] as $userId => $countAnswers) {
							if ($countAnswers == $row['count_questions']) $row['count_users_answers'] += 1;
						}
					}
					
					if ($startDate = arrTakeItem($row, 'start')) {
						$startDate += $this->timezoneOffset; // добавляем для правильного отображения даты в списке
						$hoursMinutes = $startDate % 86400;
						$row['start_date'] = $startDate - $hoursMinutes;
						$row['start_hours'] = floor($hoursMinutes / (60 * 60)); 
						$row['start_minutes'] = ($hoursMinutes % (60 * 60)) / 60;
					}
					$rowsData[] = $row;
				}
				return $rowsData;
				break;
			
			case 'save':
				if (!$data) return false;
				if (!$this->db->insert($this->pollingsTable, $data)) return false;
				return $this->db->insert_id();
				break;
			
			case 'update':
				if (!$data) return false;
				$fields = $data['fields'];
				
				$startDate = arrTakeItem($fields, 'start_date');
				$startHours = arrTakeItem($fields, 'start_hours');
				$startMinutes = arrTakeItem($fields, 'start_minutes');
				
				if ($startDate = ($startDate ? strtotime($startDate) : false)) {
					$startHours = $startHours ? ($startHours * (60*60)) : 0;
					$startMinutes = $startMinutes ? ($startMinutes * 60) : 0;
					$fields['start'] = $startDate ? ($startDate + $startHours + $startMinutes) : null;
				}
				
				$this->db->where('id', $data['id']);
				if (!$this->db->update($this->pollingsTable, $fields)) return false;
				return true;
				break;
			
			case 'remove':
				if (!$pollingId = (isset($data['id']) ? $data['id'] : false)) return false;
				
				$questionsIds = $this->_getPollingQuestionsIds($pollingId);
				$this->db->where_in('question_id', $questionsIds);
				$this->db->delete($this->pollingQuestionsVariantsTable);
				
				$this->db->start_cache();
				$this->db->where('polling_id', $pollingId);
				$this->db->stop_cache();
				$this->db->delete($this->pollingQuestionsTable);
				$this->db->delete($this->pollingAnswersTable);
				$this->db->flush_cache();
				
				$this->db->where('id', $pollingId);
				$this->db->delete($this->pollingsTable);
				return true;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/** 
	 * Вопросы
	 * @param 
	 * @return 
	 */
	public function questions() {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'all':
				$this->db->select('q.id, q.title, q.answers_type, COUNT(qv.id) AS variants_count');
				$this->db->join($this->pollingQuestionsVariantsTable.' qv', 'qv.question_id = q.id', 'LEFT OUTER');
				$this->db->where('polling_id', $data['polling_id']);
				$this->db->group_by('q.id');
				$this->db->order_by('q.sort', 'ASC');
				if (!$questions = $this->_result($this->pollingQuestionsTable.' q')) return false;
				return $questions;
				break;
			
			case 'get':
				$this->db->select('id, title, answers_type, other_variant');
				$this->db->where('id', $data['question_id']);
				if (!$qData = $this->_row($this->pollingQuestionsTable)) return false;
				$qData['variants'] = $this->variants('all', $data);
				return $qData;
				break;
			
			case 'add':
				$variants = arrTakeItem($data, 'variants');
				
				$data['sort'] = $this->_getLastQuestionSortIndex($data['polling_id']);
				
				if (!$this->db->insert($this->pollingQuestionsTable, $data)) return false;
				$questionId = $this->db->insert_id();
				
				$this->variants('add', ['question_id' => $questionId, 'variants' => $variants]);
				return true;
				break;
			
			case 'update':
				$variants = arrTakeItem($data, 'variants');
				$questionId = arrTakeItem($data, 'question_id');
				
				$this->db->where('id', $questionId);
				if (!$this->db->update($this->pollingQuestionsTable, $data)) return false;
				
				$this->variants('update', ['question_id' => $questionId, 'variants' => $variants, 'answers_type' => $data['answers_type']]);
				return true;
				break;
				
			case 'sort':
				$this->db->update_batch($this->pollingQuestionsTable, $data['sort_data'], 'id');
				return true;
				break;
				
			case 'remove':
				$this->variants('remove', ['question_id' => $data['question_id']]);
				
				$this->db->where('id', $data['question_id']);
				$this->db->delete($this->pollingQuestionsTable);
				
				$this->db->where('question_id', $data['question_id']);
				$this->db->delete($this->pollingAnswersTable);
				return true;
				break;
			
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/** 
	 * Вопросы
	 * @param 
	 * @return 
	 */
	public function variants() {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'all':
				$this->db->select('id, content, scores');
				$this->db->where('question_id', $data['question_id']);
				$this->db->order_by('sort', 'ASC');
				if (!$variants = $this->_result($this->pollingQuestionsVariantsTable)) return false;
				return $variants;
				break;
			
			case 'add':
				if (!$data['variants']) return false;
				$insVariants = [];
				foreach ($data['variants'] as $variant) {
					$insVariants[] = [
						'question_id'	=> $data['question_id'],
						'scores' 		=> $variant['scores'],
						'content' 		=> $variant['content'],
						'sort' 			=> $variant['sort']
					];
				}
				if (!$this->db->insert_batch($this->pollingQuestionsVariantsTable, $insVariants)) return false;
				return true;
				break;
			
			case 'update':
				if (!isset($data['question_id']) || !isset($data['answers_type'])) return false;
				$answersType = arrTakeItem($data, 'answers_type');
				if ($answersType != 3 && (!isset($data['variants']) || !$data['variants'])) return false;
				
				if ($answersType == 3) {
					$this->db->where('question_id', $data['question_id']);
					if (!$this->db->delete($this->pollingQuestionsVariantsTable)) return false;
					return true;
				}
				
				$tableVariants = $this->variants('all', ['question_id' => $data['question_id']]);
				$items = compareArrays([$data['variants'], 'variant_id'], [$tableVariants, 'id']);
				
				if ($tableVariants && (count($tableVariants) == count($items['delete']) && empty($items['new'])) && $answersType != 3) return false;
				
				
				if (isset($items['new']) && $items['new']) {
					$this->db->insert_batch($this->pollingQuestionsVariantsTable, $items['new']);
				}
				
				if (isset($items['update']) && $items['update']) {
					$this->db->update_batch($this->pollingQuestionsVariantsTable, $items['update'], 'id');
				}
				
				if (isset($items['delete']) && $items['delete']) {
					$this->db->where_in('id', array_column($items['delete'], 'id'));
					$this->db->delete($this->pollingQuestionsVariantsTable);
				}
				
				return true;
				break;
			
			case 'remove':
				if (isset($data['variant_id'])) $this->db->where('id', $data['variant_id']);
				if (isset($data['question_id'])) $this->db->where('question_id', $data['question_id']);
				
				if (!$this->db->delete($this->pollingQuestionsVariantsTable)) return false;
				return true;
				break;
			
			case 'sort':
				$this->db->update_batch($this->pollingQuestionsVariantsTable, $data['sort_data'], 'id');
				return true;
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/** 
	 * Участники
	 * @param 
	 * @return 
	 */
	public function users() {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				$this->db->select('users');
				$this->db->where('id', $data['polling_id']);
				if (!$usersIds = $this->_row($this->pollingsTable, 'users')) return false;
				return json_decode($usersIds, true);
				break;
			
			case 'set':
				if (!$data['polling_id'] || !isset($data['users'])) return false;
				$usersIds = $data['users'] ? json_encode($data['users']) : null;
				
				$this->db->where('id', $data['polling_id']);
				if (!$this->db->update($this->pollingsTable, ['users' => $usersIds])) return false;
				return true;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Статикии
	 * @param 
	 * @return 
	 */
	public function statics() {
		$args = func_get_args();
		$action = $args[0];
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'get':
				$this->db->select('statics');
				$this->db->where('id', $data['polling_id']);
				if (!$staticsIds = $this->_row($this->pollingsTable, 'statics')) return false;
				return json_decode($staticsIds, true);
				break;
			
			case 'set':
				if (!$data['polling_id']) return false;
				$staticsIds = isset($data['statics']) ? json_encode($data['statics']) : null;
				
				$this->db->where('id', $data['polling_id']);
				if (!$this->db->update($this->pollingsTable, ['statics' => $staticsIds])) return false;
				return true;
				break;
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function setStatus($pollingId = false, $status = false) {
		if (!$pollingId || $status === false) return false;
		$this->db->where('id', $pollingId);
		if (!$this->db->update($this->pollingsTable, ['status' => $status])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------- Личный кабинет
	
	/**
	 * Аккаунт
	 * @param 
	 * @return 
	*/
	public function account($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'all':
				$this->load->model('account_model', 'account');
				$staticsIds = $this->account->getStaticsIds();
			
				$this->db->select('p.id, p.title, p.description, p.date, COUNT(pq.id) AS count_questions');
				$this->db->join($this->pollingQuestionsTable.' pq', 'p.id = pq.polling_id', 'LEFT OUTER');
				$this->_pollingsToUserСondition($data['user_id'], $staticsIds);
				$this->db->having('COUNT(pq.id) >', 0);
				$this->db->group_by('p.id');
				$this->db->order_by('_sort', 'DESC');
				if (!$pollings = $this->_result($this->pollingsTable.' p')) return false;
				
				$answers = $this->_getAnswersCount($data['user_id']);
				
				foreach ($pollings as $k => $row) {
					$countAnswers = isset($answers[$row['id']]) ? $answers[$row['id']] : 0;
					if ($countAnswers == $row['count_questions']) unset($pollings[$k]); // убрать из списка пойденные опросы
					else $pollings[$k]['count_answers'] = $countAnswers;
				}
				return $pollings;
				break;
			
			case 'get':
				$this->db->select('q.id AS question_id, q.title, q.answers_type, q.other_variant, '.$this->groupConcat('qv.question_id', 'qv.id:id, qv.content:content, qv.scores:scores, qv.sort:sort', 'variants'));
				$this->db->where('q.polling_id', $data['polling_id']);
				$this->db->join($this->pollingQuestionsVariantsTable.' qv', 'q.id = qv.question_id', 'LEFT OUTER');
				$this->db->group_by('q.id');
				$this->db->order_by('q.sort', 'ASC');
				if (!$result = $this->_result($this->pollingQuestionsTable.' q')) return false;
				
				$answeredQuestions = $this->_getAnsweredQuestions($data['user_id'], $data['polling_id']); // массив ID вопросов на которые ответили
				
				$pollingData = [];
				foreach ($result as $row) {
					
					if (isset($answeredQuestions[$row['question_id']])) {
						$row['answered'] = isset($answeredQuestions[$row['question_id']]['variants']) ? $answeredQuestions[$row['question_id']]['variants'] : (isset($answeredQuestions[$row['question_id']]['custom']) ? $answeredQuestions[$row['question_id']]['custom'] : null);
						$row['other'] = $answeredQuestions[$row['question_id']]['other'];
					}
					
					$row['variants'] = json_decode($row['variants'], true);
					$row['polling_id'] = $data['polling_id'];
					$pollingData[] = $row;
				}
				
				return $pollingData;
				break;
			
			case 'save':
				$variants = (isset($data['variants']) && $data['variants']) ? json_encode(arrTakeItem($data, 'variants')) : null;
				$other = (isset($data['other']) && $data['other']) ? arrTakeItem($data, 'other') : null;
				$custom = (isset($data['custom']) && $data['custom']) ? arrTakeItem($data, 'custom') : null;
				
				$this->db->where($data);
				if ($this->db->count_all_results($this->pollingAnswersTable) == 0) {
					if (!$this->db->insert($this->pollingAnswersTable, array_merge($data, ['variants' => $variants, 'other' => $other, 'custom' => $custom]))) return false;
				} else {
					$this->db->where($data);
					if (!$this->db->update($this->pollingAnswersTable, ['variants' => $variants, 'other' => $other, 'custom' => $custom])) return false;
					return true;
				}
				break;
				
			case 'count':
				$this->db->select('p.id, COUNT(pq.id) AS count_questions');
				$this->db->join($this->pollingQuestionsTable.' pq', 'p.id = pq.polling_id', 'LEFT OUTER');
				$this->_pollingsToUserСondition($data['user_id'], $data['statics']);
				$this->db->having('COUNT(pq.id) >', 0);
				$this->db->group_by('p.id');
				if (!$pollings = $this->_result($this->pollingsTable.' p')) return false;
				$answers = $this->_getAnswersCount($data['user_id']);
				
				$pollingsCount = 0;
				foreach ($pollings as $k => $row) {
					if (!isset($answers[$row['id']]) || $answers[$row['id']] < $row['count_questions']) $pollingsCount += 1;
				}
				
				return $pollingsCount;
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------- Статистика
	
	/**
	 * Статистика
	 * @param 
	 * @return 
	*/
	public function statistics($action = false) {
		$args = func_get_args();
		$action = isset($args[0]) ? $args[0] : false;
		$data = isset($args[1]) ? $args[1] : false;
		if (!$action) return false;
		
		switch ($action) {
			case 'common': // общая статистика (цифры)
				$this->db->where('p.id', $data['polling_id']);
				break;
			
			
			default: break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------------------- Приватные функции
	
	/**
	 * Получить условия для выборки опросов участников
	 * @param 
	 * @return 
	 */
	private function _pollingsToUserСondition($userId = false, $userStatics = false) {
		if (!$userId && !$userStatics) return false;
		
		$this->db->group_start();
		$this->db->group_start();
		$this->db->where('start <=', time());
		$this->db->or_where('start', null);
		$this->db->group_end();
		$this->db->where('status', 1);
		$this->db->group_end();
		
		$this->db->group_start();
		if ($userId) $this->db->where($this->jsonSearch($userId, 'users'));
		if ($userStatics) $this->db->or_where($this->jsonSearch($userStatics, 'statics'));
		$this->db->group_end();
	}
	
	
	
	
	
	/**
	 * Получить ID вопросов опроса
	 * @param ID опроса
	 * @return 
	 */
	private function _getPollingQuestionsIds($pollingId = false) {
		if (!$pollingId) return false;
		$this->db->select('id');
		$this->db->where('polling_id', $pollingId);
		if (!$result = $this->_result($this->pollingQuestionsTable)) return false;
		return array_column($result, 'id');
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getAnsweredQuestions($userId = false, $pollingId = false) {
		if (!$userId) return false;
		$this->db->select('question_id, variants, other, custom');
		$this->db->where('user_id', $userId);
		if ($pollingId) $this->db->where('polling_id', $pollingId);
		if (!$answers = $this->_result($this->pollingAnswersTable)) return false;
		
		$answersData = [];
		foreach ($answers as $row) {
			$row['variants'] = json_decode($row['variants'], true);
			$qId = arrTakeItem($row, 'question_id');
			$answersData[$qId] = $row;
		}
		return $answersData;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getAnswersCount($userId = false) {
		if (!$userId) return false;
		$this->db->select('polling_id, COUNT(id) AS answers_count');
		$this->db->where('user_id', $userId);
		$this->db->group_by('polling_id');
		if (!$answersCounts = $this->_result($this->pollingAnswersTable)) return false;
		return setArrKeyFromField($answersCounts, 'polling_id', 'answers_count');
	}
	
	
	
	
	
	/**
	 * 
	 * @param 
	 * @return [polling_id => [user_id => answers_count]]
	 */
	public function _getAnsweredUsers() {
		$this->db->select('polling_id, user_id, COUNT(question_id) AS answers_count');
		$this->db->group_by('polling_id, user_id');
		if (!$result = $this->_result($this->pollingAnswersTable)) return false;
		return arrRestructure($result, 'polling_id user_id', 'answers_count', true);
	}
	
	
	
	
	/**
	 * 	Получить последний индекс сортировки вопросв
	 * @param polling_id
	 * @return
	*/
	protected function _getLastQuestionSortIndex($pollingId = false) {
		if (!$pollingId) return false;
		$this->db->select('MAX(sort) AS max_sort');
		$this->db->where('polling_id', $data['polling_id']);
		$maxSort = $this->_row($this->pollingQuestionsTable) ?: 0;
		return ($maxSort + 1) ?: 999999;
	}
	
	
	
}