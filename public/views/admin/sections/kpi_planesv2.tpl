<div class="section" id="{{id}}">
	<div class="section_title h34px">
		<div class="d-flex mr-auto">
			<h2 class="mr3px">KPI планы</h2>
			<sup class="grayblue fz14px">версия 2</sup>
		</div>
		
		
		<div class="d-flex" hidden kpiv2toppanel="kpiv2_data">
			<div class="select w100px mr3px">
				<select id="kpiv2SearchField" class="fz12px h32px" disabled>
					<option disabled selected>Загрузка...</option>
				</select>
				<div class="select__caret"></div>
			</div>
			<div class="field w200px mr3px">
				<input type="text" id="kpiv2SearchStr" class="h32px" placeholder="Поиск..." autocomplete="off" disabled>
			</div>
			<div class="buttons notop mr40px">
				<button id="kpiv2SearchReset" class="remove" title="Сбросить" disabled><i class="fa fa-ban"></i></button>
			</div>
			
			
			
			
			<div class="usersv2showlists mr40px" plannerpanel id="plannerShowLists">
				<div class="usersv2showlists__item" title="Отобразить таблицей">
					<input type="radio" name="kpiv2ListType" id="kpiv2showDataTable" kpiv2datatype="table">
					<label for="kpiv2showDataTable"><i class="fa fa-table fz16px"></i></label>
				</div>
				
				<div class="usersv2showlists__item" title="Отобразить списком">
					<input type="radio" name="kpiv2ListType" id="kpiv2showDataList" kpiv2datatype="list">
					<label for="kpiv2showDataList"><i class="fa fa-list fz16px"></i></label>
				</div>
			</div>
			
			
			<div class="buttons notop">
				<button id="kpiv2ImportBtn" class="alt2" title="Загрузить данные"><i class="fa fa-upload"></i></button>
				<button id="kpiv2StruсtureBtn" title="Структура таблицы"><i class="fa fa-columns"></i></button>
				<button id="kpiv2StaticsBtn" title="Статики"><i class="fa fa-bars"></i></button>
			</div>
			
			<div class="buttons notop ml40px">
				<button id="kpiv2DataSettings" class="alt2" title="Настройки"><i class="fa fa-sliders"></i></button>
			</div>
		</div>
		
		<div class="d-flex" hidden kpiv2toppanel="kpiv2_payments">
			<div class="usersv2showlists mr40px" plannerpanel id="relationFieldsBlock">
				<div class="usersv2showlists__item" title="Отобразить таблицей">
					<input type="checkbox" id="kpiv2RelationFieldsPToS" kpiv2relationfields="ps">
					<label for="kpiv2RelationFieldsPToS">
						<strong class="fz14px">%</strong>
						<i class="fa fa-chevron-right fz10px pl2px pr2px"></i>
						<span class="fz14px">{{currency}}</span>
					</label>
				</div>
				
				<div class="usersv2showlists__item" title="Отобразить таблицей">
					<input type="checkbox" id="kpiv2RelationFieldsNone" kpiv2relationfields="sp">
					<label for="kpiv2RelationFieldsNone">
						<strong class="fz14px">%</strong>
						<i class="fa fa-chevron-left fz10px pl2px pr2px"></i>
						<span class="fz14px">{{currency}}</span>
					</label>
				</div>
			</div>
			
			
			<div class="buttons notop">
				<button id="kpiv2PeriodsButton" class="alt2" title="Создать период"><i class="fa fa-list-alt"></i></button>
				<button id="kpiv2ImportProgressBtn" class="alt2" title="Загрузить данные"><i class="fa fa-upload"></i></button>
				<button id="kpiv2SaveReportBtn" class="alt ml30px" title="Сохранить отчет" disabled><i class="fa fa-save"></i></button>
				<button id="kpiv2ReportsList" class="alt" title="Сохраненные отчеты"><i class="fa fa-bars"></i></button>
				<button id="kpiv2AmountsBtn" class="pay ml30px" title="Задать суммы выплат"><i class="fa fa-money"></i></button>
			</div>
			
			<div class="buttons notop ml40px">
				<button id="kpiv2PaymentsSettings" class="alt2" title="Настройки"><i class="fa fa-sliders"></i></button>
			</div>
		</div>
	</div>
	
	
	
	
	<div class="kpiv2">
		<div class="kpiv2__waitblock" id="kpiv2WaitBlock">
			<div class="text-center">
				<i class="fa fa-spinner fa-pulse fz30px fa-fw fontcolor"></i>
				<p class="fz14px fontcolor">Загрузка...</p>
			</div>
		</div>
		
		<ul class="tabstitles">
			<li id="kpiv2_data" maintabs>Сводная таблица</li>
			<li id="kpiv2_payments" maintabs>Платежные инструменты</li>
		</ul>
		
		
		<div class="tabscontent">
			<div tabid="kpiv2_data">
				<div id="kpiv2TableData"></div>
			</div>
			<div tabid="kpiv2_payments">
				<div id="kpiv2Payments"></div>
			</div>
		</div>
	</div>
