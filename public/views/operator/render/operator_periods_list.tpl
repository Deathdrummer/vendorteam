{% if periods %}	
	<div class="popup__data">
		<table id="periodsList" class="popup__table">
			<thead>
				<tr>
					<td>Название периода</td>
					<td class="nowidth center"><i class="fa fa-check"></i></td>
				</tr>
			</thead>
			<tbody>	
				{% for period in periods %}
					<tr>
						<td>{{period.name}}</td>
						<td><div class="buttons"><button title="Выбрать период" chooseperiod="{{period.id}}"><i class="fa fa-check"></i></button></div></td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}