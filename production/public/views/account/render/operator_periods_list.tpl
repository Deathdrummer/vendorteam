<table id="periodsList">
	<thead>
		<tr>
			<td>Название периода</td>
			<td class="w25">Выбрать</td>
		</tr>
	</thead>
	<tbody>
		{% if periods %}	
			{% for period in periods %}
				<tr>
					<td>{{period.name}}</td>
					<td class="nowidth"><div class="buttons"><button title="Выбрать период" chooseperiod="{{period.id}}"><i class="fa fa-check-square-o"></i></button></div></td>
				</tr>
			{% endfor %}
		{% endif %}
	</tbody>
</table>