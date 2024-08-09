<?


if (!function_exists('snakeToCamelcase')) {
	/**
	 * Преобразовать написание переменных
	 * @param 
	 * @return 
	*/
	function snakeToCamelcase($arr = false) {
		if (!$arr) return false;
		$newData = [];
		foreach ($arr as $varName => $value) {
			$newVarName = lcfirst(str_replace(' ', '', ucwords(str_replace('_', ' ', $varName))));
			$newData[$newVarName] = $value;
			unset($arr[$varName]);
		}
		return $newData;
	}
}




if (!function_exists('jsonResponse')) {
	/**
	 * ответ для AJAX запроса
	 * @param 
	 * @return 
	*/
	function jsonResponse($stat = false) {
		if ($stat) echo '1';
		else echo '0';
	}
}



if (!function_exists('currency')) {
	/**
	 * Валюта
	 * @param 
	 * @return 
	*/
	function currency($summ = 0, $tag = false, $countAfterDot = 0) {
		$CI = &get_instance();
		$params = $CI->admin_model->getSettings(['currency', 'currency_dot_count', 'currency_dot_count', 'currency_pos'], true);
		$currency = $params['currency'] ?? '₽';
		
		$currencyPos = $params['currency_pos'] ?? 'after';
		if (is_numeric($tag)) {
			$countAfterDot = $tag;
			$tag = false;
		}
		
		$currencyDotCount = $countAfterDot ?: ($params['currency_dot_count'] ?? 0);
		
		$summ = number_format((float)$summ, $currencyDotCount, '.', ' ');
		
		if ($tag) $currencyStr = preg_replace('/\$|₽/', $currency, $tag);
		//else $currencyStr = '<small>'.$currency.'</small>';
		else $currencyStr = $currency;
		
		if ($currencyPos == 'before') return $currencyStr.' '.$summ;
		if ($currencyPos == 'after') return $summ.' '.$currencyStr;
		return $currency;
	}
}








if (!function_exists('arrRemoveByKeys')) {
	/**
	 * Убрать из массива значчения с ключами, которые переданы вторым параметром
	 * @param основной массив
	 * @param массив с ключами
	 * @return 
	*/
	function arrRemoveByKeys($arr = false, $arrKeys = []) {
		if (!$arr || !is_array($arr)) return false;
		if (empty($arrKeys)) return $arr;
		return array_diff_key($arr, array_flip($arrKeys));
	}
}


if (!function_exists('arrGetByKeys')) {
	/** 
	 * Заполнить первый массив значениями из второга массива опираясь на ключи
	 * @param ключи
	 * @param массив с которого берутся данные
	 * @return 
	*/
	function arrGetByKeys($arrKeys = [], $arr = false) {
		if (!$arrKeys || !is_array($arrKeys) || !$arr || !is_array($arr)) return false;
		$needdedDataFromArr = array_intersect_key($arr, array_flip($arrKeys)) ?: [];
		return array_replace_recursive(array_flip($arrKeys), $needdedDataFromArr);
	}
}
	







				
				
















if (!function_exists('compareArrays')) {
	/**
	 * Сравнить массивы c новыми и исходными данными
	 * @param [массив с новыми данными, ключ, по которому будет вестись сравнение]
	 * @param [массив с исходными данными (в таблице), ключ, по которому будет вестись сравнение]
	 * @return три массива: [new - новые данные, которых нет в исходном массииве, update - обновленные данные, delete - данные которые нужно удалить из исходного массива]
	*/
	function compareArrays($mainArrayData = false, $compareArrayData = false) {
		if (!$mainArrayData ||!$compareArrayData) return false;
		$mainArray = is_array($mainArrayData[0]) ? $mainArrayData[0] : [];
		$compareArray = is_array($compareArrayData[0]) ? $compareArrayData[0] : [];
		
		if (!$mainFieldToKey = isset($mainArrayData[1]) ? $mainArrayData[1] : false) return false;
		if (!$compareFieldToKey = isset($compareArrayData[1]) ? $compareArrayData[1] : false) return false;
		
		$mainArray = $mainArray ? setArrKeyfromField($mainArray, $mainFieldToKey, true) : [];
		$compareArray = $compareArray ? setArrKeyfromField($compareArray, $compareFieldToKey, true) : [];
		
		$newRows = array_diff_key($mainArray, $compareArray);
		$updatedRows = array_intersect_key($mainArray, $compareArray);
		$deletedRows = array_diff_key($compareArray, $mainArray);
		
		$newRows = array_map(function($row) use ($mainFieldToKey) {
			unset($row[$mainFieldToKey]);
			return $row;
		}, $newRows);
		
		$updatedRows = array_map(function($row) use ($mainFieldToKey, $compareFieldToKey) {
			$row = array_reverse($row, true);
			$row[$compareFieldToKey] = $row[$mainFieldToKey];
			$row = array_reverse($row, true);
			unset($row[$mainFieldToKey]);
			return $row;
		}, $updatedRows);
		
		return [
			'new'       => array_values($newRows),
			'update'    => array_values($updatedRows),
			'delete'    => array_values($deletedRows)
		];
		
	}
}








