<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Статистика (доходы)</h2>
	</div>
	
	
	<ul class="tabstitles">
		<li id="tabStaticsAmount" class="active">Доход статиков</li>
		<li id="tabUsersAmount">Доход участников</li>
		<li id="tabRanksAmount">Доход званий</li>
		<li id="tabCalendar">Календарь отчетов</li>
	</ul>
	
	
	
	<div class="tabscontent">
		<div tabid="tabStaticsAmount" class="visible">
			<fieldset>
				<legend>Отчет</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<button id="staticsAmount" class="fieldheight" title="Сформировать отчет"><i class="fa fa-calculator"></i></button>
					</div>
				</div>
				
				
				<div id="staticsAmountReport" class="reports noborder"></div>
			</fieldset>
		</div>
		
		
		<div tabid="tabUsersAmount">
			<fieldset>
				<legend>Отчет</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<button id="usersAmount" class="fieldheight" title="Сформировать отчет"><i class="fa fa-calculator"></i></button>
					</div>
				</div>
				
				
				<div id="usersAmountReport" class="reports noborder"></div>
			</fieldset>
		</div>
		
		
		<div tabid="tabRanksAmount">
			<fieldset>
				<legend>Отчет</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<button id="ranksAmount" class="fieldheight" title="Сформировать отчет"><i class="fa fa-calculator"></i></button>
					</div>
				</div>
				
				
				<div id="ranksAmountReport" class="reports noborder"></div>
			</fieldset>
		</div>
		
		
		<div tabid="tabCalendar">
			<div id="calendarGrid"></div>
		</div>
	</div>
</div>








