{% if reports %}
	<table>
		<thead>
		<tr>
			<td>Название</td>
			<td class="w96px">Опции</td>
		</tr>
		</thead>
		<tbody>
			{% for report in reports %}
				<tr>
					<td>{{report.title}}</td>
					<td class="center">
						<div class="buttons inline">
							<button class="small w35px" kpireport="{{report.id}}|{{report.periods}}" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
							<a href="{{base_url('kpi/statistics/export/'~report.id)}}" download="{{report.title}}.csv" class="button small alt w35px" title="Экспортировать отчет"><i class="fa fa-download"></i></a>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}