if (!function_exists('arrRestructure')) {
	/**
	 * Перебор многомерного массива с коллбэк функцией для каждого элемента
	 * @param массив
	 * @param поля для реструктуризации. Строка или массив
	 * @param поля - которые нужно вернуть в конечных значениях. Можно задать несуществующее поле со знасением через двоеточие, тогда оно вернется со значением NULL (это нужно для создания бланка массива)
	 * @param вернуть сразу значение поля. По-умолчанию: массив [поле => значение]
	 * @return реструктурированный массив
	*/
	function arrRestructure($array = false, $regroupFields = false, $values = false, $onlyValue = false) {
		if (!$array || !$regroupFields) return false;
		if (!is_array($regroupFields)) $regroupFields = preg_split("/[\s,]+/", $regroupFields);
		if (!is_array($values)) $values = preg_split("/[\s,]+/", $values);
		
		$restructArr = [];
		$path = '';
		
		foreach ($regroupFields as $field) $path .= "[\$item['".$field."']]";
		
		foreach ($array as $item) {
			if ($values && count($values) > 1) {
				$v = [];
				foreach ($values as $val) {
					if (isset($item[$val])) $v[$val] = $item[$val];
					else {
						$val = explode(':', $val);
						$v[reset($val)] = isset($val[1]) ? $val[1] : null;
					}
				} 
			} elseif (isset($item[reset($values)])) {
				if ($onlyValue) $v = $item[reset($values)];
				else $v[reset($values)] = $item[reset($values)];
			} else {
				$v = array_diff_key($item, array_flip($regroupFields));
			}
			
			eval("return \$restructArr$path"." = \$v;");
		}
			
		return $restructArr ?: false;
	}
}









if (!function_exists('formatArray')) {
	/**
	 * Сформировать массив
	 * @param массив
	 * @param поле в качестве ключа
	 * @param поле(я) значений 
	 * @param если одно поле - то самого названия поля не будет
	 * @return 
	*/
	function formatArray($arr = false, $key = false, $fields = false, $noFieldName = false) {
		if (!$arr || !$key || !$fields) return false;
		if (!$fields = preg_split("/[\s,]+/", $fields)) return false;
		$data = [];
		foreach ($arr as $k => $row) {
			if (!isset($row[$key])) continue;
			if (count($fields) == 1 && $noFieldName) {
				$field = reset($fields);
				if (!isset($row[$field])) continue;
				$data[$row[$key]][] = $row[$field];
			} else {
				foreach ($fields as $field) {
					if (!isset($row[$field])) continue;
					$data[$row[$key]][$k][$field] = $row[$field];
				}
				$data[$row[$key]] = array_values($data[$row[$key]]);
			}  
		}
		return $data;
	}
}





if (!function_exists('sortUsers')) {
	function sortUsers($arr, $field = 'nickname') {    
		if (!$arr || !$field) return false;
		uasort($arr, function($a, $b) use ($field) {
			if (preg_match('/[а-яё.]+/ui', $a[$field]) && preg_match('/[a-z.]+/ui', $b[$field])) {
				return -1;
			} elseif (preg_match('/[a-z.]+/ui', $a[$field]) && preg_match('/[а-яё.]+/ui', $b[$field])) {
				return 1;
			} else {
				return $a[$field] < $b[$field] ? -1 : 1;
			}
		});
		return array_values($arr);
	}
}




if (!function_exists('getSprite')) {
	function getSprite($path) {    
		if ($svgData = @file_get_contents($path)) {
			return str_replace('<?xml version="1.0" encoding="utf-8"?><svg ', '<svg style="display:none;"', $svgData);
		}
		return false;
	}
}




