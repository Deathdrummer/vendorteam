{% if boosters_history %}
	<h3>История изменения бустера</h3>
	<table id="boostersHistoryTable">
		<thead>
			<tr>
				<td class="w150px"><strong class="fz12px">Бустер</strong></td>
				<td class="w200px"><strong class="fz12px">Задан</strong></td>
			</tr>
		</thead>
		<tbody>
			{% for date, boooster in boosters_history %}
				<tr>
					<td class="fz12px">{{boooster}}</td>
					<td class="fz12px">{{date|d}} в {{date|t}}</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}