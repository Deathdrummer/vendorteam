{% if periods.total %}
	<div class="popup__title">
		<h6 class="white center">Выберите период</h6>
	</div>

	<div class="popup__data">
		<ul class="popup__list popup__list_vertical">
			{% for period in periods.items %}
				<li kpiplanperiod="{{period.id}}" class="h70px">
					<strong class="fz18px mb10px">{{period.title}}</strong>
					<small class="fz12px">{{period.date_start|d}} - {{period.date_end|d}}</small>
				</li>
			{% endfor %}
		</ul>
	</div>
{% else %}
	<div class="popup__title">
		<h6 class="white center">Нет периодов</h6>
	</div>
{% endif %}