<p class="center large mb24px">на оплату за наставничество</p>
<form id="mrPaymentBlank" class="payment_request_blank onlyblock">
	
	<input type="hidden" name="id" value="{{id}}">
	<input type="hidden" name="user_id" value="{{user_id}}">
	<input type="hidden" name="nickname" value="{{nickname}}">
	<input type="hidden" name="avatar" value="{{avatar}}">
	<input type="hidden" name="payment" value="{{payment}}">
	<input type="hidden" name="static" value="{{static}}">
	<input type="hidden" name="order" value="Оплата за наставничество">
	
	<ul class="payment_request_choosen_users noselect">
		<li class="d-flex align-items-center">
			<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~avatar)}}')"></div>
			<div class="ml5px">
				<p class="mb3px"><strong>{{nickname}}</strong></p>
				<small>{{static_name}}</small>
			</div>
		</li>
	</ul>
	<div class="payment_request_form">
		{#<div class="payment_request_form__item">
			<label>Номер заказа</label>
			<input type="text" id="paymentRequestOrder" value="{{data.pay0}}" autocomplete="off"/>
		</div>#}
		<div class="payment_request_form__item">
			<label>Сумма</label>
			<input type="number" name="summ" class="number" min="0" value="0" autocomplete="off"/> <span>{{currency}}</span>
		</div>
		<div class="payment_request_form__item">
			<label>Комментарий</label>
			<textarea name="comment"></textarea>
		</div>
	</div>
</form>