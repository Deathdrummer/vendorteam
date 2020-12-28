<div class="salary">
	<p class="salary__title">Выберите период</p>

	{% if periods %}
		<ul class="salary__periods">
			{% for period in periods %}
				<li periodid="{{period.id}}" periodtitle="{{period.name}}">{{period.name}}</li>
			{% endfor %}
		</ul>
	{% endif %}
</div>