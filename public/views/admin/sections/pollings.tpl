<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Опросы</h2>
		<div class="buttons notop">
			<button class="" id="{{id}}NewBtn" title="Создать опрос">Создать опрос</button>
		</div>
	</div>
	
	
	
	<table id="pollingsTable">
		<thead>
			<tr>
				<td><strong>Название опроса</strong></td>
				<td><strong>Описание опроса</strong></td>
				<td class="w100px"><strong>Ответивших участников</strong></td>
				<td class="w180px"><strong>Дата и время создания</strong></td>
				<td class="w30rem"><strong>Аудитория опроса</strong></td>
				<td class="w100px"><strong>Вопросы</strong></td>
				<td class="w170px"><strong>Запустить опрос</strong></td>
				<td class="w60px" title="Активен"><strong>Актив.</strong></td>
				<td class="w90px"><strong>Операции</strong></td>
			</tr>
		</thead>
		<tbody id="pollingsList"></tbody>
	</table>
	
</div>	








<script type="text/javascript"><!--
$(function() {
	
	let pollingsScrollTable;
	
	$('#pollingsList').ddrCRUD({
		addSelector: '#pollingsNewBtn',
		before: {
			add: function() {
				if ($('#pollingsList').find('tr:not(.empty)').length == 0) {
					$('#pollingsList').find('tr.empty').remove();
				}
			}
		},
		confirms: {
			getList: function() {
				pollingsScrollTable = $('#pollingsTable').ddrTable({
					minHeight: '50px',
					maxHeight: 'calc(100vh - 240px)',
					fixWidth: false
				});
				
				$('[pollingdatestart]').datepicker({
					dateFormat:         'd M yy г.',
					yearRange:          "2020:"+(new Date().getFullYear() + 1),
					numberOfMonths:     1,
					changeMonth:        true,
					changeYear:         true,
					monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
					monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
					dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
					firstDay:           1,
					minDate:            new Date(2020, 0, 1, 0, 0, 0),
					onSelect: function(stringDate, dateObj) {
						var selectedDay = parseInt(dateObj.selectedDay),
						selectedMonth = parseInt(dateObj.selectedMonth),
						selectedYear = parseInt(dateObj.selectedYear);
						var formDay = '0'+selectedDay, formMonth = '0'+(selectedMonth + 1);
						$(dateObj.input).closest('td').find('[pollingdatestartvalue]').val(selectedYear+'-'+formMonth.substr(-2)+'-'+formDay.substr(-2));
						$(dateObj.input).closest('tr').find('[save], [update]').removeAttrib('disabled');
						$('[pollingstarttime]').removeAttrib('hidden');
					} 
				});
				
			},
			add: function() {
				pollingsScrollTable.scroll('top');
				if ($('#pollingsList').find('tr:not(.empty)').length == 1) {
					pollingsScrollTable.reInit();
				}
			},
			save: function() {
				if ($('#pollingsList').find('tr:not(.empty)').length == 1) {
					pollingsScrollTable.reInit();
				}
				
				$('[pollingdatestart]').datepicker({
					dateFormat:         'd M yy г.',
					yearRange:          "2020:"+(new Date().getFullYear() + 1),
					numberOfMonths:     1,
					changeMonth:        true,
					changeYear:         true,
					monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
					monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
					dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
					firstDay:           1,
					minDate:            new Date(2020, 0, 1, 0, 0, 0),
					onSelect: function(stringDate, dateObj) {
						var selectedDay = parseInt(dateObj.selectedDay),
						selectedMonth = parseInt(dateObj.selectedMonth),
						selectedYear = parseInt(dateObj.selectedYear);
						var formDay = '0'+selectedDay, formMonth = '0'+(selectedMonth + 1);
						$(dateObj.input).closest('td').find('[pollingdatestartvalue]').val(selectedYear+'-'+formMonth.substr(-2)+'-'+formDay.substr(-2));
						$(dateObj.input).closest('tr').find('[save], [update]').removeAttrib('disabled');
						$('[pollingstarttime]').removeAttrib('hidden');
					} 
				});
			},
			remove: function() {
				if ($('#pollingsList').find('tr:not(.empty)').length > 1) {
					pollingsScrollTable.reInit();
				}
			}
		},
		emptyList: '<tr class="empty"><td colspan="9"><p class="empty center fz14px noselect">Нет опросов</p></td></tr>',
		functions: 'pollings/pollings', // PHP функции, например: account/personages/[get,add,save,update,remove]
		listDirection: 'top',
		exceptions: ['[pollingsstatus]'],
		removeConfirm: '<p class="center red strong">Вы действительно хотите удалить опрос?</p>'
	});
	
	
	
	$('#pollingsList').changeInputs(function(input) {
		$(input).parent().addClass('changed');
	});
	
	
	
	
	$('#pollingsList').on(tapEvent, '[pollingauditoryusers]', function() {
		let pollingId = $(this).attr('pollingauditoryusers'),
			usersList = $(this).closest('td').find('[pollingauditoryuserslist]');
		
		usersManager({
			title: 'Менеджер участников|4',
			choosedUsers: function(callback) {
				$.post('pollings/users/get', {polling_id: pollingId}, function(users) {
					callback(users);
				}, 'json').fail(function(e) {
					showError(e);
					notify('Системная ошибка!', 'error');
				});
			},
			chooseType: 'multiple',
			returnFields: 'nickname',
			onChoose: function(users) {
				getAjaxHtml('pollings/users/set', {polling_id: pollingId, users: users}, function(html, stat) {
					if (stat) $(usersList).html(html);
					else $(usersList).html('<li><p class="empty fz12px">Участники не выбраны</p></li>');
					notify('Участники успешно заданы!');
				});
			},
			closeToChoose: true,
			closePos: 'left'
		});
	});
	
	
	
	
	
	
	
	$('#pollingsList').on(tapEvent, '[pollingauditorystatics]', function() {
		let pollingId = $(this).attr('pollingauditorystatics'),
			staticsList = $(this).closest('td').find('[pollingauditorystaticslist]');
		
		popUp({
			title: 'Выбрать статики|4',
			width: 500,
			buttons: [{id: 'chooseStaticsBtn', title: 'Выбрать', disabled: 1}],
			closePos: 'left',
			closeButton: 'Закрыть'
		}, function(pollingAuditoryStaticsWin) {
			pollingAuditoryStaticsWin.setData('pollings/statics/get', {polling_id: pollingId}, function() {
				
				$('#pollingsStaticsTable').ddrTable({
					minHeight: '200px',
					maxHeight: 'calc(100vh - 250px)'
				});
				
				let initStatics = [], choosedStatics = [], checkedStat = 0;
				
				$('#pollingsStaticsTable').find('[pollingsstatic]:checked').each(function() {
					initStatics.push(parseInt($(this).attr('pollingsstatic')));
				});
				
				$('#pollingsStaticsTable').find('[pollingsstatic]').on('change', function() {
					manageButton();
				});
				
				
				
				$('#pollingsStaticsChoodeAll').on(tapEvent, function() {
					if (checkedStat == 0) {
						$('#pollingsStaticsTable').find('[pollingsstatic]:not([checked])').each(function() {
							$(this).setAttrib('checked');
						});
						checkedStat = 1;
					} else {
						$('#pollingsStaticsTable').find('[pollingsstatic]:checked').each(function() {
							$(this).removeAttrib('checked');
						});
						checkedStat = 0;
					}
					manageButton();
				});
				
				
				$('#chooseStaticsBtn').on(tapEvent, function() {
					pollingAuditoryStaticsWin.wait();
					getAjaxHtml('pollings/statics/set', {polling_id: pollingId, statics: choosedStatics}, function(html, stat) {
						if (stat) $(staticsList).html(html);
						else $(staticsList).html('<li><p class="empty fz12px">Статики не выбраны</p></li>');
						notify('Статики успешно заданы!');
						pollingAuditoryStaticsWin.close();
					});
				});
				
				
				
				
				
				function manageButton() {
					choosedStatics = [];
					$('#pollingsStaticsTable').find('[pollingsstatic]:checked').each(function() {
						choosedStatics.push(parseInt($(this).attr('pollingsstatic')));
					});
					
					let moreDiff = choosedStatics.filter(function(i) {return initStatics.indexOf(i) < 0;}),
						lessDiff = initStatics.filter(function(i) {return choosedStatics.indexOf(i) < 0;});
					
					if (moreDiff.length == 0 && lessDiff.length == 0) {
						$('#chooseStaticsBtn:not([disabled])').setAttrib('disabled');
					} else {
						$('#chooseStaticsBtn[disabled]').removeAttrib('disabled');
					}
				}
			});
		});
	});
	
	
	
	
	
	
	$('#pollingsList').on('change', '[pollingsstatus]', function() {
		let pollingId = $(this).attr('pollingsstatus'),
			status = $(this).is(':checked') ? 1 : 0;
		
		$.post('/pollings/status', {polling_id: pollingId, status: status}, function(response) {
			if (response) {
				notify('Опрос '+(status ? 'включен!' : 'выключен!'), (!status && 'info'));
				//if (status) socket.emit('pollings:reload', messId);
			} else {
				notify('Ошибка! Не удалось изменить статус опроса!', 'error');
			}
		}).fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
	
	
	$('#pollingsList').on(tapEvent, '[pollingquestions]', function() {
		let pollingId = $(this).attr('pollingquestions'),
			pollingRow = $(this).closest('tr'),
			pollingQuestionsTable;
		
		popUp({
			title: 'Вопросы опроса|4',
			buttons: [{id: 'pollingsNewQuestionBtn', title: 'Добавить'}],
			closePos: 'left',
			closeButton: 'Закрыть'
		}, function(pollingQuestionsWin) {
			
			(function getQuestions() {
				pollingQuestionsWin.setData('pollings/questions/all', {polling_id: pollingId}, function() {
					pollingQuestionsWin.setWidth(800, function() {
						pollingQuestionsTable = $('#pollingQuestionsTable').ddrTable({minHeight: '50px', maxHeight: 'calc(100vh - 300px)'});
					});
					pollingQuestionsWin.setTitle('Вопросы опроса|4');
					pollingQuestionsWin.setButtons([{id: 'pollingsNewQuestionBtn', title: 'Новый вопрос'}], 'Закрыть');
					
					Sortable.create($('#pollingQuestions')[0], {
						direction: 'vertical',
						animation: 200,
						touchStartThreshold: 1,
						filter: "[pollingquestionnohandle]",
						//handle: '[pollingquestionhandle]',
						preventOnFilter: false,
						sort: true,
						onSort: function (evt) {
							pollingQuestionsWin.wait();
							
							$('#pollingQuestions').find('tr').each(function(k) {
								$(this).find('[pollingquestionorder]').text(k+1);
							});
							
							
							let sordData = [];
							$('#pollingQuestions').find('[pollingquestion]').each(function(k) {
								let qId = parseInt($(this).attr('pollingquestion'));
								sordData.push({
									id: qId,
									sort: (k+1)
								});
							});
							
							$.post('/pollings/questions/sort', {sort_data: sordData}, function(response) {
								if (!response) {
									notify('Ошибка сортировки вопросов!', 'error');
								}
								pollingQuestionsWin.wait(false);
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
								pollingQuestionsWin.wait(false);
							});
						},			  	
					});
					
					
					
					
					
					
					// ------------------------------------------------------------- Новый вопрос
					$('#pollingsNewQuestionBtn').on(tapEvent, function() {
						getQuestionForm();
					});
					
					
					
					
					
					// ------------------------------------------------------------- Редактировать вопрос
					$('#pollingQuestions').on(tapEvent, '[pollingquestionedit]', function() {
						let questionId = $(this).attr('pollingquestionedit');
						getQuestionForm(questionId);
					});
					
					
					
					
					// ------------------------------------------------------------- Удалить вопрос
					$('#pollingQuestions').on(tapEvent, '[pollingquestionremove]', function() {
						let questionId = $(this).attr('pollingquestionremove'),
							qRow = $(this).closest('tr'),
							countQRows = $(this).closest('#pollingQuestions').find('tr:not(.empty)').length;
						
						
						pollingQuestionsWin.dialog('<p class="center red fz16px">Вы действительно хотите удалить вопрос?</p>', 'Удалить', 'Отмена', function() {
							pollingQuestionsWin.wait();
							$.post('/pollings/questions/remove', {question_id: questionId}, function(response) {
								if (response) {
									if (countQRows > 1) {
										$(qRow).remove();
									} else {
										$(qRow).replaceWith('<tr><td><p class="empty center fz14px">Нет вопросов</p></td></tr>');
									}
									pollingQuestionsWin.dialog(false);
									pollingQuestionsWin.wait(false);
									
									let countQuestions = parseInt($(pollingRow).find('[pollingcountquestions]').text());
									$(pollingRow).find('[pollingcountquestions]').text(countQuestions - 1);
									
									if (countQuestions <= 1) {
										$.post('/pollings/status', {polling_id: pollingId, status: 0}, function(response) {
											if (response) {
												$(pollingRow).find('[pollingsstatus]').setAttrib('disabled');
												$(pollingRow).find('[pollingsstatus]').removeAttrib('checked');
											} else {
												notify('Ошибка! Не удалось изменить статус опроса!', 'error');
											}
										}).fail(function(e) {
											showError(e);
											notify('Системная ошибка!', 'error');
										});
									} 
									pollingQuestionsTable.reInit();
								} else {
									notify('Ошибка удаления вопроса!', 'error');
									pollingQuestionsWin.wait(false);
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
								pollingQuestionsWin.wait(false);
							});
						});
					});
					
					
					
					
					
					
					
					
					function getQuestionForm(questionId) {
						let params = questionId ? {question_id: questionId} : {};
						pollingQuestionsWin.setData('pollings/questions/form', params, function() {
							pollingQuestionsWin.setWidth(600);
							pollingQuestionsWin.setTitle(questionId ? 'Редактирование вопроса|4' : 'Новый вопрос|4');
							
							let addEditBtn = questionId ? {id: 'pollingsaUpdateQuestionBtn', title: 'Обновить'} : {id: 'pollingsAddQuestionBtn', title: 'Создать вопрос'};
							pollingQuestionsWin.setButtons([{id: 'pollingsGoBackBtn', title: 'Назад', class: 'popup__buttons_close'}, addEditBtn], 'Закрыть');
							
							setVariantsNumbers();
							Sortable.create($('#pollingsQuestionsVariants')[0], {
								direction: 'vertical',
								animation: 200,
								touchStartThreshold: 1,
								filter: "[pollingquestionvariantsnohandle]",
								preventOnFilter: false,
								sort: true,
								onSort: function (evt) {
									setVariantsNumbers();
								},			  	
							});
							
							
							
							$('#questionVariantsType').on('change', function() {
								let type = $(this).val();
								
								if (type == 3) { // если тип ответа - кастомный
									$('#questionFormVariantsBlock').setAttrib('hidden');
								} else {
									$('#questionFormVariantsBlock').removeAttrib('hidden');
								}
							});
							
							
							
							
							// Добавить варинт
							let newIndex = 1;
							$('#questionvariandAdd').on(tapEvent, function() {
								getAjaxHtml('/pollings/variants/new', {id: 'new_'+(newIndex++)}, function(html) {
									if ($('#pollingsQuestionsVariants').find('tr.empty').length) {
										$('#pollingsQuestionsVariants').find('tr.empty').remove();
									}
									$('#pollingsQuestionsVariants').append(html);
									setVariantsNumbers();
								});
							});
							
							
							// Удалить вариант
							$('#pollingsQuestionsVariants').on(tapEvent, '[pollingquestionvariantremove]', function() {
								let pVId = $(this).attr('pollingquestionvariantremove'),
									row = $(this).closest('tr'),
									countRows = $('#pollingsQuestionsVariants').find('tr').length;
								
								if (countRows > 1) {
									$(row).remove();
									setVariantsNumbers();
								} else {
									$(row).replaceWith('<tr class="empty" pollingquestionvariantsnohandle><td colspan="5"><p class="empty center fz12px">Нет вариантов</p></td></tr>');
								}
							});
							
							
							
							// Запрет на ввод баллов больше 100 и меньше 0
							$('#pollingsQuestionsVariants').on('keyup', '[pollingvariantscores]', function() {
								let scoreVal = $(this).val();
								if (scoreVal < 0) {
									$(this).val(0);
								} else if (scoreVal > 100) {
									$(this).val(100);
								}
							});
							
							
							
							
							function setVariantsNumbers() {
								let rows = $('#pollingsQuestionsVariants').find('tr:not(.empty)');
								if (rows.length) {
									$(rows).each(function(k, item) {
										$(item).find('[pollingsvariantindex]').text(k+1);
									});
								}
							}
							
							
							
							// Назад
							$('#pollingsGoBackBtn').on(tapEvent, function() {
								getQuestions();
							});
							
							
							
							$('#pollingsAddQuestionBtn, #pollingsaUpdateQuestionBtn').on(tapEvent, function() {
								let question = $('#questionText'),
									answersType = $('#questionVariantsType'),
									variants = $(answersType).val() != 3 ? $('#pollingsQuestionsVariants').find('tr:not(.empty)') : null,
									
									variantsData = [],
									stat = true;
									
								if ($(question).val() == '') {
									$(question).addClass('error');
									stat = false;
								}
								
								if ($(answersType).val() == null) {
									$(answersType).addClass('error');
									stat = false;
								}
								
								if ($(answersType).val() != 3) {
									if ($(variants).length < 2) {
										notify('Необходимо добавить как миниум два варианта ответа!', 'error');
										stat = false;
									} else {
										$(variants).each(function(k, item) {
											let variantId = $(this).attr('pollingquestionvariant') || null,
												sort = parseInt($(this).find('[pollingsvariantindex]').text()),
												content = $(this).find('[pollingvariantcontent]'),
												scores = $(this).find('[pollingvariantscores]');
											
											if ($(content).val() == '') {
												$(content).addClass('error');
												stat = false;
												return true;
											}
											
											let row = {
												variant_id: variantId,
												content: $(content).val(),
												scores: parseInt($(scores).val()) || 0,
												sort: sort
											};
											if (questionId) row['question_id'] = questionId;
											variantsData.push(row);
										});
									}
									
									if (stat) saveQuestion();
									
								} else if ($(answersType).val() == 3 && stat) {
									pollingQuestionsWin.dialog('<h3 class="red center fz24px mb10px">Внимание!</h3><p class="red center fz16px">При выборе типа ответа "Кастомный" все варианты ответов безвозвратно удалятся и в ответах участников не будут отображаться эти удаленныйе варианты</p>', 'Удалить', 'Отмена', function() {
										saveQuestion(function() {
											pollingQuestionsWin.dialog(false);
										});
									});
								} 
								
								
								function saveQuestion(callback) {
									if (questionId) {
										pollingQuestionsWin.wait();
										$.post('/pollings/questions/update', {question_id: questionId, title: $(question).val(), answers_type: $(answersType).val(), variants: variantsData}, function(response) {
											if (response) {
												getQuestions();
												
											} else {
												notify('Ошибка! Вопрос не обновлен!' ,'error');
												pollingQuestionsWin.wait(false);
											}
											if (callback && typeof callback == 'function') callback();
										}).fail(function(e) {
											showError(e);
											notify('Системная ошибка!', 'error');
											pollingQuestionsWin.wait(false);
											if (callback && typeof callback == 'function') callback();
										});
									} else {
										pollingQuestionsWin.wait();
										$.post('/pollings/questions/add', {polling_id: pollingId, title: $(question).val(), answers_type: $(answersType).val(), variants: variantsData}, function(response) {
											if (response) {
												let countQuestions = parseInt($(pollingRow).find('[pollingcountquestions]').text());
												$(pollingRow).find('[pollingcountquestions]').text(countQuestions + 1);
												$(pollingRow).find('[pollingsstatus]').removeAttrib('disabled');
												getQuestions();
											} else {
												notify('Ошибка! Вопрос не добавлен!' ,'error');
												pollingQuestionsWin.wait(false);
											}
											if (callback && typeof callback == 'function') callback();
										}).fail(function(e) {
											showError(e);
											notify('Системная ошибка!', 'error');
											pollingQuestionsWin.wait(false);
											if (callback && typeof callback == 'function') callback();
										});
									}
								}
								
								
							});
							
						});
					}
				});
			})();
			
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	$('#pollingsList').on(tapEvent, '[pollingremove]', function() {
		let row = $(this).closest('tr'),
			pollingId = $(this).attr('pollingremove'),
			countRows = $(this).closest('tbody').find('tr').length;
		
		popUp({
			title: 'Удалить опрос',
			width: 400,
			buttons: [{id: 'removePollingBtn', title: 'Удалить'}],
			closePos: 'left',
			closeButton: 'Отмена',
			contentToCenter: true,
		}, function(removePollingWin) {
			removePollingWin.setData('pollings/remove/dialog', function() {
				$('#removePollingBtn').on(tapEvent, function() {
					removePollingWin.wait();
					$.post('/pollings/remove/set', {id: pollingId}, function(response) {
						if (response) {
							if (countRows > 1) {
								$(row).remove();
							} else {
								$(row).replaceWith('<tr><td colspan="7"><p class="empty center">Нет данных</p></td></tr>');
							}
							
							notify('Опрос успешно удален!');
							removePollingWin.close();
						} else {
							notify('Ошибка удаления опроса!', 'error');
							removePollingWin.wait(false);
						}
					}).fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
						removePollingWin.wait(false);
					});
				});
			});
		});
	});
	
	
	
});
//--></script>