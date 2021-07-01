{% if reports %}
	<ul class="popup__list">
		{% for report in reports %}
			<li kpireport="{{report.id}}|{{report.periods}}">{{report.title}}</li>
		{% endfor %}
	</ul>
{% endif %}