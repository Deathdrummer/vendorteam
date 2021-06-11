<div class="section" id="ratingsSection">
	<div class="section__title">
		<h1>Форс мажор, Выговоры, Стимулирование</h1>
	</div>
	
	{#<div class="section__buttons" id="sectionButtons">
		<button id="importantinfoSave" title="Сохранить настройки"><i class="fa fa-save"></i></button>
	</div>#}
	
	<div class="section__content" id="sectionContent">
		<div>
			<p>Поиск по участнику</p>
			
			<div class="section__buttons nowidth mb-3">
				<div class="item inline">
					<div class="field">
						<input type="text" id="searchEventsField" autocomplete="off" placeholder="Введите никнейм">
					</div>
				</div>
				<div class="item inline">
					<div class="buttons notop">
						<button id="setSearchFromEvents">Поиск</button>
						<button class="remove" disabled id="resetSearchFromEvents">Сбросить</button>
					</div>
				</div>
			</div>
			
			<div id="eventsList"></div>
		</div>
	</div>
</div>



<script type="text/javascript"><!--
//------------------------------------------------------------ Форс мажор, Выговоры, Стимулирование
var tabForceMajeureLoaded = false,
	coeffPagination = 0;

getUsersList(function() {
	$('.tabstitles').find('li:first').addClass('active');
	$('.tabstitles').siblings('.tabscontent').children('div:first').addClass('visible');
});

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


function getUsersList(callback) {
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
		if (callback && typeof callback == 'function') callback();
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