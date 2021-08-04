{% if periods.total %}
	<strong class="fz14px">Выбрать период</strong>
	{% if single %}
		<ul class="popup__list popup__list_vertical">
			{% for period in periods.items %}
				<li class="h60px" kpistatbonusperiod="{{period.id}}">
					<strong class="d-block">{{period.title}}</strong>
					<small>c {{period.date_start|d}} по {{period.date_end|d}}</small>
				</li>
			{% endfor %}
		</ul>
	{% else %}
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
		
{% endif %}