<div class="list_item">
	<div>
		{% include form~'field.tpl' with {'label': 'Логин оператора', 'name': 'operators|new_'~index~'|login', 'placeholder': 'Логин', 'postfix': 0, 'class': 'w15', 'inline': 1} %}
		{% include form~'field.tpl' with {'label': 'Пароль оператора', 'name': 'operators|new_'~index~'|password', 'placeholder': 'Пароль', 'postfix': 0, 'class': 'w15', 'inline': 1} %}
		<input type="hidden" class="choosen_statics" name="operators[new_{{index}}][statics]" value="">
		<input type="hidden" class="choosen_access" name="operators[new_{{index}}][access]" value="">
		<div class="buttons">
			<button class="fieldheight set_operators_statics" title="Разрешенные статики"><i class="fa fa-bars"></i></button>
			<button class="fieldheight set_operators_access" title="Доступы"><i class="fa fa-sliders"></i></button>
		</div>
	</div>
</div>