{% if actions %}
	<option value="">Все типы</option>
	{% for actionId, actionName in actions %}
		<option value="{{actionId}}">{{actionName}}</option>
	{% endfor %}
{% else %}
	<option value="">Нет типов</option>
{% endif %}