<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Расписание</h2>
	</div>
	
	<fieldset>
		<legend>Панель управления</legend>
		
		<div class="item inline">
			<input type="hidden" id="timesheetPeriodId" value="">
			<div class="buttons notop">
				<button id="timesheetPeriodButton" class="fieldheight" title="Периоды расписания"><i class="fa fa-list-alt"></i></button>
			</div>
		</div>
		
		<div class="item inline">
			<h3 class="mt-3" id="timesheetPeriodName"></h3>
		</div>
		
	</fieldset>
	
	
	<!-- 
		время
		тип рейда (из выпадающего списка)
		продолжительность
		статик (из выпадающего списка)
		добавить
	 -->
	 
	 <div id="timesheetTable" class="mt-4"></div>
	 
		
	
	
	
</div>








<script type="text/javascript"><!--
$(document).ready(function() {
	//-------------------------------------------------------------------------------------------------------------------- Расписание
	
	//---------------------------------------------------------------- Периоды расписания
	var periodName = '', currentPeriod = null, timesheetPeriodsWin;
	$('#timesheetPeriodButton').on(tapEvent, function() {
		popUp({
			title: 'Периоды расписания',
		    width: 520,
		    buttons: [{id: 'newTimesheetPeriod', title: 'Новый период', disabled: true}]
		}, function(tPWin) {
			timesheetPeriodsWin = tPWin;
			timesheetPeriodsWin.wait();
			getAjaxHtml('timesheet/get_timesheet_periods', function(html) {
				timesheetPeriodsWin.setData(html, false);
				$('#newTimesheetPeriod').prop('disabled', false);
			}, function() {
				timesheetPeriodsWin.wait(false);
			});
		});
	});
	
	
	
	//---------------------------------------------------------------- Новый период
	$('body').off(tapEvent, '#newTimesheetPeriod').on(tapEvent, '#newTimesheetPeriod', function() {
		$.post('/timesheet/new_timesheet_period', function(html) {
			if ($('#timesheetPeriodsList tbody').find('td[colspan="4"]').length > 0) {
				$('#timesheetPeriodsList tbody').find('td[colspan="4"]').parent('tr').remove();
			}
			$('#timesheetPeriodsList tbody').append(html);
			
			$('#timesheetPeriodsList tbody').find('.saveTimesheetPeriod').on(tapEvent, function() {
				var thisRow = $(this).closest('tr'),
					thisName = $(thisRow).find('input').val(),
					thisStartDate = $(thisRow).find('select').val(),
					thisStartDateText = $(thisRow).find('select').children('option:selected').text();
				
				if (thisName != '') {
					$.post('/timesheet/save_timesheet_period', {name: thisName, start_date: thisStartDate}, function(periodId) {
						if (periodId) {
							notify('Период успешно сохранен!');
							
							var html = '<td>'+thisName+'</td>';
								html += '<td>'+thisStartDateText+'</td>';
								html += '<td class="nowidth"><div class="buttons"><button class="remove" title="Удалить период" removetimesheetperiod="'+periodId+'"><i class="fa fa-trash"></i></button></div></td>';
								html += '<td class="nowidth"><div class="buttons"><button title="Выбрать период" choosetimesheetperiod="'+periodId+'"><i class="fa fa-check"></i></button></div></td>';
							$(thisRow).html(html);
						}
					}).fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				} else {
					notify('Ошибка! Название не может быть пустым!', 'error');
					$(thisRow).find('input').addClass('error');
				}	
			});
			
			
			$('#timesheetPeriodsList tbody').find('.copyTimesheetPeriod').on(tapEvent, function() {
				var thisRow = $(this).closest('tr'),
					thisName = $(thisRow).find('input').val(),
					thisStartDate = $(thisRow).find('select').val(),
					thisStartDateText = $(thisRow).find('select').children('option:selected').text();
				
				if (thisName != '') {
					timesheetPeriodsWin.wait();
					getAjaxHtml('timesheet/get_timesheet_periods', {to_user: 1, attr: 'chooseperiodtocopy'}, function(html) {
						timesheetPeriodsWin.setData(html, false);
						timesheetPeriodsWin.setTitle('Скопировать период');
						timesheetPeriodsWin.removeButtons();
						timesheetPeriodsWin.wait(false);
					}, function() {
						
						$('[chooseperiodtocopy]').on(tapEvent, function() {
							timesheetPeriodsWin.wait(false);
							var periodId = $(this).attr('chooseperiodtocopy');
							$.post('/timesheet/copy_timesheet_period', {period_id: periodId, name: thisName, start_date: thisStartDate}, function(response) {
								if (response) {
									timesheetPeriodsWin.close();
									notify('Расписание успешно скопировано!');
								} else {
									timesheetPeriodsWin.wait(false);
									notify('Ошибка! При копировании расписания произошла ошибка!', 'error');
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						});
					});
				} else {
					notify('Ошибка! Название не может быть пустым!', 'error');
					$(thisRow).find('input').addClass('error');
				}	
			});
			
			
			
			
			
		}, 'html').fail(function(e) {
			notify('Системная ошибка!', 'error');
			timesheetPeriodsWin.wait(false);
			showError(e);
		});
	});
	
	
		
	//---------------------------------------------------------------- Выбрать период
	$('body').off(tapEvent, '[choosetimesheetperiod]').on(tapEvent, '[choosetimesheetperiod]', function() {
		var thisId = $(this).attr('choosetimesheetperiod'),
			thisRow = $(this).closest('tr');
			periodName = $(thisRow).find('td:first').text();
			currentPeriod = thisId;
		
		$('#timesheetPeriodId').val(thisId);
		notify('Период расписания выбран!');
		$('#timesheetPeriodButton').addClass('done');
		timesheetPeriodsWin.close();
		getAjaxHtml('timesheet/get_timesheet_data', {period_id: thisId}, function(html) {
			$('#timesheetTable').html(html);
			$('#timesheetPeriodName').html('Период: <strong>'+periodName+'</strong>');
		});
	});
	
	
	
	
	//---------------------------------------------------------------- Удалить период
	$('body').off(tapEvent, '[removetimesheetperiod]').on(tapEvent, '[removetimesheetperiod]', function() {
		var thisPeriodId = $(this).attr('removetimesheetperiod'),
			thisRow = $(this).closest('tr');
		
		popUp({
			title: 'Удалить период?',
		    width: 500,
		    buttons: [{id: 'removeConfirm'+thisPeriodId, title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(removeWin) {
			$('#removeConfirm'+thisPeriodId).on(tapEvent, function() {
				$.post('/timesheet/remove_timesheet_period', {period_id: thisPeriodId}, function(response) {
					if (response) {
						if (currentPeriod == thisPeriodId) {
							$('#timesheetTable').html('');
							$('#timesheetPeriodName').html('');
							$('#timesheetPeriodButton').removeClass('done');
							$('#timesheetPeriodId').val('');
						}
						$(thisRow).remove();
						notify('Период успешно удален!');
						removeWin.close();
					} else {
						notify('Ошибка! Период не удален!', 'error');
					}
				}).fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
					removeWin.close();
				});
			});
		});	
	});
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------- Добавить рейд
	$('body').off(tapEvent, '[addtimesheetitem]').on(tapEvent, '[addtimesheetitem]', function() {
		var thisPeriodId = $('#timesheetPeriodId').val(),
			thisItem = $(this).attr('addtimesheetitem').split('|');
		
		popUp({
			title: 'Добавить рейд',
		    width: 600,
		    buttons: [{id: 'addTimesheetRaid', title: 'Добавить', disabled: 1}],
		    closeButton: 'Отмена',
		}, function(timesheetItemWin) {
			$.post('/timesheet/new_timesheet_raid', {day: thisItem[1]}, function(html) {
				timesheetItemWin.setData(html, false);
				$('#addTimesheetRaid').prop('disabled', false);
				
				$('#newTimesheetRaidType').on('change', function() {
					var defaultRaidDuration = $(this).children('option:selected').attr('duration').split('|');
					$('#newRaidDurationHour').val(defaultRaidDuration[0]).removeClass('error');
					$('#newRaidDurationMinute').val(defaultRaidDuration[1]).removeClass('error');
				});
				
				
				$('#addTimesheetRaid').on(tapEvent, function() {
					timesheetItemWin.wait();
					var stat = true;
					
					$('#timesheetRaidForm').find('input, select').each(function(k, item) {
						if ($(item).val() == '' || $(item).val() == null) {
							$(item).addClass('error');
							stat = false;
						}
					});
					
					
					if (stat) {
						var newTHForm = new FormData($('#timesheetRaidForm')[0]);
							newTHForm.append('timesheet_raid[period]', thisPeriodId);
							newTHForm.append('timesheet_raid[static]', thisItem[0]);
							newTHForm.append('timesheet_raid[day]', thisItem[1]);
						
						$.ajax({
							type: 'POST',
							url: '/timesheet/add_timesheet_raid',
							dataType: 'json',
							cache: false,
							contentType: false,
							processData: false,
							data: newTHForm,
							success: function(response) {
								if (response) {
									getAjaxHtml('timesheet/get_timesheet_data', {period_id: thisPeriodId}, function(html) {
										$('#timesheetTable').html(html);
										$('#timesheetName').text(periodName);
										notify('Рейд успешно добавлен в расписание!');
										timesheetItemWin.close();
									}, function() {
										timesheetItemWin.wait(false);
									});
								} else {
									notify('Ошибка! Рейд не добавлен!', 'error');
								}
							},
							error: function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							}
						});
					} else {
						timesheetItemWin.wait(false);
						notify('Ошибка! Необходимо заполнить все поля!', 'error');
					}
					
				});
				
			}, 'html').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
			});
		});
	});
	
	
	
	
	
	//---------------------------------------------------------------- Редактировать рейд
	$('body').off(tapEvent, '[edittimesheetitem]').on(tapEvent, '[edittimesheetitem]', function() {
		var thisPeriodId = $('#timesheetPeriodId').val(),
			p = $(this).attr('edittimesheetitem').split('|'),
			updateTId = p[0],
			params = {
				'edit': 1,
				'edit_raid_id': p[1],
				'edit_time_start_h': p[2],
				'edit_time_start_m': p[3],
				'edit_duration_h': Math.floor(p[4] / 60),
				'edit_duration_m': p[4] % 60,
				'edit_raids': {}
			};
			
			$(this).closest('tr').find('[tdata]').each(function() {
				 var thisData = $(this).attr('tdata').split('|');
				 if (updateTId != thisData[1]) params['edit_raids'][thisData[0]] = thisData[1];
			});
			
		
		popUp({
			title: 'Редактировать рейд',
		    width: 600,
		    buttons: [{id: 'updateTimesheetRaid', title: 'Обновить', disabled: 1}],
		    closeButton: 'Отмена',
		}, function(timesheetItemWin) {
			$.post('/timesheet/edit_timesheet_raid', {params: params}, function(html) {
				timesheetItemWin.setData(html, false);
				$('#updateTimesheetRaid').prop('disabled', false);
				
				$('#newTimesheetRaidType').on('change', function() {
					var defaultRaidDuration = $(this).children('option:selected').attr('duration').split('|');
					$('#newRaidDurationHour').val(defaultRaidDuration[0]).removeClass('error');
					$('#newRaidDurationMinute').val(defaultRaidDuration[1]).removeClass('error');
				});
				
				
				$('#updateTimesheetRaid').on(tapEvent, function() {
					timesheetItemWin.wait();
					var stat = true;
					
					$('#timesheetRaidForm').find('input, select').each(function(k, item) {
						if ($(item).val() == '' || $(item).val() == null) {
							$(item).addClass('error');
							stat = false;
						}
					});
					
					if (stat) {
						var updateTHForm = new FormData($('#timesheetRaidForm')[0]);
						updateTHForm.append('timesheet_raid[id]', updateTId);
						
						$.ajax({
							type: 'POST',
							url: '/timesheet/update_timesheet_raid',
							dataType: 'json',
							cache: false,
							contentType: false,
							processData: false,
							data: updateTHForm,
							success: function(response) {
								if (response) {
									$.post('/timesheet/get_timesheet_data', {period_id: thisPeriodId}, function(html) {
										$('#timesheetTable').html(html);
										$('#timesheetName').text(periodName);
										notify('Рейд успешно добавлен в расписание!');
										timesheetItemWin.close();
									}).fail(function(e) {
										notify('Системная ошибка!', 'error');
										showError(e);
										timesheetItemWin.wait(false);
									});
								} else {
									notify('Ошибка! Рейд не добавлен!', 'error');
								}
							},
							error: function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							}
						});
					} else {
						timesheetItemWin.wait(false);
						notify('Ошибка! Необходимо заполнить все поля!', 'error');
					}
					
				});
				
			}, 'html').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
			});
		});
		
		
	});
	
	
	
	
	
	
	//---------------------------------------------------------------- Удалить рейд
	$('body').off(tapEvent, '[removetimesheetitem]').on(tapEvent, '[removetimesheetitem]', function() {
		var thisPeriodId = $('#timesheetPeriodId').val(),
			thisId = $(this).attr('removetimesheetitem');
		
		$.post('/timesheet/remove_timesheet_raid', {id: thisId}, function(response) {
			if (response) {
				$.post('/timesheet/get_timesheet_data', {period_id: thisPeriodId}, function(html) {
					$('#timesheetTable').html(html);
					$('#timesheetName').text(periodName);
					notify('Рейд успешно удален из расписания!');
				}).fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
				});
			} else {
				notify('Ошибка! Рейд не удален!', 'error');
			}
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
		
	});
});
//--></script>