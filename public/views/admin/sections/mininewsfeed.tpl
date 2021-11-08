<div class="section" id="{{id}}">
	<div class="section_title align-items-start">
		<h2>Важные события</h2>
		<div class="buttons notop">
			<button class="fieldheight mr20px" id="miniNewsFeedNewBtn" title="Новое событие"><i class="fa fa-commenting"></i></button>
			
			<button class="fieldheight alt" id="miniNewsFeedBirthdaysBtn" title="Шаблоны: дни рождения"><i class="fa fa-birthday-cake"></i></button>
			<button class="fieldheight alt" id="miniNewsFeedNewRanksBtn" title="Шаблоны: новые звания"><i class="fa fa-user-plus"></i></button>
		</div>
	</div>
	
	
	<div class="row">
		<div class="col-6">
			<h4>Отправленные</h4>
			<table id="miniNewsFeedTable">
				<thead>
					<tr>
						<td class="w60px">Иконка</td>
						<td>Оповещение</td>
						<td class="w200px">Статики</td>
						<td class="w180px">Дата размещения</td>
						<td class="w80px">Опции</td>
					</tr>
				</thead>
				<tbody id="miniNewsFeedList"></tbody>
			</table>
		</div>
		
		<div class="col-6">
			<h4>Отложенные</h4>
			<table id="miniNewsFeedLaterTable">
				<thead>
					<tr>
						<td class="w60px">Иконка</td>
						<td>Оповещение</td>
						<td class="w200px">Статики</td>
						<td class="w180px">Отправка</td>
						<td class="w80px">Опции</td>
					</tr>
				</thead>
				<tbody id="miniNewsFeedLater"></tbody>
			</table>
		</div>
	</div>	
</div>





