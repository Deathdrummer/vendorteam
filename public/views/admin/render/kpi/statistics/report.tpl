{% if report %}
	<ul class="tabstitles mt-2">
		{% for staticId in report|keys %}
			<li id="tabKpiStat{{staticId}}">{{statics[staticId]}}</li>
		{% endfor %}
	</ul>
	
	
	<div class="tabscontent" id="kpiReport">
		<input type="hidden" name="periods" value="{{kpi_periods_ids|json_encode()}}">
		{% for staticId, users in report %}
		<div tabid="tabKpiStat{{staticId}}">
			<div class="kpireport noselect">
				<div class="kpireport__table_left">
					<table>
						<thead>
							<tr>
								<td class="w200px">Участник</td>
								<td class="w40px">NDA</td>
								<td class="w150px">Платежные реквизиты</td>
							</tr>
						</thead>
						<tbody>
							{% for uId, user in users %}
								<tr>
									<td class="h72px">
										<div class="d-flex align-items-center mt4px mb4px">
											<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}')"></div>
											<div class="ml4px">
												<strong>{{user.nickname}}</strong>
												<p class="fz11px mt3px">{{ranks[user.rank]['name']}}</p>
											</div>	
										</div>
									</td>
									<td class="center">{% if user.nda %}<i class="fa fa-check"></i> {% else %}<i class="fa fa-ban"></i>{% endif %}</td>
									<td><p class="fz12px">{{user.payment}}</p></td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
								
				<div class="scroll">
					<table>
						<thead>
							<tr>
								{% for period in kpi_periods %}
									<td>{{period.title}}</td>
								{% endfor %}
								<td class="p-0 w100"></td>
							</tr>
						</thead>
						<tbody>
							{% for uId, user in users %}
								<tr>
									{% for period in kpi_periods %}
										<td class="h72px">
											<div class="kpireportitem">
												<div class="kpireportitem__row">
													<span class="fz12px">Сумма</span>
													<strong class="fz12px">{{currency(report[staticId][uId]['periods'][period.id]['summ'])}}</strong>
													<input type="hidden" name="report[{{staticId}}][{{uId}}][planes][{{period.id}}][summ]" value="{{report[staticId][uId]['periods'][period.id]['summ']|default(0)}}">
												</div>
												<div class="kpireportitem__row">
													<span class="fz12px">Процент выплаты</span>
													<strong class="fz12px">{{report[staticId][uId]['periods'][period.id]['persent']|default(0)}} %</strong>
													<input type="hidden" name="report[{{staticId}}][{{uId}}][planes][{{period.id}}][persent]" value="{{report[staticId][uId]['periods'][period.id]['persent']|replace({'.': ','})|default(0)}}">
												</div>
												<div class="kpireportitem__row">
													<span class="fz12px">Сумма выплаты</span>
													<strong class="fz12px">{{currency(report[staticId][uId]['periods'][period.id]['payout'])}}</strong>
													<input type="hidden" name="report[{{staticId}}][{{uId}}][planes][{{period.id}}][payout]" value="{{report[staticId][uId]['periods'][period.id]['payout']|replace({'.': ','})|default(0)}}">
												</div>
											</div>
										</td>
									{% endfor %}
									<td class="p-0 w100"></td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
				
				<div class="kpireport__table_right">
					<table>
						<thead>
							<tr>
								<td>Итого к выплате</td>
							</tr>
						</thead>
						<tbody>
							{% for uId, user in users %}
								<tr>
									<td class="h72px w100px">
										{% if saved_report %}
											<p>{{currency(user.payout)}}</p>
										{% else %}
											<div class="d-flex align-items-center">
												<div class="field w125px">
													<input class="w125px" type="text" name="report[{{staticId}}][{{uId}}][payout]" payoutinput value="{{user.payout_all|replace({'.': ','})}}" rules="empty">
												</div>
												<strong class="fz12px ml5px">{{currency}}</strong>
											</div>
											<input type="hidden" name="report[{{staticId}}][{{uId}}][payment]" value="{{user.payment}}">
											<input type="hidden" name="report[{{staticId}}][{{uId}}][nda]" value="{{user.nda}}">
										{% endif %}
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
			</div>
		</div>
		{% endfor %}
	</div>
{% endif %}