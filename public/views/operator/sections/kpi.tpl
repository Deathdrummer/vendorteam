<div class="section" id="kpi">
	<div class="section__title">
		<h1>KPI планы</h1>
	</div>
	
	<div class="section__buttons d-flex justify-content-between" id="sectionButtons">
		<div class="">
			<button id="kpiPeriodsButton" title="Новый KPI период"><i class="fa fa-list-alt"></i></button>
			<button id="kpiFormButton" title="Заполнить KPI план"><i class="fa fa-vcard-o"></i></button>
			<button id="kpiCheckPlanButton" title="Отметить достижения KPI плана"><i class="fa fa-check-square-o"></i></button>
			
			<button id="kpiReportsButton" class="alt" title="Сохраненные отчеты"><i class="fa fa-list"></i></button>
			<button id="kpiStatisticsButton" class="alt" title="Статистика выполнения задач"><i class="fa fa-bar-chart-o"></i></button>
			<button id="kpiStatisticsSaveButton" disabled class="alt" title="Сохранить статистику"><i class="fa fa-save"></i></button>
		</div>
		
		
		<div class="mr-auto ml-3"><h3 id="kpiDataTitle"></h3></div>
		
		
		
		<div class="ml-auto" hidden id="kpiSearchBlock">
			<div class="d-flex align-items-center">
				<div class="field w300px mr5px">
					<input type="text" autocomplete="off" id="kpiSearchString" placeholder="Введите никнейм...">
				</div>
				<div class="buttons inline notop minspace">
					<button title="Поиск по участникам" id="kpiSearchButton"><i class="fa fa-search"></i></button>
					<button class="remove" title="Очистить поиск" id="kpiResetSearchButton"><i class="fa fa-eraser"></i></button>
				</div>
			</div>
		</div>
		
		<div class="ml-auto" hidden id="kpiProgressSearchBlock">
			<div class="d-flex align-items-center">
				<div class="field w300px mr5px">
					<input type="text" autocomplete="off" id="kpiProgressSearchString" placeholder="Введите никнейм...">
				</div>
				<div class="buttons inline notop minspace">
					<button title="Поиск по участникам" id="kpiProgressSearchButton"><i class="fa fa-search"></i></button>
					<button class="remove" title="Очистить поиск" id="kpiProgressResetSearchButton"><i class="fa fa-eraser"></i></button>
				</div>
			</div>
		</div>
		
		
		
		
		<div>
			<button id="kpiPersonagesTemplatesButton" class="alt2 ml-5" title="Шаблоны задач для персонажей"><i class="fa fa-newspaper-o"></i></button>
			<button id="kpiPersonagesTasksButton" class="alt2" title="Задачи для персонажей"><i class="fa fa-users"></i></button>
			<button id="kpiCustomTasksButton" class="alt" title="Задачи для кастомных полей"><i class="fa fa-tasks"></i></button>
			<button id="kpiAmountsButton" class="pay" title="Задать суммы выплат"><i class="fa fa-money"></i></button>
		</div>
	</div>
	
	
	<div class="section__content" id="sectionContent">
		<div id="kpiDataContainer" class="reports"></div>
	</div>
</div>







