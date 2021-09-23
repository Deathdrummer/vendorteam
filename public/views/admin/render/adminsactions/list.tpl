{% if list %}
	{% for item in list %}
		{% include 'views/admin/render/adminsactions/item.tpl' with item %}
	{% endfor %}
{% endif %}