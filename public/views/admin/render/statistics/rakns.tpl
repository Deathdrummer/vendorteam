{% if ranks %}
	<h4>Выберите звания</h4>
	<div id="ranksAmountList">
		<table>
			<thead>
				<tr>
					<td>Звание</td>
					<td class="center"><i class="fa fa-check-square fa-2x" id="ranksAmountSetAll"></i></td>
				</tr>
			</thead>
			<tbody>
				{% for rId, rankName in ranks %}
					<tr>
						<td>
							<p>{{rankName}}</p>
						</td>
						<td class="nowidth center">
							<div class="checkblock">
								<input id="ranksAmount{{rId}}" type="checkbox" value="{{rId}}">
								<label for="ranksAmount{{rId}}"></label>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>	
{% endif %}