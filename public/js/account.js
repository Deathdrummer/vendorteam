$(document).ready(function() {
	
	$('.scroll').ddrScrollTable();
	$(document).on('popup:open', function() {
		$('.scroll').ddrScrollTable();
	});
	

	addComplaintsItem = function(response) {
		
		delete response['from'];
		delete response['template'];
		delete response['title'];
		delete response['to'];
		delete response['site_protocol'];
		delete response['site_url'];
		
		response['stat'] = 0;
		response['date'] = Date.now();
		
		
		$.post('/admin/add_complaints_item', response).fail(function(e) {
			console.log(e.responseText);
		}).fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	}
	
	
	
	
	
	$(document).on('ddrpopup:close', function() {
		location.hash = '';
	});
	
	
	
	
	
	//---------------------------------------- регистрация и авторизация в ЛК
	$('#account').on(tapEvent, function() {
		popUp({
			title: 'Войти в Личный кабинет',
			width: 460,
			wrapToClose: true,
			winClass: 'account',
			buttons: [
				{id: 'resetPass', title: 'Сбросить пароль', class: 'link'},
				{id: 'toReg', title: 'Регистрация', class: 'link'},
				{id: 'getAuth', title: 'Войти'}
			],
		}, function(accountWin) {
			accountWin.wait();
			
			getAjaxHtml('main/auth', {template: 1}, function(html) {
				accountWin.setData(html, false);
				
				//---------------------------------------- Авторизация
				$('#getAuth').on(tapEvent, function() {
					var authEmail = $('#authEmail').val(),
						authPassword = $('#authPassword').val();
					
					if (authEmail == '') {
						$('#authEmail').addClass('error');
						notify('Ошибка! Введите логин!', 'error');
					}
					
					if (authPassword == '') {
						$('#authPassword').addClass('error');
						notify('Ошибка! Введите пароль!', 'error');
					}
					
					if (authEmail != '' && authPassword != '') {
						$.post('/main/auth', {email: authEmail, password: authPassword}, function(response) {
							
							if (response == 0) {
								$('#authEmail, #authPassword').addClass('error');
								notify('Ошибка! Введены неверные данные!', 'error');
							} else if (response == 1) {
								location = '/account';
							} else if (response == 2) {
								$('#authEmail, #authPassword').addClass('error');
								notify('Ошибка! Доступ ограничен!', 'error');
							}
						}, 'json').fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
						});
					}	
				});
				
				
				//---------------------------------------- Регистрация
				$('#toReg').on(tapEvent, function() {
					accountWin.wait();
					getAjaxHtml('main/reg', {template: 1}, function(html) {
						accountWin.setTitle('Регистрация');
						accountWin.setData(html, false);
						accountWin.setButtons([{id: 'getReg', title: 'Зарегистрироваться'}]);
						
						
						$('#getReg').on(tapEvent, function() {
							accountWin.wait();
							var regEmail = $('#regEmail').val()
								password = generateCode('LlnnlLn');
							
							if (regEmail != '') {
								$.post('/main/reg', {email: regEmail, password: password}, function(response) {
									if (response == 0) {
										$('#regEmail').addClass('error');
										notify('Ошибка! Необходимо ввести E-mail!', 'error');
									} else if (response == 1) {
										$('#regEmail').addClass('error');
										notify('Ошибка! Введен некорректный E-mail!', 'error');
									} else if (response == 2) {
										$('#regEmail').addClass('error');
										notify('Ошибка! такой E-mail уже зарегистрирован!', 'error');
									} else if (response == 3) {
										notify('E-mail успешно зарегистрирован');
										accountWin.setData('<p class="center">Ваш аккаунт успешно зарегистрирован</p><p class="center">Письмо с регистрационными данными отправлено на ваш E-mail адрес</p>', false);
										accountWin.removeButtons();
									}
								}, 'json').done(function() {
									accountWin.wait(false);
								}).fail(function(e) {
									showError(e);
									notify('Системная ошибка!', 'error');
								});
							} else {
								$('#regEmail').addClass('error');
								notify('Ошибка! Необходимо заполнить поле!', 'error');
								accountWin.wait(false);
							}
							
						});
						
					}, function() {
						accountWin.wait(false);
					});
				});
				
				
				//---------------------------------------- Сбросить пароль
				$('#resetPass').on(tapEvent, function() {
					var authEmail = $('#authEmail').val(),
						newPass = generateCode('LlnnlLn');
					
					if (authEmail == '') {
						$('#authEmail').addClass('error');
						notify('Ошибка! Необходимо ввести Ваш E-mail!', 'error');
					} else {
						accountWin.wait();
						$.post('/main/reset_pass', {email: authEmail, new_password: newPass}, function(response) {
							if (response == 0) {
								$('#authEmail').addClass('error');
								notify('Ошибка! Необходимо ввести Ваш E-mail!', 'error');
							} else if (response == 1) {
								$('#authEmail').addClass('error');
								notify('Ошибка! Введен некорректный E-mail!', 'error');
							} else if (response == 2) {
								$('#authEmail').addClass('error');
								notify('Ошибка! Такого E-mail нет в базе!', 'error');
							} else if (response == 3) {
								notify('Ваш пароль успешно сброшен и передан на Ваш E-mail!');
							}
						}, 'json').done(function() {
							accountWin.wait(false);
						}).fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
						});
					}	
				});
				
			}, function() {
				accountWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------- Выход из личного кабинета
	$('[logout]').on(tapEvent, function() {
		popUp({
			title: 'Выход из личного кабинета',
			width: 400,
			html: 'Вы действительно хотите выйти?',
			buttons: [{id: 'logoutCancel', title: 'Отмена', class: 'close'}, {id: 'logoutConfirm', title: 'Выйти'}],
		}, function(logoutWin) {
			$('#logoutConfirm').on(tapEvent, function() {
				location = '/account/logout';
			});
			$('#logoutCancel').on(tapEvent, function() {
				logoutWin.close();
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------- Уволиться
	$('[resign]').on(tapEvent, function() {
		let resignBtn = this;
		
		popUp({
			title: 'Заявка на увольнение',
			width: 600,
			buttons: [{id: 'setResign', title: 'Отправить заявку'}],
			closeButton: 'Отмена'
		}, function(resignWin) {
			resignWin.wait();
			getAjaxHtml('account/resign/get_form', function(html) {
				resignWin.setData(html, false);
				
				var d = new Date();
	
				$('#chooseResignDate').datepicker({
					dateFormat:         'd M yy г.',
					//yearRange:          "2020:"+(new Date().getFullYear() + 1),
					numberOfMonths:     1,
					changeMonth:        true,
					changeYear:         true,
					monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
					monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
					dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
					firstDay:           1,
					minDate:            d,
					//maxDate:          	'+1m',
					
					onSelect: function(stringDate, dateObj) {
						$.post('account/resign/calc_enddate', {date: dateObj.currentDay+'-'+(dateObj.currentMonth+1)+'-'+dateObj.currentYear}, function(date) {
							$('#resignCurrentDate').val(date.current_date);
							$('#resignLastday').text(date.last_date_format);
							$('#resignLastDate').val(date.last_date);
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					} 
				});
				
				
				$('#setResign').on(tapEvent, function() {
					var resignDate = $('#resignCurrentDate'),
						lastDate = $('#resignLastDate'),
						reason = $('#resignReason'),
						comment = $('#resignComment'),
						stat = true;
						
					if (!reason.val()) {
						$(reason).addClass('error');
						stat = false;
					}
					
					if (!comment.val()) {
						$(comment).addClass('error');
						stat = false;
					}

					
					if (stat) {
						resignWin.wait();
						$.post('account/resign/set_resign', {date_resign: resignDate.val(), date_last: lastDate.val(), reason: reason.val(), comment: comment.val()}, function(response) {
							if (response) {
								notify('Заявка успешно отправлена!');
								$(resignBtn).remove();
								resignWin.close();
							} else {
								resignWin.wait(false);
								notify('Ошибка отправки заявки!', 'error');
							}
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					} else {
						notify('Необходимо заполнить все поля!', 'error');
					}
				});
				
				
				
				
			}, function() {
				resignWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------- Изменить данные аккаунта
	function setUserData(t) {
		var title = t || 'Заполнить данные';
		
		popUp({
			title: title,
			width: 500,
			winClass: 'account',
			buttons: [{id: 'setUserData', title: 'Готово'}],
		}, function(userDataWin) {
			userDataWin.wait();
			var isLider = $('#isLider').val() == 1 ? 1 : 0;
			getAjaxHtml('account/get_account_data', {lider: isLider}, function(html) {
				userDataWin.setData(html, false);
				
				$('#updateUserAvatar').chooseInputFile(function(data, thisItem) {
					$('#userAvatarImg').attr('src', data.src);
					$('#userFilename').text(data.name);
				});
				
				
				//---------------- Цвет участника
				var colorTooltip = new jBox('Tooltip', {
					attach: '#chooseColor',
					trigger: 'click',
					closeOnMouseleave: true,
					closeOnClick: 'body',
					addClass: 'raiderscolorswrap',
					outside: 'x',
					ignoreDelay: true,
					zIndex: 1200,
					//pointer: 'left',
					//pointTo: 'left',
					position: {
					  x: 'right',
					  y: 'center'
					},
					content: '<i class="fa fa-bars"></i>'
				});
					
				getAjaxHtml('account/get_raiders_colors', {attr: 'chooseusercolor'}, function(html) {
					colorTooltip.setContent(html);
					
					//--------------------------------------------------- Задать цвет себе
					$('[chooseusercolor]').on(tapEvent, function() {
						var color = $(this).attr('chooseusercolor');
						$('#userDataForm').find('[name="user_color"]').val(color);
						$('#chooseColor').css('background-color', color);
						colorTooltip.close();
					});
				});	
				
				$('.popup').scroll(function() {
					colorTooltip.close();
				});
				
				
				
				
				
				
				$('#setUserData').on(tapEvent, function() {
					userDataWin.wait();
					var formStat = true;
					
					if ($('#updateUserNick').val() == '') {
						$('#updateUserNick').addClass('error');
						formStat = false;
					}
					
					if ($('#userAvatarImg').attr('src').substr(-8, 4) == 'none') {
						$('[for="updateUserAvatar"]').addClass('error');
						formStat = false;
					}
					
					
					if (formStat) {
						$.ajax({
							type: 'POST',
							url: '/account/update_account_data',
							dataType: 'json',
							cache: false,
							contentType: false,
							processData: false,
							data: new FormData($('#userDataForm')[0]),
							success: function(response) {
								if (response.error) {
									notify(response.error, 'error');
								} else {
									if (response.avatar) $('[useravatarimg]').attr('src', response.avatar+'?'+ new Date().getTime());
									if (response.nickname) $('[accountnickname]').text(response.nickname);
									if (response.color) $('#chooseColor').css('background-color', response.color);
									
									notify('Настройки сохранены!');
									userDataWin.close(function() {
										if ($('#agreementStat').val() == 1) getAgrement();
									});
								}
							},
							error: function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							},
							complete: function() {
								userDataWin.wait(false);
							}
						});
					} else {
						userDataWin.wait(false);
					}
				});
				
			}, function() {
				userDataWin.wait(false);
			});
			
		});
	}
	
	
	
	//-------------------- Если не заполнены данные аккаунта
	if (location.pathname.replace('/', '') == 'account') {
		if ($('#isUserData').val() == 0) setUserData();
	}
	
	//-------------------- Изменить данные аккаунта, кликнув на аватар или никнейм
	$('#changeAvatar, #changeNickname').on(tapEvent, function() {
		setUserData('Изменить данные');
	});
	
	
	
	
	
	
	
	//---------------------------------------- Высота блоков старт
	var startBgTop, startBgBottom, startBgResizeTOut;
	$('.start__bg').find('img').load(function() {
		startBgTop = Math.ceil($('#startBgTop').outerHeight()),
		startBgBottom = Math.ceil($('#startBgBottom').outerHeight());
		$('#startContent').css('min-height', (startBgTop + startBgBottom) + 'px');
	});
		
	
	$(window).resize(function() {
		clearTimeout(startBgResizeTOut);
		startBgResizeTOut = setTimeout(function() {
			startBgTop = Math.ceil($('#startBgTop').outerHeight()),
			startBgBottom = Math.ceil($('#startBgBottom').outerHeight());
			$('#startContent').css('min-height', (startBgTop + startBgBottom) + 'px');
		}, 50);
	});
	
	
	
	
	
	
	
	//---------------------------------------- Высота блоков ЛК
	var winH = $(window).height(),
		blocksH = $('#accountTopBlock').outerHeight() + $('#accountBottomBlock').outerHeight(),
		blockHeight = 200,
		resizeTOut;
	
	if (winH + blockHeight > blocksH) {
		$('#accountNavBlock').css('max-height', (winH - blocksH < blockHeight ? blockHeight : winH - blocksH) + 'px');
	}
	
	$(window).resize(function() {
		winH = $(window).height();
		clearTimeout(resizeTOut);
		resizeTOut = setTimeout(function() {
			if (winH + blockHeight > blocksH) {
				$('#accountNavBlock').css('max-height', (winH - blocksH < blockHeight ? blockHeight : winH - blocksH) + 'px');
			}
		}, 50);
	});
	
	
	$('[staticusers]').each(function() {
		let thisUsersBlock = this,
			isLider = $(thisUsersBlock).attr('staticusers') == 1 ? true : false;
		if (isLider) {
			$(thisUsersBlock).css('max-height', 'calc(100vh - 289px)');
		} else {
			$(thisUsersBlock).css('max-height', 'calc(100vh - 252px)');
		}
	});
	
	
	
	
	//---------------------------------------- Статики карусель
	var resizeTOut;
	function initArrows() {
		var allSlides = $('#accountStatics').find('.slick-slide').length,
			visibleSlides = $('#accountStatics').find('.slick-slide.slick-active').length;
		
		if (visibleSlides < allSlides) {
			$('.staticsblock__arrow').addClass('staticsblock__arrow_visible');
			$('.staticsblock').addClass('staticsblock__rows');
		} else {
			$('.staticsblock__arrow').removeClass('staticsblock__arrow_visible');
			$('.staticsblock').removeClass('staticsblock__rows');
		}
	}
	
	
	$('#accountStatics').on('init', function(slick) {
		$('.staticsblock').addClass('staticsblock__visible');
		initArrows();
		$(window).resize(function() {
			clearTimeout(resizeTOut);
			resizeTOut = setTimeout(function() {
				initArrows();
			}, 50);
		});
	});
	
	
	$('#accountStatics').slick({
		infinite: false,
		dots: false,
		autoplay: false,
		autoplaySpeed: 3000,
		pauseOnHover: true,
		fade: false,
		speed: 200,
		draggable: true,
		//swipeToSlide: true,
		arrows: false,
		mobileFirst: true,
		slidesToScroll: 1,
		slidesToShow: 1,
		responsive: [
			{breakpoint: 450, settings: {slidesToShow: 2}},
			{breakpoint: 576, settings: {slidesToShow: 2}},
			{breakpoint: 768, settings: {slidesToShow: 2}},
			{breakpoint: 992, settings: {slidesToShow: 3}},
			{breakpoint: 1590, settings: {slidesToShow: 5}}
		]
	});
	
	
	
	
	$('#primarySlidesnav').find('li:first').addClass('active');
	
	$('#primarySlidesnav').find('li').on(tapEvent, function() {
		var thisIndex = $(this).index();
		console.log(thisIndex);
		$('#accountStatics').slick('slickGoTo', thisIndex);
	});
	
	$('#staticsPrev').on(tapEvent, function() {
		$('#accountStatics').slick('slickPrev');
	});
	
	$('#staticsNext').on(tapEvent, function() {
		$('#accountStatics').slick('slickNext');
	});
	
	$('#accountStatics').on('beforeChange', function(event, slick, currentSlide, nextSlide) {
		$('#primarySlidesnav').find('li').removeClass('active');
		$('#primarySlidesnav').find('li').eq(nextSlide).addClass('active');
	});
	
	
	
	
	
	
	//---------------------------------------- Статики контент
	$('.staticscontent:first-of-type').css('display', 'block');
	
	$('[accountstatic]').on(tapEvent, function() {
		var thisStaticId = $(this).attr('accountstatic');
		$('[accountstatic]').removeClass('active');
		$(this).addClass('active');
		$('[staticscontent]').removeClass('staticscontent_visible');
		$('[staticscontent="'+thisStaticId+'"]').addClass('staticscontent_visible');
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Операторы
	$('[operators]').on(tapEvent, function() {
		popUp({
			title: 'Операторы',
			width: 1300
		}, function(operatorsWin) {
			operatorsWin.wait();
			getAjaxHtml('account/get_operators', function(html) {
				operatorsWin.setData(html, false);
				
				$('[operatorsendmess], [operatorsendcomplain]').on(tapEvent, function(e) {
					operatorsWin.wait();
					var thisAttr = $(this).attr('operatorsendmess') || $(this).attr('operatorsendcomplain'),
						data = thisAttr.split('|'),
						operatorId = data[0],
						operatorNickname = data[1],
						type = data[2], // mess complain
						title,
						button;
					
					if (type == 'mess') {
						title = 'Новое сообщение';
						button = 'Отправить сообщение';
					} 
					else if (type == 'complain') {
						title = 'Новая жалоба';
						button = 'Отправить жалобу';
					} 
					
					getAjaxHtml('account/operator_new_mess', {
						type: type,
						id: operatorId, 
						nickname: operatorNickname
					}, function(html) {
						operatorsWin.setData(html, false);
						operatorsWin.setWidth(500);
						operatorsWin.setTitle(title);
						operatorsWin.setButtons([{id: 'sendMessToOperator', title: button}]);
												
						$('#sendMessToOperator').on(tapEvent, function() {
							var message = $('#messToOperator').val();
							if (message == '') {
								$('#messToOperator').addClass('error');
								notify('Ошибка! Сообщение не может быть пустым!', 'error');
							} else {
								operatorsWin.wait();
								$.post('/account/operator_send_mess', {
									type: type,
									message: message,
									to: operatorId
								}, function(response) {
									if (response) {
										operatorsWin.wait(false);
										operatorsWin.close();
										if (type == 'mess') notify('Сообщение успешно отправлено!');
										else if (type == 'complain') notify('Жалоба успешно отправлена!');
									}
								}).fail(function(e) {
									notify('Системная ошибка!', 'error');
									showError(e);
								});
							}	
						});
						
					}, function() {
						operatorsWin.wait(false);
					});
					
				});
				
			}, function() {
				operatorsWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Статики отправить сообщение
	$('#staticSendMessage').on(tapEvent, function() {
		console.log('fh fh');
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Договор
	if ($('#agreementStat').val() == 1 && $('#isUserData').val() != 0) {
		showAgreement();
	}
	
	var agrementWin;
	function showAgreement() {
		popUp({
			title: 'Договор',
			width: 1300,
			html: '<div id="agreementBlock"></div>',
			wrapToClose: false,
			winClass: 'account',
			closeButton: 'Закрыть',
		}, function(agrWin) {
			agrementWin = agrWin;
			agrementWin.wait();
			
			var d1 = $.Deferred(), d2 = $.Deferred();
			
			$.post('/account/get_agreement_data', function(html) {
				d1.resolve(html);
			}, 'html');
			
			$.post('/account/get_agreement_stat', function(stat) {
				d2.resolve(stat);
			}, 'json');
			
			$.when(d1, d2).then(function(agreementHtml, stat) {
				$('#agreementBlock').html(agreementHtml);
				if (stat == 0) agrementWin.setButtons([{id: 'agreementSuccess', title: 'Согласен(на)'}]);
				agrementWin.wait(false);
			}).fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
				agrementWin.wait(false);
			});
		});
	}
	
	$('body').off(tapEvent, '#agreementSuccess').on(tapEvent, '#agreementSuccess', function() {
		$.post('/account/set_agreement_stat', {stat: 1}, function(response) {
			if (response) {
				notify('Соглашение принято!');
				$('#agreementSuccess').prop('disabled', true);
				$('#agreementStat').val(1);
				agrementWin.close();
			}
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Важная (полезня) информация
	$('[importantinfo]').on(tapEvent, function() {
		popUp({
			title: 'Важная информация',
			width: 1300,
			height: false,
			html: '<div id="infoBlock"></div>',
			wrapToClose: true,
			winClass: 'account',
			buttons: false,
			closeButton: false,
		}, function(infoWin) {
			infoWin.wait();
			getAjaxHtml('account/get_info', function(html) {
				$('#infoBlock').html(html);
				$('.tabstitles li').on(tapEvent, function() {});
			}, function() {
				infoWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Создание рейда
	var newRaidWin,
		activePeriod;
	
	$('[newraid]').on(tapEvent, function() {
		var newRaidStatic = $(this).attr('newraid');
		popUp({
			title: 'Новый рейд',
			width: 800,
			winClass: 'account'
		}, function(nrWin) {
			newRaidWin = nrWin;
			newRaidWin.wait();
			
			$.post('/account/get_active_period', {static: newRaidStatic}, function(period) {
				if (!period) {
					newRaidWin.setData('<p class="empty center">Нет активных периодов!</p>', false);
					newRaidWin.wait(false);
				} else {
					activePeriod = period;
					getNewRaidData(newRaidStatic);
				}
				$('.tabstitles li').on(tapEvent, function() {});
			}, 'json').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
				newRaidWin.wait(false);
			});
		});
	});
	
	
	
	function getNewRaidData(newRaidStatic) {
		getAjaxHtml('account/get_new_raid_data', {static: newRaidStatic, period: activePeriod}, function(html) {
			newRaidWin.setData(html, false);
			newRaidWin.setButtons([{id: 'addRaid', title: "Создать рейд"}]);
			
			$('#raidStaticTabs').find('li').on(tapEvent, function() {});
			
			$('[tabid="raidStaticOrders"]').on('keydown', '.popup__table tbody tr:last input[type="text"]', function() {
				if ($(this).val().length == 0) {
					var newIndex = $('[tabid="raidStaticOrders"]').find('.popup__table tbody tr').length,
						rowHtml = '';
						rowHtml += '<tr>';
						rowHtml += 	'<td><p>Заказ '+(newIndex + 1)+'</p></td>';
						rowHtml += 	'<td><div class="popup__field"><input type="text" autocomplete="off" name="raid_orders['+newIndex+']"></div></td>';
						rowHtml += '</tr>';
					$('[tabid="raidStaticOrders"]').find('.popup__table tbody').append(rowHtml);
				}
			});
			
			$('[tabid="raidStaticUsers"]').on('change', 'input[type="checkbox"]', function() {
				var thisStat = $(this).is(':checked'),
					thisRow = $(this).closest('tr');
					
				if (thisStat) {
					$(thisRow).find('input[type="number"]').val('1');
				} else {
					$(thisRow).find('input[type="number"]').val('0');
				}
			});
			
			
			//---------------------------------------- Добавить рейд
			$('#addRaid').on(tapEvent, function() {
				newRaidWin.wait();
				var stat = true;
				
				if (!$('select[name="raid_type"]').val()) {
					$('select[name="raid_type"]').addClass('error');
					notify('Ошибка! Необходимо выбрать тип рейда', 'error');
					stat = false;
				}
				
				/*if ($('#newRaidOrders tbody').find('input[name*="raid_orders"]').length < 2) {
					notify('Ошибка! Список заказов не может быть пустым!', 'error');
					$('#raidStaticOrders').addClass('error');
					stat = false;
				}*/
				
				
				if (stat) {
					var raidForm = new FormData($('#newRaidForm')[0]);
						raidForm.append('static_id', newRaidStatic);
					
					$.ajax({
						type: 'POST',
						url: '/account/add_raid',
						dataType: 'json',
						cache: false,
						contentType: false,
						processData: false,
						data: raidForm,
						success: function(response) {
							if (response) notify('Рейд успешно добавлен!');
							else notify('Ошибка сохранения данных', 'error');
						},
						error: function(e) {
							notify('Ошибка сохранения данных', 'error');
							showError(e);
						},
						complete: function() {
							newRaidWin.close();
						}
					});
				} else {
					newRaidWin.wait(false);
				}
			});
		}, function() {
			newRaidWin.wait(false);
		});	
	}
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Коэффициенты
	var setCompoundWin,
		compoundPeriodId,
		compoundStaticId,
		compoundIsLider;
	$('[setcompound]').on(tapEvent, function() {
		var c = $(this).attr('setcompound').split('|');
		compoundStaticId = c[0],
		compoundIsLider = c[1];
		
		popUp({
			title: 'Коэффициенты команды',
			width: 500,
			winClass: 'account',
			buttons: false,
		}, function(sCWin) {
			setCompoundWin = sCWin;
			setCompoundWin.wait();
			
			getAjaxHtml('account/get_reports_periods', function(html, stat) {
				if (stat) setCompoundWin.setData(html, false);
				else setCompoundWin.setData('<p class="empty center">Нет активных периодов!</p>', false);
			}, function() {
				setCompoundWin.wait(false);
			});
		});
	});
	
	
	//------------------------------------------- Выбрать период для изменения состава команды
	$('body').off(tapEvent, '[periodtocompound]').on(tapEvent, '[periodtocompound]', function() {
		compoundPeriodId = $(this).attr('periodtocompound');
		getUsersToCompound();
	});
	
	
	
	function getUsersToCompound() {
		setCompoundWin.wait();
		$.post('/account/get_users_to_compound', {period_id: compoundPeriodId, static_id: compoundStaticId, is_lider: compoundIsLider}, function(html) {
			if (html) {
				setCompoundWin.setWidth(1300);
				setCompoundWin.setData(html, false);
				if (compoundIsLider == 1) {
					//setCompoundWin.setButtons([{id: 'setCompoundButton', title: "Обновить"}]);
					
					let editRaidKoeffTOut;
					$('#koeffsData').find('[editkoeff]').onChangeNumberInput(function(value, input) {
						var d = $(input).attr('editkoeff').split('|');
						clearTimeout(editRaidKoeffTOut);
						editRaidKoeffTOut = setTimeout(function() {
							$.post('/account/edit_raid_koeff', {id: d[0], user_id: d[1], raid_id: d[2], rate: value}, function(response) {
								if (!response) {
									$(input).addClass('error');
									notify('Ошибка сохранения коэффициента!', 'error');
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						}, 200);
					});
					
					
					let editRaidTypeTOut;
					$('#koeffsData').find('[editraidtype]').on('change', function() {
						var input = this,
							keyId = $(input).attr('editraidtype'),
							thisTypeId = $(input).val();
						
						clearTimeout(editRaidTypeTOut);
						editRaidTypeTOut = setTimeout(function() {
							$.post('/account/edit_raid_type', {id: keyId, type: thisTypeId}, function(response) {
								if (!response) {
									$(input).addClass('error');
									notify('Ошибка сохранения типа рейда!', 'error');
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						}, 200);
					});
					
					
					let editCompoundTOut;
					$('#compoundForm').find('[setcompound]').onChangeNumberInput(function(value, input) {
						var d = $(input).attr('setcompound').split('|'),
							userId = d[0],
							field = d[1];
						
						clearTimeout(editCompoundTOut);
						editCompoundTOut = setTimeout(function() {
							$.post('/account/set_compound_item', {period_id: compoundPeriodId, static_id: compoundStaticId, user_id: userId, field: field, value: value}, function(response) {
								if (!response) {
									$(input).addClass('error');
									notify('Ошибка сохранения коэффициента!', 'error');
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						}, 200);
					});
					
				}
			} else {
				setCompoundWin.setData('<p class="empty center">Нет данных</p>', false);
			}
			setCompoundWin.wait(false);
			$('.scroll').ddrScrollTable();
		}, 'html').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
			setCompoundWin.wait(false);
		});
	}
	
	
	//------------------------------------------- Задать коэффициенты
	$('body').off(tapEvent, '#setCompoundButton').on(tapEvent, '#setCompoundButton', function() {
		setCompoundWin.wait();
		var compoundForm = new FormData($('#compoundForm')[0]);
			compoundForm.append('period_id', compoundPeriodId);
			compoundForm.append('static_id', compoundStaticId);
		
		/*var koeffData = [],
			rTypesData = [];
			
		$('#koeffsData').find('[editkoeff]').each(function(k, item) {
			var data = $(item).attr('editkoeff').split('|'),
				rate = $(item).val();
				
			koeffData.push({
				id: data[0],
				user_id: data[1],
				raid_id: data[2],
				rate: rate
			});	
		});
		
		$('#koeffsData').find('[editraidtype]').each(function(k, item) {
			var keyId = $(item).attr('editraidtype'),
				thisTypeId = $(item).val();
			rTypesData.push({
				id: keyId,
				type: thisTypeId,
			});
		});
		
		compoundForm.append('koeffs', JSON.stringify(koeffData));
		compoundForm.append('r_types', JSON.stringify(rTypesData));*/
		
		$.ajax({
			type: 'POST',
			url: '/account/set_compound',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: compoundForm,
			success: function(response) {
				if (response) notify('Состав команды успешно обновлен!');
				else notify('Ошибка сохранения данных', 'error');
			},
			error: function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
			},
			complete: function() {
				setCompoundWin.close();
			}
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	var funct;
	
	//---------------------------------------- Ключи
	$('[setkeys]').on(tapEvent, function() {
		var c = $(this).attr('setkeys').split('|'),
			staticId = c[0],
			isLider = parseInt(c[1]),
			activePeriod;
		
		popUp({
			title: 'Ключи',
			width: 1000,
			winClass: 'account',
			buttons: false,
		}, function(keysWin) {
			keysWin.wait();
			
			
			$.post('/account/get_active_period', {static: staticId}, function(period) { // period.id period.name
				activePeriod = period;
				if (!activePeriod) {
					keysWin.setData('<p class="empty center">Нет активных периодов!</p>', false);
					keysWin.wait(false);
				} else {
					keysWin.setTitle('Ключи - '+activePeriod.name);
					
					funct = function() {
						getAjaxHtml('account/get_users_to_keys', {period_id: activePeriod.id, static_id: staticId, is_lider: isLider}, function(html, stat) {
							keysWin.setData(html, false);
							$('.scroll').ddrScrollTable();
							if (stat && !!isLider) keysWin.setButtons([{id: 'saveKeyCoefficients', title: "Сохранить", 'disabled': 1}, {id: 'newKeyButton', title: "Новый ключ"}]);
						}, function() {
							keysWin.wait(false);
							
							//---------------------------------------- изменение коэффициентов и типов ключей
							$('body').off('keyup change', '[editkeykoeff]').on('keyup change', '[editkeykoeff]', function(e) {
								$(this).closest('td').addClass('changed');
								$('#saveKeyCoefficients').removeAttrib('disabled');
							});

							$('body').off('change', '[editkeytype]').on('change', '[editkeytype]', function(e) {
								$(this).closest('td').addClass('changed');
								$('#saveKeyCoefficients').removeAttrib('disabled');
							});


							//---------------------------------------- сохранить коэффициенты и типы ключей
							$('body').off(tapEvent, '#saveKeyCoefficients').on(tapEvent, '#saveKeyCoefficients', function() {
								keysWin.wait();
								var koeffData = [],
									kTypesData = [];
									
								$('body').find('[editkeykoeff]').each(function(k, item) {
									var data = $(item).attr('editkeykoeff').split('|'),
										koeff = $(item).val();
										
									koeffData.push({
										user_id: data[0],
										raid_id: data[1],
										koeff: koeff
									});	
								});
								
								$('body').find('[editkeytype]').each(function(k, item) {
									var keyId = $(item).attr('editkeytype'),
										thisTypeId = $(item).val();
									kTypesData.push({
										id: keyId,
										type: thisTypeId,
									});
								});

								$.post('/account/edit_key_data', {koeffs: koeffData, k_types: kTypesData}, function(response) {
									if (response) {
										notify('Данные сохранены!');
										foo();
										//тут вернуть окно с ключами
										
									} else notify('Ошибка сохранения данных!', 'error');
								});
							});
							
							
							
							//---------------------------------------- Создание ключа
							$('#newKeyButton').on(tapEvent, function() {
								keysWin.setWidth(800);
								getNewKeyData(staticId, activePeriod, keysWin);
								/*$('.tabstitles li').on(tapEvent, function() {
									infoWin.correctPosition(100);
								});*/
							});
						});
					}
					
					funct();	
					
				}
			}, 'json').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
				keysWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	//---------------------------------------- Новый ключ
	function getNewKeyData(newKeyStatic, activePeriod, newKeyWin) {
		getAjaxHtml('account/get_new_key_data', {static: newKeyStatic, period: activePeriod}, function(html) {
			newKeyWin.setData(html, false);
			newKeyWin.setButtons([{id: 'addKey', title: "Создать ключ"}]);
			
			$('#keyStaticTabs').find('li').on(tapEvent, function() {});
			
			$('#newKeyForm').on('change', 'input[type="checkbox"]', function() {
				var thisStat = $(this).is(':checked'),
					thisRow = $(this).closest('tr');
					
				if (thisStat) {
					$(thisRow).find('input[type="number"]').val('1');
				} else {
					$(thisRow).find('input[type="number"]').val('0');
				}
			});
			
			
			//---------------------------------------- Добавить ключ
			$('#addKey').on(tapEvent, function() {
				newKeyWin.wait();
				var stat = true;
				
				if (!$('select[name="key_type"]').val()) {
					$('select[name="key_type"]').addClass('error');
					notify('Ошибка! Необходимо выбрать тип ключа', 'error');
					stat = false;
				}
				
				/*if ($('#newRaidOrders tbody').find('input[name*="raid_orders"]').length < 2) {
					notify('Ошибка! Список заказов не может быть пустым!', 'error');
					$('#raidStaticOrders').addClass('error');
					stat = false;
				}*/
				
				
				if (stat) {
					var keyForm = new FormData($('#newKeyForm')[0]);
						keyForm.append('static_id', newKeyStatic);
					
					$.ajax({
						type: 'POST',
						url: '/account/add_key',
						dataType: 'json',
						cache: false,
						contentType: false,
						processData: false,
						data: keyForm,
						success: function(response) {
							if (response) notify('Ключ успешно добавлен!');
							else notify('Ошибка сохранения данных', 'error');
						},
						error: function(e) {
							notify('Ошибка сохранения данных', 'error');
							showError(e);
						},
						complete: function() {
							newKeyWin.setWidth(1000);
							funct();
							//newKeyWin.close();
						}
					});
				} else {
					newKeyWin.wait(false);
				}
			});
		}, function() {
			newKeyWin.wait(false);
		});	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Рейтинг участников
	$('[setrating]').on(tapEvent, function() {
		var c = $(this).attr('setrating').split('|'),
			staticId = c[0],
			isLider = parseInt(c[1]);
		
		popUp({
			title: 'Рейтинги участников',
			width: 1000,
			winClass: 'account',
			buttons: [{id: 'setDataToRatings', title: 'Сохранить'}],
			closeButton: 'Отмена'
		}, function(setRatingWin) {
			setRatingWin.wait();
			getAjaxHtml('account/get_users_for_rating', {static_id: staticId}, function(html, stat) {
				if (stat) {
					setRatingWin.setData(html, false);
				} else {
					setRatingWin.setData('<p class="info">Нет активных периодов!</p>', false);
				}
			}, function() {
				setRatingWin.wait(false);
			});
			
			
			$('#setDataToRatings').on(tapEvent, function() {
				setRatingWin.wait();
				sendFormData('#usersRatings', {
					url: '/account/save_data_for_rating',
					success: function(response) {
						notify('Данные успешно сохранены!');
						setRatingWin.close();
						setRatingWin.wait(false);
					},
					error: function(e) {
						setRatingWin.wait(false);
						notify('Ошибка сохранения данных', 'error');
						showError(e);
					}
				});
			});
		});
		
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Моя премия
	$('[myreward]').on(tapEvent, function() {
		let staticId = $(this).attr('myreward');
		
		popUp({
			title: 'Моя премия',
			width: 500,
			//closeButton: 'Отмена',
		}, function(myRewardWin) {
			myRewardWin.wait();
			getAjaxHtml('account/rewards/get_periods', function(html) {
				myRewardWin.setData(html, false);
				
				$('[chooseperiodtoreward]').on(tapEvent, function() {
					let periodId = $(this).attr('chooseperiodtoreward');
					myRewardWin.wait();
					getAjaxHtml('account/rewards/get_report', {period_id: periodId, static_id: staticId}, function(html) {
						myRewardWin.setData(html, false);
					}, function() {
						myRewardWin.wait(false);
					});
				});
			}, function() {
				myRewardWin.wait(false);
			});
		});
		
		
		/*1. выбрать премиальный период
		2. выдрать из периода платежные периоды из rewards_period
		3. выдрать сумму на статик из rewards_statics
		
		
		{cash: "{"2":30000}", period_id: "[89,88,87]", variant: "2"}
		getAjaxHtml('reports/get_main_report', {cash: staticsCash, period_id: periodId, to_user: 1,  variant: 2}, function(html) {
			$('#mainReport').html(html);
			$('#mainReport').ready(function() {
				$('.scroll').ddrScrollTable();
				$('#mainReportTitle').text('');
			});
			$('[id^="tabstatic"]:first').addClass('active');
			$('[tabid^="tabstatic"]:first').addClass('visible');
			$('#reportVariant').val(reportVariant);
			reportVariantWin.close();
			$('#saveMainReport').removeAttrib('disabled');
		});*/
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Напоминание о заполнении коэффициентов для рейтинга
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Отчет по выплатам
	var reportWin, limit = 10, offset;
	$('[reportpatternsbutton]').on(tapEvent, function() {
		popUp({
			title: 'Выплаты',
			width: 800,
			html: '<div id="reportPatternsList"></div>',
			winClass: 'account',
			buttons: [{id: 'getEarlyPatterns', title: 'Показать более ранние'}],
			closeButton: 'Закрыть'
		}, function(rptWin) {
			reportWin = rptWin;
			offset = 0;
			reportWin.wait();
			var html = '';
			
			getAjaxHtml('reports/get_main_reports_patterns', {to_user: 1, limit: limit, offset: offset}, function(html) {
				$('#reportPatternsList').html(html);
			}, function() {
				reportWin.wait(false);
			});
		});
	});
	
	
	$('body').off(tapEvent, '#getEarlyPatterns').on(tapEvent, '#getEarlyPatterns', function() {
		reportWin.wait();
		offset += limit;
		
		getAjaxHtml('reports/get_main_reports_patterns', {to_user: 1, limit: limit, offset: offset}, function(html, stat) {
			if (stat) {
				$('#reportPatternsList').html(html);
			} else {
				$('#getEarlyPatterns').setAttrib('disabled');
				notify('Это последние записи.', 'info');
			}
		}, function() {
			reportWin.wait(false);
		});	
	});
		
		
	$('body').off(tapEvent, '[patternid]').on(tapEvent, '[patternid]', function() {
		reportWin.wait();
		var thisPatternId = $(this).attr('patternid'),
			thisPatternName = $(this).attr('patternname');
		
		getAjaxHtml('reports/get_main_report', {from_pattern: 1, to_user: 1, pattern_id: thisPatternId}, function(html, stat) {
			reportWin.setTitle('Отчет по выплатам - '+thisPatternName);
			
			if (stat) {
				reportWin.setWidth(1330);
				reportWin.setData(html, false);
				reportWin.removeButtons();
			} else {
				reportWin.setData('<p class="empty center">Нет данных</p>', false);
				reportWin.removeButtons();
			}
			
			$('.scroll').ddrScrollTable();
		}, function() {
			reportWin.wait(false);
		});
	});
	
	
	
	$('body').off(tapEvent, '[patternkeyid]').on(tapEvent, '[patternkeyid]', function() {
		reportWin.wait();
		var thisPatternId = $(this).attr('patternkeyid'),
			thisPatternName = $(this).attr('patternname');
		
		getAjaxHtml('reports/get_keys_report', {from_pattern: 1, to_user: 1, pattern_id: thisPatternId}, function(html, stat) {
			reportWin.setTitle('Отчет по выплатам - '+thisPatternName);
			if (stat) {
				reportWin.setWidth(1058);
				reportWin.setData(html, false);
				reportWin.removeButtons();
			} else {
				reportWin.setData('<p class="empty center">Нет данных</p>', false);
				reportWin.removeButtons();
			}
		}, function() {
			reportWin.wait(false);
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Периоды расписания
	var timesheetPeriodsWin, periodId, periodName, staticName;
	$('[timesheetperiodbutton]').on(tapEvent, function() {
		popUp({
			title: 'Периоды расписания',
			width: 520,
			winClass: 'account'
		}, function(tPWin) {
			timesheetPeriodsWin = tPWin;
			timesheetPeriodsWin.wait();
			
			$.post('/timesheet/get_timesheet_periods', {to_user: 1}, function(html) {
				if (html) {
					timesheetPeriodsWin.setData(html, false);
				} else {
					timesheetPeriodsWin.setData('<p class="empty center">Нет данных</p>', false);
				}
				timesheetPeriodsWin.wait(false);
			}, 'html').fail(function(e) {
				timesheetPeriodsWin.wait(false);
				showError(e);
				notify('Системная ошибка!', 'error');
			});
		});
	});
	
	
	//---------------------------------------------------------------- Выбрать период
	$('body').off(tapEvent, '[choosetimesheetperiod]').on(tapEvent, '[choosetimesheetperiod]', function() {
		timesheetPeriodsWin.wait();
		periodId = $(this).attr('choosetimesheetperiod'),
		periodName = $(this).children('span').text();
			
		$.post('/account/get_statics', {attr: 'statictotimesheet'}, function(html) {
			if ($(html).find('[statictotimesheet]').length == 1) {
				var staticId = $(html).find('[statictotimesheet]').attr('statictotimesheet');
					staticName = $(html).find('[statictotimesheet] span').text();
				getTimesheetData(staticId, staticName, periodId);
			} else {
				timesheetPeriodsWin.setData(html, false);
			}
			timesheetPeriodsWin.wait(false);
		}, 'html').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
			timesheetPeriodsWin.wait(false);
		});
	});
	
	
	
	$('body').off(tapEvent, '[statictotimesheet]').on(tapEvent, '[statictotimesheet]', function() {
		timesheetPeriodsWin.wait();
		var staticId = $(this).attr('statictotimesheet');
		getTimesheetData(staticId, staticName, periodId);
	});
	
	
	function getTimesheetData(staticId, staticName, period) {
		getAjaxHtml('timesheet/get_timesheet_data', {period_id: period, static_id: staticId, static_name: staticName}, function(html, stat) {
			if (stat) {
				timesheetPeriodsWin.setWidth(1330);
				timesheetPeriodsWin.setData(html, false);
				timesheetPeriodsWin.setTitle(periodName);
			} else {
				timesheetPeriodsWin.setTitle(periodName);
				timesheetPeriodsWin.setData('<p class="empty dark center">Нет данных</p>', false);
			}
		}, function() {
			timesheetPeriodsWin.wait(false);
		});
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Забронировать выходной
	var offtimeWin, offtimeStatic, historyWeeks;
	$('[getofftime]').on(tapEvent, function() {
		historyWeeks = 0;
		popUp({
			title: 'Забронировать выходной',
			width: 500,
			winClass: 'account'
		}, function(win) {
			offtimeWin = win;
			offtimeWin.wait();
			
			getAjaxHtml('account/get_statics', {attr: 'statictoofftime'}, function(html) {
				if ($(html).find('[statictoofftime]').length == 1) {
					offtimeStatic = $(html).find('[statictoofftime]').attr('statictoofftime');
					getOfftimeDates(offtimeStatic);
				} else {
					offtimeWin.setData(html, false);
				}
			}, function() {
				offtimeWin.wait(false);
			});
		});
	});
	
	
	$('body').off(tapEvent, '[statictoofftime]').on(tapEvent, '[statictoofftime]', function() {
		offtimeWin.wait();
		offtimeStatic = $(this).attr('statictoofftime');
		getOfftimeDates(offtimeStatic);
	});
	
	$('body').off(tapEvent, '[offtimehistory]').on(tapEvent, '[offtimehistory]', function() {
		var dir = $(this).attr('offtimehistory');
		historyWeeks = dir == '+' ? historyWeeks+1 : historyWeeks-1;
		if (historyWeeks == 0) $('[offtimehistory="+"]').setAttrib('disabled');
		else $('[offtimehistory="+"]').removeAttrib('disabled');
		offtimeWin.wait();
		getOfftimeDates(offtimeStatic, historyWeeks);
	});
	
	
	function getOfftimeDates(st, hWeeks) {
		console.log(st, hWeeks);
		$.post('/offtime/get_offtime_dates', {static: st, history: hWeeks}, function(html) {
			if (!hWeeks) offtimeWin.setWidth(1330);
			offtimeWin.setData(html, false);
			offtimeWin.wait(false);
		}, 'html').fail(function(e) {
			showError(e);
			offtimeWin.wait(false);
			notify('Системная ошибка!', 'error');
		});
	}
	
	
	
	
	
	$('body').off(tapEvent, '[setofftime]').on(tapEvent, '[setofftime]', function() {
		var thisData = $(this).attr('setofftime').split('|');
			params = {
				user_id: thisData[0],
				static: thisData[1],
				role: thisData[2],
				date: thisData[3],
				history: historyWeeks
			};
		$.post('/offtime/set_offtime', params, function(html) {
			if (html == '-1') { // лимит на роль в день
				notify('Достигнут лимит на роль в день!', 'info');
			} else if (html == '-2') { // лимит на все роли одного статика в день
				notify('Достигнут лимит на все роли одного статика в день!', 'info');
			} else if (html == '-3') { // лимит на количество выходных в месяц
				notify('Достигнут лимит на количество выходных в месяц!', 'info');
			} else if (html == '-4') { // если у этого участника в этот день уже есть выходной
				notify('У Вас в этот день уже есть выходной!', 'info');
			} else {
				offtimeWin.setData(html, false);
				notify('Выходной успешно забронирован!');
			}
		}, 'html').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	$('body').off(tapEvent, '[unsetofftime]').on(tapEvent, '[unsetofftime]', function() {
		var thisData = $(this).attr('unsetofftime').split('|');
		$.post('/offtime/unset_offtime', {id: thisData[0], static: thisData[1], history: historyWeeks}, function(html) {
			if (html) {
				offtimeWin.setData(html, false);
				notify('Выходной отменен!', 'info');
			} else {
				notify('Ошибка! Выходной не отменен!', 'error');
			}
		}, 'html').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Забронировать отпуск
	var date = new Date(),
		vacationWin,
		currentStatic,
		datesShift;
		
	$('[getvacation]').on(tapEvent, function() {
		popUp({
			title: 'Забронировать отпуск',
			width: 500,
			winClass: 'account'
		}, function(win) {
			vacationWin = win;
			vacationWin.wait();
			datesShift = 4;
			
			getAjaxHtml('account/get_statics', {attr: 'statictovacation'}, function(html) {
				if ($(html).find('[statictovacation]').length == 1) {
					currentStatic = $(html).find('[statictovacation]').attr('statictovacation');
					getVacationDates(currentStatic, datesShift);
				} else {
					vacationWin.setData(html, false);
				}
			}, function() {
				vacationWin.wait(false);
			});
		});
	});
	
	
	$('body').off(tapEvent, '[statictovacation]').on(tapEvent, '[statictovacation]', function() {
		vacationWin.wait();
		currentStatic = $(this).attr('statictovacation');
		console.log(currentStatic, datesShift);
		getVacationDates(currentStatic, datesShift);
	});
	
	$('body').off(tapEvent, '[vacationshift]').on(tapEvent, '[vacationshift]', function() {
		var dir = $(this).attr('vacationshift');
		if (dir == 'prev' && datesShift != -4) {
			datesShift = -4;
			getVacationDates(currentStatic, datesShift);
		} else if (dir == 'next' && datesShift != 4) {
			datesShift = 4;
			getVacationDates(currentStatic, datesShift);
		}
	});
	
	function getVacationDates(st, shift) {
		vacationWin.wait();
		shift == shift || 0;
		$.post('/vacation/get_vacation_dates', {static: st, shift: shift}, function(html) {
			if (!html) {
				vacationWin.setData('<p class="empty text-center">Запрещено бронировать отпуск в текущем звании!</p>', false);
				vacationWin.wait(false);
				return true;
			}
			
			vacationWin.setWidth(1330);
			vacationWin.setData(html, false);
			vacationWin.wait(false);
			
			var space = parseInt($('#vacationsSpace').val()), //---- промежуток между партиями
				party = parseInt($('#vacationsParty').val()), //---- лимит партии
				minLimit = 0, //---- минимальный общий лимит
				maxLimit = parseInt($('#setVacationsLimit').val()) + $('#vacationTable tbody tr.edited').children('td.vacated').length; //---- максимальный общий лимит
			
			
			$('#vacationTable').find('tr.edited').multiChoose({
				item: '[setvacation]:not(.out):not(.confirmed)',
				cls: 'vacated',
				onChoose: function(item, row, stat, start) {
					var rows = $('#vacationTable tbody tr'),
						index = $(item).index(),
						timePoint = parseInt($(item).attr('setvacation')),
						partyBefore = 0,
						partyAfter = 0;
					
					date.setTime(timePoint * 1000);
					
					function cell(i) {
						i = i || 0;
						return $(row).children().eq(index + i);
					}
					
					if (stat && cell().hasClass('disabled')) {
						notify('Запрещено!', 'info');
						return false;
					} 
					
					
					if (space) {
						if (stat && (cell(1).hasClass('vacated') == false && cell(-1).hasClass('vacated') == false)) {
							for (var iter = 2; iter <= space; iter++) {
								if (cell(iter).hasClass('vacated') || cell(-iter).hasClass('vacated')) return false;
							}
						} else if (stat && cell(1).hasClass('vacated') == false) {
							for (var iter = 2; iter <= space; iter++) {
								if (cell(iter).hasClass('vacated')) return false;
							}
						} else if (stat && cell(-1).hasClass('vacated') == false) {
							for (var iter = 2; iter <= space; iter++) {
								if (cell(-iter).hasClass('vacated')) return false;
							}
						}
						
						if (!stat && (cell(1).hasClass('vacated') && cell(-1).hasClass('vacated')) && space > 1) {
							notify('Нельзя!', 'info');
							return false;
						}
					}
						
					
					
					if (party) {
						while (cell(-(partyBefore + 1)).hasClass('vacated') == true) partyBefore += 1;
						while (cell(partyAfter + 1).hasClass('vacated') == true) partyAfter += 1;
						if (stat && (partyBefore + partyAfter) >= party) {
							notify('Запрещено более '+party+' дн. подряд!', 'info');
							return false;
						}
					}	
						
					
					
					if (minLimit && stat == false && $(row).children('td.vacated').length <= minLimit) {
						notify('Лимит бронирования!', 'info');
						return false;
					}
					
					if (maxLimit && stat && $(row).children('td.vacated').length >= maxLimit) {
						notify('Лимит бронирования!', 'info');
						return false;
					}
					
					
					/*if (parallelLimit) {
						$.each(rows, function(k, r) {
							if ($(r).children('td').eq(index).hasClass('vacated')) parallel += 1;
						});
						
						if (stat && parallel >= parallelLimit) {
							notify('Лимит одновременного бронирования!', 'info');
							return false;
						}
					}*/
					
					return true;
				}
			}, function(row, choosedItems, isChoosed) {
				var dates = [],
					userId = $(row).attr('vacationuser'),
					staticId = $(row).attr('vacationstatic');
				
				if (choosedItems) {
					$.each(choosedItems, function(k, item) {
						dates.push($(item).attr('setvacation'));
					});
				}
				
				if (isChoosed) {
					$.post('/vacation/set_vacation_date', {user_id: userId, static_id: staticId, dates: dates}, function(response) {
						if (response) {
							notify('День успешно забронирован');
						}
					}, 'json');
				} else {
					$.post('/vacation/unset_vacation_date', {user_id: userId, static_id: staticId, dates: dates}, function(response) {
						if (response) {
							notify('Бронь отменена');
						}
					}, 'json');
				}
			});
			
		}, 'html').fail(function(e) {
			showError(e);
			vacationWin.wait(false);
			notify('Системная ошибка!', 'error');
		});
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*var mDownStat = false, isVacated = false, choosedCells = [], limit = 10;
	$('body').off('mousedown mouseup', '[setvacation]').on('mousedown mouseup', '[setvacation]', function(e) {
		var cell = this,
			cellsRow = $(cell).closest('tr'),
			countVacatedCells = $(cellsRow).children('td.vacated').length,
			date = $(cell).attr('setvacation'),
			userId = $(cellsRow).attr('vacationuser'),
			staticId = $(cellsRow).attr('vacationstatic');
		
		
		if (e.type == 'mousedown') {
			mDownStat = true;
			choosedCells = [];
			if ($(cell).hasClass('vacated') == false) {
				if (countVacatedCells < limit) {
					$(cell).addClass('vacated');
					choosedCells.push(date);
					isVacated = true;
				} else {
					notify('Достигнут лимит', 'info'); // ---------------
				}
			} else {
				$(cell).removeClass('vacated');
				choosedCells.push(date);
				isVacated = false;
			}
		} else if (e.type == 'mouseup') {
			mDownStat = false;
			if (choosedCells.length) setVacationDays(userId, staticId, isVacated, choosedCells); // ---------------
		}
	});
	
	
	$('body').off('mouseenter', '[setvacation]').on('mouseenter', '[setvacation]', function(e) {
		var cell = this,
			cellsRow = $(cell).closest('tr'),
			countVacatedCells = $(cellsRow).children('td.vacated').length;
		
		if ($(cell).hasClass('vacated') == false && mDownStat && isVacated) {
			if (countVacatedCells < limit) {
				choosedCells.push($(cell).attr('setvacation'));
				$(cell).addClass('vacated');
			}
		} else if ($(cell).hasClass('vacated') && mDownStat && isVacated == false) {
			$(cell).removeClass('vacated');
			choosedCells.push($(cell).attr('setvacation'));
		} 
	});
	
	
	// Задать или отменить дни для отпуска
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------- Образование (guides)
	$('[guideschapter]:not([guideropensubnav])').on(tapEvent, function() {
		if ($(this).hasClass('active')) return false;
		$('[guideschapter]').removeClass('active');
		$(this).addClass('active');
		
		var thisChapterId = $(this).attr('guideschapter');
		$('.contentblock__wait').addClass('contentblock__wait_visible');
		$('#guidesContent').html('');
		getAjaxHtml('account/get_guide_chapter', {id: thisChapterId}, function(html) {
			$('#guidesContent').html(html);
			location.hash = thisChapterId;
		}, function() {
			$('.contentblock__wait').removeClass('contentblock__wait_visible');
		});
	});
	
	
	var hashChapterId = location.hash.substr(1, location.hash.length);
	if (hashChapterId != '') {
		$('.contentblock__wait').addClass('contentblock__wait_visible');
		getAjaxHtml('account/get_guide_chapter', {id: hashChapterId}, function(html) {
			$('#guidesContent').html(html);
		}, function() {
			$('.contentblock__wait').removeClass('contentblock__wait_visible');
			$('[guideschapter="'+hashChapterId+'"]').addClass('active');
			$('[guideschapter="'+hashChapterId+'"]').closest('li').parents('li').addClass('opened');
		});
	}
	
	$('[guideropensubnav]').on(tapEvent, function() {
		if ($(this).closest('li').hasClass('opened')) {
			$(this).closest('li').removeClass('opened');
			$('#accountNavBlock').find('li').removeClass('opened');
		} else {
			$('#accountNavBlock').find('li').removeClass('opened');
			$(this).closest('li').addClass('opened');
			//$(this).parents('ul').addClass('opened');
		}
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('[showstatistics]').on(tapEvent, function() {
		popUp({
			title: 'Статистика',
			width: 800,
			closeButton: 'Закрыть',
		}, function(statisticsWin) {
			statisticsWin.wait();
			getAjaxHtml('account/statistics_get', function(html) {
				statisticsWin.setData(html, false);
				statisticsWin.wait(false);
			}, function() {});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------- Личные рейтинг и выбор наставника
	$('[myrating]').on(tapEvent, function() {
		popUp({
			title: 'Мой рейтинг',
			width: 600,
			closeButton: 'Закрыть',
			winClass: 'ratings'
		}, function(myRatingWin) {
			myRatingWin.wait();
			getAjaxHtml('account/get_rating', function(html) {
				myRatingWin.setData(html, false);
				onChangeTabs(function(titles, content) {});
			}, function() {
				myRatingWin.wait(false);
			});
		});
	});
	
	
	
	
	/*$('[myrating]').on(tapEvent, function() {
		popUp({
			title: 'Мой рейтинг',
			width: 800,
			buttons: [{id: 'chooseMentor', title: 'Выбрать наставника'}],
			closeButton: 'Закрыть',
		}, function(myRatingWin) {
			
			function myRating(replace) {
				if (replace) {
					myRatingWin.setTitle('Мой рейтинг');
					myRatingWin.setButtons([{id: 'chooseMentor', title: 'Выбрать наставника'}], 'Закрыть');
				}
				
				//------------------------------------------------ тут загружать данные личного рейтинга
				myRatingWin.setData('Мой рейтинг', false);
				
				
				
				//------------------------------------------------ Выбрать наставника
				$('#chooseMentor').on(tapEvent, function() {
					myRatingWin.wait();
					getAjaxHtml('account/mentors/get', function(html) {
						myRatingWin.setTitle('Выбрать наставника');
						myRatingWin.setData(html, false);
						myRatingWin.setButtons([{id: 'setMyRating', title: 'Мой рейтинг'}], 'Закрыть');
						myRatingWin.wait(false);
					}, function() {
						$('#mentorsTable').scroll(function(e) {
							var scrTop = $(this).scrollTop();
							$('#mentorsTable').find('thead').css('transform', 'translateY('+scrTop+'px)');
						});
						
						$('.popup__window').find('[id^=tab]').on(tapEvent, function() {
							myRatingWin.correctPosition();
						});
						
						$('.mentors').on(tapEvent, '[choosementor]', function() {
							const classes = $(this).attr('choosementor');
							getAjaxHtml('account/mentors/show_classes', {classes: classes}, function(html) {
								myRatingWin.setData(html, false);
								myRatingWin.setWidth(400);
								myRatingWin.setTitle('Запросить обучение');
							}, function() {
								$('[choosementorsclass]').on(tapEvent, function() {
									let data = $(this).attr('choosementorsclass').split('|'),
										classId = data[0],
										mentorId = data[1];
									
									myRatingWin.wait();
									$.post('/account/mentors/add_request', {mentor_id: mentorId, class_id: classId}, function(request) {
										if (request) {
											myRatingWin.close();
											notify('Запрос успешно создан!');
										} else {
											notify('Ошибка создания запроса!', 'error');
											myRatingWin.wait(false);
										}
									});
								});
							});
							
						});
						
						
						$('#setMyRating').on(tapEvent, function() {
							myRating(true);
						});
						
					});
				});
				
			}
			
			myRating();
		});
	});
	*/
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------- Мои персонажи
	$('[getpersonages]').on(tapEvent, function() {
		
		popUp({
			title: 'Мои персонажи',
			width: 800,
			wrapToClose: true,
			winClass: false,
			//buttons: [{id: 'addPersonage', title: 'Добавить персонаж'}],
			closeButton: 'Закрыть',
		}, function(getPersonagesWin) {
			getPersonagesWin.wait();
			
			getAjaxHtml('account/personages/main', function(html) {
				getPersonagesWin.setData(html, false);
				$('#personesList').ddrCRUD({
					addSelector: '#addPersonage',
					functions: 'account/personages',
				}, function(html) {
					getPersonagesWin.wait(false);
				});
			}, function() {
				getPersonagesWin.wait(false);
			});
		});
		
		
		
		
		
		
		/*popUp({
			title: 'Мои персонажи',
			width: 500,
			buttons: [{id: 'popupNewPersonage', title: 'Добавить персонаж', disabled: 1}],
			closeButton: 'Закрыть',
		}, function(gameIdsPersonagesWin) {
			
			gameIdsPersonagesWin.wait();
			getAjaxHtml('account/personages/get_game_ids', function(html) {
				gameIdsPersonagesWin.setData(html, false);
			}, function() {
				gameIdsPersonagesWin.wait(false);
				$('#popupNewPersonage').removeAttrib('disabled');
			});
			
			
			$('body').on(tapEvent, '#popupNewPersonage', function() {
				gameIdsPersonagesWin.wait();
				getAjaxHtml('account/personages/new', function(html) {
					gameIdsPersonagesWin.setData(html, false);
					gameIdsPersonagesWin.setButtons([{id: 'addPersonage', title: 'Добавить'}, {title: 'Отмена', cls: 'close'}]);
					
					
					$('#addPersonage').on(tapEvent, function() {
						var nick = $('#newPersonageNick'),
							armor = $('#newPersonageArmor'),
							server = $('#newPersonageServer'),
							stat = true;
						
						if (nick.val() == '') {
							$(nick).addClass('error');
							stat = false;
						}
					
						if (armor.val() == '') {
							$(armor).addClass('error');
							stat = false;
						}
						
						if (server.val() == '') {
							$(server).addClass('error');
							stat = false;
						}
						
						if (stat) {
							gameIdsPersonagesWin.wait();
							$.post('/account/personages/add', {nick: nick.val(), armor: armor.val(), server: server.val()}, function(response) {
								if (response) {
									notify('Заявка успешно отправлена!');
									
									getAjaxHtml('account/personages/get_game_ids', function(html) {
										gameIdsPersonagesWin.setData(html, false);
										gameIdsPersonagesWin.setButtons([{id: 'popupNewPersonage', title: 'Добавить персонаж'}, {title: 'Отмена', cls: 'close'}]);
									}, function() {
										gameIdsPersonagesWin.wait(false);
									});
									
								} else {
									notify('Ошибка! Заявка не отправлена!', 'error');
								}
							}, 'json');
						}
						
						
						
					});
					
				}, function() {
					gameIdsPersonagesWin.wait(false);
				});
			});
		});*/
		
		
		
		/*$('#personesList').ddrCRUD({
			addSelector: '#addPersonage',
			functions: 'account/personages',
		}, function(html) {
			getPersonagesWin.wait(false);
		});*/
				
		
		
		
		
		/*var html = '';
			html += '<table class="popup__table">';
			html += 	'<thead>';
			html += 		'<tr>';
			html += 			'<td>Ник</td>';
			html += 			'<td>Тип брони</td>';
			html += 			'<td>Сервер</td>';
			html += 			'<td>Опции</td>';
			html += 		'</tr>';
			html += 	'</thead>';
			html += 	'<tbody id="personesList"></tbody>';
			html += '</table>';
		
		popUp({
			title: 'Мои персонажи',
			width: 800,
			height: false,
			html: html,
			wrapToClose: true,
			winClass: false,
			buttons: [{id: 'addPersonage', title: 'Добавить персонаж'}],
			closeButton: 'Закрыть',
		}, function(getPersonagesWin) {
			getPersonagesWin.wait();
			$('#personesList').ddrCRUD({
				addSelector: '#addPersonage',
				functions: 'account/personages',
			}, function(html) {
				getPersonagesWin.wait(false);
			});
		});*/
	});
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------- Мои заявки
	$('[paymentorders]').on(tapEvent, function() {
		popUp({
			title: 'Заявки на оплату',
			width: 1000,
			height: false,
			html: '<div id="paymentRequestsWin"></div>',
			wrapToClose: true,
			winClass: 'account',
			buttons: false,
			closeButton: false,
		}, function(paymentRequestsWin) {
			getAjaxHtml('account/get_payment_requests', function(html) {
				$('#paymentRequestsWin').html(html);
			}, function() {
				$('.tabstitles li:first').addClass('active');
				$('.tabscontent > *:first').addClass('visible');
				$('.tabstitles li').on(tapEvent, function() {});
			});
		});
	});
	
	
	
	
	
	
	
	
	//--------------------------------------------------- Моя посещаемость
	$('[visitsrate]').on(tapEvent, function() {
		popUp({
			title: 'Моя посещаемость',
			width: 400,
			height: false,
			html: '<div id="visitsRateWin"></div>',
			wrapToClose: true,
			winClass: 'account',
			buttons: false,
			closeButton: false,
		}, function(visitsRateWin) {
			visitsRateWin.wait();
			
			getAjaxHtml('account/get_reports_periods', {attr: 'chooseperiodtovisits', 'only_opened': false, 'to_visits': true}, function(html) {
				$('#visitsRateWin').html(html);
			}, function() {
				visitsRateWin.wait(false);
			});
			
			
			$('#visitsRateWin').on(tapEvent, '[chooseperiodtovisits]', function() {
				visitsRateWin.wait();
				var visitsPeriodId = $(this).attr('chooseperiodtovisits');
				
				getAjaxHtml('account/get_visits_coeffs', {period_id: visitsPeriodId}, function(html) {
					visitsRateWin.setWidth(1300);
					visitsRateWin.setData(html, false, function() {
						$('.scroll').ddrScrollTable();
					});
				}, function() {
					visitsRateWin.wait(false);
				});
			});
			
		});
	});
	
	
	
	
	
	
	//--------------------------------------------------- Мой KPI план
	$('[mykpiplan]').on(tapEvent, function() {
		popUp({
			title: 'Мой KPI план',
			width: 400,
			height: false,
			wrapToClose: true,
			winClass: 'account',
			buttons: false,
			closeButton: false,
		}, function(kpiPlanWin) {
			kpiPlanWin.setData('account/kpiplan/get_periods', function() {
				$('[kpiplanperiod]').on(tapEvent, function() {
					let kpiPeriodId = $(this).attr('kpiplanperiod'),
						kpiPeriodTitle = $(this).children('strong').text(),
						kpiPeriodDate = $(this).children('small').text(),
						userId = getCookie('id');
						
					kpiPlanWin.setData('account/kpiplan/get_user_progress', {kpi_period_id: kpiPeriodId, user_id: userId, period_title: kpiPeriodTitle, period_date: kpiPeriodDate}, function(html, stat) {
						if (!stat) kpiPlanWin.setData(html, false);
						else {
							kpiPlanWin.setWidth(1000);
						}
					});
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('[walletbalance]').on(tapEvent, function() {
		popUp({
			title: 'Мой баланс',
			width: 1000,
			closeButton: 'Закрыть',
		}, function(walletBalanceWin) {
			walletBalanceWin.wait();
			getAjaxHtml('account/get_balance', function(html) {
				walletBalanceWin.setData(html, false);
				$('#walletUserBalance').ddrScrollTableY({height: '400px', wrapBorderColor: '#d7dbde'});
			}, function() {
				walletBalanceWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	var raidersColorsData,
		raidersColorsUserId,
		raidersColorBlock,
		raidersColorsTooltip = new jBox('Tooltip', {
		attach: '[setstaticusercolor]',
		trigger: 'click',
		closeOnMouseleave: true,
		addClass: 'raiderscolorswrap',
		outside: 'x',
		ignoreDelay: true,
		zIndex: 1200,
		//pointer: 'left',
		//pointTo: 'left',
		position: {
		  x: 'right',
		  y: 'center'
		},
		content: '<i class="fa fa-bars"></i>'
	});
		
	getAjaxHtml('account/get_raiders_colors', {}, function(html) {
		raidersColorsTooltip.setContent(html);
	});	
	
	$('body').on(tapEvent, function(e) {
		if ($('[setstaticusercolor]:hover').length == 0 && $('body').find('.raiderscolorswrap:visible').length > 0 && $('body').find('.raiderscolors:hover').length  == 0) {
			raidersColorsTooltip.close();
		}
	});
	
	
	//--------------------------------------------------- Задать цвет рейдера
	$('[setstaticusercolor]').on(tapEvent, function() {
		raidersColorsUserId = $(this).closest('[userid]').attr('userid');
		raidersColorBlock = this;
	});
	
	
	
	$('body').on(tapEvent, '[chooseraidercolor]', function() {
		var thisRaiderColor = $(this).attr('chooseraidercolor');
		$.post('/account/change_user_color', {user_id: raidersColorsUserId, color: thisRaiderColor}, function(response) {
			if (response) {
				notify('Цвет пользователя задан!');
				$(raidersColorBlock).css('background-color', thisRaiderColor);
				raidersColorsTooltip.close();
			} else {
				notify('Ошибка! Цвет пользователя не задан!', 'error');
			}
		});
	});
	
	
	
	
	
	if ($('[ratingstatic]').length) {
		var ratingsStatics = [];
		$('[ratingstatic]').each(function() {
			var sData = $(this).attr('ratingstatic').split('|'),
				sTitle = sData[0],
				sIcon = sData[1];
			
			ratingsStatics.push({
				title: sTitle,
				icon: sIcon
			});
			
			popUp({
				title: 'Заполните коэффициенты!',
				width: 500,
				closeButton: 'Закрыть',
			}, function(ratingNotificationsWin) {
				ratingNotificationsWin.wait();
				getAjaxHtml('account/get_rating_notifications', {statics: ratingsStatics}, function(html) {
					ratingNotificationsWin.setData(html, false);
				}, function() {
					ratingNotificationsWin.wait(false);
				});
			});
				
		});
	}
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------------- Заказ оплаты
	$('[paymentorder]').on(tapEvent, function() {
		popUp({
			title: 'Заказ оплаты',
		    width: 700,
		    buttons: [{id: 'paymentOrderSendBtn', title: 'Отправить'}],
		    buttonsAlign: 'right',
		    disabledButtons: false,
		    closePos: 'right',
		    closeByButton: false,
		    closeButton: 'Отмена'
		}, function(paymentOrderWin) {
			paymentOrderWin.setData('account/paymentorder/get_form', function() {
				$('#paymentOrderSendBtn').on(tapEvent, function() {
					$('#paymentOrderForm').formSubmit({
						url: 'account/paymentorder/add',
						beforeSend: function() {
							paymentOrderWin.wait();
						},
						formError: function(err) {
							paymentOrderWin.wait(false);
							console.log(err);
						},
						success: function() {
							paymentOrderWin.close();
							notify('Заявка успешно отправлена!');
						},
						error: function() {
							paymentOrderWin.wait(false);
							notify('Ошибка отправки заявки', 'error');
						}
					});
				});
			});
			
			//fields_pay_setting
			
			
			/*$.post('/admin/add_pay_item', response).fail(function(e) {
				console.log(e.responseText);
			}).fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
			});*/
			
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------ Подарки
	if (getCookie('gifts')) {
		$('[giftscounter]').text(getCookie('gifts'));
		$('[getgifts]').addClass('leftblocktopicon_active');
		$('[getgifts]').attr('title', 'Вам подарки!');
		
		
		$('[getgifts]').on(tapEvent, function() {
			popUp({
				title: false,
				width: 500,
				winClass: 'giftwin'
			}, function(giftsWin) {
				giftsWin.setData('gifts/show_message', function() {
					$('#getGifts').on(tapEvent, function() {
						(function getGift() {
							giftsWin.setData('gifts/get_gift', function() {
								
								$('#takeGiftBtn').on(tapEvent, function() {
									let giftId = $(this).attr('giftid');
									$.post('/gifts/take_gift', {gift_id: giftId}, function(response) {
										if (response) {
											giftsWin.setData('gifts/gift_success', function() {
												if (!getCookie('gifts')) $('[getgifts]').setAttrib('hidden');
												
												$('#getNextGiftBtn').on(tapEvent, function() {
													getGift();
												});
												
												$('#closeGiftsWinBtn').on(tapEvent, function() {
													giftsWin.close();
												});
											});
										} else {
											notify('Ошибка получения подарка, попробуйте еще раз', 'error');
										}
									});
								});
								
								$('#closeGiftsWinBtn').on(tapEvent, function() {
									giftsWin.close();
								});
							});
						})();
					});
				});
			});
		});
	}
	
	
	
	
	//------------------------------------------------------------------ Сообщения
	$.post('messages/account/status', {user_id: getCookie('id')}, function(response) {
		if (response.all > 0) {
			$('[newmessages]').addClass('leftblocktopicon_stendby');
		}
		
		if (response.unread > 0) {
			$('[newmessagecounter]').text(response.unread);
			$('[newmessages]').addClass('leftblocktopicon_active');
			$('[newmessages]').attr('title', 'У Вас новые сообщения!');
		}
	}, 'json').fail(function(e) {
		showError(e);
		notify('Системная ошибка!', 'error');
	});	
	
	
	$('[newmessage]').on(tapEvent, function() {
		popUp({
			title: 'Уведомления|4',
		    width: 600,
		    closeButton: 'Закрыть'
		}, function(newMessageWin) {
			(function openMessagesList() {
				newMessageWin.setData('messages/account/list', {user_id: getCookie('id')}, function() {
					newMessageWin.setWidth(600);
					newMessageWin.setButtons([], 'Отмена'); 
					ddrInitTabs('userMessages');
				
					$('[usersmessagesshow]').on(tapEvent, function() {
						let d = $(this).attr('usersmessagesshow').split('|'),
							messId = d[0],
							stat = d[1];
						
						newMessageWin.setData('messages/account/get', {id: messId, user_id: getCookie('id')}, function() {
							newMessageWin.setWidth(1000);
							if (stat == 0) newMessageWin.setButtons([{id: 'setReadStstBtn', title: 'Прочитал(а)'}], 'Отмена');
							else newMessageWin.setButtons([{id: 'usersMessagesGoBack', title: 'Назад'}], 'Отмена'); 
							
							$('#setReadStstBtn').on(tapEvent, function() {
								$.post('messages/account/set_read', {id: messId, user_id: getCookie('id')}, function(response) {
									if (response) {
										let countUnread = parseInt($('[newmessagecounter]').text(response.unread));
										if (countUnread > 1) {
											$('[newmessagecounter]').text(--countUnread);
										} else {
											$('[newmessagecounter]').text('0');
											$('[newmessages]').removeClass('leftblocktopicon_active');
											$('[newmessages]').attr('title', 'Сообщения от администрации');
										}
										socket.emit('usersmessages:read', messId);
									} else {
										notify('Ошибка изменения статуса прочтения!', 'error');
									}
								}).fail(function(e) {
									showError(e);
									notify('Системная ошибка!', 'error');
								});
								openMessagesList();
							});
							
							$('#usersMessagesGoBack').on(tapEvent, function() {
								openMessagesList();
							});
						});
					});
				});
			})();
				
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------ Очереди открытия модальных окон
	
	
	if (getCookie('gifts')) { // подарки
		
		
	} else if (getCookie('birthday')) { // День рождения
		
		popUp({
			title: 'Дата рождения|5',
			width: 450,
		    buttons: [{id: 'setBirthDayDataBtn', title: 'Применить'}],
		    buttonsAlign: 'right',
		    disabledButtons: true,
		    closePos: 'left',
		    closeByButton: true,
		    closeButton: 'Отмена',
		    contentToCenter: true,
		}, function(birthDayDataBtnWin) {
			birthDayDataBtnWin.setData('account/birthday/get_form', function() {
				
				let dateVal;
				$('#userBirthdayDate').datepicker({
			        dateFormat:         'd M yy г.',
			        yearRange:          "1900:"+(new Date().getFullYear() + 1),
			        numberOfMonths:     1,
			        changeMonth:        true,
			        changeYear:         true,
			        monthNamesShort:    ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
			        dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
			        firstDay:           1,
			        minDate:            new Date(1900, 0, 1, 0, 0, 0),
			        maxDate:            0,
			        onSelect: function(stringDate, dateObj) {
			        	let monthes = ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
			        	dateStr = dateObj.currentDay+' '+monthes[dateObj.currentMonth]+' '+dateObj.currentYear+' г.',
			        	d = ('0'+dateObj.currentDay).substr(-2),
			        	m = ('0'+(dateObj.currentMonth+1)).substr(-2);
			        	
			        	dateVal = d+'-'+m+'-'+dateObj.currentYear;
			        	$('#userBirthdayDate').val(dateStr);
			        	birthDayDataBtnWin.enabledButtons();
			        }
			    });
			    
			    
			    
			    $('#setBirthDayDataBtn').on(tapEvent, function() {
			    	birthDayDataBtnWin.dialog('<p>Внимание! Дата задается один раз и изменить ее будет нельзя!<small>Информация будет доступна только администратору</small>', 'Задать', 'Отмена', function() {
			    		birthDayDataBtnWin.wait();
			    		let closeBDTOut;
				    	clearTimeout(closeBDTOut);
				    	$.post('account/birthday/set', {date: dateVal}, function(response) {
				    		if (response) {
				    			birthDayDataBtnWin.setData('<h3 class="fz20px mt10px">Дата успешно задана!</h3>', false);
				    			birthDayDataBtnWin.setButtons([]);
				    			birthDayDataBtnWin.dialog(false);
				    			closeBDTOut = setTimeout(function() {
				    				birthDayDataBtnWin.close();
				    			}, 10000);
				    		} else {
				    			notify('Ошибка! Дата не задана, повторите еще раз!', 'error');
				    		}
				    		birthDayDataBtnWin.wait(false);
				    	}).fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
			    	});	
			    });
			});
		});
		
	}
	
	
	
	
	
	
	
	
	
		
	
	
	
	
	
	
	
	
	
	
	
});