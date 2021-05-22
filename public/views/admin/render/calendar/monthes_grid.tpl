{% if calendar %}
	<ul class="tabstitles sub">
		{% for year, monthes in calendar %}
			<li id="tabCalendar{{year}}"><strong>{{year}} г.</strong></li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent">
		{% for year, monthes in calendar %}
			<div tabid="tabCalendar{{year}}">
				<div class="calendar">
					{% for month in monthes %}
						<div class="calendar__item">
							<p class="calendar__title"><span>{{month.month}} {{year}} <small>г.</small></span></p>
							
							<div class="calendar__content">
								<div class="calendar__column">
									<div class="calendar__subtitle"><span>Сохраненные отчеты</span></div>
									<ul calendarreportslist>
										{% if reports[1][month.timepoint] %}
											{% for report in reports[1][month.timepoint] %}
												<li>
													<span>{{report.title}}</span>
													<i calendarremovereport="1|{{month.timepoint}}|{{report.report_id}}" class="fa fa-trash" title="Удалить отчет"></i>
												</li>
											{% endfor %}
										{% endif %}
									</ul>
									<div class="calendar__bottom">
										<button class="calendar__botton" calendaraddreport="1|{{month.timepoint}}">Добавить отчет</button>
									</div>
								</div>
								<div class="calendar__column">
									<div class="calendar__subtitle"><span>Премиальные отчеты</span></div>
									<ul calendarreportslist>
										{% if reports[2][month.timepoint] %}
											{% for report in reports[2][month.timepoint] %}
												<li>
													<span>{{report.title}}</span>
													<i calendarremovereport="2|{{month.timepoint}}|{{report.report_id}}" class="fa fa-trash" title="Удалить отчет"></i>
												</li>
											{% endfor %}
										{% endif %}
									</ul>
									<div class="calendar__bottom">
										<button class="calendar__botton" calendaraddreport="2|{{month.timepoint}}">Добавить отчет</button>
									</div>
								</div>
							</div>
						</div>
					{% endfor %}
				</div>
			</div>
		{% endfor %}
	</div>
{% endif %}