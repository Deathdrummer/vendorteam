;function Popup(settings, callback) {
	var ops = $.extend({
		title: false,
		width: 500,
		height: false,
		html: '',
		wrapToClose: true,
		buttons: false,
		closeButton: false,
		buttonsOnTop: false,
		winClass: false,
	}, settings);
	
	
	
	var html = '',
		popUpId = 'popup'+random(0, 9999),
		winW,
		winH,
		top,
		domModifedTimeout;
	
	
	if($('.popup').length > 0) $('.popup').remove();
	
	winW = $(window).outerWidth();
	winH = $(window).height();
	
	
	html += '<div class="popup">';
	html +=     '<div id="'+popUpId+'" class="popup__window'+(ops.winClass ? ' '+ops.winClass : '')+'">';
	html +=         '<div class="popup__wait"><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></div>';
	html +=         '<div class="popup__close" close title="Закрыть окно"></div>';       
	if (ops.title) {
	html +=         '<div class="popup__top">';
	html +=             '<h5 class="text-overflow">'+ops.title+'</h5>';
	html +=         '</div>';
	}
	
	if (!ops.buttonsOnTop) html += '<div class="popup__content">'+(ops.html ? ops.html : '')+'</div>';
	
	if(ops.closeButton || ops.buttons) {
	html +=         '<div class="popup__buttons">';
	
	if(ops.closeButton) {
	html +=             '<button close>'+ops.closeButton+'</button>' ;  
	}
	
	if(ops.buttons) {
	$.each(ops.buttons.reverse(), function(k, b) {
	html +=             '<button'+(b.disabled ? ' disabled' : '')+' id="'+b.id+'"'+(b.metrikaId ? ' onclick="yaCounter'+(b.metrikaId)+'.reachGoal('+'\''+(b.metrikaTargetId)+'\''+'); return true;"' : '')+(b.class ? ' class="'+b.class+'"' : '')+'>'+b.title+'</button>';
	});
	}            
	html +=         '</div>';
	}
	
	if (ops.buttonsOnTop) html += '<div class="popup__content">'+(ops.html ? ops.html : '')+'</div>';
	
	html +=     '</div>';
	html += '</div>';
	
	$('body').prepend(html);
	disableScroll();
	
	
	var popupH = ops.height ? ops.height : $('#'+popUpId).outerHeight() + parseInt($('#'+popUpId).css('margin-top')) + parseInt($('#'+popUpId).css('margin-bottom'));
	
	$('#'+popUpId).css({
		'width': typeof ops.width == 'number' ? ((ops.width + 20 > winW) ? 'calc(100% - 20px)' : ops.width+'px') : ops.width,
		'min-height': ops.height ? ops.height+'px' : '100px',
		'left': (ops.width + 20 > winW) ? '10px' : typeof ops.width == 'number' ? (winW / 2) - (ops.width / 2)+'px' : (100 - parseInt(ops.width)) / 2 + '%',
		'top': popupH < winH ? 'calc(50vh - ('+popupH+'px / 2 + 20px))' : 0
	});
	
	$(window).resize(function() {
		winW = $(window).width();
		winH = $(window).height();
		top = 'calc(50vh - ('+popupH+'px / 2 + 20px))';
		
		$('#'+popUpId).css({
			'width': typeof ops.width == 'number' ? ((ops.width + 20 > winW) ? 'calc(100% - 20px)' : ops.width+'px') : ops.width,
			'left': (ops.width + 20 > winW) ? '10px' : typeof ops.width == 'number' ? (winW / 2) - (ops.width / 2)+'px' : (100 - parseInt(ops.width)) / 2 + '%',
			'top': popupH < winH ? (top < 0 ? 0 : top) : 0
		});
	});
	
	
	

	$('#'+popUpId).on('DOMSubtreeModified', function() {
		clearTimeout(domModifedTimeout);
		domModifedTimeout = setTimeout(function() {
			if(popupH && popupH != $('#'+popUpId).outerHeight()) {
				popupH = $('#'+popUpId).outerHeight() + parseInt($('#'+popUpId).css('margin-top')) + parseInt($('#'+popUpId).css('margin-bottom'));
				top = (winH / 2) - (popupH / 2);
				$('#'+popUpId).css({top: popupH < winH ? (top < 0 ? 0 : top) : 0});
				$('#'+popUpId).fadeIn(50);
			}
		}, 20);
	});
	
	$('.popup').addClass('visible');
	
	
	
	
	
	//----------------------------------------------- Закрыть окно
	$('#'+popUpId).on(tapEvent, '[close], .close', function() {
		$('.popup').removeClass('visible');
		setTimeout(function() {
			$('.popup').remove();
			enableScroll();
			$(document).trigger('popup:close');
		}, 100);
	});
	
	if (ops.wrapToClose) {
		$('.popup').on(tapEvent, function(e) {
			if (/\bpopup\b/.test(e.target.className) && $('.popup__wait.visible').length == 0 && $('.popup__window').find('*:focus').length == 0) {
				$('.popup').removeClass('visible');
				setTimeout(function() {
					$('.popup').remove();
					enableScroll();
					$(document).trigger('popup:close');
				}, 100);
			}
		});
	}
	
	
	
	
	
	function _getWinHeight() {
		return $('#'+popUpId).outerHeight();
	}
	
	
	function _getWinPosition() {
		return $('#'+popUpId).parent('.popup').scrollTop();
	}
	
	
	
	
	//----------------------------------------------------
	
	var obj = {
		close: function(callback) {
			$('.popup').removeClass('visible');
			setTimeout(function() {
				$('.popup').remove();
				enableScroll();
				$(document).trigger('popup:close');
				if (callback && typeof callback == 'function') callback();
			}, 100);
		},
		setData: function(html, hideButtons, callback) {
			hideButtons = hideButtons || false;
			$('.popup__content').html(html);
			if (hideButtons) {
				$('.popup__buttons').hide();
			}
			
			$('#'+popUpId).css({'top': popupH < winH ? (top < 0 ? 0 : top) : 0});
			$('.popup__content').ready(function() {
				$(document).trigger('popup:open');
				if (callback && typeof callback == 'function') callback(obj);
			});
		},
		setTitle: function(title) {
			$('.popup__top h5').text(title);
		},
		setButtons: function(btns, close) {
			var btnsHtml = '';
			if(close) btnsHtml += '<button close>'+close+'</button>' ;  
			if (btns) {
				$.each(btns.reverse(), function(k, b) {
					btnsHtml += '<button'+(b.disabled ? ' disabled' : '')+' id="'+b.id+'"'+(b.cls ? ' class="'+b.cls+'"' : '')+(b.metrikaId ? ' onclick="yaCounter'+(b.metrikaId)+'.reachGoal('+'\''+(b.metrikaTargetId)+'\''+'); return true;"' : '')+'>'+b.title+'</button>';
				});
			}
			
			if ($('.popup__buttons').length == 0) {
				$('.popup__content').after('<div class="popup__buttons">'+btnsHtml+'</div>');   
			} else {
				$('.popup__buttons').html(btnsHtml);
			}
		},
		removeButtons: function() {
			if ($('.popup__buttons').length > 0){
				$('.popup__buttons').remove();   
			}
		},
		deleteTitle: function() {
			$('.popup__top').remove();
		},
		correctPosition: function(timeout) {
			var t = timeout || 0;
			setTimeout(function () {
				popupH = $('#'+popUpId).outerHeight();
				top = (winH / 2) - (popupH / 2);
				$('#'+popUpId).css({
					top: popupH < winH ? (top < 0 ? 0 : top) : 0
				});
			}, t);	
		},
		setWidth: function(newWidth, callback) {
			winW = $(window).width();
			winH = $(window).height();
			top = 'calc(50vh - ('+popupH+'px / 2 + 20px))',
			ops.width = newWidth;
			
			$('#'+popUpId).css({
				'width': typeof newWidth == 'number' ? ((newWidth + 20 > winW) ? 'calc(100% - 20px)' : newWidth+'px') : newWidth,
				'left': (newWidth + 20 > winW) ? '10px' : typeof newWidth == 'number' ? (winW / 2) - (newWidth / 2)+'px' : (100 - parseInt(newWidth)) / 2 + '%',
				'top': popupH < winH ? (top < 0 ? 0 : top) : 0
			});
			if (callback) callback();
		},
		wait: function(stat) {
			if (stat != undefined ? stat : true) {
				$('.popup__wait').addClass('visible');
			} else if (stat == false) {
				$('.popup__wait').removeClass('visible');
			}
		},
		dialog: function(dialog, yBtn, nBtn, yFunc) {
			if (dialog == false) {
				$('#'+popUpId).find('.popup__dialog').remove();
			} else {
				var dhtml = '<div class="popup__dialog">';
					dhtml += 	'<div class="popupdialog">';
					dhtml += 		'<div class="message">'+dialog+'</div>';
					dhtml += 		'<div class="buttons">';
					dhtml += 			'<button class="cancel" id="popupDialogN'+popUpId+'">'+nBtn+'</button>';
					dhtml += 			'<button id="popupDialogY'+popUpId+'">'+yBtn+'</button>';
					dhtml += 		'</div>';
					dhtml += 	'</div>';
					dhtml += '</div>';
				$('.popup__window').prepend(dhtml);
				
				
				
				var winH = $(window).height(),
					popupH = _getWinHeight(),
					winPos = _getWinPosition(),
					dialogH = $('#'+popUpId).find('.popupdialog').outerHeight();
				
				if (popupH > winH) {
					$('#'+popUpId).find('.popupdialog').css('top', 'calc(50vh - '+(dialogH / 2)+'px + '+winPos+'px)');
				} else {
					$('#'+popUpId).find('.popup__dialog').css('align-items', 'center');
				}
				
				$('#'+popUpId).parent('.popup').scroll(function() {
					winPos = _getWinPosition();
					$('#'+popUpId).find('.popupdialog').css('top', 'calc(50vh - '+(dialogH / 2)+'px + '+winPos+'px)');
				});
				
				
				
				$('#popupDialogN'+popUpId).on(tapEvent, function() {
					$('#'+popUpId).find('.popup__dialog').remove();
				});
				
				$('#popupDialogY'+popUpId).on(tapEvent, function() {
					if (typeof yFunc == 'function') yFunc();
				});
			}
		},
	};
	
	
	
	var popUpImg = $('.popup__content').find('img');
	$(popUpImg).each(function() {
		var i = new Image(),
			imageSrc = $(this).attr('src');
		i.onload = function() {
			popupH = $('#'+popUpId).outerHeight();
			winH = $(window).height();
			top = 'calc(50vh - ('+popupH+'px / 2 + 20px))';
			
			$('#'+popUpId).css({
				'top': popupH < winH ? (top < 0 ? 0 : top) : 0
			});
		}
		i.src = imageSrc;
	});
	
	
	
	if (callback && typeof callback == 'function') {
		$(document).trigger('popup:open');
		callback(obj);
	}
};


popUp = function(settings, callback) {
	return new Popup(settings, callback);
}