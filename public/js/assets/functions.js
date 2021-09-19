tapEvent = ('ontouchstart' in window) ? 'tap' : 'click';


thisDevice = 'desktop';
if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
    thisDevice = 'mobile';
};


//--------------------------------------------- Месяцы
monthNames = {
	1: 'января',
	2: 'февраля',
	3: 'марта',
	4: 'апреля',
	5: 'мая',
	6: 'июня',
	7: 'июля',
	8: 'августа',
	9: 'сентября',
	10: 'октября',
	11: 'ноября',
	12: 'декабря',
};



Counter = function(start, order, step) {
    var count = start || 0;
    return function(num) {
        count = num != undefined ? num : count;
        return order == undefined || order == '+' ? (order == '-' ? count-=step : count+=step) : count-=step;
    }
};



/*
	Поиск в массиве объектов по значению ключа
		- массив объектов
		- поле, по которому искать
		- значение, которое искать
		возвращает индекс объекта массива
*/
searchInObject = function(arrObj, field, value) {
	let objIndex = arrObj.findIndex(function(element, index) {
		if (element[field] == value) return true;
	});
	return objIndex;
};



	




$.fn.setAttrib = function(attr, value) {
	if (attr == undefined) return false;
	if ($(this).length == 0) return false;
	$(this).prop(attr, (value || true));
	$(this)[0].setAttribute(attr, (value || true));
};


$.fn.removeAttrib = function(attr) {
	if (attr == undefined) return false;
	if ($(this).length == 0) return false;
	$(this).prop(attr, false);
	$(this)[0].removeAttribute(attr);
};




/*
	Является ли строка json
	- строка
*/
isJson = function(str) {
	if (str == undefined || typeof str == 'undefined') return false;
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
};


/*
	Является ли строка целым числом
*/
isInt = function(n) {
	if (n == undefined || typeof n == 'undefined') return false;
	if (typeof n != 'string') return Number(n) === n && n % 1 === 0;
	return Number(n)+'' === n;
};


/*
	Является ли строка числом с плавающей точкой
*/
isFloat = function(n) {
	if (n == undefined || typeof n == 'undefined') return false;
	if (typeof n != 'string') return Number(n) === n && n % 1 !== 0;
	return Number(n)+'' === n && Number(n) % 1 !== 0;
};




/*
	Проверка наличия атрибута
		- название атрибута
*/
$.fn.hasAttr = function(a) {
	var attr = $(this).attr(a);
	return typeof attr !== typeof undefined && attr !== false;
};

$.fn.hasAttrib = function(a) {
	var attr = $(this).attr(a);
	return typeof attr !== typeof undefined && attr !== false;
};




/*
	Срабатывает при изменении хэш-строки в браузере
	- отдает хэш БЕЗ #
*/
hashChange = function(callback) {
	$(window).on('hashchange', () => {
		let hash = location.hash.replace('#', '');
		if (callback && typeof callback == 'function') callback(hash);
	});
};







/*
	Изменение цифрового поля стрелками и цифрами
		- вернет
			- значение
			- селетор инпут
			- тип изменения arrow или key
		
*/
$.fn.onChangeNumberInput = function(callback) {
	let inpVal, selector = this;
	
	$(selector).on('keydown keyup mousedown mouseup', function(e) {
		let input = this;
		if (e.type == 'mousedown' || e.type == 'keydown') {
			inpVal = parseFloat($(input).val()) || 0;
		} else if (e.type == 'mouseup') {
			let v = parseFloat($(input).val()) || 0;
			if (inpVal != v) {
				if (callback && typeof callback == 'function') callback(v, input, e.type);
			}
		} else if (e.type == 'keyup' && [190, 13].indexOf(e.keyCode) == -1) {
			let v = parseFloat($(input).val());
			if (v != inpVal && callback && typeof callback == 'function') callback(v, input, e.type);
		}
	});
};





copyStringToClipboard = function(str) {
	var el = document.createElement('textarea');
	el.value = str;
	el.setAttribute('readonly', '');
	el.style.position = 'absolute';
	el.style.left = '-9999px';
	document.body.appendChild(el);
	el.select();
	document.execCommand('copy');
	document.body.removeChild(el);
}






