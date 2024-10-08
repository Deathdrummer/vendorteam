{% if reports_patterns %}
	<ul class="tabstitles sub">
		<li id="tabStandartReports" class="active">Стандартный отчет</li>
		<li id="tabCumulativeReports">Накопительный отчет</li>
	</ul>
	
	<div class="tabscontent">
		<div tabid="tabStandartReports" class="visible">
			<table class="popup__table">
				<thead>
					<tr>
						<td>Название</td>
						<td>Бюджет статиков</td>
						<td>Отчет</td>
						<td>Экспорт</td>
						<td class="nowrap">В архив</td>
					</tr>
				</thead>
				
				<tbody>
					{% for id, pattern in reports_patterns.wallet %}
						<tr>
							<td>{{pattern.report_name}}</td>
							<td class="w30">
								<ul class="list_overflow patterns">
									{% for static, cash in pattern.cash %}
										<li>{{statics[static]['name']}} <strong>{{currency(cash)}}</strong></li>
									{% endfor %}
								</ul>
							</td>
							<td class="nowidth center">
								<div class="buttons inline">
									<button{% if is_key %} patternkeyid="{{id}}"{% else %} patternid="{{id}}"{% endif %} title="Показать отчет"><i class="fa fa-bar-chart"></i></button>
								</div>
							</td>
							<td class="nowidth center">
								<div class="buttons inline">
									<a class="button" target="_self" href="reports/{% if is_key %}export_keys_payments{% else %}export_payments{% endif %}/{{id}}/{{pattern.variant}}" download="{{pattern.report_name}}.csv" title="Экспортировать отчет"><i class="fa fa-download"></i></a>
								</div>
							</td>
							<td class="nowidth center">
								<div class="buttons inline">
									<button class="remove" patternkeytoarchive="{{id}}" title="В архив"><i class="fa fa-trash"></i></button>
								</div>
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
		
		<div tabid="tabCumulativeReports">
			<table class="popup__table">
			<thead>
					<tr>
						<td>Название</td>
						<td>Бюджет статиков</td>
						<td>Отчет</td>
						{# <td>Экспорт</td> #}
						<td class="nowrap">В архив</td>
					</tr>
				</thead>
				
				<tbody>
					{% for id, pattern in reports_patterns.cumulative %}
						<tr>
							<td>{{pattern.report_name}}</td>
							<td class="w30">
								<ul class="list_overflow patterns">
									{% for static, cash in pattern.cash %}
										<li>{{statics[static]['name']}} <strong>{{currency(cash)}}</strong></li>
									{% endfor %}
								</ul>
							</td>
							<td class="nowidth center">
								<div class="buttons inline">
									<button{% if is_key %} patternkeyid="{{id}}"{% else %} patternid="{{id}}"{% endif %} title="Показать отчет"><i class="fa fa-bar-chart"></i></button>
								</div>
							</td>
							{# <td class="nowidth center">
								<div class="buttons inline">
									<a class="button" target="_self" href="reports/{% if is_key %}export_keys_payments{% else %}export_payments{% endif %}/{{id}}/{{pattern.variant}}" download="{{pattern.report_name}}.csv" title="Экспортировать отчет"><i class="fa fa-download"></i></a>
								</div>
							</td> #}
							<td class="nowidth center">
								<div class="buttons inline">
									<button class="remove" patternkeytoarchive="{{id}}" title="В архив"><i class="fa fa-trash"></i></button>
								</div>
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
	</div>
{% endif %}