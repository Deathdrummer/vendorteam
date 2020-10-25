<div id="enabledRanksWin">
	<div class="d-flex flex-column justify-content-center align-items-center text-center mb-3">{{static|raw}}</div>

	<table>
		<thead>
			<tr>
				<td>Список званий</td>
				<td class="center w50px"><i class="fa fa-check"></i></td>
			</tr>
		</thead>
		<tbody>
			{% for rid, rank in ranks %}
				<tr>
					<td>{{rank.name}}</td>
					<td class="center">
						<div class="checkblock">
							<input type="checkbox" id="monthday{{rid}}"{% if rid in enabled_ranks %} checked{% endif %} enablerank="{{rid}}">
							<label for="monthday{{rid}}"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
</div>