jQuery(document).ready(function($) {
	
	// -------------------------------------------------------------------- Файлменеджер
	clientFileManager();
	
	// -------------------------------------------------------------------- Фокус при наведении
	$('body').on('focus', 'input, textarea, select', function() {
		$(this).parent('div').addClass('focused');
	});
	
	$('body').on('blur', 'input, textarea, select', function() {
		$(this).parent('div').removeClass('focused');
	});
	
	
	
	//---------------------------------------- Высота блоков КО
	var winH = $(window).height(),
		blocksH = $('#operatorTopBlock').outerHeight() + $('#operatorBottomBlock').outerHeight(),
		blockHeight = 200,
		resizeNavTOut;
	
	if (winH + blockHeight > blocksH) {
		$('#operatorNavBlock').css('max-height', (winH - blocksH < blockHeight ? blockHeight : winH - blocksH) + 'px');
	}
	
	$(window).resize(function() {
		winH = $(window).height();
		clearTimeout(resizeNavTOut);
		resizeNavTOut = setTimeout(function() {
			if (winH + blockHeight > blocksH) {
				$('#operatorNavBlock').css('max-height', (winH - blocksH < blockHeight ? blockHeight : winH - blocksH) + 'px');
			}
		}, 50);
	});
	
	
	
	
	
	//----------------------------------------------------------------------------------- Изменить данные аккаунта
	function setOperatorData(a, n, t) {
		var avatar = a || false,
			nickname = n || false;
			
		popUp({
			title: t || 'Заполнить данные',
		    width: 500,
		    buttons: [{id: 'setOperatorData', title: 'Готово'}],
		}, function(operatorDataWin) {
			operatorDataWin.wait();
			
			getAjaxHtml('operator/get_operator_data', function(html) {
				operatorDataWin.setData(html, false);
				
				
				$('#operatorFormAvatar').chooseInputFile(function(data, thisItem) {
					$('#operatorAvatarImg').attr('src', data.src);
					$('#operatorFilename').text(data.name);
				});
				
				$('#setOperatorData').on(tapEvent, function() {
					var operatorFormData = new FormData($('#operatorDataForm')[0]);
    				operatorDataWin.wait();
					var formStat = true;
					
					if ($('#operatorNick').val() == '') {
						$('#operatorNick').addClass('error');
						formStat = false;
					}
					
					if ($('#operatorAvatarImg').attr('src').substr(-8, 4) == 'none') {
						$('[for="operatorFormAvatar"]').addClass('error');
						formStat = false;
					}
    				
    				if (formStat) {
    					$.ajax({
							type: 'POST',
							url: '/operator/set_operator_data',
							dataType: 'json',
							cache: false,
							contentType: false,
							processData: false,
							data: operatorFormData,
							success: function(response) {
								if (response.error) {
									notify(response.error, 'error');
								} else {
									if (response.avatar) {
										$('[operatoravatarimg]').attr('src', response.avatar+'?'+ new Date().getTime());
									} 
									if (response.nickname) $('[operatornickname]').text(response.nickname);
									notify('Настройки сохранены!');
									operatorDataWin.close();
								}
							},
							error: function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							},
							complete: function() {
								operatorDataWin.wait(false);
							}
						});
    				} else {
    					operatorDataWin.wait(false);
    				}
				});	
				
				
			}, function() {
				operatorDataWin.wait(false);
			});
		});
	}
	
	
	
	//-------------------- Если не заполнены данные кабинета оператора
	if (location.pathname.replace('/', '') == 'operator' && $('[operatoravatarimg]').length > 0 && $('[operatoravatarimg]').attr('src').substr(-8, 4) == 'user') {
		var nickName = $('#operatorNickname').val() || null;
		
	}
	
	if ($('#operatorNickname').val() == '') {
		setOperatorData(null, '');
	}
	
	//-------------------- Изменить данные аккаунта, кликнув на аватар или никнейм
	$('#changeAvatar, #changeNickname').on(tapEvent, function() {
		var avatar = $('#changeAvatar').siblings('img').attr('src'),
			nickname = $('#operatorNickname').text();
		setOperatorData(avatar, nickname, 'Изменить данные');
	});
	
	
	
	//----------------------------------------------------------------------------------- Выход из личного кабинета
	$('[operatorlogout]').on(tapEvent, function() {
		popUp({
			title: 'Выход из кабинета оператора',
		    width: 400,
		    html: '<p>Вы действительно хотите выйти?</p>',
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'logoutCancel', title: 'Отмена', class: 'close'}, {id: 'logoutConfirm', title: 'Выйти'}],
		}, function(logoutWin) {
			$('#logoutConfirm').on(tapEvent, function() {
				location = '/operator/logout';
			});
			$('#logoutCancel').on(tapEvent, function() {
				logoutWin.close();
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	contentWait = function(stat) {
		if (stat != undefined && stat == false) {
			if ($('#sectionButtons').length > 0) {
				$('#sectionButtons').find('button.disabled').removeAttrib('disabled');
				$('#sectionButtons').find('button.disabled').removeClass('disabled');
			}
			$('#sectionContent').removeClass('section__content_wait');
		} else {
			if ($('#sectionButtons').length > 0) {
				$('#sectionButtons').find('button:not(:disabled)').addClass('disabled');
				$('#sectionButtons').find('button.disabled').setAttrib('disabled');
			}
			$('#sectionContent').addClass('section__content_wait');
		}
	};
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------- Вывести контент на страницу
	setContentData = function(url, params) {
		params = params || {};
		var hashData = location.hash.split('.');
		
		$('#contentblockWaitBlock').addClass('wait_visible');
		$('#operatorContent').html('');
		
		$('[operatorSections]').find('li').removeClass('active');
		$('[operatorSections]').find('li[url='+url+']').addClass('active');
		
		$.post('/operator/render/'+url, params, function(html) {
			$('#operatorContent').html(html);
			
			//------------------------- Активировать табы, если нет ни одного активного пункта
			if (hashData[1] != undefined) {
				$('#'+url+'Section').find('.tabstitles:not(.sub) li').removeClass('active');
				$('#'+url+'Section').find('.tabstitles:not(.sub) li#'+hashData[1]).addClass('active');
				
				$('#'+url+'Section').find('.tabstitles:not(.sub)').siblings('.tabscontent').find('[tabid]').removeClass('visible');
				$('#'+url+'Section').find('.tabstitles:not(.sub)').siblings('.tabscontent').find('[tabid="'+hashData[1]+'"]').addClass('visible');
			} else {
				$('#'+url+'Section').find('.tabstitles:not(.sub) li:first').addClass('active');
				$('#'+url+'Section').find('.tabstitles:not(.sub)').siblings('.tabscontent').find('[tabid]:first').addClass('visible');
			}
			
			
			if (hashData[2] != undefined) {
				if ($('#'+url+'Section').find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').length > 0) {
					$('#'+url+'Section').find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').each(function() {
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
				if ($('#'+url+'Section').find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').length > 0) {
					$('#'+url+'Section').find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').each(function() {
						$(this).children('li').removeClass('active');
						$(this).children('li:first').addClass('active');
						
						$(this).siblings('.tabscontent').find('[tabid]').removeClass('visible');
						$(this).siblings('.tabscontent').find('[tabid]:first').addClass('visible');
					});
				}	
			}
		}, 'html').done(function() {
			$('#contentblockWaitBlock').removeClass('wait_visible');
			
			
			//-------------------------------------------------------- Высота блока контента
			var sectionTop = $('#sectionContent').offset().top,
				resizeTOut;
			$('#sectionContent').children('div').css('height', (winH - sectionTop - 35)+'px');
	
			$(window).resize(function() {
				winH = $(window).height(),
				sectionTop = $('#sectionContent').offset().top;
				clearTimeout(resizeTOut);
				resizeTOut = setTimeout(function() {
					$('#sectionContent').children('div').css('height', (winH - sectionTop - 35)+'px');
				}, 50);
			});
			
			//------------------------- Прикрепить визуальный редактор
			if ($('#operatorContent').find('.editor').length > 0) {
				initEditors();
			}
			
			//location.hash = hashData[0];
		}).fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	} 
	
	
	
	
	
	//-------------------- Первоначальная загрузка контента по хэшу
	if (location.hash != '') {
		var hashData = location.hash.substr(1, location.hash.length).split('.');
		
		if (hashData[0]) setContentData(hashData[0]);
	} else {
		setContentData('main');
	}
	
	
	
	//-------------------- Пункты меню
	$('[operatorSections]').find('li').on(tapEvent, function() {
		var thisUrl = $(this).attr('url');
		if (thisUrl && thisUrl != location.hash.substr(1, location.hash.length)) {
			location.hash = thisUrl;
			setTimeout(function() {
				setContentData(thisUrl);
			}, 30);
		}
	});
	
	
	
	
	renderContentData = function() {
		let hashData = location.hash.split('.');
		setContentData(hashData[0].substr(1, hashData[0].length));
	}
	
	
	
	
	
});