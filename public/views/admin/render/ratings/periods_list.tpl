<table>
	<thead>
		<tr>
			<td>Название</td>
			<td>Периоды</td>
			<td class="nowidth" title="Активировать период">Актив.</td>
			<td class="nowidth" title="Точка отсчета для расчета рейтинга периода">Отсч..</td>
			<td class="nowidth" title="Уведомить">Увед.</td>
			<td class="nowidth">Отчет</td>
		</tr>
	</thead>
	<tbody>
		{% if ratings_periods %}
			{% for period in ratings_periods %}
				<tr>
					<td>{{period.title}}</td>
					<td>
						{% if period.reports_periods %}
							<ul>
								{% for p in period.reports_periods %}
									<li>{{p}}</li>
								{% endfor %}
							</ul>
						{% else %}
							<p class="empty">Нет данных</p>
						{% endif %}
					</td>
					<td class="center">
						<div class="checkblock" title="Активировать период">
							<input id="activeperiod{{period.id}}" setactiveperiod="{{period.id}}"{% if period.active %} checked{% endif %} name="setactiveperiod" type="radio">
							<label for="activeperiod{{period.id}}"></label>
						</div>
					</td>
					<td class="center">
						<div class="checkblock" title="Задать точку отсчета для расчета рейтинга">
							<input id="referencepoint{{period.id}}" setreferencepoint="{{period.id}}"{% if period.referencepoint %} checked{% endif %} name="setreferencepoint" type="radio">
							<label for="referencepoint{{period.id}}"></label>
						</div>
					</td>
					<td>
						<div class="buttons">
							<button notifyfromperiod="{{period.id}}" title="Уведомить рейд лидеров"><i class="fa fa-bullhorn"></i></button>
						</div>
					</td>
					<td>
						<div class="buttons">
							<button setreportfromperiod="{{period.id}}" title="Сформировать отчет" periodtitle="{{period.title}}"><i class="fa fa-bar-chart"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		{% else %}
			<tr>
				<td colspan="6"><p class="empty center red">Нет данных</p></td>
			</tr>
		{% endif %}
	</tbody>
</table>		