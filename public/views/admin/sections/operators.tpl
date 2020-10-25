<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Операторы</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend></legend>
		
		<ul class="tabstitles">
			<li id="operators">Список операторов</li>
			<li id="hourssheet">Приемные часы</li>
		</ul>
		
		<div class="tabscontent">
			<div tabid="operators">
				<div class="list" id="operatorsBlock">
					{% if operators|length > 0 %}
						{% for id, data in operators %}
							<div class="list_item">
								<div>
									
									{% include form~'field.tpl' with {'label': 'Логин оператора', 'name': 'operators|'~id~'|login', 'placeholder': 'Логин', 'postfix': 0, 'class': 'w15', 'inline': 1} %}
									{% include form~'field.tpl' with {'label': 'Пароль оператора', 'name': 'operators|'~id~'|password', 'placeholder': 'Пароль', 'postfix': 0, 'class': 'w15', 'inline': 1} %}
									<input type="hidden" class="choosen_statics" name="operators[{{id}}][statics]" value="{{data.statics}}">
									<input type="hidden" class="choosen_access" name="operators[{{id}}][access]" value="{{data.access}}">
									<div class="buttons">
										<button class="fieldheight set_operators_statics" title="Разрешенные статики"><i class="fa fa-bars"></i></button>
										<button class="fieldheight set_operators_access" title="Доступы"><i class="fa fa-sliders"></i></button>
									</div>
									
									{% if data.avatar %}
										<img src="{{base_url()}}public/images/operators/mini/{{data.avatar}}?{{time()}}" class="ml-5" alt="{{data.nickname}}" title="{{data.nickname}}">
									{% endif %}
									{% if data.nickname %}
										<span>{{data.nickname}}</span>
									{% endif %}
									
									<div class="buttons right ml-auto">
										<button class="remove fieldheight remove_operators" data-id="{{id}}" title="Удалить оператора"><i class="fa fa-trash"></i></button>
									</div>
								</div>
							</div>
						{% endfor %}
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}	
				</div>
				
				<div class="buttons">
					<button class="large" id="operatorsAdd">Добавить оператора</button>
				</div>
			</div>
			<div tabid="hourssheet">
				{% if hourssheet %}
					<ul class="tabstitles sub">
						{% for opid, data in hourssheet %}
							<li id="operator{{opid}}">{{data.name}}</li>
						{% endfor %}
					</ul>
					
					<div class="tabscontent">
						{% for opid, data in hourssheet %}
							<div tabid="operator{{opid}}">
								<table>
									<thead>
										<tr>
											{% for day in week %}
												<td>{{day}}</td>
											{% endfor %}
										</tr>
									</thead>
									{% for week in data.dates|chunk(7, true) %}
										<tr>
											{% for day, data in week %}
												<td{% if day < current_date %} class="closed"{% endif %}>
													<div class="d-flex justify-content-between">
														<p>{{day|d}}</p>
														{% if day >= current_date %}
															<button title="Часы работы" addhourssheet="{{opid}}|{{day}}"><i class="fa fa-clock-o"></i></button>
														{% endif %}
													</div>
													
													{% if data %}
														<ul>
															{% for item in data %}
																<li>{{item.time_start_h|add_zero}}:{{item.time_start_m|add_zero}} - {{item.time_end_h|add_zero}}:{{item.time_end_m|add_zero}}</li>
															{% endfor %}
														</ul>
													{% endif %}
														
												</td>
											{% endfor %}
										</tr>
									{% endfor %}
								</table>	
							</div>
						{% endfor %}
					</div>		
				{% endif %}
			</div>
		</div>
		
		
	</fieldset>
	
	
		
</form>








