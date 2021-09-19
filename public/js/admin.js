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
			
			
			$('#startPageNav').find('li').on(tapEvent, function() {
				var thisSection = $(this).data('block');
				location.hash = '#'+thisSection;
				$(window).one('hashchange', function() {
					renderSection();
					$('nav.main_nav').find('li').removeClass('active');
					$('nav.main_nav').find('li[data-block="'+thisSection+'"]').addClass('active');
				});
			});
			
			
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
			$(document).trigger('renderSection', section);
			if (callback) callback();
		}, 'html').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	};
	
	
	
	
	// -------------------------------------------------------------------- Автозагрузка section при загрузке страницы и установка tabs 
	if ($('.auth_form').length == 0) {
		/*if (location.hash == '') {
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
		}*/
		
		var hashData = location.hash.substr(1, location.hash.length).split('.'),
			section = hashData[0];
		$('li[data-block="'+section+'"]').addClass('active');
		renderSection();
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
	
	
	
	
	// при одиночном выборе не иметь возможность выбирать уже выбранных участников !!!
	
	usersManager = function(params) {
		let ops = $.extend({
			title: 'Менеджер участников', // Заголовок окна
			choosedStatic: false, // последний выбранный статик
			choosedUsers: false, // выбранные участники: объект [{user:..., static:..., ...}] или функция с коллбэком, в которые передаются данные: [{user:..., static:..., ...}] 
			chooseType: 'single', // multiple Тип выборки одиночный или множественный
			returnFields: false, // при выборе участников какие поля вывести
			onChoose: false, // возвращает выбранных участников
			closeToChoose: false, // Закрыть после выбора участников
			closePos: 'left'
		}, params),
		usersManagerWin,
		choosedUsers = typeof ops.choosedUsers == 'object' ? ops.choosedUsers : [],
		initialUsers = choosedUsers.map(function(item) {return item.user}),
		initialStatic = false,
		stUsersCounter = {},
		sUTOut,
		isDisableBtn = ops.choosedUsers ? 0 : 1;
		
		popUp({
			title: ops.title,
		    width: 900,
		    winClass: 'usersmanager',
		    buttons: ops.chooseType == 'multiple' ? [{id: 'chooseUsers', title: 'Выбрать', disabled: isDisableBtn}] : false,
		    closePos: ops.closePos,
		    closeButton: 'Закрыть',
		}, function(uMWin) {
			usersManagerWin = uMWin;
			usersManagerWin.wait();
			
			if (typeof ops.choosedUsers == 'function') {
				ops.choosedUsers(function(data) {
					choosedUsers = data;
					initialUsers = data.map(function(item) {return item.user});
					init();
				});
			} else {
				init();
			}
		});
		
		
		
		// ----------------------------------------------------- Функции
		
		function init() {
			getAjaxHtml('admin/usersmanager/init', {choose_type: ops.chooseType}, function(html) {
				usersManagerWin.setData(html, false);
				
				if (choosedUsers) {
					choosedUsers.forEach(function(item, index) {
						let static = parseInt(item.static);
						if (stUsersCounter[static] === undefined) stUsersCounter[static] = 0;
						stUsersCounter[static] += 1;
					});
					
					$.each(stUsersCounter, function(static, count) {
						$('[umstatic="'+static+'"]').find('[countchoosedusers]').text(count);
						$('[umstatic="'+static+'"]:not(.haschoosed)').addClass('haschoosed');
					});
				}
				
				
				initialStatic = getSavedStatic();
				
				if (initialStatic) {
					usersWait();
					getUsers(initialStatic, choosedUsers, function(html) {
						$('[umstatic="'+initialStatic+'"]').addClass('choosed');
						$('#usersmanagerUsers').html(html);
						$('#usersmanagerChoosedTotal').text(choosedUsers.length);
						manageButtons();
						usersWait(false);
					});
				} else {
					$('#usersmanagerUsers').html('<div class="usersmanager__empty"><p class="empty center">Нет участников</p></div>');
					$('#usersmanagerStatics').html('<div class="usersmanager__empty"><p class="empty center">Нет статиков</p></div>');
				}
				
				
				
				$('#usersmanagerSearch').on('keyup', function() {
					clearTimeout(sUTOut);
					sUTOut = setTimeout(function() {
						filterUsersStatics();
					}, 500);
				});
				
				
				
				$('#usersmanagerRanks').on('change', function() {
					filterUsersStatics();
				});
				
				
				
				$('#usersmanagerStatics').on(tapEvent, '[umstatic]:not(.choosed)', function() {
					let staticId = parseInt($(this).attr('umstatic'));
					$('[umstatic].choosed').removeClass('choosed');
					usersWait();
					getUsers(staticId, choosedUsers, function(html) {
						$('[umstatic="'+staticId+'"]').addClass('choosed');
						$('#usersmanagerUsers').html(html);
						stUsersCounter[staticId] = stUsersCounter[staticId] || 0;
						saveChoosedStatic(staticId);
						manageButtons();
						usersWait(false);
					});
				});
				
				
				
				$('#usersmanagerUsers').on(tapEvent, '[umuser]:not(.choosed_single)', function() {
					let thisItem = this,
						d = $(thisItem).attr('umuser').split('|'),
						static = parseInt(d[0]),
						user = parseInt(d[1]),
						isChoosed = $(thisItem).hasClass('choosed');
					
					if (ops.chooseType == 'multiple') {
						if (isChoosed) {
							let index = searchInObject(choosedUsers, 'user', user);
							choosedUsers.splice(index, 1);
							$(thisItem).removeClass('choosed');
							$('#usersmanagerChoosedTotal').text(choosedUsers.length);
							
							stUsersCounter[static] -= 1;
							$('[umstatic="'+static+'"]').find('[countchoosedusers]').text(stUsersCounter[static]);
							if (stUsersCounter[static] == 0) $('[umstatic="'+static+'"]').removeClass('haschoosed');
						} else {
							choosedUsers.push({
								user: user,
								static: static
							});
							$(thisItem).addClass('choosed');
							$('#usersmanagerChoosedTotal').text(choosedUsers.length);
							
							if (stUsersCounter[static] === undefined) stUsersCounter[static] = 0;
							stUsersCounter[static] += 1;						
							$('[umstatic="'+static+'"]').find('[countchoosedusers]').text(stUsersCounter[static]);
							if (stUsersCounter[static] > 0) $('[umstatic="'+static+'"]:not(.haschoosed)').addClass('haschoosed');
						}
						
						manageButtons();
						
					} else {
						if (ops.returnFields) {
							getUsersFull([{static: static, user: user}], ops.returnFields, function(usersData) {
								ops.onChoose(usersData, usersManagerWin);
								if (ops.closeToChoose) usersManagerWin.close();
							}, function() {
								usersManagerWin.wait(false);
							});
						} else {
							ops.onChoose({static: static, user: user}, usersManagerWin);
							if (ops.closeToChoose) usersManagerWin.close();
						}
					}	
				});
				
				
				
				// 
				$('#uMCheckAllStatic').on(tapEvent, function() {
					if ($(this).hasAttrib('disabled')) return false;
					checkAllUsersStatic();
				});
				
				// 
				$('#uMUncheckAllStatic').on(tapEvent, function() {
					if ($(this).hasAttrib('disabled')) return false;
					unCheckAllUsersStatic();
				});
				
				// 
				$('#uMCheckAll').on(tapEvent, function() {
					if ($(this).hasAttrib('disabled')) return false;
					checkAllUsers();
				});
				
				// 
				$('#uMUncheckAll').on(tapEvent, function() {
					if ($(this).hasAttrib('disabled')) return false;
					unCheckAllUsers();
				});
				
				
				$('#chooseUsers').on(tapEvent, function() {
					usersManagerWin.wait();
					let ouputData = [];
					
					if (initialUsers) {
						ouputData = choosedUsers.filter(function(item) {
							if (initialUsers.indexOf(item.user) == -1) return true;
						});
					} else {
						ouputData = choosedUsers;
					}
					
					if (ops.returnFields) {
						getUsersFull(ouputData, ops.returnFields, function(usersData) {
							ops.onChoose(usersData, usersManagerWin);
							if (ops.closeToChoose) usersManagerWin.close();
						}, function() {
							usersManagerWin.wait(false);
						});
					} else {
						ops.onChoose(ouputData, usersManagerWin);
						if (ops.closeToChoose) usersManagerWin.close();
					}
				});
				
			}, function() {
				usersManagerWin.wait(false);
			});
		}
		
		
		
		
		function getUsersFull(users, fields, callback, always) {
			$.post('/admin/usersmanager/get_users_full', {users: users, fields: fields}, function(usersData) {
				callback(usersData);
			}, 'json').fail(function(e) {
				always();
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		}
		
		
		
		function getUsers(staticId, choosedUsers, callback) {
			if (!staticId) {
				callback('');
				return false;
			}
			
			let usersIds = [],
				nickName = $('#usersmanagerSearch').val() || null,
				rank = $('#usersmanagerRanks').val() || null;
			
			if (choosedUsers) {
				usersIds = choosedUsers.map(function(item) {
					return item['user'];
				});
			}
			
			getAjaxHtml('admin/usersmanager/get_users', {static_id: staticId, choosed_users_ids: usersIds, choose_type: ops.chooseType, nickname: nickName, rank: rank}, function(html) {
				if (callback && typeof callback == 'function') callback(html);
			}, function() {});
		}
		
		
		
		function filterUsersStatics() {
			usersWait();
			staticsWait();
			
			let nickName = $('#usersmanagerSearch').val(),
				rank = $('#usersmanagerRanks').val();
			getAjaxHtml('admin/usersmanager/get_statics', {nickname: nickName, rank: rank}, function(html) {
				$('#usersmanagerStatics').html(html);
				$('#usersmanagerCountAllUsers').text($('#usersmanagerStatics').find('#countAllUsers').val());
				initialStatic = getSavedStatic();
				$('#usersmanagerStatics').find('[umstatic="'+initialStatic+'"]:not(.choosed)').addClass('choosed');
				staticsWait(false);
			}, function() {
				getUsers(initialStatic, choosedUsers, function(html) {
					if (html) {
						$('#usersmanagerUsers').html(html);
						$('#usersmanagerChoosedTotal').text(choosedUsers.length);
						manageButtons();
					} else {
						$('#usersmanagerUsers').html('<div class="usersmanager__empty"><p class="empty center">Нет участников</p></div>')
					}
					usersWait(false);
				});
			});
		}
		
		
		
		
		function saveChoosedStatic(static) {
			localStorage.setItem('usersManagerStatic', static);
		}
		
		
		function getSavedStatic() {
			let savedStatic = localStorage.getItem('usersManagerStatic');
			if (savedStatic && $('#usersmanagerStatics').find('[umstatic="'+savedStatic+'"]').length) return savedStatic; 
			
			let firstStaticInList = $('#usersmanagerStatics').find('[umstatic]:first');
			if ($(firstStaticInList).length) {
				let firstStId = $(firstStaticInList).attr('umstatic');
				if (firstStId) return parseInt(firstStId);
			}
			return false;
		}
		
					
		function checkAllUsers() {
			let nickName = $('#usersmanagerSearch').val() || null;
				rank = $('#usersmanagerRanks').val() || null;
			$.post('/admin/usersmanager/check_all_users', {nickname: nickName, rank: rank}, function(allUsers) {
				stUsersCounter = {};
				allUsers.forEach(function(user) {
					if (stUsersCounter[user.static] === undefined) stUsersCounter[user.static] = 0;
					stUsersCounter[user.static] += 1;
				});
				
				$.each(stUsersCounter, function(static, count) {
					$('[umstatic="'+static+'"]').find('[countchoosedusers]').text(count);
					$('[umstatic="'+static+'"]:not(.haschoosed)').addClass('haschoosed');
				});
				
				$('#usersmanagerChoosedTotal').text(allUsers.length);
				$('#usersmanagerUsers').find('[umuser]:not(.choosed)').addClass('choosed');
				
				choosedUsers = allUsers;
				
				$('#uMCheckAll:not([disabled])').setAttrib('disabled');
				$('#uMUncheckAll[disabled]').removeAttrib('disabled');
				manageButtons();
				
			}, 'json').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		}
		
		
		function unCheckAllUsers() {
			stUsersCounter = {};
			choosedUsers = [];
			
			$('[umstatic]').find('[countchoosedusers]').text(0);
			$('[umstatic].haschoosed').removeClass('haschoosed');
			
			$('#usersmanagerChoosedTotal').text(0);
			
			$('#usersmanagerUsers').find('[umuser].choosed').removeClass('choosed');
			manageButtons();
		}
		
		
		
		
		function checkAllUsersStatic() {
			let currentStatic = parseInt($('[umstatic].choosed').attr('umstatic'));
			$('#usersmanagerUsers').find('[umuser]:not(.choosed)').each(function() {
				let thisItem = this,
					d = $(thisItem).attr('umuser').split('|'),
					static = parseInt(d[0]),
					user = parseInt(d[1]);
				
				choosedUsers.push({
					user: user,
					static: static
				});
			
				if (stUsersCounter[static] === undefined) stUsersCounter[static] = 0;
				stUsersCounter[static] += 1;
				
				$(thisItem).addClass('choosed');
			});
			
			$('[umstatic="'+currentStatic+'"]').find('[countchoosedusers]').text($('#usersmanagerUsers').find('[umuser].choosed').length);
			$('[umstatic="'+currentStatic+'"]:not(.haschoosed)').addClass('haschoosed');
			manageButtons()
			$('#usersmanagerChoosedTotal').text(choosedUsers.length);
		}
		
		
		
		
		function unCheckAllUsersStatic() {
			let currentStatic = parseInt($('[umstatic].choosed').attr('umstatic'));
			$('#usersmanagerUsers').find('[umuser].choosed').each(function() {
				let thisItem = this,
					d = $(thisItem).attr('umuser').split('|'),
					static = parseInt(d[0]),
					user = parseInt(d[1]);
				
				let index = searchInObject(choosedUsers, 'user', user);
				choosedUsers.splice(index, 1);
			
				if (stUsersCounter[static] !== undefined) stUsersCounter[static] -= 1;
				
				$(thisItem).removeClass('choosed');
			});
			
			$('[umstatic="'+currentStatic+'"]').find('[countchoosedusers]').text(0);
			$('[umstatic="'+currentStatic+'"].haschoosed').removeClass('haschoosed');
			manageButtons();
			$('#usersmanagerChoosedTotal').text(choosedUsers.length);
		}
		
		
		
		function staticsWait(stat) {
			if (stat === undefined) {
				$('#staticsWait').addClass('usersmanager__wait_visible');
			} else if (stat == false) {
				$('#staticsWait').removeClass('usersmanager__wait_visible');
			}
		}
		
		function usersWait(stat) {
			if (stat === undefined) {
				$('#usersWait').addClass('usersmanager__wait_visible');
			} else if (stat == false) {
				$('#usersWait').removeClass('usersmanager__wait_visible');
			}
		}
		
		
		
		function manageButtons() {
			let countAll = $('#usersmanagerTotal').val(),
				countChoosedAll = choosedUsers.length,
				countInStatic = $('#usersmanagerUsers').find('[umuser]').length,
				countChoosedInStatic = $('#usersmanagerUsers').find('[umuser].choosed').length;
			
			if (countAll == 0) return false;
			
			if (countChoosedAll < countAll) {
				$('#uMCheckAll[disabled]').removeAttrib('disabled');
				$('#uMUncheckAll[disabled]').removeAttrib('disabled');
			} 
			
			if (countChoosedAll == 0) $('#uMUncheckAll:not([disabled])').setAttrib('disabled');
			if (countAll == countChoosedAll) $('#uMUncheckAll[disabled]').removeAttrib('disabled');
			
			
			
			if (countInStatic) $('#uMCheckAllStatic[disabled]').removeAttrib('disabled');
			else $('#uMCheckAllStatic:not([disabled])').setAttrib('disabled');
			
			if (countChoosedInStatic) $('#uMUncheckAllStatic[disabled]').removeAttrib('disabled');
			else $('#uMUncheckAllStatic:not([disabled])').setAttrib('disabled');
			
			if (countInStatic == countChoosedInStatic) $('#uMCheckAllStatic:not([disabled])').setAttrib('disabled');
			else $('#uMCheckAllStatic[disabled]').removeAttrib('disabled');
			
			if (countChoosedAll) $('#chooseUsers[disabled]').removeAttrib('disabled');
			else $('#chooseUsers:not([disabled])').setAttrib('disabled');
		}
						
						
		
		return usersManagerWin;
		
	};
	
	
	
	
	
	
	
	
	
	
	
	
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