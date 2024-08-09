<form class="popup__form" id="timesheetRaidForm">
	<div class="popup__form_item">
		<div><label for="">Тип рейда:</label></div>
		<div>
			<div class="select">
				<select name="timesheet_raid[raid]" id="newTimesheetRaidType">
					{% if raids_types %}
						<option value="" disabled="" selected="">Выбрать</option>
						{% for raid in raids_types %}
							{% if edit_raid_id == raid.id %}
								<option value="{{raid.id}}" selected="" duration="{{raid.duration_hours}}|{{raid.duration_minutes}}">{{raid.name}}</option>
							{% else %}
								<option value="{{raid.id}}" duration="{{raid.duration_hours}}|{{raid.duration_minutes}}">{{raid.name}}</option>
							{% endif %}
						{% endfor %}	
					{% else %}
						<option value="" disabled="">Нет данных</option>
					{% endif %}	
				</select>
				<div class="select__caret"></div>
			</div>	
		</div>
	</div>
	
	
	<div class="popup__form_item">
		<div><label for="">Время начала:</label></div>
		<div>
			<div class="number time">
				<input type="number" name="timesheet_raid[time_start][h]" min="0" max="23" step="1" {% if edit_time_start_h is defined %} value="{{edit_time_start_h}}" {% endif %}>
			</div>
			<span>ч.</span>
			
			<div class="number time">
				<input type="number" name="timesheet_raid[time_start][m]" min="0" max="59" step="5" {% if edit_time_start_m is defined %} value="{{edit_time_start_m}}" {% endif %}>
			</div>
			<span>мин.</span>
		</div>
	</div>
	
	
	{# <div class="popup__form_item">
		<div><label for="">Длительность:</label></div>
		<div>
			<div class="number time">
				<input type="number" name="timesheet_raid[duration][h]" id="newRaidDurationHour" min="0" max="23" step="1" {% if edit_duration_h is defined %} value="{{edit_duration_h}}" {% endif %}>
			</div>
			<span>ч.</span>
			
			<div class="number time">
				<input type="number" name="timesheet_raid[duration][m]" id="newRaidDurationMinute" min="0" max="59" step="5" {% if edit_duration_m is defined %} value="{{edit_duration_m}}" {% endif %}>
			</div>
			<span>мин.</span>
		</div>
	</div> #}
	
	
	<div class="popup__form_item">
		{% if edit %}
			<div><label for="">Обновить другие дни:</label></div>
			<div class="checks">
				{% for d in 1..7 %}
					<div class="center">
						<small>День {{d}}</small>
						<div class="checkblock">
							{% if edit_raids[d] is not defined %}
								<input type="checkbox" disabled="">
								<label></label>
							{% else %}
								<input type="checkbox" id="day{{d}}" name="timesheet_raid[edit][{{edit_raids[d]}}]" value="1">
								<label for="day{{d}}"></label>
							{% endif %}
						</div>
					</div>
				{% endfor %}
			</div>
		{% else %}
			<div><label for="">Клонировать в другие дни:</label></div>
			<div class="checks">
				{% for d in 1..7 %}
					<div class="center">
						<small>День {{d}}</small>
						<div class="checkblock">
							{% if day == d %}
								<input type="checkbox" disabled="" checked="">
								<label></label>
							{% else %}
								<input type="checkbox" id="day{{d}}" name="timesheet_raid[clone][{{d}}]" value="1">
								<label for="day{{d}}"></label>
							{% endif %}
						</div>
					</div>
				{% endfor %}
			</div>
		{% endif %}	
	</div>
</form>