if (!function_exists('isJson')) {
	/**
	 * Является ли формат строки JSON
	 * @param строка
	 * @return bool
	*/
	function isJson($string) {
		if (is_array($string) || !is_string($string) || is_numeric($string) || is_integer($string) || is_bool($string)) return false;
		json_decode($string);
		return (json_last_error() == JSON_ERROR_NONE);
	}
}




if (!function_exists('arrTakeItem')) {
	/**
	 * Взять элемент из массива по ключу. сократить сам массив
	 * @param 
	 * @return 
	*/
	function arrTakeItem(&$arr = false, $itemKey = false) {
		if (!$arr || !$itemKey) return false;
		if (!array_key_exists($itemKey, $arr)) return false;
		$takeItem = $arr[$itemKey];
		unset($arr[$itemKey]);
		return $takeItem;
	}
}     
	





if (!function_exists('arrCutByValue')) {
	/**
	 * Убрать элемент из массива по значению
	 * @param 
	 * @return 
	*/
	function arrCutByValue(&$arr = false, $itemValue = false, $countItems = 1, $replace = []) {
		if (!$arr || !$itemValue) return false;
		
		if (($searchIndex = array_search($itemValue, $arr)) === false) return false;
		
		array_splice($arr, $searchIndex, $countItems, $replace);
		return $arr ?: false;
	}
} 






if (!function_exists('encodeDirsFiles')) {
	function encodeDirsFiles($str = false) {
		if (!$str) return false;   
		$search = [DIRECTORY_SEPARATOR, "\'", "\"", "'", '"', " ", ".", ","];
		$replace = ["***", "&#39;", "&quot;", "&#39;", "&quot;", "___", "---", "==="];
		return quotemeta(str_replace($search, $replace, trim($str)));
	}
}



if (!function_exists('decodeDirsFiles')) {
	function decodeDirsFiles($str = false) {
		if (!$str) return false;   
		$search = ["***", "&#39;", "&quot;", "&#39;", "&quot;", "___", "---", "==="];
		$replace = [DIRECTORY_SEPARATOR, "\'", "\"", "'", '"', " ", ".", ","];
		return str_replace($search, $replace, $str);
	}
}












if (!function_exists('clearDirs')) {
	function clearDirs($dirs, $hideDirs = false) {
		$hideDirs = gettype($hideDirs) == 'string' ? explode('|', $hideDirs) : $hideDirs;
		$data = [];
		
		uksort($dirs, function($a, $b) {
			return strcasecmp($a, $b);
		});
		foreach ($dirs as $dirName => $dirData) {
			$dirName = str_replace([' ', '/', '\\', DIRECTORY_SEPARATOR], ['', '', '', ''], trim($dirName));
			if ($hideDirs && in_array($dirName, $hideDirs)) continue;
			//$dirName = decodeDirsFiles($dirName);
			if (is_array($dirData)) $data[$dirName] = clearDirs($dirData);
		}
		return $data;
	} 
}




if (!function_exists('toLog')) {
	/**
	 * Отправить данные в лог
	*/
	function toLog($data = null, $exit = false) {
		if (is_null($data)) return false;
		
		$logPath = APPPATH.'/logs/log.lg';
		
		if (!file_exists($logPath)) mkdir(APPPATH.'/logs', 0755);
		
		$fileData = @file_get_contents($logPath);
		$data = is_array($data) ? json_encode($data) : $data;
		
		if ($fileData != '') {
			$fileData .= '||'.$data;
		} else {
			$fileData = $data;
		}
		
		@file_put_contents($logPath, $fileData);  
		if ($exit !== false && $exit !== true) exit($exit);
		elseif ($exit === true) exit;
	}
}










