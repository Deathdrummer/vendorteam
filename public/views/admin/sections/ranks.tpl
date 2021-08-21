<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Звания</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<ul class="tabstitles">
		<li id="users">Для участников</li>
		<li id="liders">Для рейд-лидеров</li>
	</ul>
	
	
	
	<div class="tabscontent">
		<div tabid="users">
			<fieldset>
				<legend>Список званий</legend>
				
				<div class="list" id="ranksBlock">
					{% if ranks|length > 0 %}
						{% for id in ranks|keys %}
							<div class="list_item">
								<div>
									{% include form~'field.tpl' with {'label': 'Звание', 'name': 'ranks|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Период присвоения (дн.)', 'type': 'number', 'name': 'ranks|'~id~'|period', 'postfix': 0, 'placeholder': 'Дней', 'class': 'w12', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Сдельный отчёт', 'type': 'number', 'step': 0.01, 'name': 'ranks|'~id~'|coefficient|1', 'postfix': 0, 'placeholder': 'Коэффициент', 'class': 'w12', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Премиальный отчёт', 'type': 'number', 'step': 0.01, 'name': 'ranks|'~id~'|coefficient|2', 'postfix': 0, 'placeholder': 'Коэффициент', 'class': 'w12', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Дополнительные выплаты', 'type': 'number', 'step': 1, 'name': 'ranks|'~id~'|additional_pay', 'postfix': 0, 'placeholder': 'Сумма', 'class': 'w12', 'inline': 1} %}
									
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
		</div>
		<div tabid="liders">
			<fieldset>
				<legend>Список званий</legend>
				
				<div class="list" id="ranksLidersBlock">
					{% if ranks_liders|length > 0 %}
						{% for id in ranks_liders|keys %}
							<div class="list_item">
								<div>
									{% include form~'field.tpl' with {'label': 'Звание', 'name': 'ranks_liders|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Коэффициент', 'type': 'number', 'step': 0.01, 'name': 'ranks_liders|'~id~'|coefficient', 'postfix': 0, 'placeholder': 'Коэффициент', 'class': 'w12', 'inline': 1} %}
				
									<div class="buttons right ml-auto">
										<button class="remove fieldheight remove_liders_rank" data-id="{{id}}" title="Удалить Звание"><i class="fa fa-trash"></i></button>
									</div>
								</div>
							</div>
						{% endfor %}
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}	
				</div>
				
				<div class="buttons">
					<button class="large" id="ranksLidersAdd">Добавить Звание</button>
				</div>
				
			</fieldset>
		</div>
	</div>
	
			
	
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
	
	
	
	//---------------------------------------------------------------------- Звания РЛ
	dynamicList({
		listBlock: '#ranksLidersBlock', 	// - ID блока списка
		addButton: '#ranksLidersAdd', 	// - ID кнопки добавления элемента списка
		template: 'ranks_liders_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_liders_rank',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить звание?',
		removeMessage: 'Звание успешно удалено!',
		phpFunctionRemove: 'admin/ranks_liders_remove', 	// - Функция обработки в PHP
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