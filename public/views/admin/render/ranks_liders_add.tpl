<div class="list_item">
	<div>
		{% include form~'field.tpl' with {'label': 'Звание', 'name': 'ranks_liders|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Коэффициент для формул', 'type': 'number', 'step': 0.01, 'name': 'ranks_liders|new_'~index~'|coefficient', 'postfix': 0, 'placeholder': 'число', 'class': 'w12', 'default': 1, 'inline': 1} %}
	</div>
</div>