if (!function_exists('getDatesRange')) {
	/**
	 * Получить массив дат с заданным шагом в заданном диапазоне
	 * - Текущая дата
	 * - Количество записей для диапазона
	 * - шаг даты для диапазона (day день, week неделя и т.д.)
	 * - направление диапазона (+ возрастание или - убывание)
	 * - что вернуть (маска функции Date()) Например: 'Y-m-d H:i' По-умолчанию UNIX
	 * - строгость UNIX даты. по-умолчанию - строго
	*/
	function getDatesRange($currentDate = null, $itemsCount = null, $dateType = 'day', $order = '+', $returnMask = false, $strict = true) {
		$currentDate = !is_null($currentDate) ? (!is_numeric($currentDate) ? strtotime($currentDate) : $currentDate) : time();
		$datesRange = [];
		for ($i = 0; $i < $itemsCount; $i++) {
			strtotime(date('Y-m-d', strtotime('+'.$i.$dateType, $currentDate)));
			if ($returnMask) $datesRange[] = date($returnMask, strtotime('+'.$i.$dateType, $currentDate));
			else {
				if ($strict) $datesRange[] = strtotime('+'.$i.$dateType, $currentDate);
				else $datesRange[] = strtotime(date('Y-m-d', strtotime('+'.$i.$dateType, $currentDate)));
			}
		}
		return $datesRange;
	}
}





if (!function_exists('getHoursMinutes')) {
	/**
	 * Получить часы и минуты, исходя из прбавления или отнимания от переданных часов и минут
	 * - Текущий час
	 * - Текущие минуты
	 * - Значение для смещения времени (часы|минуты или просто минуты)
	*/
	
	function getHoursMinutes($currentHours = null, $currentMinutes = null, $offset = 0, $separator = false) {
		
		if (is_numeric($offset)) {
			$hoursOffset = floor($offset / 60);
			$minutesOffset = $offset % 60;
		} else {
			$offs = explode('|', $offset);
			$offs = ($offs[0] * 60) + $offs[1];
			$hoursOffset = floor($offs / 60);
			$minutesOffset = $offs % 60;
		}
		
		
		$hoursData = range(0, 23);
		$hoursData[] = 0;
		$minutesData = range(0, 59);
		$minutesData[] = 0;
 
		$limitHours = 24;
		$limitMinutes = 60;
		$plusHours = 0;
		
		
		if ($minutesOffset + $currentMinutes <= $limitMinutes) $resMinutes = $minutesData[$minutesOffset + $currentMinutes];
		else {
			$plusHours = floor(($minutesOffset + $currentMinutes) / $limitMinutes);
			$resMinutes = $minutesData[($minutesOffset + $currentMinutes) % $limitMinutes];
		}
		
		
		if ($hoursOffset + $currentHours <= $limitHours) $resHours = $hoursData[$hoursOffset + $currentHours + $plusHours];
		else $resHours = $hoursData[($hoursOffset + $currentHours + $plusHours) % $limitHours];
		
		if ($separator) return substr('0'.$resHours, -2).$separator.substr('0'.$resMinutes, -2);
		return [$resHours, $resMinutes];
	}
}











if (!function_exists('intRange')) {
	/**
	 * Возвращает ряд чисел с указанием лимита и смещения
	 * - число от
	 * - число до
	 * - лимит чисел
	 * - смещение
	*/
	
	function intRange($from = null, $to = null, $limit = null, $offset = 0) {
		/*if ($from == null || $to == null || $limit == null || $from == $to) {
			return false;
		}*/
		
		if($from < $to) $res = range((int)$from, (int)$to);
		else $res = array_merge(range($from, $limit), range(0, (int)$to));
		
		if($offset > 0) {
			for($x = 0; $x < $offset; $x++) {
				$res[] = ($res[count($res) - 1] + 1 > $limit) ? ($res[count($res) - 1] + 1 - $limit) : ($res[count($res) - 1] + 1);
			}
		}
		$res = array_slice($res, $offset);
		return $res;
	}
}










if ( ! function_exists('buildArr')) {
	/** Возвращает индекс или элемент массива по указанному значению указанного поля элементов данного массива
	 * - массив array
	 * - поле string
	 * - значение string
	*/
	/*function buildArr($arr, $values = []) {
		$newArr = [];
		foreach ($arr as $k => $v) {
			foreach () {
				
			}
			$key = $v[$val];
			unset($v[$val]);
			$newArr[$key] = $v;
		}
	}*/
}






if ( ! function_exists('dateToNumeric')) {
	/**
	 * @param Дата в любом виде, например: 2019-02-11
	 * @return UNIX дата
	 */
	function dateToNumeric($date = null) {
		if (is_null($date)) return false;
		if (is_numeric($date)) return $date;
		else return strtotime($date);
	}
}






