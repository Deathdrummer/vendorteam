{% if wallet_data and statics %}
	<ul class="tabstitles sub mt-2">
		{% for stId, static in statics %}
			<li id="tabWalletStatic{{stId}}">{{static.name}}</li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent">
		{% for stId in statics|keys %}
			<div tabid="tabWalletStatic{{stId}}">
				<table>
					<thead>
						<tr>
							<td class="w250px">Участник</td>
							<td class="w150px">Сумма в балансе</td>
							<td class="w150px">Резерв</td>
							<td class="w150px">Выплатить</td>
							<td class="w150px">В резерв</td>
							<td class="p0"></td>
							<td class="w122px" title="Распределить средства">Распределение</td>
							<td class="w60px" title="Посмотреть историю баланса">Истор.</td>
							<td class="w60px center">
								<i walletselectstatic="1" class="fa fa-2x fa-check-square"></i>
							</td>
						</tr>
					</thead>
					<tbody>
						{% for userId, user in wallet_data[stId] %}
							<tr walletuserrow="{{stId}}|{{userId}}">
								<td>
									<input type="hidden" initwalletbalance value="{{user['wallet_balance']}}">
									<input type="hidden" initdeposit value="{{user['deposit']}}">
									<input type="hidden" initpercenttodeposit value="{{user['percent_to_deposit']}}">
									<input type="hidden" initpayout value="{{user['payout']}}">
									<input type="hidden" inittodeposit value="{{user['to_deposit']}}">
									<input type="hidden" initmaxtodeposit value="{{user['max_to_deposit']}}">
									
									<div class="d-flex align-items-center">
										<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}')"></div>
										<p>{{user['nickname']}}</p>
									</div>
								</td>
								<td>{% if user['wallet_balance'] %}{{user['wallet_balance']|number_format(1, '.', ' ')}} <small>₽</small>{% else %}0 <small>₽</small>{% endif %}</td>
								<td>{% if user['deposit'] %}{{user['deposit']|number_format(1, '.', ' ')}} <small>₽</small>{% else %}0 <small>₽</small>{% endif %}</td>
								<td>
									{% if user['wallet_balance'] != 0 %}
										<div class="d-flex align-items-end">
											<div class="field mr-1">
												<input type="text" walletpayout value="{{user['payout']}}">
											</div>
											<small>₽</small>
										</div>
									{% else %}
										<span>-</span>
									{% endif %}
								</td>
								<td>
									{% if user['wallet_balance'] != 0 %}
										<div class="d-flex align-items-end">
											<div class="field mr-1">
												<input type="text" wallettodeposit value="{{user['to_deposit']}}">
											</div>
											<small>₽</small>
										</div>
									{% else %}
										<span>-</span>
									{% endif %}
								</td>
								<td class="p0"></td>
								<td class="center top pt8px">
									{% if user['wallet_balance'] != 0 %}
										<div class="buttons inline nowrap">
											<button walletalltopayout class="button pay small w30px" title="Отправить всю сумму в оплату"><i class="fa fa-money"></i></button>
											<button walletsetmaxtodeposit class="button small w30px" title="Отправить максимально возможную сумму в резерв"><i class="fa fa-money"></i></button>
											<button walletreturntoinit class="button alt2 small w30px" title="Сбросить значения до начальных"><i class="fa fa-undo"></i></button>
										</div>
									{% else %}
										<p class="mt10px">-</p>
									{% endif %}	
								</td>
								<td class="center top pt8px">
									<div class="buttons inline nowrap">
										<button class="small alt w30px" walletopenhistory="{{userId}}" title="Посмотреть историю баланса"><i class="fa fa-eye"></i></button>
									</div>
								</td>
								<td class="center">
									<div class="checkblock">
										<input type="checkbox" id="walletPayout{{stId}}{{userId}}" walletcheckeduser{% if user['wallet_balance'] != 0 %} checked{% else %} disabled{% endif %}>
										<label for="walletPayout{{stId}}{{userId}}"></label>
									</div>
								</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		{% endfor %}
	</div>
{% endif %}