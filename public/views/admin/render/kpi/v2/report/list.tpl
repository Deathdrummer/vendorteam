{% if list %}
	<table id="kpiv2ReportsTable">
		<thead>
			<tr>
				<td><strong>Отчет</strong></td>
				<td class="w84px"><strong>Опции</strong></td>
			</tr>
		</thead>
		<tbody>
			{% for row in list %}
				<tr>
					<td>
						<p>{{row.title}}</p> 
						<small class="grayblue">{{row.date|d}}</small>
					</td>
					<td>
						<div class="buttons">
							<button class="small w32px" kpiv2buildreportbtn="{{row.id}}" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
							<a href="{{base_url('kpiv2/report/export/'~row.id)}}" class="button small w32px pay" download="{{row.title}}.csv" title="Экспорт отчета"><i class="fa fa-download"></i></a>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>	
{% endif %}