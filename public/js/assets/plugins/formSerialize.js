// аргумент rules - если true, то возвращает вместе с rules
;$.fn.formSerialize = function(rules) {
	var thisFormBlock = this,
		formData = {};
	
	$(thisFormBlock).find('input[type=text], input[type=tel], input[type=email], input[type=number], input[type=hidden], input[type=checkbox], input[type=radio]:checked, select, textarea').each(function() {
		var value = false;
		if (this.type == 'select_one') {
			value = $(this).children('option:selected').val();
		} else if (this.type == 'checkbox') {
			value = $(this).is(':checked') ? true : false;
		} else {
			value = $(this).val();
		}
		
		if (rules != undefined ? rules : false) {
			formData[$(this).attr('name')] = {
				'rules': $(this).attr('rules') || false,
				'value': value
			};
		} else {
			formData[$(this).attr('name')] = value;
		}
		
	});
	
	return formData;
};




/*;$.fn.formSerialize = function(rules) {
	var thisFormBlock = this,
		value,
		thisType,
		formData = {};
	
	$(thisFormBlock).find('input[type=text], input[type=tel], input[type=email], input[type=number], input[type=hidden], input[type=checkbox], input[type=radio]:checked, select, textarea, input[type=file]').each(function() {
		value = false,
		thisType = this.type;
		
		
		if (thisType == 'select_one') {
			value = $(this).children('option:selected').val();
		} else if (thisType == 'checkbox') {
			value = $(this).is(':checked') ? true : false;
		} else if (thisType == 'file') {
			if (this.files.length > 0) value = $(this).attr('path');
		} else {
			value = $(this).val();
		}
		
		if (rules != undefined ? rules : false) {
			formData[$(this).attr('name')] = {
				'rules': $(this).attr('rules') || false,
				'value': value
			};
		} else {
			if (value) {
				if (formData[$(this).attr('name')] != undefined) {
					if (typeof formData[$(this).attr('name')] == 'string') {
						var item = formData[$(this).attr('name')];
						formData[$(this).attr('name')] = [];
						formData[$(this).attr('name')].push(item);
						formData[$(this).attr('name')].push(value);
					} else {
						formData[$(this).attr('name')].push(value);
					}
				} else {
					formData[$(this).attr('name')] = value;
				}
			} 
		}
		
	});
	
	
	data = new FormData();
	
	$.each(formData, function(k, item) {
		if (typeof item == 'object') {
			$.each(item, function(ok, oi) {
				data.append(k, oi);
			});
		} else {
			data.append(k, item);
		}
	});
	
	
	return data;
};
*/