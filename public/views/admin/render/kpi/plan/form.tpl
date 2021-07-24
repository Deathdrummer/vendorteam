{% if statics %}
	<ul class="tabstitles mt10px">
		{% for stId in formdata|keys %}
			<li id="tabKpiForm{{stId}}"><small>{{statics[stId]}}</small></li>
		{% endfor %}
	</ul>
	
	
	<div class="tabscontent">
		{% for stId in formdata|keys %}
			{% if formdata[stId] %}
				<div tabid="tabKpiForm{{stId}}">
					<table userspersonagesform>
						<thead>
							<tr class="h60px">
								<td class="w250px">Участник</td>
								{% if has_fields.visits %}<td class="w100px" title="Посещаемость"><p class="text-overflow w100px">Посещаемость</p></td>{% endif %}
								{% if has_fields.fine %}<td class="w100px" title="Штрафы"><p class="text-overflow w100px">Штрафы</p></td>{% endif %}
								{% if custom_fields %}
									{% for field in custom_fields %}
										{% if field.type != 'bool' %}
											<td class="w100px" title="{{field.title}}"><p class="fz11px">{{field.title}}</p></td>
										{% endif %}
									{% endfor %}
								{% endif %}
								{% if has_fields.personages %}<td>Активность на персонажах</td>{% endif %}
								<td class="p-0"></td>
							</tr>
						</thead>
						<tbody>
							{% for userId, user in formdata[stId] %}
								<tr kpiperiodsformrow="{{stId}}|{{userId}}">
									<td class="top w250px">
										<div class="d-flex align-items-center mt4px mb4px">
											<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}')"></div>
											<div class="ml4px">
												<strong>{{user.nickname}}</strong>
												<p class="fz11px mt3px">{{ranks[user.rank]['name']}}</p>
											</div>	
										</div>
									</td>
									{% if has_fields.visits %}
										<td class="top">
											<div class="popup__field kpiparamsfield mt4px">
												<input type="number" kpiformparam="visits|{{userId}}" showrows value="{{formdata[stId][userId]['params']['visits']}}">
											</div>
										</td>
									{% endif %}
									
									{% if has_fields.fine %}
										<td class="top">
											<div class="popup__field kpiparamsfield mt4px">
												<input type="number" kpiformparam="fine|{{userId}}" showrows value="{{formdata[stId][userId]['params']['fine']}}">
											</div>
										</td>
									{% endif %}
									
									{% if custom_fields %}
										{% for fName, field in custom_fields %}
											{% if field.type == 'koeff' %}
												<td class="top">
													<div class="popup__field kpiparamsfield mt4px">
														<input type="number" showrows value="{{formdata[stId][userId]['params']['custom_fields'][fName]}}" kpiformcustomparam="{{fName}}|{{userId}}">
													</div>
												</td>
											{% endif %}
										{% endfor %}
									{% endif %}
									
									{% if has_fields.personages %}
										<td{# kpipersonagestasks="{{stId}}|{{userId}}"#}>
											{#{% if formdata[stId][userId]['tasks'] %}#}
											
											{% if personages[userId] %}
												<div class="kpitasksblock noselect" personagestaskstable>
													<div class="kpitasks">
														{% for pId, personage in personages[userId] %}
															<div class="kpitasks__item kpitasksitem" kpitasksitem>
																<div class="kpitasksitem__top">
																	<div class="kpitasksitem__personage">
																		<strong class="fz12px">{{personage.game_id_name}}</strong>
																		<span class="fz12px">{{personage.nick}}</span>
																		<span class="fz12px">{{personage.server}}</span>
																		<span class="fz12px">{{personage.armor}}</span>
																	</div>
																	<div class="kpitasksitem__buttons">
																		<button class="edit" setpersonagetasks="{{personage.nick}}|{{userId}}|{{pId}}" title="Задачи"><i class="fa fa-edit"></i></button>
																	</div>
																</div>
																<ul class="kpitasksitem__list" kpitaskslist>
																	{% if formdata[stId][userId]['tasks'][pId] %}
																		{% for tId, task in formdata[stId][userId]['tasks'][pId] %}
																			<li>
																				<small>{{task.task}}</small>
																				<small><strong class="fz11px d-block w22px">Х{{task.repeats}}</strong></small>
																			</li>
																		{% endfor %}
																	{% else %}
																		<p class="kpitasksitem__empty">Нет задач</p>
																	{% endif %}
																</ul>
															</div>
														{% endfor %}
													</div>
												</div>	
											{% endif %}
										</td>
									{% endif %}
									<td class="p-0"></td>
								</tr>
							{% endfor %}
						</tbody>
					</table>	
				</div>
			{% endif %}
		{% endfor %}
	</div>
{% endif %}