{% if data %}
	<p class="text-center">{{period_title}}</p>
	
	<div class="salary__statics mb-3" id="salaryStatics">
		<table>
			<thead>
				<tr>
					<td>Статик</td>
					<td class="w60px" title="Количчество участников">Кол-во участ.</td>
					<td class="w60px" title="Максимальная сумма коэффициентов">Макс. сум. коэфф.</td>
					<td class="nowidth">Коэфф.</td>
					<td class="nowidth">Сумма (р.)</td>
					<td class="nowidth" title="Выбрать">Выб.</td>
				</tr>
			</thead>
			<tbody id="salaryFormStatics">
				{% for staticId, row in data %}
					<tr>
						<td class="nopadding">
							<div class="row gutters-4 align-items-center">
								<div class="col-auto">
									<div class="avatar mini" style="background-image: url('{{base_url('public/filemanager/'~statics[staticId]['icon'])|is_file('public/images/deleted_mini.jpg')}}')"></div>
								</div>
								<div class="col">
									{{statics[staticId]['name']}}
								</div>
							</div>
						</td>
						<td>{{row.count_users}}</td>
						<td>{{row.max_coeff|round(2)}}</td>
						<td>
							<div class="popup__field w70px">
								<input type="number" salarycoeff showrows value="{{row.max_coeff|round(2)}}">
							</div>
						</td>
						<td>
							<div class="popup__field w100px">
								<input type="text" salarysumm showrows>
							</div>
						</td>
						<td class="text-center">
							<div class="checkblock">
								<input id="coeff{{staticId}}" choosedstatic="{{staticId}}" type="checkbox">
								<label for="coeff{{staticId}}"></label>
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
				<input type="text" id="salesOrder" placeholder="Номер заказа">
			</div>
		</div>
		<div class="col-auto">
			<div class="d-flex align-items-center">
				<span class="mr-2">Удержать в резерв</span>
				<div class="checkblock">
					<input type="checkbox" id="paymentRequestToDeposit">
					<label for="paymentRequestToDeposit"></label>
				</div>
			</div>
		</div>
	</div>
	
	<div class="popup__textarea">
		<label><span>Комментарий к оплате</span></label>
		<textarea id="salesComment" rows="4" placeholder="Комментарий"></textarea>
	</div>
{% endif %}