{% if statics and ranks %}
	<table id="kpiAmountsForm">
		<thead>
			<tr>
				<td class="w200px">Статик/Звание</td>
				{% for rId, rName in ranks %}
					<td class="w140px"><small>{{rName}}</small></td>
				{% endfor %}
			</tr>
		</thead>
		<tbody>
			{% for stId, stName in statics %}
				<tr>
					<td>{{stName}}</td>
					{% for rId in ranks|keys %}
						<td class="pt4px pb4px">
							<div class="d-flex align-items-center mt4px">
								<strong class="mr3px">Р</strong>
								<div class="popup__field">
									<input type="text" class="h26px" min="0" amountfield="{{stId}}|{{rId}}|1" value="{{amounts[stId][rId][1]}}">
								</div>
							</div>
							<div class="d-flex align-items-center">
								<strong class="mr3px">В</strong>
								<div class="popup__field">
									<input type="text" class="h26px" min="0" amountfield="{{stId}}|{{rId}}|2" value="{{amounts[stId][rId][2]}}">
								</div>
							</div>
						</td>
					{% endfor %}
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}