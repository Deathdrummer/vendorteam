<div class="section" id="accountingSection">
	<div class="section__title">
		<h1>Бухгалтерия</h1>
	</div>
	
	
	<div class="section__buttons" id="sectionButtons">
		<button id="usersSave" title="Сохранить"><i class="fa fa-save"></i></button>
	</div>
	


	<div class="section__content" id="sectionContent">
		<input type="hidden" id="sortField" value="{{sort_field}}">
		<input type="hidden" id="sortOrder" value="{{sort_order}}">
		<div>
			{% if users|length > 0 %}
				<div>
					<ul class="tabstitles">
						{% if users[0] is defined %}
							<li id="tab0">Статик не задан</li>
						{% endif %}
						{% for sId, sData in statics %}
							{% if users[sId] is defined and sId in access_statics|keys %}
								<li id="tab{{sId}}">{{statics[sId]['name']|default('Статик не задан')}}</li>
							{% endif %}
						{% endfor %}
					</ul>
					
					<div class="tabscontent">
						{% for staticId, usersData in users %}
							{% if staticId in access_statics|keys %}
								<div tabid="tab{{staticId}}">
									<strong>{{statics[staticId]['name']|default('Статик не задан')}}</strong>
									
									{% if usersData %}
										<table id="{{tabid}}Table" class="wauto">
											<thead>
												<tr>
													<td></td>
													<td{% if sort_field == 'u.nickname' %} class="active"{% endif %}>Никнейм <i class="fa fa-sort" userssortfield="u.nickname" sortorder="{{sort_order}}"></i></td>
													<td>Средство платежа</td>
													<td{% if sort_field == 'u.deposit' %} class="active"{% endif %}>Резерв <i class="fa fa-sort" userssortfield="u.deposit" sortorder="{{sort_order}}"></i></td>
													<td>Статики</td>
													<td class="nowidth" {% if tabid == 'newUsers' %}colspan="2{% endif %}">Опции</td>
												</tr>
											</thead>
											
											<tbody>
												{% for k, user in usersData %}
													<tr userid="{{user.id}}" staticid="{{staticId}}">
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
														<td>
															<div class="text">
																{% if 7 in access %}
																	<input type="text" class="user_payment" value="{{user.payment}}">
																{% else %}
																	<p>{{user.payment|default('-')}}</p>
																{% endif %}
															</div>
														</td>
														<td class="nowidth">
															<div class="number">
																{% if 7 in access %}
																	<input type="text" class="user_deposit" value="{{user.deposit|default(0)}}">
																{% else %}
																	<p>{{currency(user.deposit)}}</p>
																{% endif %}
															</div>
														</td>
														<td class="nowidth center">
															<input type="hidden" class="user_statics" value="">
															<div class="buttons notop">
																<button class="alt" setuserstatics="{{user.id}}" title="Задать статики"><i class="fa fa-th-list"></i></button>
															</div>
														</td>
														<td class="nowidth center">
															<div class="buttons notop">
																<button class="remove large" deleteuser="{{user.id}}"{% if tabid == 'deletedUsers' %} disabled{% endif %} title="Удалить"><i class="fa fa-trash"></i></button>
															</div>
														</td>
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
	</div>
</div>







<script type="text/javascript"><!--
$(document).ready(function() {
	
	$('#accountingSection').find('.user_deposit').number(true, 2, '.', ' ');
	
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
	
	
	
	$('body').off('change', '#accountingSection select').on('change', '#accountingSection select', function() {
		$(this).closest('tr').addClass('changed');
	});
	
	$('body').off('keypress change', '#accountingSection input').on('keypress change', '#accountingSection input', function() {
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
	$('#accountingSection').on(tapEvent, '[setuserstatics]', function() {
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Сохранить данные пользователей (верифицированных)
	$('#usersSave').on(tapEvent, function() {
		var usersData = [];
		if ($('.tabscontent').find('tbody tr.changed').length == 0) {
			notify('Нет данных для сохранения!', 'info');
			return false;
		}
		
		$('.tabscontent').find('tbody tr.changed').each(function() {
			var thisRow = $(this),
				thisUserId = $(this).attr('userid'),
				thisUserNickname = $(thisRow).find('.user_nickname'),
				thisUserPayment = $(thisRow).find('.user_payment'),
				thisUserDeposit = $(thisRow).find('.user_deposit');
			
			var user = {
				id: thisUserId,
				nickname: $(thisUserNickname).val(),
				payment: $(thisUserPayment).val(),
				deposit: $(thisUserDeposit).val()
			}
			usersData.push(user);
		});
		
		
		$.ajax({
			type: 'POST',
			url: '/admin/set_users_accounting',
			dataType: 'json',
			data: {users: usersData},
			success: function(response) {
				if (response) {
					setContentData('accounting', {field: thisField, order: thisOrder});
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
	$('#accountingSection').on(tapEvent, '[setuserdata]', function() {
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