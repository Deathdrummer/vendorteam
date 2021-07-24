<ul class="tabstitles mt-2">
	{% for stId, stName in statics %}
		<li id="tabKpiProgressStatic{{stId}}">{{stName}}</li>
	{% endfor %}
</ul>

<div class="tabscontent">
	{% for staticId, stName in statics %}
		<div tabid="tabKpiProgressStatic{{staticId}}">
			<div class="kpiprocessblock drow dgutter-15">
				{% for userId, user in formdata[staticId] %}
					<div class="dcol-1 dcol-sm-2 dcol-md-3 dcol-lg-4 dcol-xl-5">
						<div class="kpiprocesscard">
							<div class="kpiprocesscard__user">
								<img class="avatar w70px h70px mr15px" src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/deleted_mini.jpg')}}" alt="{{user.nickname}}">
								<div>
									<strong>{{user.nickname}}</strong>
									<p class="fz11px mt3px">{{ranks[user.rank]['name']}}</p>
								</div>
							</div>
							
							
							{% if user.visits or user.fine %}
								<div class="kpiprocesscard__bars">
									{% if user.visits.need %}
										<div class="process">
											<p class="process__label">Посещаемость:</p>
											<div class="progressbar">
												<progress class="progressbar__progress" value="{{user.visits.fact|default(0)}}" max="{{user.visits.need|default(0)}}"></progress>
												<div class="progressbar__value">
													<strong>{{user.visits.fact|default(0)}}</strong> <small>из</small> <strong>{{user.visits.need|default(0)}}</strong>
												</div>
												<div class="progressbar__stat">
													{% if user.visits.fact >= user.visits.need %}
														<i class="fa fa-check progressbar__stat_done"></i>
													{% else %}
														<i class="fa fa-close progressbar__stat_fail"></i>
													{% endif %}
												</div>
											</div>
										</div>
									{% endif %}
									
									{% if user.fine.need %}
										<div class="process">
											<p class="process__label">Штрафы:</p>
											<div class="progressbar">
												<progress class="progressbar__progress progressbar__progress_red" value="{{user.fine.fact|default(0)}}" max="{{user.fine.need|default(0)}}"></progress>
												<div class="progressbar__value">
													<strong>{{user.fine.fact|default(0)}}</strong> <small>из</small> <strong>{{user.fine.need|default(0)}}</strong>
												</div>
												<div class="progressbar__stat">
													{% if user.fine.need == 0 %}
														<i class="fa fa-ban progressbar__stat_empty"></i>
													{% elseif user.fine.fact < user.fine.need %}
														<i class="fa fa-check progressbar__stat_done"></i>
													{% else %}
														<i class="fa fa-close progressbar__stat_fail"></i>
													{% endif %}
												</div>
											</div>
										</div>
									{% endif %}
								</div>
							{% endif %}
								
							
							{% if user.custom_fields %}
								<div class="kpiprocesscard__fields customtasks">
									{% for field, cFData in custom_fields %}
										{% if cFData['type'] == 'koeff' %}
											<div class="customtasks__item{% if user['custom_fields'][field]['fact'] == user['custom_fields'][field]['need'] %} customtasks__item_done{% elseif user['custom_fields'][field]['fact'] > user['custom_fields'][field]['need'] %} customtasks__item_verydone{% endif %}" ctasksitem>
												<small class="fz12px mr10px">{{cFData['task']}}</small>
												
												<strong class="customtasks__need ml-auto" customtasksneed="{{user['custom_fields'][field]['need']}}">{{user['custom_fields'][field]['need']}}</strong>
												
												<div class="counterblock counterblock_vertical ml5px">
													<div class="counterblock__value"><span customprogressdata="{{userId}}|{{field}}">{{user['custom_fields'][field]['fact']|default(0)}}</span></div>
													<div class="counterblock__rows">
														<button class="counterblock__rows_plus" customprogresschangebutton="+"></button>
														<button class="counterblock__rows_minus" customprogresschangebutton="-"></button>
													</div>
												</div>
											</div>
										{% elseif cFData['type'] == 'bool' %}
											<div class="customtasks__item{% if user['custom_fields'][field]['fact'] == 1 %} customtasks__item_done{% endif %}" ctasksitem>
												<small class="fz12px mr10px">{{cFData['task']}}</small>
												<div class="customtasks__checkblock mr15px">
													<input type="checkbox" id="customProgressCheck{{userId}}{{field}}" customprogresschangecheck="{{userId}}|{{field}}"{% if user['custom_fields'][field]['fact'] %} checked{% endif %}>
													<label for="customProgressCheck{{userId}}{{field}}"></label>
												</div>
											</div>
										{% endif %}
									{% endfor %}
								</div>
							{% endif %}
								
							
							<div class="kpiprocesscard__tasks">
								{% if user.tasks %}
									<p class="kpiprocesscard__label">Активность на персонажах</p>
									{% for personageId, tasks in user.tasks %}
										<div class="personagetasks">
											<div class="personagetasks__personage">
												<strong>{{personages[userId][personageId]['game_id_name']}}</strong>
												<span>{{personages[userId][personageId]['nick']}}</span>
												<span>{{personages[userId][personageId]['server']}}</span>
												<span>{{personages[userId][personageId]['armor']}}</span>
											</div>
											
											<ul class="personagetasks__list">
												{% for taskId, task in tasks %}
													<li class="personagetasks__item{% if progress[userId][personageId][taskId] == task.repeats %} personagetasks__item_done{% elseif progress[userId][personageId][taskId] > task.repeats %} personagetasks__item_verydone{% endif %}" ptasksitem>
														<small class="personagetasks__task">{{task.task}}</small>
														<div class="personagetasks__need" personagetasksneed="{{task.repeats}}">{{task.repeats}}</div>
														<div class="personagetasks__repeats">
															<div class="counterblock">
																<div class="counterblock__value"><span tasksprogressdata="{{userId}}|{{personageId}}|{{taskId}}">{{progress[userId][personageId][taskId]|default(0)}}</span></div>
																<div class="counterblock__rows">
																	<button class="counterblock__rows_minus" tasksprogresschangebutton="-"></button>
																	<button class="counterblock__rows_plus" tasksprogresschangebutton="+"></button>
																</div>
															</div>
														</div>
													</li>
												{% endfor %}
											</ul>
										</div>	
									{% endfor %}
								{% else %}
									
								{% endif %}
								{#user personage task#}
							</div>
						</div>
					</div>
				{% endfor %}
			</div>
		</div>
	{% endfor %}
</div>