if (!function_exists('setArrKeyFromField')) {
	/**
	 * Подставляет поле массива в качестве ключа
	 * @param входящий массив
	 * @param поле для ключа 
	 * @param сохранить ли поля для ключа в значениях
	 * @param вернуть определенные поля (можно обойти preserveField и сразу задать returnFields)       
	 * @return array
	 */
	function setArrKeyFromField($array = null, $field = false, $preserveField = false, $returnFields = false) {
		if (!is_array($array) || empty($array)) return false;
		if (!is_bool($preserveField) ) {
			$returnFields = $preserveField;
			$preserveField = false;
		}
		if ($returnFields && !is_array($returnFields)) $returnFields = preg_split('/[\s,]+/', $returnFields);
		
		$newArr = [];
		foreach ($array as $key => $val) {
			$newKey = ($field && isset($val[$field])) ? $val[$field] : $key;
			if (!$preserveField) unset($val[$field]);
			if ($returnFields) {
				if (count($returnFields) == 1) $newArr[$newKey] = $val[reset($returnFields)];
				else {
					$newArr[$newKey] = array_filter($val, function($item) use($returnFields) {
						if (in_array($item, $returnFields)) return $item;
					}, ARRAY_FILTER_USE_KEY);
				}
			} else {
				$newArr[$newKey] = $val;
			}
		}
		return $newArr;
	}
}

	
	
	
	
	
if ( ! function_exists('setHeadersToDownload')) {
	/**
	 * Задает заголовки для отдачи браузеру на скачивание
	 * @return Заголовки на скачивание
	 */
	function setHeadersToDownload($contentType = 'text/html', $charset = 'utf-8') {
		header('Content-Description: File Transfer');
		header('Content-Type: '.$contentType.'; charset='.$charset);
		header('Content-Transfer-Encoding: binary');
		header('Expires: 0');
		header('Cache-Control: must-revalidate');
		header('Pragma: public');
	} 
}





if (!function_exists('setAjaxHeader')) {
	/**
	 * Задать заголовки для ajax
	 * @param ключ или масссив из ключей и значений
	 * @param значение
	 * @return 
	*/
	function setAjaxHeader($keyOrArr = false, $value = null, $preffix = 'ddr-') {
		if (!$keyOrArr) return false;
		if (is_array($keyOrArr)) {
			foreach ($keyOrArr as $k => $val) {
				$val = isJson($val) ? json_encode($val) : $val;
				header($preffix.$k.': '.$val);
			}
		} else {
			if (is_null($value)) return false;
			if (is_array($value)) $value = json_encode($value);
			//elseif (is_string($value)) $value = cyrillicEncode($value);
			header($preffix.$keyOrArr.': '.$value);
		}
	}
}









if ( ! function_exists('getIndexFromFieldValue')) {
	/** Возвращает индекс или элемент массива по указанному значению указанного поля элементов данного массива
	 * - массив array
	 * - поле string
	 * - значение string
	*/
	function getIndexFromFieldValue($array = [], $field = null, $value = null) {
		if(is_null($array) || is_null($field) || is_null($value)) return false;
		$res = array_filter($array, function($val, $key) use($field, $value) {
			return ($val[$field] == $value);
		}, ARRAY_FILTER_USE_BOTH);
		
		if ($res && count($res) > 1) {
			$keys = [];
			while ($item = current($res)) {
				$keys[] = key($res);
				next($res);
			}
			return $keys;
		} elseif ($res && count($res) == 1) {
			return key($res);
		} else {
			return false;
		}
	}
}




if ( ! function_exists('arr_getFields')) {
	/** Возвращает заданные поля из массива
	 * - массив array
	 * - поля string
	*/
	function arr_getFields($array = [], $fields = null) {
		if(empty($array) || is_null($fields)) {if(config_item('log_helper')) return false;}
		if(! is_array($fields)) {
			preg_match_all('/\b\w+\b/mi', $fields, $matches);
			if(empty($matches[0])) {return false;}
			$fields = $matches[0];
		} 
		
		if(config_item('log_helper')) toLog('Выборка полей: '.implode(' ', $fields));
		if(count($fields) == 1) return array_column($array, $fields[0]);
		
		$data = [];
		foreach($fields as $field) $data[$field] = array_column($array, $field);
		return $data;
	}
}





