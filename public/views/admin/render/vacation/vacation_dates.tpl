{% if statics_names %}
	<ul class="tabstitles sub">
		{% for staticId, staticName in statics_names %}
			<li id="tabStatic{{staticId}}">{{staticName}}</li>
		{% endfor %}
	</ul>
	
	
	
	
	<div class="tabscontent">
		{% for staticId, staticName in statics_names %}
			<div tabid="tabStatic{{staticId}}">
				<div class="d-flex align-items-center mb-2">
					<strong class="mr-3">{{staticName}}</strong>
					<div class="buttons notop minspace section__buttons mb-0" id="vacationActionButtons">
						<button vacationaction="set" class="small" disabled title="Задать день отпуска"><i class="fa fa-plus"></i></button>
						<button vacationaction="confirm" class="small" disabled title="Подтвердить"><i class="fa fa-check"></i></button>
						<button vacationaction="remove" class="remove small" disabled title="Отменить"><i class="fa fa-trash"></i></button>
					</div>
				</div>
				
				{% if vacation_users[staticId] %}
					<table class="vacation_table noselect" id="vacationTable">
						<thead>
							<tr>
								<td rowspan="2" class="names">
									<div class="d-flex align-items-center justify-content-between">
										<span>Имя</span>
										<div>
											<i class="fa fa-chevron-left" shiftweeks="back" title="На неделю назад"></i>
											<i class="fa fa-chevron-right" shiftweeks="forward" title="На неделю вперед"></i>
										</div>
									</div>
									
								</td>
								{% for m, d in dates[staticId] %}
									<td colspan="{{d|length}}">
										<p class="month">{{m}}</p>
									</td>
								{% endfor %}
							</tr>
							<tr>
								{% for m, d in dates[staticId] %}
									{% for day in d %}
										<td class="day {{day|date('D')|lower}}{% if day in disabled_static_dates[staticId] %} disabled{% endif %}{% if day in disabled_dates[staticId] %} noedited{% endif %}"{% if day not in disabled_dates[staticId] %} vacationdisabledstaticday="{{staticId}}|{{day}}"{% endif %} title="{% if day in disabled_static_dates[staticId] %}Разрешить{% else %}Запретить{% endif %}">
											<p>{{day|date('j')}}</p>
										</td>
									{% endfor %}
								{% endfor %}
							</tr>
						</thead>
						<tbody>
							{% for user in vacation_users[staticId] %}
								<tr{% if user['user_id'] == user_id %} class="edited"{% endif %} vacationuser="{{user_id}}" vacationstatic="{{staticId}}">
									<td class="names">
										<div class="d-flex align-items-center">
											{% if user['avatar'] %}
												<div class="avatar mini mr-1" style="background-image: url({{base_url('public/images/users/mini/'~user['avatar'])}})"></div>
											{% else %}
												<div class="avatar mini mr-1" style="background-image: url({{base_url('public/images/user_mini.jpg')}})"></div>
											{% endif %}
											<span>{{user['nickname']}}</span>
										</div>
									</td>
									{% for day in vacation_dates[staticId] %}
										<td setvacation="{{user['user_id']}}|{{staticId}}|{{day}}" class="{{day|date('D')|lower}}{% if day in user['dates']|keys %} vacated{% endif %}{% if day in disabled_dates[staticId] or day in disabled_static_dates[staticId] %} disabled{% endif %}{% if user['dates'][day] == 1 %} confirmed{% endif %}"></td>
									{% endfor %}
								</tr>
							{% endfor %}
						</tbody>
					</table>
				{% else %}
					<p class="empty">Нет данных</p>
				{% endif %}
			</div>
		{% endfor %}
	</div>
{% endif %}