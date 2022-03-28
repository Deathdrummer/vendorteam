{% if report_statics %}
	<table>
		<thead>
			<tr>
				<td>Статик</td>
				<td>Бюджет</td>
				<td class="text-center w40px">
					<i id="staticsDepositCheckAll" class="fa fa-check-square fa-2x" title="Выделить все / Снять выделение"></i>
				</td>
			</tr>
		</thead>
		<tbody>
			{% for id, name in report_statics %}
				<tr>
					<td><label for="static{{id}}">{{name}}</label></td>
					<td class="w130px nowrap">
						<div class="row gutters-3 align-items-center">
							<div class="col">
								<div class="popup__field">
									<input type="text" min="0" step="1000" id="static{{id}}" autocomplete="off" static="{{id}}" value="{% if set_cash[id] %}{{set_cash[id]}}{% else %}0{% endif %}">
								</div>
							</div>
							<div class="col-auto">
								<span>{{currency}}</span>
							</div>
						</div>
					</td>
					<td class="text-center">
						<div class="checkblock">
							<input choosestatictodeposit type="checkbox" id="staticChoosed{{id}}" checked>
							<label for="staticChoosed{{id}}"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}