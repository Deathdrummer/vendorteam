<div class="d-flex align-items-end wallet__title">
	<span class="wallet__label">Текущий баланс:</span>
	<span class="wallet__balance">{{balance|number_format(1, '.', ' ')}}</span>
	<small class="wallet__postfix">₽</small>
</div>

{% if history %}
	<div id="walletUserBalance">
		<table class="popup__table">
			<thead>
				<tr>
					<td class="w170px">Тип</td>
					<td>Название</td>
					<td>Дата</td>
					<td class="w100px">Выплата</td>
					<td class="w100px">В резерв</td>
					<td class="w100px">Остаток</td>
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
						<td class="center"><strong>{{item.transfer}}</strong></td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}