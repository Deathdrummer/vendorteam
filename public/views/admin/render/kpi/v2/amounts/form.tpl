{% if statics and ranks %}
	<table id="kpiAmountsForm">
		<thead>
			<tr>
				<td class="w200px">Статик/Звание</td>
				{% for rId, rName in ranks %}
					<td class="w100px"><small>{{rName}}</small></td>
				{% endfor %}
			</tr>
		</thead>
		<tbody>
			{% for stId, stName in statics %}
				<tr>
					<td>
						<div class="d-flex align-items-center justify-content-between">
							<p class="mr10px fz14px">{{stName}}</p>
							<div class="d-flex flex-column justify-content-between h40px">
								<strong class="mb5px fz12px" title="Регулярный">Рег.</strong>
								<hr class="w100 smooth">
								<strong class="fz12px" title="Высокий">Выс.</strong>
							</div>
						</div>
					</td>
					{% for rId in ranks|keys %}
						<td class="pt4px pb4px">
							<div class="d-flex align-items-center mb3px">
								<div class="popup__field">
									<input type="text" class="h24px" min="0" amountfield="{{stId}}|{{rId}}|1" value="{{amounts[stId][rId][1]}}" title="{{stName}} - Регулярный" autocomplete="off">
								</div>
							</div>
							<div class="d-flex align-items-center">
								<div class="popup__field">
									<input type="text" class="h24px" min="0" amountfield="{{stId}}|{{rId}}|2" value="{{amounts[stId][rId][2]}}" title="{{stName}} - Высокий" autocomplete="off">
								</div>
							</div>
						</td>
					{% endfor %}
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}