// Задать куки
setCookie = function(cname, cvalue, exdays) {
    // expire the old cookie if existed to avoid multiple cookies with the same name
    if  (getCookie(cname)) {
        document.cookie = cname + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + "; " + expires + "; path=/";
};


// Получить куки
getCookie = function(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ')
            c = c.substring(1);
        if (c.indexOf(name) == 0) {
            return decodeURIComponent(c.substring(name.length, c.length));
        }
    }
    return '';
};







disableScroll = function() {
	var scrollPosition = [
	  self.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft,
	  self.pageYOffset || document.documentElement.scrollTop  || document.body.scrollTop
	];
	var html = $('html'); // it would make more sense to apply this to body, but IE7 won't have that
	html.data('scroll-position', scrollPosition);
	html.data('previous-overflow', html.css('overflow'));
	html.css('overflow', 'hidden');
	window.scrollTo(scrollPosition[0], scrollPosition[1]);
};


enableScroll = function() {
	// un-lock scroll position
	var html = jQuery('html');
	var scrollPosition = html.data('scroll-position');
	html.css('overflow', html.data('previous-overflow'));
	window.scrollTo(scrollPosition[0], scrollPosition[1]);
};


	
	
	
	
	
	
	
	
	
/*
	Передать в функцию event
	- можно передать объект с предполагаемым атрибутом или склассом {attribute: 'любое зачение'} или {class: ['любое зачение 1', 'любое зачение 2']}
	возвращает аттрибуты и классы элемента или true/false если находит заданный атрибут(ы) или класс(ы)
*/
tapEventInfo = function(e, d) {
	var data, attrs, classes, at = '';
	if (thisDevice == 'mobile') {
		attrs = e.changedTouches != undefined ? e.changedTouches[0].target.attributes : false;
		classes = e.changedTouches != undefined ? e.changedTouches[0].target.className : false;
	} else {
		attrs = e.target.attributes || false;
		classes = e.target.className || false;
	}

	if (attrs.length) {
		$.each(attrs, function(k, a) {
			at += ' '+a.name;
		});
	}

	data = {
		classes: (classes && typeof classes == 'string') ? classes.split(' ') : false,
		attributes: (at && typeof at == 'string') ? at.trim().split(' ') : false
	};

	if (d != undefined && d.class) {
		if (data.classes) {
			var fStat = false;
			if (typeof d.class == 'object') {
				$.each(d.class, function(k, cls) {
					if (data.classes.indexOf(cls) != -1) fStat = true;
				});
				return fStat;
			} else return (data.classes.indexOf(d.class) != -1);
		} else return false;
	}

	if (d != undefined && d.attribute) {
		if (data.attributes) {
			var fStat = false;
			if (typeof d.attribute == 'object') {
				$.each(d.attribute, function(k, attr) {
					if (data.attributes.indexOf(attr) != -1) fStat = true;
				});
				return fStat;
			} else return (data.attributes.indexOf(d.attribute) != -1);
		} else return false;
	}

	return data.classes || data.attributes ? data : false;
};
	
	




random = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
};


// lLn
generateCode = function(mask) {
	var letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
	var code = '';
	for(var x = 0; x < mask.length; x++) {
		if (mask.substr(x, 1) == 'l') code += letters[random(0,25)];
		else if (mask.substr(x, 1) == 'L') code += letters[random(0,25)].toUpperCase();
		else if (mask.substr(x, 1) == 'n') code += random(0,9);
	}
	return code;
};



//------------------------------------ Аргументы с GET данных
getArgs = function(arg) {
	var args = location.search.substr(1, location.search.length).split('&'),
		item,
		argsArr = [];
	
	$.each(args, function(k, i) {
		item = i.split('=');
		argsArr[item[0]] = item[1];
	});
	
	if (arg != undefined && argsArr[arg] != undefined) {
		return argsArr[arg];
	} else if (arg != undefined && argsArr[arg] == undefined) {
		return false;
	} else {
		return argsArr;
	}
};





//------------------------  проверка существования файла
urlExists = function(url) {
    var http = new XMLHttpRequest();
    http.open('HEAD', url, false);
    http.send();
    return http.status != 404;
};






