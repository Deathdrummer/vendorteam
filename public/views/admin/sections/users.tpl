<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Участники</h2>
		<div class="buttons notop" id="{{id}}SaveBlock">
			<button class="large" id="{{id}}Save" title="Сохранить"><i class="fa fa-save"></i> <span>Сохранить</span></button>
			<button class="large" hidden id="raidersColorsSave" title="Сохранить цвета"><i class="fa fa-save"></i> <span>Сохранить цвета</span></button>
		</div>
	</div>
	
	<fieldset>
		<legend>Список участников</legend>
		
		<input type="hidden" id="sortField" value="{{sort_field}}">
		<input type="hidden" id="sortOrder" value="{{sort_order}}">
		
		<ul class="tabstitles">
			<li id="newUsers">Новые</li>
			<li id="verifyUsers">Верифицированные</li>
			<li id="deletedUsers">Удаленные</li>
			<li id="depositUsers">Резерв</li>
			<li id="colorsUsers">Цвета рейдеров</li>
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
									{% if udata[sId] is defined %}
										<li id="tab{{sId}}">{% if sId == 0 %}Статик не задан{% else %}{{statics[sId]['name']|default('Статик удален')}}{% endif %}</li>
									{% endif %}
								{% endfor %}
							</ul>
							
							<div class="tabscontent">
								{% for staticId, usersData in udata %}
									<div tabid="tab{{staticId}}" class="scroll">
										<strong>{% if staticId == 0 %}Статик не задан{% else %}{{statics[staticId]['name']|default('Статик удален')}}{% endif %}</strong>
										
										{% if usersData %}
											<table id="{{tabid}}Table">
												<thead>
													<tr>
														<td></td>
														{% if tabid == 'verifyUsers' or tabid == 'newUsers' %}<td class="nowidth" title="Цвет">Цвет</td>{% endif %}
														<td{% if sort_field == 'u.nickname' %} class="active"{% endif %}>Никнейм <i class="fa fa-sort" userssortfield="u.nickname" sortorder="{{sort_order}}"></i></td>
														<td class="nowrap{% if sort_field == 'us.lider' %} active{% endif %}">Лидер <i class="fa fa-sort" userssortfield="us.lider" sortorder="{{sort_order}}"></i></td>
														<td class="nowrap{% if sort_field == 'u.agreement' %} active{% endif %}" title="Соглашение">Согл. <i class="fa fa-sort" userssortfield="u.agreement" sortorder="{{sort_order}}"></i></td>
														<td{% if sort_field == 'u.rank' %} class="active"{% endif %}>Звание <i class="fa fa-sort" userssortfield="u.rank" sortorder="{{sort_order}}"></i></td>
														<td{% if sort_field == 'u.email' %} class="active"{% endif %}>E-mail <i class="fa fa-sort" userssortfield="u.email" sortorder="{{sort_order}}"></i></td>
														<td{% if sort_field == 'u.reg_date' %} class="active"{% endif %}>Дата регистрации <i class="fa fa-sort" userssortfield="u.reg_date" sortorder="{{sort_order}}"></i></td>
														<td>Стаж</td>
														<td>Средство платежа</td>
														<td{% if sort_field == 'u.deposit' %} class="active"{% endif %}>Резерв <i class="fa fa-sort" userssortfield="u.deposit" sortorder="{{sort_order}}"></i></td>
														<!-- <td>Ранг</td> -->
														<td{% if sort_field == 'u.role' %} class="active"{% endif %}>Роль <i class="fa fa-sort" userssortfield="u.role" sortorder="{{sort_order}}"></i></td>
														<td>Доступ</td>
														<td>Статики</td>
														{% if tabid == 'verifyUsers' %}<td title="Персонажи">Персон.</td>{% endif %}
														{% if tabid == 'deletedUsers' %}<td class="nowidth" title="Восстановить участника">Восст.</td>{% endif %}
														<td class="nowidth" {% if tabid == 'newUsers' %}colspan="2{% endif %}">Опции</td>
													</tr>
												</thead>
												
												<tbody userslistrows>
													{% for k, user in usersData %}
														<tr userid="{{user.id}}">
															<td class="nowidth nopadding">
																{% if user.avatar %}
																	<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)}}')" title="{{user.nickname}}"></div>
																{% elseif user.deleted %}
																	<div class="avatar" style="background-image: url({{base_url('public/images/deleted_mini.jpg')}})" title="Нет аватарки"></div>
																{% else %}
																	<div class="avatar" style="background-image: url({{base_url('public/images/user_mini.jpg')}})" title="Нет аватарки"></div>
																{% endif %}
															</td>
															{% if tabid == 'verifyUsers' or tabid == 'newUsers' %}
																<td class="center">
																	<div class="color">
																		<div setstaticusercolor style="background-color: {{user.color}}"></div>
																		<input type="hidden" class="user_color" value="{{user.color}}">
																	</div>
																</td>
															{% endif %}	
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
															<td class="nowidth">
																<div class="text">
																	<input type="text" class="user_payment wpx70" value="{{user.payment}}">
																</div>
															</td>
															<td class="nowidth">
																<div class="number">
																	<input type="number" showrows class="user_deposit" value="{{user.deposit|default(0)}}">
																</div>
															</td>
															{#<td class="nowidth">
																<div class="select">
																	<select class="user_access_level">
																		<option value="" selected="" disabled="">Задать</option>
																		{% for id, level in access_levels %}
																			<option value="{{id}}">{{level.name}}</option>
																		{% endfor %}
																	</select>
																	<div class="select__caret"></div>
																</div>
															</td>
															<td>{{user.access_level_name|default('не задан')}}</td>#}
															<td class="nowidth">
																{% if roles|length > 0 %}
																	<div class="select wpx40">
																		<select class="user_role">
																			<option value="" selected="" disabled="">Задать</option>
																			{% for id, role in roles %}
																				<option value="{{id}}"{% if id == user.role %} selected=""{% endif %}>{{role.name}}</option>
																			{% endfor %}
																		</select>
																		<div class="select__caret"></div>
																	</div>		
																{% else %}
																	<p class="empty">Создайте роли</p>
																{% endif %}
															</td>
															<td class="nowidth">
																{% if accounts_access|length > 0 %}
																	<div class="select wpx40">
																		<select class="user_access">
																			<option value="0" selected>По-умолчанию</option>
																			{% for id, access in accounts_access %}
																				<option value="{{id}}"{% if id == user.access %} selected=""{% endif %}>{{access.name}}</option>
																			{% endfor %}
																		</select>
																		<div class="select__caret"></div>
																	</div>		
																{% else %}
																	<p class="empty">Создайте доступы</p>
																{% endif %}
															</td>
															<td class="nowidth center">
																<input type="hidden" class="user_statics" value="{{user.static}}">
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
																<td class="nowidth center">
																	<div class="buttons notop">
																		<button class="alt" setuserpersonages="{{user.id}}" title="Утвердить персонажей"><i class="fa fa-th-list"></i></button>
																	</div>
																</td>
																<td class="nowidth center">
																	<div class="buttons notop">
																		<button class="remove large" deleteuser="{{user.id}}"{% if tabid == 'deletedUsers' %} disabled{% endif %} title="Удалить"><i class="fa fa-trash"></i></button>
																	</div>
																</td>
															{% elseif tabid == 'deletedUsers' %}
																<td class="center">
																	<div class="checkblock">
																		<input type="checkbox" id="recoveryUser{{staticId}}{{user.id}}{{user.role}}" class="recovery_user">
																		<label for="recoveryUser{{staticId}}{{user.id}}{{user.role}}"></label>
																	</div>
																</td>
																<td class="nowidth center">
																	<div class="buttons notop">
																		<button class="large" setuserdata="{{user.id}}" title="Обновить"><i class="fa fa-repeat"></i></button>
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
								{% endfor %}
							</div>
							
						</div>
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}
				</div>
			{% endfor %}
			
			
			<div tabid="depositUsers">

				<h4 class="mb-2">Общий Резерв: <strong>{{deposit['global']|number_format(2, '.', ' ')}}</strong> руб.</h4>
				
				<div style="width: 700px;">
					<div class="d-flex align-items-center justify-content-between">
						<h4>Резерв по статикам:</h4>
						<div class="buttons mb10px">
							<button id="depositUsersList" disabled>Сохранить</button>
						</div>
					</div>
					
					
					
					<div id="depositTables">
						<table>
							<thead class="main">
								<tr class="h40px">
									<td colspan="2"><h4>Статик</h4></td>
									<td class="w250px">Средство платежа</td>
									<td class="w150px"><h4>Резерв</h4></td>
								</tr>
							</thead>
						</table>
						{% for stId, deposit in deposit['statics'] %}
							<table>
								<thead class="hover">
									<tr class="h50px">
										<td colspan="2"><h4>{% if stId == 0 %}Статик не задан{% else %}{{statics[stId]['name']|default('Статик удален')}}{% endif %}</h4></td>
										<td class="w250px"></td>
										<td class="w150px"><h4>{{deposit|number_format(2, '.', ' ')}} руб.</h4></td>
									</tr>
								</thead>
								<tbody hidden deposituserslist>
									{% for user in deposit_users[stId] %}
										<tr>
											<td class="nowidth nopadding noheight">
												{% if user.avatar %}
													<div class="avatar mini" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)}}')" title="{{user.nickname}}"></div>
												{% elseif user.deleted %}
													<div class="avatar mini" style="background-image: url({{base_url('public/images/deleted_mini.jpg')}})" title="Нет аватарки"></div>
												{% else %}
													<div class="avatar mini" style="background-image: url({{base_url('public/images/user_mini.jpg')}})" title="Нет аватарки"></div>
												{% endif %}
											</td>
											<td class="noheight">{{user.nickname|default('Не задан')}}</td>
											<td>
												<div class="text">
													<input type="text" class="deposit_user_payment" value="{{user.payment}}">
												</div>
											</td>
											<td class="noheight">
												<div class="number">
													<input type="hidden" class="deposit_user_id" value="{{user.id}}">
													<input type="number" class="deposit_user_deposit" value="{{user.deposit|default(0)}}">
												</div>
												<span>руб.</span>
											</td>
										</tr>
									{% endfor %}
								</tbody>
							</table>
						{% endfor %}
					</div>
					
				</div>
				
					
				
					
				
				
				
				{#<table>
					<thead>
						<tr>
							<td>Статик</td>
							<td>Резерв</td>
						</tr>
					</thead>
					<tbody>
						{% for stId, deposit in deposit['statics'] %}
						<tr>
							<td>{{statics[stId]['name']|default('Статик не задан')}}</td>
							<td>{{deposit|number_format(2, '.', ' ')}} руб.</td>
						</tr>
						{% endfor %}
					</tbody>
				</table>#}
				
					
			</div>
			
			<div tabid="colorsUsers">
				<form id="raidersColorsForm">
					<fieldset>
						<legend>Список цветов</legend>
						
						<div class="list" id="raiderColorsBlock">
							{% if raiders_colors|length > 0 %}
								{% for id in raiders_colors|keys %}
									<div class="list_item">
										<div>
											{% include form~'color.tpl' with {'label': 'Цвет', 'name': 'raiders_colors|'~id~'|color', 'postfix': 0, 'class': 'w70px'} %}
											{% include form~'field.tpl' with {'label': 'Название цвета', 'name': 'raiders_colors|'~id~'|name', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
											<div class="buttons right ml-auto">
												<button class="remove remove_raders_color fieldheight" data-id="{{id}}" title="Удалить Цвет"><i class="fa fa-trash"></i></button>
											</div>
										</div>
									</div>
								{% endfor %}
							{% else %}
								<p class="empty">Нет данных</p>
							{% endif %}	
						</div>
						
						<div class="buttons">
							<button class="large" id="raidersColorsAdd">Добавить Цвет</button>
						</div>
						
					</fieldset>
				</form>
			</div>
		</div>
		
		
	</fieldset>
</div>








<script type="text/javascript"><!--
$(document).ready(function() {
	
	//---------------------------------------------------------------------- Цвета
	dynamicList({
		listBlock: '#raiderColorsBlock', 	// - ID блока списка
		addButton: '#raidersColorsAdd', 	// - ID кнопки добавления элемента списка
		template: 'raiders_colors_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_raders_color',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить цвет?',
		removeMessage: 'Цвет успешно удален!',
		phpFunctionRemove: 'admin/raiders_colors_remove' 	// - Функция обработки в PHP
	});
	
	$('#raidersColorsSave').on(tapEvent, function() {
		var raidersColorsForm = new FormData($('#raidersColorsForm')[0]);
		$.ajax({
			type: 'POST',
			url: '/admin/raiders_colors_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: raidersColorsForm,
			success: function(response) {
				if (response) notify('Настройки цветов сохранены!');
				else notify('Ошибка сохранения настроек цветов!', 'error');
			},
			error: function(e) {
				console.log(e);	
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	
	
	
	
	//---------------------------------------------------------------------- Задать цвет рейдера
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
	
	
	
	
	
	
	
	
	
	
	
	$('#users').find('.user_deposit').number(true, 2, '.', ' ');
	
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
	
	
	
	
	$('[userslistrows]').changeRowInputs(function(row) {
		$(row).addClass('changed');
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
	
	if (/colorsUsers/.test(location.hash)) $('#raidersColorsSave').removeAttrib('hidden');
	else $('#raidersColorsSave').setAttrib('hidden');
	$('.tabstitles:not(.sub)').on(tapEvent, 'li', function() {
		if ($(this).attr('id') == 'colorsUsers') {
			$('#raidersColorsSave').removeAttrib('hidden');
		} else {
			$('#raidersColorsSave').setAttrib('hidden');
		}
	});
	
	
	
	var thisField = $('#sortField').val(),
		thisOrder = $('#sortOrder').val();
		
	$('[userssortfield]').on(tapEvent, function() {
		thisField = $(this).attr('userssortfield');
		thisOrder = $(this).attr('sortorder');
		renderSection({field: thisField, order: (thisOrder == 'ASC' ? 'DESC' : 'ASC')});
	});
	
	
	
	$('body').on('keyup', 'input:focus', function(e) {
		if (e.keyCode == 13 && $('[tabid="verifyUsers"]').hasClass('visible')) {
			$('#usersSave').trigger('click');
			return false;
		} 
	});
	
	
	
	
	
	//-------------------------------------------------------------- Задать статики пользователя
	$('#users').on(tapEvent, '[setuserstatics]', function() {
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
					userStaticsWin.setData(html);
					
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
					userStaticsWin.setData('<p class="empty center">Нет данных</p>');
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
	$('#users').on(tapEvent, '[setuserpersonages]', function() {
		$(this).removeClass('error');
		var thisUserRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserpersonages');
			thisUserName = $(thisUserRow).find('.user_nickname').val();
			
		popUp({
			title: '<small>Персонажи: <strong>'+thisUserName+'</strong></small>',
		    width: 1000,
		    //buttons: [{id: 'userPersonagesSave', title: 'Сохранить', disabled: 1}],
		    closeButton: 'Закрыть'
		}, function(userPersonagesWin) {
			userPersonagesWin.wait();
			
			getAjaxHtml('admin/personages/get', {from_id: thisUserId, users_list: 1}, function(html) {
				userPersonagesWin.setData(html);
				
				$('#userPersonagesList').changeRowInputs(function(row, item) {
					$(row).addClass('changed');
					$('#userPersonagesSave').removeAttrib('disabled');
				});
				
				$('#userPersonagesSave').on(tapEvent, function() {
					userPersonagesWin.wait();
					var formData = new FormData($('#userPersonagesForm')[0]);
					
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Задать данные верифицированных пользователей
	$('#usersSave').on(tapEvent, function() {
		var usersData = [];
		if ($('[tabid="verifyUsers"]').find('tbody tr.changed').length == 0) {
			notify('Нет данных для сохранения!', 'info');
			return false;
		}
		
		$('[tabid="verifyUsers"]').find('tbody tr.changed').each(function() {
			var thisRow = $(this),
				thisUserId = $(this).attr('userid'),
				thisUserColor = $(thisRow).find('.user_color'),
				thisUserNickname = $(thisRow).find('.user_nickname'),
				thisUserRegDate = $(thisRow).find('.user_reg_date').attr('date') || false,
				thisUserStage = $(thisRow).find('.user_stage'),
				thisUserPayment = $(thisRow).find('.user_payment'),
				thisUserDeposit = $(thisRow).find('.user_deposit'),
				thisUserRole = $(thisRow).find('.user_role'),
				thisUserAccess = $(thisRow).find('.user_access');
			
			var user = {
				id: thisUserId,
				color: $(thisUserColor).val(),
				nickname: $(thisUserNickname).val(),
				reg_date: thisUserRegDate,
				stage: thisUserStage.val(),
				payment: $(thisUserPayment).val(),
				deposit: $(thisUserDeposit).val(),
				role: $(thisUserRole).val(),
				access: $(thisUserAccess).val()
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
					renderSection({field: thisField, order: thisOrder});
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
	

	
	
	
	
	
	
	
	//-------------------------------------------------------------- Верифицировать, обновить или восстановить пользователя
	$('#users').on(tapEvent, '[setuserdata]', function() {
		var thisRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserdata'),
			thisUserRegDate = $(thisRow).find('.user_reg_date').attr('date') || false,
			thisUserStage = $(thisRow).find('.user_stage'),
			thisUserPayment = $(thisRow).find('.user_payment'),
			thisUserNickname = $(thisRow).find('.user_nickname'),
			thisUserColor = $(thisRow).find('.user_color'),
			thisUserDeposit = $(thisRow).find('.user_deposit'),
			thisUserStatics = $(thisRow).find('.user_statics'),
			//thisUserAccessLevel = $(thisRow).find('.user_access_level'),
			thisUserRole = $(thisRow).find('.user_role'),
			verification = $(thisRow).find('.recovery_user').length ? ($(thisRow).find('.recovery_user').is(':checked') ? 1 : 0) : 1,
			stat = true;
		
		
		if (verification && !$(thisUserStatics).val()) {
			$(thisUserStatics).closest('td').find('button').addClass('error');
			notify('Необходимо задать как минимум, один статик!', 'info');
			stat = false;
		}
		
		/*if (! $(thisUserAccessLevel).val()) {
			$(thisUserAccessLevel).addClass('error');
			notify('Необходимо выбрать ранг', 'error');
			stat = false;
		}*/
		
		
		
		if (verification && !$(thisUserRole).val()) {
			$(thisUserRole).addClass('error');
			notify('Необходимо выбрать роль', 'error');
			stat = false;
		}
		
			
		if (stat) {
			$.post('/admin/set_user_data', {
				verification: verification,
				user_id: thisUserId,
				user_nickname: $(thisUserNickname).val(),
				user_color: $(thisUserColor).val(),
				//user_access_level: $(thisUserAccessLevel).val(),
				user_role: $(thisUserRole).val(),
				user_payment: $(thisUserPayment).val(),
				user_deposit: $(thisUserDeposit).val(),
				user_reg_date: thisUserRegDate,
				user_stage: thisUserStage.val()
			}, function(response) {
				if (response) {
					renderSection({field: thisField, order: thisOrder});
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
						renderSection({field: thisField, order: thisOrder});
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
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Резерв
	$('#depositTables').find('thead').on(tapEvent, function() {
		var closed = $(this).siblings('tbody').attr('hidden') ? true : false;
		if (!closed) {
			$(this).siblings('tbody').setAttrib('hidden');
		} else {
			$('#depositTables').find('tbody').setAttrib('hidden');
			$(this).siblings('tbody').removeAttrib('hidden');
		}
	});
	
	
	$('[deposituserslist]').changeRowInputs(function(row, item) {
		$(row).addClass('changed');
		$('#depositUsersList').removeAttrib('disabled');
	});
	
	
	$('#depositUsersList').on(tapEvent, function() {
		var depositUpdateData = [];
		if ($('[deposituserslist]').find('tr.changed').length > 0) {
			$('[deposituserslist]').find('tr.changed').each(function() {
				var thisUserId = parseFloat($(this).find('.deposit_user_id').val()),
					thisPayment = $(this).find('.deposit_user_payment').val(),
					thisDeposit = parseFloat($(this).find('.deposit_user_deposit').val());
				depositUpdateData.push({
					id: thisUserId,
					payment: thisPayment,
					deposit: thisDeposit
				});
			});
			
			$.post('/admin/deposit_update', {deposit: depositUpdateData}, function(response) {
				if (response) {
					notify('Резервы успешно сохранены!');
					$('[deposituserslist]').find('tr.changed').removeClass('changed');
					renderSection();
				}
			});
		} else {
			notify('Нет данных для сохранения', 'info');
		}
	});
	
	
	
	
});

//--></script>