<div class="list_item">
	<div>
		{% include form~'color.tpl' with {'label': 'Иконка', 'name': 'raiders_colors|new_'~index~'|color', 'postfix': 0, 'class': 'w70px'} %}
		{% include form~'field.tpl' with {'label': 'Название цвета', 'name': 'raiders_colors|new_'~index~'|name', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
	</div>
</div>