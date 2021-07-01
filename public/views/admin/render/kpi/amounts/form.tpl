{% if statics and ranks %}
	<table id="kpiAmountsForm">
		<thead>
			<tr>
				<td>Статик/Звание</td>
				{% for rId, rName in ranks %}
					<td class="w120px"><small>{{rName}}</small></td>
				{% endfor %}
			</tr>
		</thead>
		<tbody>
			{% for stId, stName in statics %}
				<tr>
					<td>{{stName}}</td>
					{% for rId in ranks|keys %}
						<td>
							<div class="popup__field">
								<input type="number" min="0" showrows amountfield="{{stId}}|{{rId}}" value="{{amounts[stId][rId]|default(0)}}">
							</div>
						</td>
					{% endfor %}
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}