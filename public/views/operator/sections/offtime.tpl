<div class="section" id="offtimeSection">
	<div class="section__title">
		<h1>Выходные</h1>
	</div>
	
	
	<div class="section__buttons" id="sectionButtons">
		<button id="offtimeSave" title="Сохранить настройки"><i class="fa fa-save"></i></button>
	</div>
	


	<div class="section__content" id="sectionContent">
		<div>
			<ul class="tabstitles">
				<li id="rolesLimits" class="active">Ограничения</li>
				<li id="offtimeUsers">График Выходных</li>
			</ul>
			
			<div class="tabscontent">
				<div tabid="rolesLimits" class="visible">
					<form id="rolesLimitsForm" class="offtime">
						<table class="offtime__limits">
							<thead>
								<tr>
									{% for role in roles %}
										<td>Роль: {{role.name}}</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</thead>
							<tbody>
								<tr>
									{% for roleId, role in roles %}
										<td>
											<ul class="w250px">
												<li class="title">
													<span>Статик</span>
													<span>Месячный лимит</span>
												</li>
												{% for staticId, static in statics %}
													{% if staticId in access_statics|keys %}
														<li>
															<span class="mr-auto">{{static.name}}</span>
															<div class="number w60px mr-1">
																<input type="number" showrows min="0" name="offtime_limits[{{roleId}}][{{staticId}}]" value="{{roles_limits[roleId][staticId]|default(0)}}">
															</div>
															<span>дн.</span>
														</li>	
													{% endif %}
												{% endfor %}
											</ul>
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				
				
				
				
				
				
				<div tabid="offtimeUsers">
					
					<div class="d-flex align-items-center mb15px">
						<p class="mr10px">Сместить диапазон:</p>
						<div class="buttons notop left">
							<button offtimehistory="-" class="small w34px main" title="На месяц назад"><i class="fa fa-angle-left"></i></button>
							<button offtimehistory="+" class="small w34px main" title="На месяц вперед"><i class="fa fa-angle-right"></i></button>
						</div>
					</div>
					
					<div id="offtimeDataContent">
						<ul class="tabstitles sub">
							{% for stId, static in statics %}
								{% if stId in access_statics|keys %}
									<li id="static{{stId}}">{{static.name}}</li>
								{% endif %}
							{% endfor %}
						</ul>
						
						<div class="tabscontent">
							{% for stId, static in statics %}
								{% if stId in access_statics|keys %}
									<div tabid="static{{stId}}">
										<h3>{{static.name}}</h3>
										<table class="offtime__users">
											{% for week in offtime.dates|batch(7) %}
												<tr>
													{% for date in week %}
														<td class="{% if current_date > date %}passed{% elseif offtime.disabled[stId][date] is defined %}disabled{% endif %}">
															<div class="offtime__title{% if current_date == date %} offtime__title_current{% endif %}">
																<div>
																	<strong>{{date|d}}</strong>
																	<small>{{date|week}}</small>
																</div>
																<div>
																	{% if date >= current_date and offtime.disabled[stId][date] is not defined %}
																		<div class="forbidden">
																			<button class="remove" disableday="{{stId}}|{{date}}" title="Запретить"><i class="fa fa-times"></i></button>
																		</div>
																	{% elseif date >= current_date and offtime.disabled[stId][date] is defined %}
																		<div class="forbidden">
																			<button enableday="{{offtime.disabled[stId][date]}}" title="Разрешить"><i class="fa fa-check-circle"></i></button>
																		</div>
																	{% endif %}
																</div>
															</div>
															
															<div class="offtime__content">
																{% if offtime.users[stId][date] %}
																	<ul class="users_list">
																		{% for userId, user in offtime.users[stId][date] %}
																			<li>{{user.role_name}} - {{user.nickname}}{% if current_date <= date %} <i title="Удалить участника из бронирования" disableuser="{{stId}}|{{date}}|{{userId}}" class="fa fa-trash"></i>{% endif %}</li>
																		{% endfor %}
																	</ul>
																{% endif %}
															</div>
														</td>
													{% endfor %}
												</tr>
											{% endfor %}
										</table>
									</div>
								{% endif %}
							{% endfor %}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>






<script type="text/javascript"><!--
$(document).ready(function() {
	//-------------------------------------------------------------------------------------------------- Выходные
	
	var history = 0, weeksStep = 4;
	$('[offtimehistory]').on(tapEvent, function() {
		var dir = $(this).attr('offtimehistory'),
			hash = location.hash.split('.');
		history = dir == '+' ? history+weeksStep : history-weeksStep;
		
		getAjaxHtml('operator/get_offtime_history', {history: history}, function(html) {
			$('#offtimeDataContent').html(html);
			
			if (hash[2] != undefined) {
				$('#'+hash[2]).addClass('active');
				$('[tabid="'+hash[2]+'"]').addClass('visible');
			} else {
				$('#offtimeDataContent').find('.tabstitles.sub li:first').addClass('active');
				$('#offtimeDataContent').find('.tabscontent [tabid]:first').addClass('visible');
			}
		});
	});
	
	
	
	$('#offtimeSave').on(tapEvent, function() {
		var rolesLimitsForm = new FormData($('#rolesLimitsForm')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/offtime/set_roles_limits',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: rolesLimitsForm,
			success: function(response) {
				if (response) {
					notify('Лимиты успешно сохранены!');
				} else {
					notify('Ошибка сохранения лимитов!', 'error');
				}
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	
	
	
	
	//----------------------------------------------- Запретить день
	$('body').off(tapEvent, '[disableday]').on(tapEvent, '[disableday]', function() {
		var thisItem = this,
			thisTd = $(thisItem).closest('td');
			thisData = $(thisItem).attr('disableday').split('|'),
			static = thisData[0],
			date = thisData[1];
		
		$.post('/offtime/disable_day', {date: date, static: static}, function(insertId) {
			if (insertId) {
				$(thisTd).addClass('disabled');
				$(thisTd).find('ul.users_list').remove();
				$(thisTd).find('.forbidden').html('<button enableday="'+insertId+'" title="Разрешить"><i class="fa fa-check-circle"></i></button>');
			} else {
				notify('Ошибка! Не удалось запретить день!', 'error');
			}
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	
	//----------------------------------------------- Разрешить день
	$('body').off(tapEvent, '[enableday]').on(tapEvent, '[enableday]', function() {
		var thisItem = this,
			thisTd = $(thisItem).closest('td');
			thisId = $(thisItem).attr('enableday');
		
		$.post('/offtime/enable_day', {id: thisId}, function(data) {
			if (data) {
				$(thisTd).removeClass('disabled');
				$(thisTd).find('.forbidden').html('<button class="remove" disableday="'+(data.static+'|'+data.date)+'" title="Запретить"><i class="fa fa-times"></i></button>');
			} else {
				notify('Ошибка! Не удалось разрешить день!', 'error');
			}
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	
	
	
	
	//----------------------------------------------- Удалить пользователя из бронирования
	$('body').off(tapEvent, '[disableuser]').on(tapEvent, '[disableuser]', function() {
		var thisItem = this,
			thisData = $(thisItem).attr('disableuser').split('|'),
			static = thisData[0],
			date = thisData[1],
			userId = thisData[2];
		
		$.post('/offtime/disable_user', {date: date, static: static, user: userId}, function(response) {
			if (response) {
				$(thisItem).closest('li').remove();
				notify('Участник удален из бронирования!');
			} else {
				notify('Ошибка! Участник не удален!', 'error');
			}
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	
	
	
	
	
});
//--></script>