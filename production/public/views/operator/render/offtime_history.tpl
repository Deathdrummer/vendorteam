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