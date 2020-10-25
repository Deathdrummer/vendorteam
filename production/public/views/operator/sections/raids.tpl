<div class="section" id="raidsSection">
	<div class="section__title">
		<h1>Рейды</h1>
	</div>
	
	<div class="section__buttons" id="sectionButtons">
		<input type="hidden" id="staticsCashData" value="">
		<button id="setStaticsCash" title="Бюджет статиков"><i class="fa fa-rub"></i></button>
		
		<input type="hidden" id="choosenPeriodId" value="">
		<input type="hidden" id="patternPeriodId" value="">
		<button id="periodsButton" title="Периоды"><i class="fa fa-calculator"></i></button>
		
		<button id="setMainReport" class="alt ml-5" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
		<button id="reportPatternsButton" class="alt" title="Отчеты"><i class="fa fa-list-alt"></i></button>
		<button id="saveCoefficients" class="alt" title="Сохранить значения" disabled><i class="fa fa-save"></i></button>
		
	</div>
	
	<div class="section__content" id="sectionContent">
		<div id="mainReport"></div>
	</div>
</div>







<script type="text/javascript"><!--
$(document).ready(function() {
	
	var currentPatternId = false;
	function getPeriodId() {
		return $('#patternPeriodId').val() || $('#choosenPeriodId').val();
	}
	
	
	// ------------------------Сформировать первый отчет
	$('body').off(tapEvent, '#setMainReport').on(tapEvent, '#setMainReport', function() {
		var staticsCash = $('#staticsCashData').val(),
			periodId = $('#choosenPeriodId').val(),
			stat = true;
		
		if (!staticsCash) {
			notify('Ошибка! Необходимо задать бюджет для статиков!', 'error');
			$('#setStaticsCash').addClass('fail error');
			stat = false;
		}
		
		if (!periodId) {
			notify('Ошибка! Необходимо указать период!', 'error');
			$('#periodsButton').addClass('fail error');
			stat = false;
		}
		
		if(stat) {
			contentWait();
			getAjaxHtml('operator/get_main_report', {cash: staticsCash, period_id: periodId}, function(html) {
				$('#mainReport').html(html);
				$('[id^="tabstatic"]:first').addClass('active');
				$('[tabid^="tabstatic"]:first').addClass('visible');
				$('.scroll').ddrScrollTable();
			}, function() {
				contentWait(false);
			});
		}
	});
	
	
	
	
	
	
	// ---------------------------------- Задать бюджет статиков
	$('body').off(tapEvent, '#setStaticsCash').on(tapEvent, '#setStaticsCash', function() {
		$(this).removeClass('fail error');
		popUp({
			title: 'Задать бюджет статиков',
		    width: 300,
		    html: '<div id="staticsCash"></div>',
		    buttons: [{id: 'setStaticsCashButton', title: 'Задать бюджет'}],
		    closeButton: 'Отмена'
		}, function(staticsCashWin) {
			staticsCashWin.wait();
			
			var data = $('#staticsCashData').val() || {};
			$.post('/operator/get_statics_to_cash', {set_cash: data}, function(html) {
				if (html) {
					$('#staticsCash').html(html);
					$('#staticsCash').find('input').number(true, 0, '.', ' ');
					
					$('#setStaticsCashButton').on(tapEvent, function() {
						var staticsCash = {};
						$('#staticsCash').find('input').each(function() {
							var staticId = $(this).attr('static'),
								staticValue = parseInt($(this).val());
							staticsCash[staticId] = staticValue;
						});
						$('#staticsCashData').val(JSON.stringify(staticsCash));
						staticsCashWin.close();
						$('#setStaticsCash').addClass('done');
						notify('Бюджет статиков задан!');
					});
				} else {
					$('#staticsCash').html('<p class="empty center">Нет данных</p>');
				}
				staticsCashWin.wait(false);
				
			}, 'html').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
				staticsCashWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	// ------------------------------------------------ Периоды
	$('body').off(tapEvent, '#periodsButton').on(tapEvent, '#periodsButton', function() {
		$(this).removeClass('error fail');
		popUp({
			title: 'Периоды',
		    width: 400
		}, function(periodsWin) {
			periodsWin.wait();
			
			getAjaxHtml('operator/get_reports_periods', function(html, stat) {
				if (stat) periodsWin.setData(html);
				else {
					periodsWin.setData('<p class="empty">Нет периодов!</p>');
				}
				
				$('[chooseperiod]').on(tapEvent, function() {
					var thisId = $(this).attr('chooseperiod');
					$('#choosenPeriodId').val(thisId);
					$('#patternPeriodId').val('');
					notify('Период выбран!');
					$('#periodsButton').addClass('done');
					periodsWin.close();
				});
			}, function() {
				periodsWin.wait(false);
			});
		});
	});
	
	
	
	
	// ----------------------------- Открыть список паттернов первого отчета
	var reportPatternsWin;
	$('body').off(tapEvent, '#reportPatternsButton').on(tapEvent, '#reportPatternsButton', function() {
		popUp({
			title: 'Сохраненные отчеты',
		    width: 400,
		    html: '<div id="reportPatternsList"></div>'
		}, function(rPWin) {
			reportPatternsWin = rPWin;
			reportPatternsWin.wait();
			var html = '', limit = 5, offset = 0;
			
			getAjaxHtml('operator/get_main_reports_patterns', {limit: limit, offset: offset}, function(html, stat) {
				if (!stat) $('#reportPatternsList').html('Нет сохраненных отчетов!');
				else {
					$('#reportPatternsList').html(html);
					if ($(html).find('table tbody tr').length == limit) {
						reportPatternsWin.setButtons([{id: 'getEarlyPatterns', title: 'Показать более ранние'}]);
					}
				} 
			}, function() {
				reportPatternsWin.wait(false);
			});	
			
			$('#getEarlyPatterns').on(tapEvent, function() {
				reportPatternsWin.wait();
				offset += limit;
				getAjaxHtml('operator/get_main_reports_patterns', {limit: limit, offset: offset}, function(html, stat) {
					if (stat) $('#reportPatternsList').html(html);
					else {
						$('#getEarlyPatterns').prop('disabled', true);
						notify('Это самые последние сохраненные отчеты!', 'info');
					} 
				}, function() {
					reportPatternsWin.wait(false);
				});
			});
		});
	});
	
	
	
	
	
	
	// ----------------------------- Сформировать первый отчет по паттерну
	$('body').off(tapEvent, '[patternid]').on(tapEvent, '[patternid]', function() {
		contentWait();
		reportPatternsWin.wait();
		currentPatternId = $(this).attr('patternid');
		var thisPatternPeriodId = $(this).attr('patternperiodid');
		
		getAjaxHtml('operator/get_main_report', {pattern_id: currentPatternId}, function(html, stat) {
			if (stat) {
				$('#mainReport').html(html);
				$('[id^="tabstatic"]:first').addClass('active');
				$('[tabid^="tabstatic"]:first').addClass('visible');
				$('#patternPeriodId').val(thisPatternPeriodId);
				$('#choosenPeriodId').val('');
				$('.scroll').ddrScrollTable();
			} else {
				reportPatternsWin.wait(false);
			}
		}, function() {
			reportPatternsWin.close();
			contentWait(false);
		});
	});
	
	
	
	
	
	
	
	// --------------------------------------- Изменить статус выплаты участника
	$('body').off(tapEvent, '[paydone]').on(tapEvent, '[paydone]', function() {
		var thisItem = this,
			stat = $(thisItem).attr('paydone'),
			thisData = $(thisItem).attr('data').split('|'),
			patternId = thisData[0],
			staticId = thisData[1],
			userId = thisData[2],
			toDeposit = thisData[3];
			
		$.post('/reports/change_paydone_stat', {
			stat: stat,
			pattern_id: patternId,
			static_id: staticId,
			user_id: userId,
			to_deposit: toDeposit
		}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('paydone', '0').removeClass('forbidden').addClass('success').attr('title', 'разрешен');
				} else {
					$(thisItem).attr('paydone', '1').removeClass('success').addClass('forbidden').attr('title', 'не разрешен');
				}
				notify('Статус изменен!');
			} else {
				notify('Ошибка изменения статуса!', 'error');
			}
			
			
			if ($(thisItem).closest('.report').find('[paydone].success').length > 0) {
				$(thisItem).closest('.report').find('[operatornewraid]').setAttrib('disabled');
				$(thisItem).closest('.report').find('[deleteraid]').setAttrib('disabled');
			} else {
				$(thisItem).closest('.report').find('[operatornewraid]').removeAttrib('disabled');
				$(thisItem).closest('.report').find('[deleteraid]').removeAttrib('disabled');
			}
			
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('body').off('keyup change', '[editraidkoeff]').on('keyup change', '[editraidkoeff]', function(e) {
		$(this).closest('td').addClass('changed');
		$('#saveCoefficients').removeAttrib('disabled');
	});
	
	$('body').off('change', '[editraidtype]').on('change', '[editraidtype]', function(e) {
		$(this).closest('td').addClass('changed');
		$('#saveCoefficients').removeAttrib('disabled');
	});
	
	
	
	
	$('body').off(tapEvent, '#saveCoefficients').on(tapEvent, '#saveCoefficients', function() {
		contentWait();
		var params = {},
			koeffData = [],
			rTypesData = [];
			
		$('#sectionContent').find('[editraidkoeff]').each(function(k, item) {
			var data = $(item).attr('editraidkoeff').split('|'), // id | user_id | raid_id 
				rate = $(item).val();
			
			if (data[0]) {
				koeffData.push({
					id: data[0],
					user_id: data[1],
					raid_id: data[2],
					rate: rate
				});	
			}
		});
		
		$('#sectionContent').find('[editraidtype]').each(function(k, item) {
			var raidId = $(item).attr('editraidtype'),
				thisTypeId = $(item).val();
			rTypesData.push({
				id: raidId,
				type: thisTypeId,
			});
		});
		
		
		getAjaxHtml('operator/edit_raid_data', {
			koeffs: koeffData,
			report: {
				cash: $('#staticsCashData').val(),
				period_id: $('#choosenPeriodId').val()
			},
			r_types: rTypesData
		}, function(html, stat) {
			$('#mainReport').html(html);
			$('.scroll').ddrScrollTable();
			
			var tabStatic = location.hash.split('.');
			if (tabStatic.length > 1) {
				tabStatic = tabStatic.pop();
				$('[id="'+tabStatic+'"]').addClass('active');
				$('[tabid="'+tabStatic+'"]').addClass('visible');
			} else {
				$('[id^="tabstatic"]:first').addClass('active');
				$('[tabid^="tabstatic"]:first').addClass('visible');
			}
			
			if (stat) notify('Данные сохранены!');
			else notify('Ошибка сохранения данных!', 'error');
			contentWait(false);
			$('#saveCoefficients').setAttrib('disabled');
		}, function() {
			contentWait(false);
		});
	});
	
	
	
	
	
	
	
	
	
	$('body').off(tapEvent, '[deleteraid]').on(tapEvent, '[deleteraid]', function() {
		var raidId = $(this).attr('deleteraid'),
			params = {};
			
		popUp({
			title: 'Удаление рейда',
		    width: 400,
		    height: false,
		    html: '<p>Вы действительно хотите удалить рейд?</p>',
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'deleteRaid', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(deleteRaidWin) {
			
			$('#deleteRaid').on(tapEvent, function() {	
				contentWait();
				deleteRaidWin.wait();
				if (currentPatternId) params = {raid_id: raidId, pattern_id: currentPatternId, is_key: 0};
				else params = {raid_id: raidId, cash: $('#staticsCashData').val(), period_id: getPeriodId(), is_key: 0};
				
				getAjaxHtml('operator/delete_raid', params, function(html, stat) {
					if (stat) {
						$('#mainReport').html(html);
						
						var hashData = location.hash.split('.');
						if (hashData[1] != undefined) {
							$('#mainReport').find('.tabstitles li').removeClass('active');
							$('#mainReport').find('.tabstitles li#'+hashData[1]).addClass('active');
							
							$('#mainReport').find('.tabstitles').siblings('.tabscontent').find('[tabid]').removeClass('visible');
							$('#mainReport').find('.tabstitles').siblings('.tabscontent').find('[tabid="'+hashData[1]+'"]').addClass('visible');
						} else {
							$('#mainReport').find('.tabstitles li:first').addClass('active');
							$('#mainReport').find('.tabstitles').siblings('.tabscontent').find('[tabid]:first').addClass('visible');
						}
						
						notify('Рейд успешно удален!');
						deleteRaidWin.close();
					} else {
						notify('Ошибка удаления рейда!', 'error');
					}
				}, function() {
					deleteRaidWin.wait(false);
					contentWait(false);
				});
			});
		});
		
			
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------------------- Создание рейда
	var newRaidWin;
	$('body').off(tapEvent, '[operatornewraid]').on(tapEvent, '[operatornewraid]', function() {
		var newRaidStatic = $(this).attr('operatornewraid'),
			newRaidPeriod = getPeriodId(),
			isReport = $(this).attr('report') == 1 ? true : false;
		
		popUp({
			title: 'Новый рейд',
		    width: 700,
		    winClass: 'account'
		}, function(nrWin) {
			newRaidWin = nrWin;
			newRaidWin.wait();			
			$.post('/operator/get_period', {period_id: newRaidPeriod}, function(period) {
				getAjaxHtml('account/get_new_raid_data', {static: newRaidStatic, period: period}, function(html) {
					newRaidWin.setData(html);
					newRaidWin.setButtons([{id: 'addRaid', title: "Создать рейд"}, {id: 'newRaidWinClose', title: "Отмена", cls: 'close'}]);
					
					
					$('#newRaidWinClose').on(tapEvent, function() {
						newRaidWin.close();
					});
					
					$('#raidStaticTabs').find('li').on(tapEvent, function() {
						setTimeout(function() {newRaidWin.correctPosition();}, 100);
					});
					
					
					$('[tabid="raidStaticOrders"]').on('keydown', '.popup__table tbody tr:last input[type="text"]', function() {
						if ($(this).val().length == 0) {
							var newIndex = $('[tabid="raidStaticOrders"]').find('.popup__table tbody tr').length,
								rowHtml = '';
								rowHtml += '<tr>';
								rowHtml += 	'<td><p>Заказ '+(newIndex + 1)+'</p></td>';
								rowHtml += 	'<td><div class="popup__field"><input type="text" autocomplete="off" name="raid_orders['+newIndex+']"></div></td>';
								rowHtml += '</tr>';
							$('[tabid="raidStaticOrders"]').find('.popup__table tbody').append(rowHtml);
						}
					});
					
					$('[tabid="raidStaticUsers"]').on('change', 'input[type="checkbox"]', function() {
						var thisStat = $(this).is(':checked'),
							thisRow = $(this).closest('tr');
							
						if (thisStat) {
							$(thisRow).find('input[type="number"]').val('1');
						} else {
							$(thisRow).find('input[type="number"]').val('0');
						}
					});
					
					
					
					
					//---------------------------------------- Добавить рейд
					$('#addRaid').on(tapEvent, function() {
						newRaidWin.wait();
						stat = true;
						
						if (!$('select[name="raid_type"]').val()) {
							$('select[name="raid_type"]').addClass('error');
							notify('Ошибка! Необходимо выбрать тип рейда', 'error');
							stat = false;
						} 
						
						if ($('#newRaidOrders').find('input[name*="raid_orders"]').length < 2) {
							notify('Ошибка! Список заказов не может быть пустым!', 'error');
							$('#raidStaticOrders').addClass('error');
							stat = false;
						}
						
						
						if (stat) {
							var raidForm = new FormData($('#newRaidForm')[0]);
								raidForm.append('static_id', newRaidStatic);
							
							$.ajax({
								type: 'POST',
								url: '/account/add_raid',
								dataType: 'json',
								cache: false,
								contentType: false,
								processData: false,
								data: raidForm,
								success: function(response) {
									if (response) {
										if (isReport) mainReportParams = {pattern_id: currentPatternId};
										else mainReportParams = {cash: $('#staticsCashData').val(), period_id: getPeriodId()};
										
										getAjaxHtml('operator/get_main_report', mainReportParams, function(html) {
											$('#mainReport').html(html);
											$('.scroll').ddrScrollTable();
										}, function() {
											notify('Рейд успешно добавлен!');
										});
									} else {
										notify('Ошибка сохранения данных', 'error');
									}
								},
								error: function(e) {
									notify('Ошибка сохранения данных', 'error');
									showError(e);
								},
								complete: function() {
									newRaidWin.close();
								}
							});
						} else {
							newRaidWin.wait(false);
						}
					});
					
				}, function() {
					newRaidWin.wait(false);
				});
			}, 'json').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
				newRaidWin.wait(false);
			});
		});
	});
	
	
	
});
//--></script>