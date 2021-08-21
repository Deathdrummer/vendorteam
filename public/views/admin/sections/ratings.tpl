<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Рейтинги</h2>
	</div>
	
	
	
	<ul class="tabstitles">
		<li id="tabReport" class="active">Отчет</li>
		<li id="tabEvents">Форс мажор, Выговоры, Стимулирование</li>
		<li id="tabHistory">История операций</li>
		<li id="tabStatistics">Статистика заполнения коэффициентов</li>
	</ul>
	
	
	
	<div class="tabscontent">
		<div tabid="tabReport" class="visible">
			<fieldset>
				<legend>Отчет</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<button id="ratingPeriods" class="fieldheight" title="Периоды"><i class="fa fa-calculator"></i></button>
					</div>
				</div>
				
				<div class="item inline">
					<div class="buttons notop">
						<button id="ratingPeriodsSave"disabled class="fieldheight alt" title="Сохранить данные периода"><i class="fa fa-save"></i></button>
					</div>
				</div>
				<div class="item inline"><h3 id="ratingsReportTitle"></h3></div>
				
				
				<div id="ratingsReport" class="reports noborder"></div>
			</fieldset>
		</div>
		
		
		<div tabid="tabEvents">
			<fieldset class="mb-3">
				<legend>Поиск по участнику</legend>
				<div class="item inline">
					<div class="field w300px">
						<input type="text" id="searchEventsField" placeholder="Введите никнейм">
					</div>
				</div>
				<div class="item inline">
					<div class="buttons notop">
						<button id="setSearchFromEvents">Поиск</button>
						<button class="remove" disabled id="resetSearchFromEvents">Сбросить</button>
					</div>
				</div>
				{#<div class="item inline right">
					<div class="buttons notop">
						<button eventsoffset="prev" title="Назад" disabled><i class="fa fa-angle-up"></i></button>
						<button eventsoffset="next" title="Далее"><i class="fa fa-angle-down"></i></button>
					</div>
				</div>#}
			</fieldset>
			
			<div id="eventsList"></div>
		</div>
		
		<div tabid="tabHistory">
			<fieldset class="mb-3">
				<legend>Поиск по участнику</legend>
				<div class="item inline">
					<div class="field w300px">
						<input type="text" id="searchHistoryField" placeholder="Введите никнейм">
					</div>
				</div>
				<div class="item inline">
					<div class="buttons notop">
						<button id="setSearchFromHistory">Поиск</button>
						<button class="remove" disabled id="resetSearchFromHistory">Сбросить</button>
					</div>
				</div>
				<div class="item inline right">
					<div class="buttons notop">
						<button ratingshistoryoffset="prev" title="Назад" disabled><i class="fa fa-angle-up"></i></button>
						<button ratingshistoryoffset="next" title="Далее"><i class="fa fa-angle-down"></i></button>
					</div>
				</div>
			</fieldset>
			
			<ul class="tabstitles sub">
				<li id="tabSubCoeffs">Коэффициенты</li>
				<li id="tabSubOthers">Форс мажор, Выговоры, Стимулирование</li>
			</ul>
			
			<div class="tabscontent" id="historyResultsBlock"></div>
		</div>
		
		<div tabid="tabStatistics"></div>
		
	</div>
	
	
</div>




<script type="text/javascript"><!--

var tabForceMajeureLoaded = false,
	pagination = 0,
	coeffPagination = 0;
	
onChangeTabs(function(item, tabContent) {
	var tabId = $(item).attr('id');
	
	switch (tabId) {	
		case 'tabEvents':
			if (!tabForceMajeureLoaded) getUsersList();
			break;
			
		case 'tabHistory':
			getRatingsHistory();
			break;
		
		case 'tabStatistics': 
			getStatistics();
			break;
			
		default:
	}
});


$(document).off('renderSection').on('renderSection', function() {
	if ($('#tabEvents').hasClass('active')) getUsersList();
	if ($('#tabHistory').hasClass('active')) getRatingsHistory();
	if ($('#tabStatistics').hasClass('active')) getStatistics();
});
	
	
	
	





//------------------------------------------
	
	

	
var koeffHistory = [];

$('#ratingPeriods').on(tapEvent, function() {
	popUp({
		title: 'Рейтинговые отчеты',
		//buttons: [{id: 'newRatingPeriod', title: 'Новый период'}],
		closeButton: 'Закрыть',
		winClass: false,
	}, function(ratingsReportsWin) {
		function openPeriods() {
			ratingsReportsWin.wait();
			getAjaxHtml('admin/ratings/get_periods', function(html) {
				ratingsReportsWin.setTitle('Рейтинговые отчеты');
				ratingsReportsWin.setWidth(700);
				ratingsReportsWin.setButtons([{id: 'newRatingPeriod', title: 'Новый период'}], 'Закрыть');
				ratingsReportsWin.setData(html, false);
				
				
				
				$('[setactiveperiod]').on('change', function() {
					ratingsReportsWin.wait();
					var periodId = $(this).attr('setactiveperiod');
					$.post('/admin/ratings/set_active_period', {id: periodId}, function(response) {
						if (response) {
							notify('Период успешно активирован!');
							tabForceMajeureLoaded = false;
						} else {
							notify('Ошибка активации периода!', 'error');
						}
						ratingsReportsWin.wait(false);
					}).fail(function(e) {
						notify('Системная ошибка!', 'error');
						showError(e);
					});
				});
				
				
				
				$('[setreferencepoint]').on('change', function() {
					ratingsReportsWin.wait();
					var periodId = $(this).attr('setreferencepoint');
					$.post('/admin/ratings/set_referencepoint_period', {id: periodId}, function(response) {
						if (response) {
							notify('Точка отсчета успешно задана!');
							tabForceMajeureLoaded = false;
						} else {
							notify('Ошибка установки точки отсчета!', 'error');
						}
						ratingsReportsWin.wait(false);
					}).fail(function(e) {
						notify('Системная ошибка!', 'error');
						showError(e);
					});
				});
				
				
				
				
				$('[setreportfromperiod]').on(tapEvent, function() {
					$('#sectionWait').addClass('visible');
					ratingsReportsWin.close();
					var periodId = $(this).attr('setreportfromperiod'),
						title = $(this).attr('periodtitle');
					
					getAjaxHtml('admin/ratings/get_report', {period_id: periodId}, function(html) {
						$('#ratingsReport').html(html);
						$('#ratingsReportTitle').text(title);
						$('#ratingsReport').find('.tabstitles.sub').children('li:first').addClass('active');
						$('#ratingsReport').find('[subcontent]').children('div:first').addClass('visible');
						
						
						$('#ratingsReportForm').changeInputs(function(item) {
							var userId = $(item).closest('tr').attr('userid'),
								koeff = $(item).val(),
								type = $(item).attr('htype');
							
							koeffHistory.push({from: 0, to: userId, type: type, data: {coeff: koeff}});
							
							$(item).closest('td').addClass('changed');
							$('#ratingPeriodsSave').removeAttrib('disabled');
						});
						
						
					}, function() {
						$('#sectionWait').removeClass('visible');
					});
				});
				
				
				
				$('[notifyfromperiod]').on(tapEvent, function() {
					var periodId = $(this).attr('notifyfromperiod');
					ratingsReportsWin.wait();
					$.post('/admin/ratings/notify_raidliders', {period_id: periodId}, function(response) {
						if (response) {
							notify('Оповещениея рейд-лидерам отправлены!');
						} else {
							notify('Ошибка отправки опвещений!');
						}
						ratingsReportsWin.wait(false);
					});
				});
				
				
				
				
				
				
				
				$('#newRatingPeriod').on(tapEvent, function() {
					ratingsReportsWin.wait();
					getAjaxHtml('admin/ratings/new_period', function(html) {
						ratingsReportsWin.setData(html, false);
						ratingsReportsWin.setTitle('Новый период');
						ratingsReportsWin.setButtons([{id: 'addRatingPeriod', title: 'Создать'}], 'Отмена');
						ratingsReportsWin.setWidth(500);
						
						var choosedPeriods = [];
						$('[periodid]').on(tapEvent, function() {
							var thisItem = this,
								id = parseInt($(thisItem).attr('periodid'));
							
							if ($(thisItem).hasClass('choosed')) {
								$(thisItem).removeClass('choosed');
								var index = choosedPeriods.indexOf(id);
								if (index !== -1) choosedPeriods.splice(index, 1);
								$('#countChoosedReports').text(choosedPeriods.length);
							} else if ($(thisItem).hasClass('choosed') == false) {
								if (choosedPeriods.length == 4) {
									notify('Допускается только 4 периода!', 'error');
								} else {
									$(thisItem).addClass('choosed');
									choosedPeriods.push(id);
									$('#countChoosedReports').text(choosedPeriods.length);
								}
							}

						});
						
						
						$('#addRatingPeriod').on(tapEvent, function() {
							var stat = true;
							if (choosedPeriods.length != 4) {
								notify('Необходимо выбрать 4 периода!', 'error');
								stat = false;
							} 
							
							if ($('#newratingPeriodTitle').val() == '') {
								$('#newratingPeriodTitle').addClass('error');
								notify('Необходимо указать название периода!', 'error');
								stat = false;
							}
							
							/*if (!$('#newRatingsPeriodDate').attr('date')) {
								$('#newRatingsPeriodDate').addClass('error');
								notify('Необходимо указать дату отсчета посещений!', 'error');
								stat = false;
							}*/
							
							
							if (stat) {
								ratingsReportsWin.dialog('<p class="info">Внимание, после сохранения, период нельзя будет редактировать и удалять!</p><p>Сохранить период?</p>', 'Да', 'Отмена', function() {
									ratingsReportsWin.dialog(false);
									ratingsReportsWin.wait();
									$.post('/admin/ratings/add_period', {
										title: $('#newratingPeriodTitle').val(),
										//visits_date: $('#newRatingsPeriodDate').attr('date'),
										periods: choosedPeriods
									}, function() {
										ratingsReportsWin.wait(false);
										openPeriods();
									}).fail(function(e) {
										notify('Системная ошибка!', 'error');
										showError(e);
									});
								});
							}
						});
						
					}, function() {
						ratingsReportsWin.wait(false);
					});
				});
			}, function() {
				ratingsReportsWin.wait(false);
			});
		}
		
		openPeriods();
	});
	
		
	
	
	
});



$('#ratingPeriodsSave').on(tapEvent, function() {
	$('#sectionWait').addClass('visible');
	sendFormData('#ratingsReportForm', {
		url: '/admin/ratings/save_report',
		success: function(response) {
			if (response) {
				$.post('/admin/ratings/history_add', {history: koeffHistory}, function(response) {
					if (!response) notify('Ошибка! Запись не была добалена в историю!', 'error');
					else koeffHistory = [];
					$('#sectionWait').removeClass('visible');
					notify('Данные успешно сохранены!');
					$('#ratingsReportForm').find('td.changed').removeClass('changed');
					$('#ratingPeriodsSave').setAttrib('disabled');
				}, 'json');
				
				
			} else {
				$('#sectionWait').removeClass('visible');
				notify('Ошибка сохранения данных!', 'error');
			}	
		},
		error: function() {
			$('#sectionWait').removeClass('visible');
			notify('Ошибка сохранения данных!', 'error');
		}
	});
	
});

















//------------------------------------------------------------ История
$('#setSearchFromHistory').on(tapEvent, function() {
	getRatingsHistory();
	$('[ratingshistoryoffset="prev"]').setAttrib('disabled');
	$('#resetSearchFromHistory').removeAttrib('disabled');
	pagination = 0;
});

$('#resetSearchFromHistory').on(tapEvent, function() {
	$('#searchHistoryField').val('');
	pagination = 0;
	getRatingsHistory();
	$('#resetSearchFromHistory').setAttrib('disabled');
	$('[ratingshistoryoffset="prev"]').setAttrib('disabled');
});


$('[ratingshistoryoffset]').on(tapEvent, function() {
	var dir = $(this).attr('ratingshistoryoffset'),
		offset;
	if (dir == 'next') {
		if (pagination == 0) {
			$('[ratingshistoryoffset="prev"]').removeAttrib('disabled');
		}
		pagination += 1;
	} else if (dir == 'prev') {
		$('[ratingshistoryoffset="next"]').removeAttrib('disabled');
		pagination -= 1;
		if (pagination == 0) {
			$('[ratingshistoryoffset="prev"]').setAttrib('disabled');
		}
	}
	getRatingsHistory(pagination);
});



function getRatingsHistory() {
	$('#historyResultsBlock').setWaitToBlock('Загрузка данных...');
	var searchString = $('#searchHistoryField').val();
	
	getAjaxHtml('admin/ratings/get_rating_history', {search: searchString, offset: pagination}, function(html, stat) {
		var countItems = $(html).find('tbody tr').length;
		$('#historyResultsBlock').html(html);
		if (countItems == 0) $('[ratingshistoryoffset="next"]').setAttrib('disabled');
		else $('[ratingshistoryoffset="next"]').removeAttrib('disabled');
	}, function() {
		$('#sectionWait').removeClass('visible');
		$('#historyResultsBlock').setWaitToBlock(false);
		ddrInitTabs();
	});
}













function getStatistics() {
	$('[tabid="tabStatistics"]').setWaitToBlock('Загрузка данных...');
	getAjaxHtml('admin/ratings/get_statistics', function(html) {
		$('[tabid="tabStatistics"]').html(html);
		
		
		//---------------------------------------- Рейтинг участников
		$('[showkoeffsreport]').on(tapEvent, function() {
			var c = $(this).attr('showkoeffsreport').split('|'),
				staticId = c[0],
				isLider = parseInt(c[1]);
			
			popUp({
				title: 'Рейтинги участников',
			    width: 1000,
			    buttons: [{id: 'setDataToRatings', title: 'Сохранить'}],
			    closeButton: 'Отмена'
			}, function(setRatingWin) {
				setRatingWin.wait();
				getAjaxHtml('admin/ratings/get_coeffs_info', {static_id: staticId}, function(html, stat) {
					if (stat) {
						setRatingWin.setData(html, false);
					} else {
						setRatingWin.setData('<p class="info">Нет активных периодов!</p>', false);
					}
				}, function() {
					setRatingWin.wait(false);
				});
				
				
				$('#setDataToRatings').on(tapEvent, function() {
					setRatingWin.wait();
					sendFormData('#usersRatings', {
						url: '/admin/ratings/correct_coeffs_info',
						success: function(response) {
							notify('Данные успешно сохранены!');
							setRatingWin.close();
							setRatingWin.wait(false);
						},
						error: function(e) {
							setRatingWin.wait(false);
							notify('Ошибка сохранения данных', 'error');
							showError(e);
						}
					});
				});
			});
			
		});
		
		
	}, function() {
		$('[tabid="tabStatistics"]').setWaitToBlock(false);
		$('[tabid="tabStatistics"]').find('.scroll').ddrScrollTable();
	});
}












//------------------------------------------------------------ Форс мажор, Выговоры, Стимулирование
$('#setSearchFromEvents').on(tapEvent, function() {
	getUsersList();
	$('#resetSearchFromEvents').removeAttrib('disabled');
	coeffPagination = 0;
});

$('#resetSearchFromEvents').on(tapEvent, function() {
	$('#searchEventsField').val('');
	coeffPagination = 0;
	getUsersList();
	$('#resetSearchFromEvents').setAttrib('disabled');
});


function getUsersList() {
	$('#eventsList').setWaitToBlock('Загрузка данных...');
	var searchString = $('#searchEventsField').val();
	getAjaxHtml('admin/ratings/get_users_list', {search: searchString, offset: coeffPagination}, function(html) {
		var countItems = $(html).find('tbody tr').length;
		$('#eventsList').html(html);
		if (countItems == 0) $('[ratingshistoryoffset="next"]').setAttrib('disabled');
		else $('[ratingshistoryoffset="next"]').removeAttrib('disabled');
		
		
		// Стимулирование
		$('[setstimulation]').on(tapEvent, function() {
			var	thisRow = $(this).closest('tr'), 
				userId = $(this).attr('setstimulation');
			
			setStimulation(thisRow, userId);
		});
		
		// Форс мажор
		$('[setforcemajeure]').on(tapEvent, function() {
			var	thisRow = $(this).closest('tr'), 
				userId = $(this).attr('setforcemajeure');
			
			setForcemajeure(thisRow, userId);
		});
		
		// Выговоры
		$('[setreprimand]').on(tapEvent, function() {
			var	thisRow = $(this).closest('tr'), 
				userId = $(this).attr('setreprimand');
			
			setReprimand(thisRow, userId);
		});
			
	}, function() {
		$('#sectionWait').removeClass('visible');
		$('#eventsList').setWaitToBlock(false);
		ddrInitTabs();
	});
	tabForceMajeureLoaded = true;
}
	







//-------------------------------------------------------- Форс мажор
function setForcemajeure(row, userId) {
	popUp({
		title: 'Форс мажорные выходные',
		width: 700,
		buttons: [{id: 'forcemajeureNew', title: 'Новая запись'}],
		closeButton: 'Закрыть'
	}, function(setForcemajeureWin) {
		setForcemajeureWin.wait();
		getAjaxHtml('admin/forcemajeure/get_list', {user_id: userId}, function(html, stat) {
			if (stat) {
				setForcemajeureWin.setData(html, false);
			} else {
				setForcemajeureWin.setData('<p class="empty center">Нет данных</p>', false);
			}
		}, function() {
			setForcemajeureWin.wait(false);
			
			//---------------------------------------------- Новая запись
			$('#forcemajeureNew').on(tapEvent, function() {
				setForcemajeureWin.wait();
				getAjaxHtml('admin/forcemajeure/new', function(html) {
					setForcemajeureWin.setWidth(500);
					setForcemajeureWin.setData(html, false);
					setForcemajeureWin.setButtons([{id: 'forcemajeureAdd', title: 'Добавить'}], 'Отмена');
					setForcemajeureWin.setTitle('Добавить выходной');
					datePicker('#forcemajeureDate');
					
					$('#forcemajeureAdd').on(tapEvent, function() {
						var stat = true,
							date = $('#forcemajeureDate').attr('date'),
							message = $('#forcemajeureMess').val();
						
						if (!date) {
							$('#forcemajeureDate').addClass('error');
							notify('Необходимо указать дату!', 'error');
							stat = false;
						}
						
						if (!message) {
							$('#forcemajeureMess').addClass('error');
							notify('Необходимо указать причину!', 'error');
							stat = false;
						}
						
						if (stat) {
							setForcemajeureWin.wait();
							$.post('/admin/forcemajeure/add', {user_id: userId, date: date, message: message}, function(response) {
								if (response) {
									setForcemajeureWin.close();
									$(row).find('[forcemajeure]').text(parseInt($(row).find('[forcemajeure]').text()) + 1);
									notify('Запись успешно добавлена!');
								} else {
									notify('Ошибка добавления записи!', 'error');
								}
								setForcemajeureWin.wait(false);
							}).fail(function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							});
						}
					});
				}, function() {
					setForcemajeureWin.wait(false);
				});
			});
			
			
			
			
			//---------------------------------------------- Редактировать запись
			$('[forcemajeureedit]').on(tapEvent, function() {
				var id = $(this).attr('forcemajeureedit');
				setForcemajeureWin.wait();
				getAjaxHtml('admin/forcemajeure/edit', {id: id}, function(html) {
					setForcemajeureWin.setWidth(500);
					setForcemajeureWin.setData(html, false);
					setForcemajeureWin.setButtons([{id: 'forcemajeureEdit', title: 'Обновить'}], 'Отмена');
					setForcemajeureWin.setTitle('Редактировать выходной');
					datePicker('#forcemajeureDate');
					
					
					$('#forcemajeureEdit').on(tapEvent, function() {
						var stat = true,
							date = $('#forcemajeureDate').attr('date'),
							message = $('#forcemajeureMess').val();
						
						if (!date) {
							$('#forcemajeureDate').addClass('error');
							notify('Необходимо указать дату!', 'error');
							stat = false;
						}
						
						if (!message) {
							$('#forcemajeureMess').addClass('error');
							notify('Необходимо указать причину!', 'error');
							stat = false;
						}
						
						if (stat) {
							setForcemajeureWin.wait();
							$.post('/admin/forcemajeure/update', {id: id, user_id: userId, date: date, message: message}, function(response) {
								if (response) {
									setForcemajeureWin.close();
									notify('Запись успешно обновлена!');
								} else {
									notify('Ошибка обновления записи!', 'error');
								}
								setForcemajeureWin.wait(false);
							}).fail(function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							});
						}
					});
					
				}, function() {
					setForcemajeureWin.wait(false);
				});
			});
			
			
			
			
			//---------------------------------------------- Удалить запись
			$('[forcemajeureremove]').on(tapEvent, function() {
				var id = $(this).attr('forcemajeureremove');
				setForcemajeureWin.wait();
				getAjaxHtml('admin/forcemajeure/remove_form', function(html) {
					setForcemajeureWin.setWidth(500);
					setForcemajeureWin.setData(html, false);
					setForcemajeureWin.setButtons([{id: 'forcemajeureRemove', title: 'Удалить'}], 'Отмена');
					setForcemajeureWin.setTitle('Удалить выходной');
					
					
					$('#forcemajeureRemove').on(tapEvent, function() {
						var stat = true,
							message = $('#forcemajeureMess').val();
						
						if (!message) {
							$('#forcemajeureMess').addClass('error');
							notify('Необходимо указать причину удаления!', 'error');
							stat = false;
						}
						
						if (stat) {
							setForcemajeureWin.wait();
							$.post('/admin/forcemajeure/remove', {id: id, message: message}, function(response) {
								if (response) {
									setForcemajeureWin.close();
									$(row).find('[forcemajeure]').text(parseInt($(row).find('[forcemajeure]').text()) - 1);
									notify('Запись успешно удалена!');
								} else {
									notify('Ошибка удаления записи!', 'error');
								}
								setForcemajeureWin.wait(false);
							}).fail(function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							});
						}
					});
					
				}, function() {
					setForcemajeureWin.wait(false);
				});
			});
			
			
		});
	});
}