if ( ! function_exists('arr_mergeItems')) {
	/**
	 * Объединяет подмассивы
	 * - массив array
	 * - название поля, которое добавится в массив со значением ключа родительского элемента массива
	*/
	function arr_mergeItems($array = [], $keyField = false) {
		if(empty($array)) {if(config_item('log_helper')) toLog('Ошибка! arr_mergeItems ошибка входящих данных'); return false;}
		if(config_item('log_helper')) toLog('Объединение записей...');
		if($keyField) {
			foreach($array as $key => $items) {
				$array[$key] = array_map(function($item) use($keyField, $key) {
					$item[$keyField] = $key;
					return $item;
				}, $items);
			}
		}
		return call_user_func_array('array_merge', $array);
	}
}





if ( ! function_exists('arrSortByField')) {
	/**
	 * Сортировка массива по определенному полю
	*/
	function arrSortByField($array = [], $field = null, $sort = 'desc', $keepKeys = false) {
		if(empty($array) || is_null($field)) {if(config_item('log_helper')) toLog('Ошибка! arrSortByField ошибка входящих данных'); return false;}
		if(config_item('log_helper')) toLog('Сортировка по полю '.$field.' от '.(strtolower($sort) == 'asc' ? 'а-я' : 'я-а'));
		uasort($array, function($a, $b) use($field, $sort) {
			$aField = $a[$field] ?? false;
			$bField = $b[$field] ?? false;
			if ($aField == $bField) return 0;
			if(strtolower($sort) == 'asc') return ($aField < $bField) ? -1 : 1;
			if(strtolower($sort) == 'desc') return ($aField < $bField) ? 1 : -1;
		});
		if($keepKeys) return $array;
		return array_values($array);
	}
}









if ( ! function_exists('arr_removeByZeroField')) {
	/**
	 * Очистка массива записей от записей с несуществующим, пустым, нулевым или null значением заданного поля
	*/
	function arr_removeByZeroField($array = [], $field = null, $returnField = false) {
		if(empty($array) || is_null($field)) {if(config_item('log_helper')) toLog('Ошибка! arr_removeByZeroField ошибка входящих данных'); return false;}
		$filter = array_values(array_filter($array, function($item) use($field) {
			return(isset($item[$field]) && ! is_null($item[$field]) && $item[$field] != 0 && $item[$field] != '');
		}));
		if(empty($filter)) return false;
		if($returnField) return arr_getFields($filter, $returnField);
		return $filter;
	} 
}








if ( ! function_exists('bringTypes')) {
	/** 
	 * Приводит типы данных элементов массива
	*/
	function bringTypes($inpArray = []) {
		if(empty($inpArray)) return false;
		$resData = [];
		foreach($inpArray as $key => $val) {
			if(is_string($val)) $val = trim($val);
			if(!is_array($val)) {
				if((is_bool($val) && $val === false) || $val === 'false' || $val === 'FALSE') $resData[$key] = false;
				elseif((is_bool($val) && $val === true) || $val === 'true' || $val === 'TRUE') $resData[$key] = true;
				elseif(is_null($val) || $val === 'null' || $val === 'NULL' || $val === null || $val === NULL || $val === '' || preg_match('/^\s+$/', $val)) $resData[$key] = null;
				elseif(is_float($val) || (preg_match('/^-?\d+\.\d+$/', $val) && substr($val, -1) != '0')) $resData[$key] = (float)$val;
				elseif(preg_match('/^-?\d+\.\d+$/', $val) && substr($val, -1) == '0') $resData[$key] = (string)$val;
				elseif(is_int($val) || preg_match('/^-?\d+$/', $val)) $resData[$key] = (int)$val;
				else $resData[$key] = (string)$val;
			} 
			else $resData[$key] = bringTypes($val);
		}
		return $resData;
	}
}









if ( ! function_exists('scanFolder')) {
	/** Сканирует директорию и возвращает список файлов
		- путь до директории
	*/
	function scanFolder($path = null, $remove = []) {
		if (! is_dir($path) || ! is_array($remove) || ! $files = scandir($path)) return false;
		if ($files[array_search('.', $files)]) unset($files[array_search('.', $files)]);
		if ($files[array_search('..', $files)]) unset($files[array_search('..', $files)]);    
		if (empty($files)) return false;
		if ($remove) {
			foreach ($remove as $item) {
				if ($files[array_search($item, $files)]) unset($files[array_search($item, $files)]);
			}
		}
		if (empty($files)) return false;
		return $files;
	}
}

