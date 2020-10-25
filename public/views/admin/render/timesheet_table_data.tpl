{% if timesheet %}
	<div class="popup__title">
		<div class="image"><img src="{{base_url('public/filemanager/')}}{{static_icon}}" alt=""></div>
		
		<h6>{{static_name}}</h6>
	</div>

	<div class="popup__data">
		{% if not to_user or to_user == 0 %}
			<div class="timesheet timesheet__operator">
				{% for staticId, static in statics %}
					{% if access_statics is not defined or staticId in access_statics|keys %}
						<h3>{{static.name}}</h3>
						
						<div class="timesheet__item">
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
													<div class="timesheet__item_raid" style="background-color: {{data.color|default('#eff1f3')}}" tdata="{{day}}|{{data.tid}}">
														<div>
															<ul>
																<li>
																	<span>Тип рейда:</span>
																	<strong>{{data.raid_name}}</strong>
																</li>
																<li>
																	<span>Время начала:</span>
																	<strong>{{data.time_start_h|add_zero}}:{{data.time_start_m|add_zero}}</strong>
																</li>
																<li>
																	<span>Длительность:</span>
																	<strong>{{(data.duration / 60)|floor|add_zero}}:{{(data.duration % 60)|add_zero}}</strong>
																</li>
															</ul>
														</div>
														<div>
															<div class="bittons">
																<button edittimesheetitem="{{data.tid}}|{{data.raid_id}}|{{data.time_start_h}}|{{data.time_start_m}}|{{data.duration}}"><i class="fa fa-edit"></i></button>
																<button removetimesheetitem="{{data.tid}}" class="ml-0"><i class="fa fa-trash"></i></button>
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
					{% endif %}
				{% endfor %}
			</div>
		{% elseif to_user == 1 and timesheet %}
			<div class="timesheet">
				<div class="drow dgutter-24">
					{% for day in 0..6 %}
						<div class="dcol-7">
							<div class="popup__grid popup__grid_title">
								<p>{{dates[day]|d}}</p>
								
								{% if location == 3 %}
									<small>{{dates[day]|week}}-{{dates[day+1]|week}} | день {{day + 1}}</small>
								{% else %}
									<small>{{dates[day]|week}} | день {{day + 1}}</small>
								{% endif %}
							</div>
						</div>
					{% endfor %}
					
				</div>
				
				<div class="drow dgutter-24">
					{% for day in 1..7 %}
						<div class="dcol-7">
							{% for data in timesheet[statics.id][day] %}
								<div class="popup__grid popup__grid_content" style="background-color: {{data.color|default('#eff1f3')}}">
									<p class="center">{{data.raid_name}}</p>
									
									<ul>
										<li>
											<span>Начало:</span>
											<strong>{{data.time_start_h|add_zero}}:{{data.time_start_m|add_zero}}</strong>
										</li>
										
										{% if data.raid_end_name %}
											<li class="mt-2">
												<span>{{data.raid_end_name}}</span>
												<strong>{{getHoursMinutes(data.time_start_h, data.time_start_m, (data.duration - 30), ':')}}</strong>
											</li>
										{% endif %}	
									</ul>
								</div>
							{% endfor %}
						</div>
					{% endfor %}
				</div>
			</div>
		{% endif %}
	</div>
{% endif %}