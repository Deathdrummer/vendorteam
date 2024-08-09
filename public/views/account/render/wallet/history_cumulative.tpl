<div class="d-flex align-items-end wallet__title">
	<span class="wallet__label">Текущий баланс:</span>
	{# <small class="wallet__postfix">{{balance}}</small> #}
	<span class="wallet__balance">{{currency(balance, '<small class="wallet__postfix">$</small>')}}</span>
</div>

{% if history %}
	<div id="walletUserBalance">
		<table class="popup__table">
			<thead>
				<tr>
					<td class="w170px">Тип</td>
					<td>Название</td>
					<td class="w180px">Дата</td>
					<td class="w200px">Сумма</td>
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
						<td>
							<div class="d-flex justify-content-between">
								<span>{{currency(item.summ, '<small class="wallet__postfix">$</small>')}}</span>
								<div class="text-right">
									{% if not item.type and item.currency %}
										<p class="fz12px grayblue">{{currency(item.summ * item.currency)}}</p>
										<p class="lightfontcolor fz10px">по курсу: {{currency(item.currency)}}</p>
									{% else %}
										<p>-</p>
									{% endif %}
								</div>
							</div>
						</td>
						<td>{{currency(item.current_balance, '<small class="wallet__postfix">$</small>')}}</td>
						<td class="center" title="{% if item.transfer == '+' %}Пополнение{% else %}Выплата{% endif %}"><strong>{{item.transfer}}</strong></td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}