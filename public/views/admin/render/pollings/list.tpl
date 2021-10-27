{% if pollings %}
	{% for polling in pollings %}
		{% include 'views/admin/render/pollings/item.tpl' with polling %}
	{% endfor %}
{% endif %}