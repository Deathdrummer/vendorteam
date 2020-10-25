{% if orders_patterns %}
	<table>
		<thead>
			<tr>
				<td>Название</td>
				<td>Период с:</td>
				<td>Период по:</td>
				<td>Отчет</td>
				<td>Экспорт</td>
			</tr>
		</thead>
		
		<tbody>
			{% for id, pattern in orders_patterns %}

				<tr>
					<td>{{pattern.report_name}}</td>
					<td class="w18">{{pattern.date_start|d}}</td>
					<td class="w18">{{pattern.date_end|d}}</td>
					<td class="nowidth">
						<div class="buttons">
							<button orderpatternid="{{id}}" title="Показать отчет"><i class="fa fa-bar-chart"></i></button>
						</div>
					</td>	
					<td class="nowidth">
						<div class="buttons">
							<a class="button" target="_self" href="reports/export_orders/{{id}}" download="{{pattern.report_name}}.txt" title="Экспортировать отчет"><i class="fa fa-download"></i></a>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}