<p class="center">на {{date|d}}</p>

<form id="operatorsHourssheetForm">
	<table id="hourssheetDataTable" class="mb-3">
		<thead>
			<tr>
				<td>Приемные часы</td>
				<td></td>
			</tr>
		</thead>
		<tbody>
			{% if hourssheet %}
				{% for date, item in hourssheet %}
					<tr>
						<td>
							<select name="hourssheet[has][{{item.id}}][time_start_h]">
								{% for hour in 0..23 %}
									<option value="{{hour}}"{% if item.time_start_h == hour %} selected{% endif %}>{{hour|add_zero}}</option>
								{% endfor %}
							</select>
							<select name="hourssheet[has][{{item.id}}][time_start_m]">
								{% for minute in minutes %}
									<option value="{{minute}}"{% if item.time_start_m == minute %} selected{% endif %}>{{minute|add_zero}}</option>
								{% endfor %}
							</select>
							-
							<select name="hourssheet[has][{{item.id}}][time_end_h]">
								{% for hour in 0..23 %}
									<option value="{{hour}}"{% if item.time_end_h == hour %} selected{% endif %}>{{hour|add_zero}}</option>
								{% endfor %}
							</select>
							<select name="hourssheet[has][{{item.id}}][time_end_m]">
								{% for minute in minutes %}
									<option value="{{minute}}"{% if item.time_end_m == minute %} selected{% endif %}>{{minute|add_zero}}</option>
								{% endfor %}
							</select>
						</td>
						<td class="nowidth">
							<div class="buttons">
								<button class="remove" title="Удалить" deletehourssheet="{{item.id}}"><i class="fa fa-trash"></i></button>
							</div>
						</td>
					</tr>
				{% endfor %}
			{% endif %}
			<tr>
				<td></td>
				<td class="nowidth">
					<div class="buttons">
						<button title="Добавить" newhourssheet><i class="fa fa-plus"></i></button>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
	
	<p class="center">Клонировать расписание:</p>
	<table class="mt-1 noselect" id="cloneHourssheetDate">
		<thead>
			<tr>
				{% for day in week %}
					<td>{{day}}</td>
				{% endfor %}
			</tr>
		</thead>
		<tbody>
			{% for week in dates|chunk(7) %}
				<tr>
					{% for date in week %}
						<td{% if date == current_date %} disabled{% endif %} clonehourssheetdate="{{date}}">{{date|d(true)}}</td>
					{% endfor %}
				</tr>
			{% endfor %}
		</tbody>
	</table>
</form>