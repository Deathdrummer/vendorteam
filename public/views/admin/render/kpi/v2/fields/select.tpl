{% if fields %}
	{% for field, title in fields %}
		<option value="{{field}}">{{title}}</option>
	{% endfor %}
{% else %}
	<option value="" disabled>Нет полей</option>
{% endif %}