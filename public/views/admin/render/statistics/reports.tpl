{% if reports.total %}
	<h4>Выберите отчеты</h4>
	<div id="reportsAmountList">
		<table>
			<thead>
				<tr>
					<td>Отчет</td>
					<td class="center"><i class="fa fa-check-square fa-2x" id="reportsAmountSetAll"></i></td>
				</tr>
			</thead>
			<tbody>
				{% for id, title in reports.items %}
					<tr>
						<td>
							<div class="d-flex align-items-center">
								<p>{{title}}</p>
							</div>
						</td>
						<td class="nowidth center">
							<div class="checkblock">
								<input id="reportsAmount{{id}}" type="checkbox" value="{{id}}">
								<label for="reportsAmount{{id}}"></label>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}