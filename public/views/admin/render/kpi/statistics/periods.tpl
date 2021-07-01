{% if periods.total %}
	<strong class="fz14px">Выбрать период</strong>
	<table>
		<thead>
			<tr>
				<td>Период</td>
				<td class="w40px"></td>
			</tr>
		</thead>
		<tbody id="kpiStatPeriods">
			{% for period in periods.items %}
				<tr>
					<td>{{period.title}}</td>
					<td class="center">
						<div class="popup__checkbox">
							<input type="checkbox" id="kpiPeriod{{period.id}}" kpistatperiod value="{{period.id}}">
							<label for="kpiPeriod{{period.id}}"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}