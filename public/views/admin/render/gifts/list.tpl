{% if gifts %}
	{% for gift in gifts %}
		{% include 'views/admin/render/gifts/item.tpl' with {gift: gift, fields: fields} %}
	{% endfor %}
{% endif %}