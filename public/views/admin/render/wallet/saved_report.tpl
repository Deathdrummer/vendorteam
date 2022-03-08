{% if report %}
	<ul class="tabstitles sub mt-2">
		{% for stId, stName in statics %}
			<li id="tabWalletReportStatic{{stId}}">{{stName}}</li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent">
		{% for stId in statics|keys %}
			<div tabid="tabWalletReportStatic{{stId}}">
				<table>
					<thead>
						<tr>
							<td class="w250px">Участник</td>
							<td class="w150px">Баланс <p class="fz11px grayblue">(на момент сохранения)</p></td>
							<td class="w150px">Резерв <p class="fz11px grayblue">(на момент сохранения)</p></td>
							<td class="w200px">{% if paid %}Выплатилось{% else %}Выплатится{% endif %}</td>
							<td class="w200px">{% if paid %}Отправилось{% else %}Отправится{% endif %} в резерв</td>
							<td class="p0"></td>
						</tr>
					</thead>
					<tbody>
						{% for userId, user in report[stId]|sortusers %}
							<tr walletuserrow="{{stId}}|{{userId}}">
								<td>
									<div class="d-flex align-items-center">
										<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}')"></div>
										<p>{{user.nickname}}</p>
									</div>
								</td>
								<td>{{user.wallet|currency(true, 1)}}</td>
								<td>{{user.deposit|currency(true, 1)}}</td>
								<td>
									<div class="d-flex justify-content-between">
										<span walletreportpayout="{{user.summ}}">{{user.summ|currency(true, 1)}}</span>
										{% if paid %}
											<div><span class="fontcolor">{{(user.summ * report_currency)|number_format(1, ',', ' ')}}</span> <small>₽</small></div>
										{% else %}
											<div><span class="fontcolor" walletreportpayoutconverted>0.00</span> <small>₽</small></div>
										{% endif %}
									</div>
								</td>
								<td>
									<div class="d-flex justify-content-between">
										<span walletreporttodeposit="{{user.to_deposit}}">{{user.to_deposit|currency(true, 1)}}</span>
										{% if paid %}
											<div><span class="fontcolor">{{(user.to_deposit * report_currency)|number_format(1, ',', ' ')}}</span> <small>₽</small></div>
										{% else %}
											<div><span class="fontcolor" walletreporttodepositconverted>0.00</span> <small>₽</small></div>
										{% endif %}
									</div>
								</td>
								<td class="p0"></td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		{% endfor %}
	</div>
{% endif %}