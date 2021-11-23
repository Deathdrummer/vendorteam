{% if users.total %}
	{% for user in users.items %}
		{% include 'views/admin/render/usersv2/row.tpl' with user %}
	{% endfor %}
{% endif %}