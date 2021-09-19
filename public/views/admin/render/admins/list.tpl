{% if list %}
	{% for item in list %}
		{% include 'views/admin/render/admins/item.tpl' with item %}
	{% endfor %}
{% endif %}