{% if periods %}
	<table id="coefficientsPeriods">
		<thead>
			<tr>
				<td>Период</td>
				<td class="w50px center"><i class="fa fa-check"></i></td>
			</tr>
		</thead>
		<tbody>
			{% for period in periods %}
				<tr>
					<td>{{period.name}}</td>
					<td>
						<div class="buttons">
							<button class="small w30px" coefficientschooseperiod="{{period.id}}"><i class="fa fa-check"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% else %}
	<p class="empty">Нет периодов</p>
{% endif %}