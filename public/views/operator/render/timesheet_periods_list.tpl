<table id="timesheetPeriodsList" class="popup__table">
	<thead>
		<tr>
			<td>Название периода</td>
			<td>Начало недели</td>
			<td colspan="2" class="w25">Операции</td>
		</tr>
	</thead>
	<tbody>
		{% if timesheet_periods %}
			{% for period in timesheet_periods %}
				<tr>
					<td>{{period.name}}</td>
					<td>{{period.start_date|d}}</td>
					<td class="nowidth"><div class="buttons"><button class="remove" title="Удалить период" removetimesheetperiod="{{period.id}}"><i class="fa fa-trash"></i></button></div></td>
					<td class="nowidth"><div class="buttons"><button title="Выбрать период" choosetimesheetperiod="{{period.id}}"><i class="fa fa-check"></i></button></div></td>
				</tr>
			{% endfor %}
		{% else %}
		<tr>
			<td colspan="4"><p class="empty center">Нет данных</p></td>
		</tr>
		{% endif %}
	</tbody>
</table>