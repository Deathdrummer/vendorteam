<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Звания</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список званий</legend>
		
		<div class="list" id="ranksBlock">
			{% if ranks|length > 0 %}
				{% for id in ranks|keys %}
					<div class="list_item">
						<div>
							{% include form~'field.tpl' with {'label': 'Звание', 'name': 'ranks|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
							{% include form~'field.tpl' with {'label': 'Период присвоения (дн.)', 'type': 'number', 'name': 'ranks|'~id~'|period', 'postfix': 0, 'placeholder': 'Дней', 'class': 'w12', 'inline': 1} %}
							{% include form~'field.tpl' with {'label': 'Коэффициент для формул', 'type': 'number', 'step': 0.01, 'name': 'ranks|'~id~'|coefficient', 'postfix': 0, 'placeholder': 'число', 'class': 'w12', 'inline': 1} %}
							<div class="buttons right ml-auto">
								<button class="remove fieldheight remove_rank" data-id="{{id}}" title="Удалить Звание"><i class="fa fa-trash"></i></button>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}	
		</div>
		
		<div class="buttons">
			<button class="large" id="ranksAdd">Добавить Звание</button>
		</div>
		
	</fieldset>
	
</form>




<script type="text/javascript"><!--
$(document).ready(function() {
	//---------------------------------------------------------------------- Звания
	dynamicList({
		listBlock: '#ranksBlock', 	// - ID блока списка
		addButton: '#ranksAdd', 	// - ID кнопки добавления элемента списка
		template: 'ranks_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_rank',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить звание?',
		removeMessage: 'Звание успешно удалено!',
		phpFunctionRemove: 'admin/ranks_remove', 	// - Функция обработки в PHP
	});
	
	
	
	
	$('#ranksSave').on(tapEvent, function() {
		var ranksForm = new FormData($('#ranks')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/admin/ranks_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: ranksForm,
			success: function(response) {
				if (response) notify('Звания обновлены!');
				else notify('Ошибка сохранения званий!', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
		
	});
});
//--></script>