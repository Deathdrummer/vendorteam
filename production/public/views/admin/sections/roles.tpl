<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Роли</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список ролей</legend>
		
		<div class="list" id="rolesBlock">
			{% if roles|length > 0 %}
				{% for id in roles|keys %}
					<div class="list_item">
						<div>
							{% include form~'field.tpl' with {'label': 'Навание роли', 'name': 'roles|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
							<div class="buttons right ml-auto">
								<button class="remove fieldheight remove_role" data-id="{{id}}" title="Удалить Роль"><i class="fa fa-trash"></i></button>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}	
		</div>
		
		<div class="buttons">
			<button class="large" id="rolesAdd">Добавить Роль</button>
		</div>
		
	</fieldset>
	
</form>








<script type="text/javascript"><!--
$(document).ready(function() {
	//---------------------------------------------------------------------- Роли
	dynamicList({
		listBlock: '#rolesBlock', 	// - ID блока списка
		addButton: '#rolesAdd', 	// - ID кнопки добавления элемента списка
		template: 'roles_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_role',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить роль?',
		removeMessage: 'Роль успешно удалена!',
		phpFunctionRemove: 'admin/roles_remove', 	// - Функция обработки в PHP
	});
	
	$('#rolesSave').on(tapEvent, function() {
		var rolesForm = new FormData($('#roles')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/admin/roles_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: rolesForm,
			success: function(response) {
				if (response) notify('Роли обновлены!');
				else notify('Ошибка сохранения ролей!', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
});
//--></script>