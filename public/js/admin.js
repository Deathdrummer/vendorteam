jQuery(document).ready(function($) {
	
	
	// -------------------------------------------------------------------- Файлменеджер
	clientFileManager();
	
	
	// -------------------------------------------------------------------- Меню
	var hideNavTOut;
	$('nav.main_nav').on('mouseenter', function() {
		clearTimeout(hideNavTOut);
	});
	
	$('nav.main_nav, #openNav').on('mouseleave', function() {
		hideNavTOut = setTimeout(function() {
			if ($('#openNav').is(':hover') == false) {
				$('i[touch]').prop('aria-expanded', 'false');
				$('.header__item.opened').removeClass('opened');
			}
		}, 300);
	});
	
	$('nav.main_nav li').on(tapEvent, function() {
		if ($(this).hasClass('active') == false) {
			var thisSection = $(this).data('block');
			$('nav.main_nav').find('li').removeClass('active');
			$(this).addClass('active');
			
			location.hash = '#'+thisSection;
			$(window).one('hashchange', function() {
				renderSection();
			});
			
			$('i[touch]').prop('aria-expanded', 'false');
			$('.header__item.opened').removeClass('opened');
		}
	});
	
	
	
	
	
	
	// -------------------------------------------------------------------- Загрузка блоков
	// - параметры 
	// - callback 
	renderSection = function() {
		$('#sectionWait').addClass('visible');
		
		var params = {},
			callback = false,
			hashData = location.hash.substr(1, location.hash.length).split('.'),
			section = hashData[0];
		
		if (arguments.length == 2) {
			params = arguments[0] || {},
			callback = typeof arguments[1] == 'function' ? arguments[1] : false;
		} else if (arguments.length == 1) {
			params = typeof arguments[0] == 'object' ? arguments[0] : {};
			callback = typeof arguments[0] == 'function' ? arguments[0] : false;
		}
		
		
		$.post('/admin/get_sections_data', {section: section, params: params}, function(html) {
			$('#section').html(html);
			
			//------------------------- Активировать табы, если нет ни одного активного пункта
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
			
			
			//------------------------- Прикрепить визуальный редактор
			if ($('.tabscontent').length > 0) {
				initEditors($('.tabscontent').find('[tabid]:visible').find('[editor]'));
			} else {
				initEditors($('#section').find('[editor]'));
			}
			
			onChangeTabs(function(titles, content) {
				initEditors($(content).find('[editor]'));
			});
			
			$('.scroll').ddrScrollTable();
			
			$('#sectionWait').removeClass('visible');
			$(document).trigger('renderSection');
			if (callback) callback();
		}, 'html').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	};
	
	
	
	
	// -------------------------------------------------------------------- Автозагрузка section при загрузке страницы и установка tabs 
	if ($('.auth_form').length == 0) {
		if (location.hash == '') {
			location.hash = '#common';
			$(window).one('hashchange', function() {
				renderSection();
			});
			$('li[data-block="common"]').addClass('active');
		} else {
			var hashData = location.hash.substr(1, location.hash.length).split('.'),
				section = hashData[0];
			$('li[data-block="'+section+'"]').addClass('active');
			renderSection();
		}
	}
		
	
	
	
	

		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// -------------------------------------------------------------------- Фокус при наведении
	$('body').on('focus', 'input, textarea, select', function() {
		$(this).parent('div').addClass('focused');
	});
	
	$('body').on('blur', 'input, textarea, select', function() {
		$(this).parent('div').removeClass('focused');
	});
	
	
	
	
	
	
	  	
	
	
	// -------------------------------------------------------------------- Перейти на сайт
	$('#goToSite').on('click', function() {
		var fullPath = location.protocol+'//'+location.host+location.pathname;
		window.open(fullPath.substr(0, fullPath.length - 6));
	});
	
	
	
	// -------------------------------------------------------------------- Выход из админки
	$('#adminLogout').on(tapEvent, function() {
		location = 'admin/logout';
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// -------------------------------------------------------------------- Предпросмотр картинки [type=file] и добавление input[type=hidden]
	/*$('#section').on('change', 'input[type="file"]', function() {
		var thisInp = this,
			thisInpName = $(thisInp).attr('name'),
			thisInpPath = $(thisInp).attr('path') != '' ? $(thisInp).attr('path')+'/' : '';
		
		if (thisInp.files && thisInp.files[0]) {
	        var reader = new FileReader();
	        reader.onload = function (e) {
	        	if (e.target.result.split('/')[0] == 'data:image') {
	        		$(thisInp).siblings('div').find('img').attr('src', e.target.result);
	        	} else if (e.target.result.split('/')[0] == 'data:video') {
	        		$(thisInp).siblings('div').find('img').attr('src', 'assets/images/video.png');
	        	}
	        	
	            $(thisInp).siblings('div').find('span.image_name').text(thisInp.files[0].name);
	        };
	        reader.readAsDataURL(thisInp.files[0]);
	        if($(thisInp).find('input[type="hidden"]').length > 0) {
	        	$(thisInp).find('input[type="hidden"]').attr('name', thisInpName+'[path]').val(thisInpPath);
	        } else {
	        	$(thisInp).after('<input type="hidden" name="'+thisInpName+'[path]" value="'+thisInpPath+'">');
	        }
	    }
	});*/
	
	
});