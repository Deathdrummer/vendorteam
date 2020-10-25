<div class="list_item">
	<div>
		{% include form~'field.tpl' with {'label': 'Название типа рейда', 'name': 'raids_types|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Название окончания рейда', 'name': 'raids_types|new_'~index~'|end_name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Длительность (часов)', 'name': 'raids_types|new_'~index~'|duration_hours', 'type': 'number', 'min': 0, 'default': 0, 'postfix': 0, 'class': 'w10', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Длительность (минут)', 'name': 'raids_types|new_'~index~'|duration_minutes', 'type': 'number', 'default': 0, 'step': 5, 'min': 0, 'max': 55, 'postfix': 0, 'class': 'w10', 'inline': 1} %}
	</div>
</div>