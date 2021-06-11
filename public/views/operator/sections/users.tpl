<div class="section" id="usersSection">
	<div class="section__title">
		<h1>Участники</h1>
	</div>
	
	
	
	<div class="section__buttons nowidth mb-3">
		<div class="item inline">
			<div class="section__buttons mb-0" id="sectionButtons">
				<button class="small" id="usersSave" title="Сохранить"><i class="fa fa-save"></i></button>
			</div>
		</div>
		<div class="item inline">
			<div class="field small">
				<input type="text" id="searchUsersField" placeholder="Введите никнейм">
			</div>
		</div>
		<div class="item inline">
			<div class="buttons notop">
				<button class="small" id="setSearchFromUsers">Поиск</button>
			</div>
		</div>
		<div class="item inline">
			<div class="buttons notop">
				<button class="small remove" disabled id="resetSearchFromUsers">Сбросить</button>
			</div>
		</div>
		<div class="item inline ml-auto">
			<span>Группировка:</span>
		</div>
		<div class="item inline">
			<div class="select small">
				<select id="staticsGroup">
					<option value="">Все</option>
					<option value="1">Рейды</option>
					<option value="2">Группа</option>
					<option value="3">Инактив</option>
				</select>
				<div class="select__caret"></div>
			</div>
		</div>
	</div>
	
	
	
			
	


	<div class="section__content" id="sectionContent">
		<input type="hidden" id="sortField" value="{{sort_field}}">
		<input type="hidden" id="sortOrder" value="{{sort_order}}">
		<div>
			<ul class="tabstitles">
				<li id="newUsers" class="active">Новые</li>
				<li id="verifyUsers">Верифицированные</li>
				<li id="deletedUsers">Удаленные</li>
			</ul>
			
			<div class="tabscontent">
				{% for tabid, udata in {'newUsers': users.new, 'verifyUsers': users.verify, 'deletedUsers': users.deleted} %}
					<div tabid="{{tabid}}">
						{% if udata|length > 0 %}
							<div>
								<ul class="tabstitles sub">
									{% if udata[0] is defined %}
										<li id="tab0">Статик не задан</li>
									{% endif %}
									{% for sId, sData in statics %}
										{% if udata[sId] is defined and sId in access_statics|keys %}
											<li id="tab{{sId}}" group="{{statics[sId]['group']}}">{{statics[sId]['name']|default('Статик не задан')}}</li>
										{% endif %}
									{% endfor %}
								</ul>
								
								<div class="tabscontent">
									{% for staticId, usersData in udata %}
										{% if staticId in access_statics|keys %}
											<div tabid="tab{{staticId}}">
												<strong>{{statics[staticId]['name']|default('Статик не задан')}}</strong>
												
												{% if usersData %}
													<table id="{{tabid}}Table">
														<thead>
															<tr>
																<td></td>
																<td{% if sort_field == 'u.nickname' %} class="active"{% endif %}>Никнейм <i class="fa fa-sort" userssortfield="u.nickname" sortorder="{{sort_order}}"></i></td>
																<td class="nowrap{% if sort_field == 'us.lider' %} active{% endif %}">Лидер <i class="fa fa-sort" userssortfield="us.lider" sortorder="{{sort_order}}"></i></td>
																<td class="nowrap{% if sort_field == 'u.agreement' %} active{% endif %}" title="Соглашение">Согл. <i class="fa fa-sort" userssortfield="u.agreement" sortorder="{{sort_order}}"></i></td>
																<td{% if sort_field == 'u.rank' %} class="active"{% endif %}>Звание <i class="fa fa-sort" userssortfield="u.rank" sortorder="{{sort_order}}"></i></td>
																<td{% if sort_field == 'u.email' %} class="active"{% endif %}>E-mail <i class="fa fa-sort" userssortfield="u.email" sortorder="{{sort_order}}"></i></td>
																<td class="w160px{% if sort_field == 'u.reg_date' %} active{% endif %}">Дата регистрации <i class="fa fa-sort" userssortfield="u.reg_date" sortorder="{{sort_order}}"></i></td>
																<td>Стаж</td>
																<!-- <td>Ранг</td> -->
																<td{% if sort_field == 'u.role' %} class="active"{% endif %}>Роль <i class="fa fa-sort" userssortfield="u.role" sortorder="{{sort_order}}"></i></td>
																<td>Статики</td>
																{% if tabid == 'verifyUsers' and '12' in access %}<td title="Персонажи">Персон.</td>{% endif %}
																<td class="nowidth" {% if tabid == 'newUsers' %}colspan="2{% endif %}">Опции</td>
															</tr>
														</thead>
														
														<tbody userslistrows>
															{% for k, user in usersData %}
																<tr userid="{{user.id}}" staticid="{{staticId}}"{% if user.nickname %} usernickname="{{user.nickname}}"{% endif %}>
																	<td class="nowidth nopadding">
																		{% if user.avatar %}
																			<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)}}')" title="{{user.nickname}}"></div>
																		{% elseif user.deleted %}
																			<div class="avatar" style="background-image: url({{base_url('public/images/deleted_mini.jpg')}})" title="Нет аватарки"></div>
																		{% else %}
																			<div class="avatar" style="background-image: url({{base_url('public/images/user_mini.jpg')}})" title="Нет аватарки"></div>
																		{% endif %}
																	</td>	
																	<td class="nowidth">
																		<div class="text">
																			<input type="text" class="user_nickname wpx50" value="{{user.nickname}}" placeholder="Не задан">
																		</div>
																	</td>
																	<td class="nowidth center">
																		{% if user.lider == 1 %}
																			<i class="fa fa-check"></i>
																		{% else %}
																			<i class="fa fa-ban"></i>
																		{% endif %}
																	</td>
																	<td class="nowidth center">
																		{% if user.agreement == 1 %}
																			<i class="fa fa-check"></i>
																		{% else %}
																			<i class="fa fa-ban"></i>
																		{% endif %}
																	</td>
																	<td>{{user.rank|default('не задано')}}</td>
																	<td>{{user.email}}</td>
																	<td class="nowidth">
																		<div class="date">
																			<input type="text" class="user_reg_date" value="{{user.reg_date|d}}" date="">
																		</div>
																	</td>
																	<td class="nowidth nowrap">
																		<div class="number short">
																			<input type="number" showrows class="user_stage" value="{{user.stage|default(0)}}">
																		</div>
																		<span class="ml-1">дн.</span>
																	</td>
																	<!-- <td class="nowidth">
																		<div class="select">
																			<select class="user_access_level">
																				<option value="" selected="" disabled="">Задать</option>
																				{% for id, level in access_levels %}
																					<option value="users">{{level.name}}</option>
																				{% endfor %}
																			</select>
																			<div class="select__caret"></div>
																		</div>
																	</td>
																	<td>{{user.access_level_name|default('не задан')}}</td> -->
																	<td class="nowidth">
																		{% if roles|length > 0 %}
																			<div class="select wpx40">
																				<select class="user_role">
																					<option value="" selected="" disabled="">Задать</option>
																					{% for rid, role in roles %}
																						<option value="{{rid}}"{% if rid == user.role %} selected=""{% endif %}>{{role.name}}</option>
																					{% endfor %}
																				</select>
																				<div class="select__caret"></div>
																			</div>		
																		{% else %}
																			<p class="empty">Создайте роли</p>
																		{% endif %}
																	</td>
																	<td class="nowidth center">
																		<input type="hidden" class="user_statics" value="">
																		<div class="buttons notop">
																			<button class="alt" setuserstatics="{{user.id}}" title="Задать статики"><i class="fa fa-th-list"></i></button>
																		</div>
																	</td>
																	{% if tabid == 'newUsers' %}
																		<td class="nowidth center">
																			<div class="buttons notop">
																				<button class="large update" setuserdata="{{user.id}}" title="Подтвердить"><i class="fa fa-check"></i></button>
																			</div>
																		</td>
																		<td class="nowidth center">
																			<div class="buttons notop">
																				<button class="remove large" deleteuser="{{user.id}}"{% if tabid == 'deletedUsers' %} disabled{% endif %} title="Удалить"><i class="fa fa-trash"></i></button>
																			</div>
																		</td>
																	{% elseif tabid == 'verifyUsers' %}
																		{% if '12' in access %}
																			<td class="nowidth center">
																				<div class="buttons notop">
																					<button class="alt" setuserpersonages="{{user.id}}" title="Утвердить персонажей"><i class="fa fa-th-list"></i></button>
																				</div>
																			</td>
																		{% endif %}	
																		<td class="nowidth center">
																			<div class="buttons notop">
																				<button class="remove large" deleteuser="{{user.id}}"{% if tabid == 'deletedUsers' %} disabled{% endif %} title="Удалить"><i class="fa fa-trash"></i></button>
																			</div>
																		</td>
																	{% elseif tabid == 'deletedUsers' %}
																		<td class="nowidth center">
																			<div class="buttons notop">
																				<button class="large recovery_user" setuserdata="{{user.id}}" title="Восстановить"><i class="fa fa-repeat"></i></button>
																			</div>
																		</td>
																	{% endif %}
																</tr>
															{% endfor %}
														</tbody>
													</table>
													<br>
													<br>
												{% else %}
													<p class="empty">Нет данных</p>
												{% endif %}
											</div>
										{% endif %}
										
											
									{% endfor %}
								</div>
								
							</div>
						{% else %}
							<p class="empty">Нет данных</p>
						{% endif %}
					</div>	
				{% endfor %}
			</div>
		</div>
	</div>
