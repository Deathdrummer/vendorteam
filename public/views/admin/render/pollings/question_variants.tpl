{% if variants %}
	{% for variant in variants %}
		{% include 'views/admin/render/pollings/question_variant.tpl' with variant %}
	{% endfor %}
{% endif %}