{% if reports_patterns %}
	<div class="popup__title">
		<h6>Выберите отчет</h6>
	</div>

	<div class="popup__data">
		<div class="payments">
			<table class="popup__table popup__table_hover">
				<thead>
					<tr>
						<td>Название</td>
						<td>Отчет</td>
					</tr>
				</thead>
				
				<tbody>
					{% for id, pattern in reports_patterns %}
						<tr>
							<td>{{pattern.report_name}}</td>
							<td class="w1 center">
								<button{% if is_key %} patternkeyid="{{id}}"{% else %} patternid="{{id}}"{% endif %} patternname="{{pattern.report_name}}" patternperiodid="{{pattern.period_id}}" title="Показать отчет">
									<i class="fa fa-table"></i>
								</button>
							</td>	
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
	</div>
{% endif %}