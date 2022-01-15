<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Уровни доступа к личному кабинету</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список доступов</legend>
		
		<div class="list" id="accountsAccessBlock">
			{% if accounts_access|length > 0 %}
				{% for id in accounts_access|keys %}
					<div class="list_item{% if accounts_access[id]['default'] %} list_item_active{% endif %}" rowid="{{id}}">
						<div>
							<div class="row w100">
								<div class="col-auto">
									{% include form~'field.tpl' with {'label': 'Название', 'name': 'accounts_access|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w300px', 'inline': 1} %}
								</div>
								<div class="col-auto">
									<strong>Меню</strong>
									<div><label for="nav{{id}}_1"><input type="checkbox"{% if accounts_access[id]['access']['nav']['guides'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][guides]" value="1" id="nav{{id}}_1"> Образование</label></div>
									<div><label for="nav{{id}}_2"><input type="checkbox"{% if accounts_access[id]['access']['nav']['timesheet'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][timesheet]" value="1" id="nav{{id}}_2"> Расписание</label></div>
									<div><label for="nav{{id}}_3"><input type="checkbox"{% if accounts_access[id]['access']['nav']['wallet'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][wallet]" value="1" id="nav{{id}}_3"> Выплаты</label></div>
									<div><label for="nav{{id}}_4"><input type="checkbox"{% if accounts_access[id]['access']['nav']['information'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][information]" value="1" id="nav{{id}}_4"> Важная информация</label></div>
									<div><label for="nav{{id}}_5"><input type="checkbox"{% if accounts_access[id]['access']['nav']['operators'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][operators]" value="1" id="nav{{id}}_5"> Операторы</label></div>
									<div><label for="nav{{id}}_6"><input type="checkbox"{% if accounts_access[id]['access']['nav']['offtime'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][offtime]" value="1" id="nav{{id}}_6"> Выходные</label></div>
									<div><label for="nav{{id}}_7"><input type="checkbox"{% if accounts_access[id]['access']['nav']['vacation'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][vacation]" value="1" id="nav{{id}}_7"> Отпуск</label></div>
									<div><label for="nav{{id}}_8"><input type="checkbox"{% if accounts_access[id]['access']['nav']['personages'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][personages]" value="1" id="nav{{id}}_8"> Мои персонажи</label></div>
									<div><label for="nav{{id}}_9"><input type="checkbox"{% if accounts_access[id]['access']['nav']['paymentorders'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][paymentorders]" value="1" id="nav{{id}}_9"> Мои заявки</label></div>
									<div><label for="nav{{id}}_10"><input type="checkbox"{% if accounts_access[id]['access']['nav']['visitsrate'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][visitsrate]" value="1" id="nav{{id}}_10"> Моя посещаемость</label></div>
									<div><label for="nav{{id}}_11"><input type="checkbox"{% if accounts_access[id]['access']['nav']['kpi'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][kpi]" value="1" id="nav{{id}}_11"> Мой KPI план</label></div>
									<div><label for="nav{{id}}_12"><input type="checkbox"{% if accounts_access[id]['access']['nav']['myaccount'] %} checked{% endif %} name="accounts_access[{{id}}][access][nav][myaccount]" value="1" id="nav{{id}}_12"> Мой аккаунт</label></div>
								</div>
								
								<div class="col-auto">
									<strong>Нижнее меню</strong>
									<div><label for="navdown{{id}}_1"><input type="checkbox"{% if accounts_access[id]['access']['navdown']['skype'] %} checked{% endif %} name="accounts_access[{{id}}][access][navdown][skype]" value="1" id="navdown{{id}}_1"> Ссылка скайп</label></div>
									<div><label for="navdown{{id}}_2"><input type="checkbox"{% if accounts_access[id]['access']['navdown']['complaints'] %} checked{% endif %} name="accounts_access[{{id}}][access][navdown][complaints]" value="1" id="navdown{{id}}_2"> Заказ оплаты</label></div>
									<div><label for="navdown{{id}}_3"><input type="checkbox"{% if accounts_access[id]['access']['navdown']['message'] %} checked{% endif %} name="accounts_access[{{id}}][access][navdown][message]" value="1" id="navdown{{id}}_3"> Форма для обращений</label></div>
								</div>
								
								<div class="col-auto">
									<strong>Контент</strong>
									<div><label for="content{{id}}_1"><input type="checkbox"{% if accounts_access[id]['access']['content']['compound'] %} checked{% endif %} name="accounts_access[{{id}}][access][content][compound]" value="1" id="content{{id}}_1"> Состав команды</label></div>
									<div><label for="content{{id}}_2"><input type="checkbox"{% if accounts_access[id]['access']['content']['news'] %} checked{% endif %} name="accounts_access[{{id}}][access][content][news]" value="1" id="content{{id}}_2"> Новости</label></div>
								</div>
								
								<div class="col-auto">
									<strong>Ссылки</strong>
									<div><label for="links{{id}}_1"><input type="checkbox"{% if accounts_access[id]['access']['links']['paydata'] %} checked{% endif %} name="accounts_access[{{id}}][access][links][paydata]" value="1" id="links{{id}}_1"> Платежные данные</label></div>
									<div><label for="links{{id}}_2"><input type="checkbox"{% if accounts_access[id]['access']['links']['mentors'] %} checked{% endif %} name="accounts_access[{{id}}][access][links][mentors]" value="1" id="links{{id}}_2"> Наставники</label></div>
								</div>
								
								<div class="col-auto ml-auto">
									<div class="buttons right ml-auto">
										<button class="fieldheight set_default_access"{% if accounts_access[id]['default'] %} disabled{% endif %} data-id="{{id}}" title="Задать дотсуп по-умолчанию"><i class="fa fa-users"></i></button>
										<button class="remove fieldheight remove_accounts_access"{% if accounts_access[id]['default'] %} disabled{% endif %} data-id="{{id}}" title="Удалить уровень доступа"><i class="fa fa-trash"></i></button>
									</div>
								</div>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}	
		</div>
		
		<div class="buttons">
			<button class="large" id="accountsAccessAdd">Добавить доступ</button>
		</div>
		
	</fieldset>
	
</form>




<script type="text/javascript"><!--
$(document).ready(function() {
	//---------------------------------------------------------------------- Уровни доступа
	dynamicList({
		listBlock: '#accountsAccessBlock', 	// - ID блока списка
		addButton: '#accountsAccessAdd', 	// - ID кнопки добавления элемента списка
		template: 'accounts_access_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_accounts_access',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить доступ?',
		removeMessage: 'Доступ успешно удален!',
		phpFunctionRemove: 'admin/accounts_access_remove', 	// - Функция обработки в PHP
	});
	
	$('#accounts_accessSave').on(tapEvent, function() {
		var accountsAccessForm = new FormData($('#accounts_access')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/admin/accounts_access_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: accountsAccessForm,
			success: function(response) {
				if (response) notify('Уровни доступа обновлены!');
				else notify('Ошибка сохранения уровней доступа!', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
		
	});
	
	
	
	
	$('.set_default_access').on(tapEvent, function() {
		var id = $(this).data('id'),
			thisRow = $(this).closest('.list_item'),
			activeRow = $('#accountsAccessBlock').find('.list_item.list_item_active');
		$.post('/admin/set_users_access', {id: id}, function(response) {
			if (response) {
				$(activeRow).removeClass('list_item_active');
				$(activeRow).find('.set_default_access, .remove_accounts_access').removeAttrib('disabled');
				
				$('#accountsAccessBlock').find('.list_item.list_item_active').remove
				$(thisRow).addClass('list_item_active');
				$(thisRow).find('.set_default_access, .remove_accounts_access').setAttrib('disabled');
				
				notify('Уровень доступа по-умолчанию назначен!');
			}
			else notify('Ошибка назначения уровнея доступа!', 'error');
		});
	});
	
});
//--></script>