<script type="text/javascript"><!--
	//------------------------------------------------------- Создать новый KPI период
	$('#kpiPeriodsButton').on(tapEvent, function() {
		popUp({
			title: 'Новый KPI период',
		    width: 1100,
		    buttons: [{id : 'saveKpiPeriodButton', title: 'Создать'}],
		    closeButton: 'Закрыть',
		    closeByButton: true
		}, function(kpiPeriodsWin) {
			kpiPeriodsWin.setData('kpi/periods/new', function() {
				datePicker('#newKpiPeriodDateStart', '#newKpiPeriodDateEnd');
				$('#kpiPeriodsList').ddrScrollTableY({height: '64vh', wrapBorderColor: '#d7dbde'});
				$('#kpiStaticsList').ddrScrollTableY({height: '64vh', wrapBorderColor: '#d7dbde'});
				const srcTableFields = $('#kpiFieldsList').ddrScrollTableY({height: '64vh', offset: 1});
				
				let checkAllStatics = false;
				$('[newkpiperiodcheckallstatics]').on(tapEvent, function() {
					$('#newKpiPeriodStatics').find('input[type="checkbox"]').each(function() {
						if (!checkAllStatics) $(this).setAttrib('checked');
						else $(this).removeAttrib('checked');
					});
					checkAllStatics = !checkAllStatics;
				});
				
				
				$('#newKpiPeriodAddField').on(tapEvent, function() {
					getAjaxHtml('kpi/periods/add_custom_field', function(html) {
						$('#newKpiPeriodCustomFields').append(html);
						srcTableFields.reInit();
					});
				});
				
				$('#newKpiPeriodCustomFields').on(tapEvent, '[newkpiperiodremovefield]', function() {
					$(this).closest('tr').remove();
					srcTableFields.reInit();
				});
				
				$('#newKpiPeriodCustomFields').changeInputs(function(item) {
					$(item).closest('tr.error').removeClass('error');
				});
				
				
				let isCheckedCustomTasks = false;
				$('#kpiFieldsCustomTasks').on(tapEvent, function() {
					isCheckedCustomTasks = $(this).is(':checked');
					if (isCheckedCustomTasks) {
						$('#kpiCustomFieldsListContainer').removeAttrib('hidden');
					} else {
						$('#kpiCustomFieldsListContainer').setAttrib('hidden');
					}
				});
				
				
				$('#saveKpiPeriodButton').on(tapEvent, function() {
					let newKpiPeriodTitle = $('#newKpiPeriodTitle'),
						newKpiPeriodPayoutType = $('#newKpiPeriodPayoutType'),
						newKpiPeriodDateStart = $('#newKpiPeriodDateStart'),
						newKpiPeriodDateEnd = $('#newKpiPeriodDateEnd'),
						reportPeriodId = $('[name="reportperiodforkpi"]:checked'),
						statics = $('[newkpiperiodstatic]:checked'),
						fields = $('#newKpiPeriodFields').find('[newkpiperiodfield]:checked'),
						customFields = $('#newKpiPeriodCustomFields').find('tr'),
						stat = true;
					
						
					let fieldsData = [], scores = {}, fSHasError = false;
					fields.each(function() {
						let scoreInp = $(this).closest('tr').find('[newkpiperiodfieldscore]'),
							scrore = parseInt($(scoreInp).val());
						
						if (!scrore) {
							$(scoreInp).errorLabel('');
							fSHasError = true;
							return true;
						}
						
						fieldsData.push($(this).val());
						scores[$(this).val()] = scrore;
					});
					
					let customFieldsData = []; cFHasError = false;
					customFields.each(function() {
						let thisBlock = this,
							customTaskId = $(thisBlock).find('[newkpicustomfieldtask]').val(),
							rand = random(0, 9999);
						
						if (!customTaskId) {
							$(thisBlock).addClass('error');
							cFHasError = true;
							return true;
						}
						
						customFieldsData.push({
							name: 'custom_field_'+rand,
							custom_task_id: parseInt(customTaskId)
						});
					});
					
					
					if (fSHasError) {
						notify('Ошибка! Некорректно заполнены значения кастомных полей!', 'error');
						stat = false;
					}
					
					if (cFHasError) {
						notify('Ошибка! Некорректно заполнены значения кастомных полей!', 'error');
						stat = false;
					}
					
					if (newKpiPeriodTitle.val() == '') {
						$(newKpiPeriodTitle).addClass('error');
						notify('Ошибка! Необходимо ввести название периода!', 'error');
						stat = false;
					}
					
					if (newKpiPeriodPayoutType.val() == null) {
						$(newKpiPeriodPayoutType).addClass('error');
						notify('Ошибка! Необходимо указать тип выплаты!', 'error');
						stat = false;
					}
					
					if (newKpiPeriodDateStart.hasAttrib('date') == false) {
						$(newKpiPeriodDateStart).addClass('error');
						notify('Ошибка! Необходимо выбрать начальную дату!', 'error');
						stat = false;
					}
					
					if (newKpiPeriodDateEnd.hasAttrib('date') == false) {
						$(newKpiPeriodDateEnd).addClass('error');
						notify('Ошибка! Необходимо выбрать конечную дату!', 'error');
						stat = false;
					}
					
					if (reportPeriodId.length == 0) {
						notify('Ошибка! Необходимо выбрать платежный период!', 'error');
						stat = false;
					}
					
					if (statics.length == 0) {
						notify('Ошибка! Необходимо как минимум один статик!', 'error');
						stat = false;
					}
					
					if (fields.length == 0 && customFields.length == 0) {
						notify('Ошибка! Необходимо выбрать хотябы одно поле!', 'error');
						stat = false;
					}
					
					
					if (stat) {
						kpiPeriodsWin.dialog('<p class="green">Создать KPI период?</p>', 'Создать', 'Отмена', function() {
							kpiPeriodsWin.wait();
							
							let choosedStatics = [];
							statics.each(function() {
								choosedStatics.push(parseInt($(this).val()));
							});
							
							let params = {
								title: newKpiPeriodTitle.val(),
								payout_type: newKpiPeriodPayoutType.val(),
								date_start: newKpiPeriodDateStart.attr('date'),
								date_end: newKpiPeriodDateEnd.attr('date'),
								report_period: parseInt(reportPeriodId.val()),
								statics: choosedStatics,
								fields: fieldsData,
								custom_fields: customFieldsData,
								scores: scores
							};
							
							$.post('/kpi/periods/add', params, function(response) {
								if (response) {
									notify('Период успешно добавлен!');
									kpiPeriodsWin.close();
								} else {
									notify('Ошибка добавления периода!', 'error');
								}
								kpiPeriodsWin.wait(false);
							}, 'json').fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						});	
					}
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Задачи для персонажей
	$('#kpiPersonagesTasksButton').on(tapEvent, function() {
		popUp({
			title: 'Задачи для персонажей',
		    width: 700,
		    buttons: [{id: 'addTask', title: 'Добавить задачу'}],
		    closeButton: 'Закрыть',
		}, function(kpiPersonagesTasksWin) {
			kpiPersonagesTasksWin.setData('kpi/tasks/init', function() {
				$('#personagesTasksList').ddrCRUD({
					addSelector: '#addTask', // селектор для добавления новой записи
					onInit: function(countRows) {
						$('#personagesTasksList').closest('table').ddrScrollTableY({height: '70vh', wrapBorderColor: '#d7dbde'});
					},
					emptyList: '<tr><td colspan="3"><p class="empty">Нет данных</p></td></tr>',
					functions: 'kpi/tasks', // PHP функции, например: account/personages/[get,add,save,update,remove]
					removeConfirm: true,
					popup: kpiPersonagesTasksWin
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Шалоны задач для персонажей
	$('#kpiPersonagesTemplatesButton').on(tapEvent, function() {
		let operatorId = getCookie('operator_id');
		popUp({
			title: 'Шаблоны задач для персонажей|4',
		    width: 500,
		    buttons: [{id: 'kpiPersonagesTemplateNewBtn', title: 'Новый шаблон'}],
		    closePos: 'left',
		    closeByButton: false,
		    disabledButtons: true,
		    closeButton: 'Закрыть'
		}, function(kpiPersonagesTemplatesWin) {
			(function openTemplatesWin() {
				kpiPersonagesTemplatesWin.setData('kpi/templates/list', {from: operatorId}, function() {
					kpiPersonagesTemplatesWin.setWidth(500);
					kpiPersonagesTemplatesWin.setButtons([{id: 'kpiPersonagesTemplateNewBtn', title: 'Новый шаблон'}], 'Закрыть');
					kpiPersonagesTemplatesWin.setTitle('Шаблоны задач для персонажей|4');
					kpiPersonagesTemplatesWin.enabledButtons();
					
					
					// Активировать шаблон
					$('[kpitemplatesactivate]').on('change', function() {
						let id = $(this).attr('kpitemplatesactivate');
						
						$.post('/kpi/templates/activate', {id: id, from: operatorId}, function(response) {
							if (response) {
								notify('Шаблон активирован!');
							} else {
								notify('Ошибка активации шаблона!', 'error');
							}
						}).fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
						});
					});
					
					
					
					// Редактировать шаблон
					$('[kpiedittemplate]').on(tapEvent, function() {
						let id = $(this).attr('kpiedittemplate');
						kpiPersonagesTemplatesWin.setWidth(900);
						kpiPersonagesTemplatesWin.setTitle('Редактировать шаблон|4');
						kpiPersonagesTemplatesWin.setData('kpi/templates/form', {id: id}, function() {
							kpiPersonagesTemplatesWin.setButtons([{id: 'kpiPersonagesTemplateBackBtn', title: 'Назад', type: 'close'}, {id: 'kpiPersonagesTemplatesUpdateBtn', title: 'Обновить шаблон'}]);
							$('#kpiPersonagesTemplateBackBtn').on(tapEvent, function() {openTemplatesWin();});
							
							$('#kpiPersonagesTemplatesUpdateBtn').on(tapEvent, function() {
								let title = $('#kpiFormTemplateTitle').val(), 
									templateTasksData = [];
								$('#kpiFormTemplateTasks').find('[kpitaskitemtask]:checked').each(function() {
									let taskId = $(this).val(),
										repeats= $(this).closest('[kpitasksgriditem]').find('[kpitaskitemtaskrepeats]').val();
									templateTasksData.push({
										task_id: parseInt(taskId),
										repeats: parseInt(repeats),
									});
								});
								
								if (title && templateTasksData.length) {
									kpiPersonagesTemplatesWin.wait();
									$.post('/kpi/templates/update', {id: id, title: title, tasks: templateTasksData}, function(response) {
										if (response) {
											notify('Шаблон успешно обновлен!');
											kpiPersonagesTemplatesWin.close();
										} else {
											notify('Ошибка обновления шаблона!', 'error');
											kpiPersonagesTemplatesWin.wait(false);
										}
									}).fail(function(e) {
										showError(e);
										notify('Системная ошибка!', 'error');
										kpiPersonagesTemplatesWin.wait(false);
									});
								} else {
									if (title == '') {
										$('#kpiFormTemplateTitle').addClass('error');
										notify('Ошибка заполнения формы!', 'error');
									}
									
									if (templateTasksData.length == 0) {
										notify('Ошибка заполнения формы! Необходимо выбрать хотя бы одну задачу!', 'error');
									}
								}
							});
						});
					});
					
					
					
					// Удалить шаблон
					$('[kpiremovetemplate]').on(tapEvent, function() {
						let id = $(this).attr('kpiremovetemplate');
						kpiPersonagesTemplatesWin.dialog('<p class="fz16px info">Вы действительно хотите удалить шаблон?</p>', 'Удалить', 'Отмена', function() {
							$.post('/kpi/templates/remove', {id: id}, function(response) {
								if (response) {
									notify('Шаблон удален!');
									kpiPersonagesTemplatesWin.close();
								} else {
									notify('Ошибка удаления шаблона!', 'error');
									kpiPersonagesTemplatesWin.wait(false);
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
								kpiPersonagesTemplatesWin.wait(false);
							});
						});
					});
					
					
					
					// Открыть форму для создания нового шаблона
					$('#kpiPersonagesTemplateNewBtn').on(tapEvent, function() {
						kpiPersonagesTemplatesWin.setWidth(900);
						kpiPersonagesTemplatesWin.setTitle('Создать шаблон|4');
						kpiPersonagesTemplatesWin.setData('kpi/templates/form', function() {
							kpiPersonagesTemplatesWin.setButtons([{id: 'kpiPersonagesTemplateBackBtn', title: 'Назад', type: 'close'}, {id: 'kpiPersonagesTemplatesAddBtn', title: 'Создать шаблон'}]);
							$('#kpiPersonagesTemplateBackBtn').on(tapEvent, function() {openTemplatesWin();});
							
							
							// Создать шаблон
							$('#kpiPersonagesTemplatesAddBtn').on(tapEvent, function() {
								let title = $('#kpiFormTemplateTitle').val(), 
									templateTasksData = [];
								$('#kpiFormTemplateTasks').find('[kpitaskitemtask]:checked').each(function() {
									let taskId = $(this).val(),
										repeats= $(this).closest('[kpitasksgriditem]').find('[kpitaskitemtaskrepeats]').val();
									templateTasksData.push({
										task_id: parseInt(taskId),
										repeats: parseInt(repeats),
									});
								});
								
								if (title && templateTasksData.length) {
									kpiPersonagesTemplatesWin.wait();
									$.post('/kpi/templates/save', {title: title, tasks: templateTasksData}, function(response) {
										if (response) {
											notify('Шаблон успешно сохранен!');
											kpiPersonagesTemplatesWin.close();
										} else {
											notify('Ошибка сохранения шаблона!', 'error');
											kpiPersonagesTemplatesWin.wait(false);
										}
									}).fail(function(e) {
										showError(e);
										notify('Системная ошибка!', 'error');
										kpiPersonagesTemplatesWin.wait(false);
									});
								} else {
									if (title == '') {
										$('#kpiFormTemplateTitle').addClass('error');
										notify('Ошибка заполнения формы!', 'error');
									}
									
									if (templateTasksData.length == 0) {
										notify('Ошибка заполнения формы! Необходимо выбрать хотя бы одну задачу!', 'error');
									}
								}
							});
							
							
							
						});
					});
				});
			})();
		});
	
			
	});
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Задачи для кастомных полей
	$('#kpiCustomTasksButton').on(tapEvent, function() {
		popUp({
			title: 'Задачи для кастомных полей',
		    width: 700,
		    buttons: [{id: 'addCustomTask', title: 'Добавить задачу'}],
		    closeButton: 'Закрыть',
		}, function(kpiCustomTasksWin) {
			kpiCustomTasksWin.setData('kpi/customtasks/init', function() {
				$('#customTasksList').ddrCRUD({
					addSelector: '#addCustomTask', // селектор для добавления новой записи
					onInit: function(countRows) {
						$('#customTasksList').closest('table').ddrScrollTableY({height: '70vh', wrapBorderColor: '#d7dbde'});
					},
					emptyList: '<tr><td colspan="4"><p class="empty">Нет данных</p></td></tr>',
					functions: 'kpi/customtasks', // PHP функции, например: account/personages/[get,add,save,update,remove]
					removeConfirm: true,
					popup: kpiCustomTasksWin
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Открыть список KPI периодов \ Заполнить KPI план
	$('#kpiFormButton').on(tapEvent, function() {
		popUp({
			title: 'Заполнить KPI план',
		    width: 1000,
		    height: false,
		    html: '',
		    wrapToClose: true,
		    winClass: false,
		    buttons: false,
		    closeButton: 'Закрыть',
		}, function(kpiFormWin) {
			kpiFormWin.setData('kpi/periods/get', function(foo, bar) {
				$('#kpiPeriodsList').ddrScrollTableY({height: '70vh', wrapBorderColor: '#d7dbde'});
				
				// Активировать KPI период
				$('[activatekpiperiod]').on('change', function() {
					if ($(this).is(':checked') == false) return false;
					let periodId = $(this).attr('activatekpiperiod'),
						stat = $(this).is(':checked');
						
					$.post('/kpi/periods/activate_period', {period_id: periodId, stat: stat}, function(response) {
						if (response) {
							notify('Период успешно активирован!');
							/*if (stat) {
								notify('Период успешно активирован!');
							} else {
								notify('Период успешно деактивирован!');
							}*/
						} else {
							notify('Ошибка изменения статуса активации периода!', 'error');
						}
					}, 'json').fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				});
				
				
				
				// Опубликовать KPI период
				$('[publishkpiperiod]').on('change', function() {
					if ($(this).is(':checked') == false) return false;
					let periodId = $(this).attr('publishkpiperiod'),
						stat = $(this).is(':checked');
						
					$.post('/kpi/periods/publish_period', {period_id: periodId, stat: stat}, function(response) {
						if (response) {
							notify('Период успешно опубликован!');
							/*if (stat) {
								notify('Период успешно активирован!');
							} else {
								notify('Период успешно деактивирован!');
							}*/
						} else {
							notify('Ошибка публикации периода!', 'error');
						}
					}, 'json').fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				});
				
				
				
				
				
				$('[kpiopenform]').on(tapEvent, function() {
					$('#kpiSearchString').val('');
					$('#kpiSearchButton, #kpiResetSearchButton').off(tapEvent);
					
					kpiFormWin.wait();
					let periodTitle = $(this).closest('tr').find('[periodtitle]').text(),
						periodId = $(this).attr('kpiopenform');
					
					location.hash = 'kpi';
					
					openForm(periodId, periodTitle);
					
					$('#kpiSearchButton').on(tapEvent, function() {
						let searchString = $('#kpiSearchString').val();
						if (searchString) openForm(periodId, periodTitle, searchString);
						else $('#kpiSearchString').errorLabel('Необходимо ввести как минимум 1 символ!');
					});
					
					$('#kpiResetSearchButton').on(tapEvent, function() {
						$('#kpiSearchString').val('');
						openForm(periodId, periodTitle);
					});
					
				});
				
				
				
				
				
				
				
				$('[kpiremoveperiod]').on(tapEvent, function() {
					let kpiPeriodId = $(this).attr('kpiremoveperiod'),
						thisRow = $(this).closest('tr');
					kpiFormWin.dialog('Удалить KPI период?', 'Удалить', 'Отмена', function() {
						$.post('/kpi/periods/remove_period', {period_id: kpiPeriodId}, function(response) {
							if (response) {
								notify('KPI период успешно удален!');
								$(thisRow).remove();
								kpiFormWin.dialog(false);
							} else {
								notify('ошибка удаления KPI периода!', 'error');
							}
						});
					});
				});
				
				
				
				
				
				
				
				function openForm(periodId, periodTitle, search) {
					getAjaxHtml('kpi/plan/get_form', {period_id: periodId, search: search}, function(html) {
						$('#kpiDataContainer').html(html);
						$('#kpiStatisticsSaveButton').setAttrib('disabled');
						$('#kpiDataTitle').text('KPI план: '+periodTitle);
						ddrInitTabs('kpiDataContainer');
						
						$('#kpiProgressSearchBlock').setAttrib('hidden');
						$('#kpiSearchBlock').removeAttrib('hidden');
						
						$('[personagestaskstable]').ddrHorizontalScroll({
							ignoreSelectors: 'button',
							mouseWheelScrollStep: 50
						});
						
						
						$('[userspersonagesform]').ready(function() {
							let cellsWidth = 0;
							$('[userspersonagesform]:first').find('[kpifieldcell]').each(function() {
								let w = $(this).outerWidth();
								cellsWidth += w;
							});
							$('[userspersonagesform]').find('.kpitasksblock').width('calc(100vw - '+(cellsWidth+364)+'px)');
						});
						
						$('[userspersonagesform]').each(function() {
							$(this).ddrScrollTableY({height: 'calc(100vh - 230px)', wrapBorderColor: '#d7dbde'});
						})
						kpiFormWin.close();
						
						let setParamTOut;
						$('[kpiformparam]').onChangeNumberInput(function(value, thisInput, type) {
							let d = $(thisInput).attr('kpiformparam').split('|');
							
							$(thisInput).parent().removeClass('kpiparamsfield__error kpiparamsfield__changed');
							
							function _saveParam() {
								$(thisInput).parent().addClass('kpiparamsfield__saved');
								$.post('/kpi/plan/save_param', {period_id: periodId, user_id: d[1], param: d[0], value: value}, function(response) {
									if (response) {
										$(thisInput).parent().addClass('kpiparamsfield__changed');
									} else {
										$(thisInput).parent().addClass('kpiparamsfield__error');
										notify('Ошибка сохранения параметра!', 'error');
									}
									$(thisInput).parent().removeClass('kpiparamsfield__saved');
								}, 'json').fail(function(e) {
									showError(e);
									notify('Системная ошибка!', 'error');
								});
							}
							
							if (type == 'key') {
								//clearTimeout(setParamTOut);
								setParamTOut = setTimeout(function() {
									_saveParam();
								}, 300);
							} else {
								clearTimeout(setParamTOut);
								setParamTOut = setTimeout(function() {
									_saveParam();
								}, 300);
							}	
						});
						
						
						
						$('[kpiformcustomparam]').on('change', function() {
							if (this.type != 'checkbox') return false;
							let d = $(this).attr('kpiformcustomparam').split('|'),
								isChecked 	= $(this).is(':checked'),
								fieldName 	= d[0],
								userId 		= d[1];
							
							$.post('/kpi/plan/save_custom_param', {period_id: periodId, user_id: userId, field: fieldName, value: isChecked}, function(response) {
								if (!response) tify('Ошибка сохранения параметра!', 'error');
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						});
						
						
						
						let setCustomParamTOut;
						$('[kpiformcustomparam]').onChangeNumberInput(function(value, thisInput, type) {
							if (thisInput.type == 'checkbox') return false;
							let d = $(thisInput).attr('kpiformcustomparam').split('|'),
								fieldName	= d[0],
								userId 		= d[1];
							
							$(thisInput).parent().removeClass('kpiparamsfield__error kpiparamsfield__changed');
							
							
							function _saveCustomParam() {
								$(thisInput).parent().addClass('kpiparamsfield__saved');
								$.post('/kpi/plan/save_custom_param', {period_id: periodId, user_id: userId, field: fieldName, value: value}, function(response) {
									if (response) {
										$(thisInput).parent().addClass('kpiparamsfield__changed');
									} else {
										$(thisInput).parent().addClass('kpiparamsfield__error');
										notify('Ошибка сохранения параметра!', 'error');
									}
									$(thisInput).parent().removeClass('kpiparamsfield__saved');
								}).fail(function(e) {
									showError(e);
									notify('Системная ошибка!', 'error');
								});
							}
							
							if (type == 'key') {
								//clearTimeout(setCustomParamTOut);
								setCustomParamTOut = setTimeout(function() {
									_saveCustomParam();
								}, 300);
							} else {
								_saveCustomParam();
							}
						});
						
						
						
						
						//------------------------------------------------------- Задать задачи для персонажа
						$('[setpersonagetasks]').on(tapEvent, function() {
							let tasksListSelector = $(this).closest('[kpitasksitem]').find('[kpitaskslist]'),
								d = $(this).attr('setpersonagetasks').split('|'),
								nick = d[0],
								userId = d[1],
								personageId = d[2];
							
							popUp({
								title: 'Задачи персонажа '+nick+'|4',
								width: 900,
								buttons: [{id: 'setPersonageTasks', title: 'Задать'}],
								disabledButtons: true,
								closeButton: 'Закрыть'
							}, function(setPersonageTasksWin) {
								setPersonageTasksWin.setData('kpi/personages_tasks/get_form', {period_id: periodId, personage_id: personageId}, function() {
									setPersonageTasksWin.enabledButtons();
									ddrInitTabs('progressPlanPersonages');
									
									$('[kpitaskitemrepeats]').on('focus', function(e) {
										e.preventDefault();
									});
								});
								
								$('#setPersonageTasks').on(tapEvent, function() {
									setPersonageTasksWin.wait();
									let tasksData = [], tasksList = []; 
									$('#kpiTasksItemms').find('[kpitaskitemtask]:checked').each(function() {
										let task = $(this).siblings('label').find('[kpitaskitemtasktext]').text(),
											taskId = parseInt($(this).val()),
											repeats = parseInt($(this).siblings('label').find('[kpitaskitemrepeats]').val()),
											type = $(this).siblings('label').find('[kpitaskitemtasktype]').val();
										
										tasksData.push({
											task_id: taskId,
											type: type,
											repeats: repeats
										});
										
										tasksList.push({
											task: task,
											type: type,
											repeats: repeats
										});
									});
									
									getAjaxHtml('kpi/personages_tasks/save_tasks', {period_id: periodId, user_id: userId, personage_id: personageId, tasks: tasksData, to_list: tasksList}, function(html, stat) {
										if (stat) {
											$(tasksListSelector).replaceWith(html);
											setPersonageTasksWin.close();
											notify('Задачи успешно сохранены!');
										} else {
											notify('Ошибка сохранения задач!', 'error');
											setPersonageTasksWin.wait(false);
										}
									}, function() {
										setPersonageTasksWin.wait(false);
									});
								});
							});
						});
						
						
						
						//------------------------------------------------------- Задать задачи для персонажа из шаблона
						$('[setpersonagetaskfromtemplates]').on(tapEvent, function() {
							let tasksListSelector = $(this).closest('[kpitasksitem]').find('[kpitaskslist]'),
								d = $(this).attr('setpersonagetaskfromtemplates').split('|'),
								userId = d[0],
								personageId = d[1],
								from = getCookie('operator_id');
							
							getAjaxHtml('kpi/personages_tasks/save_from_template', {from: from, period_id: periodId, user_id: userId, personage_id: personageId}, function(html, stat) {
								if (stat) {
									$(tasksListSelector).replaceWith(html);
									notify('Шаблон успешно применен!');
								} else {
									notify('Ошибка применения шаблона!', 'error');
								}
							}, function() {
								
							});
						});
						
					}, function() {
						kpiFormWin.wait(false);
					});
				}
				
				
				
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Отметить достижения KPI плана
	$('#kpiCheckPlanButton').on(tapEvent, function() {
		
		popUp({
			title: 'Отметить достижения KPI плана',
		    width: 800,
		    closeButton: 'Закрыть'
		}, function(progressPlanWin) {
			progressPlanWin.setData('kpi/periods/get', {type: 'simple', attr: 'kpichooseperiod'}, function() {
				$('[kpichooseperiod]').on(tapEvent, function() {
					progressPlanWin.wait();
					let periodId = $(this).attr('kpichooseperiod');
					location.hash = 'kpi';
					$('#kpiProgressSearchString').val('');
					
					$('#kpiDataContainer').setWaitToBlock('Загрузка плана...', 'pt40px pb40px', 'transparent');
					openProgressForm({period_id: periodId}, function() {
						progressPlanWin.close();
					});
				});
			});
		});		
	});
	
	$('#kpiProgressSearchButton').on(tapEvent, function() {
		let searchString = $('#kpiProgressSearchString').val();
		if (searchString) openProgressForm({search: searchString});
		else $('#kpiProgressSearchString').errorLabel('Необходимо ввести как минимум 1 символ!');
	});
	
	$('#kpiProgressResetSearchButton').on(tapEvent, function() {
		$('#kpiProgressSearchString').val('');
		openProgressForm();
	});

	function openProgressForm(params, callback) {
		getAjaxHtml('kpi/progressplan/get_form', (params || {}), function(html, stat) {
			if (stat) {
				$('#kpiDataContainer').html(html);
				if (callback && typeof callback == 'function') callback();
				ddrInitTabs('kpiDataContainer');
				$('.kpiprocessblock:visible').ddrUnitHeight('.kpiprocesscard');
				
				$(document).on('changetabs', function() {
					setTimeout(function() {
						$('.kpiprocessblock:visible').ddrUnitHeight('.kpiprocesscard');
					}, 1000);
				});
				
				$('#kpiSearchBlock').setAttrib('hidden');
				$('#kpiProgressSearchBlock').removeAttrib('hidden');
				$('#kpiStatisticsSaveButton').setAttrib('disabled');
				
				$('[tasksprogresschangebutton]').on(tapEvent, function() {
					changePersonagesProgressValue(this, 'button');
				});
				$('[personagescounterblockvalue]').on('keyup', function() {
					changePersonagesProgressValue(this, 'key');
				});
				
				let saveProgPersTOut;
				function changePersonagesProgressValue(thisItem, type) {
					clearTimeout(saveProgPersTOut);
					let dir = type == 'button' ? $(thisItem).attr('tasksprogresschangebutton') : false,
						blockSelector = $(thisItem).closest('.personagetasks__item'),
						selector = $(thisItem).closest('.counterblock').find('[tasksprogressdata]'),
						needValue = parseInt($(thisItem).closest('[ptasksitem]').find('[personagetasksneed]').attr('personagetasksneed')),
						d = $(selector).attr('tasksprogressdata').split('|'),
						userId = d[0],
						personageId = d[1],
						taskId = d[2],
						taskType = d[3],
						value = parseInt($(selector).text()) || 0;
					
					
					if (value == 0 && dir == '-') return false;
					if (dir == '+') value += 1;
					else if (dir == '-') value -= 1;
					$(selector).text(value);
					
					if (value == needValue) $(blockSelector).removeClass('personagetasks__item_verydone').addClass('personagetasks__item_done');
					else if (value > needValue) $(blockSelector).removeClass('personagetasks__item_done').addClass('personagetasks__item_verydone');
					else $(blockSelector).removeClass('personagetasks__item_done personagetasks__item_verydone');
					
					saveProgPersTOut = setTimeout(function() {
						$(blockSelector).addClass('personagetasks__item_wait');
						$.post('/kpi/progressplan/check_task', {period_id: params.period_id, user_id: userId, personage_id: personageId, task_id: taskId, type: taskType, value: value}, function(response) {
							if (!response) notify('Ошибка сохранения параметра!', 'error');
							$(blockSelector).removeClass('personagetasks__item_wait');
						}, 'json').fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
							$(blockSelector).removeClass('personagetasks__item_wait');
						});
					}, 500);
				}
				
				
				
				
				$('[customprogresschangebutton]').on(tapEvent, function() {
					changeCustomProgressValue(this, 'button');
				});
				$('[customcounterblockvalue]').on('keyup', function() {
					changeCustomProgressValue(this, 'key');
				});
				
				let saveProgCostomTOut;
				function changeCustomProgressValue(thisItem, type) {
					clearTimeout(saveProgCostomTOut);
					let dir = type == 'button' ? $(thisItem).attr('customprogresschangebutton') : false,
						blockSelector = $(thisItem).closest('.customtasks__item'),
						selector = $(thisItem).closest('.counterblock').find('[customprogressdata]'),
						needValue = parseInt($(thisItem).closest('[ctasksitem]').find('[customtasksneed]').attr('customtasksneed')),
						d = $(selector).attr('customprogressdata').split('|'),
						userId = d[0],
						field = d[1]
						value = parseInt($(selector).text()) || 0;
					
					if (value == 0 && dir == '-') return false;
					if (dir == '+') value += 1;
					else if (dir == '-') value -= 1;
					$(selector).text(value);
					
					if (value == needValue) $(blockSelector).removeClass('customtasks__item_verydone').addClass('customtasks__item_done');
					else if (value > needValue) $(blockSelector).removeClass('customtasks__item_done').addClass('customtasks__item_verydone');
					else $(blockSelector).removeClass('customtasks__item_done customtasks__item_verydone');
					
					saveProgCostomTOut = setTimeout(function() {
						$(blockSelector).addClass('customtasks__item_wait');
						$.post('/kpi/progressplan/check_custom', {period_id: params.period_id, user_id: userId, field: field, value: value}, function(response) {
							if (!response) notify('Ошибка сохранения параметра!', 'error');
							$(blockSelector).removeClass('customtasks__item_wait');
						}, 'json').fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
							$(blockSelector).removeClass('customtasks__item_wait');
						});
					}, 500);
				}
				
				
				
				
				$('[customprogresschangecheck]').on('change', function() {
					let selector = this,
						d = $(selector).attr('customprogresschangecheck').split('|'),
						blockSelector = $(selector).closest('.customtasks__item'),
						userId = d[0],
						field = d[1]
						value = $(selector).is(':checked') ? 1 : 0;
					
					if (value) $(blockSelector).addClass('customtasks__item_done');
					else $(blockSelector).removeClass('customtasks__item_done');
					
					$(blockSelector).addClass('customtasks__item_wait');
					$.post('/kpi/progressplan/check_custom', {period_id: params.period_id, user_id: userId, field: field, value: value}, function(response) {
						if (!response) {
							notify('Ошибка сохранения параметра!', 'error');
						}
						$(blockSelector).removeClass('customtasks__item_wait');
					}, 'json').fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
						$(blockSelector).removeClass('customtasks__item_wait');
					});
				});
				
				
				//---------------------------------------------- временная копка для удаления несуществующего персонажа
				$('[kpiremovedeletedpersonage]').on(tapEvent, function() {
					let personageId = $(this).attr('kpiremovedeletedpersonage'),
						personageBlock = $(this).closest('.personagetasks');
					$.post('/kpi/progressplan/remove_personage', {personage_id: personageId}, function(response) {
						if (response) {
							notify('Перонаж успешно удален из KPI!');
							$(personageBlock).remove();
						} else {
							notify('Ошибка удаления пермонажа!', 'error');
						}
					}).fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
						$(blockSelector).removeClass('customtasks__item_wait');
					});
				});
				
				
			} else {
				$('#kpiDataContainer').html('');
				$('#kpiDataContainer').setWaitToBlock(false);
				notify('Нет данных!', 'info');
			}
		}, function() {
			$('#kpiDataContainer').setWaitToBlock(false);
		});
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Суммы выплат по званиям и статикам
	$('#kpiAmountsButton').on(tapEvent, function() {
		popUp({
			title: 'Суммы выплат по званиям и статикам',
		    width: 1100,
		    buttons: false,
		    buttonsAlign: 'right',
		    disabledButtons: false,
		    closePos: 'right',
		    closeByButton: false,
		    closeButton: false,
		    winClass: false,
		    contentToCenter: false,
		    buttonsOnTop: false,
		    topClose: true
		}, function(amountsWin) {
			amountsWin.setData('kpi/amounts/get_form', function() {
				$('#kpiAmountsForm').ddrScrollTableY({
					height: 'calc(100vh - 200px)',
					minHeight: '350px',
					wrapBorderColor: '#eee',
					offset: 1
				});
				$('#kpiAmountsForm').find('input[amountfield]').number(true, 2, '.', ' ');
				
				
				
				let changeAmountTOut;
				$('[amountfield]').onChangeNumberInput(function(value, input) {
					if (value < 0) {
						$(input).val('0');
						return false;
					} 
					
					clearTimeout(changeAmountTOut);
					let d = $(input).attr('amountfield').split('|'),
						staticId = d[0],
						rankId = d[1],
						payoutType = d[2];
					
					changeAmountTOut = setTimeout(function() {
						$.post('/kpi/amounts/set_amount', {static_id: staticId, rank_id: rankId, amount: value, payout_type: payoutType}, function(response) {
							if (response) {
								$(input).parent().addClass('kpiparamsfield__changed');
							} else {
								$(input).parent().removeClass('kpiparamsfield__changed').addClass('error');
							}
						}).fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					}, 300);	
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Статистика выполнения задач
	$('#kpiStatisticsButton').on(tapEvent, function() {
		location.hash = 'kpi';
		$('#kpiProgressSearchBlock').setAttrib('hidden');
		
		popUp({
			title: 'Вывести статистику',
		    width: 500,
		    buttons: [{id: 'calcKpiStat', title: 'Показать статистику', disabled: 1}],
		    closeButton: 'Закрыть'
		}, function(calcKpiStatWin) {
			calcKpiStatWin.setData('kpi/statistics/get_periods', function() {
				$('#kpiStatPeriods').find('[kpistatperiod]').on('change', function() {
					if ($('#kpiStatPeriods').find('[kpistatperiod]:checked').length) {
						$('#calcKpiStat').removeAttrib('disabled');
					} else {
						$('#calcKpiStat').setAttrib('disabled');
					}
				});
			});
			
			$('#calcKpiStat').on(tapEvent, function() {
				let choosedPeriods = [];
				$('#kpiStatPeriods').find('[kpistatperiod]:checked').each(function() {
					choosedPeriods.push(parseInt($(this).val()));
				});
				
				if (choosedPeriods) {
					calcKpiStatWin.wait();
					getAjaxHtml('kpi/statistics/calc_statistics', {periods: choosedPeriods}, function(html) {
						$('#kpiDataContainer').html(html);
						ddrInitTabs('kpiDataContainer');
						$('.scroll').ddrScrollTable();
						$('#kpiStatisticsSaveButton').removeAttrib('disabled');
						$('#kpiDataContainer').find('[payoutinput]').number(true, 2, '.', ' ');
						calcKpiStatWin.close();
					}, function() {
						calcKpiStatWin.wait(false);
					});
				}
			});
		});
	});
	
	
	
	
	
	$('#kpiStatisticsSaveButton').on(tapEvent, function() {
		popUp({
			title: 'Сохранить отчет',
		    width: 400,
		    html: '<strong>Название отчета</strong><div class="popup__field"><input type="text" id="reportTitle" autocomplete="off"></div>',
		    buttons: [{id: 'saveReport', title: 'Сохранить'}],
		    closeButton: 'Отмена'
		}, function(saveReportWin) {
			$('#saveReport').on(tapEvent, function() {
				saveReportWin.wait();
				let reportTitle = $('#reportTitle').val();
				if (reportTitle) {
					$('#kpiReport').formSubmit({
						url: 'kpi/statistics/save',
						fields: {title: reportTitle},
						success: function() {
							saveReportWin.close();
						},
						error: function() {
							saveReportWin.wait(false);
						}
					});
				} else {
					saveReportWin.wait(false);
					$('#reportTitle').errorLabel('Необходимо заполнить поле!');
				}
			});
		});	
	});
	
	
	
	
	
	
	
	
	
	$('#kpiReportsButton').on(tapEvent, function() {
		popUp({
			title: 'Сохраненные отчеты',
		    width: 400,
		    closeButton: 'Закрыть'
		}, function(kpiReportsWin) {
			kpiReportsWin.setData('kpi/statistics/get_reports_list', function() {
				$('[kpireport]').on(tapEvent, function() {
					kpiReportsWin.wait();
					location.hash = 'kpi';
					$('#kpiProgressSearchBlock').setAttrib('hidden');
					$('#kpiStatisticsSaveButton').setAttrib('disabled');
		
					let d = $(this).attr('kpireport').split('|'),
						reportId = d[0],
						periods = JSON.parse(d[1]);
						
					getAjaxHtml('kpi/statistics/get_report', {report_id: reportId, periods: periods}, function(html) {
						$('#kpiDataContainer').html(html);
						ddrInitTabs('kpiDataContainer');
						kpiReportsWin.close();
					}, function() {kpiReportsWin.wait(false);
						kpiReportsWin.wait(false);
					});
				});
			});
		});
	});
	
	
	
//--></script>