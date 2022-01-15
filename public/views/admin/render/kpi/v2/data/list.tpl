{% if data %}
	<ul class="tabstitles sub">
		{% for static, rows in data %}
			<li id="kpiv2_data_static_list{{static}}" class="d-flex align-items-center">
				<img src="{{base_url('public/filemanager/thumbs/'~statics[static]['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="" class="avatar w20px h20px">
				<p class="fz11px ml3px">{{statics[static]['name']}}</p>
			</li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent">
		{% for static, rows in data %}
			<div tabid="kpiv2_data_static_list{{static}}">
				<ul class="kpiv2list" kpiv2list>
					{% for accoutId, list in rows %}
						<li class="kpiv2list__item">
							<h3 class="kpiv2list__title" kpiv2openlistbtn>{{accoutId}}</h3>
							<div class="kpiv2list__data">
								<table>
									<thead>
										<tr>
											<td class="w130px"><strong>Сервер 2</strong></td>
											<td class="w130px"><strong>Персонаж 2</strong></td>
											<td class="w170px"><strong>Бустер 2</strong></td>
											{% if fields %}
												{% for fId, field in fields %}
													<td class="w{{field.width}}px" title="{{field.title}}"><strong class="d-block text-overflow w{{field.width - 10}}px{% if field.center %} text-center{% endif %}">{{field.title}}</strong></td>
												{% endfor %}
											{% endif %}
											<td class="p0"></td>
										</tr>
									</thead>
									<tbody>
										{% for row in list %}
											<tr>
												<td class="fz13px">{{row['server']}}</td>
												<td class="fz13px">{{row['personage']}}</td>
												<td>
													<div class="row gutters-4 align-items-center justify-content-between">
														<div class="col">
															<span class="fz13px">{{row['booster']}}</span>
														</div>
														<div class="col-auto">
															<i class="fa fa-bars fz18px pointer lightblue lightblue_hovered" openboostershistorybtn="{{row['id']}}"></i>
														</div>
													</div>
												</td>
												{% if fields %}
													{% for fId, field in fields %}
														<td{% if field.center %} class="text-center"{% endif %}>
															{% if field.type == 1 %} {# строка #}
																{{row[fId]}}
																
															{% elseif field.type == 2 %} {# булево #}
																{% if row[fId] %}
																	<i class="fa fa-check fz16px green"></i>
																{% else %}
																	<i class="fa fa-ban fz16px red"></i>
																{% endif %}
																
															{% elseif field.type == 3 %} {#  #}
																<div class="progressbar progressbar_center">
																	<progress class="progressbar__progress h26px" value="{{row[fId]|default(0)}}" max="100"></progress>
																	<div class="progressbar__value">
																		<strong>{{row[fId]|default(0)}} %</strong>
																	</div>
																</div>
																
															{% else %}
																{{row[fId]}}
																
															{% endif %}
														</td>
													{% endfor %}
												{% endif %}
												<td class="p0"></td>
											</tr>
										{% endfor %}
									</tbody>
								</table>
							</div>
						</li>
					{% endfor %}
				</ul>
			</div>
		{% endfor %}
	</div>		
{% endif %}