<script type="text/javascript"><!--
$(document).ready(function() {
	
	dynamicList({
		listBlock: '#operatorsBlock', 	// - ID блока списка
		addButton: '#operatorsAdd', 	// - ID кнопки добавления элемента списка
		template: 'operators_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_operators',	// - Класс кнопки удаления элемента списка
		removeCallback: function() {
			renderSection();
		},
		removeQuestion: 'Удалить оператора?',
		removeMessage: 'Оператор успешно удален!',
		phpFunctionRemove: 'admin/operators_remove', 	// - Функция обработки в PHP
	});
	
	$('#operatorsSave').on(tapEvent, function() {
		var raidsTypesForm = new FormData($('#operators')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/admin/operators_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: raidsTypesForm,
			success: function(response) {
				if (response) notify('Список операторов обновлен!');
				else notify('Ошибка сохранения операторов!', 'error');
				$('#operatorsBlock').find('.list_item').removeClass('changed');
				renderSection();
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
		
	});
	
	
	
	
	$('body').off(tapEvent, '.set_operators_statics').on(tapEvent, '.set_operators_statics', function() {
		var thisOperetorBlock = $(this).closest('.list_item'),
			hasStatics = JSON.parse($(thisOperetorBlock).find('.choosen_statics').val() || '[]');
		
		popUp({
			title: 'Доступ к статикам',
		    width: 500,
		    html: '<div id="operatorsStatics"></div>',
		    buttons: [{id: 'setOperatorsStatics', title: 'Применить'}],
		    closeButton: 'Отмена',
		}, function(operStatWin) {
			operStatWin.wait();
			
			getAjaxHtml('admin/get_operator_statics', {has_statics: hasStatics}, function(html) {
				$('#operatorsStatics').html(html);
			}, function() {
				operStatWin.wait(false);
			});
			
			$('#setOperatorsStatics').on(tapEvent, function() {
				var checkedStatics = [];
				$('#operatorsStatics').find('input[type="checkbox"]:checked').each(function() {
					checkedStatics.push($(this).attr('id'));
				});
				
				$(thisOperetorBlock).find('.choosen_statics').val(JSON.stringify(checkedStatics) || '[]');
				
				operStatWin.close();
				$(thisOperetorBlock).addClass('changed');
			});
		});
	});
	
	
	
	
	
	
	
	$('body').off(tapEvent, '.set_operators_access').on(tapEvent, '.set_operators_access', function() {
		var thisOperetorBlock = $(this).closest('.list_item'),
			hasAccess = JSON.parse($(thisOperetorBlock).find('.choosen_access').val() || '[]');
		
		popUp({
			title: 'Настройки доступа',
		    width: 500,
		    html: '<div id="operatorsAccess"></div>',
		    buttons: [{id: 'setOperatorsAccess', title: 'Применить'}],
		    closeButton: 'Отмена',
		}, function(operAccessWin) {
			operAccessWin.wait();
			
			getAjaxHtml('admin/get_operator_access', {has_access: hasAccess}, function(html) {
				$('#operatorsAccess').html(html);
			}, function() {
				operAccessWin.wait(false);
			});
			
			
			$('#setOperatorsAccess').on(tapEvent, function() {
				var checkedAccess = [];
				$('#operatorsAccess').find('input[type="checkbox"]:checked').each(function() {
					checkedAccess.push($(this).attr('id'));
				});
				
				$(thisOperetorBlock).find('.choosen_access').val(JSON.stringify(checkedAccess) || '[]');
				
				operAccessWin.close();
				$(thisOperetorBlock).addClass('changed');
			});
		});
	});
	
	
	
	
	
	
	var index,
		hourssheetWin,
		hSData
	$('body').off(tapEvent, '[addhourssheet]').on(tapEvent, '[addhourssheet]', function() {
		hSData = $(this).attr('addhourssheet').split('|');
		index = 0;
		
		popUp({
			title: 'Расписание работы оператора',
		    width: 400,
		    html: '<div id="addHourssheetBlock"></div>',
		    buttons: [{id: 'saveOpertarorHourssheet', title: 'Сохранить'}],
		    closeButton: 'Закрыть',
		}, function(hsWin) {
			hourssheetWin = hsWin;
			hourssheetWin.wait();
			getAjaxHtml('admin/get_operator_hourssheet', {operator_id: hSData[0], date: hSData[1]}, function(html) {
				$('#addHourssheetBlock').html(html);
				if ($('body').find('#hourssheetDataTable tbody tr').length > 1) {
					$('#addHourssheetBlock').find('#cloneHourssheetDate').addClass('visible');
				}
			}, function() {
				hourssheetWin.wait(false);
			});
		});
	});
	
	
	
	
	$('body').off(tapEvent, '[newhourssheet]').on(tapEvent, '[newhourssheet]', function() {
		hourssheetWin.wait();
		getAjaxHtml('admin/operators_hourssheet_add', {index: index++}, function(html) {
			$('#hourssheetDataTable').find('tbody tr:last').before(html);
			$('#cloneHourssheetDate').addClass('visible');
		}, function() {
			hourssheetWin.wait(false);
		});
	});
	
	
	$('body').off(tapEvent, '[deletehourssheet]').on(tapEvent, '[deletehourssheet]', function() {
		var thisItem = this,
			thisId = $(thisItem).attr('deletehourssheet');
			
		if (!thisId) {
			$(thisItem).closest('tr').remove();
		} else {
			$.post('/admin/operators_hourssheet_delete', {id: thisId}, function(response) {
				if (response) {
					$(thisItem).closest('tr').remove();
					renderSection();
					
					if ($('body').find('#hourssheetDataTable tbody tr').length == 2) {
						$('#addHourssheetBlock').find('#cloneHourssheetDate').removeClass('visible');
					}
				} else {
					notify('Ошибка удаления!', 'error');
				}
			}, 'json').always(function() {
			}).fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		}
	});
	
	
	
	
	
	$('body').off(tapEvent, '[clonehourssheetdate]:not([disabled])').on(tapEvent, '[clonehourssheetdate]:not([disabled])', function() {
		var thisItem = this;
		if ($(thisItem).hasClass('checked')) {
			$(thisItem).removeClass('checked');
		} else {
			$(thisItem).addClass('checked');
		}
	});
	
	
	
	
	
	
	$('body').off(tapEvent, '#saveOpertarorHourssheet').on(tapEvent, '#saveOpertarorHourssheet', function() {
		
		if ($('#hourssheetDataTable tbody tr').length == 1) {
			notify('необходимо задать приемные часы!', 'error');
			return true;
		}
		
		
		
		
		hourssheetWin.wait();
		var f = new FormData($('#operatorsHourssheetForm')[0]);
			f.append('operator_id', hSData[0]);
			f.append('date', hSData[1]);
		
		$('#cloneHourssheetDate tbody').find('td.checked:not([desabled])').each(function() {
			var thisDate = $(this).attr('clonehourssheetdate');
			f.append('clone_dates[]', thisDate);
		});
		
		$.ajax({
			type: 'POST',
			url: '/admin/operators_hourssheet_save',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: f,
			success: function(response) {
				if (response) {
					hourssheetWin.close();
					renderSection();
				}
			},
			error: function(e, status) {
				notify('Системная ошибка отправки данных!', 'error');
				showError(e);
			},
			complete: function() {
				hourssheetWin.wait(false);
			}
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('#operatorsBlock').on('keydown', 'input', function() {
		var thisBlock = $(this).closest('.list_item');
		$(thisBlock).addClass('changed');
	});
	
	
	
	
});
//--></script>