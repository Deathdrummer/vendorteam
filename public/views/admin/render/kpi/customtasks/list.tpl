{% if customtasks.total %}
	{% for task in customtasks.items %}
		{% include 'views/admin/render/kpi/customtasks/item.tpl' with task %}
	{% endfor %}
{% endif %}