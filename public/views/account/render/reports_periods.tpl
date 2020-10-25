<div class="popup__title">
	<h6 class="white center">Выберите период</h6>
</div>

<div class="popup__data">
	{% if periods %}
		
		<ul class="popup__list">
			{% for period in periods %}
				<li periodtocompound="{{period.id}}"><span>{{period.name}}</span></li>
			{% endfor %}
		</ul>
	{% endif %}
</div>
	