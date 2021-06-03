{% if statics %}
	<div class="salary__statics mb-3" id="salaryStatics">
		<table>
			<thead>
				<tr>
					<td>Статик</td>
					<td class="nowidth" title="Выбрать">Выб.</td>
				</tr>
			</thead>
			<tbody id="addictPayFormStatics">
				{% for staticId, static in statics %}
					<tr>
						<td>
							<div class="row gutters-4 align-items-center">
								<div class="col-auto">
									<div class="avatar mini" style="background-image: url('{{base_url('public/filemanager/'~static['icon'])|is_file('public/images/deleted_mini.jpg')}}')"></div>
								</div>
								<div class="col">
									{{static['name']}}
								</div>
							</div>
						</td>
						<td class="text-center">
							<div class="checkblock">
								<input type="checkbox" id="addictPay{{staticId}}" value="{{staticId}}">
								<label for="addictPay{{staticId}}"></label>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
	
	<div class="row">
		<div class="col-auto">
			<div class="popup__field mb-3">
				<label><span>Номер заказа</span></label>
				<input type="text" id="addictPayOrder" placeholder="Номер заказа">
			</div>
		</div>
		{#<div class="col-auto">
			<div class="d-flex align-items-center">
				<span class="mr-2">Удержать в резерв</span>
				<div class="checkblock">
					<input type="checkbox" id="paymentRequestToDeposit">
					<label for="paymentRequestToDeposit"></label>
				</div>
			</div>
		</div>#}
	</div>
	
	<div class="popup__textarea">
		<label><span>Комментарий к оплатам</span></label>
		<textarea id="addictPayComment" rows="4" placeholder="Комментарий"></textarea>
	</div>
{% endif %}