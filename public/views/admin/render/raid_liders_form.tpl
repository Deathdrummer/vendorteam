{% if raidliders %}
	<table id="raidlidersPaysForm">
		<thead>
			<tr class="h40px">
				<td><strong>Рейд-лидер</strong></td>
				<td class="w120px"><strong>Сумма</strong></td>
				<td class="center w60px"><i class="fa fa-check"></i></td>
			</tr>
		</thead>
		<tbody>
			{% for stId, liders in raidliders %}
				<tr>
					<td colspan="3" class="lightblue_bg">
						<div class="d-flex align-items-center">
							<img src="{{base_url('public/filemanager/thumbs/'~statics[stId]['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="{{statics[stId]['name']}}" class="avatar w40px h40px">
							<p class="ml5px">{{statics[stId]['name']}}</p>
						</div>
					</td>
				</tr>
				{% for lId, lider in liders %}
					<tr>
						<td>
							<div class="d-flex align-items-center">
								<img src="{{base_url('public/images/users/mini/'~lider.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{lider.nickname}}" class="avatar w30px h30px">
								<p class="ml5px">{{lider.nickname}}</p>
							</div>
						</td>
						<td>
							<div class="d-flex align-items-end">
								<div class="field">
									<input type="number" showrows value="{{summs[stId][lider.rank_lider][lider.rank]|default('0')}}" raidliderspayssumm>
								</div>
								<small class="ml4px fz16px">{{currency}}</small>
							</div>
						</td>
						<td class="center">
							<div class="checkblock">
								<input type="checkbox" id="raidliderspay{{lider.static}}_{{lId}}"{% if summs[stId][lider.rank_lider][lider.rank] %} checked{% endif %} raidliderspayslider="{{lId}}">
								<label for="raidliderspay{{lider.static}}_{{lId}}"></label>
							</div>
						</td>
					</tr>
				{% endfor %}
			{% endfor %}
		</tbody>
	</table>	
{% endif %}


<div class="row gutters-5">
	<div class="col-12 col-md-5">
		<div class="payment_request_form">
			<div class="payment_request_form__item">
				<label for="raidlidersPayOrder">Номер заказа</label>
				<input type="text" id="raidlidersPayOrder" autocomplete="off"/>
			</div>
			{#<div class="payment_request_form__item">
				<label>Удержать в резерв</label>
				<div class="checkblock">
					<input type="checkbox" id="paymentRequestToDeposit">
					<label for="paymentRequestToDeposit"></label>
				</div>
			</div>#}
		</div>
	</div>
	<div class="col-12 col-md-7">
		<div class="payment_request_form">
			<div class="payment_request_form__item">
				<label for="raidlidersPayComment">Комментарий</label>
				<textarea id="raidlidersPayComment"></textarea>
			</div>
		</div>
	</div>
</div>