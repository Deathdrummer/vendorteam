<div class="list_item">
	<div>
		<div class="list_col">
			{% include form~'file.tpl' with {'label': 'Иконка', 'name': 'statics|new_'~index~'|icon', 'postfix': 0, 'ext': 'jpg|jpeg|png|gif'} %}
		</div>	
		
		<div class="list_col ml20px">
			<strong class="title">Название статика:</strong>
			{% include form~'field.tpl' with {'label': 'Название', 'name': 'statics|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w100'} %}
		</div>
		
		<div class="list_col ml20px">
			<strong class="title">Лимиты:</strong>
			{% include form~'field.tpl' with {'label': 'Рейдера', 'name': 'statics|new_'~index~'|cap_simple', 'postfix': 0, 'class': 'w100'} %}
			{% include form~'field.tpl' with {'label': 'Рейд-лидера', 'name': 'statics|new_'~index~'|cap_lider', 'postfix': 0, 'class': 'w100'} %}
		</div>
		
		<div class="list_col ml20px">
			<strong class="title">Локация:</strong>
			{% include form~'radio.tpl' with {'label': 'Локация', 'name': 'statics|new_'~index~'|location', 'data': {'У': 1, 'Е': 2, 'А': 3}, 'nolabel': 1, 'postfix': 0} %} 
		</div>
		
		<div class="list_col ml20px">
			<strong class="title">Приостановить стаж:</strong>
			<div class="checkblock">
				<input type="checkbox" id="stopstage{{id}}"{% if statics[id]['stopstage'] %} checked{% endif %} name="statics[new_{{index}}][stopstage]" value="1">
				<label for="stopstage{{id}}"></label>
			</div>
		</div>
		
		<div class="list_col ml20px">
			<strong class="title">Формат оплаты труда:</strong>
			<div class="d-flex w160px">
				<div class="checkblock">
					<input type="checkbox" id="payformat{{id}}" {% if statics[id]['payformat'] %} checked{% endif %} name="statics[new_{{index}}][payformat]" value="1">
					<label for="payformat{{id}}"></label>
				</div>
				<label for="payformat{{id}}"><small class="subtitle ml5px">Окладно-премиальный</small></label>
			</div>
		</div>
		
		<div class="list_col ml20px">
			<strong class="title">Группа:</strong>
			<div class="select">
				<select name="statics[new_{{index}}][group]">
					<option value="1"{% if statics[id]['group'] == 1 %} selected{% endif %}>Рейды</option>
					<option value="2"{% if statics[id]['group'] == 2 %} selected{% endif %}>Группа</option>
					<option value="3"{% if statics[id]['group'] == 3 %} selected{% endif %}>Инактив</option>
				</select>
				<div class="select__caret"></div>
			</div>
		</div>
		
		<div class="list_col ml20px">
			<strong class="title">Начисление в депозит:</strong>
			{% include form~'field.tpl' with {'label': 'Процент', 'name': 'statics|new_'~index~'|deposit_percent', 'postfix': 0, 'class': 'w100'} %}
		</div>
			
		{#<div class="buttons right ml-auto">
			<button class="remove remove_static fieldheight" data-id="{{id}}" title="Удалить Статик"><i class="fa fa-trash"></i></button>
		</div>#}
	</div>
</div>