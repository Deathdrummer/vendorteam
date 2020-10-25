<div class="popup__title d-flex justify-content-between align-items-center">
	<h6><small>Статик:</small> {{statics_names[static]}}</h6>
	
	<div class="buttons noselect">
		<button vacationshift="prev" title="На неделю назад"><i class="fa fa-chevron-left"></i></button>
		<button vacationshift="next" title="На неделю вперед"><i class="fa fa-chevron-right"></i></button>
	</div>
</div>



<div class="popup__data">
	<div class="vacation">
		<input type="hidden" id="setVacationsLimit" value="{{vacations_limit}}">
		<input type="hidden" id="vacationsSpace" value="{{vacations_space}}">
		<input type="hidden" id="vacationsParty" value="{{vacations_party}}">
		<table class="popup__table noselect" id="vacationTable">
			<thead>
				<tr>
					<td rowspan="2" class="names">Имя</td>
					{% for m, d in dates %}
						<td colspan="{{d|length}}">
							<p class="month">{{m}}</p>
						</td>
					{% endfor %}
				</tr>
				<tr>
					{% for m, d in dates %}
						{% for day in d %}
							<td class="{{day|date('D')|lower}}{% if day < enabled_point %} out{% endif %}{% if day == current_date %} current{% endif %}">
								<p>{{day|date('j')}}</p>
							</td>
						{% endfor %}
					{% endfor %}
				</tr>
			</thead>
			<tbody>
				{% for uId, user in vacation_users %}
					<tr{% if uId == user_id %} class="edited"{% endif %} vacationuser="{{user_id}}" vacationstatic="{{static}}">
						<td class="names">{{user['nickname']}}</td>
						{% for day in vacation_dates %}
							<td{% if uId == user_id %} setvacation="{{day}}"{% endif %} class="{{day|date('D')|lower}}{% if day in user['dates']|keys %} vacated{% endif %}{% if uId == user_id and day in disabled_dates %} disabled{% endif %}{% if user['dates'][day] == 1 %} confirmed{% endif %}{% if uId == user_id and day < enabled_point %} out{% endif %}"{% if uId == user_id and (day in disabled_dates or day < enabled_point) %} title="Запрещено"{% endif %}></td>
						{% endfor %}
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
</div>