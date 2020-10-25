<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Типы рейдов и ключей</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	
	<ul class="tabstitles">
		<li id="tabRaidsTypes">Типы рейдов</li>
		<li id="tabKeysTypes">Типы ключей</li>
	</ul>
	
	
	
	<div class="tabscontent">
		<div tabid="tabRaidsTypes">
			<fieldset>
				<legend>Список типов рейдов</legend>
				
				<div class="list" id="raidsTypesBlock">
					{% if raids_types|length > 0 %}
						{% for id in raids_types|keys %}
							<div class="list_item">
								<div>
									{% include form~'field.tpl' with {'label': 'Название типа рейда', 'name': 'raids_types|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Название окончания рейда', 'name': 'raids_types|'~id~'|end_name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Длительность (часов)', 'name': 'raids_types|'~id~'|duration_hours', 'type': 'number', 'min': 0, 'postfix': 0, 'class': 'w10', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Длительность (минут)', 'name': 'raids_types|'~id~'|duration_minutes', 'type': 'number', 'step': 5, 'min': 0, 'max': 55, 'postfix': 0, 'class': 'w10', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Цвет фона', 'name': 'raids_types|'~id~'|color', 'type': 'color', 'postfix': 0, 'default': '#eef0f0', 'class': 'w5', 'inline': 1} %}
									<div class="buttons right ml-auto">
										<button class="remove fieldheight remove_raids_types" data-id="{{id}}" title="Удалить тип рейда"><i class="fa fa-trash"></i></button>
									</div>
								</div>
							</div>
						{% endfor %}
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}	
				</div>
				
				<div class="buttons">
					<button class="large" id="raidsTypesAdd">Добавить тип рейда</button>
				</div>
				
			</fieldset>
		</div>
		<div tabid="tabKeysTypes">
			<fieldset>
				<legend>Список типов ключей</legend>
				
				<div class="list" id="keysTypesBlock">
					{% if keys_types|length > 0 %}
						{% for id in keys_types|keys %}
							<div class="list_item">
								<div>
									{% include form~'field.tpl' with {'label': 'Название типа ключа', 'name': 'keys_types|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
									<div class="buttons right ml-auto">
										<button class="remove fieldheight remove_keys_types" data-id="{{id}}" title="Удалить тип ключа"><i class="fa fa-trash"></i></button>
									</div>
								</div>
							</div>
						{% endfor %}
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}	
				</div>
				
				<div class="buttons">
					<button class="large" id="keysTypesAdd">Добавить тип ключа</button>
				</div>
				
			</fieldset>
		</div>
	</div>
	
			
	
</form>








<script type="text/javascript"><!--
$(document).ready(function() {
	//---------------------------------------------------------------------- Типы рейдов
	dynamicList({
		listBlock: '#raidsTypesBlock', 	// - ID блока списка
		addButton: '#raidsTypesAdd', 	// - ID кнопки добавления элемента списка
		template: 'raids_types_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_raids_types',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить тип рейда?',
		removeMessage: 'Тип рейда успешно удален!',
		phpFunctionRemove: 'admin/raids_types_remove', 	// - Функция обработки в PHP
	});
	
	
	//---------------------------------------------------------------------- Типы рейдов
	dynamicList({
		listBlock: '#keysTypesBlock', 	// - ID блока списка
		addButton: '#keysTypesAdd', 	// - ID кнопки добавления элемента списка
		template: 'keys_types_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_keys_types',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить тип рейда?',
		removeMessage: 'Тип рейда успешно удален!',
		phpFunctionRemove: 'admin/keys_types_remove', 	// - Функция обработки в PHP
	});
	
	
	
	
	$('#raids_typesSave').on(tapEvent, function() {
		var raidsTypesForm = new FormData($('#raids_types')[0]),
			type = $('#raids_types').find('.tabstitles').children('li.active').attr('id'),
			url,
			n,
			nErr;
		
		if (type == 'tabRaidsTypes') {
			url = '/admin/raids_types_add';
			n = 'Рейды обновлены!';
			nErr = 'Ошибка сохранения рейдов!';
		} 
		else if (type == 'tabKeysTypes') {
			url = '/admin/keys_types_add';
			n = 'Ключи обновлены!';
			nErr = 'Ошибка сохранения ключей!';
		} 
		
		
		$.ajax({
			type: 'POST',
			url: url,
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: raidsTypesForm,
			success: function(response) {
				if (response) notify(n);
				else notify(nErr, 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
		
	});
});
//--></script>