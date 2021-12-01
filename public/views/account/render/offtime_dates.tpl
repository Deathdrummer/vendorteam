<div class="popup__title">
	<h6>{{statics_names[static]}}</h6>
</div>


<div class="d-flex align-items-center mb15px">
	<p class="mr10px">Сместить диапазон:</p>
	<div class="buttons notop left">
		<button offtimehistory="-" class="small w34px main" title="На месяц назад"><i class="fa fa-angle-left"></i></button>
		<button{% if history_disabled %} disabled{% else %} offtimehistory="+"{% endif %} class="small w34px main" title="На месяц вперед"><i class="fa fa-angle-right"></i></button>
	</div>
</div>

<div class="popup__data">
	<div class="offtime">
		<table class="popup__table">
			{% for week in offtime_dates|batch(7) %}
				<tr>
					{% for date in week %}
						{% if disabled[static][date] is not defined and current_date < (date - location.timeoffset) %}
							<td>
								<div class="offtime__title">
									<strong>{{date|d}}</strong>
									<small>{{date|week}}</small>
								</div>
								
								<div class="offtime__content">
									<ul class="users_list">
										{% if users[date]['users'] %}
											{% for user in users[date]['users'] %}
												<li>
													<p>{{user.nickname}}</p>
													<small>{{user.role_name}}</small>
												</li>
											{% endfor %}
										{% endif %}
									</ul>
								</div>
								
								{% if (users[date]['users'][user_id] is not defined and users[date]['roles'][role] == true) or users[date]['roles'][role] is not defined %}
									<div class="buttons">
										<button setofftime="{{user_id}}|{{static}}|{{role}}|{{date}}">Забронировать</button>
									</div>
								{% elseif users[date]['users'][user_id] is not defined and users[date]['roles'][role] == false and users[date]['users']|length > 0 %}
									<div class="buttons">
										<button disabled>Нет мест</button>
									</div>
								{% elseif users[date]['users'][user_id] is defined %}
									<div class="buttons">
										<button unsetofftime="{{users[date]['users'][user_id]['id']}}|{{static}}">Снять бронь</button>
									</div>
								{% endif %}
								
							</td>
						{% else %}
							<td class="disabled">
								<div class="offtime__title">
									<strong>{{date|d}}</strong>
									<small>{{date|week}}</small>
								</div>
								<div class="offtime__content offtime__content_closed">
									
									<ul class="users_list">
										{% if users[date]['users'] %}
											{% for user in users[date]['users'] %}
												<li>
													<p>{{user.nickname}}</p>
													<small>{{user.role_name}}</small>
												</li>
											{% endfor %}
										{% endif %}
									</ul>
								</div>
							</td>
						{% endif %}
					{% endfor %}
				</tr>
			{% endfor %}
		</table>
	</div>
</div>