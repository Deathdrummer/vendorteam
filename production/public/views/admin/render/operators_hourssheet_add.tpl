<tr class="operators_hourssheet_new">
	<td>
		<select name="hourssheet[new][{{index}}][time_start_h]">
			{% for hour in 0..23 %}
				<option value="{{hour}}">{{hour|add_zero}}</option>
			{% endfor %}
		</select>
		<select name="hourssheet[new][{{index}}][time_start_m]">
			{% for minute in minutes %}
				<option value="{{minute}}">{{minute|add_zero}}</option>
			{% endfor %}
		</select>
		-
		<select name="hourssheet[new][{{index}}][time_end_h]">
			{% for hour in 0..23 %}
				<option value="{{hour}}">{{hour|add_zero}}</option>
			{% endfor %}
		</select>
		<select name="hourssheet[new][{{index}}][time_end_m]">
			{% for minute in minutes %}
				<option value="{{minute}}">{{minute|add_zero}}</option>
			{% endfor %}
		</select>
	</td>
	<td class="nowidth">
		<div class="buttons">
			<button class="remove" title="Удалить" deletehourssheet><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>