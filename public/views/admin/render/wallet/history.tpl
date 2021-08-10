{% if history %}
	<div id="walletUserBalance">
		<table class="popup__table">
			<thead>
				<tr>
					<td class="w170px">Тип</td>
					<td>Название</td>
					<td>Дата</td>
					<td class="w100px">Пополнение</td>
					<td class="w100px">В резерв</td>
					<td class="w100px">Сумма в кошельке</td>
					<td class="w30px"></td>
				</tr>
			</thead>
			<tbody>
				{% for item in history|reverse %}
					<tr{% if item.transfer == '-' %} class="wallet__payout"{% endif %}>
						{% if item.transfer == '-' %}
							<td colspan="2">{{item.title}}</td>
						{% else %}
							<td>{{types[item.type]}}</td>
							<td>{{item.title}}</td>
						{% endif %}
						<td>{{item.date|d}} в {{item.date|t}}</td>
						<td>{{item.summ|number_format(1, '.', ' ')}} <small class="wallet__postfix">₽</small></td>
						<td>{{item.deposit|number_format(1, '.', ' ')}} <small class="wallet__postfix">₽</small></td>
						<td>{{item.current_balance|number_format(1, '.', ' ')}} <small class="wallet__postfix">₽</small></td>
						<td class="center" title="{% if item.transfer == '+' %}Пополнение{% else %}Выплата{% endif %}"><strong>{{item.transfer}}</strong></td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}