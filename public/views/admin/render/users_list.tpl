{% if blank %}
	<div class="row no-gutters payment_request_block">
		<div class="col-12">
			<div id="paymentRequestBlank" class="payment_request_blank onlyblock">
				<ul id="paymentRequestChoosenUsers" class="payment_request_choosen_users noselect">
					<li paymentrequestchoosenuser="{{data.user_id}}">
						<p class="nickname">{{data.nickname}}</p>
						<div class="static"><span>{{data.static}}</span></div>
					</li>
				</ul>
				<div class="payment_request_form">
					<div class="payment_request_form__item">
						<label for="paymentRequestOrder">Номер заказа</label>
						<input type="text" id="paymentRequestOrder" value="{{data.pay0}}" autocomplete="off"/>
					</div>
					<div class="payment_request_form__item">
						<div class="row">
							<div class="col-auto">
								<label for="paymentRequestSumm">Сумма</label>
								<input type="text" class="number" value="0" id="paymentRequestSumm" autocomplete="off"/> <span>руб.</span>
							</div>
							{#<div class="col">
								<label>Удержать в резерв</label>
								<div class="checkblock">
									<input type="checkbox" id="paymentRequestToDeposit">
									<label for="paymentRequestToDeposit"></label>
								</div>
							</div>#}
						</div>
					</div>
					<div class="payment_request_form__item">
						<label for="paymentRequestComment">Комментарий</label>
						<textarea name="" id="paymentRequestComment">{{data.pay1}}</textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
{% endif %}

{% if start %}
	<div class="row no-gutters payment_request_block">
		<div class="col-12 col-md-4">
			<div class="field">
				<input type="text" id="paymentRequestFindUser" autocomplete="off" placeholder="Введите никнейм..." />
			</div>
			<div id="paymentRequestsUsers" class="payment_requests_users noselect">
				{% if users %}
					<ul>
						{% for user in users %}
							<li chooseusertopaymentrequest="{{user.id}}">
								<p class="nickname">{{user.nickname}}</p>
								<div class="static">
									<div class="image"><img src="{{base_url()}}public/filemanager/{{user.static.icon}}" alt=""></div>
									<span>{{user.static.name}}</span>
								</div>
							</li>
						{% endfor %}
					</ul>
				{% endif %}
			</div>
		</div>
		<div class="col-12 col-md-8">
			<div id="paymentRequestBlank" class="payment_request_blank">
				<ul id="paymentRequestChoosenUsers" class="payment_request_choosen_users noselect"></ul>
				<div class="payment_request_form">
					<div class="payment_request_form__item">
						<label for="paymentRequestOrder">Номер заказа</label>
						<input type="text" id="paymentRequestOrder" autocomplete="off"/>
					</div>
					<div class="payment_request_form__item">
						<div class="row align-items-end">
							<div class="col-auto">
								<label for="paymentRequestSumm">Сумма</label>
								<input type="text" class="number" value="0" id="paymentRequestSumm" autocomplete="off"/> <span>руб.</span>
							</div>
							{#<div class="col-auto">
								<label>Удержать в резерв</label>
								<div class="checkblock">
									<input type="checkbox" id="paymentRequestToDeposit">
									<label for="paymentRequestToDeposit"></label>
								</div>
							</div>#}
						</div>
								
					</div>
					<div class="payment_request_form__item">
						<label for="paymentRequestComment">Комментарий</label>
						<textarea name="" id="paymentRequestComment" ></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
{% else %}
	{% if users %}
		<ul>
			{% for user in users %}
				<li chooseusertopaymentrequest="{{user.id}}">
					<p class="nickname">{{user.nickname}}</p>
					<div class="static">
						<div class="image"><img src="{{base_url()}}public/images/{{user.static.icon}}" alt=""></div>
						<span>{{user.static.name}}</span>
					</div>
				</li>
			{% endfor %}
		</ul>
	{% endif %}
{% endif %}