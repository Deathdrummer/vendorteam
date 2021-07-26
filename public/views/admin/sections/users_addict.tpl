<div class="section" id="usersAddictSection">
	<div class="section__title">
		<h1>Участники (дополнительные поля)</h1>
	</div>
	
	
	
	{# <div class="section__buttons nowidth mb-3">
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
	</div> #}
	
	
	
			
	


	<div class="section__content" id="sectionContent">
		{% if users %}
			<ul class="tabstitles">
				<li id="tabActiveUsers">Верифицированные</li>
				<li id="tabNewUsers">Новые</li>
				<li id="tabDeletedUsers">Удаленные</li>
			</ul>
			
			<div class="tabscontent">
				{% for tabid, udata in {'tabActiveUsers': users.active, 'tabNewUsers': users.new, 'tabDeletedUsers': users.deleted} %}
					<div tabid="{{tabid}}">
						{% if udata|length > 0 %}
							<ul class="tabstitles sub">
								{% if udata[0] is defined %}
									<li id="tab0">Статик не задан</li>
								{% endif %}
								{% for sId, sData in statics %}
									{% if udata[sId] is defined %}
										<li id="tab{{sId}}" group="{{statics[sId]['group']}}">{% if sId == 0 %}Статик не задан{% else %}{{statics[sId]['name']|default('Статик удален')}}{% endif %}</li>
									{% endif %}
								{% endfor %}
							</ul>
							
							<div class="tabscontent">
								{% for staticId, usersData in udata %}
									<div tabid="tab{{staticId}}">
										{% if usersData %}
											<table id="{{tabid}}Table" userstable>
												<thead>
													<tr>
														<td class="w240px">Участник</td>
														<td class="w250px">Скриншот (ссылка)</td>
														<td></td>
													</tr>
												</thead>
												
												<tbody userslistrows>
													{% for uid, user in usersData %}
														<tr userid="{{user.id}}">
															<td>
																<div class="d-flex">
																	<img src="{{base_url('public/images/users/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="" class="avatar w40px h40px">
																	<div class="ml5px">
																		<strong class="fz14px d-block">{{user.nickname}}</strong>
																		<small class="fz12px">{{ranks[user.rank]['name']}}</small>
																	</div>
																</div>
															</td>
															<td>
																<div class="field">
																	<input type="text" userid="{{uid}}" field="screenshot" value="{{user.screenshot}}">
																</div>
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
						{% else %}
							<p class="empty">Нет данных</p>
						{% endif %}
					</div>
				{% endfor %}
			</div>
			
			
			
		{% endif %}
	</div>
</div>










<script type="text/javascript"><!--

$(document).on('renderSection', function() {
	ddrInitTabs('usersAddictSection');
	
	$('[userstable]').each(function() {
		$(this).ddrScrollTableY({
			height: 'calc(100vh - 368px)',
			minHeight: '80px',
			//cls: false,
			wrapBorderColor: '#c8ced4',
			//offset: 0
		});
	});
	
	let changeFieldTOut;
	$('#usersAddictSection').changeInputs(function(input, event) {
		$(input).closest('td').removeClass('changed');
		let userId = $(input).attr('userid'),
			field = $(input).attr('field'),
			value = null;
		
		if (!userId || !field) return false;
		if (event.st == 'checkbox') {
			value = $(input).is(':checked') ? 1 : 0;
		} else {
			value = $(input).val();
		}
		
		//clearTimeout(changeFieldTOut);
		changeFieldTOut = setTimeout(function() {
			saveFieldValue(userId, field, value, function() {
				$(input).closest('td').addClass('changed');
			});
			
		}, 500);
	});
	
	
	
	
	
});


function saveFieldValue(userId, field, value, callback) {
	$.post('/admin/set_user_field', {user_id: userId, field: field, value: value}, function(response) {
		if (response) {
			if (callback && typeof callback == 'function') callback();
		} else {
			notify('Ошибка! Не удалось сохранить значение', 'error');
		}
	});
}




$(document).ready(function() {
	
	
	
	
});
//--></script>