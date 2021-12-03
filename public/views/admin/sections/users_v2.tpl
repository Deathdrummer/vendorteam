<div class="section" id="usersV2">
	<div class="section_title noselect">
		<div class="d-flex">
			<h2 class="mr3px">Участники</h2>
			<sup class="grayblue fz14px">версия 2</sup>
		</div>
		
		
		
		<div class="align-items-center ml40px mr-auto">
			<p class="fz14px mb3px uppercase">В списке: <strong id="totalUsers">----</strong></p>
			<p class="fz14px uppercase">Онлайн: <strong id="onlineUsersCount">----</strong></p>
		</div>
		
			
		
		
		<div class="usersv2showlists mr40px" id="usersv2ShowLists">
			<div class="usersv2showlists__item" title="Верифицированные">
				<input type="checkbox" id="usersv2showlistsVerify" usersv2showlist="verify">
				<label for="usersv2showlistsVerify">В</label>
			</div>
			
			<div class="usersv2showlists__item" title="Новые">
				<input type="checkbox" id="usersv2showlistsNew" usersv2showlist="new">
				<label for="usersv2showlistsNew">Н</label>
			</div>
			
			<div class="usersv2showlists__item" title="Отстраненные">
				<input type="checkbox" id="usersv2showlistsExcluded" usersv2showlist="excluded">
				<label for="usersv2showlistsExcluded">О</label>
			</div>
			
			<div class="usersv2showlists__item" title="Удаленные">
				<input type="checkbox" id="usersv2showlistsDeleted" usersv2showlist="deleted">
				<label for="usersv2showlistsDeleted">У</label>
			</div>
		</div>
		
		
		<div class="select w100px mr3px">
			<select id="usersv2SearchField" class="fz12px h32px">
				<option value="nickname">Никнейм</option>
				<option value="payment">Плат. данные</option>
			</select>
			<div class="select__caret"></div>
		</div>
		<div class="field w200px mr3px">
			<input type="text" id="usersv2SearchStr" class="h32px" placeholder="Поиск..." autocomplete="off">
		</div>
		<div class="buttons notop mr40px">
			<button id="usersv2SearchReset" class="remove" title="Сбросить" disabled><i class="fa fa-ban"></i></button>
		</div>
		
		
		<div class="buttons notop">
			<button id="usersv2FielsdBtn" title="Столбцы"><i class="fa fa-columns"></i></button>
			<button id="usersv2StaticsBtn" title="Статики"><i class="fa fa-bars"></i></button>
			<button id="usersv2SettingsBtn" title="Настройки отображения"><i class="fa fa-sliders"></i></button>
		</div>
	</div>
	
	

	<ul class="usersv2staticstabs noselect mb20px" id="usersv2StaticsTabs"></ul>
	
	
	<div class="section__content" id="sectionContent">
		<div class="usersv2">
			<table id="usersTable">
				<thead class="h40px">
					<tr id="usersTableThead"></tr>
				</thead>
				<tbody id="usersList"></tbody>
			</table>
		</div>
	</div>
</div>




