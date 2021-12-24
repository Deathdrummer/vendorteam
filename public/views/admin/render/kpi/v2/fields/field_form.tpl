<h3 class="fz16px mb20px">{{id ? 'Редактировать столбец' : 'Новый стобец'}}</h3>
<form class="text-left" id="kpiv2NewFieldForm">
	{% if id %} <input type="hidden" name="id" value="{{id}}">{% endif %}
	<div class="mb20px">
		<p class="fz14px mb4px">Название</p>
		<div class="field">
			<input type="text" name="field_title" value="{{title}}" rules="empty" autocomplete="off">
		</div>
	</div>
	<div class="mb15px">
		<p class="fz14px mb4px">Ширина (px)</p>
		<div class="field w90px">
			<input type="number" showrows name="field_width" value="{{width}}" rules="empty::введите значение!|num" autocomplete="off">
		</div>
	</div>
</form>