// --------------------------------------------------------------------------------------- ajax render
renderTwig = function(block, params, callback) {
	var settings = $.extend({block: block}, params);
	$.ajax({
		type: 'POST',
		url: '/main/render',
		dataType: 'html',
		data: settings,
		success: function(data) {
			callback(data);
		},
		error: function(e) {
			console.log(e.responseText);
		}
	}); 
};







// --------------------------------------------------------------------------------------- ajax render
renderTwigAdmin = function(block, params, callback) {
	var settings = $.extend({block: block}, params);
	$.ajax({
		type: 'POST',
		url: '/admin/render',
		dataType: 'html',
		data: settings,
		success: function(data) {
			initEditors();
			callback(data);
		},
		error: function(e) {
			notify('Системная ошибка', 'error');
			console.log(e.responseText);
		}
	}); 
};







/* Динамический список */
dynamicList = function(params) {
	var ops = $.extend({
		listBlock: '', 	// - ID блока списка
		addButton: '', 	// - ID кнопки добавления элемента списка
		template: '', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '',	// - Класс кнопки удаления элемента списка
		phpFunctionRemove: '', 	// - Функция удаления в PHP
		removeCallback: false,
		removeQuestion: 'Удалить?', // Вопрос при удалении во всплывающем окне
		removeMessage: 'Успешно!', // - Сообщение после удаления
		onAdd: false // событие при добавлении новой строки
	}, params);
	
	if (ops.phpFunctionRemove.substr(0, 1) != '/') {
		ops.phpFunctionRemove = '/'+ops.phpFunctionRemove;
	}
	
	$(ops.addButton).on(tapEvent, function() {
		renderTwigAdmin('render/'+ops.template, {index: $(ops.listBlock).find('.list_item').length}, function(html) {
			if ($(ops.listBlock).has('.empty')) $(ops.listBlock).find('.empty').remove();
			$(ops.listBlock).append(html);
			if (ops.onAdd) ops.onAdd($(ops.listBlock).find('.list_item:last'));
		});
	});
	
	$('body').on(tapEvent, ops.removeButton, function() {
		var thisItem = this,
			thisId = $(thisItem).data('id');
		
		popUp({
			title: ops.removeQuestion,
		    width: 500,
		    buttons: [{id: 'remove'+thisId, title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(removeWin) {
			$('#remove'+thisId).on(tapEvent, function() {
				$.post(ops.phpFunctionRemove, {id: thisId}, function(response) {
					if (response) {
						if ($(ops.listBlock).find('.list_item').length == 1) $(ops.listBlock).append('<p class="empty">Нет данных</p>');
						$(thisItem).closest('.list_item').remove();
						notify(ops.removeMessage);
						if (ops.removeCallback && typeof ops.removeCallback == 'function') ops.removeCallback();
					} else {
						notify('Ошибка!', 'error');
					}
				}, 'json').always(function() {
					removeWin.close();
				}).fail(function(e) {
					showError(e);
					notify('Системная ошибка!', 'error');
				});
			});
		});
		
	});
};











$.fn.changeInputs = function(callback) {
	if (this.length == 0) {
		console.warn('changeInputs ошибка! Селектор: не найден!');
		return false;
	} 
	
	if (callback == undefined || typeof callback != 'function') {
		console.warn('changeInputs ошибка! callback функция не задана!');
		return false;
	}
		
	var selector = this;
	
	function _getEventData(e) {
		return {
			t: e.type,
			k: e.keyCode,
			s: e.currentTarget.localName,
			st: (e.currentTarget.type == undefined) ? 'contenteditable' : e.currentTarget.type.replace('select-one', 'select'),
			isShiftKey: e.shiftKey,
			isCtrlKey: e.ctrlKey,
			codeShift: (e.keyCode == 16),
			codeCtrl: (e.keyCode == 17),
			codeEnter: (e.keyCode == 13),
			codeX: (e.keyCode == 88),
			codeV: (e.keyCode == 86)
		};
	}
	
	function _setAction(thisItem, eData) {
		callback(thisItem, eData);
	}
	
	
	$(selector).on('change', 'select, input[type="checkbox"], input[type="radio"], input[type="color"], input[type="number"]', function(event) {
		var eData = _getEventData(event);
		_setAction(this, eData);
	});
	
	
	var keyDownVal;
	$(selector).on('keyup keydown', 'input, textarea, [contenteditable]', function(event) {
		var thisItem = this, eData = _getEventData(event);
		if (['text', 'password', 'email', 'tel', 'number'].indexOf(eData.st) != -1 || (eData.s == 'textarea' && !eData.codeShift && !eData.codeCtrl) || (eData.st == 'contenteditable')) {
			if (eData.t == 'keydown') keyDownVal = $(thisItem).val() || $(thisItem).html();
			else if (eData.t == 'keyup') {
				var thisKeyUpVal = $(thisItem).val() || $(thisItem).html();
				if (keyDownVal !== thisKeyUpVal || (eData.st == 'contenteditable' && eData.codeEnter)) {
					keyDownVal = thisKeyUpVal;
					_setAction(thisItem, eData);
				} 
			}
		}
	});
};










/*
	Выполняет действие со строкой, в которой были изменены инпуты или селекты
	Функция вешается на селектор блака, в котором расположены инпуты
	сразатывает при изменении любого инпута
	в callback функцию передается селектор, внутри которого был изменен инпут и селектор самого инпута
*/
$.fn.changeRowInputs = function(callback) {
	if (this.length == 0) {
		console.warn('changeInputs ошибка! Селектор: не найден!');
		return false;
	} 
	
	if (callback == undefined || typeof callback != 'function') {
		console.warn('changeInputs ошибка! callback функция не задана!');
		return false;
	}
		
	var selector = this,
	thisItemSelector = $(selector).children()[0];
	if (!thisItemSelector) return false;
	
	var thisItemTag = thisItemSelector.localName || '',
	thisItemClass = $(thisItemSelector).className ? '.'+thisItemSelector.className : '';
	
	
	function _getEventData(e) {
		return {
			t: e.type,
			k: e.keyCode,
			s: e.currentTarget.localName,
			st: e.currentTarget.type.replace('select-one', 'select'),
			isShiftKey: e.shiftKey,
			isCtrlKey: e.ctrlKey,
			codeShift: (e.keyCode == 16),
			codeCtrl: (e.keyCode == 17),
			codeEnter: (e.keyCode == 13),
			codeX: (e.keyCode == 88),
			codeV: (e.keyCode == 86)
		};
	}
	
	function _setAction(thisItem, eData) {
		var thisRow = $(thisItem).closest(thisItemTag+thisItemClass);
		callback(thisRow, thisItem, eData);
	}
	
	
	$(selector).on('change', 'select, input[type="checkbox"], input[type="radio"], input[type="color"], input[type="number"]', function(event) {
		var eData = _getEventData(event);
		_setAction(this, eData.st);
	});
	
	
	var keyDownVal;
	$(selector).on('keyup keydown', 'input, textarea, [contenteditable]', function(event) {
		var thisItem = this, eData = _getEventData(event);
		if (['text', 'password', 'email', 'tel', 'number'].indexOf(eData.st) != -1 || (eData.s == 'textarea' && !eData.codeShift && !eData.codeCtrl) || (eData.st == 'contenteditable')) {
			if (eData.t == 'keydown') keyDownVal = $(thisItem).val() || $(thisItem).html();
			else if (eData.t == 'keyup') {
				var thisKeyUpVal = $(thisItem).val() || $(thisItem).html();
				if (keyDownVal !== thisKeyUpVal || (eData.st == 'contenteditable' && eData.codeEnter)) {
					keyDownVal = thisKeyUpVal;
					_setAction(thisItem, eData);
				} 
			}
		}
	});
};














showError = function(e) {
	var showId = generateCode('lLLnnn');
	if ($('body').find('.show_error').length > 0) {
		$('body').find('.show_error').remove();
	}
	
	if (e.responseText) {
		var html = '<div>'+e.responseText+'</div>';
		var errData;
		if ($(html).find('#container').length > 0) {
			errData = '<div class="show_error"><div>'+$(html).find('#container').html()+'</div><button id="'+showId+'">Закрыть</button></div>';
		} else {
			errData = '<div class="show_error"><div>'+e.responseText+'</div><button id="'+showId+'">Закрыть</button></div>';
		}
		
		$('body').append(errData);
		
		$('#'+showId).on(tapEvent, function() {
			$(this).parent('.show_error').remove();
		});
	}	
};






getAjaxHtml = function() {
	let a = arguments,
		url = (typeof a[0] == 'string' ? (a[0].substr(0, 1) != '/' ? '/'+a[0] : a[0]) : false),
		params = typeof a[1] == 'object' ? a[1] : {},
		callback = typeof a[1] == 'function' ? a[1] : (a[2] !== undefined ? a[2] : false),
		always = typeof a[1] == 'function' ? (typeof a[2] == 'function' ? a[2] :false) : (typeof a[2] == 'function' ? (typeof a[3] == 'function' ? a[3] :false) : false);
		
	$.post(url, params, function(html) {
		html = html.trim();
		if (html && callback) callback(html, true);
		else if (callback) callback('<p class="empty center">Нет данных</p>', false);
	}, 'html').always(function() {
		if (always) always();
	}).fail(function(e) {
		notify('Системная ошибка!', 'error');
		showError(e);
	});
}











/* Отправка данных формы */
sendFormData = function(formSelector, settings) {
	if (formSelector == undefined || settings.url == undefined) return false;
	var f = new FormData($(formSelector)[0]),
		url = settings.url.substr(0, 1) != '/' ? '/'+settings.url : settings.url;
	
	if (settings.params) {
		$.each(settings.params, function(param, value) {
			f.append(param, value);
		});
	}
	
	$.ajax({
		type: settings.type || 'POST',
		url: url,
		dataType: settings.dataType || 'json',
		cache: false,
		contentType: false,
		processData: false,
		/*ifModified: ,
		beforeSend: ,
		dataFilter: ,
		async: ,
		password: ,*/
		data: f,
		success: function(r) {
			if (settings.success && typeof settings.success == 'function') settings.success(r);
		},
		error: function(e, status) {
			notify('Системная ошибка отправки данных!', 'error');
			showError(e);
			if (settings.error && typeof settings.error == 'function') settings.error(status);
		},
		complete: function() {
			if (settings.complete && typeof settings.complete == 'function') settings.complete();
		}
	});
};





initEditors = function(selector, callback) {
	var fontSizes = [],
		lineHeights = [];
	
	for (i = 0; i < 100; i++) {
		fontSizes.push(''+i);
		lineHeights.push(i+'px');
	} 
	
	var options = {
		disableDragAndDrop: true,
		height: 500,
		lang: 'en-US',
		emptyPara: '',
		lineHeights: lineHeights,
		fontSizes: fontSizes,
		codeviewFilter: false,
  		codeviewIframeFilter: true,
  		disableGrammar: true,
  		codemirror: {
		    theme: 'monokai'
		},
		toolbar: [
			['font', ['bold', 'italic', 'underline', 'clear']],
			['height', ['height']],
			['style', ['style']],
			['fontsize', ['fontsize']],
			['fontname', ['fontname']],
			['color', ['color']],
			['para', ['ul', 'ol', 'paragraph']],
			['table', ['table']],
			['insert', ['link', 'image', 'video']],
			['view', ['fullscreen', 'codeview']]
		],
		buttons: {
			image: function(context) {
				var ui = $.summernote.ui;
				var button = ui.button({
					contents: '<i class="note-icon-picture" />',
					tooltip: 'тултип',
					className: 'editorfile',
					click: function () {
						if (currentDir = lscache.get('clientmanagerdir')) {
							getAjaxHtml('filemanager/files_get', {directory: currentDir, filetypes: 'png|jpg|jpeg|gif|ico|bmp'}, function(html) {
								$('#clientFilemanagerContentFiles').html(html);
							});
							
							getAjaxHtml('filemanager/dirs_get', {current_dir: currentDir}, function(html) {
								$('#clientFilemanagerDirs').html(html);
							});
						}
						
						if ($('#clientFileManager').hasClass('visible') == false) {
							$('#clientFileManager').addClass('visible');
						}
												
						$('#clientFilemanagerContentFiles').off(tapEvent, '.image').on(tapEvent, '.image', function() {
							var thisFileBlock = $(this).closest('.file'),
								thisFilePath = $(thisFileBlock).attr('dirfile'),
								thisFileName = $(thisFileBlock).attr('namefile'),
								thisFileSrc = $(this).find('img').attr('src');
							
							context.invoke('editor.insertImage', location.origin+'/public/filemanager/'+thisFilePath);
							//$('.editor').summernote('insertImage', location.origin+'/public/filemanager/'+thisFilePath);	
							$('#clientFileManager').removeClass('visible');
						});			
					}
				});
				return button.render();
			}
		},
		callbacks: {
			onInit: function() {
				setTimeout(function() {
					if (callback && typeof callback == 'function') callback();
				}, 500);
			}
		}
	};
		
		
	
	$(selector).not('.summernote_activated').summernote(options);
	$(selector).addClass('summernote_activated');
	/*var selectors = [];
		
	$.each(editors, function(k, item) {
		var d = $(item).attr('editor').split('|'),
			h = d[1] != undefined ? parseInt(d[1]) : 500;
		
		selectors.push({
			selector: $(item).attr('editor'),
			height: h
		});
	});*/
	
	/*$.each(selectors, function(k, s) {
		options.height = s.height;
		$('[editor="'+s.selector+'"]').summernote(options);
		$('[editor="'+s.selector+'"]').addClass('activated');
	});*/
};





$.fn.getSummernoteCode = function() {
	return $(this).summernote('code');
};









// input type file событие изменения поля, на выходе даные загружаемого файла
$.fn.chooseInputFile = function(callback) {
	var thisInp = this, reader, file;
	
	$(thisInp).on('change', function(e) {
		if (e.currentTarget.type != 'file') return false;
		file = thisInp[0].files[0];
		if (!file) return false;
		reader = new FileReader();
		
		reader.onload = function(e) {
			var type = e.target.result.split('/')[0].substr(5, e.target.result.split('/')[0].length),
				ext = file.name.split('.');
			
        	if (callback && typeof callback == 'function') callback({
        		name: file.name,
        		ext: ext[ext.length - 1],
        		type: type, //image  application video  audio
        		size: file.size,
        		src: e.target.result
        	}, thisInp);
        };
        reader.readAsDataURL(file);
	});
};





// Событие при переключении табов
// Возвращает селектор tabstitles и селектор tabscontent
onChangeTabs = function(callback) {
	$(document).on('changetabs', function(e, thisItemTitle, thisItemContent) {
		if (typeof callback == 'function') callback(thisItemTitle, thisItemContent);
	});
};










// Мультивыбор мышью
// - 
// - 
// - 
$.fn.multiChoose = function(settings, callback) {
	var o = $.extend({
		item: false,
		cls: 'choosed',
		onChoose: true // item, row, stat, start
	}, settings),
		cellsRow = this,
		mDownStat = false,
		isChoosed = false,
		choosedItems = [];
		
	$(cellsRow).off('mousedown mouseup', o.item).on('mousedown mouseup', o.item, function(e) {
		var cell = this;
		
		if (e.type == 'mousedown') {
			mDownStat = true;
			choosedItems = [];
			if ($(cell).hasClass(o.cls) == false) {
				if (o.onChoose == true || (typeof o.onChoose == 'function' && o.onChoose(cell, cellsRow, true, true))) {
					$(cell).addClass(o.cls);
					choosedItems.push(cell);
					isChoosed = true;
				} else {
					mDownStat = false;
				}
			} else {
				if (o.onChoose == true || (typeof o.onChoose == 'function' && o.onChoose(cell, cellsRow, false, true))) {
					$(cell).removeClass(o.cls);
					choosedItems.push(cell);
					isChoosed = false;
				} else {
					mDownStat = false;
				}
			}
		} else if (e.type == 'mouseup') {
			mDownStat = false;
			if (choosedItems.length && callback && typeof callback == 'function') callback(cellsRow, choosedItems, isChoosed);
		}
	});
	
	
	$(cellsRow).off('mouseenter', o.item).on('mouseenter', o.item, function(e) {
		var cell = this;
		
		if ($(cell).hasClass(o.cls) == false && mDownStat && isChoosed) {
			if (o.onChoose == true || (typeof o.onChoose == 'function' && o.onChoose(cell, cellsRow, true, false))) {
				choosedItems.push(cell);
				$(cell).addClass(o.cls);
			} else {
				mDownStat = false;
			}
		} else if ($(cell).hasClass(o.cls) && mDownStat && isChoosed == false) {
			if (o.onChoose == true || (typeof o.onChoose == 'function' && o.onChoose(cell, cellsRow, false, false))) {
				$(cell).removeClass(o.cls);
				choosedItems.push(cell);
			} else {
				mDownStat = false;
			}
		} 
	});
};











// -------------------------------------------------------------------- Динамически инициализировать табы
ddrInitTabs = function(container) {
	
	var hashData = location.hash.substr(1, location.hash.length).split('.'),
		section = container != undefined ? container.replace('#', '') : hashData[0];
	
	if (hashData[1] != undefined) {
		$('#'+section).find('.tabstitles:not(.sub) li').removeClass('active');
		$('#'+section).find('.tabstitles:not(.sub) li#'+hashData[1]).addClass('active');
		
		$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('[tabid]').removeClass('visible');
		$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('[tabid="'+hashData[1]+'"]').addClass('visible');
	} else {
		$('#'+section).find('.tabstitles:not(.sub) li:first').addClass('active');
		$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('[tabid]:first').addClass('visible');
	}
	
	if (hashData[2] != undefined) {
		if ($('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').length > 0) {
			$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').each(function() {
				if ($(this).children('li#'+hashData[2]).length > 0) {
					$(this).children('li').removeClass('active');
					$(this).children('li#'+hashData[2]).addClass('active');
					
					$(this).siblings('.tabscontent').find('[tabid]').removeClass('visible');
					$(this).siblings('.tabscontent').find('[tabid="'+hashData[2]+'"]').addClass('visible');
				} else {
					$(this).children('li:first').addClass('active');
					$(this).siblings('.tabscontent').find('[tabid]:first').addClass('visible');
				}
			});
		}
	} else {
		if ($('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').length > 0) {
			$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').each(function() {
				$(this).children('li').removeClass('active');
				$(this).children('li:first').addClass('active');
				
				$(this).siblings('.tabscontent').find('[tabid]').removeClass('visible');
				$(this).siblings('.tabscontent').find('[tabid]:first').addClass('visible');
			});
		}	
	}
};





