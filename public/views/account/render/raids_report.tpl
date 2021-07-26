{% if report %}
	{% for staticId, static in report %}
		<h2>{{static.static_name}}</h2>
		
		<div class="report">
			<div>
				<table class="main_report_names">
					<thead>
						<tr>
							<td class="nowrap w50">Состав</td>
							<td class="nowrap w50">Звание</td>
							<td>Резерв</td>
						</tr>
					</thead>
					<tbody>
						{% for userId, userData in static.users %}
							<tr>
								<td>{{userData.nickname}}</td>
								<td>{{userData.rank_name}}</td>
								<td><span class="nowrap">{{userData.deposit|number_format(2, '.', ' ')}} ₽</span></td>
							</tr>
						{% endfor %}
						<tr>
							<td>
								<button operatornewraid="{{staticId}}"><i class="fa fa-plus"></i></button>
							</td>
							<td colspan="2" class="right">Сумма коэффициентов:</td>
						</tr>
					</tbody>
				</table>	
			</div>
			
			<div class="scroll">
				<table>
					<thead>
						<tr>
							{% for raidId, raid in raids[staticId]['raids'] %}
								<td class="nowidth">
									<p class="nowrap">Рейд № {{raidId}}</p>	
									<button deleteraid="{{raidId}}"><i class="fa fa-trash"></i></button>
									
									{% if pattern_id %}
										{{raid.raid_type}}
									{% else %}
										<select editraidtype="{{raidId}}">
											{% if raids_types %}
												{% for id, name in raids_types %}
													<option value="{{id}}"{% if raid.raid_type == name %} selected{% endif %}>{{name}}</option>
												{% endfor %}
											{% endif %}
										</select>
									{% endif %}
									
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
									<td>
										{% if pattern_id %}
											{{userData['raids'][raidId]|default('-')}}
										{% else %}
											<input type="number" step="0.1" min="0" showrows editraidkoeff="{{userId}}|{{raidId}}" class="w34" value="{{userData['raids'][raidId]|default('-')}}">
										{% endif %}
									</td>
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
				<table>
					<thead>
						<tr>
							<td>сумм коэф.</td>
							<td>Персон.</td>
							<td>Эффект.</td>
							<td>Ошибки</td>
							<td>Коэфф. периода</td>
							<td>Выплата</td>
							<td class="nowrap">В Резерв</td>
							<td>Итого</td>
							{% if pattern_id and not to_user and 7 in access %}<td class="center"><i title="Статус выплаты" class="fa fa-check-square"></i></td>{% endif %}
						</tr>
					</thead>
					<tbody>
						{% for userId, userData in static.users %}
							<tr>
								<td class="nowidth">{{userData.koeff_summ}}</td>
								<td class="nowidth">{{userData.persones_count}}</td>
								<td class="nowidth">{{userData.effectiveness}}</td>
								<td class="nowidth">{{userData.fine}}</td>
								<td class="nowidth">{{userData.period_koeff|round(3)}}</td>
								<td class="nowidth"><span class="nowrap">{{userData.payment|number_format(2, '.', ' ')}} ₽</span></td>
								<td><span class="nowrap">{{userData.to_deposit|number_format(2, '.', ' ')}} ₽</span></td>
								<td><strong class="nowrap">{{userData.final_payment|number_format(2, '.', ' ')}} ₽</strong></td>
								{% if pattern_id and not to_user and 7 in access %}
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
								{% endif %}
							</tr>
						{% endfor %}
						<tr>
							<td colspan="4" class="right">Сумма коэффициентов периода:</td>
							<td><strong>{{static.period_koeff_summ|round(3)}}</strong></td>
							<td colspan="3" class="right"><span class="nowrap right">Бюджет:</span> <strong class="nowrap">{{static.cash|number_format(2, '.', ' ')}} р.</strong></td>
							{% if pattern_id and not to_user and 7 in access %}<td></td>{% endif %}
						</tr>
					</tbody>
				</table>	
			</div>
		</div>
	{% endfor %}
{% endif %}