<div class="list_item">
	<div>
		{% include form~'file.tpl' with {'label': 'Иконка', 'name': 'statics|new_'~index~'|icon', 'postfix': 0, 'ext': 'jpg|jpeg|png|gif'} %}
		{% include form~'field.tpl' with {'label': 'Название', 'name': 'statics|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w12', 'inline': 1} %}
		<span class="w3"></span>
		
		<strong class="ml4">Лимиты:</strong>
		{% include form~'field.tpl' with {'label': 'Рейдера', 'name': 'statics|new_'~index~'|cap_simple', 'postfix': 0, 'class': 'w6', 'default': 0, 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Рейд-лидера', 'name': 'statics|new_'~index~'|cap_lider', 'postfix': 0, 'class': 'w6', 'default': 0, 'inline': 1} %}
		<span class="w3"></span>
		
		<strong class="ml4">Локация:</strong>
		{% include form~'radio.tpl' with {'label': 'Локация', 'name': 'statics|new_'~index~'|location', 'data': {'У': 1, 'Е': 2, 'А': 3}, 'nolabel': 1, 'postfix': 0} %} 
		<span class="w3"></span>
		
		<strong class="ml4">Приостановить стаж:</strong>
		<div class="checkbox"><input type="checkbox" name="statics[new_{{index}}][stopstage]" value="1"></div>		
		<span class="w3"></span>
		
		
		{% include form~'field.tpl' with {'label': 'Процент начисления в депозит', 'name': 'statics|new_'~index~'|deposit_percent', 'postfix': 0, 'class': 'w6', 'inline': 1} %}
	</div>
</div>