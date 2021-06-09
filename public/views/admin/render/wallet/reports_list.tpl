{% if reports %}
	<div id="walletReportsList">
		<table>
			<thead>
				<tr>
					<td>Название отчета</td>
					<td>Дата выплаты</td>
					<td class="w80px">Опции</td>
				</tr>
			</thead>
			<tbody>
				{% for report in reports %}
					<tr>
						<td reporttitle>{{report.title}}</td>
						<td reportdate>{{report.date|d}}</td>
						<td class="center">
							<div class="buttons inline">
								<button class="small w30px" buildsavedreport="{{report.id}}" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
								<a class="button small alt w30px ml4px" target="_self" href="{{base_url('reports/wallet/get_saved_report/'~report.id)}}" download="{{report.title}}_{{date('Y-m-d', report.date)}}.csv" title="Экспорт отчета"><i class="fa fa-download"></i></a>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}