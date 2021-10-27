{% if statics %}
	{% for stId, staticName in statics %}
		<li>{{staticName}}</li>
	{% endfor %}
{% endif %}