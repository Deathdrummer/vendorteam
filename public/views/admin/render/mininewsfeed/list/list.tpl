{% if list %}
	{% for item in list %}
		{% include 'views/admin/render/mininewsfeed/list/item.tpl' with {item: item, statics: statics} %}
	{% endfor %}
{% endif %}