$.fn.setWaitToBlock = function(mess, cls, bg) {
	var selector = this;
	if (mess === false) {
		$(selector).css('background-color', 'none');
		$(selector).find('#ddrWaitBlock').remove();
	} else {
		$(selector).css('background-color', (bg || 'rgba(255, 255, 255, 0.2)'));
		$(selector).html('<div id="ddrWaitBlock" class="d-flex align-items-center justify-content-center flex-column'+(' '+cls || '')+'"><i class="fa fa-spinner fa-pulse fa-2x fa-fw"></i><p>'+mess+'</p></div>');
	}
		
};








/*
	Повесить ошибку на input
*/
$.fn.errorLabel = function(html) {
	var selectors = '.field, .textarea, .select, .file, .ddrselect, .popup__field, .popup__textarea, .popup__select, .popup__file, .ddrselect';
	if ($(this).closest(selectors).length == 0) {
		if ($(this).siblings('span.error').length > 0) {
			$(this).siblings('span.error').html(html);
		} else {
			$(this).after('<span class="error">'+html+'</span>');
		}
		$(this).addClass('error');
	} else {
		if ($(this).closest(selectors).find('span.error').length == 0) {
			$(this).closest(selectors).append('<span class="error">'+html+'</span>');
		} else {
			$(this).closest(selectors).find('span.error').html(html);
		}
		$(this).closest(selectors).addClass('error');
	}
};












