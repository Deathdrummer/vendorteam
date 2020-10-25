{% if data %}
	<ul class="tabstitles sub mt-2">
		{% set itertitles = 0 %}
		{% for static, users in data %}
			<li id="tabpaybrago{{itertitles}}">{{static}}</li>
			{% set itertitles = itertitles + 1 %}
		{% endfor %}
	</ul>
	
	<div class="tabscontent">
		{% set itercontent = 0 %}
		{% for static, users in data %}
			<div tabid="tabpaybrago{{itercontent}}">
				<h2>{{static}}</h2>
				
				<div class="report">
					<table class="payment_patterns_report">
						<thead>
							<tr>
								<td>Никнейм</td>
								<td class="w34">Резерв</td>
							</tr>
						</thead>
						<tbody>
							{% for userId, userData in users %}
								<tr>
									<td>{{userData.nickname}}</td>
									<td>{{userData.deposit|number_format(2, '.', ' ')}} р.</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
					
					<div class="scroll">
						<table>
							<thead>
								<tr>
									{% for patternId, patternName in patterns %}
										<td class="w150"><small>{{patternName}}</small></td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in users %}
									<tr>
										{% for patternSumm in userData.patterns %}
											<td class="w150 nowrap">{{patternSumm|number_format(2, '.', ' ')}} р.</td>
										{% endfor %}
										<td class="p0"></td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
					
					<table class="w700">
						<thead>
							<tr>
								<td>Общая сумма</td>
								<td>Выплачено</td>
								<td>Зар. сумма</td>
								<td>Не выплачено</td>
								<td>Платежные реквизиты</td>
								<td class="center"><i title="Статус выплаты" class="fa fa-check-square"></i></td>
							</tr>
						</thead>
						<tbody>
							{% for userId, userData in users %}
								<tr>
									<td class="nowrap w15">{{userData.full|number_format(2, '.', ' ')}} р.</td>
									<td class="nowrap w15">{{userData.payout|number_format(2, '.', ' ')}} р.</td>
									<td class="nowrap w15">{{userData.profit|number_format(2, '.', ' ')}} р.</td>
									<td class="nowrap w15">{{userData.debit|number_format(2, '.', ' ')}} р.</td>
									<td>{{userData.pay_method}}</td>
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
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
			</div>
			{% set itercontent = itercontent + 1 %}
		{% endfor %}
	</div>
{% endif %}