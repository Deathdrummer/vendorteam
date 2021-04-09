<div class="mb20px">
	<span>Название периода:</span>
	<div class="popup__field">
		<input type="text" autocomplete="off" id="newratingPeriodTitle">
	</div>
</div>	

{#<div class="mb20px">
	<span class="d-block">Дата отсчета посещений:</span>
	<div class="popup__field popup__field_date w273px">
		<input type="text" autocomplete="off" id="newRatingsPeriodDate">
	</div>
</div>#}


<div class="d-flex justify-content-between align-items-center">
	<span>Периоды отчетов:</span>
	<small>Выбрано: <span id="countChoosedReports">0</span></small>	
</div>

{% if reports_periods %}
	<ul class="popup__scrollblock">
		{% for period in reports_periods %}
			<li class="noselect" periodid="{{period.id}}">{{period.name}}</li>
		{% endfor %}
	</ul>
{% else %}
	<p class="empty">Нет данных</p>
{% endif %}