</div>



<script type="text/javascript"><!--
$(function() {
	
	let searchString,
		searchField,
		sortField = ddrStore('kpiv2:sortField') || null,
		sortDir = ddrStore('kpiv2:sortDir') || null;
	
	
	let hashData = location.hash.substr(1, location.hash.length).split('.'),
		activeTab = hashData[1];
		if (activeTab) $('[kpiv2toppanel="'+activeTab+'"]').removeAttrib('hidden');
		else $('[kpiv2toppanel="kpiv2_data"]').removeAttrib('hidden');
	
	onChangeTabs(function(tab) {
		if (!$(tab).hasAttrib('maintabs')) return false;
		let tabId = $(tab).attr('id');
		$('[kpiv2toppanel]').setAttrib('hidden');
		$('[kpiv2toppanel="'+tabId+'"]').removeAttrib('hidden');
	});
	
	
	
	let showType = ddrStore('kpiv2:showtype') || 'table';
	$('[kpiv2datatype="'+showType+'"]').setAttrib('checked');
	
	
	getDataTable();
	
	
	
	//-------------------- Тип отображения данных
	$('[kpiv2datatype]').on('change', function() {
		let type = $(this).attr('kpiv2datatype');
		ddrStore('kpiv2:showtype', type);
		showType = type;
		getDataTable();
	});
	
	
	//-------------------- Получить поля для поиска
	getAjaxHtml('kpiv2/fields/to_find', function(html) {
		$('#kpiv2SearchField').html(html).removeAttrib('disabled');
		$('#kpiv2SearchStr').removeAttrib('disabled');
		searchField = $('#kpiv2SearchField').val();
	});
	
	
	
	
	//-------------------- Поиск
	let kpiv2SearchTOut;
	$('#kpiv2SearchStr').on('keyup', function() {
		clearTimeout(kpiv2SearchTOut);
		kpiv2SearchTOut = setTimeout(function() {
			$('#kpiv2SearchReset').removeAttrib('disabled');
			let str = $('#kpiv2SearchStr').val(); 
			if (str.length) searchString = str.trim();
			getDataTable();
		}, 500);
	});
	
	$('#kpiv2SearchField').on('change', function() {
		searchField = $('#kpiv2SearchField').val();
		if ($('#kpiv2SearchStr').val()) {
			$('#kpiv2SearchReset').removeAttrib('disabled');
			getDataTable();
		} 
	});
	
	$('#kpiv2SearchReset').on(tapEvent, function() {
		$('#kpiv2SearchStr').val('');
		searchString = null;
		searchField = null;
		//ddrStore('kpiv2:selected_statics', false);
		//ddrStore('kpiv2:current_static', false);
		getDataTable();
		$('#kpiv2SearchReset').setAttrib('disabled');
	});
	
	
	
	
	
	
	
	
	//-------------------- Сортировка
	$('#kpiv2TableData').on(tapEvent, '[kpiv2field]', function() {
		let sField = $(this).attr('kpiv2field');
		if (sField != sortField) {
			sortField = sField;
			sortDir = 'ASC';
		} else {
			sortDir = (sortDir == 'DESC') ? 'ASC' : 'DESC';
		}
		ddrStore('kpiv2:sortField', sortField);
		ddrStore('kpiv2:sortDir', sortDir);
		getDataTable();
	});
	
	
	
	
	
	
	
	
	//-------------------- Статики
	let reloadUsersStatics = false;
	$('#kpiv2StaticsBtn').on(tapEvent, function() {
		popUp({
			title: 'Статики|4',
			width: 700,
			closePos: 'left',
			closeButton: 'Закрыть',
			onClose: function() {
				if (reloadUsersStatics) {
					reloadUsersStatics = false;
					$('#kpiv2SearchStr').val('');
					searchField = null;
					sortField = null;
					getDataTable();
				}	
			}
		}, function(usersStaticsWin) {
			usersStaticsWin.setData('users/statics', {selected_statics: ddrStore('kpiv2:selected_statics')}, function() {
				
				
				$('#usersv2StaticsGroups').find('[usersv2groupbtn]').on(tapEvent, function() {
					let group = $(this).attr('usersv2groupbtn');
					
					$('#usersv2StaticsGroups').find('button').removeClass('active');
					$(this).addClass('active');
					
					$('#usersv2StaticsList').find('[usersv2staticgroup]').each(function() {
						if (group == 'all') $(this).setAttrib('checked');
						else if (group == 'none') $(this).removeAttrib('checked');
						else {
							if ($(this).attr('usersv2staticgroup') == group) $(this).setAttrib('checked');
							else $(this).removeAttrib('checked');
						}
					});
					
					reloadUsersStatics = true;
					setChoosedStaticsIds();
				});
				
				
				$('#usersv2StaticsList').find('[usersv2static]').on('change', function() {
					reloadUsersStatics = true;
					setChoosedStaticsIds();
				});
				
				
				function setChoosedStaticsIds() {
					let selectedStatics = [];
					$('#usersv2StaticsList').find('[usersv2static]:checked').each(function() {
						let stId = $(this).attr('usersv2static');
						selectedStatics.push(isInt(stId) ? parseInt(stId) : stId);
					});
					ddrStore('kpiv2:selected_statics', selectedStatics);
					if (selectedStatics.length) ddrStore('kpiv2:current_static', selectedStatics.shift());
					else ddrStore('kpiv2:current_static', null);
				}
				
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	//-------------------- Структура таблицы
	$('#kpiv2StruсtureBtn').on(tapEvent, function() {
		let changedStat = false;
		popUp({
			title: 'Структура таблицы|4',
			width: 500,
			closePos: 'left',
			closeButton: 'Закрыть',
			onClose: function() {
				if (changedStat) getDataTable();
			}
		}, function(kpiv2StruсtureWin) {
			
			Promise.all([
				getAjaxHtml('kpiv2/fields'),
				getAjaxHtml('kpiv2/fields/all'),
				getAjaxHtml('kpiv2/fields/choosed')
			]).then((data) => {
				
				let form = data[0]['html'],
					allFields = data[1]['html'],
					choosedFields = data[2]['html'];
				
				kpiv2StruсtureWin.setData(form, false, function() {
					if (allFields) $('#kpiv2FieldsAll').removeClass('kpiv2__list_empty').html(allFields);
					if (choosedFields) $('#kpiv2ChoosedFields').removeClass('kpiv2__list_empty').html(choosedFields);
					
					
					new Sortable($('#kpiv2FieldsAll')[0], {
						group: 'shared',
						animation: 150,
						sort: false
					});
			
					new Sortable($('#kpiv2ChoosedFields')[0], {
						group: 'shared',
						animation: 150,
						onSort: function(data) {
							let choosedFields = [];
							$('#kpiv2ChoosedFields').find('[kpiv2field]').each(function(k) {
								let fieldId = parseInt($(this).attr('kpiv2field'));
								
								choosedFields.push({
									id: fieldId,
									choosed: 1,
									sort: (k + 1)
								});
							});
							
							setEmptyFieldsBlock();
							setChoosedFields(choosedFields);
							changedStat = true;
						}
					});
						
					
					
					$('#kpiv2NewFieldBtn').on(tapEvent, function() {
						kpiv2StruсtureWin.dialog('<div class="d-flex align-items-center justify-content-center" id="kpiv2NewField"><i class="fa fa-spinner fa-pulse fa-fw"></i></div>', 'Добавить', 'Отмена', function() {
							
							$('#kpiv2NewFieldForm').formSubmit({
								url: 'kpiv2/fields/add',
								success: function(response) {
									if (response) {
										getFields(function() {
											kpiv2StruсtureWin.dialog(false);
										});
									} else {
										notify('Ошибка! Столбец не добавлен!', 'error');
									}
								}
							});
						});
						
						getAjaxHtml('kpiv2/fields/new', function(html) {
							$('#kpiv2NewField').replaceWith(html);
						});
					});
					
					
					
					// Изменить поле
					$('#kpiv2FieldsAll, #kpiv2ChoosedFields').on(tapEvent, '[kpiv2fieldsettingbtn]', function() {
						let fieldId = $(this).attr('kpiv2fieldsettingbtn'),
							setChangeStat = !!$(this).closest('#kpiv2ChoosedFields').length;
						
						kpiv2StruсtureWin.dialog('<div class="d-flex align-items-center justify-content-center" id="kpiv2NewField"><i class="fa fa-spinner fa-pulse fa-fw"></i></div>', 'Обновить', 'Отмена', function() {
							
							$('#kpiv2NewFieldForm').formSubmit({
								url: 'kpiv2/fields/update',
								success: function(response) {
									if (response) {
										Promise.all([
											getFields(),
											getChoosedFields()
										]).then(() => {
											kpiv2StruсtureWin.dialog(false);
											if (setChangeStat) changedStat = true;
										});
									} else {
										notify('Ошибка! Столбец не добавлен!', 'error');
									}
								}
							});
						});
						
						getAjaxHtml('kpiv2/fields/edit', {id: fieldId}, function(html) {
							$('#kpiv2NewField').replaceWith(html);
						});
					});
					
					
					// Удалить поле
					$('#kpiv2FieldsAll').on(tapEvent, '[kpiv2fieldremovebtn]', function() {
						let fieldId = $(this).attr('kpiv2fieldremovebtn');
						kpiv2StruсtureWin.dialog('<p class="red fz16px">Удлить столбец?</p>', 'Удалить', 'Отмена', function() {
							$.post('/kpiv2/fields/remove', {id: fieldId}, function(response) {
								if (response) {
									getFields(() => {
										kpiv2StruсtureWin.dialog(false);
										notify('Столбец успешно удален!');
									});
								} else {
									notify('Ошибка! Столбец не удален!', 'error');
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						});
						
					});
					
					
				});
			});
			
			
			
		});
	});
	
	
	
	
	
	
	//-------------------- Импорт из файла
	$('#kpiv2ImportBtn').on(tapEvent, function() {
		popUp({
			title: 'Загрузить данные из файла|4',
			width: 500,
			buttons: [{id: 'kpiv2SetImportBtn', title: 'Загрузить', disabled: 1}],
			closePos: 'left',
			closeButton: 'Отмена'
		}, function(kpiv2ImportWin) {
			kpiv2ImportWin.setData('kpiv2/import/form', function() {
				
				$("#kpiv2ImportFile").on('input', function() {
					let inpFile = $("#kpiv2ImportFile");
				    if (inpFile.prop('files').length === 0) {
				    	$('#kpiv2SetImportBtn').setAttrib('disabled');
				    } else {
				    	kpiv2ImportWin.wait();
				    }
				});
				
				$('#kpiv2ImportFile').chooseInputFile(function(data) {
					if (data.ext !== 'json') {
						$("#kpiv2ImportFile").val('');
						kpiv2ImportWin.dialog('Необходимо загрузить в формате JSON!', null, 'Закрыть', function() {
							kpiv2ImportWin.dialog(false);
						});
					} else {
						$('#kpiv2SetImportBtn').removeAttrib('disabled');
					}
					kpiv2ImportWin.wait(false);
				});
				
				
				$('#kpiv2SetImportBtn').on(tapEvent, function() {
					kpiv2ImportWin.wait();
					let inpFile = $("#kpiv2ImportFile"),
				    	form = new FormData;
				    if (inpFile.prop('files').length === 0) {
				    	$('#kpiv2SetImportBtn').setAttrib('disabled');
				    	return false;
				    } 
				    
				    form.append('file', inpFile.prop('files')[0]);
				    $.ajax({
				        url: '/kpiv2/import',
				        dataType: 'json',
				        data: form,
				        processData: false,
				        contentType: false,
				        type: 'POST',
				        success: function(response) {
				        	if (response == -1) {
				        		notify('Ошибка загрузки файла', 'error');
				        		$('#kpiv2ImportFile').val('');
				        		$('#kpiv2SetImportBtn').setAttrib('disabled');
				        		kpiv2ImportWin.wait(false);
				        	
				        	} else if (response == -2) {
				        		notify('Файл успешно загружен, но новых данных нет', 'info', 10);
				        		$('#kpiv2ImportFile').val('');
				        		$('#kpiv2SetImportBtn').setAttrib('disabled');
				        		kpiv2ImportWin.close();
				        	} else if (response == 1) {
				        		getDataTable(function() {
				        			notify('Данные успешно импортированы!');
									kpiv2ImportWin.close();
									//kpiv2ImportWin.wait(false);
				        		});
				        	}
						},
						error: function(e) {
							kpiv2ImportWin.wait(false);
							notify('Ошибка сохранения данных', 'error');
							showError(e);
						}
				    });
				});
				
				
			});
		});
	});
	
	
	
	
	
	
	
	
	
	$('#kpiv2DataSettings').on(tapEvent, function() {
		popUp({
			title: 'Настройки полей «Сводная таблица»|4',
			width: 500,
			buttons: false,
			closePos: 'left',
			closeButton: 'Закрыть'
		}, function(kpiv2PaymentsSettingsWin) {
			let setSettingTOut;
			kpiv2PaymentsSettingsWin.setData('kpiv2/settings/data_fields', function() {
				$('[kpiv2setting]').on('input', function() {
					const input = this;
					clearTimeout(setSettingTOut);
					setSettingTOut = setTimeout(function() {
						let param = $(input).attr('kpiv2setting'),
							value = $(input).val();
						$.post('/kpiv2/settings/set', {param: param, value: value}, function() {
							$(input).addClass('changed');
						}).fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
						});
					}, 500);
				});
				
			});
		});
	});
	
	
	
	
	
	
	
	
	$('#kpiv2PaymentsSettings').on(tapEvent, function() {
		popUp({
			title: 'Настройки полей «Платежные реквизиты»|4',
			width: 500,
			buttons: false,
			closePos: 'left',
			closeButton: 'Закрыть'
		}, function(kpiv2PaymentsSettingsWin) {
			let setSettingTOut;
			kpiv2PaymentsSettingsWin.setData('kpiv2/settings/payment_fields', function() {
				$('[kpiv2setting]').on('input', function() {
					const input = this;
					clearTimeout(setSettingTOut);
					setSettingTOut = setTimeout(function() {
						let param = $(input).attr('kpiv2setting'),
							value = $(input).val();
						$.post('/kpiv2/settings/set', {param: param, value: value}, function() {
							$(input).addClass('changed');
						}).fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
						});
					}, 500);
				});
				
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------- Вторая вкладка
	
	
	
	
	
	
	
	
	
	
	
	let kpiv2PeriodId;
	
	if (ddrStore('kpiv2:relationfieldsps')) $('#relationFieldsBlock').find('[kpiv2relationfields="ps"]').setAttrib('checked');
	if (ddrStore('kpiv2:relationfieldssp')) $('#relationFieldsBlock').find('[kpiv2relationfields="sp"]').setAttrib('checked');
	
	
	$('#relationFieldsBlock').find('[kpiv2relationfields]').on(tapEvent, function() {
		let isChecked = $(this).is(':checked') ? 1 : 0,
			relationField = $(this).attr('kpiv2relationfields');
		
		ddrStore('kpiv2:relationfields'+relationField, isChecked);
	});
	
	
	
	
	
	
	
	
	
	
	//-------------------- Создать новый KPI период
	$('#kpiv2PeriodsButton').on(tapEvent, function() {
		popUp({
			title: 'Новый KPI период',
			width: 600,
			buttons: [{id : 'saveKpiv2PeriodButton', title: 'Создать'}],
			closeButton: 'Закрыть',
			closeByButton: true
		}, function(kpiv2PeriodsWin) {
			kpiv2PeriodsWin.setData('kpiv2/periods/new', function() {
				datePicker('#newKpiv2PeriodDateStart', '#newKpiv2PeriodDateEnd');
				$('#kpiv2PeriodsList').ddrTable({minHeight: '50px', maxHeight: '300px'});
				$('#kpiv2StaticsList').ddrTable({minHeight: '50px', maxHeight: '300px'});
				
				$('#saveKpiv2PeriodButton').on(tapEvent, function() {
					let newKpiPeriodTitle = $('#newKpiPeriodTitle'),
						newKpiPeriodPayoutType = $('#newKpiPeriodPayoutType'),
						newKpiPeriodDateStart = $('#newKpiv2PeriodDateStart'),
						newKpiPeriodDateEnd = $('#newKpiv2PeriodDateEnd'),
						reportPeriodId = $('[name="reportperiodforkpi"]:checked'),
						staticsKoeffs = {},
						stat = true;
					
					
					$('#kpiv2StaticsList').find('[kpiv2periodstatics]').each(function() {
						let staticId = $(this).attr('kpiv2periodstatics'),
							koeff = parseFloat($(this).val());
						if (!koeff) return true;
						staticsKoeffs[staticId] = koeff;
					});
					
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
					
					
					if (stat) {
						kpiv2PeriodsWin.dialog('<p class="green">Создать KPI период?</p>', 'Создать', 'Отмена', function() {
							kpiv2PeriodsWin.wait();
							
							let params = {
								title: newKpiPeriodTitle.val(),
								payout_type: newKpiPeriodPayoutType.val(),
								date_start: newKpiPeriodDateStart.attr('date'),
								date_end: newKpiPeriodDateEnd.attr('date'),
								report_period: parseInt(reportPeriodId.val()),
								statics_koeffs: staticsKoeffs
							};
							
							$.post('/kpiv2/periods/add', params, function(response) {
								if (response) {
									notify('Период успешно добавлен!');
									kpiv2PeriodsWin.close();
								} else {
									notify('Ошибка добавления периода!', 'error');
								}
								kpiv2PeriodsWin.wait(false);
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
	
	
	
	
	
	
	
	
	
	
	
	//-------------------- Суммы выплат по званиям и статикам
	$('#kpiv2AmountsBtn').on(tapEvent, function() {
		popUp({
			title: 'Суммы выплат по званиям и статикам',
			width: 1100,
		}, function(kpiv2AmountsWin) {
			kpiv2AmountsWin.setData('kpiv2/amounts/get_form', function() {
				$('#kpiAmountsForm').find('input[amountfield]').number(true, 2, '.', ' ');
				$('#kpiAmountsForm').ddrTable({minHeight: '350px', maxHeight: 'calc(100vh - 200px)'});
				
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
						$.post('/kpiv2/amounts/set_amount', {
							static_id: staticId,
							rank_id: rankId,
							amount: value,
							payout_type: payoutType
						}, function(response) {
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
	
	
	
	
	
	
	
	
	
	
	//-------------------- Импорт прогресса выполнения
	$('#kpiv2ImportProgressBtn').on(tapEvent, function() {
		popUp({
			title: 'Загрузить данные',
			width: 700,
			buttons: [{id: 'kpiv2SetImportProgressBtn', title: 'Загрузить'}],
			closePos: 'left',
			closeButton: 'Отмена'
		}, function(kpiv2ImportProgressWin) {
			kpiv2ImportProgressWin.setData('kpiv2/import_progress/form', function() {
				$('#kpiv2ImportProgressFile').chooseInputFile(function(data) {
					if (data.ext !== 'json') {
						kpiv2ImportProgressWin.dialog('Необходимо загрузить в формате JSON!', null, 'Закрыть', function() {
							kpiv2ImportProgressWin.dialog(false);
						});
					} else {
						$('#kpiv2SetImportProgressBtn').removeAttrib('disabled');
					}
				});
				
				
				$("#kpiv2ImportProgressFile").on('input', function() {
					let inpFile = $("#kpiv2ImportProgressFile");
				    if (inpFile.prop('files').length === 0) $('#kpiv2SetImportProgressBtn').setAttrib('disabled');
				});
				
				
				
				$('#kpiv2PeriodId').on('change', function() {
					let periodId = $('#kpiv2PeriodId').val();
					$('#kpiv2StaticsList').html('<div class="h325px d-flex align-items-center justify-content-center"><i class="fa fa-spinner fa-pulse fa-fw fontcolor fz30px"></i></div>');
					getAjaxHtml('/kpiv2/import_progress/statics_koeffs', {period_id: periodId}, function(html) {
						$('#kpiv2StaticsList').html(html);
						$('#kpiv2StaticsList').find('table').ddrTable({minHeight: '50px', maxHeight: '300px'});
					});
				});
				
				
				$('#kpiv2SetImportProgressBtn').on(tapEvent, function() {
					kpiv2ImportProgressWin.wait();
					let periodId = $('#kpiv2PeriodId').val(),
						inpFile = $("#kpiv2ImportProgressFile"),
						staticsKoeffs = {},
				    	form = new FormData;
				    
				    if (inpFile.prop('files').length === 0) {
				    	$('#kpiv2SetImportProgressBtn').setAttrib('disabled');
				    	kpiv2ImportProgressWin.wait(false);
				    	notify('Ошибка! Необходимо выбрать файл!', 'error');
				    	return false;
				    }
				    
				    
				    $('#kpiv2StaticsList').find('[kpiv2periodstatics]').each(function() {
						let staticId = $(this).attr('kpiv2periodstatics'),
							koeff = parseFloat($(this).val());
						if (!koeff) return true;
						staticsKoeffs[staticId] = koeff;
					});
				    
				    
				    kpiv2PeriodId = parseInt(periodId);
				    
				    form.append('file', inpFile.prop('files')[0]);
				    form.append('period_id', kpiv2PeriodId);
				    form.append('statics_koeffs', JSON.stringify(staticsKoeffs));
				    
				    $.ajax({
				        url: '/kpiv2/import_progress',
				        dataType: 'html',
				        data: form,
				        processData: false,
				        contentType: false,
				        type: 'POST',
				        success: function(data) {
				        	if (isInt(data)) {
				        		let stat = parseInt(data);
				        		if (stat === 0) {
				        			notify('Ошибка! Не удалось обработать данные!', 'error', 10);
				        		} else if (stat === -1) {
				        			notify('Ошибка загрузки файла!', 'error');
				        		} else if (stat === -2) {
				        			notify('Ошибка! В импортируемом файле отсутствуют или имеют иное название обязательные поля!', 'error', 10);
				        		}
				        		
				        		$('#kpiv2ImportProgressFile').val('');
				        		$('#kpiv2SetImportProgressBtn').setAttrib('disabled');
				        		kpiv2ImportProgressWin.wait(false);
				        	
				        	} else {
				        		$('#kpiv2Payments').html(data);
				        		kpiv2ImportProgressWin.close();
				        		ddrInitTabs();
				        		$('#kpiv2Payments').find('input[kpiv2amountfield]').number(true, 2, '.', ' ');
				        		$('#kpiv2SaveReportBtn').removeAttrib('disabled');
				        		
				        		let progressfieldTOut;
				        		$('#kpiv2Payments').find('input[kpiv2progressfield]').on('input', function() {
				        			let input = this;
				        			if (!ddrStore('kpiv2:relationfieldsps')) {
				        				let progress = parseFloat($(input).val()) || 0,
					        				progressbar = $(input).closest('td').find('[kpiv2progressbar]'),
					        				progressbarNum = $(input).closest('td').find('[kpiv2progressbarnum]');
				        				
				        				$(progressbar).val(progress);
					        			$(progressbarNum).text(progress+' %');
					        			$(input).addClass('changed');
				        				return false;
				        			}
				        			clearTimeout(progressfieldTOut);
				        			
				        			progressfieldTOut = setTimeout(function() {
				        				let progress = parseFloat($(input).val()) || 0,
					        				d = $(input).attr('kpiv2progressfield').split('|'),
					        				summField = $(input).closest('tr').find('[kpiv2amountfield]'),
					        				progressbar = $(input).closest('td').find('[kpiv2progressbar]'),
					        				progressbarNum = $(input).closest('td').find('[kpiv2progressbarnum]');
					        				
					        			$.post('/kpiv2/amounts/calc_summ', {
					        				static: parseInt(d[0]),
					        				rank: parseInt(d[1]),
					        				payout_type: parseInt(d[2]),
					        				factor: parseFloat(d[3]),
					        				progress: progress
					        			}, function(summ) {
					        				$(summField).val(summ);
					        				$(progressbar).val(progress);
					        				$(progressbarNum).text(progress+' %');
					        				$(input).addClass('changed');
					        			}).fail(function(e) {
					        				showError(e);
					        				notify('Системная ошибка!', 'error');
					        			});
				        			}, 300);
				        		});
				        		
				        		let amountfieldTOut;
				        		$('#kpiv2Payments').find('input[kpiv2amountfield]').on('input', function() {
				        			if (!ddrStore('kpiv2:relationfieldssp')) return false;
				        			clearTimeout(amountfieldTOut);
				        			let input = this;
				        			amountfieldTOut = setTimeout(function() {
				        				let summ = parseFloat($(input).val()) || 0,
					        				d = $(input).attr('kpiv2amountfield').split('|'),
					        				progressField = $(input).closest('tr').find('[kpiv2progressfield]'),
					        				progressbar = $(input).closest('tr').find('[kpiv2progressbar]'),
					        				progressbarNum = $(input).closest('tr').find('[kpiv2progressbarnum]');
					        			
					        			$.post('/kpiv2/amounts/calc_progress', {
					        				static: parseInt(d[0]),
					        				rank: parseInt(d[1]),
					        				payout_type: parseInt(d[2]),
					        				factor: parseFloat(d[3]),
					        				summ: summ
					        			}, function(progress) {
					        				$(progressField).val(progress);
					        				$(progressbar).val(progress);
					        				$(progressbarNum).text(progress+' %');
					        				$(input).addClass('changed');
					        			}).fail(function(e) {
					        				showError(e);
					        				notify('Системная ошибка!', 'error');
					        			});
				        			}, 300);
				        		});
				        	}
						},
						error: function(e) {
							kpiv2ImportProgressWin.wait(false);
							notify('Ошибка сохранения данных', 'error');
							showError(e);
						}
				    });
				});
			});
			
		});
	});
	
	
	
	
	
	
	
	
	
	
	//-------------------- Сохранение отчета
	$('#kpiv2SaveReportBtn').on(tapEvent, function() {
		popUp({
			title: 'Сохранить отчет|4',
			width: 400,
			buttons: [{id: 'kpiv2SetSaveReportBtn', title: 'Сохранить'}],
			disabledButtons: true,
			closePos: 'left',
			closeButton: 'Отмена'
		}, function(kpiv2SaveReportWin) {
			kpiv2SaveReportWin.setData('kpiv2/report', function() {
				let titleInp
				$('#kpiv2ReportTitle').on('input', function() {
					titleInp = this;
					if ($(titleInp).val()) {
						$('#kpiv2SetSaveReportBtn').removeAttrib('disabled');
					} else {
						$('#kpiv2SetSaveReportBtn').setAttrib('disabled');
					}
				});
				
				
				$('#kpiv2SetSaveReportBtn').on(tapEvent, function() {
					kpiv2SaveReportWin.wait();
					
					$('#kpiv2ReportData').formSubmit({
						url: 'kpiv2/report/save',
						fields: {title: $(titleInp).val(), period_id: kpiv2PeriodId},
						success: function() {
							kpiv2SaveReportWin.close();
							$('#kpiv2SaveReportBtn').setAttrib('disabled');
							notify('Отчет успешно сохранен!');
						},
						complete: function() {
							kpiv2SaveReportWin.wait(false);
						},
						error: function() {
							notify('Ошибка сохранения отчета', 'error');
						}
					});
				});
				
			});
			
			
		});
	});




	
	
	
	
	
	
	
	
	$('#kpiv2ReportsList').on(tapEvent, function() {
		popUp({
			title: 'Список сохраненных отчетов|4',
			width: 400,
			closeButton: 'Закрыть'
		}, function(kpiv2ReportsListWin) {
			kpiv2ReportsListWin.setData('kpiv2/report/list', function() {
				$('#kpiv2ReportsTable').ddrTable({minHeight: '50px', maxHeight: '500px'});
				
				$('[kpiv2buildreportbtn]').on(tapEvent, function() {
					let reportId = $(this).attr('kpiv2buildreportbtn');
					kpiv2ReportsListWin.wait();
					getAjaxHtml('kpiv2/report/get', {report_id: reportId}, function(html, stat) {
						if (stat) $('#kpiv2Payments').html(html);
						else $('#kpiv2Payments').html('<p class="empty">Нет данных</p>');
						ddrInitTabs();
						$('#kpiv2SaveReportBtn').setAttrib('disabled');
						kpiv2ReportsListWin.close();
					});
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-----------------------------------------------------------------------------------------------------------------
	
	
	
	function getFields(callback) {
		return new Promise(function(resolve, reject) {
			try {
				getAjaxHtml('kpiv2/fields/all', function(html, stat) {
					if (stat) $('#kpiv2FieldsAll').removeClass('kpiv2__list_empty').html(html);
					else $('#kpiv2FieldsAll').addClass('kpiv2__list_empty').html('');
					resolve();
					if (callback && typeof callback === 'function') callback();
				});
			} catch(e) {
				reject(e);
			}
		});
		
	}
	
	function getChoosedFields(callback) {
		return new Promise(function(resolve, reject) {
			try {
				getAjaxHtml('kpiv2/fields/choosed', function(html, stat) {
					if (stat) $('#kpiv2ChoosedFields').removeClass('kpiv2__list_empty').html(html);
					else $('#kpiv2ChoosedFields').addClass('kpiv2__list_empty').html('');
					resolve();
					if (callback && typeof callback === 'function') callback();
				});
			} catch(e) {
				reject(e);
			}
		});	
	}
	
	
	function setChoosedFields(fields) {
		getAjaxJson('kpiv2/fields/set_choosed', {fields: fields}, function(response) {
			if (!response) {
				notify('Ошибка! Столбцы не сохранлись!', 'error');
			}
		});
	}
	
	
	
	

	function setEmptyFieldsBlock() {
		let fieldsCount = $('#kpiv2FieldsAll').find('li').length,
			fieldsChoosed = $('#kpiv2ChoosedFields').find('li').length;
		
		if (fieldsCount == 0) $('#kpiv2FieldsAll').not('.kpiv2__list_empty').addClass('kpiv2__list_empty');
		else $('#kpiv2FieldsAll.kpiv2__list_empty').removeClass('kpiv2__list_empty');
		
		if (fieldsChoosed == 0) $('#kpiv2ChoosedFields').not('.kpiv2__list_empty').addClass('kpiv2__list_empty');
		else $('#kpiv2ChoosedFields.kpiv2__list_empty').removeClass('kpiv2__list_empty');
	}
	
	
	
	
	
	
	
	let usersSetRankTooltip;
	function getDataTable(callback) {
		$('#kpiv2WaitBlock').addClass('kpiv2__waitblock_visible');
		
		return new Promise(function(resolve, reject) {
			try {
				getAjaxHtml('kpiv2/data', {
					show_type: showType,
					search_str: searchString,
					search_field: searchField,
					sort_field: sortField,
					sort_dir: sortDir,
					selected_statics: ddrStore('kpiv2:selected_statics')
				}, function(html) {
					$('#kpiv2TableData').html(html);
					resolve();
					if (callback && typeof callback === 'function') callback();
					
					$('#kpiv2WaitBlock').removeClass('kpiv2__waitblock_visible');
					
					
					ddrInitTabs();
					$('.scroll').ddrScrollTable();
					
					if (showType == 'list') {
						$('#kpiv2TableData').off(tapEvent, '[kpiv2openlistbtn]').on(tapEvent, '[kpiv2openlistbtn]', function() {
							if ($(this).parent().hasClass('kpiv2list__item_visible')) {
								$(this).parent().removeClass('kpiv2list__item_visible');
							} else {
								$('#kpiv2TableData').find('[kpiv2openlistbtn]').parent().removeClass('kpiv2list__item_visible');
								$(this).parent().addClass('kpiv2list__item_visible');
							}
						});
					} else if (showType == 'table') {
						$('[kpiv2field="'+sortField+'"]').addClass('sorttd_active');
					}
					
					
					//------------- Присвоить звание
					if (usersSetRankTooltip) usersSetRankTooltip.destroy();
					usersSetRankTooltip = new jBox('Tooltip', {
						attach: '[openboostershistorybtn]',
						trigger: 'click',
						closeOnMouseleave: true,
						outside: 'x',
						ignoreDelay: true,
						zIndex: 1200,
						pointer: 'top',
						position: {
						  x: 'right',
						  y: 'center'
						},
						onOpen: function() {
							$('#kpiv2TableData').find('[openboostershistorybtn]').removeClass('lightblue_active');
							usersSetRankTooltip.setContent('<div class="d-flex w367px h110px align-items-center justify-content-center flex-column"><i class="fa fa-spinner fa-pulse fz22px"></i><p>Загрузка истории...</p></div>');
							
							let id = $(this.target).attr('openboostershistorybtn');
							$(this.target).addClass('lightblue_active');
							
							getAjaxHtml('kpiv2/data/boosters_history', {id: id}, function(html) {
								usersSetRankTooltip.setContent(html);
								$('#boostersHistoryTable').ddrTable({minHeight: '50px', maxHeight: '300px'});
							});
						},
						onClose: function() {
							$(this.target).removeClass('lightblue_active');
						}
					});
					
				});
			} catch(e) {
				reject(e);
				showError(e);
			}
		});	
	}
								
								
	
	
	
});
//--></script>