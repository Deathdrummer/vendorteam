<div class="row no-gutters payment_request_block">
	<div class="col-12 col-md-5">
		<div class="field">
			<input type="text" id="paymentRequestTempFindUser" autocomplete="off" placeholder="Поиск" />
		</div>
		<div id="paymentRequestsTempUsers" class="payment_requests_users noselect">
			{% if users %}
				<ul>
					{% for user in users %}
						<li chooseusertopaymentrequesttemp="{{user.id}}"{% if user.choosed %} class="choosed"{% endif %}>
							<p class="nickname">{{user.nickname}}</p>
							<div class="static">
								{% if user.static_icon %}
									<div class="image"><img src="{{base_url('public/filemanager/'~user.static_icon)}}" alt="{{user.static_name}}"></div>
								{% else %}
									<div class="image"><img src="{{base_url('public/images/deleted_mini.jpg')}}" alt="{{user.static_name}}"></div>
								{% endif %}
								<span>{{user.static_name}}</span>
							</div>
						</li>
					{% endfor %}
				</ul>
			{% endif %}
		</div>
	</div>
	<div class="col-12 col-md-7">
		<div class="payment_request_table">
			<table>
				<thead>
					<tr>
						<td class="w140px">Участник</td>
						<td>Сумма (руб.)</td>
						<td class="w58px">Удал.</td>
					</tr>
				</thead>
			</table>
			<div class="payment_request_table_scroll">
				<table>
					<tbody id="paymentRequestTempChoosen">
						{% if choosed_users %}
							{% for user in choosed_users %}
								<tr chooseduserid="{{user.user_id}}">
									<td class="w140px">
										<p class="nickname">{{users[user.user_id]['nickname']}}</p>
										<div class="static">
											<div class="image">
												<img src="{{base_url('public/filemanager/'~users[user.user_id]['static_icon'])}}" alt="{{users[user.user_id]['static_name']}}">
											</div>
											<span>{{users[user.user_id]['static_name']}}</span>
										</div>
									</td>
									<td>
										<div class="field">
											<input type="text" summ value="{{user.summ}}">
										</div>
									</td>
									<td><div class="buttons"><button class="remove" removechoosenuser="{{user.user_id}}" title="Удалить из списка"><i class="fa fa-trash"></i></button></div></td>
								</tr>	
							{% endfor %}	
						{% endif %}
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<div class="col-12">
		<div class="row gutters-5">
			<div class="col-12 col-md-5">
				<div class="payment_request_form">
					<div class="payment_request_form__item">
						<label for="paymentRequestTempOrder">Номер заказа</label>
						<input type="text" id="paymentRequestTempOrder" autocomplete="off"/>
					</div>
					<div class="payment_request_form__item">
						<label>Удержать в депозит</label>
						<div class="checkblock">
							<input type="checkbox" id="paymentRequestToDeposit">
							<label for="paymentRequestToDeposit"></label>
						</div>
					</div>
				</div>
			</div>
			<div class="col-12 col-md-7">
				<div class="payment_request_form">
					<div class="payment_request_form__item">
						<label for="paymentRequestTempComment">Комментарий</label>
						<textarea id="paymentRequestTempComment"></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>