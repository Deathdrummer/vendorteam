<div class="list_item">
	<div class="block">
		<title>{{i}}</title>
		
		{% include form~'field.tpl' with {'label': 'Лэйбл', 'name': 'fields_complaints|'~i~'|label'} %}
		{% include form~'field.tpl' with {'label': 'Плейсхолдер', 'name': 'fields_complaints|'~i~'|placeholder'} %}
		{% include form~'field.tpl' with {'label': 'Значение', 'name': 'fields_complaints|'~i~'|values', 'placeholder': 'значение1,значение2,...', 'class': 'w100'} %}
		{% include form~'radio.tpl' with {'label': 'Тип поля', 'name': 'fields_complaints|'~i~'|type', 'data': {'Строка': 'text', 'Телефон': 'tel', 'E-mail': 'email', 'Текстовое поле': 'textarea', 'Число': 'number', 'Выпадающий список': 'select'}} %}
		{% include form~'radio.tpl' with {'label': 'Обязательное поле', 'name': 'fields_complaints|'~i~'|required', 'data': {'Да': '', 'Нет': 'empty'}} %}
	</div>
</div>