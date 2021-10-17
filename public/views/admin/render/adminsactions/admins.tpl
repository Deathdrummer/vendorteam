{% if admins %}
	<option value="">Все администраторы</option>
	<option value="0">Главный администратор</option>
	
	{% for admin in admins %}
		<option value="{{admin.id}}">{{admin.nickname}}</option>
	{% endfor %}
{% else %}
	<option value="">Нет админов</option>
{% endif %}