function ClientFileManager() {
	var html = '',
		fileTypes,
		activeSelector,
		currentDir,
		typesGroups = {
			images: 'png|jpg|jpeg|gif|ico|bmp',
			videos: 'mp4|avi|mov|wmv|mpeg|3gp|flv|m4v|mpg|swf',
			audios: 'mp3|wav|wma|m3u|ogg|wav|wave',
			docs: 'doc|docx|pdf|ppt|pptx|rtf|xls|xlsx|txt',
		};
	
	
	html += '<div class="filemanager__client" id="clientFileManager">';
	html += '<div class="filemanager__topdirs mb-2">';
	html += 	'<ul class="filemanager__dirstree noselect" id="clientFilemanagerDirs"></ul>';
	html += '</div>';
	html += '<div class="filemanager__bottomfiles">';
	html += 	'<div class="filemanager__content_files filemanager__content_clientfiles noselect" id="clientFilemanagerContentFiles">';
	html += 		'<p class="empty center">Выберите раздел</p>';
	html += 	'</div>'
	html += '</div>';
	html += '</div>';
	$('body').append(html);
	
	
	$('body').on(tapEvent, '[filemanager]', function() {
		currentDir = lscache.get('clientmanagerdir') || false,
		activeSelector = this;
		fileTypes = $(this).attr('filemanager') || 0;
		if (typesGroups[fileTypes] != undefined) fileTypes = typesGroups[fileTypes];
		if (currentDir) {
			getAjaxHtml('filemanager/files_get', {directory: currentDir, filetypes: fileTypes}, function(html) {
				$('#clientFilemanagerContentFiles').html(html);
			});
			
			getAjaxHtml('filemanager/dirs_get', {current_dir: currentDir}, function(html) {
				$('#clientFilemanagerDirs').html(html);
			});
		}
		if ($('#clientFileManager').hasClass('visible') == false) {
			$('#clientFileManager').addClass('visible');
		}
	});
	
	
	$('body').on(tapEvent, '.filemanager_remove', function() {
		var thisImgblock = $(this).closest('.file, .popup__file');
		$(thisImgblock).find('.image_name').text('нет файла');
		$(thisImgblock).find('img').attr('src', './public/images/none.png');
		$(thisImgblock).find('input[type="hidden"]').val('');
	});
	
	
	
	getAjaxHtml('filemanager/dirs_get', {current_dir: currentDir}, function(html) {
		$('#clientFilemanagerDirs').html(html);
	});
	
	
	$('#clientFilemanagerDirs').on(tapEvent, '[directory]:not(.disabled):not(.active)', function() {
		var thisDirectory = $(this).attr('directory'); 
		lscache.set('clientmanagerdir', thisDirectory);
		$('#clientFilemanagerDirs').find('[directory]').removeClass('active');
		$(this).addClass('active');
		getAjaxHtml('filemanager/files_get', {directory: thisDirectory, filetypes: fileTypes}, function(html) {
			$('#clientFilemanagerContentFiles').html(html);
		});
	});
	
	
	
	$('#clientFilemanagerContentFiles').on(tapEvent, '.image', function() {
		if ($(activeSelector).closest('.file, .popup__file').find('input[type="hidden"]').length == 0) return false;
		var thisFileBlock = $(this).closest('.file, .popup__file'),
			thisFilePath = $(thisFileBlock).attr('dirfile'),
			thisFileName = $(thisFileBlock).attr('namefile'),
			thisFileSrc = $(this).find('img').attr('src');
		
		$(activeSelector).closest('.file, .popup__file').find('input[type="hidden"]').val(thisFilePath);
		$(activeSelector).find('img').attr('src', thisFileSrc);
		$(activeSelector).closest('.file, .popup__file').find('.image_name').text(thisFileName);
		$('#clientFileManager').removeClass('visible');
	});
	
	
	$('body').on(tapEvent, function() {
		if (!$('#clientFileManager').is(':hover') && $('[filemanager]:hover').length == 0 && $('.editorfile:hover').length == 0) {
			if ($('#clientFileManager').hasClass('visible')) {
				$('#clientFileManager').removeClass('visible');
			}
		}	
	});
	
	$('#clientFileManager').on('mouseenter', function() {
		disableScroll();
	});
	
	$('#clientFileManager').on('mouseleave', function() {
		enableScroll();
	});
};

clientFileManager = function() {
	return new ClientFileManager();
}