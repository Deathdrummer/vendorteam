<div class="list_item">
	<div>
		{% include form~'field.tpl' with {'label': 'Звание', 'name': 'ranks|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Период присвоения (дн.)', 'type': 'number', 'name': 'ranks|new_'~index~'|period', 'postfix': 0, 'placeholder': 'Дней', 'class': 'w12', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Сдельный отчёт', 'type': 'number', 'step': 0.01, 'name': 'ranks|new_'~index~'|coefficient|1', 'postfix': 0, 'placeholder': 'Коэффициент', 'class': 'w12', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Премиальный отчёт', 'type': 'number', 'step': 0.01, 'name': 'ranks|new_'~index~'|coefficient|2', 'postfix': 0, 'placeholder': 'Коэффициент', 'class': 'w12', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Дополнительные выплаты', 'type': 'number', 'step': 1, 'name': 'ranks|new_'~index~'|additional_pay', 'postfix': 0, 'placeholder': 'Сумма', 'class': 'w12', 'inline': 1} %}						
	</div>
</div>