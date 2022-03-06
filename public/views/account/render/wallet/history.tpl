<div class="d-flex align-items-end wallet__title">
	<span class="wallet__label">Текущий баланс:</span>
	{# <small class="wallet__postfix">{{balance}}</small> #}
	<span class="wallet__balance">{{balance|currency('wallet__postfix')|raw}}</span>
</div>

{% if history %}
	<div id="walletUserBalance">
		<table class="popup__table">
			<thead>
				<tr>
					<td class="w170px">Тип</td>
					<td>Название</td>
					<td class="w180px">Дата</td>
					<td class="w90px">Сумма</td>
					<td class="w90px">В резерв</td>
					<td class="w90px">Баланс</td>
					<td class="w26px"></td>
				</tr>
			</thead>
			<tbody>
				{% for item in history|reverse %}
					<tr{% if item.type is null %} class="wallet__payout"{% endif %}{% if item.type < 0 %} class="wallet__payout_recovery"{% endif %}>
						{% if item.type < 0 %}
							<td colspan="2">{{types[item.type]}}</td>
						{% else %}
							<td>{{types[item.type]|default('Выплата')}}</td>
							<td><p class="fz12px">{{item.title}}</p></td>
						{% endif %}
						<td><small class="fz12px">{{item.date|d}} в {{item.date|t}}</small></td>
						<td>{{item.summ|currency('wallet__postfix')|raw}}</td>
						<td>{{item.deposit|currency('wallet__postfix')|raw}}</td>
						<td>{{item.current_balance|currency('wallet__postfix')|raw}}</td>
						<td class="center" title="{% if item.transfer == '+' %}Пополнение{% else %}Выплата{% endif %}"><strong>{{item.transfer}}</strong></td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}