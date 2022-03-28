<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Статистика (участники)</h2>
		<div class="buttons notop" id="{{id}}SaveBlock">
			<button class="large" id="{{id}}Save" title="Сохранить"><i class="fa fa-save"></i> <span>Сохранить</span></button>
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
										<li id="tab{{sId}}">{{statics[sId]['name']|default('Статик не задан')}}</li>
									{% endif %}
								{% endfor %}
							</ul>
							
							<div class="tabscontent">
								{% for staticId, usersData in udata %}
									<div tabid="tab{{staticId}}">
										<strong>{{statics[staticId]['name']|default('Статик не задан')}}</strong>
										
										{% if usersData %}
											<table id="{{tabid}}Table">
												<thead>
													<tr>
														<td></td>
														<td{% if sort_field == 'u.nickname' %} class="active"{% endif %}>Никнейм <i class="fa fa-sort" userssortfield="u.nickname" sortorder="{{sort_order}}"></i></td>
														<td>Общий кэш</td>
														<td>Кол-во дней</td>
														<td>Средний заработок</td>
														<td></td>
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
															<td class="w200px">
																<p>{{user.nickname}}</p>
															</td>
															<td class="nowidth w100px">
																<div class="number short">
																	<input type="number" class="user_statistics_cash wpx50" value="{{user.statistics_cash}}" placeholder="Не задан">
																</div>
																<small>{{currency}}</small>
															</td>
															<td class="nowidth w100px">
																<div class="number short">
																	<input type="number" class="user_statistics_days wpx50" value="{{user.statistics_days}}" placeholder="Не задан">
																</div>
																<small>дн.</small>
															</td>
															<td class="w170px">
																{% if user.pay %}
																	<p>{{currency(user.pay)}}</p>
																{% else %}
																	<p class="empty">Нет данных</p>
																{% endif %}
															</td>
															<td></td>
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
		</div>
		
		
	</fieldset>
</div>








<script type="text/javascript"><!--
$(document).ready(function() {
	
	$('#statistics').find('.user_statistics_cash').number(true, 2, '.', ' ');
	
	
	
	$('[userslistrows]').changeRowInputs(function(row, item) {
		$(row).addClass('changed');
	});
	
	var thisField = $('#sortField').val(),
		thisOrder = $('#sortOrder').val();
		
	$('[userssortfield]').on(tapEvent, function() {
		thisField = $(this).attr('userssortfield');
		thisOrder = $(this).attr('sortorder');
		renderSection({field: thisField, order: (thisOrder == 'ASC' ? 'DESC' : 'ASC')});
	});
	
	
	
	$('*').off('keyup').on('keyup', function(e) {
		if (e.keyCode == 13) {
			$('#statisticsSave').trigger('click');
			return false;
		} 
	});
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Задать данные верифицированных пользователей
	$('#statisticsSave').on(tapEvent, function() {
		var usersData = [];
		if ($('#statistics').find('tbody tr.changed').length == 0) {
			notify('Нет данных для сохранения!', 'info');
			return false;
		}
		
		$('#statistics').find('tbody tr.changed').each(function() {
			var thisRow = $(this),
				thisUserId = $(this).attr('userid'),
				thisUserNickname = $(thisRow).find('.user_nickname'),
				thisUserStatCash = $(thisRow).find('.user_statistics_cash'),
				thisUserStatDays = $(thisRow).find('.user_statistics_days');
			
			var user = {
				id: thisUserId,
				nickname: $(thisUserNickname).val(),
				statistics_cash: $(thisUserStatCash).val(),
				statistics_days: $(thisUserStatDays).val()
			}
			usersData.push(user);
		});
		
		
		$.ajax({
			type: 'POST',
			url: '/admin/set_users_stat',
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
	
});

//--></script>