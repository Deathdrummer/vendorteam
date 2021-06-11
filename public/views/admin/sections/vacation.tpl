<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Отпуска</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	

	<ul class="tabstitles">
		<li id="tabVacationSettings" class="active">Настройки</li>
		<li id="tabVacationData">График отпусков</li>
		<li id="tabVacationDisableds">Глобальные запреты</li>
	</ul>
	
	
	<div class="tabscontent">
		<div tabid="tabVacationSettings" class="visible">
			{% if statics %}
				<form id="vacationForm">
					<table>
						<thead>
							<tr>
								<td>Статик</td>
								<td class="w10">Длина отпуска в год</td>
								<td class="w10">Кол-во одновременных бронирований</td>
								<td class="w10">Партия бронирования</td>
								<td class="w10">Промежуток между партиями</td>
								<td class="nowidth center"><i title="Запрещенные дни" class="fa fa-star-o"></i></td>
								<td class="nowidth center"><i title="Запрещенные дни" class="fa fa-calendar-times-o"></i></td>
							</tr>
						</thead>
						<tbody>
							{% for sId, s in statics %}
								<tr>
									<td class="pl-0">
										<input type="hidden" name="vacation_settings[{{sId}}][static_id]" value="{{sId}}">
										<div class="d-flex align-items-center" vacationstaticdata>
											<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/filemanager/'~s.icon)}}')"></div>
											<span>{{s.name}}</span>
										</div>
									</td>
									<td>
										<div class="number">
											<input type="number" name="vacation_settings[{{sId}}][limit]" min="0" value="{{settings[sId]['limit']}}" showrows>
										</div>
									</td>
									<td>
										<div class="number">
											<input type="number" name="vacation_settings[{{sId}}][parallel]" min="0" value="{{settings[sId]['parallel']}}" showrows>
										</div>
									</td>
									<td>
										<div class="number">
											<input type="number" name="vacation_settings[{{sId}}][party]" min="0" value="{{settings[sId]['party']}}" showrows>
										</div>
									</td>
									<td>
										<div class="number">
											<input type="number" name="vacation_settings[{{sId}}][space]" min="0" value="{{settings[sId]['space']}}" showrows>
										</div>
									</td>
									<td>
										<input type="hidden" vacationenabledranks name="vacation_settings[{{sId}}][enabled_ranks]" value="{{settings[sId]['enabled_ranks']}}">
										<div class="buttons">
											<button vacationsetenabledranks><i class="fa fa fa-star-o"></i></button>
										</div>
									</td>
									<td>
										<input type="hidden" vacationdisabledweekdays name="vacation_settings[{{sId}}][disabled_week]" value="{{settings[sId]['disabled_week']}}">
										<input type="hidden" vacationdisabledmonthdays name="vacation_settings[{{sId}}][disabled_month]" value="{{settings[sId]['disabled_month']}}">
										<div class="buttons">
											<button vacationsetdisableddays><i class="fa fa-calendar-times-o"></i></button>
										</div>
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</form>
			{% else %}
				<p class="empty">Нет статиков</p>
			{% endif %}
		</div>
		
		<div tabid="tabVacationData"></div>
		
		<div tabid="tabVacationDisableds">
			<div class="buttons notop minspace section__buttons mb-3 text-left">
				<button vacationglobalaction="set" class="small" disabled title="Запретить день"><i class="fa fa-plus"></i></button>
				<button vacationglobalaction="remove" class="remove small" disabled title="Отменить запрет"><i class="fa fa-trash"></i></button>
			</div>
			
			{% if statics %}
				<table class="vacation_table noselect" id="vacationTableGlobalDisabled">
					<thead>
						<tr>
							<td rowspan="2" class="names right pr-2">
								<span>Статик</span>
							</td>
							{% for m, d in dates_to_disabled %}
								<td colspan="{{d|length}}">
									<p class="month">{{m}}</p>
								</td>
							{% endfor %}
						</tr>
						<tr>
							{% for m, d in dates_to_disabled %}
								{% for day in d %}
									<td class="{{day|date('D')|lower}}">
										<p>{{day|date('j')}}</p>
									</td>
								{% endfor %}
							{% endfor %}
						</tr>
					</thead>
					<tbody>
						{% for sId, s in statics %}
							<tr>
								<td class="names right pr-2"><p>{{s.name}}</p></td>
								{% for m, d in dates_to_disabled %}
									{% for day in d %}
										<td class="{{day|date('D')|lower}} global{% if day in disabled_days[sId] %} globaldisabled{% endif %}" vacationglobaldisabledday="{{sId}}|{{day}}"></td>
									{% endfor %}
								{% endfor %}
							</tr>
						{% endfor %}
					</tbody>
				</table>
			{% else %}
				<p class="empty">Нет статиков</p>
			{% endif %}
		</div>
	</div>
