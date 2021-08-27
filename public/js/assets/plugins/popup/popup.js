/*
	Модальное окно (21.01.2020) Создано в глубочайшем стрессе. (08.10.2020) - все супер, работа идет, стресса нет! Митя привыкает к школе
	- опции
		- title: заголовок
		- width: ширина окна
		- html: контент
		- buttons: кнопки
		- buttonsAlign: выравнивание кнопок по левому или правому краю [left - слева, right - справа]
		- closeByButton: закрывать только по кнопкам
		- closePos: расположение кнопки "close" [left - слева, right - справа]
		- close: заголовок кнопки "закрыть"
		- topClose: верхний крестик "закрыть"

	- методы
		- wait: окно в режиме ожидания
		- close: закрыть окно
		- setData: задать контент [url или строка, параметры (или false, если строка), ширина окна]
		- setTitle: задать заголовок
		- onScroll: событие прокрутки окна
		- setButtons: задать кнопки [массив кнопок, кнопка "закрыть"]
		- setWidth: задать ширину окна
		- buttonsOnTop: кнопки сверху
		- dialog: вывести диалог [диалог, заголовок "да", заголовок "нет", каллбэк]
*/
function DdrPopUp(settings, callback) {
	var o = $.extend({
		title: false,
		width: false, // ширина окна
		html: '', // контент
		buttons: false, // массив кнопок
		buttonsAlign: 'right', // выравнивание вправо
		disabledButtons: false, // при старте все кнопки кроме закрытия будут disabled
		closePos: 'right', // расположение кнопки "close" left - слева, right - справа
		closeByButton: false, // Закрывать окно только по кнопкам [ddrpopupclose]
		closeButton: false, // заголовок кнопки "закрыть"
		winClass: false, // добавить класс к модальному окну
		contentToCenter: false, // весь контент по центру вертикально и горизонтально
		buttonsOnTop: false, // Кнопки сверху
		topClose: true, // верхний крестик "закрыть"
		lang: 'ru'
	}, settings),
		animationTime = 0.2,
		popupCloseTOut,
		buttonsHtml = '',
		topCloseHtml = '',
		titleHtml = '',
		popupHtml = '',
		ddrPopupId = 'ddrpopup'+generateCode('LlnlL'),
		ddrPopupSelector = '#'+ddrPopupId,
		language = {ru: {
			closeWin: 'Закрыть окно',
			noData: 'Нет данных',
			systemError: 'Системная ошибка!'
		}, en: {
			closeWin: 'Close window',
			noData: 'No data',
			systemError: 'System error!'
		}};



	var openingDdrPopup = $('body').find('.popup.popup_opening');
	if ($(openingDdrPopup).length) {
		$(openingDdrPopup).remove();
	}


	if (o.closePos == 'left') {
		if (o.closeButton) buttonsHtml += '<button class="popup__buttons_close" ddrpopupclose>'+o.closeButton+'</button>';
	}

	if(o.buttons) {
		$.each(o.buttons, function(k, b) {
			buttonsHtml += '<button'+((b.disabled || o.disabledButtons) ? ' disabled' : '')+(b.close ? ' ddrpopupclose' : '')+'  id="'+b.id+'"'+(b.metrikaId ? ' onclick="yaCounter'+(b.metrikaId)+'.reachGoal('+'\''+(b.metrikaTargetId)+'\''+'); return true;"' : '')+' class="popup__buttons_'+(b.type ? b.type : 'main')+''+(b.class ? ' '+b.class : '')+'">'+b.title+'</button>';
		});
	}

	if (o.closePos == 'right') {
		if (o.closeButton) buttonsHtml += '<button class="popup__buttons_close" ddrpopupclose>'+o.closeButton+'</button>';
	}


	if (o.title) {
		var tData = o.title.split('|'),
			title = tData[0],
			titleSize = tData[1] || '1',
			titleOverflow = (tData[2] == 1) ? ' popup__title_overflow' : '',
			titleHtml = '<h5 ddrpopuptitle class="popup__title'+titleOverflow+' popup__title_'+titleSize+'">'+title+'</h5>';
	}

	if (o.topClose) topCloseHtml = '<div ddrpopupclose class="popup__close" title="'+language[o.lang]['closeWin']+'"></div>';


	popupHtml += '';
	popupHtml += '<div class="popup" id="'+ddrPopupId+'">';
	popupHtml += 	'<div class="popup__wrap">';
	popupHtml += 		'<div class="popup__container">';
	popupHtml += 			'<div class="popup__win'+(o.winClass ? ' '+o.winClass : '')+' noselect" ddrpopupwin>';
	popupHtml += 				'<div class="popup__wait">';
	popupHtml += 					'<div class="popupwait" ddrpopupwaitblock>';
	popupHtml += 						'<i class="fa fa-spinner fa-pulse fa-fw"></i>';
	popupHtml += 						'<p ddrpopupwait></p>';
	popupHtml += 					'</div>';
	popupHtml += 				'</div>';
	if (titleHtml || topCloseHtml) {
	popupHtml += 				'<div class="popup__header">';
	popupHtml +=					titleHtml;
	popupHtml +=					topCloseHtml;
	popupHtml += 				'</div>';
	}
	
	if (o.buttonsOnTop) {
	popupHtml += 				'<div class="popup__footer">';
	popupHtml += 					'<div class="popup__buttons'+(o.buttonsAlign ? ' popup__buttons_'+o.buttonsAlign : '')+'" ddrpopupbuttons>'+buttonsHtml+'</div>';
	popupHtml += 				'</div>';
	}

	if (o.contentToCenter) popupHtml += '<div class="popup__content d-flex align-items-center justify-content-center"><div ddrpopupcontent>'+o.html+'</div></div>';
	else popupHtml += '<div class="popup__content" ddrpopupcontent>'+o.html+'</div>';
	if (!o.buttonsOnTop) {
	popupHtml += 				'<div class="popup__footer">';
	popupHtml += 					'<div class="popup__buttons'+(o.buttonsAlign ? ' popup__buttons_'+o.buttonsAlign : '')+'" ddrpopupbuttons>'+buttonsHtml+'</div>';
	popupHtml += 				'</div>';
	}
	popupHtml += 			'</div>';
	popupHtml += 		'</div>';
	popupHtml += 	'</div>';
	popupHtml += '</div>';

	$('body').append(popupHtml);
	if (o.width) $(ddrPopupSelector).find('[ddrpopupwin]').width(o.width);

	$(ddrPopupSelector).ready(function() {
		_popupOpen();
	});


	// Закрыть окно
	$(ddrPopupSelector).on(tapEvent, function(e) {
		var isCloseButton = tapEventInfo(e, {attribute: 'ddrpopupclose'});
		if (isCloseButton) _popupClose();
		else if (o.closeByButton == false) {
			var isCloseClass = tapEventInfo(e, {class: 'popup__wrap'});
			if (isCloseClass) {
				if (thisDevice == 'desktop' &&
					($('.popup__win').find('input:focus').length == 0 &&
					$('.popup__win').find('textarea:focus').length == 0 &&
					$('.popup__win').find('select:focus').length == 0 &&
					$('.popup__win').find('[contenteditable]:focus').length == 0 &&
					$('.popup__win').find('input[type="checkbox"]:hover').length == 0)) {
					_popupClose();
				} else if (thisDevice == 'mobile') {
					_popupClose();
				}
			}
		}
	});




	function _popupWait(stat) {
		if (stat != false) {
			_setWaitPos();

			$(ddrPopupSelector).scroll(function() {
				_setWaitPos();
			});

			$(window).resize(function() {
				_setWaitPos();
			});

			$(ddrPopupSelector).find('[ddrpopupwait]').text(stat || '');
			$(ddrPopupSelector).find('.popup__wait').addClass('popup__wait_visible');
		} else if (stat == false) {
			$(ddrPopupSelector).find('.popup__wait.popup__wait_visible').removeClass('popup__wait_visible');
			$(ddrPopupSelector).off('scroll');
		}
	};


	function _setWaitPos() {
		var winTop = $(ddrPopupSelector).scrollTop(),
			winH = $(window).height(),
			ppWinH = $('[ddrpopupwin]').height(),
			trY = 0;
		if (ppWinH > winH) {
			trY = winTop - ((ppWinH / 2) - (winH / 2));
			$('[ddrpopupwaitblock]').css('top', +trY+'px');
		}
	};

	function _popupOpen() {
		disableScroll();
		$(ddrPopupSelector).addClass('popup_opening');
		$(ddrPopupSelector).find('.popup__win').addClass('popup__win_opening');
	};

	function _popupClose() {
		clearTimeout(popupCloseTOut);
		$(document).trigger('ddrpopup:close');
		$(ddrPopupSelector).addClass('popup_closing');
		$(ddrPopupSelector).find('.popup__win').addClass('popup__win_closing');
		popupCloseTOut = setTimeout(function() {
			$(ddrPopupSelector).remove();
			enableScroll();
		}, (animationTime * 1000));
	};

	// Сюда подставить скрипты, которые должны активироваться при загрузке контента
	function _setScripts() {
		//setBaseScripts(ddrPopupSelector);
	};


	function _getWinHeight() {
		return $(ddrPopupSelector).find('.popup__win').outerHeight();
	}


	function _getWinPosition() {
		return $(ddrPopupSelector).scrollTop();
	}



	var obj = {
		wait: function(stat) {
			_popupWait(stat);
		},
		close: function() {
			_popupClose();
		},
		getSelector: function() {
			return ddrPopupSelector;
		},
		setData: function() {
			let a = arguments;
			let url = (typeof a[0] == 'string' ? ((a[0].substr(0, 1) != '/' && a[0].substr(0, 7) != 'http://') ? '/'+a[0] : a[0]) : false);
			if (!url) {
				throw new Error('ddrPopUp setData -> Ошибка! не передан URL');
				return false;
			}

			let string = typeof a[0] == 'string' && a[1] === false ? a[0] : false;
			let params = typeof a[1] == 'object' ? a[1] : false;
			let callback = (!params && typeof a[1] == 'function') ? a[1] : ((a[2] !== undefined && typeof a[2] == 'function') ? a[2] : false);
			let width = (typeof a[1] != 'function' && typeof a[1] != 'object') && /\d+(px|vh|\%)?/.test(a[1]) ? a[1] : ((typeof a[2] != 'function' && typeof a[2] != 'object') && /\d+(px|vh|\%)?/.test(a[2]) ? a[2] : ((typeof a[3] != 'function' && typeof a[3] != 'object') && /\d+(px|vh|\%)?/.test(a[3]) ? a[3] : false));


			if (string) {
				if (width) $(ddrPopupSelector).find('[ddrpopupwin]').width(width);
				$(ddrPopupSelector).find('[ddrpopupcontent]').html(string);
				if (o.disabledButtons) $(ddrPopupSelector).find('.popup__buttons_main').removeAttrib('disabled');

				$('[ddrpopupcontent]').ready(function() {
					if (callback && typeof callback == 'function') callback(obj);
					$(document).trigger('popup:load');
				});
			} else if (url) {
				_popupWait();
				$.post(url, params, function(html) {
					html = html.trim();
					if (width) $(ddrPopupSelector).find('[ddrpopupwin]').width(width);
					$(ddrPopupSelector).find('[ddrpopupcontent]').html(html);
					//if (o.disabledButtons) $(ddrPopupSelector).find('.ddrpopup__buttons_main').removeAttrib('disabled');
					_popupWait(false);
					_setScripts();

					$('[ddrpopupcontent]').ready(function() {
						var stat = !!html
						if (stat && callback && typeof callback == 'function') callback(html, stat);
						else if (callback && typeof callback == 'function') callback('<p class="empty center">'+language[o.lang]['noData']+'</p>', stat);
						$(document).trigger('popup:load');
					});
				}, 'html').fail(function(e) {
					notify(language[o.lang]['systemError'], 'error');
					showError(e);
				});
			}
		},
		setTitle: function(title) {
			var stData = title.split('|'),
				title = stData[0],
				titleSize = stData[1] || '1',
				titleOverflow = (stData[2] == 1) ? ' popup__title_overflow' : '';
			$(ddrPopupSelector).find('[ddrpopuptitle]').replaceWith('<h5 ddrpopuptitle class="popup__title'+titleOverflow+' popup__title_'+titleSize+'">'+title+'</h5>');
		},
		onScroll: function(callback) {
			$(ddrPopupSelector).scroll(function() {
				if (callback && typeof callback == 'function') callback();
				$(document).trigger('popup:scroll');
			});
		},
		deleteTitle: function() {
			$(ddrPopupSelector).find('[ddrpopuptitle]').empty();
		},
		setButtons: function(buttons, close) {
			var buttonsHtml = '';
			
			if (close && o.closePos == 'left') buttonsHtml += '<button class="popup__buttons_close" ddrpopupclose>'+close+'</button>';
			if(buttons) {
				$.each(buttons, function(k, b) {
					buttonsHtml += '<button'+(b.disabled ? ' disabled' : '')+(b.close ? ' ddrpopupclose' : '')+'  id="'+b.id+'"'+(b.metrikaId ? ' onclick="yaCounter'+(b.metrikaId)+'.reachGoal('+'\''+(b.metrikaTargetId)+'\''+'); return true;"' : '')+' class="popup__buttons_'+(b.type ? b.type : 'main')+(b.class ? ' '+b.class+'"' : '"')+'>'+b.title+'</button>';
				});
			}
			if (close && o.closePos == 'right') buttonsHtml += '<button class="popup__buttons_close" ddrpopupclose>'+close+'</button>';
			$(ddrPopupSelector).find('[ddrpopupbuttons]').html(buttonsHtml);
		},
		removeButtons: function() {
			$(ddrPopupSelector).find('[ddrpopupbuttons]').empty();
		},
		disabledButtons: function() {
			$(ddrPopupSelector).find('.ddrpopup__buttons_main').setAttrib('disabled');
		},
		enabledButtons: function() {
			$(ddrPopupSelector).find('[ddrpopupbuttons]').children('[disabled]').removeAttrib('disabled');
		},
		setWidth: function(width) {
			$(ddrPopupSelector).find('[ddrpopupwin]').addClass('popup__win_animated');
			$(ddrPopupSelector).find('[ddrpopupwin]').width(width);
			setTimeout(function() {
				$(ddrPopupSelector).find('[ddrpopupwin].popup__win_animated').removeClass('popup__win_animated');
			}, (animationTime * 1000));
		},
		dialog: function(dialog, yBtn, nBtn, yFunc) {
			if (dialog == false) {
				$(ddrPopupSelector).find('[ddrpopupdialog]').remove();
			} else {
				var id = generateCode('LlnlL'),
					dhtml = '<div class="popup__dialog" ddrpopupdialog>';
					dhtml += 	'<div class="popupdialog">';
					dhtml += 		'<div class="popupdialog__message">'+dialog+'</div>';
					dhtml += 		'<div class="popupdialog__buttons">';
					if (o.closePos == 'left') dhtml += '<button class="cancel" id="popupDialogN'+id+'">'+nBtn+'</button>';
					if (yBtn) dhtml += 			'<button id="popupDialogY'+id+'">'+yBtn+'</button>';
					if (o.closePos == 'right') dhtml += '<button class="cancel" id="popupDialogN'+id+'">'+nBtn+'</button>';
					dhtml += 		'</div>';
					dhtml += 	'</div>';
					dhtml += '</div>';
				$(ddrPopupSelector).find('[ddrpopupwin]').prepend(dhtml);

				var winH = $(window).height(),
					popupH = _getWinHeight(),
					winPos = _getWinPosition(),
					dialogH = $(ddrPopupSelector).find('.popupdialog').outerHeight();

				if (popupH > winH) {
					$(ddrPopupSelector).find('.popupdialog').css('top', 'calc(50vh - '+(dialogH / 2)+'px + '+winPos+'px)');
				} else {
					$(ddrPopupSelector).find('[ddrpopupdialog]').css('align-items', 'center');
				}

				$(ddrPopupSelector).scroll(function() {
					winPos = _getWinPosition();
					$(ddrPopupSelector).find('.popupdialog').css('top', 'calc(50vh - '+(dialogH / 2)+'px + '+winPos+'px)');
				});

				$(ddrPopupSelector).find('[ddrpopupdialog]').addClass('popup__dialog_visible');

				$('#popupDialogN'+id).on(tapEvent, function() {
					$(ddrPopupSelector).find('[ddrpopupdialog]').remove();
				});

				$('#popupDialogY'+id).on(tapEvent, function() {
					if (typeof yFunc == 'function') yFunc();
				});
			}
		},
		correctPosition: function() {
			return true;
		} 
	};



	$(document).trigger('ddrpopup:open');
	if (callback && typeof callback == 'function') {
		callback(obj);
	} else {
		return obj;
	}
};


popUp = function(settings, callback) {
	return new DdrPopUp(settings, callback);
};

$.fn.popUp = function(settings, callback) {
	$(this).on(tapEvent, function() {
		return new DdrPopUp(settings, callback);
	});
};