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
					<div>
						<table class="payment_patterns_report">
							<thead>
								<tr>
									<td class="w150px">Никнейм</td>
									<td class="w100px">Резерв</td>
								</tr>
							</thead>
							<tbody>
								{% for userId, userData in users %}
									<tr>
										<td>{{userData.nickname}}</td>
										<td class="nowrap">{{currency(userData.deposit)}}</td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
					
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
											<td class="w150 nowrap">{{currency(patternSumm)}}</td>
										{% endfor %}
										<td class="p0"></td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
					
					<div>
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
										<td class="nowrap w15">{{currency(userData.full)}}</td>
										<td class="nowrap w15">{{currency(userData.payout)}}</td>
										<td class="nowrap w15">{{currency(userData.profit)}}</td>
										<td class="nowrap w15">{{currency(userData.debit)}}</td>
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
			</div>
			{% set itercontent = itercontent + 1 %}
		{% endfor %}
	</div>
{% endif %}