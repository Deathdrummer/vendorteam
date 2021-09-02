{% if newsfeedlist %}
	{% for item in newsfeedlist %}
		{% include 'views/admin/render/mininewsfeed/templates/item.tpl' with item %}
	{% endfor %}
{% endif %}