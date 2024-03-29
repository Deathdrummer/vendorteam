{% if report %} {# Данные для админа #}
	<ul class="tabstitles sub mt-2">
		{% for staticId, static in report %}
			<li id="tabstatic{{staticId}}">{{static.static_name}}</li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent">
		{% for staticId, static in report %}
			<div tabid="tabstatic{{staticId}}">
				<h2>{{static.static_name}}</h2>
				
				<div class="report">
					<div>
						<table class="main_report_names report__table_left">
							<thead>
								<tr>
									<td class="w36px">№</td>
									<td class="nowrap">Состав</td>
								</tr>
							</thead>
							<tbody>
								{% set index = 1 %}
								{% for userId, userData in static.users %}
									<tr>
										<td class="center"><strong>{{index}}</strong></td>
										<td>
											<p class="fz14px"><strong>{{userData.nickname}}</strong></p>
											<small class="fz12px nowrap">{{userData.rank_name}}</small>
										</td>
									</tr>
									{% set index = index + 1 %}
								{% endfor %}
								<tr>
									<td colspan="4" class="right">Сумма коэффициентов:</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="scroll">
						<table class="report__table_center">
							<thead>
								<tr>
									{% for raidId, raid in raids[staticId]['raids'] %}
										<td class="nowidth">
											<p class="nowrap">Ключ № {{raidId}}</p>	
											<p class="nowrap">{{raid.raid_type}}</p>
											<p class="nowrap">{{raid.date|d(true)}}</p>
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in static.users %}
									<tr>
										{% for raidId, raid in raids[staticId]['raids'] %}
											<td>{{userData['raids'][raidId]['rate']|default('-')}}</td>
										{% endfor %}
										<td class="p0"></td>
									</tr>
								{% endfor %}
								<tr>
									{% for raidId, raid in raids[staticId]['raids'] %}
										<td><strong>{{raid.koeff_summ}}</strong></td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div>
						<table class="report__table_right">
							<thead>
								<tr>
									<td colspan="2">сумма коэффициентов</td>
									<td>Выплата</td>
									{#{% if pattern_id and not to_user %}<td class="center"><i title="Статус выплаты" paydonekeyall class="fa fa-check-square"></i></td>{% endif %}#}
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in static.users %}
									<tr>
										<td colspan="2" class="nowidth">{{userData.koeff_summ}}</td>
										<td><strong class="nowrap">{{currency(userData.payment)}}</strong></td>
										{#{% if pattern_id and not to_user %}
											<td class="square_block">
												{% if userData.payment != 0 %}
													{% if userData.pay_done %}
														<div paydonekey="0" data="{{pattern_id}}|{{staticId}}|{{userId}}|{{userData.payment}}" class="success" title="рассчитан"><i class="fa fa-square-o"></i></div>
													{% else %}
														<div paydonekey="1" data="{{pattern_id}}|{{staticId}}|{{userId}}|{{userData.payment}}" class="forbidden" title="Не рассчитан"><i class="fa fa-check-square-o"></i></div>
													{% endif %}
												{% else %}
													<div class="forbidden disabled" title="Недоступен"><i class="fa fa-check-square-o"></i></div>
												{% endif %}
											</td>
										{% endif %}#}
									</tr>
								{% endfor %}
								<tr>
									<td class="right">Сумм. коэф. периода:</td>
									<td><strong>{{static.period_koeff_summ|round(3)}}</strong></td>
									<td class="right"><span class="nowrap right">Бюджет:</span> <strong class="nowrap">{{currency(static.cash)}}</strong></td>
									{#{% if pattern_id and not to_user %}<td></td>{% endif %}#}
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		{% endfor %}
	</div>	
{% endif %}