<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	
	let ddrScrollminiNewsFeedTable = $('#miniNewsFeedTable').ddrScrollTableY({height: 'calc(100vh - 254px)', offset: 1, wrapBorderColor: '#d7dbde'});
	let ddrScrollminiNewsFeedLaterTable = $('#miniNewsFeedLaterTable').ddrScrollTableY({height: 'calc(100vh - 254px)', offset: 1, wrapBorderColor: '#d7dbde'});
	

	(getMininewsFeedList = function(callback) {
		getAjaxHtml('mininewsfeed/list/get', function(html, stat) {
			if (stat) $('#miniNewsFeedList').html(html);
			else $('#miniNewsFeedList').html('<tr class="empty h61px"><td colspan="5"><p class="empty center">Нет данных</p></td></tr>');
		}, function() {
			ddrScrollminiNewsFeedTable.reInit();
			if (callback && typeof callback == 'function') callback();
		});
	})();
	
	
	(getMininewsFeedLater = function(callback) {
		getAjaxHtml('mininewsfeed/later/get', function(html, stat) {
			if (stat) $('#miniNewsFeedLater').html(html);
			else $('#miniNewsFeedLater').html('<tr class="empty h61px"><td colspan="5"><p class="empty center">Нет данных</p></td></tr>');
		}, function() {
			ddrScrollminiNewsFeedLaterTable.reInit();
			if (callback && typeof callback == 'function') callback();
		});
	})();
	
	
	
	$('#mininewsfeed').on(tapEvent, '[mininewsfeedupdate]', function() {
		let d = $(this).attr('mininewsfeedupdate').split('|'),
			listType = d[0],
			id = d[1];
		openMiniNewsFeedForm(listType, id);
	});
	
	
	$('#mininewsfeed').on(tapEvent, '[mininewsfeedremove]', function() {
		let d = $(this).attr('mininewsfeedremove').split('|'),
			listType = d[0],
			id = d[1],
			tr = $(this).closest('tr'),
			countRows = $(this).closest('tbody').find('tr').length;
		
		popUp({
			title: 'Удалить запись|4',
		    width: 600,
		    html: '<p class="fz18px info text-center">Вы действительно хотите удалить запись?</p>',
		    buttons: [{id : 'removeMininewsfeedBtn', title: 'Удалить'}],
		    closeButton: 'Отмена',
		    closePos: 'left'
		}, function(mininewsfeedremoveWin) {
			$('#removeMininewsfeedBtn').on(tapEvent, function() {
				mininewsfeedremoveWin.wait();
				$.post('mininewsfeed/'+listType+'/remove', {id: id}, function(response) {
					if (response) {
						notify('Запись успешно удалена!');
						if (countRows > 1) $(tr).remove();
						else $(tr).replaceWith('<tr class="empty h61px"><td colspan="5"><p class="empty center">Нет данных</p></td></tr>');
						mininewsfeedremoveWin.close();
						if (listType == 'list') socket.emit('mininewsfeed:update');
					} else {
						notify('Ошибка удаления записи!', 'error');
						mininewsfeedremoveWin.wait(false);
					}
				}).fail(function(e) {
					showError(e);
					notify('Системная ошибка!', 'error');
					mininewsfeedremoveWin.wait(false);
				});
			});
		});	
	});
	
	
	
	
	
	
	
	
	$('#miniNewsFeedNewBtn').on(tapEvent, function() {
		openMiniNewsFeedForm();
	});
	
	
	
	
	
	
	function openMiniNewsFeedForm(listType, id) {
		let params = id != undefined ? {id : id} : {},
			title = id != undefined ? 'Редактировать событие|4' : 'Новое событие|4',
			isEdit = !!id;
			
			params['edit_later'] = (isEdit && listType == 'later') || !isEdit;
			
		popUp({
			title: title,
			width: 600,
			buttons: [{id : 'miniNewsFeedFormBtn', title: isEdit ? 'Обновить' : 'Создать'}],
			buttonsAlign: 'right',
			disabledButtons: false,
			closePos: 'left',
			closeByButton: false,
			closeButton: 'Отмена'
		}, function(miniNewsFeedNewWin) {
			miniNewsFeedNewWin.setData('mininewsfeed/form', params, function() {
				
				let d = new Date();
	
				$('#miniNewsFormDate').datepicker({
					dateFormat:         'd M yy г.',
					numberOfMonths:     1,
					changeMonth:        true,
					changeYear:         true,
					monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
					monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
					dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
					firstDay:           1,
					minDate:            d,
					onSelect: function(stringDate, dateObj) {
						let date = dateObj.currentDay+'-'+(dateObj.currentMonth+1)+'-'+dateObj.currentYear;
						$('#miniNewsFormDateValue').val(date);
					} 
				});
				
				
				$('#miniNewsFormClearDate').on(tapEvent, function() {
					$('#miniNewsFormDate, #miniNewsFormDateValue').val('');
					$('select[name="later_hours"], select[name="later_minutes"]').children('option').removeAttrib('selected');
					$('select[name="later_hours"], select[name="later_minutes"]').children('option:first').setAttrib('selected');
				});
				
							
				$('[mininewsfeedstatics]').on(tapEvent, function() {
					let stat = $(this).attr('mininewsfeedstatics');
					
					if (stat == 'all') {
						$('#miniNewsFeedStaticsBlock').find('[mininewsfedstatic]').each(function() {
							$(this).setAttrib('checked');
						});
						$('#miniNewsFeedStaticsBlock').removeClass('errorblock errorblock_border errorblock_bg');
					} else if (stat == 'none') {
						$('#miniNewsFeedStaticsBlock').find('[mininewsfedstatic]').each(function() {
							$(this).removeAttrib('checked');
						});
					}
				});
				
				$('.popup__file').on(tapEvent, function() {
					$(this).removeClass('error');
				});
				
				
				
				$('#miniNewsFeedStaticsBlock').find('[mininewsfedstatic]').on('change', function() {
					$('#miniNewsFeedStaticsBlock').removeClass('errorblock errorblock_border errorblock_bg');
				});
				
				
				$('#miniNewsFeedFormBtn').on(tapEvent, function() {
					
					let choosedStatics = [];
					$('#miniNewsFeedStaticsBlock').find('[mininewsfedstatic]:checked').each(function() {
						choosedStatics.push(parseInt($(this).val()));
					});
					
					$('#miniNewsFormCountStatics').val(choosedStatics.length);
					
					
					
					
					let fields = isEdit ? {id: id, statics: JSON.stringify(choosedStatics)} : {statics: JSON.stringify(choosedStatics)};
					let isLater = !!$('#miniNewsFormDateValue').val();
					let func = listType != undefined ? listType : (isLater ? 'later' : 'list');
					let path = isEdit ? 'mininewsfeed/'+func+'/update' : 'mininewsfeed/'+func+'/add';
					
					
					$('#miniNewsFeedForm').formSubmit({
						url: path,
						fields: fields,
						formError: function(errors) {
							$.each(errors, function(k, item) {
								if (item.field.name == 'icon') {
									$('#miniNewsFeedIcon').closest('.popup__file').addClass('error');
								}
								
								if (item.field.name == '_countstatics') {
									$('#miniNewsFeedStaticsBlock').addClass('errorblock errorblock_border errorblock_bg');
								}
							});
							miniNewsFeedNewWin.wait(false);
						},
						before: function() {
							miniNewsFeedNewWin.wait();
						},
						success: function() {
							if (func == 'later') {
								getMininewsFeedLater(function() {
									miniNewsFeedNewWin.close();
									notify('Запись успешно '+(isEdit ? 'обновлена!' : 'добавлена!'));
								});
							} else {
								getMininewsFeedList(function() {
									miniNewsFeedNewWin.close();
									notify('Запись успешно '+(isEdit ? 'обновлена!' : 'добавлена!'));
									socket.emit('mininewsfeed:update');
								});
							}
						},
						error: function() {
							notify('Ошибка '+(isEdit ? 'обновления' : 'добавления')+' записи!', 'error');
							miniNewsFeedNewWin.wait(false);
						}
					});
				});
			});
		});
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('#miniNewsFeedBirthdaysBtn').on(tapEvent, function() {
		popUp({
			title: 'Шаблоны: дни рождения|4',
			width: 900,
			closePos: 'left'
		}, function(miniNewsFeedBirthdaysWin) {
			
			miniNewsFeedBirthdaysWin.setData('mininewsfeed/templates/init', {list_id: 'miniNewsFeedBirthdaysList', btn_id: 'nFBirthDayAddBtn'}, function() {
				$('#miniNewsFeedBirthdaysList').ddrCRUD({
					addSelector: '#nFBirthDayAddBtn',
					emptyList: '<tr><td colspan="3">Нет данных</td></tr>',
					functions: 'mininewsfeed/templates',
					data: {
						getList: {type: 1}, //Данные при получении списка записей
						add: {}, // Данные при добавлении записи
						save: {type: 1}, // Данные при сохранении записи
						update: {}, // Данные при обновлении записи
						remove: {} // Данные при удалении записи
					},
					confirms: {
						/*remove: function(thisRow) {
							if ($(thisRow).next('tr.personageslist').length > 0) $(thisRow).next('tr.personageslist').remove();
						}*/
					},
					removeConfirm: true,
					listDirection: 'bottom',
					popup: miniNewsFeedBirthdaysWin
				}, function(list) {
					$('#miniNewsFeedBirthdaysList').on(tapEvent, '[mininewsfeedcode]', function() {
						let type = $(this).attr('mininewsfeedcode'),
							tr = $(this).closest('tr'),
							textarea = $(tr).find('[name="text"]'),
							saveUpdate = $(tr).find('[save], [update]'),
							codeHtml = '<p>Вставить код</p>';
							codeHtml += '<ul class="popup__list">';
							codeHtml += 	'<li mininewsfeedchoose="[nickname]" class="h30px">Никнейм</li>';
							codeHtml += 	'<li mininewsfeedchoose="[rank]" class="h30px">Звание</li>';
							codeHtml += '</ul>';
						
						miniNewsFeedBirthdaysWin.dialog(codeHtml, '', 'Закрыть', function() {});
						$('[mininewsfeedchoose]').on(tapEvent, function() {
							let thisCode = $(this).attr('mininewsfeedchoose'),
								text = $(textarea).val();
							$(textarea).val(text.trim()+' '+thisCode);
							miniNewsFeedBirthdaysWin.dialog(false);
							$(saveUpdate).removeAttrib('disabled');
						});
					});
				});
			});
			
			
			
			
			
				
		});
	});
	
	
	
	$('#miniNewsFeedNewRanksBtn').on(tapEvent, function() {
		popUp({
			title: 'Шаблоны: новые звания|4',
			width: 900,
			closePos: 'left'
		}, function(miniNewsFeedNewRanksWin) {
			
			miniNewsFeedNewRanksWin.setData('mininewsfeed/templates/init', {list_id: 'miniNewsFeedNewRankList', btn_id: 'nFNewRankAddBtn', type: 2}, function() {
				$('#miniNewsFeedNewRankList').ddrCRUD({
					addSelector: '#nFNewRankAddBtn',
					emptyList: '<tr><td colspan="3">Нет данных</td></tr>',
					functions: 'mininewsfeed/templates',
					data: {
						getList: {type: 2}, //Данные при получении списка записей
						add: {type: 2}, // Данные при добавлении записи
						save: {type: 2}, // Данные при сохранении записи
						update: {}, // Данные при обновлении записи
						remove: {} // Данные при удалении записи
					},
					confirms: {
						/*remove: function(thisRow) {
							if ($(thisRow).next('tr.personageslist').length > 0) $(thisRow).next('tr.personageslist').remove();
						}*/
					},
					removeConfirm: true,
					listDirection: 'bottom',
					popup: miniNewsFeedNewRanksWin
				}, function(list) {
					$('#miniNewsFeedNewRankList').on(tapEvent, '[mininewsfeedcode]', function() {
						let type = $(this).attr('mininewsfeedcode'),
							tr = $(this).closest('tr'),
							textarea = $(tr).find('[name="text"]'),
							saveUpdate = $(tr).find('[save], [update]'),
							codeHtml = '<p>Вставить код</p>';
							codeHtml += '<ul class="popup__list">';
							codeHtml += 	'<li mininewsfeedchoose="[nickname]" class="h30px">Никнейм</li>';
							codeHtml += 	'<li mininewsfeedchoose="[rank]" class="h30px">Звание</li>';
							codeHtml += '</ul>';
						
						miniNewsFeedNewRanksWin.dialog(codeHtml, '', 'Закрыть', function() {});
						$('[mininewsfeedchoose]').on(tapEvent, function() {
							let thisCode = $(this).attr('mininewsfeedchoose'),
								text = $(textarea).val();
							$(textarea).val(text.trim()+' '+thisCode);
							miniNewsFeedNewRanksWin.dialog(false);
							$(saveUpdate).removeAttrib('disabled');
						});
					});
				});
			});
				
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
});
//--></script>