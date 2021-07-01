/*
	Отправка данных формы
	- settings
		- url: URL запрашиваемой страницы
		- fields: дополнительные поля {field: value}
		- files: дополнительные файлы {field: название поля files: список файлов}
		- type: GET или POST
		- dataType: json
		- ignoreNames: игнорировать по name
		- ignore: игнорировать по атрибуту, классу и пр. пример: '[attr1],[attr2]' или '.class1,.class2'
		- formError: функция срабатывает при наличии ошибок при заполнении формы в соответствии с rules
		- beforeSend: функция срабатывает перед отправкой запроса
		- success: функция если ошибок не возникло с возвратом данных из функции контроллера
		- error: функция при ошибке с возвратом статуса
		- complete: функция срабатывает по окончании AJAX запроса
		- returnFields: вернуть поля. Есди не указан url - просто вернуть поля без отправки на сервер

	Для полей
	- rules
		- empty: не допустить постое поле
		- reg: регулярное выражение без / /
		- not: запрещенные слова или фразы (через запятую)
		- length: ограничение по длине строки
		- num: только цифра и диапазон числовых данных например: num:1,10 (что означает число от 1 до 10)
		- string: строка
		- email: почта
		- phone: номер телефона в формате +7 (902) 200-90-22
		- rus: только кириллица
		- eng: только литиница

		!!! Если добавить к инпуту атрибуд ignore - то данный инпут будет игнорироваться
		!!! Если добавить инпут с name начинающимся с _ - то он будет учитываться в ошибках, но игнорироваться в дальнейшей отправке данных
*/
$.fn.formSubmit = function(settings) {
	var formSelector = this;
	if (formSelector == undefined || $(formSelector).length == 0) return false;

	var form = new FormData,
		url = settings.url ? (settings.url.substr(0, 1) != '/' ? '/'+settings.url : settings.url) : false,
		errorFields = [],
		fieldsData = [],
		lang = localStorage.getItem('language') || 'ru',
		language = {ru: {
			mat: 'ОЙ-ёй! нельзя так! Мы же культурные!',
			noEmptyFile: 'Ошибка! Файл не может быть пустым!',
			noEmptyField: 'Ошибка! Поле не может быть пустым!',
			error: 'Ошибка!',
			errorValue: 'Ошибка! Данное значение недопустимо!',
			errorLength: 'Ошибка! Допускаются длина',
			symbols: 'символов!',
			errorOnlyNums: 'Ошибка! Допускаются только цифры',
			errorDiapason: 'Ошибка! Допускаются диапазон',
			errorDisabledSymbols: 'Ошибка! Запрещенные символы в строке!',
			errorEmail: 'Ошибка! Email указан некорректно',
			errorPhone: 'Ошибка! Телефон указан некорректно',
			errorSeo: 'Ошибка! SEO URL указан некорректно! Допускаются',
			errorUrl: 'Ошибка! URL указан некорректно!',
			errorSystem: 'Системная ошибка отправки данных!'
		}, en: {
			mat: 'Uh-Oh! You can`t do this! We are polite!',
			noEmptyFile: 'Error! File cannot be empty!',
			noEmptyField: 'Error! This field cannot be empty!',
			error: 'Error!',
			errorValue: 'Error! This value is not allowed!',
			errorLength: 'Error! Allowed length',
			symbols: 'symbols!',
			errorOnlyNums: 'Error! Only numbers are allowed',
			errorDiapason: 'Error! Allowed range',
			errorDisabledSymbols: 'Error! Forbidden characters in a string!',
			errorEmail: 'Error! Email is specified incorrectly',
			errorPhone: 'Error! The Phone number is specified incorrectly',
			errorSeo: 'Error! SEO URL is specified incorrectly! Allow',
			errorUrl: 'Error! URL is specified incorrectly!',
			errorSystem: 'System error in sending data!'
		}};


	$(formSelector).find('input[name], textarea[name], select[name], [contenteditable][name]').not('input[type="button"]').each(function() {
		if (settings.ignore) {
			if (typeof settings.ignore == 'string') {
				if ($(this).is(settings.ignore)) return true;
			} else if (Array.isArray(settings.ignore)) {
				if ($(this).is(settings.ignore.join(','))) return true;
			}
		}

		var f = this,
			isFile = $(f).closest('.file').length > 0 ? true : false,
			n = $(f).attr('name') || false, // $(f).attr('name') || $(f).attr('class') || false,
			t = $(f).attr('type') || ($(f)[0].type != undefined ? $(f)[0].type.replace('select-one', 'select') : ($(f).hasAttr('contenteditable') ? 'contenteditable' : false)),
			r = ($(f).attr('rules') != undefined) ? $(f).attr('rules').split('|') : false,
			v = (t == 'file') ? ($(f).prop('files').length ? $(f).prop('files') : null) : (['checkbox', 'radio'].indexOf(t) != -1 ? ($(f).is(':checked') ? (t == 'radio' ? $(f).val() : 1) : (t == 'radio' ? null : 0)) : (t == 'contenteditable' ? (getContenteditable($(f)) || null) : ((t =='hidden' ? ($(f).prop('value') || null) : $(f).val()) || null)));


		if (n == undefined || n === false) return true;
		if (isInt(v)) v = parseInt(v);
		if (isFloat(v)) v = parseFloat(v);
		//if (isJson(v)) v = JSON.parse(v);
		if (['file', 'radio'].indexOf(t) != -1 && v == null) return true;

		if (settings.ignoreNames) {
			if (typeof settings.ignoreNames == 'string') {
				if (settings.ignoreNames == n) return true;
			} else if (Array.isArray(settings.ignoreNames)) {
				if (settings.ignoreNames.indexOf(n) != -1) return true;
			}
		}

		if (r) {
			$.each(r, function(k, r) {
				var errStat = true,
					ri = r.split(':'),
					rule = ri[0]
					params = ri[1] != undefined ? ri[1].split(',') : false,
					text = ri[2] || false;


				if (errStat && v != null) {
					if (typeof v == 'string' && containsMat(v)) {
						errorFields.push({
							field: f,
							error: text || language[lang]['mat']
						});
						errStat = false;
					}
				}


				if (errStat && v == null && rule == 'empty') {
					errorFields.push({
						field: f,
						error: text || (isFile ? language[lang]['noEmptyFile'] : language[lang]['noEmptyField'])
					});
					errStat = false;
				}


				if (errStat && v != null && rule == 'reg') {
					var regExp = new RegExp(params[0], params[1]);
					if (/<\?php|<\?|<script|\$\(/gi.test(v) == true || regExp.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['error']
						});
						errStat = false;
					}
				}


				if (errStat && v != null && rule == 'not') {
					if (/<\?php|<\?|<script|\$\(/gi.test(v) == true || params.indexOf(v) != -1) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorValue']
						});
						errStat = false;
					}
				}


				if (errStat && v != null && rule == 'length') {
					if ((params[0] && v.toString().length < params[0]) || (params[1] && v.toString().length > params[1])) {
						var at = params[0] ? 'от '+params[0]+' ' : '',
							to = params[1] ? 'до '+params[1]+' ' : '';
						errorFields.push({
							field: f,
							error: text || language[lang]['errorLength']+' '+at+to+language[lang]['symbols']
						});
						errStat = false;
					}
				}


				if (errStat && v != null && rule == 'num') {
					if (/^(\d)+$/g.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorOnlyNums']
						});
						errStat = false;
					}
					if (errStat && params && (params[0] != undefined && v < params[0]) || (params[1] != undefined && v > params[1])) {
						var at = params[0] ? ' от '+params[0]+'' : '',
							to = params[1] ? ' до '+params[1]+'' : '';
						errorFields.push({
							field: f,
							error: text || language[lang]['errorDiapason']+at+to+'!'
						});
						errStat = false;
					}
				}

				if (errStat && v != null && rule == 'string') {
					if (/<\?php|<\?|<script|\$\(/gi.test(v) == true) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorDisabledSymbols']
						});
						errStat = false;
					}
				}

				if (errStat && v != null && rule == 'eng') {
					if (/<\?php|<\?|<script|\$\(/gi.test(v) == true || /^[^а-яё]+$/giu.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorDisabledSymbols']
						});
						errStat = false;
					}
				}

				if (errStat && v != null && rule == 'rus') {
					if (/<\?php|<\?|<script|\$\(/gi.test(v) == true || /^[^a-z]+$/giu.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorDisabledSymbols']
						});
						errStat = false;
					}
				}

				if (errStat && v != null && rule == 'email') {
					if (/^[0-9a-zA-Z_.-]+@[a-z0-9_.-]+.[a-z]{2,10}$/gi.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorEmail']
						});
						errStat = false;
					}
				}

				if (errStat && v != null && rule == 'phone') {
					if (/^\+\d{1,3} \(\d{3}\) \d{3}(-|\s)?\d{2}(-|\s)?\d{2}$/g.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorPhone']
						});
						errStat = false;
					}
				}

				if (errStat && v != null && rule == 'seourl') {
					if (/<\?php|<\?|<script|\$\(/gi.test(v) == true || /^[a-z0-9_-]+$/g.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorSeo']+': a-z0-9_-'
						});
						errStat = false;
					}
				}

				if (errStat && v != null && (rule == 'url' || rule == 'link')) {
					if (/^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$/g.test(v) == false) {
						errorFields.push({
							field: f,
							error: text || language[lang]['errorUrl']
						});
						errStat = false;
					}
				}

			});
		}

		// избавляемся от полей, начинающихся с _
		if (/\b_/.test(n)) {
			console.log('deleted '+n);
		} else {
			fieldsData.push({
				field: f,
				type: t,
				name: n,
				value: v
			});
		}


	});


	if (errorFields.length > 0) {
		if (settings.formError && typeof settings.formError == 'function') settings.formError(errorFields);

		$.each(errorFields, function(k, item) {
			if ($(item.field).attr('type') == 'hidden') return true;
			$(item.field).errorLabel(item.error);
		});

		return true;
	}

	if (!url || settings.returnFields) {
		if (settings.returnFields && typeof settings.returnFields == 'function') settings.returnFields(fieldsData);
		if (!url) return true;
	}


	$.each(fieldsData, function(k, i) {
		var field = i.field,
			type  = i.type,
			name = i.name,
			value = i.value;

		if (type == 'file') {
			var files = value;
			if (files.length > 0) {
				if (files.length > 1) {
					$.each(files, function(k, file) {
						form.append(name+'[]', file);
					});
				} else {
					form.append(name, files[0]);
				}
			} else {
				form.append(name, null);
			}
		} else if (type == 'checkbox' || type == 'radio') {
			form.append(name, value);
		} else {
			form.append(name, (value || ''));
		}
	});


	if (settings.fields) {
		$.each(settings.fields, function(field, value) {
			var v = typeof value == 'object' ? JSON.stringify(value) : value;
			form.append(field, v);
		});
	}


	if (settings.files) {
		var field = settings.files['field'],
			files = settings.files['files'];

		if (Array.isArray(files) == false) {
			files = Object.values(files);
		}

		files.map(function(file, index) {
	        form.append(field+'['+index+']', file);
	    });
	}


	$.ajax({
		type: settings.type || 'POST',
		url: url,
		dataType: settings.dataType || 'json',
		data: form,
		cache: false,
		contentType: false,
		processData: false,
		beforeSend: function() {
			if (settings.before && typeof settings.before == 'function') settings.before();
		},
		success: function(r) {
			if (settings.success && typeof settings.success == 'function') settings.success(r);
		},
		error: function(e, status) {
			notify(language[lang]['errorSystem'], 'error');
			showError(e);
			if (settings.error && typeof settings.error == 'function') settings.error(status);
		},
		complete: function() {
			if (settings.complete && typeof settings.complete == 'function') settings.complete();
		}
	});
};