</div>







<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	
	//------------------------------------------------------------ Выбор группы
	var groupFromCache = lscache.get('staticsGroupOperator');
	if (groupFromCache) {
		$('#staticsGroup').find('option[value="'+groupFromCache+'"]').setAttrib('selected');
		$('[group]:not([group="'+groupFromCache+'"])').setAttrib('hidden');
		$('.tabstitles.sub').find('li').removeClass('active');
		$('.tabstitles.sub').find('li:visible:first').addClass('active');
		var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
		
		$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
		$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
	} 
	
	$('#staticsGroup').on('change', function() {
		var group = $('#staticsGroup').val() || false;
		lscache.set('staticsGroupOperator', group);
		$('[group]').removeAttrib('hidden');
		if (group) {
			$('[group]:not([group="'+group+'"])').setAttrib('hidden');
			$('.tabstitles.sub').find('li').removeClass('active');
			$('.tabstitles.sub').find('li:visible:first').addClass('active');
			var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
			
			$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
			$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
		} else {
			$('.tabstitles.sub').find('li').removeClass('active');
			$('.tabstitles.sub').find('li:first').addClass('active');
			var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
			
			$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
			$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
		}
	});
	
	
	
	
	
	
	//------------------------------------------------------------ Поиск по участникам
	$('#setSearchFromUsers').on(tapEvent, function() {
		var searchNickname = $('#searchUsersField').val();
		
		if (!searchNickname) $('#searchUsersField').addClass('error');
		else {
			$('.tabstitles.sub').children().removeAttrib('hidden');
			$('[userslistrows], [deposituserslist]').find('tr').each(function() {
				var thisRow = this;
				var thisnickName = $(this).attr('usernickname');
				var patt = new RegExp(searchNickname, 'im');
				if (!patt.test(thisnickName)) {
					$(thisRow).setAttrib('hidden');
				} else {
					$(thisRow).removeAttrib('hidden');
				}
			});
			
						
			$('[userslistrows]').each(function() {
				if ($(this).children().not('[hidden]').length == 0) {
					var id = $(this).closest('[tabid]').attr('tabid');
					$(this).closest('.tabscontent').siblings('.tabstitles.sub').find('#'+id).setAttrib('hidden');
				}
			});
			
			$('.tabstitles.sub').find('li').removeClass('active');
			$('.tabstitles.sub').find('li:visible:first').addClass('active');
			var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
			
			$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
			$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
			
			$('#resetSearchFromUsers').removeAttrib('disabled');
		}	
	});
	
	$('#resetSearchFromUsers').on(tapEvent, function() {
		$('[userslistrows], [deposituserslist]').find('tr').each(function() {
			$(this).removeAttrib('hidden');
		});
		$('.tabstitles.sub').children().removeAttrib('hidden');
		$('#searchUsersField').val('');
		
		$('.tabstitles.sub').find('li').removeClass('active');
		$('.tabstitles.sub').find('li:visible:first').addClass('active');
		var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
		
		$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
		$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
		
		
		$('#resetSearchFromUsers').setAttrib('disabled');
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('#usersSection').find('.user_deposit').number(true, 2, '.', ' ');
	
	if ($('.user_reg_date').length > 0) {
		$('.user_reg_date').each(function() {
			$(this).datepicker({
		        dateFormat:         'd M yy г.',
		        yearRange:          "2010:+100",
		        numberOfMonths:     1,
		        changeMonth:        true,
		        changeYear:         true,
		        monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
		        monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
		        dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
		        firstDay:           1,
		        minDate:            new Date(2010, 0, 1, 0, 0, 0),
		        maxDate:            0,
		        onSelect: function(stringDate, dateObj) {
		            var rangeDay = rangeMonth = rangeYaer = 0;
		            var selectedDay = parseInt(dateObj.selectedDay),
		            	selectedMonth = parseInt(dateObj.selectedMonth),
		            	selectedYear = parseInt(dateObj.selectedYear);
		            
		            var formDay = '0'+selectedDay, formMonth = '0'+(selectedMonth + 1);
		            $(this).attr('date', selectedYear+'-'+formMonth.substr(-2)+'-'+formDay.substr(-2));
		            $(this).attr('name', 'users[][reg_date]');
		        }
		    });
		});
	}
	
	
	
	$('body').off('change', '#usersSection select').on('change', '#usersSection select', function() {
		$(this).closest('tr').addClass('changed');
	});
	
	$('body').off('keypress change', '#usersSection input').on('keypress change', '#usersSection input', function() {
		$(this).closest('tr').addClass('changed');
	});
	
	
	
	
	$('body').off('focus', '.hasDatepicker').on('focus', '.hasDatepicker', function() {
		var thisItem = this,
			thisDate = $(thisItem).attr('date');
		$(thisItem).one('blur', function() {
			setTimeout(function() {
				if ($(thisItem).attr('date') != thisDate) {
					$(thisItem).closest('tr').addClass('changed');
				}
			}, 200);
		});
	});
	
	
	
	
	//-------------------------------------------------------------- Кнопка "сохранить" верифицированных пользователей скрыть или нет
	if (!/verifyUsers/.test(location.hash)) $('#usersSave').addClass('hidden');
	$('.tabstitles:not(.sub)').on(tapEvent, 'li', function() {
		if ($(this).attr('id') == 'verifyUsers') {
			$('#usersSave').removeClass('hidden');
		} else {
			$('#usersSave').addClass('hidden');
		}
	});
	
	
	
	var thisField = $('#sortField').val(),
		thisOrder = $('#sortOrder').val();
		
	$('[userssortfield]').on(tapEvent, function() {
		thisField = $(this).attr('userssortfield');
		thisOrder = $(this).attr('sortorder');
		setContentData('users', {field: thisField, order: (thisOrder == 'ASC' ? 'DESC' : 'ASC')});
	});
	
	
	
	$('*').off('keyup').on('keyup', function(e) {
		if (e.keyCode == 13 && $('[tabid="verifyUsers"]').hasClass('visible')) {
			$('#usersSave').trigger('click');
			return false;
		} 
	});
	
	
	
	
	
	//-------------------------------------------------------------- Задать статики пользователя
	$('#usersSection').on(tapEvent, '[setuserstatics]', function() {
		$(this).removeClass('error');
		var thisUserRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserstatics');
			thisInput = $(this).closest('td').find('input.user_statics'),
			thisUserName = $(thisUserRow).find('.user_nickname').val();
			
		popUp({
			title: '<small>Статики: <strong>'+thisUserName+'</strong></small>',
		    width: 500,
		    //buttons: [{id: 'buildUserStatics', title: 'Применить'}],
		    //closeButton: 'Закрыть',
		}, function(userStaticsWin) {
			userStaticsWin.wait();
			newSet = thisInput.val() ? JSON.parse(thisInput.val()) : false;
			
			$.post('/admin/get_users_statics', {user_id: thisUserId, newset: newSet}, function(html) {
				if (html) {
					userStaticsWin.setData(html, false);
					
					$('[staticpart], [staticlider]').on('change', function() {
						var thisStaticId = $(this).attr('staticpart') || $(this).attr('staticlider'),
							thisItem = $(this)[0].hasAttribute('staticpart') ? 'part' : 'lider',
							staticPart = $('[staticpart="'+thisStaticId+'"]'),
							staticLider = $('[staticlider="'+thisStaticId+'"]'),
							staticMain = $('[staticmain="'+thisStaticId+'"]');
						
						if (thisItem == 'part') {
							$(staticLider).prop('checked', false);
							$(staticLider)[0].removeAttribute('checked');
							
						} else if (thisItem == 'lider') {
							$(staticPart).prop('checked', true);
							$(staticPart)[0].setAttribute('checked', true);
						}	
						
						if ($(staticPart).is(':checked')) {
							$(staticMain).prop('disabled', false);
							$(staticMain)[0].removeAttribute('disabled');
							if ($('[staticmain]:checked').length == 0) {
								$(staticMain).prop('checked', true);
								$(staticMain)[0].setAttribute('checked', true);
							}
						} else {
							$(staticMain).prop('checked', false);
							$(staticMain)[0].removeAttribute('checked');
							$(staticMain)[0].setAttribute('disabled', true);
							$(staticMain).prop('disabled', true);
						}
					});
				} else {
					userStaticsWin.setData('<p class="empty center">Нет данных</p>', false);
				}
				userStaticsWin.wait(false);
				
				$('#userStatics').on('change', 'input[type="checkbox"], input[type="radio"]', function() {
					if ($('[staticmain]:checked').length == 0) {
						notify('Необходимо указать хотя бы один статик основным!', 'error');
					} else {
						userStaticsWin.wait();
						var staticPartData = {},
							staticLiderData = {},
							staticMainData = {};
						$('[userstaticschecks]').each(function() {
							var staticPart = $(this).find('[staticpart]'),
								staticLider = $(this).find('[staticlider]'),
								staticMain = $(this).find('[staticmain]'),
								staticPartId = $(staticPart).attr('staticpart'),
								staticLiderId = $(staticLider).attr('staticlider'),
								staticMainId = $(staticMain).attr('staticmain'),
								staticPartChecked = $(staticPart).is(':checked') ? 1 : 0,
								staticLiderChecked = $(staticLider).is(':checked') ? 1 : 0,
								staticMainChecked = $(staticMain).is(':checked') ? 1 : 0;
							
							staticPartData[staticPartId] = staticPartChecked;
							staticLiderData[staticLiderId] = staticLiderChecked;
							staticMainData[staticMainId] = staticMainChecked;
						});
						
						
						$.post('/admin/set_user_statics', {
							user_id: thisUserId,
							user_statics: {part: staticPartData, lider: staticLiderData, main: staticMainData}
						}, function(stat) {
							if (stat) $(thisInput).val(JSON.stringify({part: staticPartData, lider: staticLiderData, main: staticMainData}));
							else $(thisInput).val('');
							userStaticsWin.wait(false);
							//userStaticsWin.close();
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					}	
				});
				
			}, 'html').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Персонажи пользователя
	$('#usersSection').on(tapEvent, '[setuserpersonages]', function() {
		$(this).removeClass('error');
		var thisUserRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserpersonages');
			thisUserName = $(thisUserRow).find('.user_nickname').val();
			
		popUp({
			title: '<small>Персонажи: <strong>'+thisUserName+'</strong></small>',
		    width: 1000,
		    buttons: [{id: 'personagesSave', title: 'Сохранить', disabled: 1}],
		    closeButton: 'Отмена'
		}, function(userPersonagesWin) {
			userPersonagesWin.wait();
			
			getAjaxHtml('admin/personages/get', {user_id: thisUserId}, function(html) {
				userPersonagesWin.setData(html, false);
				
				
				$('#personagesForm').on('keypress change', 'input, select', function() {
					$('#personagesSave').removeAttrib('disabled');
				});
				
				
				$('body').off(tapEvent, '[personageaccess]').on(tapEvent, '[personageaccess]', function() {
					var thisItem = this,
						approved = $(thisItem).attr('personageaccess'),
						thisId = $(thisItem).attr('data');
						
					$.post('/admin/personages/approved', {id: thisId, approved: approved}, function(response) {
						if (response) {
							if (approved === '1') {
								$(thisItem).attr('personageaccess', '0').removeClass('forbidden').addClass('success').attr('title', 'Утвержден');
							} else {
								$(thisItem).attr('personageaccess', '1').removeClass('success').addClass('forbidden').attr('title', 'Не утвержден');
							}
							notify('Статус изменен!');
						} else {
							notify('Ошибка изменения статуса!', 'error');
						}
					}, 'json').fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				});
				
				
				$('#personagesSave').on(tapEvent, function() {
					userPersonagesWin.wait();
					var formData = new FormData($('#personagesForm')[0]);
					
					$.ajax({
						type: 'POST',
						url: '/admin/personages/save',
						dataType: 'json',
						cache: false,
						contentType: false,
						processData: false,
						data: formData,
						success: function(r) {
							notify('Персонажи успешно сохранены!');
							userPersonagesWin.close();
						},
						error: function(e, status) {
							notify('Системная ошибка отправки данных!', 'error');
							showError(e);
						},
						complete: function() {
							userPersonagesWin.wait(false);
						}
					});
				});
				
			}, function() {
				userPersonagesWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Сохранить данные пользователей (верифицированных)
	$('#usersSave').on(tapEvent, function() {
		var usersData = [];
		if ($('[tabid="verifyUsers"]').find('tbody tr.changed').length == 0) {
			notify('Нет данных для сохранения!', 'info');
			return false;
		}
		
		$('[tabid="verifyUsers"]').find('tbody tr.changed').each(function() {
			var thisRow = $(this),
				thisUserId = $(this).attr('userid'),
				thisUserNickname = $(thisRow).find('.user_nickname'),
				thisUserRegDate = $(thisRow).find('.user_reg_date').attr('date') || false,
				thisUserStage = $(thisRow).find('.user_stage'),
				thisUserPayment = $(thisRow).find('.user_payment'),
				thisUserDeposit = $(thisRow).find('.user_deposit'),
				thisUserRole = $(thisRow).find('.user_role');
			
			var user = {
				id: thisUserId,
				nickname: $(thisUserNickname).val(),
				reg_date: thisUserRegDate,
				stage: thisUserStage.val(),
				payment: $(thisUserPayment).val(),
				deposit: $(thisUserDeposit).val(),
				role: $(thisUserRole).val()
			}
			usersData.push(user);
		});
		
		
		$.ajax({
			type: 'POST',
			url: '/admin/set_users_data',
			dataType: 'json',
			data: {users: usersData},
			success: function(response) {
				if (response) {
					setContentData('users', {field: thisField, order: thisOrder});
					notify('Данные пользователей обновлены!');
				} else {
					notify('Ошибка!', 'error');
				}
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	

	
	
	
	
	
	
	
	//-------------------------------------------------------------- Верифицировать, или восстановить пользователя
	$('#usersSection').on(tapEvent, '[setuserdata]', function() {
		var thisRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserdata'),
			thisUserRegDate = $(thisRow).find('.user_reg_date').attr('date') || false,
			thisUserStage = $(thisRow).find('.user_stage'),
			thisUserPayment = $(thisRow).find('.user_payment'),
			thisUserNickname = $(thisRow).find('.user_nickname'),
			thisUserDeposit = $(thisRow).find('.user_deposit'),
			thisUserStatics = $(thisRow).find('.user_statics'),
			//thisUserAccessLevel = $(thisRow).find('.user_access_level'),
			thisUserRole = $(thisRow).find('.user_role'),
			recovery = $(this).hasClass('recovery_user') ? true : false,
			stat = true;
			
		
		/*if (! $(thisUserAccessLevel).val()) {
			$(thisUserAccessLevel).addClass('error');
			notify('Необходимо выбрать ранг', 'error');
			stat = false;
		}*/
		
		
		if (!recovery && !$(thisUserStatics).val()) {
			$(thisUserStatics).closest('td').find('button').addClass('error');
			notify('Необходимо задать как минимум, один статик!', 'error');
			stat = false;
		}
		
		if (!$(thisUserRole).val()) {
			$(thisUserRole).addClass('error');
			notify('Необходимо выбрать роль', 'error');
			stat = false;
		}
		
			
		if (stat) {
			$.post('/admin/set_user_data', {
				verification: true,
				user_id: thisUserId,
				user_nickname: $(thisUserNickname).val(),
				//user_access_level: $(thisUserAccessLevel).val(),
				user_role: $(thisUserRole).val(),
				user_payment: $(thisUserPayment).val(),
				user_deposit: $(thisUserDeposit).val(),
				user_reg_date: thisUserRegDate,
				user_stage: thisUserStage.val()
			}, function(response) {
				if (response) {
					setContentData('users', {field: thisField, order: thisOrder});
					notify('Пользователь успешно верифицирован!');
				} else {
					notify('Ошибка!', 'error');
				}
			}, 'json').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		}
	});
	
	
	
	
	
	
	
	
	
	

	//-------------------------------------------------------------- Пометить пользователя как удаленного
	$('body').off(tapEvent, '[deleteuser]').on(tapEvent, '[deleteuser]', function() {
		var thisItem = this;
		popUp({
			title: 'Удалить пользователя?',
		    width: 500,
		    buttons: [{id: 'deleteuserConfirm', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(deleteuserWin) {
			$('#deleteuserConfirm').on(tapEvent, function() {
				var thisUserId = $(thisItem).attr('deleteuser');
				$.post('/admin/delete_user', {id: thisUserId}, function(response) {
					if (response) {
						notify('Пользователь удален!');
						setContentData('users', {field: thisField, order: thisOrder});
					} else {
						notify('Ошибка удаления пользователя!', 'error');
					}
					deleteuserWin.close();
				}, 'json').fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
					deleteuserWin.close();
				});
			});
		});
	});
});

//--></script>