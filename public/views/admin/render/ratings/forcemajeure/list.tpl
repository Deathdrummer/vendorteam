{% if list %}
	<table>
		<thead>
			<tr>
				<td class="w150px">Дата</td>
				<td>Причина</td>
				<td class="w80px">Операции</td>
			</tr>
		</thead>
		<tbody>
			{% for row in list %}
				<tr>
					<td>{{row.date|d}}</td>
					<td class="texttop"><small class="raw">{{row.message|raw}}</small></td>
					<td class="text-center">
						<div class="buttons inline">
							<button forcemajeureedit="{{row.id}}" class="small" title="Редактировать"><i class="fa fa-edit"></i></button>
							<button forcemajeureremove="{{row.id}}" class="small remove" title="Удалить"><i class="fa fa-trash"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %} 
		</tbody>
	</table>
{% endif %}