<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Классы</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список классов</legend>
		
		<div class="list" id="classesBlock">
			{% if classes|length > 0 %}
				{% for id in classes|keys %}
					<div class="list_item">
						<div>
							{% include form~'field.tpl' with {'label': 'Навание класса', 'name': 'classes|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
							<div class="buttons right ml-auto">
								<button class="remove fieldheight remove_class" data-id="{{id}}" title="Удалить класс"><i class="fa fa-trash"></i></button>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}	
		</div>
		
		<div class="buttons">
			<button class="large" id="classesAdd">Добавить Класс</button>
		</div>
		
	</fieldset>
	
</form>








<script type="text/javascript"><!--
$(document).ready(function() {
	//---------------------------------------------------------------------- классы
	dynamicList({
		listBlock: '#classesBlock', 	// - ID блока списка
		addButton: '#classesAdd', 	// - ID кнопки добавления элемента списка
		template: 'classes_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_class',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить класс?',
		removeMessage: 'класс успешно удален!',
		phpFunctionRemove: 'admin/classes_remove', 	// - Функция обработки в PHP
	});
	
	$('#classesSave').on(tapEvent, function() {
		var classesForm = new FormData($('#classes')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/admin/classes_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: classesForm,
			success: function(response) {
				if (response) notify('Классы обновлены!');
				else notify('Ошибка сохранения классов!', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
});
//--></script>