{% if report %}

	<ul class="tabstitles small">
		{% for staticId, static in report %}
			<li id="tabstatic{{staticId}}">{{static.static_name}}</li>
		{% endfor %}
	</ul>
	
	
	<div class="tabscontent">
		{% for staticId, static in report %}
			<div tabid="tabstatic{{staticId}}">
				<h2>{{static.static_name}}</h2>
				
				<div class="report">
					<table class="main_report_names">
						<thead>
							<tr>
								<td class="nowrap w50">Состав</td>
								<td class="nowrap w50">Звание</td>
							</tr>
						</thead>
						<tbody>
							{% for userId, userData in static.users %}
								<tr>
									<td>{{userData.nickname}}</td>
									<td>{{userData.rank_name}}</td>
								</tr>
							{% endfor %}
							<tr>
								<td>
									<button class="addraid" operatornewkey="{{staticId}}" report="{% if pattern_id %}1{% else %}0{% endif %}"{% if not add_raid_access[staticId] %} disabled{% endif %}>
										<i class="fa fa-plus"></i>
										<span>Ключ</span>
									</button>
								</td>
								<td colspan="2" class="right">Сумма коэффициентов:</td>
							</tr>
						</tbody>
					</table>
					
					
					
					
					<div class="scroll">
						<table>
							<thead>
								<tr>
									{% for raidId, raid in raids[staticId]['raids'] %}
										<td>
											<div class="raiditem">
												<div class="d-flex justify-content-between align-items-center mb-1 w100px">
													<p class="nowrap raiditem__title">Ключ № {{raidId}}</p>	
													<button class="raiditem__remove" deletekey="{{raidId}}" title="Удалить ключ"{% if not add_raid_access[staticId] %} disabled{% endif %}><i class="fa fa-trash"></i></button>
												</div>
												
												{% if pattern_id %}
													<span class="raiditem__type">{{raid.raid_type}}</span>
												{% else %}
													<select class="raiditem__select" editkeytype="{{raidId}}">
														{% if keys_types %}
															{% for id, name in keys_types %}
																<option value="{{id}}"{% if raid.raid_type == name %} selected{% endif %}>{{name}}</option>
															{% endfor %}
														{% endif %}
													</select>
												{% endif %}
												
												<p class="nowrap raiditem__date">{{raid.date|d(true)}}</p>
											</div>
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in static.users %}
									<tr>
										{% for raidId, raid in raids[staticId]['raids'] %}
											<td class="center">
												{% if pattern_id %}
													{{userData['raids'][raidId]['rate']|default('-')}}
												{% else %}
													<input type="number" step="0.1" min="0" showrows editkeykoeff="{{userData['raids'][raidId]['id']}}|{{userId}}|{{raidId}}" class="w45px" value="{{userData['raids'][raidId]['rate']|default(0)}}">
												{% endif %}
											</td>
										{% endfor %}
										<td class="p0"></td>
									</tr>
								{% endfor %}
								<tr>
									{% for raidId, raid in raids[staticId]['raids'] %}
										<td class="center"><strong>{{raid.koeff_summ}}</strong></td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</tbody>
						</table>
					</div>
					
					
					<table>
						<thead>
							<tr>
								<td colspan="2">Сумма коэффициентов:</td>
								<td>Выплата</td>
								{% if pattern_id and not to_user and 7 in access %}<td class="center"><i title="Статус выплаты" class="fa fa-check-square"></i></td>{% endif %}
							</tr>
						</thead>
						<tbody>
							{% for userId, userData in static.users %}
								<tr>
									<td colspan="2" class="nowidth center">{{userData.koeff_summ}}</td>

									<td class="nowidth"><span class="nowrap">{{userData.payment|number_format(2, '.', ' ')}} ₽</span></td>
									{% if pattern_id and not to_user and 7 in access %}
										<td class="square_block">
											{% if userData.payment != 0 %}
												{% if userData.pay_done == 0 %}
													<div paydonekey="1" data="{{pattern_id}}|{{staticId}}|{{userId}}|{{userData.payment}}" class="forbidden" title="Не рассчитан"><i class="fa fa-check-square-o"></i></div>
												{% else %}
													<div paydonekey="0" data="{{pattern_id}}|{{staticId}}|{{userId}}|{{userData.payment}}" class="success" title="рассчитан"><i class="fa fa-square-o"></i></div>
												{% endif %}
											{% else %}
												<div class="forbidden disabled" title="Недоступен"><i class="fa fa-check-square-o"></i></div>
											{% endif %}
												
										</td>
									{% endif %}
								</tr>
							{% endfor %}
							<tr>
								<td class="right">Сумма коэффициентов периода:</td>
								<td><strong>{{static.period_koeff_summ|round(3)}}</strong></td>
								<td class="right"><span class="nowrap right">Бюджет:</span> <strong class="nowrap">{{static.cash|number_format(2, '.', ' ')}} ₽</strong></td>
								{% if pattern_id and not to_user and 7 in access %}<td></td>{% endif %}
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		{% endfor %}
	</div>



		
{% endif %}