<script type="text/javascript"><!--
	
	
	//------------------------------------------------------------------------------------------------ Доход статиков
	$('#staticsAmount').on(tapEvent, function() {
		popUp({
			title: 'Доход статиков',
		    width: 500,
		    wrapToClose: true,
		    buttons: [{id: 'sAChooseStatics', title: 'Выбрать', disabled: 1}],
		    closeButton: 'Закрыть',
		}, function(staticsAmountWin) {
			staticsAmountWin.wait();
			getAjaxHtml('admin/statistics/get_statics', {}, function(html) {
				staticsAmountWin.setData(html, false, function() {
					$('#staticsAmountList').ddrScrollTableY('400px');
				});
				
				
				$('#staticsAmountSetAll').on(tapEvent, function() {
					$('#staticsAmountList').find('input[type="checkbox"]:not(:checked)').each(function() {
						$(this).setAttrib('checked');
					});
					$('#sAChooseStatics:disabled').removeAttrib('disabled');
				});
				
				
				$('#staticsAmountList').find('input[type="checkbox"]').on(tapEvent, function() {
					let checkedLength = $('#staticsAmountList').find('input[type="checkbox"]:checked').length;
					if (checkedLength) $('#sAChooseStatics:disabled').removeAttrib('disabled');
					else $('#sAChooseStatics:not(:disabled)').setAttrib('disabled');
				});
				
				
				$('#sAChooseStatics').on(tapEvent, function() {
					let choosedStatics = [];
					$('#staticsAmountList').find('input[type="checkbox"]:checked').each(function() {
						choosedStatics.push(parseInt($(this).val()));
					});
					
					staticsAmountWin.wait();
					getAjaxHtml('admin/statistics/get_reports', {}, function(html) {
						staticsAmountWin.setButtons([{id: 'sAChooseReports', title: 'Выбрать', disabled: 1}], 'Закрыть');
						staticsAmountWin.setData(html, false, function() {
							$('#reportsAmountList').ddrScrollTableY('400px');
						});
						
						
						$('#reportsAmountType').on('change', function() {
							staticsAmountWin.wait();
							let type = $(this).val();
							if (type == 0) {
								$('#reportsAmountList').find('tbody').children('tr[hidden]').removeAttrib('hidden');
							} else {
								$('#reportsAmountList').find('tbody').children('tr:not([hidden])').setAttrib('hidden');
								$('#reportsAmountList').find('tbody').children('tr[type="'+type+'"]').removeAttrib('hidden');
							}
							staticsAmountWin.wait(false);
						});
						
						$('#reportsAmountSetAll').on(tapEvent, function() {
							$('#reportsAmountList').find('tr:not([hidden])').each(function() {
								$(this).find('input[type="checkbox"]:not(:checked)').setAttrib('checked');
							});
							$('#sAChooseReports:disabled').removeAttrib('disabled');
						});
						
						
						$('#reportsAmountList').find('input[type="checkbox"]').on(tapEvent, function() {
							let checkedLength = $('#reportsAmountList').find('input[type="checkbox"]:checked').length;
							if (checkedLength) $('#sAChooseReports:disabled').removeAttrib('disabled');
							else $('#sAChooseReports:not(:disabled)').setAttrib('disabled');
						});
						
						
						$('#sAChooseReports').on(tapEvent, function() {
							staticsAmountWin.wait();
							let choosedReports = [];
							$('#reportsAmountList').find('input[type="checkbox"]:checked').each(function() {
								choosedReports.push(parseInt($(this).val()));
							});
							
							
							getAjaxHtml('admin/statistics/statics_amount_report', {statics: choosedStatics, reports: choosedReports}, function(html) {
								$('#staticsAmountReport').html(html);
								$('#staticsAmountReport').find('.scroll').ddrScrollTable();
								staticsAmountWin.close();
							}, function() {
								staticsAmountWin.wait(false);
							});
						});
						
					}, function() {
						staticsAmountWin.wait(false);
					});
				});
				
			}, function() {
				staticsAmountWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Доход участников
	$('#usersAmount').on(tapEvent, function() {
		
		usersManager({
			chooseType: 'multiple',
			returnFields: 'nickname avatar static_name static_icon',
			onChoose: function(users, uMWin) {
				getAjaxHtml('admin/calendar/get_table', function(html) {
					uMWin.setButtons([{id: 'uAChooseMonthes', title: 'Выбрать', disabled: 1}], 'Закрыть');
					uMWin.setData(html);
					uMWin.setWidth(900);
					uMWin.setTitle('Доход участников');
					
					
					$('#calendarPopup').find('input[type="checkbox"]').on(tapEvent, function() {
						let checkedLength = $('#calendarPopup').find('input[type="checkbox"]:checked').length;
						if (checkedLength) $('#uAChooseMonthes:disabled').removeAttrib('disabled');
						else $('#uAChooseMonthes:not(:disabled)').setAttrib('disabled');
					});
					
					$('#uAChooseMonthes').on(tapEvent, function() {
						uMWin.wait();
						let choosedMonthes = [];
						$('#calendarPopup').find('input[type="checkbox"]:checked').each(function() {
							choosedMonthes.push(parseInt($(this).val()));
						});
						
						getAjaxHtml('admin/statistics/users_amount_report', {users: users, timepoints: choosedMonthes}, function(html) {
							$('#usersAmountReport').html(html);
							$('#usersAmountReport').find('.scroll').ddrScrollTable();
							uMWin.close();
						}, function() {
							uMWin.wait(false);
						});
					});
				}, function() {
					uMWin.wait(false);
				});
			}
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Доход по званиям
	$('#ranksAmount').on(tapEvent, function() {
		popUp({
			title: 'Доход по званиям',
		    width: 500,
		    wrapToClose: true,
		    buttons: [{id: 'sAChooseStatics', title: 'Выбрать', disabled: 1}],
		    closeButton: 'Закрыть',
		}, function(ranksAmountWin) {
			ranksAmountWin.wait();
			getAjaxHtml('admin/statistics/get_statics', {}, function(html) {
				ranksAmountWin.setData(html, false, function() {
					$('#staticsAmountList').ddrScrollTableY('400px');
				});
				
				
				$('#staticsAmountSetAll').on(tapEvent, function() {
					$('#staticsAmountList').find('input[type="checkbox"]:not(:checked)').each(function() {
						$(this).setAttrib('checked');
					});
					$('#sAChooseStatics:disabled').removeAttrib('disabled');
				});
				
				
				$('#staticsAmountList').find('input[type="checkbox"]').on(tapEvent, function() {
					let checkedLength = $('#staticsAmountList').find('input[type="checkbox"]:checked').length;
					if (checkedLength) $('#sAChooseStatics:disabled').removeAttrib('disabled');
					else $('#sAChooseStatics:not(:disabled)').setAttrib('disabled');
				});
				
				
				$('#sAChooseStatics').on(tapEvent, function() {
					ranksAmountWin.wait();
					let choosedStatics = [];
					$('#staticsAmountList').find('input[type="checkbox"]:checked').each(function() {
						choosedStatics.push(parseInt($(this).val()));
					});
					
					getAjaxHtml('admin/statistics/get_ranks', {statics: choosedStatics}, function(html) {
						ranksAmountWin.setButtons([{id: 'rAChooseRanks', title: 'Выбрать', disabled: 1}], 'Закрыть');
						ranksAmountWin.setData(html, false, function() {
							$('#ranksAmountList').ddrScrollTableY('400px');
						});
						
						$('#ranksAmountSetAll').on(tapEvent, function() {
							$('#ranksAmountList').find('input[type="checkbox"]:not(:checked)').each(function() {
								$(this).setAttrib('checked');
							});
							$('#rAChooseRanks:disabled').removeAttrib('disabled');
						});
						
						
						$('#ranksAmountList').find('input[type="checkbox"]').on(tapEvent, function() {
							let checkedLength = $('#ranksAmountList').find('input[type="checkbox"]:checked').length;
							if (checkedLength) {
								$('#rAChooseRanks:disabled').removeAttrib('disabled');
							} else {
								$('#rAChooseRanks:not(:disabled)').setAttrib('disabled');
							}
						});
						
						
						$('#rAChooseRanks').on(tapEvent, function() {
							ranksAmountWin.wait();
							let choosedRanks = [];
							$('#ranksAmountList').find('input[type="checkbox"]:checked').each(function() {
								choosedRanks.push(parseInt($(this).val()));
							});
							
							
							getAjaxHtml('admin/calendar/get_table', function(html) {
								ranksAmountWin.setButtons([{id: 'rAChooseMonthes', title: 'Выбрать', disabled: 1}], 'Закрыть');
								ranksAmountWin.setData(html);
								ranksAmountWin.setWidth(900);
								
								$('#calendarPopup').find('input[type="checkbox"]').on(tapEvent, function() {
									let checkedLength = $('#calendarPopup').find('input[type="checkbox"]:checked').length;
									if (checkedLength) $('#rAChooseMonthes:disabled').removeAttrib('disabled');
									else $('#rAChooseMonthes:not(:disabled)').setAttrib('disabled');
								});
								
								$('#rAChooseMonthes').on(tapEvent, function() {
									ranksAmountWin.wait();
									let choosedMonthes = [];
									$('#calendarPopup').find('input[type="checkbox"]:checked').each(function() {
										choosedMonthes.push(parseInt($(this).val()));
									});
									
									
									getAjaxHtml('admin/statistics/ranks_amount_report', {ranks: choosedRanks, statics: choosedStatics, timepoints: choosedMonthes}, function(html) {
										$('#ranksAmountReport').html(html);
										$('#ranksAmountReport').find('.scroll').ddrScrollTable();
										ddrInitTabs();
										ranksAmountWin.close();
									}, function() {
										ranksAmountWin.wait(false);
									});
								});
							}, function() {
								ranksAmountWin.wait(false);
							});
							
							
							
							
						});
						
						
						
						
					}, function() {
						ranksAmountWin.wait(false);
					});
				});
				
				
				
				
			}, function() {
				ranksAmountWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Календарь
	let hashData = location.hash.split('.'),
		isCalendarLoaded = false;
	if (hashData[1] != undefined && hashData[1] == 'tabCalendar') {
		getCalendar(function() {
			isCalendarLoaded = true;
		});
	}

	$(document).on('changetabs', function(_, elem) {
		let id = $(elem).attr('id');
		
		if (id == 'tabCalendar' && !isCalendarLoaded) {
			getCalendar(function() {
				isCalendarLoaded = true;
			});
		}
	});
	
	
	function getCalendar(callback) {
		$('#sectionWait').addClass('visible');
		getAjaxHtml('admin/calendar/get_calendar', function(html) {
			$('#calendarGrid').html(html);
			ddrInitTabs();
			$('#sectionWait').removeClass('visible');
			
			
			$('[calendaraddreport]').on(tapEvent, function() {
				let thisBlock = $(this).closest('.calendar__item'),
					reportsList = $(this).closest('.calendar__column').find('[calendarreportslist]'),
					d = $(this).attr('calendaraddreport').split('|'),
					reportType = d[0],
					tPoint = d[1];
				
				popUp({
					title: 'Добавить отчеты',
				    width: 500,
				    buttons: [{id: 'calendarAddReport', title: 'Выбрать', disabled: 1}],
				    closeButton: 'Отмена',
				}, function(addreportWin) {
					addreportWin.wait();
					getAjaxHtml('admin/statistics/get_calendar_reports', {type: reportType}, function(html) {
						addreportWin.setData(html);
						$('#reportsAmountList').ddrScrollTableY('400px');
						
						$('#reportsAmountType').on('change', function() {
							addreportWin.wait();
							let type = $(this).val();
							if (type == 0) {
								$('#reportsAmountList').find('tbody').children('tr[hidden]').removeAttrib('hidden');
							} else {
								$('#reportsAmountList').find('tbody').children('tr:not([hidden])').setAttrib('hidden');
								$('#reportsAmountList').find('tbody').children('tr[type="'+type+'"]').removeAttrib('hidden');
							}
							addreportWin.wait(false);
						});
						
						$('#reportsAmountSetAll').on(tapEvent, function() {
							$('#reportsAmountList').find('tr:not([hidden])').each(function() {
								$(this).find('input[type="checkbox"]:not(:checked)').setAttrib('checked');
							});
							$('#calendarAddReport:disabled').removeAttrib('disabled');
						});
						
						
						$('#reportsAmountList').find('input[type="checkbox"]').on(tapEvent, function() {
							let checkedLength = $('#reportsAmountList').find('input[type="checkbox"]:checked').length;
							if (checkedLength) {
								$('#calendarAddReport:disabled').removeAttrib('disabled');
							} else {
								$('#calendarAddReport:not(:disabled)').setAttrib('disabled');
							}
						});
						
						
						$('#calendarAddReport').on(tapEvent, function() {
							addreportWin.wait();
							let choosedReports = {};
							$('#reportsAmountList').find('input[type="checkbox"]:checked').each(function() {
								choosedReports[parseInt($(this).val())] = $(this).closest('tr').find('p').text();
							});
							
							if (choosedReports) {
								$.post('/admin/calendar/add_reports', {type: reportType, timepoint: tPoint, reports: Object.keys(choosedReports)}, function(response) {
									if (response) {
										let addList = '';
										$.each(choosedReports, function(reportId, reporTitle) {
											addList += '<li>';
											addList += 	'<span>'+reporTitle+'</span>';
											addList += 	'<i calendarremovereport="'+reportType+'|'+tPoint+'|'+reportId+'" class="fa fa-trash"></i>';
											addList += '</li>';
										});
										$(reportsList).append(addList);
										notify('Отчеты успешно добавлены!');
										
									} else {
										notify('Не удалось добавить отчеты!', 'error');
									}
									addreportWin.close();
								});		
							}
						});
						
					}, function() {
						addreportWin.wait(false);
					});
				});
			});
			
			
			
			
			
			$('#calendarGrid').on(tapEvent, '[calendarremovereport]', function() {
				let thisRow = $(this).closest('li'),
					thidGridItem = $(this).closest('.calendar__item'),
					d = $(this).attr('calendarremovereport').split('|'),
					type = d[0],
					timePoint = d[1],
					reoprtId = d[2];
				
				waitCalendarItem(thidGridItem);
				$.post('/admin/calendar/remove_report', {type: type, timepoint: timePoint, report: reoprtId}, function(response) {
					if (response) {
						$(thisRow).remove();
						notify('Отчет успешно удален!');
					} else {
						notify('Не удалось удалить отчет!', 'error');
					}
					waitCalendarItem(thidGridItem, false);
				});
			});
			
			
			
			
			function waitCalendarItem(selector, stat) {
				if (stat == undefined) {
					$(selector).append('<div calendarwait class="calendar__waiting calendar__waiting_visible"><i class="fa fa-spinner fa-pulse fa-fw"></i></div>');
				} else if (stat === false)  {
					$(selector).find('[calendarwait]').removeClass('calendar__waiting_visible');
					setTimeout(function() {
						$(selector).find('[calendarwait]').remove();
					}, 160);
				}
			}
			
			
		}, function() {
			if (callback && typeof callback == 'function') {
				callback();
			}
		});
	}
	
	
	
//--></script>