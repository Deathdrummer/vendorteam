<div id="disabledDaysWin">
	<div class="d-flex flex-column justify-content-center align-items-center text-center mb-3">{{static|raw}}</div>
	
	<table class="mb-4">
		<thead>
			<tr>
				<td colspan="{{week_names|length}}">Дни недели</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				{% for k, day in week_names %}
					<td class="center">
						<div>
							<p><small>{{day}}</small></p>
							<div class="checkblock">
								<input type="checkbox" id="weekday{{k}}"{% if k in week_days %} checked{% endif %} weekday="{{k}}">
								<label for="weekday{{k}}"></label>
							</div>
						</div>
					</td>
				{% endfor %}
			</tr>
		</tbody>
	</table>

	<table>
		<thead>
			<tr>
				<td colspan="7">Дни месяца</td>
			</tr>
		</thead>
		<tbody>
			{% for day in 1..31 %}
				{% if day in [1,8,15,22] %}<tr>{% endif %}
					<td class="center">
						<div>
							<p><small>{{day}}</small></p>
							<div class="checkblock">
								<input type="checkbox" id="monthday{{day}}"{% if day in month_days %} checked{% endif %} monthday="{{day}}">
								<label for="monthday{{day}}"></label>
							</div>
						</div>
					</td>
				{% if day in [7,14,21,28] %}</tr>{% endif %}
			{% endfor %}
		</tbody>
	</table>
</div>