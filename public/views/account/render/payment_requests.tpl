{% if payment_requests_list or users_list_pay %}
	<ul class="tabstitles">
		{% if payment_requests_list %}
			{% for paid in payment_requests_list|keys %}
				<li id="paymentRequestsPaid{{paid}}"><p>{{payment_requests_titles[paid]}}</p></li>	
			{% endfor %}
		{% endif %}
		<li id="paymentRequestsNew"><p>Мои новые заявки</p></li>
	</ul>
	
	<div class="tabscontent">
		{% if payment_requests_list %}
			{% for paid, items in payment_requests_list %}
				<div tabid="paymentRequestsPaid{{paid}}">
					<table class="popup__table">
						<thead>
							<tr>
								<td class="nowrap">Статик</td>
								<td class="nowrap">Способ оплаты</td>
								<td class="nowrap">№ заказа</td>
								<td class="nowrap">Сумма заказа</td>
								<td>Комментарий</td>
								<td>Дата</td>
							</tr>
						</thead>
						{% for item in items %}
							<tbody>
								<tr>
									<td>
										<div class="d-flex align-items-center">
											<div class="mr-1">
												{% if item.static_icon %}
													<img style="width: 26px" src="{{base_url('public/filemanager/'~item.static_icon)}}" alt="">
												{% else %}
													<img style="width: 26px" src="{{base_url('public/images/deleted_mini.jpg')}}" alt="">
												{% endif %}
											</div>
											<div><small>{{item.static_name}}</small></div>
										</div>
									</td>
									<td><small>{{item.payment}}</small></td>
									<td><p>{{item.order}}</p></td>
									<td class="nowrap right"><p class="inline">{{currency(item.summ, '<small class="inline">$</small>')}}</p></td>
									<td><small>{{item.comment}}</small></td>
									<td><p class="nowrap">{{item.date|d}} {{item.date|t}}</p></td>
								</tr>
							</tbody>
						{% endfor %}
					</table>
				</div>
			{% endfor %}
		{% endif %}
			
		<div tabid="paymentRequestsNew">
			{% if users_list_pay %}
				{% set colsp = '' %}
				<table class="popup__table">
					<thead>
						<tr>
							<td>Статик</td>
							{% for k, item in fields_pay_setting %}
								{% set colsp = colsp~'|'~k %}
								<td>{{item.label}}</td>
							{% endfor %}
							<td>Дата</td>
						</tr>
					</thead>
					
					<tbody>
						{% for field in users_list_pay %}
							<tr>
								<input type="hidden" class="field_pay_id" value="{{field.user_id}}">
								<td class="field_pay_static nowidth">
									<div class="d-flex align-items-center">
										<div class="mr-1 image" style="background-image: url('{{base_url(field.static_icon)}}');width: 26px;height: 26px;"></div>
										<small class="nowrap">{{field.static}}</small>
									</div>
								</td>
								{% for i in colsp|trim('|', 'left')|split('|') %}
									<td class="field_pay_{{i}}">{{field['field_pay_'~i]}}</td>
								{% endfor %}
								<td class="nowidth nowrap">{{field['date']|slice(0, -3)|d}} {{field['date']|slice(0, -3)|t}}</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			{% endif %}
		</div>
	</div>
{% endif %}