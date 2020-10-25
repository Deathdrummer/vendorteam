<div class="timesheets">
	{% for staticId, static in statics %}
		{% if access_statics and staticId in access_statics %}
			<div class="timesheets__item timesheet">
				<div class="timesheet__title">
					<div class="icon"><img src="{{base_url()}}public/filemanager/{{static.icon}}" alt=""></div>
					<p>{{static.name}}</p>
				</div>
				
				<div class="timesheet__content">
					<table>
						<thead>
							<tr>
								{% for day in 1..7 %}
									<td>День {{day}}</td>
								{% endfor %}
							</tr>
						</thead>
						<tbody>
							<tr>
								{% for day in 1..7 %}
									<td>
										{% for data in timesheet[staticId][day] %}
											<div class="row timesheet__raid justify-content-between no-gutters" style="background-color: {{data.color|default('#eff1f3')}}" tdata="{{day}}|{{data.tid}}">
												<div class="col">
													<ul>
														<li>
															<strong>Тип рейда:</strong>
															<span>{{data.raid_name}}</span>
														</li>
														<li>
															<strong>Время начала:</strong>
															<span>{{data.time_start_h|add_zero}}:{{data.time_start_m|add_zero}}</span>
														</li>
														<li>
															<strong>{% if data.raid_end_name %}{{data.raid_end_name}}{% else %}Завершение:{% endif %}</strong>
															<span>{{getHoursMinutes(data.time_start_h, data.time_start_m, (data.duration - 30), ':')}}</span>
														</li>
													</ul>
												</div>
												<div class="col-auto">
													<div class="buttonsblock">
														<button edittimesheetitem="{{data.tid}}|{{data.raid_id}}|{{data.time_start_h}}|{{data.time_start_m}}|{{data.duration}}" title="Редактировать"><i class="fa fa-edit"></i></button>
														<button class="remove" removetimesheetitem="{{data.tid}}" title="Удалить"><i class="fa fa-trash"></i></button>
													</div>
												</div>
											</div>
										{% endfor %}
									</td>
								{% endfor %}
							</tr>
						</tbody>
						
						<tfoot>
							<tr>
								{% for day in 1..7 %}
									<td>
										<div class="buttons">
											<button addtimesheetitem="{{staticId}}|{{day}}">Добавить рейд</button>
										</div>
									</td>
								{% endfor %}
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		{% endif %}
	{% endfor %}
</div>