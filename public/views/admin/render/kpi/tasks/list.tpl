{% if tasks.total %}
	{% for task in tasks.items %}
		{% include 'views/admin/render/kpi/tasks/item.tpl' with task %}
	{% endfor %}
{% endif %}