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
							<button class="small w32px" kpiv2buildreportbtn="{{row.id}}"><i class="fa fa-bar-chart"></i></button>
							<button class="small w32px pay"><i class="fa fa-download"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>	
{% endif %}