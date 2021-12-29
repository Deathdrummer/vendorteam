<h3 class="fz16px mb20px fontcolor">{{id ? 'Редактировать столбец' : 'Новый стобец'}}</h3>
<form class="text-left" id="kpiv2NewFieldForm">
	{% if id %} <input type="hidden" name="id" value="{{id}}">{% endif %}
	<div class="mb20px">
		<p class="fz13px mb4px fontcolor">Название</p>
		<div class="field">
			<input type="text" name="field_title" value="{{title}}" rules="empty" autocomplete="off" placeholder="Введите название поля">
		</div>
	</div>
	
	<div class="mb15px">
		<div class="row gutters-5 justify-content-between">
			<div class="col-auto">
				<p class="fz13px mb4px fontcolor">Ширина (px)</p>
				<div class="field w90px">
					<input type="number" showrows name="field_width" value="{{width}}" rules="empty::введите значение!|num" autocomplete="off" placeholder="">
				</div>
			</div>
			<div class="col-auto text-right">
				<p class="fz13px mb4px fontcolor">По центру</p>
				<div class="checkblock mt7px">
					<input type="checkbox" name="field_center" id="fieldToCenter"{% if center %} checked{% endif %}>
					<label for="fieldToCenter"></label>
				</div>
			</div>
		</div>
			
	</div>
	
	<div class="mb15px">
		<p class="fz13px mb4px fontcolor">Тип данных</p>
		<div class="select fz14px">
			<select name="field_type">
				{% for t, title in {1: 'Строка', 2: 'Булевый', 3: 'Процентный'} %}
					<option value="{{t}}" {% if t == type %} selected{% endif %}>{{title}}</option>
				{% endfor %}
			</select>
			<div class="select__caret"></div>
			{# <input type="number" showrows name="field_width" value="{{width}}" rules="empty::введите значение!|num" autocomplete="off"> #}
		</div>
	</div>
</form>