//-------------------------------------------------------- Выговоры
function setReprimand(row, userId) {
	popUp({
		title: 'Выговоры',
		width: 700,
		buttons: [{id: 'reprimandsNew', title: 'Новая запись'}],
		closeButton: 'Закрыть'
	}, function(setReprimandsWin) {
		setReprimandsWin.wait();
		getAjaxHtml('admin/reprimands/get_list', {user_id: userId}, function(html, stat) {
			if (stat) {
				setReprimandsWin.setData(html, false);
			} else {
				setReprimandsWin.setData('<p class="empty center">Нет данных</p>', false);
			}
		}, function() {
			setReprimandsWin.wait(false);
			
			//---------------------------------------------- Новая запись
			$('#reprimandsNew').on(tapEvent, function() {
				setReprimandsWin.wait();
				getAjaxHtml('admin/reprimands/new', function(html) {
					setReprimandsWin.setWidth(500);
					setReprimandsWin.setData(html, false);
					setReprimandsWin.setButtons([{id: 'reprimandsAdd', title: 'Добавить'}], 'Отмена');
					setReprimandsWin.setTitle('Добавить выговор');
					datePicker('#reprimandsDate');
					
					$('#reprimandsAdd').on(tapEvent, function() {
						var stat = true,
							date = $('#reprimandsDate').attr('date'),
							message = $('#reprimandsMess').val();
						
						if (!date) {
							$('#reprimandsDate').addClass('error');
							notify('Необходимо указать дату!', 'error');
							stat = false;
						}
						
						if (!message) {
							$('#reprimandsMess').addClass('error');
							notify('Необходимо указать причину!', 'error');
							stat = false;
						}
						
						if (stat) {
							setReprimandsWin.wait();
							$.post('/admin/reprimands/add', {
								user_id: userId,
								date: date,
								message: message
							}, function(response) {
								if (response) {
									setReprimandsWin.close();
									$(row).find('[reprimands]').text(parseInt($(row).find('[reprimands]').text()) + 1);
									notify('Запись успешно добавлена!');
								} else {
									notify('Ошибка добавления записи!', 'error');
								}
								setReprimandsWin.wait(false);
							}).fail(function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							});
						}
					});
				}, function() {
					setReprimandsWin.wait(false);
				});
			});
			
			
			
			
			
			//---------------------------------------------- Редактировать запись
			$('[reprimandsedit]').on(tapEvent, function() {
				var id = $(this).attr('reprimandsedit');
				setReprimandsWin.wait();
				getAjaxHtml('admin/reprimands/edit', {id: id}, function(html) {
					setReprimandsWin.setWidth(500);
					setReprimandsWin.setData(html, false);
					setReprimandsWin.setButtons([{id: 'reprimandsEdit', title: 'Обновить'}], 'Отмена');
					setReprimandsWin.setTitle('Редактировать выговор');
					datePicker('#reprimandsDate');
					
					
					$('#reprimandsEdit').on(tapEvent, function() {
						var stat = true,
							date = $('#reprimandsDate').attr('date'),
							message = $('#reprimandsMess').val();
						
						if (!date) {
							$('#reprimandsDate').addClass('error');
							notify('Необходимо указать дату!', 'error');
							stat = false;
						}
						
						if (!message) {
							$('#reprimandsMess').addClass('error');
							notify('Необходимо указать причину!', 'error');
							stat = false;
						}
						
						if (stat) {
							setReprimandsWin.wait();
							$.post('/admin/reprimands/update', {id: id, user_id: userId, date: date, message: message}, function(response) {
								if (response) {
									setReprimandsWin.close();
									notify('Запись успешно обновлена!');
								} else {
									notify('Ошибка обновления записи!', 'error');
								}
								setReprimandsWin.wait(false);
							}).fail(function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							});
						}
					});
					
				}, function() {
					setReprimandsWin.wait(false);
				});
			});
			
			
			
			
			//---------------------------------------------- Удалить запись
			$('[reprimandsremove]').on(tapEvent, function() {
				var id = $(this).attr('reprimandsremove');
				setReprimandsWin.wait();
				getAjaxHtml('admin/reprimands/remove_form', function(html) {
					setReprimandsWin.setWidth(500);
					setReprimandsWin.setData(html, false);
					setReprimandsWin.setButtons([{id: 'reprimandsRemove', title: 'Удалить'}], 'Отмена');
					setReprimandsWin.setTitle('Удалить выговор');
					
					
					$('#reprimandsRemove').on(tapEvent, function() {
						var stat = true,
							message = $('#reprimandsMess').val();
						
						if (!message) {
							$('#reprimandsMess').addClass('error');
							notify('Необходимо указать причину удаления!', 'error');
							stat = false;
						}
						
						if (stat) {
							setReprimandsWin.wait();
							$.post('/admin/reprimands/remove', {id: id, message: message}, function(response) {
								if (response) {
									setReprimandsWin.close();
									$(row).find('[reprimands]').text(parseInt($(row).find('[reprimands]').text()) - 1);
									notify('Запись успешно удалена!');
								} else {
									notify('Ошибка удаления записи!', 'error');
								}
								setReprimandsWin.wait(false);
							}).fail(function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							});
						}
					});
					
				}, function() {
					setReprimandsWin.wait(false);
				});
			});
			
			
		});
	});
}










