<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Статики</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список статиков</legend>
		
		<div class="list" id="staticsBlock">
			{% if statics|length > 0 %}
				{% for id in statics|keys %}
					<div class="list_item">
						<div>
							<div class="list_col">
								{% include form~'file.tpl' with {'label': 'Иконка', 'name': 'statics|'~id~'|icon', 'postfix': 0, 'ext': 'jpg|jpeg|png|gif'} %}
							</div>	
							
							<div class="list_col ml20px">
								<strong class="title">Название статика:</strong>
								{% include form~'field.tpl' with {'label': 'Название', 'name': 'statics|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w100'} %}
							</div>
							
							<div class="list_col ml20px">
								<strong class="title">Лимиты:</strong>
								{% include form~'field.tpl' with {'label': 'Рейдера', 'name': 'statics|'~id~'|cap_simple', 'postfix': 0, 'class': 'w100'} %}
								{% include form~'field.tpl' with {'label': 'Рейд-лидера', 'name': 'statics|'~id~'|cap_lider', 'postfix': 0, 'class': 'w100'} %}
							</div>
							
							<div class="list_col ml20px">
								<strong class="title">Локация:</strong>
								{% include form~'radio.tpl' with {'label': 'Локация', 'name': 'statics|'~id~'|location', 'data': {'У': 1, 'Е': 2, 'А': 3}, 'nolabel': 1, 'postfix': 0} %} 
							</div>
							
							<div class="list_col ml20px">
								<strong class="title">Приостановить стаж:</strong>
								<div class="checkblock">
									<input type="checkbox" id="stopstage{{id}}"{% if statics[id]['stopstage'] %} checked{% endif %} name="statics[{{id}}][stopstage]" value="1">
									<label for="stopstage{{id}}"></label>
								</div>
							</div>
							
							<div class="list_col ml20px">
								<strong class="title">Формат оплаты труда:</strong>
								<div class="d-flex w160px">
									<div class="checkblock">
										<input type="checkbox" id="payformat{{id}}" {% if statics[id]['payformat'] %} checked{% endif %} name="statics[{{id}}][payformat]" value="1">
										<label for="payformat{{id}}"></label>
									</div>
									<label for="payformat{{id}}"><small class="subtitle ml5px">Окладно-премиальный</small></label>
								</div>
							</div>
							
							<div class="list_col ml20px">
								<strong class="title">Группа:</strong>
								<div class="select">
									<select name="statics[{{id}}][group]">
										<option value="1"{% if statics[id]['group'] == 1 %} selected{% endif %}>Рейды</option>
										<option value="2"{% if statics[id]['group'] == 2 %} selected{% endif %}>Группа</option>
										<option value="3"{% if statics[id]['group'] == 3 %} selected{% endif %}>Инактив</option>
									</select>
									<div class="select__caret"></div>
								</div>
							</div>
							
							<div class="list_col ml20px">
								<strong class="title">Начисление в депозит:</strong>
								{% include form~'field.tpl' with {'label': 'Процент', 'name': 'statics|'~id~'|deposit_percent', 'postfix': 0, 'class': 'w100'} %}
							</div>
							
							<div class="list_col right ml-auto">
								<strong class="title">Актив:</strong>
								<div class="checkblock">
									<input type="checkbox" id="active{{id}}"{% if statics[id]['active'] %} checked{% endif %} name="statics[{{id}}][active]" value="1">
									<label for="active{{id}}"></label>
								</div>
							</div>
								
							<div class="buttons right ml20px">
								<button class="remove remove_static fieldheight" data-id="{{id}}" title="Удалить Статик"><i class="fa fa-trash"></i></button>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}	
		</div>
		
		<div class="buttons">
			<button class="large" id="staticsAdd">Добавить Статик</button>
		</div>
	</fieldset>
</form>







<script type="text/javascript"><!--
$(document).ready(function() {
	//---------------------------------------------------------------------- Статики
	$('#staticsBlock').find('[name*="cap_simple"], [name*="cap_lider"]').number(true, 0, '.', ' ');
	
	$('#staticsBlock').find('.radio').each(function() {
		if ($(this).find('input:checked').length == 0) {
			$(this).find('.radio_items_item:first input').prop('checked', true);
		}
	});
	
	dynamicList({
		listBlock: '#staticsBlock', 	// - ID блока списка
		addButton: '#staticsAdd', 	// - ID кнопки добавления элемента списка
		template: 'statics_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_static',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить статик?',
		removeMessage: 'Статик успешно удален!',
		phpFunctionRemove: 'admin/statics_remove', 	// - Функция обработки в PHP
		onAdd: function(block) {
			block.find('[name*="cap_simple"], [name*="cap_lider"]').number(true, 0, '.', ' ');
			block.find('.radio_items_item:first input').prop('checked', true);
		}
	});
	
	$('#staticsSave').on(tapEvent, function() {
		
		var staticsForm = new FormData($('#statics')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/admin/statics_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: staticsForm,
			success: function(response) {
				if (response) notify('Настройки статиков сохранены!');
				else notify('Ошибка сохранения настроек статиков!', 'error');
			},
			error: function(e) {
				console.log(e);	
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
		
	});
	
	
});
//--></script>