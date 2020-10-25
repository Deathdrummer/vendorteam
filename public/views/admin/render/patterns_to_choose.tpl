{% if patterns_list and not append %}
	<table>
		<thead>
			<tr>
				<td>Название</td>
				<td class="center"><i class="fa fa-check-square"></i></td>
			</tr>
		</thead>
		
		<tbody>
			{% for id, pattern in patterns_list %}
				<tr>
					<td>{{pattern.report_name}}</td>
					<td class="square_block w3">
						<div choosepattern="1" paymentspatternid="{{id}}" class="forbidden" title=""><i class="fa fa-check-square-o"></i></div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% elseif patterns_list and append %}
	{% for id, pattern in patterns_list %}
		<tr>
			<td>{{pattern.report_name}}</td>
			<td class="square_block w3">
				<div choosepattern="1" paymentspatternid="{{id}}" class="forbidden" title=""><i class="fa fa-check-square-o"></i></div>
			</td>
		</tr>
	{% endfor %}
{% endif %}