//-------------------------------------------------------- Стимулирование
function setStimulation(row, userId) {
	popUp({
		title: 'Стимулирование',
		width: 500,
		buttons: [{id: 'stimulationSet', title: 'Задать'}],
		closeButton: 'Закрыть',
		winClass: false,
	}, function(setStimulationWin) {
		setStimulationWin.wait();
		getAjaxHtml('admin/stimulation/get_form', {user_id: userId}, function(html) {
			setStimulationWin.setData(html, false);
			
			$('#stimulationSet').on(tapEvent, function() {
				var userId = $('#stimulationUserId').val(),
					index = $('#stimulationIndex').val(),
					message = $('#stimulationMess').val();
				
				if (!message) {
					$('#stimulationMess').addClass('error');
					notify('Необходимо указать причину!', 'error');
				} else {
					$.post('/admin/stimulation/set', {
						user_id: userId,
						index: index,
						message: message
					}, function(response) {
						if (response) {
							setStimulationWin.close();
							$(row).find('[stimulation]').text(index);
							notify('Стимулирование успешно задано!');
						} else {
							notify('Ошибка! Стимулирование не задано!', 'error');
						}
						setStimulationWin.wait(false);
					}).fail(function(e) {
						notify('Системная ошибка!', 'error');
						showError(e);
					});
				}
				
				
				
					
			});
		}, function() {
			setStimulationWin.wait(false);
		});
	});
}









//--></script>