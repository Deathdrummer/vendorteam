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
							{% include form~'file.tpl' with {'label': 'Иконка', 'name': 'statics|'~id~'|icon', 'postfix': 0, 'ext': 'jpg|jpeg|png|gif'} %}
							{% include form~'field.tpl' with {'label': 'Название', 'name': 'statics|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w12', 'inline': 1} %}
							<span class="w3"></span>
							
							<strong class="ml4">Лимиты:</strong>
							{% include form~'field.tpl' with {'label': 'Рейдера', 'name': 'statics|'~id~'|cap_simple', 'postfix': 0, 'class': 'w6', 'inline': 1} %}
							{% include form~'field.tpl' with {'label': 'Рейд-лидера', 'name': 'statics|'~id~'|cap_lider', 'postfix': 0, 'class': 'w6', 'inline': 1} %}
							<span class="w3"></span>
							
							<strong class="ml4">Локация:</strong>
							{% include form~'radio.tpl' with {'label': 'Локация', 'name': 'statics|'~id~'|location', 'data': {'У': 1, 'Е': 2, 'А': 3}, 'nolabel': 1, 'postfix': 0} %} 
							<span class="w3"></span>
							
							<strong class="ml4">Приостановить стаж:</strong>
							<div class="checkbox"><input type="checkbox"{% if statics[id]['stopstage'] %} checked{% endif %} name="statics[{{id}}][stopstage]" value="1"></div>
							<span class="w3"></span>
							
							{% include form~'field.tpl' with {'label': 'Процент начисления в депозит', 'name': 'statics|'~id~'|deposit_percent', 'postfix': 0, 'class': 'w6', 'inline': 1} %}
							
							<div class="buttons right ml-auto">
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