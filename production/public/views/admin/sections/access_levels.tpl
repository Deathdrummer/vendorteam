<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Ранги</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список рангов</legend>
		
		<div class="list" id="accessLevelsBlock">
			{% if access_levels|length > 0 %}
				{% for id in access_levels|keys %}
					<div class="list_item">
						<div>
							{% include form~'field.tpl' with {'label': 'Название ранга', 'name': 'access_levels|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
							<div class="buttons right ml-auto">
								<button class="remove fieldheight remove_access_levels" data-id="{{id}}" title="Удалить ранг"><i class="fa fa-trash"></i></button>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}	
		</div>
		
		<div class="buttons">
			<button class="large" id="accessLevelsAdd">Добавить ранг</button>
		</div>
		
	</fieldset>
	
</form>




<script type="text/javascript"><!--
$(document).ready(function() {
	//---------------------------------------------------------------------- Уровни доступа
	dynamicList({
		listBlock: '#accessLevelsBlock', 	// - ID блока списка
		addButton: '#accessLevelsAdd', 	// - ID кнопки добавления элемента списка
		template: 'access_levels_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_access_levels',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить ранг?',
		removeMessage: 'Ранг успешно удален!',
		phpFunctionRemove: 'admin/access_levels_remove', 	// - Функция обработки в PHP
	});
	
	$('#access_levelsSave').on(tapEvent, function() {
		var accessLevelsForm = new FormData($('#access_levels')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/admin/access_levels_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: accessLevelsForm,
			success: function(response) {
				if (response) notify('Ранги успешно обновлены!');
				else notify('Ошибка сохранения рангов!', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
		
	});
});
//--></script>