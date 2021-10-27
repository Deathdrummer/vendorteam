{% if users %}
	{% for uId, user in users %}
		<li>{{user}}</li>
	{% endfor %}
{% endif %}