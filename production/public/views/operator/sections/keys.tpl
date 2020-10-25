<div class="section" id="raidsSection">
	<div class="section__title">
		<h1>Ключи</h1>
	</div>
	
	<div class="section__buttons" id="sectionButtons">
		<input type="hidden" id="staticsCashKeysData" value="">
		<button id="setStaticsKeysCash" title="Бюджет статиков"><i class="fa fa-rub"></i></button>
		
		<input type="hidden" id="choosenPeriodKeysId" value="">
		<input type="hidden" id="patternPeriodKeysId" value="">
		<button id="periodsKeysButton" title="Периоды"><i class="fa fa-calculator"></i></button>
		
		<button id="setKeysReport" class="alt ml-5" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
		<button id="reportPatternsKeysButton" class="alt" title="Отчеты"><i class="fa fa-list-alt"></i></button>
		<button id="saveKeysCoefficients" class="alt" title="Сохранить значения" disabled><i class="fa fa-save"></i></button>
		
	</div>
	
	<div class="section__content" id="sectionContent">
		<div id="keysReport"></div>
	</div>
</div>







<script type="text/javascript"><!--
$(document).ready(function() {
	
	var currentPatternId = false;
	function getPeriodId() {
		return $('#patternPeriodKeysId').val() || $('#choosenPeriodKeysId').val();
	}
	
	
	// ------------------------Сформировать первый отчет
	$('body').off(tapEvent, '#setKeysReport').on(tapEvent, '#setKeysReport', function() {
		var staticsCash = $('#staticsCashKeysData').val(),
			periodId = $('#choosenPeriodKeysId').val(),
			stat = true;
		
		if (!staticsCash) {
			notify('Ошибка! Необходимо задать бюджет для статиков!', 'error');
			$('#setStaticsKeysCash').addClass('fail error');
			stat = false;
		}
		
		if (!periodId) {
			notify('Ошибка! Необходимо указать период!', 'error');
			$('#periodsKeysButton').addClass('fail error');
			stat = false;
		}
		
		if(stat) {
			contentWait();
			getAjaxHtml('operator/get_keys_report', {cash: staticsCash, period_id: periodId}, function(html) {
				$('#keysReport').html(html);
				$('.scroll').ddrScrollTable();
				$('[id^="tabstatic"]:first').addClass('active');
				$('[tabid^="tabstatic"]:first').addClass('visible');
			}, function() {
				contentWait(false);
			});
		}
	});
	
	
	
	
	
	
	// ---------------------------------- Задать бюджет статиков
	$('body').off(tapEvent, '#setStaticsKeysCash').on(tapEvent, '#setStaticsKeysCash', function() {
		$(this).removeClass('fail error');
		popUp({
			title: 'Задать бюджет статиков',
		    width: 300,
		    html: '<div id="staticsKeysCash"></div>',
		    buttons: [{id: 'setStaticsKeysCashButton', title: 'Задать бюджет'}],
		    closeButton: 'Отмена'
		}, function(staticsCashKeysWin) {
			staticsCashKeysWin.wait();
			
			var data = $('#staticsCashKeysData').val() || {};
			$.post('/operator/get_statics_to_cash', {set_keys_cash: data}, function(html) {
				if (html) {
					$('#staticsKeysCash').html(html);
					$('#staticsKeysCash').find('input').number(true, 0, '.', ' ');
					
					$('#setStaticsKeysCashButton').on(tapEvent, function() {
						var staticsKeysCash = {};
						$('#staticsKeysCash').find('input').each(function() {
							var staticId = $(this).attr('static'),
								staticValue = parseInt($(this).val());
							staticsKeysCash[staticId] = staticValue;
						});
						
						$('#staticsCashKeysData').val(JSON.stringify(staticsKeysCash));
						staticsCashKeysWin.close();
						$('#setStaticsKeysCash').addClass('done');
						notify('Бюджет статиков задан!');
					});
				} else {
					$('#staticsKeysCash').html('<p class="empty center">Нет данных</p>');
				}
				staticsCashKeysWin.wait(false);
				
			}, 'html').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
				staticsCashKeysWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	// ------------------------------------------------ Периоды
	$('body').off(tapEvent, '#periodsKeysButton').on(tapEvent, '#periodsKeysButton', function() {
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
					$('#choosenPeriodKeysId').val(thisId);
					$('#patternPeriodKeysId').val('');
					notify('Период выбран!');
					$('#periodsKeysButton').addClass('done');
					periodsWin.close();
				});
			}, function() {
				periodsWin.wait(false);
			});
		});
	});
	
	
	
	
	// ----------------------------- Открыть список сохраненных отчетов
	var reportPatternsKeysWin;
	$('body').off(tapEvent, '#reportPatternsKeysButton').on(tapEvent, '#reportPatternsKeysButton', function() {
		popUp({
			title: 'Сохраненные отчеты',
		    width: 400,
		    html: '<div id="reportPatternsKeysList"></div>'
		}, function(rPKWin) {
			reportPatternsKeysWin = rPKWin;
			reportPatternsKeysWin.wait();
			var html = '', limit = 5, offset = 0;
			
			getAjaxHtml('operator/get_keys_reports_patterns', {limit: limit, offset: offset}, function(html, stat) {
				if (!stat) $('#reportPatternsKeysList').html('Нет сохраненных отчетов!');
				else {
					$('#reportPatternsKeysList').html(html);
					if ($(html).find('table tbody tr').length == limit) {
						reportPatternsKeysWin.setButtons([{id: 'getEarlyPatterns', title: 'Показать более ранние'}]);
					}
				} 
			}, function() {
				reportPatternsKeysWin.wait(false);
			});	
			
			$('#getEarlyPatterns').on(tapEvent, function() {
				reportPatternsKeysWin.wait();
				offset += limit;
				getAjaxHtml('operator/get_keys_reports_patterns', {limit: limit, offset: offset}, function(html, stat) {
					if (stat) $('#reportPatternsKeysList').html(html);
					else {
						$('#getEarlyPatterns').prop('disabled', true);
						notify('Это самые последние сохраненные отчеты!', 'info');
					} 
				}, function() {
					reportPatternsKeysWin.wait(false);
				});
			});
		});
	});
	
	
	
	
	
	
	// ----------------------------- Сформировать первый отчет по паттерну
	$('body').off(tapEvent, '[patternkeyid]').on(tapEvent, '[patternkeyid]', function() {
		contentWait();
		reportPatternsKeysWin.wait();
		currentPatternId = $(this).attr('patternkeyid');
		var thisPatternPeriodId = $(this).attr('patternperiodid');
		
		getAjaxHtml('operator/get_keys_report', {pattern_id: currentPatternId}, function(html, stat) {
			if (stat) {
				$('#keysReport').html(html);
				$('[id^="tabstatic"]:first').addClass('active');
				$('[tabid^="tabstatic"]:first').addClass('visible');
				$('#patternPeriodKeysId').val(thisPatternPeriodId);
				$('#choosenPeriodKeysId').val('');
				$('.scroll').ddrScrollTable();
			} else {
				reportPatternsKeysWin.wait(false);
			}
		}, function() {
			reportPatternsKeysWin.close();
			contentWait(false);
		});
	});
	
	
	
	
	
	
	
	// --------------------------------------- Изменить статус выплаты участника
	$('body').off(tapEvent, '[paydonekey]').on(tapEvent, '[paydonekey]', function() {
		var thisItem = this,
			stat = $(thisItem).attr('paydonekey'),
			thisData = $(thisItem).attr('data').split('|'),
			patternId = thisData[0],
			staticId = thisData[1],
			userId = thisData[2],
			cash = thisData[3];
			
		$.post('/reports/change_paydone_key_stat', {
			stat: stat,
			pattern_id: patternId,
			static_id: staticId,
			user_id: userId,
			cash: cash
		}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('paydonekey', '0').removeClass('forbidden').addClass('success').attr('title', 'разрешен');
				} else {
					$(thisItem).attr('paydonekey', '1').removeClass('success').addClass('forbidden').attr('title', 'не разрешен');
				}
				notify('Статус изменен!');
			} else {
				notify('Ошибка изменения статуса!', 'error');
			}
			
			
			if ($(thisItem).closest('.report').find('[paydonekey].success').length > 0) {
				$(thisItem).closest('.report').find('[operatornewkey]').setAttrib('disabled');
				$(thisItem).closest('.report').find('[deleteraid]').setAttrib('disabled');
			} else {
				$(thisItem).closest('.report').find('[operatornewkey]').removeAttrib('disabled');
				$(thisItem).closest('.report').find('[deleteraid]').removeAttrib('disabled');
			}
			
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// --------------------------------------- Редактировать коэффициент
	$('body').off('keyup change', '[editkeykoeff]').on('keyup change', '[editkeykoeff]', function(e) {
		$(this).closest('td').addClass('changed');
		$('#saveKeysCoefficients').removeAttrib('disabled');
	});
	
	$('body').off('change', '[editkeytype]').on('change', '[editkeytype]', function(e) {
		$(this).closest('td').addClass('changed');
		$('#saveKeysCoefficients').removeAttrib('disabled');
	});
	
	
	
	// --------------------------------------- Сохранить измененные коэффициенты
	$('body').off(tapEvent, '#saveKeysCoefficients').on(tapEvent, '#saveKeysCoefficients', function() {
		contentWait();
		var params = {},
			koeffData = [],
			kTypesData = [];
			
		$('#sectionContent').find('[editkeykoeff]').each(function(k, item) {
			var data = $(item).attr('editkeykoeff').split('|'),
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
		
		$('#sectionContent').find('[editkeytype]').each(function(k, item) {
			var raidId = $(item).attr('editkeytype'),
				thisTypeId = $(item).val();
			kTypesData.push({
				id: raidId,
				type: thisTypeId,
			});
		});
		
		
		getAjaxHtml('operator/edit_key_data', {
			koeffs: koeffData,
			report: {
				cash: $('#staticsCashKeysData').val(),
				period_id: $('#choosenPeriodKeysId').val()
			},
			k_types: kTypesData
		}, function(html, stat) {
			$('#keysReport').html(html);
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
			$('#saveKeysCoefficients').setAttrib('disabled');
		}, function() {
			contentWait(false);
		});
	});
	
	
	
	
	
	
	
	
	// --------------------------------------- Удалить ключ
	$('body').off(tapEvent, '[deletekey]').on(tapEvent, '[deletekey]', function() {
		var raidId = $(this).attr('deletekey'),
			params = {};
			
		popUp({
			title: 'Удаление ключа',
		    width: 400,
		    height: false,
		    html: '<p>Вы действительно хотите удалить ключ?</p>',
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'deleteKey', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(deleteKeyWin) {
			
			$('#deleteKey').on(tapEvent, function() {	
				contentWait();
				deleteKeyWin.wait();
				if (currentPatternId) params = {raid_id: raidId, pattern_id: currentPatternId, is_key: 1};
				else params = {raid_id: raidId, cash: $('#staticsCashKeysData').val(), period_id: getPeriodId(), is_key: 1};
				getAjaxHtml('operator/delete_raid', params, function(html, stat) {
					if (stat) {
						$('#keysReport').html(html);
						
						var hashData = location.hash.split('.');
						if (hashData[1] != undefined) {
							$('#keysReport').find('.tabstitles li').removeClass('active');
							$('#keysReport').find('.tabstitles li#'+hashData[1]).addClass('active');
							
							$('#keysReport').find('.tabstitles').siblings('.tabscontent').find('[tabid]').removeClass('visible');
							$('#keysReport').find('.tabstitles').siblings('.tabscontent').find('[tabid="'+hashData[1]+'"]').addClass('visible');
						} else {
							$('#keysReport').find('.tabstitles li:first').addClass('active');
							$('#keysReport').find('.tabstitles').siblings('.tabscontent').find('[tabid]:first').addClass('visible');
						}
						
						notify('Ключ успешно удален!');
						deleteKeyWin.close();
					} else {
						notify('Ошибка удаления ключа!', 'error');
					}
				}, function() {
					deleteKeyWin.wait(false);
					contentWait(false);
				});
			});
		});
		
			
	});
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------------------------------------------- Создание ключа
	var newKeyWin;
	$('body').off(tapEvent, '[operatornewkey]').on(tapEvent, '[operatornewkey]', function() {
		var newKeyStatic = $(this).attr('operatornewkey'),
			newKeyPeriod = getPeriodId(),
			isReport = $(this).attr('report') == 1 ? true : false;
		
		popUp({
			title: 'Новый ключ',
		    width: 700,
		    winClass: 'account'
		}, function(nkWin) {
			newKeyWin = nkWin;
			newKeyWin.wait();			
			$.post('/operator/get_period', {period_id: newKeyPeriod}, function(period) {
				getAjaxHtml('account/get_new_key_data', {static: newKeyStatic, period: period}, function(html) {
					newKeyWin.setData(html);
					newKeyWin.setButtons([{id: 'addKey', title: "Создать ключ"}, {id: 'newKeyWinClose', title: "Отмена", cls: 'close'}]);
					
					
					$('#newKeyWinClose').on(tapEvent, function() {
						newKeyWin.close();
					});
					
					$('#raidStaticTabs').find('li').on(tapEvent, function() {
						setTimeout(function() {newKeyWin.correctPosition();}, 100);
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
					
					
					
					
					//---------------------------------------- Добавить ключ
					$('#addKey').on(tapEvent, function() {
						newKeyWin.wait();
						stat = true;
						
						if (!$('select[name="key_type"]').val()) {
							$('select[name="key_type"]').addClass('error');
							notify('Ошибка! Необходимо выбрать тип ключа', 'error');
							stat = false;
						} 
						
						/*if ($('#newRaidOrders').find('input[name*="key_orders"]').length < 2) {
							notify('Ошибка! Список заказов не может быть пустым!', 'error');
							$('#raidStaticOrders').addClass('error');
							stat = false;
						}*/
						
						
						if (stat) {
							var keyForm = new FormData($('#newKeyForm')[0]);
								keyForm.append('static_id', newKeyStatic);
							
							$.ajax({
								type: 'POST',
								url: '/account/add_key',
								dataType: 'json',
								cache: false,
								contentType: false,
								processData: false,
								data: keyForm,
								success: function(response) {
									if (response) {
										if (isReport) keysReportParams = {pattern_id: currentPatternId};
										else keysReportParams = {cash: $('#staticsCashKeysData').val(), period_id: getPeriodId()};
										
										getAjaxHtml('operator/get_keys_report', keysReportParams, function(html) {
											$('#keysReport').html(html);
											$('.scroll').ddrScrollTable();
										}, function() {
											notify('Ключ успешно добавлен!');
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
									newKeyWin.close();
								}
							});
						} else {
							newKeyWin.wait(false);
						}
					});
					
				}, function() {
					newKeyWin.wait(false);
				});
			}, 'json').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
				newKeyWin.wait(false);
			});
		});
	});
	
	
	
});
//--></script>