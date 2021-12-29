<div class="section" id="{{id}}">
	<div class="section_title">
		<div class="d-flex mr-auto">
			<h2 class="mr3px">KPI планы</h2>
			<sup class="grayblue fz14px">версия 2</sup>
		</div>
		
		<div class="buttons notop mr30px">
			<button id="" class="pay" title="Загрузить данные"><i class="fa fa-upload"></i></button>
			<button id="" title="Структура таблицы"><i class="fa fa-columns"></i></button>
		</div>
		
		<div class="buttons notop">
			<button id="kpiv2ImportBtn" class="pay" title="Загрузить данные"><i class="fa fa-upload"></i></button>
			<button id="kpiv2StruсtureBtn" title="Структура таблицы"><i class="fa fa-columns"></i></button>
		</div>
	</div>
	
	
	
	<div id="kpiv2TableData"></div>
	
</div>



<script type="text/javascript"><!--
$(function() {
	
	
	getDataTable();
	
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
			title: 'Загрузить данные',
			width: 500,
			html: '',
			buttons: [{id: 'kpiv2SetImportBtn', title: 'Загрузить', disabled: 1}],
			closePos: 'left',
			closeButton: 'Отмена'
		}, function(kpiv2ImportWin) {
			kpiv2ImportWin.setData('kpiv2/import/form', function() {
				
				$('#kpiv2ImportFile').chooseInputFile(function(data) {
					if (data.ext !== 'json') {
						kpiv2ImportWin.dialog('Необходимо загрузить в формате JSON!', null, 'Закрыть', function() {
							kpiv2ImportWin.dialog(false);
						});
					} else {
						$('#kpiv2SetImportBtn').removeAttrib('disabled');
					}
					
					
				});
				
				
				$("#kpiv2ImportFile").on('input', function() {
					let inpFile = $("#kpiv2ImportFile");
				    if (inpFile.prop('files').length === 0) $('#kpiv2SetImportBtn').setAttrib('disabled');
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
				        	if (!response) {
				        		notify('Ошибка загрузки файла', 'error');
				        		$('#kpiv2ImportFile').val('');
				        		$('#kpiv2SetImportBtn').setAttrib('disabled');
				        		kpiv2ImportWin.wait(false);
				        	
				        	} else {
				        		getDataTable(function() {
				        			notify('Файл успешно загружен!');
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
		return new Promise(function(resolve, reject) {
			try {
				getAjaxHtml('kpiv2/table', function(html) {
					$('#kpiv2TableData').html(html);
					resolve();
					if (callback && typeof callback === 'function') callback();
					
					$('#kpiv2Table').ddrTable({minHeight: '50px', maxHeight: 'calc(100vh - 224px)'});
					
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
							usersSetRankTooltip.setContent('<div class="d-flex w367px h110px align-items-center justify-content-center flex-column"><i class="fa fa-spinner fa-pulse fz22px"></i><p>Загрузка истории...</p></div>');
							
							let id = $(this.target).attr('openboostershistorybtn');
							$(this.target).addClass('lightblue_active');
							
							getAjaxHtml('kpiv2/table/boosters_history', {id: id}, function(html) {
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