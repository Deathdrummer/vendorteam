{% if periods %}
	<div class="popup__title">
		<h6 class="white center">Выберите период</h6>
	</div>

	<div class="popup__data">
		<ul class="popup__list">
			{% for period in periods %}
				<li{% if attr %} {{attr}}="{{period.id}}"{% else %} periodtocompound="{{period.id}}"{% endif %}><span>{{period.name}}</span></li>
			{% endfor %}
		</ul>
	</div>
{% else %}
	<div class="popup__title">
		<h6 class="white center">Нет периодов</h6>
	</div>
{% endif %}