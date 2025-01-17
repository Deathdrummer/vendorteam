{% if report %} {# Данные для ЛК #}
	<div class="popup__data">
		<div class="reports">
			{% for staticId, static in report %}
				{% set lider = statics[staticId]['lider'] %}
				<div class="popup__title">
					<h6>{{static.static_name}}{% if lider %} <sup>Лидер</sup>{% endif %}</h6>
				</div>
				
				<div class="report">
					<div>
						<table class="popup__table report__table_left w320px">
							<thead>
								<tr>
									<td class="nowrap"><strong>Состав</strong></td>
									<td class="nowrap w100px"><strong>Звание</strong></td>
									<td><strong>Резерв</strong></td>
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in static.users %}
									<tr{% if userData.color %} style="background-color: {{userData.color}}"{% endif %}>
										<td>{% if userId == to_user or lider %}{{userData.nickname}}{% else %}#{% endif %}</td>
										<td><span class="fz12px">{% if userId == to_user or lider %}{{userData.rank_name}}{% else %}#{% endif %}</span></td>
										<td><span class="nowrap">{% if userId == to_user or lider %}{{currency(userData.deposit)}}{% else %}<strong>#</strong>{% endif %}</span></td>
									</tr>
								{% endfor %}
								<tr>
									<td colspan="3" class="right h3rem">Сумма коэффициентов:</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="scroll">
						<table class="popup__table report__table_center">
							<thead>
								<tr>
									{% for raidId, raid in raids[staticId]['raids'] %}
										<td class="nowidth">
											<small class="nowrap">Рейд № {{raidId}}</small>	
											<small class="nowrap">{{raid.raid_type}}</small>
											<small class="nowrap">{{raid.date|d(true)}}</small>
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in static.users %}
									<tr{% if userData.color %} style="background-color: {{userData.color}}"{% endif %}>
										{% for raidId, raid in raids[staticId]['raids'] %}
											<td class="center">{% if userId == to_user or lider %}<p>{{userData['raids'][raidId]['rate']|default('-')}}</p>{% else %}<p>#</p>{% endif %}</td>
										{% endfor %}
										<td class="p0"></td>
									</tr>
								{% endfor %}
								<tr>
									{% for raidId, raid in raids[staticId]['raids'] %}
										<td class="center h3rem"><strong>{% if userId == to_user or lider %}{{raid.koeff_summ}}{% else %}#{% endif %}</strong></td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</tbody>
						</table>
					</div>
					
					
					<div>
						<table class="popup__table report__table_right">
							<thead>
								<tr>
									<td><strong>сумм коэф.</strong></td>
									<td><strong>Персон.</strong></td>
									<td><strong>Эффект</strong>.</td>
									<td><strong>Ошибки</strong></td>
									<td><strong>Коэфф. периода</strong></td>
									<td><strong>Выплата</strong></td>
									{# <td><strong class="nowrap">В Резерв</strong></td>
									<td><strong>Итого</strong></td> 
									{% if pattern_id and not to_user %}<td class="center"><i title="Статус выплаты" class="fa fa-check-square"></i></td>{% endif %} #}
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in static.users %}
									<tr{% if userData.color %} style="background-color: {{userData.color}}"{% endif %}>
										<td class="nowidth center"><p>{{userData.koeff_summ}}</p></td>
										<td class="nowidth center"><p>{{userData.persones_count}}</p></td>
										<td class="nowidth center"><p>{{userData.effectiveness}}</p></td>
										<td class="nowidth center"><p>{{userData.fine}}</p></td>
										<td class="nowidth center">{% if userId == to_user or lider %}<p>{{userData.period_koeff|round(3)}}</p>{% else %}<p>#</p>{% endif %}</td>
										<td class="nowidth center">{% if userId == to_user or lider %}<p class="nowrap">{{currency(userData.payment)}}</p>{% else %}<p>#</p>{% endif %}</td>
										{# <td class="center">{% if userId == to_user or lider %}<p class="nowrap">{{currency(userData.to_deposit)}}</p>{% else %}<p>#</p>{% endif %}</td>
										<td class="center">{% if userId == to_user or lider %}<p class="nowrap">{{currency(userData.final_payment)}}</p>{% else %}<p>#</p>{% endif %}</td>
										{% if pattern_id and not to_user %}
											<td class="square_block">
												{% if userData.final_payment != 0 %}
													{% if userData.pay_done == 0 %}
														<div paydone="1" data="{{pattern_id}}|{{staticId}}|{{userId}}|{{userData.to_deposit}}" class="forbidden" title="Не рассчитан"><i class="fa fa-check-square-o"></i></div>
													{% else %}
														<div paydone="0" data="{{pattern_id}}|{{staticId}}|{{userId}}|{{userData.to_deposit}}" class="success" title="рассчитан"><i class="fa fa-square-o"></i></div>
													{% endif %}
												{% else %}
													<div class="forbidden disabled" title="Недоступен"><i class="fa fa-check-square-o"></i></div>
												{% endif %}
													
											</td>
										{% endif %} #}
									</tr>
								{% endfor %}
								<tr>
									<td colspan="3" class="right h3rem">
										Сумм. коэфф. периода:
										<strong>{% if userId == to_user or lider %}<p>{{static.period_koeff_summ|round(3)}}</p>{% else %}<p>#</p>{% endif %}</strong>
									</td>
									<td colspan="3" class="right h3rem w10rem">
										<p><span class="nowrap right">Бюджет:</span> <strong class="nowrap">{% if userId == to_user or lider %}{{currency(static.cash)}}{% else %}#{% endif %}</strong></p>
										<p><span class="nowrap right">Итоговый:</span> <strong class="nowrap">{% if userId == to_user or lider %}{{currency(static.final_cash)}}{% else %}#{% endif %}</strong></p>
									</td>
									{# {% if pattern_id and not to_user %}<td></td>{% endif %} #}
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			{% endfor %}
		</div>
	</div>
{% endif %}