<script type="text/javascript"><!--
$(function() {
	
	if (location.hostname != 'localhost') {
		socket.on('set_online_user', (userId, users) => {
			let countUsersOnline = Object.keys(users).length;
			$('#usersList').find('[userid="'+userId+'"]').find('.avatar').addClass('avatar_online').attr('title', 'Онлайн');
			$('#onlineUsersCount').text(countUsersOnline);
		});
		
		socket.on('set_offline_user', (userId, users) => {
			$('#usersList').find('[userid="'+userId+'"]').find('.avatar').removeClass('avatar_online').removeAttrib('title');
			let countUsersOnline = Object.keys(users).length;
			$('#onlineUsersCount').text(countUsersOnline);
		});
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	let saveFieldTimeout = 500, // таймаут сохранение значения поля
		scrollOffset = 0,
		isEndOfList = false,
		searchField,
		searchStr,
		sortField,
		sortOrder,
		checkedShowLists,
		usersTable = $('#usersTable').ddrTable({
			minHeight: '52px',
			maxHeight: 'calc(100vh - 310px)',
			onScrollBottom: function() {
				scrollOffset += 1;
				getUsers();
			},
			latency: 100
		});
	
	if (!ddrStore('usersv2:selected_statics')) ddrStore('usersv2:current_static', false);
	
	getStaticsTabs(function() {
		getUsers(true);
	});
	
	$('#usersv2UpdateList').on(tapEvent, function() {
		getUsers();
	});
	
	
	

	//---------------------------------------------------- Столбцы
	$('#usersv2FielsdBtn').on(tapEvent, function() {
		let fieldsData = ddrStore('usersv2:selected_fields'),
			setReload = false;
		popUp({
			title: 'Столбцы|4',
			width: 600,
			closePos: 'left',
			closeButton: 'Закрыть',
			onClose: function() {
				if (setReload) {
					ddrStore('usersv2:selected_fields', fieldsData);
					getUsers(true);
				}
			},
			winClass: false,
		}, function(usersFieldsWin) {
			usersFieldsWin.setData('users/fields', {selected_fields_keys: ddrStore('usersv2:selected_fields')}, function() {
				
				new Sortable($('#usersFieldsAll')[0], {
					group: 'shared',
					animation: 150,
					sort: false
				});

				new Sortable($('#usersFieldsToTable')[0], {
					group: 'shared',
					animation: 150,
					onSort: function(data) {
						setReload = true;
						fieldsData = [];
						$('#usersFieldsToTable').find('[userslistfield]').each(function(k) {
							fieldsData.push($(this).attr('userslistfield'));
						});
					}
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	//---------------------------------------------------- Статики
	let reloadUsersStatics = false;
	$('#usersv2StaticsBtn').on(tapEvent, function() {
		popUp({
			title: 'Статики|4',
			width: 700,
			closePos: 'left',
			closeButton: 'Закрыть',
			onClose: function() {
				if (reloadUsersStatics) {
					reloadUsersStatics = false;
					$('#usersv2SearchStr').val('');
					searchStr = null;
					sortField = null;
					getStaticsTabs(function() {
						getUsers(true);
					});
				}	
			}
		}, function(usersStaticsWin) {
			usersStaticsWin.setData('users/statics', {selected_statics: ddrStore('usersv2:selected_statics')}, function() {
				
				
				$('#usersv2StaticsGroups').find('[usersv2groupbtn]').on(tapEvent, function() {
					let group = $(this).attr('usersv2groupbtn');
					
					$('#usersv2StaticsGroups').find('button').removeClass('active');
					$(this).addClass('active');
					
					$('#usersv2StaticsList').find('[usersv2staticgroup]').each(function() {
						if (group == 'all') $(this).setAttrib('checked');
						else if (group == 'none') $(this).removeAttrib('checked');
						else {
							if ($(this).attr('usersv2staticgroup') == group) $(this).setAttrib('checked');
							else $(this).removeAttrib('checked');
						}
					});
					
					reloadUsersStatics = true;
					setCheesedStaticsIds();
				});
				
				
				$('#usersv2StaticsList').find('[usersv2static]').on('change', function() {
					reloadUsersStatics = true;
					setCheesedStaticsIds();
				});
				
				
				function setCheesedStaticsIds() {
					let selectedStatics = [];
					$('#usersv2StaticsList').find('[usersv2static]:checked').each(function() {
						let stId = $(this).attr('usersv2static');
						selectedStatics.push(isInt(stId) ? parseInt(stId) : stId);
					});
					
					ddrStore('usersv2:selected_statics', selectedStatics);
					if (selectedStatics.length) ddrStore('usersv2:current_static', selectedStatics.shift());
					else ddrStore('usersv2:current_static', null);
				}
				
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	$('#usersv2StaticsTabs').on(tapEvent, '[usersv2tabsstatic]', function() {
		if ($(this).hasClass('usersv2staticstabs__item_active')) return false;
		let staticId = $(this).attr('usersv2tabsstatic');
		$('#usersv2StaticsTabs').find('.usersv2staticstabs__item_active').removeClass('usersv2staticstabs__item_active');
		$(this).addClass('usersv2staticstabs__item_active');
		ddrStore('usersv2:current_static', staticId);
		getUsers(true);
	});
	
	
	
	
	
	
	
	
	
	let usersv2Search;
	$('#usersv2SearchStr').on('keyup', function() {
		clearTimeout(usersv2Search);
		usersv2Search = setTimeout(function() {
			$('#usersv2SearchReset').removeAttrib('disabled');
			sortField = null;
			findUsers();
		}, 500);
	});
	
	$('#usersv2SearchField').on('change', function() {
		if ($('#usersv2SearchStr').val()) {
			$('#usersv2SearchReset').removeAttrib('disabled');
			sortField = null;
			findUsers();
		} 
	});
	
	
	
	$('#usersv2SearchReset').on(tapEvent, function() {
		$('#usersv2SearchStr').val('');
		searchStr = null;
		sortField = null;
		ddrStore('usersv2:selected_statics', false);
		ddrStore('usersv2:current_static', false);
		getStaticsTabs(function() {
			getUsers(true);
		});
		$('#usersv2SearchReset').setAttrib('disabled');
	});
	
	
	
	
	
	
	
	
	$('#usersv2SettingsBtn').on(tapEvent, function() {
		popUp({
			title: 'Настройки|4',
			width: 600,
			closeButton: 'Закрыть',
			onClose: function() {
				
			},
		}, function(usersv2SettingsWin) {
			
		});
	});
	
	
	
	
	
	
	$('#usersTableThead').on(tapEvent, '[usersv2field]', function() {
		currentSortField = $(this).attr('usersv2field');
		
		if (currentSortField != sortField) {
			sortField = currentSortField;
			sortOrder = 'ASC';
		} else {
			sortOrder = sortOrder != 'DESC' ? 'DESC' : 'ASC';
		}
		
		getUsers(true);
	});
	
	
	
	
	
	$('#usersv2ShowLists').find('[usersv2showlist]').on('change', function() {
		checkedShowLists = [];
		$('#usersv2ShowLists').find('[usersv2showlist]:checked').each(function() {
			checkedShowLists.push($(this).attr('usersv2showlist'));
		});
		getUsers(true);
	});
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------- Изменения значений всех инпутов селектов и чекбоксов
	
	$('#usersList').changeInputs(function(input) {
		let tr = $(input).closest('tr'),
			userId = $(tr).attr('userid'),
			field = $(input).attr('userfield'),
			type = $(input)[0].type.replace('select-one', 'select'),
			value = type == 'checkbox' ? $(input).is(':checked') : ($(input).hasAttrib('date') ? $(input).attr('date') : $(input).val());
			
		saveUserField({user_id: userId, field: field, value: value}, function() {
			$(input).addClass('changed');
			$(tr).addClass('changed');
		});
	});
	
	
	
	
	
	
	
	
	//------------- Карточка участника
	$('#usersList').on(tapEvent, '[userv2card]', function() {
		let userId = $(this).attr('userv2card'),
			nickname = $(this).closest('tr').find('[userfield="nickname"]').val() || 'без никнейма';
		
		popUp({
			title: 'Карточка участника <strong>'+nickname+'</strong>|4',
			width: 800,
			buttons: false, 
			buttonsAlign: 'right',
			disabledButtons: false,
			closePos: 'left',
			closeButton: 'Закрыть',
			onClose: false, // событие при закрытии окна
			winClass: false
		}, function(userCardWin) {
			userCardWin.setData('users/userinfo', {user_id: userId}, function() {
				$('#usersv2UserCard').ddrTable({
					minHeight: '50px',
					maxHeight: '300px'
				});
				
				$('#usersv2UserCardDeposit').number(true, 2, '.', ' ');
				
				let setDepositTOut;
				$('#usersv2UserCardDeposit').on('keyup', function() {
					let input = this;
					clearTimeout(setDepositTOut);
					setDepositTOut = setTimeout(function() {
						let deposit = parseFloat($(input).val());
						getAjaxJson('users/userinfo/change_deposit', {user_id: userId, deposit: deposit}, function(response) {
							if (!response) notify('Ошибка изменения резерва!', 'error');
							else $(input).parent().addClass('usersv2usercard__input_changed');
						});
					}, 300);
				});
			});
		});
	});
	
	
	
	
	
	










	
	
	
	
	
	
	//----------------------------------------------------
	
	let changeFieldTOut;
	function saveUserField(params, callback) {
		clearTimeout(changeFieldTOut);
		if (!params || Object.keys(params).length < 3) return false;
		
		changeFieldTOut = setTimeout(function() {
			getAjaxJson('/users/list/save', params, function(stat) {
				if (callback && typeof callback == 'function') callback(stat);
			});
		}, (saveFieldTimeout || 500));
	}
	
	
	
	
	function findUsers() {
		searchField = $('#usersv2SearchField').val(),
		searchStr = $('#usersv2SearchStr').val();
		if (searchStr.length < 2) return false;
		
		ddrStore('usersv2:selected_statics', false);
		ddrStore('usersv2:current_static', false);
		
		getStaticsTabs(function() {
			getUsers(true);
		});
	}
	
	
	
	
	function getStaticsTabs(callback) {
		getAjaxHtml('users/statics/tabs', {
			selected_statics: ddrStore('usersv2:selected_statics'),
			current_static: ddrStore('usersv2:current_static'),
			search_field: searchField,
			search_str: searchStr
		}, function(html, stat, headers) {
			if (stat) {
				ddrStore('usersv2:current_static', headers.current_static);
				$('#usersv2StaticsTabs').html(html);
			} else $('#usersv2StaticsTabs').html('');
			if (callback && typeof callback == 'function') callback();
		});
	}
	
	
	
	
	
	
	function setUserStatic(params, callback) {
		if (params == undefined || Object.keys(params).length < 3) return false;
		getAjaxJson('users/statics/set', params, function(stat) {
			if (callback && typeof callback == 'function') callback(stat);
		});
	}
	
	
	
	function setUserClass(params, callback) {
		if (params == undefined || Object.keys(params).length < 3) return false;
		getAjaxJson('users/classes/set', params, function(stat) {
			if (callback && typeof callback == 'function') callback(stat);
		});
	}
	
	
	
	
	
	
	let usersColorsTooltip, usersStaticsTooltip, usersClassesTooltip, usersPersonagesTooltip;
	function getUsers(reboot) {
		if (reboot === undefined && isEndOfList) return false;
		else if (reboot) {
			isEndOfList = false;
			scrollOffset = 0;
		}
		
		let fields = ddrStore('usersv2:selected_fields');
		
		$('.usersv2').addClass('usersv2__waiting');
		
		Promise.all([
			getAjaxJson('users/fields/to_head', {fields: fields}),
			getAjaxHtml('users/list', {
				offset: scrollOffset,
				fields: fields,
				static: ddrStore('usersv2:current_static'),
				search_field: searchField,
				search_str: searchStr,
				sort_field: sortField,
				sort_order: sortOrder,
				show_lists: checkedShowLists
			})
		]).then((data) => {
			if (reboot) $('#totalUsers').text(data[1]['headers']['total'] || 0);
			
			if (location.hostname != 'localhost') {
				socket.emit('take_users_online', users => {
					$.each(users, function(k, item) {
						$('#usersList').find('[userid="'+item['user_id']+'"]').find('.avatar').addClass('avatar_online').attr('title', 'Онлайн');
					});
					let countUsersOnline = Object.keys(users).length;
					$('#onlineUsersCount').text(countUsersOnline);
				});
			}
			
			
			let theadCols = '';
				theadCols += '<td class="w230px sorttd pointer" usersv2field="nickname"><strong>Участник</strong></td>';
				if (data[0]['json']) {
					$.each(data[0]['json'], function(field, fData) {
						theadCols += '<td usersv2field="'+field+'" class="sorttd pointer'+(fData.cls ? ' '+fData.cls : '')+'">';
						theadCols += fData.icon ? fData.icon : '<strong>'+fData.title+'</strong>';
						theadCols += '</td>';
					});
				}
			theadCols += '<td class="p0"></td>';
			theadCols += '<td class="w50px center" title="Статики"><strong>Стат</strong></td>';
			theadCols += '<td class="w50px center" title="Классы"><strong>Клс</strong></td>';
			theadCols += '<td class="w50px center" title="Персонажи"><strong>Перс</strong></td>';
			theadCols += '<td class="w110px"><strong>Опции</strong></td>';
			$('#usersTableThead').html(theadCols);
			
			
			if (data[1]['html']) {
				if (scrollOffset > 0) $('#usersList').append(data[1]['html']);
				else $('#usersList').html(data[1]['html']);
				if ((scrollOffset + 1) * data[1]['headers']['part'] >= data[1]['headers']['total']) isEndOfList = true;
				usersTable.reInit();
				if (reboot) usersTable.scroll(0, 500);
				
			} else {
				if (scrollOffset == 0) {
					let countCols = Object.keys(data[0]['json']).length + 2;
					$('#usersList').html('<tr><td colspan="'+countCols+'"><p class="empty center">Нет данных</p></td></tr>');
				} else {
					isEndOfList = true;
				}
			}
			
			if (sortField) $('[usersv2field="'+sortField+'"]').addClass('sorttd_active');
			
			usersTable.reInit();
			$('.usersv2').removeClass('usersv2__waiting');
			
			
			
			
			//-----------------------------------------------------------
			
			
			
			//------------- Удаление участника
			$('#usersList').off(tapEvent, '[deleteuser]').on(tapEvent, '[deleteuser]', function() {
				let btn = this,
					tr = $(btn).closest('tr'),
					userId = $(this).attr('deleteuser');
				getAjaxJson('users/list/delete', {user_id: userId}, function(response) {
					if (response) {
						notify('Участник успешно удален!');
						$(btn).replaceWith('<button class="small w28px pay done" returndeleteduser="'+userId+'" title="Вернуть удаленного участника"><i class="fa fa-level-up"></i></button>');
						$(tr).addClass('changed');
					} else {
						notify('Ошибка удалния участника!', 'error');
					}
				});
			});
			
			//------------- Вернуть удаленного участника
			$('#usersList').off(tapEvent, '[returndeleteduser]').on(tapEvent, '[returndeleteduser]', function() {
				let btn = this,
					tr = $(btn).closest('tr'),
					userId = $(this).attr('returndeleteduser');
				getAjaxJson('users/list/return_deleted', {user_id: userId}, function(response) {
					if (response) {
						notify('Участник успешно восстановлен!');
						$(btn).replaceWith('<button class="small w28px remove done" deleteuser="'+userId+'" title="Удалить участника"><i class="fa fa-ban"></i></button>');
						$(tr).addClass('changed');
					} else {
						notify('Ошибка восстановления участника!', 'error');
					}
				});
			});
			
			
			
			
			
			
			//------------- Отстранение участника
			$('#usersList').off(tapEvent, '[excludeuser]').on(tapEvent, '[excludeuser]', function() {
				let btn = this,
					tr = $(btn).closest('tr'),
					userId = $(this).attr('excludeuser');
				getAjaxJson('users/list/exclude', {user_id: userId}, function(response) {
					if (response) {
						notify('Участник успешно отстранен!');
						$(btn).replaceWith('<button class="small w28px pay done" returnexcludeduser="'+userId+'" title="Вернуть отстраненного участника"><i class="fa fa-user-o"></i><i class="icon fa fa-plus"></i></button>');
						$(tr).addClass('changed');
						$(btn).addClass('done');
					} else {
						notify('Ошибка отстранения участника!', 'error');
					}
				});
			});
			
			//------------- Вернуть отстраненного участника
			$('#usersList').off(tapEvent, '[returnexcludeduser]').on(tapEvent, '[returnexcludeduser]', function() {
				let btn = this,
					tr = $(btn).closest('tr'),
					userId = $(this).attr('returnexcludeduser');
				getAjaxJson('users/list/return_excluded', {user_id: userId}, function(response) {
					if (response) {
						notify('Участник успешно восстановлен!');
						$(btn).replaceWith('<button class="small w28px remove done" excludeuser="'+userId+'" title="Отстранить участника"><i class="fa fa-user-o"></i><i class="icon fa fa-ban"></i></button>');
						$(tr).addClass('changed');
						$(btn).addClass('done');
					} else {
						notify('Ошибка восстановления участника!', 'error');
					}
				});
			});
			
			
			
			
			
			
			
			
			
			
			
			
			
			//------------- Установка даты
			let monthes = ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'];
			$('#usersList').find('[date]').datepicker({
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
					dateToUser = dateObj.currentDay+' '+monthes[dateObj.currentMonth]+' '+dateObj.currentYear+' г.',
					d = ('0'+dateObj.currentDay).substr(-2),
					m = ('0'+(dateObj.currentMonth+1)).substr(-2);
					sysDate = d+'-'+m+'-'+dateObj.currentYear;
					field = $(dateObj.input).attr('userfield');
					userId = $(dateObj.input).closest('tr').attr('userid');
					
					$(dateObj.input).val(dateToUser);
					saveUserField({user_id: userId, field: field, value: sysDate}, function() {
						$(dateObj.input).setAttrib('date', sysDate);
						$(dateObj.input).addClass('changed');
						$(dateObj.input).closest('tr').addClass('changed');
					});
				}
			});
			
			
			
			
			//------------- Цвета участников
			if (usersColorsTooltip) usersColorsTooltip.destroy();
			usersColorsTooltip = new jBox('Tooltip', {
				attach: '[userv2color]',
				onOpen: function() {
					closeToolTips('colors');
				},
				trigger: 'click',
				closeOnMouseleave: true,
				addClass: 'raiderscolorswrap',
				outside: 'x',
				ignoreDelay: true,
				zIndex: 1200,
				pointer: 'top',
				//pointTo: 'left',
				position: {
				  x: 'right',
				  y: 'center'
				},
				ajax: {
					url: '/users/colors',
					data: {attr: 'chooseusersv2color'},
					type: 'POST',
					dataType: 'html',
					reload: true, //'strict',
					setContent: true,
					success: function (response) {
						//console.log(response);
						//this.setContent(response);
					},
					error: function () {
						this.setContent('<p class="error center">ошибка загрузки данных!</p>');
					}
				}
			});
			
			
			
			let colorTr, colorElem, rCUserId, rCColorsBlock;
			$('[userv2color]').on(tapEvent, function() {
				colorElem = this;
				colorTr = $(this).closest('tr');
				rCUserId = $(colorTr).attr('userid');
				rCColorsBlock = this;
			});
			
			
			$('body').off(tapEvent, '[chooseusersv2color]').on(tapEvent, '[chooseusersv2color]', function() {
				let color = $(this).attr('chooseusersv2color');
				getAjaxJson('users/colors/change', {user_id: rCUserId, color: color}, function(response) {
					if (response) {
						$(rCColorsBlock).css('background-color', color);
						$(colorTr).addClass('changed');
						$(colorElem).addClass('changed');
						usersColorsTooltip.close();
					} else {
						notify('Ошибка! Цвет пользователя не задан!', 'error');
					}
				});
			});
			
			
			
			
			
			
			
			//------------- Статики
			let uSUserId;
			if (usersStaticsTooltip) usersStaticsTooltip.destroy();
			usersStaticsTooltip = new jBox('Tooltip', {
				attach: '[userv2statics]',
				trigger: 'click',
				closeOnMouseleave: true,
				//addClass: '',
				onOpen: function() {
					closeToolTips('statics');
					usersStaticsTooltip.setContent('<div class="d-flex w250px h60vh align-items-center justify-content-center flex-column"><i class="fa fa-spinner fa-pulse fz22px"></i><p>Загрузка статиков...</p></div>');
				},
				outside: 'x',
				ignoreDelay: true,
				zIndex: 1200,
				repositionOnContent: true,
				pointer: 'top',
				//pointTo: 'left',
				position: {
				  x: 'left',
				  y: 'center'
				}
			});
			
			
			$('body').off(tapEvent, '[userv2statics]').on(tapEvent, '[userv2statics]', function() {
				let staticsBtn = this;
				uSUserId = $(this).attr('userv2statics');
				getAjaxHtml('users/statics/user', {user_id: uSUserId}, function(html) {
					usersStaticsTooltip.setContent(html);
					
					$('body').off('change', '[usersv2staticlistitem]').on('change', '[usersv2staticlistitem]', function() {
						let staticItem = this,
							static = $(staticItem).attr('usersv2staticlistitem'),
							isChecked = $(staticItem).is(':checked') ? 1 : 0;
						
						setUserStatic({user_id: uSUserId, static_id: static, stat: isChecked}, function() {
							if (!isChecked) {
								$(staticItem).siblings('label').find('[usersv2staticlider]').removeAttrib('checked');
								$(staticItem).siblings('label').find('[usersv2staticmain]').removeAttrib('checked');
							}
							setDoneStatics(staticsBtn);
						});
					});
					
					
					$('body').off('change', '[usersv2staticlider]').on('change', '[usersv2staticlider]', function() {
						let mainCheck = $(this).closest('li').children('input'),
							isChecked = $(this).is(':checked') ? 1 : 0,
							static = $(this).attr('usersv2staticlider');
						
						setUserStatic({user_id: uSUserId, static_id: static, lider: isChecked}, function() {
							if ($(mainCheck).is(':checked') == false) {
								$(mainCheck).setAttrib('checked');
							}
							setDoneStatics(staticsBtn);
						});
					});
					
					$('body').off('change', '[usersv2staticmain]').on('change', '[usersv2staticmain]', function() {
						let mainCheck = $(this).closest('li').children('input'),
							isChecked = $(this).is(':checked') ? 1 : 0,
							static = $(this).attr('usersv2staticmain');
							
						setUserStatic({user_id: uSUserId, static_id: static, main: isChecked}, function() {
							if ($(mainCheck).is(':checked') == false) {
								$(mainCheck).setAttrib('checked');
							}
							setDoneStatics(staticsBtn);
						});
					});
				});
			});
			
			// Добавить галочку к кнопке при выборе статиков
			function setDoneStatics(btn) {
				$(btn).addClass('done');
				$(btn).closest('tr').addClass('changed');
			}
			
			
			
			
			
			
			
			
			
			
			
			
			//------------- Классы
			let uCUserId;
			if (usersClassesTooltip) usersClassesTooltip.destroy();
			usersClassesTooltip = new jBox('Tooltip', {
				attach: '[userv2classes]',
				trigger: 'click',
				closeOnMouseleave: true,
				//addClass: '',
				onOpen: function() {
					closeToolTips('classes');
					usersClassesTooltip.setContent('<div class="d-flex w250px h200px align-items-center justify-content-center flex-column"><i class="fa fa-spinner fa-pulse fz22px"></i><p>Загрузка классов...</p></div>');
				},
				outside: 'x',
				ignoreDelay: true,
				zIndex: 1200,
				repositionOnContent: true,
				pointer: 'top',
				//pointTo: 'left',
				position: {
				  x: 'left',
				  y: 'center'
				}
			});
			
			
			
			$('body').off(tapEvent, '[userv2classes]').on(tapEvent, '[userv2classes]', function() {
				let classesBtn = this;
				uCUserId = $(this).attr('userv2classes');
				getAjaxHtml('users/classes/user', {user_id: uCUserId}, function(html) {
					usersClassesTooltip.setContent(html);
					
					$('body').off('change', '[usersv2classeslistitem]').on('change', '[usersv2classeslistitem]', function() {
						let staticItem = this,
							cls = $(staticItem).attr('usersv2classeslistitem'),
							isChecked = $(staticItem).is(':checked') ? 1 : 0;
						
						setUserClass({user_id: uCUserId, class_id: cls, stat: isChecked}, function() {
							if (!isChecked) {
								$(staticItem).siblings('label').find('[usersv2classesmentor]').removeAttrib('checked');
							}
							setDoneClasses(classesBtn);
						});
					});
					
					
					$('body').off('change', '[usersv2classesmentor]').on('change', '[usersv2classesmentor]', function() {
						let mentorCheck = $(this).closest('li').children('input'),
							isChecked = $(this).is(':checked') ? 1 : 0,
							cls = $(this).attr('usersv2classesmentor');
						
						setUserClass({user_id: uCUserId, class_id: cls, mentor: isChecked}, function() {
							if ($(mentorCheck).is(':checked') == false) {
								$(mentorCheck).setAttrib('checked');
							}
							setDoneClasses(classesBtn);
						});
					});
				});
			});
			
			// Добавить галочку к кнопке при выборе статиков
			function setDoneClasses(btn) {
				$(btn).addClass('done');
				$(btn).closest('tr').addClass('changed');
			}
			
			
			
			
			
			
			
			
			
			//------------- Персонажи
			let uPUserId;
			if (usersPersonagesTooltip) usersPersonagesTooltip.destroy();
			usersPersonagesTooltip = new jBox('Tooltip', {
				attach: '[userv2personages]',
				trigger: 'click',
				closeOnMouseleave: true,
				//addClass: '',
				onOpen: function() {
					closeToolTips('personages');
				},
				outside: 'x',
				ignoreDelay: true,
				zIndex: 1200,
				repositionOnContent: true,
				pointer: 'top',
				//pointTo: 'left',
				position: {
				  x: 'left',
				  y: 'center'
				}
			});
			
			
			
			$('body').off(tapEvent, '[userv2personages]').on(tapEvent, '[userv2personages]', function() {
				uPUserId = $(this).attr('userv2personages');
				getAjaxHtml('admin/personages/get', {from_id: uPUserId, users_list: 1}, function(html) {
					usersPersonagesTooltip.setContent('<div class="usersv2personageslist">'+html+'</div>');
				});
			});
			
			
			
			// Закрыть календари и тултипы при скролле
			$('#usersTable').off('onScrollStart').on('onScrollStart', function() {
				closeToolTips();
				$('#usersList').find('[date]').datepicker('hide');
				$('#usersList').find('[date]').blur();
			});
			
			
		});
	}
	
	function closeToolTips(exclude) {
		if (exclude != 'colors' && typeof usersColorsTooltip.close === 'function') usersColorsTooltip.close();
		if (exclude != 'statics' && typeof usersStaticsTooltip.close === 'function') usersStaticsTooltip.close();
		if (exclude != 'classes' && typeof usersClassesTooltip.close === 'function') usersClassesTooltip.close();
		if (exclude != 'personages' && typeof usersPersonagesTooltip.close === 'function') usersPersonagesTooltip.close();
	}
	
	
	
	
	
	
	
	
});
//--></script>