</div>















<script type="text/javascript"><!--
$(document).ready(function() {
	
	//-------------------------------------------------------------------------------------------------- Отпуска
	$('#vacationSave').on(tapEvent, function() {
		var vacationForm = new FormData($('#vacationForm')[0]);
		
		$.ajax({
			type: 'POST',
			url: '/vacation/save_settings',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: vacationForm,
			success: function(response) {
				if (response) {
					notify('Настройки отпусков успешно сохранены!');
					$('#vacationForm').find('tr.changed').removeClass('changed');
				} else {
					notify('Ошибка сохранения настроек!', 'error');
				}
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	
	
	$('#vacationForm').changeInputs(function(item) {
		$(item).closest('tr').addClass('changed');
	});
	
	
	
	
	 

	$('#vacationForm').find('[vacationsetdisableddays]').on(tapEvent, function() {
		var thisRow = $(this).closest('tr'),
			weekInput = $(this).closest('td').find('[vacationdisabledweekdays]'),
			monthInput = $(this).closest('td').find('[vacationdisabledmonthdays]'),
			staticCard = $(this).closest('tr').find('[vacationstaticdata]').html();
		
		popUp({
			title: 'Запрещенные дни',
		    width: 500,
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'setDisabledDays', title: 'Применить'}],
		    closeButton: 'Отмена',
		}, function(vacationDisabledWin) {
			vacationDisabledWin.wait();
			
			getAjaxHtml('vacation/get_disabled_days', {week_days: $(weekInput).val(), month_days: $(monthInput).val(), static_html: staticCard}, function(html) {
				vacationDisabledWin.setData(html, false);
			}, function() {
				vacationDisabledWin.wait(false);
			});
			
			
			$('#setDisabledDays').on(tapEvent, function() {
				var weekDaysData = [],
					monthDaysData = [];
				$('#disabledDaysWin').find('[weekday]:checked').each(function(k, item) {
					weekDaysData.push(parseInt($(item).attr('weekday')));
				});
				
				$('#disabledDaysWin').find('[monthday]:checked').each(function(k, item) {
					monthDaysData.push(parseInt($(item).attr('monthday')));
				});
				
				$(weekInput).val(JSON.stringify(weekDaysData));
				$(monthInput).val(JSON.stringify(monthDaysData));
				$(thisRow).addClass('changed');
				vacationDisabledWin.close();
			});
		});
	});
	
	
	
	
	
	
	$('#vacationForm').find('[vacationsetenabledranks]').on(tapEvent, function() {
		var thisRow = $(this).closest('tr'),
			ranksInput = $(this).closest('td').find('[vacationenabledranks]'),
			staticCard = $(this).closest('tr').find('[vacationstaticdata]').html();
		
		popUp({
			title: 'Разрешенные звания',
		    width: 500,
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'setEnabledRanks', title: 'Применить'}],
		    closeButton: 'Отмена',
		}, function(vacationRanksWin) {
			vacationRanksWin.wait();
			getAjaxHtml('vacation/get_enabled_ranks', {enabled_ranks: $(ranksInput).val(), static_html: staticCard}, function(html) {
				vacationRanksWin.setData(html, false);
			}, function() {
				vacationRanksWin.wait(false);
			});
			
			
			$('#setEnabledRanks').on(tapEvent, function() {
				var enableRanksData = [];
				$('#enabledRanksWin').find('[enablerank]:checked').each(function(k, item) {
					enableRanksData.push(parseInt($(item).attr('enablerank')));
				});
				
				$(ranksInput).val(JSON.stringify(enableRanksData));
				$(thisRow).addClass('changed');
				vacationRanksWin.close();
			});
		});
	});
	
	
	
	
	
	
	
	
	// Загрузить данные по отпускам во вкладку
	var weeksShift = 0;
	if ($('#vacation').find('#tabVacationData').hasClass('active')) {
		getVacationDataToAdmin();
	}
	
	onChangeTabs(function(thisItemTitle, thisItemContent) {
		if ($(thisItemTitle).attr('id') == 'tabVacationData') {
			getVacationDataToAdmin();
		}
	});
	
	
	
	function getVacationDataToAdmin(callback) {
		getAjaxHtml('vacation/get_data_to_admin', {weeks_shift: weeksShift}, function(html) {
			$('[tabid="tabVacationData"]').html(html);
			var hashData = location.hash.substr(1, location.hash.length).split('.'),
				section = hashData[0];
		
			if (hashData[2] != undefined) {
				if ($('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').length > 0) {
					$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').each(function() {
						if ($(this).children('li#'+hashData[2]).length > 0) {
							$(this).children('li').removeClass('active');
							$(this).children('li#'+hashData[2]).addClass('active');
							
							$(this).siblings('.tabscontent').find('[tabid]').removeClass('visible');
							$(this).siblings('.tabscontent').find('[tabid="'+hashData[2]+'"]').addClass('visible');
						} else {
							$(this).children('li:first').addClass('active');
							$(this).siblings('.tabscontent').find('[tabid]:first').addClass('visible');
						}
					});
				}
			} else {
				if ($('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').length > 0) {
					$('#'+section).find('.tabstitles:not(.sub)').siblings('.tabscontent').find('.tabstitles.sub').each(function() {
						$(this).children('li').removeClass('active');
						$(this).children('li:first').addClass('active');
						
						$(this).siblings('.tabscontent').find('[tabid]').removeClass('visible');
						$(this).siblings('.tabscontent').find('[tabid]:first').addClass('visible');
					});
				}	
			}
			
			
			
			
			
			
			$('#vacation').multiChoose({
				item: '[setvacation]',
				cls: 'choosed'
			}, function(cellsRow, choosedItems, isChoosed) {
				if ($('#vacation').find('[setvacation].choosed').length > 0) {
					$(vacationActionButtons).find('button').removeAttrib('disabled');
				} else {
					$(vacationActionButtons).find('button').setAttrib('disabled');
				}
			});
			
			
			
			// Смещение недели
			$('[shiftweeks]').on(tapEvent, function() {
				//sectionWait();
				$('#vacationTable').addClass('loading');
				var direction = $(this).attr('shiftweeks');
				
				if (direction == 'back') {
					weeksShift -= 1;
				} else if (direction == 'forward') {
					weeksShift += 1;
				}
				getVacationDataToAdmin(function() {
					//sectionWait(false);
				});
			});
			
			
			
			
			
			// Запретить/разрешить дни
			$('[vacationdisabledstaticday]').on(tapEvent, function() {
				var thisCell = this,
					index = $(thisCell).index(),
					d = $(thisCell).attr('vacationdisabledstaticday').split('|'),
					disabled = $(thisCell).hasClass('disabled');
				
				$.post('/vacation/disabled_enabled_days', {disabled: disabled, static_id: parseInt(d[0]), day: parseInt(d[1])}, function(response) {
					if (response) {
						if (disabled) {
							notify('День разрешен');
							$(thisCell).removeClass('disabled');
							$(thisCell).setAttrib('title', 'Запретить');
							$(thisCell).closest('table').children('tbody').find('tr').each(function() {
								$(this).find('td').eq(index + 1).removeClass('disabled');
							});
						} else {
							notify('День запрещен');
							$(thisCell).addClass('disabled');
							$(thisCell).setAttrib('title', 'Разрешить');
							$(thisCell).closest('table').children('tbody').find('tr').each(function() {
								$(this).find('td').eq(index + 1).addClass('disabled');
							});
						}
					}
				}, 'json');
			});
			
			
			
			
			
			// Выбрать дни для операций
			$('[vacationaction]').on(tapEvent, function() {
				var action = $(this).attr('vacationaction'),
					choosedDays = [],
					items;
				
				if (action == 'set') items = $('#vacation').find('[setvacation].choosed:not(.vacated)');
				else if (action == 'confirm') items = $('#vacation').find('[setvacation].choosed');
				else if (action == 'remove') items = $('#vacation').find('[setvacation].choosed.vacated');
				
				$(items).each(function(k, item) {
					var d = $(item).attr('setvacation').split('|');
					choosedDays.push({
						user_id: d[0],
						static_id: d[1],
						date: d[2]
					});
				});
				
				
				
				if (choosedDays.length == 0) {
					$('#vacation').find('[setvacation].choosed').removeClass('choosed');
 					$(vacationActionButtons).find('button').setAttrib('disabled');
					return false;
				} 
				
				if (action == 'remove') {
					popUp({
						title: 'Отменить выбранные дни',
					    width: 500,
					    html: '<p class="red center">Вы действительно хотите отменить выбранные дни?</p>',
					    buttons: [{id: 'cancelDays', title: 'Да'}],
					    closeButton: 'Отмена',
					}, function(cancelDaysWin) {
						$('#cancelDays').on(tapEvent, function() {
							$.post('/vacation/days_action', {action: action, days: choosedDays}, function(response) {
								if (response) {
				 					$(items).removeClass('vacated').removeClass('confirmed');
				 					notify('');
								} else {
									notify('fail!', 'error');
								}
							});
							cancelDaysWin.close();
						});
					});
				} else {
					$.post('/vacation/days_action', {action: action, days: choosedDays}, function(response) {
						if (response) {
							if (action == 'set') {
								$(items).addClass('vacated');
								notify('');
							} else if (action == 'confirm') {
		 						$(items).addClass('vacated confirmed');
		 						notify('');
		 					} 
						} else {
							notify('fail!', 'error');
						}	
					});
				}
				
 				$('#vacation').find('[setvacation].choosed').removeClass('choosed');
 				$(vacationActionButtons).find('button').setAttrib('disabled');
			});
			
			
			
			if (callback && typeof callback == 'function') callback();
		});
	}
	
	
	
	
	
	
	
	//----------------------------------------------- Глобальные запреты
	$('#vacationTableGlobalDisabled').multiChoose({
		item: '[vacationglobaldisabledday]',
		cls: 'choosed'
	}, function() {
		if ($('#vacation').find('[vacationglobaldisabledday].choosed').length > 0) {
			$('[vacationglobalaction]').removeAttrib('disabled');
		} else {
			$('[vacationglobalaction]').setAttrib('disabled');
		}
	});
	
	
	
	
	$('[vacationglobalaction]').on(tapEvent, function() {
		var action = $(this).attr('vacationglobalaction'),
			items,
			choosedItems = [];
			
		if (action == 'set') {
			items = $('#vacationTableGlobalDisabled').find('[vacationglobaldisabledday].choosed:not(.globaldisabled)');
			
			$(items).each(function(k ,i) {
				var item = $(this).attr('vacationglobaldisabledday').split('|');
				choosedItems.push({
					static_id: parseInt(item[0]),
					day: parseInt(item[1])
				});
			});
		} else if (action == 'remove') {
			items = $('#vacationTableGlobalDisabled').find('[vacationglobaldisabledday].choosed.globaldisabled');
			$(items).each(function(k ,i) {
				var item = $(this).attr('vacationglobaldisabledday').split('|');
				choosedItems.push({
					static_id: parseInt(item[0]),
					day: parseInt(item[1])
				});
			});
		}
		
		
		if (choosedItems && action == 'remove') {
			popUp({
				title: 'Отменить запрет',
			    width: 500,
			    height: false,
			    html: '<p class="center red">Вы действительно хотите отменить запрет для выбранных дней?</p>',
			    buttons: [{id: 'globalRemoveConfirm', 'title': 'Да'}],
			    closeButton: 'Отмена',
			}, function(globalRemoveConfirmWin) {
				$('#globalRemoveConfirm').on(tapEvent, function() {
					globalRemoveConfirmWin.wait();
					$.post('/vacation/g_disabled_enabled_days', {action: action, items: choosedItems}, function(response) {
						if (response) {
							$('#vacationTableGlobalDisabled').find('[vacationglobaldisabledday].choosed').removeClass('globaldisabled choosed');
							notify('Запрет отменен!');
						} else {
							notify('Ошибка', 'error');
						}
						globalRemoveConfirmWin.close();
					}, 'json');
				});
			});
		} else if (choosedItems && action == 'set') {
			$.post('/vacation/g_disabled_enabled_days', {action: action, items: choosedItems}, function(response) {
				if (response) {
					$('#vacationTableGlobalDisabled').find('[vacationglobaldisabledday].choosed').addClass('globaldisabled').removeClass('choosed');
					notify('Запрет задан!');
				} else {
					notify('Ошибка', 'error');
				}
			});
		} else {
			$('#vacationTableGlobalDisabled').find('[vacationglobaldisabledday].choosed').removeClass('choosed');
		}
		
			
	});
	
	
});
//--></script>