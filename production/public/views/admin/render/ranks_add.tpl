<div class="list_item">
	<div>
		{% include form~'field.tpl' with {'label': 'Звание', 'name': 'ranks|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Период присвоения (дн.)', 'type': 'number', 'name': 'ranks|new_'~index~'|period', 'placeholder': 'Дней', 'postfix': 0, 'class': 'w12', 'default': 0, 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Коэффициент для формул', 'type': 'number', 'step': 0.01, 'name': 'ranks|new_'~index~'|coefficient', 'postfix': 0, 'placeholder': 'число', 'class': 'w12', 'default': 0, 'inline': 1} %}
	</div>
</div>