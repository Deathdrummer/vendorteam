{% if periods.total %}
	<h4>Выберите период</h4>
	<table id="kpiPeriodsList">
		<thead>
			<tr>
				<td class="w250px">Название</td>
				<td class="w170px">Даты</td>
				<td>Финансовый период</td>
				<td>Статики</td>
				<td class="w50px" title="Активный для заполнения KPI период">Ред.</td>
				<td class="w50px" title="Опубликован">Публ.</td>
				<td class="w50px"></td>
			</tr>
		</thead>
		{% if periods %}
			<tbody>
				{% for period in periods.items %}
					<tr>
						<td periodtitle>{{period.title}}</td>
						<td>
							<p>с {{period.date_start|d}}</p>
							<p>по {{period.date_start|d}}</p>
						</td>
						<td>
							{% if period.report_period %}
								<p>{{reports_periods[period.report_period]['name']}}</p>
							{% endif %}
						</td>
						<td>
							{% if period.statics %}
								<ul class="scroll_y scroll_y_thin h70px">
									{% for staticId in period.statics %}
										<li>{{statics[staticId]}}</li>
									{% endfor %}
								</ul>
							{% else %}
								<p class="empty">Нет статиков</p>
							{% endif %}
						</td>
						<td class="text-center">
							<div class="checkblock">
								<input id="kpiActivatePeriod{{period.id}}" activatekpiperiod="{{period.id}}" type="radio" name="activatekpiperiod"{% if period.active %} checked{% endif %}>
								<label for="kpiActivatePeriod{{period.id}}"></label>
							</div>
						</td>
						<td class="text-center">
							<div class="checkblock">
								<input id="kpiPublishPeriod{{period.id}}" publishkpiperiod="{{period.id}}" type="radio" name="publishkpiperiod"{% if period.published %} checked{% endif %}>
								<label for="kpiPublishPeriod{{period.id}}"></label>
							</div>
						</td>
						<td class="center">
							<div class="buttons inline nowrap">
								<button class="small w30px" kpiopenform="{{period.id}}" title="Выбрать"><i class="fa fa-check"></i></button>
								<button class="remove small w30px" kpiremoveperiod="{{period.id}}" title="Удалить период"><i class="fa fa-trash"></i></button>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		{% endif %}
	</table>
{% else %}
	<p class="empty center">Нет периодов</p>
{% endif %}	