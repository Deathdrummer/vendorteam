<div class="section" id="ratingsSection">
	<div class="section__title">
		<h1>Заявки на увольнение</h1>
	</div>
	
	{#<div class="section__buttons" id="sectionButtons">
		<button id="importantinfoSave" title="Сохранить настройки"><i class="fa fa-save"></i></button>
	</div>#}
	
	<div class="section__content" id="sectionContent">
		<div>
			{#<p>Поиск по участнику</p>
			<div class="row align-items-center mb-3">
				<div class="col-auto">
					<div class="field">
						<input type="text" id="searchEventsField" placeholder="Введите никнейм">
					</div>
				</div>
				<div class="col-auto">
					<div class="buttons notop">
						<button id="setSearchFromEvents">Поиск</button>
						<button class="remove" disabled id="resetSearchFromEvents">Сбросить</button>
					</div>
				</div>
			</div>#}
			
			<div id="resignsList">
				<ul class="tabstitles">
					<li id="tabResignsNew" class="active">Новые</li>
					<li id="tabResignsViewed">Обработанные</li>
					<li id="tabResignsArchive">Архив</li>
				</ul>
				
				<div class="tabscontent">
					<div tabid="tabResignsNew" class="visible">
						<table>
							<thead>
								<tr>
									<td class="nowidth"></td>
									<td class="w200px">Никнейм</td>
									<td>Статик</td>
									<td class="w240px">Дата подачи заявки</td>
									<td class="w240px">Дата последнего рабочего дня</td>
									<td class="w110px" title="Опции">Опции</td>
								</tr>
							</thead>
							<tbody>
								{% if resigns[1][1] %}
									{% for item in resigns[1][1] %}
										<tr>
											<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
											<td>{{item.nickname}}</td>
											<td>{{item.static}}</td>
											<td>{{item.date_add|d}} в {{item.date_add|t}}</td>
											<td datelast>{{item.date_last|d}}</td>
											<td class="center">
												<div class="buttons inline">
													<button class="alt" showresign="{{item.id}}" new title="Посмотреть заявку на увольнение"><i class="fa fa-eye"></i></button>
													<button class="remove" removeresign="{{item.id}}" title="Удалить заявку на увольнение"><i class="fa fa-trash"></i></button>
													{#<button class="pay" accessresign="{{item.id}}" title="Подтвердить увольнение"><i class="fa fa-check"></i></button>#}
												</div>
											</td>
											
											{#<td class="access_block center">
												{% if item.stat %}
													<div resign="0" class="success" data-id="{{item.id}}" title="Уволен"></div>
												{% else %}
													<div resign="1" class="forbidden" data-id="{{item.id}}" title="не уволен"></div>
												{% endif %}
											</td>#}
										</tr>
									{% endfor %}
								{% else %}
									<tr class="empty"><td colspan="6"><p class="empty center">Нет данных</p></td></tr>
								{% endif %}
							</tbody>
						</table>	
					</div>
					
					<div tabid="tabResignsViewed">
						<table>
							<thead>
								<tr>
									<td class="nowidth"></td>
									<td class="w200px">Никнейм</td>
									<td>Статик</td>
									<td class="w240px">Дата подачи заявки</td>
									<td class="w240px">Дата последнего рабочего дня</td>
									<td class="w155px" title="Опции">Опции</td>
								</tr>
							</thead>
							<tbody>
								{% if resigns[0][1] %}
									{% for item in resigns[0][1] %}
										<tr>
											<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
											<td>{{item.nickname}}</td>
											<td>{{item.static}}</td>
											<td>{{item.date_add|d}} в {{item.date_add|t}}</td>
											<td datelast>{{item.date_last|d}}</td>
											<td class="center">
												<div class="buttons inline">
													<button class="alt" showresign="{{item.id}}" title="Посмотреть заявку на увольнение"><i class="fa fa-eye"></i></button>
													<button class="pay" accessresign="{{item.id}}" title="Подтвердить увольнение"><i class="fa fa-check"></i></button>
													<button class="remove" removeresign="{{item.id}}" title="Удалить заявку на увольнение"><i class="fa fa-trash"></i></button>
												</div>
											</td>
											
											{#<td class="access_block center">
												{% if item.stat %}
													<div resign="0" class="success" data-id="{{item.id}}" title="Уволен"></div>
												{% else %}
													<div resign="1" class="forbidden" data-id="{{item.id}}" title="не уволен"></div>
												{% endif %}
											</td>#}
										</tr>
									{% endfor %}
								{% else %}
									<tr class="empty"><td colspan="6"><p class="empty center">Нет данных</p></td></tr>
								{% endif %}
							</tbody>
						</table>	
					</div>
					
					<div tabid="tabResignsArchive">
						<table>
							<thead>
								<tr>
									<td class="nowidth"></td>
									<td class="w200px">Никнейм</td>
									<td>Статик</td>
									<td class="w240px">Дата подачи заявки</td>
									<td class="w240px">Дата одобрения заявки</td>
									<td class="w150px" title="Подтвердил увольнение">Подтвердил</td>
									<td class="w60px">Опции</td>
								</tr>
							</thead>
							<tbody>
								{% if resigns[0][0] %}
									{% for item in resigns[0][0] %}
										<tr>
											<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
											<td>{{item.nickname}}</td>
											<td>{{item.static}}</td>
											<td>{{item.date_add|d}} в {{item.date_add|t}}</td>
											<td>{{item.date_success|d}} в {{item.date_success|t}}</td>
											<td>
												{% if item.from is same as(0) %}
													Администратор
												{% else %}
													<small>Оператор:</small>
													{{item.from}}
												{% endif %}
											</td>
											<td class="center">
												<div class="buttons inline">
													<button class="alt" showresign="{{item.id}}" disableedit title="Посмотреть заявку на увольнение"><i class="fa fa-eye"></i></button>
												</div>
											</td>
											{#<td class="access_block center">
												{% if item.stat %}
													<div resign="0" class="success" data-id="{{item.id}}" title="Уволен"></div>
												{% else %}
													<div resign="1" class="forbidden" data-id="{{item.id}}" title="не уволен"></div>
												{% endif %}
											</td>#}
										</tr>
									{% endfor %}
								{% else %}
									<tr class="empty"><td colspan="6"><p class="empty center">Нет данных</p></td></tr>
								{% endif %}
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>




<script type="text/javascript"><!--

	var hash = location.hash.split('.');

	if (hash[1] != undefined) {
		$('.tabstitles').find('li').removeClass('active');
		$('.tabscontent').find('[tabid]').removeClass('visible');
		
		$('#'+hash[1]).addClass('active');
		$('[tabid="'+hash[1]+'"]').addClass('visible');
	}
	
	
	
	
	
	
	//------------------------- Посмотреть заявку на увольнение
	$('body').off(tapEvent, '[showresign]').on(tapEvent, '[showresign]', function() {
		var thisItem = this,
			rowDate = $(thisItem).closest('tr'),
			id = $(thisItem).attr('showresign'),
			disableedit = $(thisItem).hasAttr('disableedit') ? 1 : 0,
			isnew = $(thisItem).hasAttr('new') ? 1 : 0;
		
		popUp({
			title: 'Заявка на увольнение',
		    width: 800,
		    buttons: isnew && [{id: 'setVievedStat', title: 'Обработать'}],
		    closeButton: 'Закрыть',
		}, function(showResignWin) {
			showResignWin.wait();
			getAjaxHtml('admin/show_resign', {id: id, disableedit: disableedit}, function(html) {
				showResignWin.setData(html);
				
				if (!disableedit) {
					let d = new Date();
					
					$('#lastWorkDay').datepicker({
				        dateFormat:         'd M yy г.',
				        //yearRange:          "2020:"+(new Date().getFullYear() + 1),
				        numberOfMonths:     1,
				        changeMonth:        true,
				        changeYear:         true,
				        monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
				        monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
				        dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
				        firstDay:           1,
				        minDate:            d,
				        //maxDate:          	'+1m',
				        onSelect: function(stringDate, dateObj) {
				        	showResignWin.wait();
				        	let dateString = dateObj.currentDay+'-'+(dateObj.currentMonth+1)+'-'+dateObj.currentYear;
				        	
				        	$.post('/admin/change_resign_lastday', {date: dateString, id: id}, function(response) {
				        		if (response) {
				        			$(rowDate).find('[datelast]').text(stringDate);
				        			notify('Дата успешно изменена!');
				        		} else {
				        			notify('Ошибка! Не удалось изменить дату', 'error');
				        		}
				        		showResignWin.wait(false);
				        	}).fail(function(e) {
								notify('Системная ошибка!', 'error');
								showError(e);
							});
				        } 
				    });
				}
					
			    
			    
			    $('#setVievedStat').on(tapEvent, function() {
			    	showResignWin.wait();
			    	$.post('/admin/set_vieved', {id: id}, function(response) {
		        		if (response) {
		        			$(rowDate).remove();
		        			notify('Заявка обработана!');
		        			showResignWin.close();
		        			renderContentData();
		        		} else {
		        			notify('Ошибка! Не удалось обработать заявку', 'error');
		        		}
		        		showResignWin.wait(false);
		        	}).fail(function(e) {
						notify('Системная ошибка!', 'error');
						showError(e);
					});
			    });
				
			}, function() {
				showResignWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	//------------------------- Изменить статус "Заявки на увольнение"
	$('body').off(tapEvent, '[accessresign]').on(tapEvent, '[accessresign]', function() {
		var thisItem = this,
			thisRow = $(thisItem).closest('tr'),
			id = $(thisItem).attr('accessresign');
		
		popUp({
			title: 'Подтвердить увольнение',
		    width: 800,
		    buttons: [{id: 'confirmResign', title: 'Подтвердить'}],
		    closeButton: 'Отмена',
		}, function(accessResignWin) {
			accessResignWin.wait();
			getAjaxHtml('admin/pay_deposit_form', {id: id}, function(html) {
				accessResignWin.setData(html);
				
				let fullSumm = parseFloat($('#confirmResignFullSumm').val()) || false;
				
				if (fullSumm) {
					$('#chengeSummPercent').on('change', function() {
						let summ = parseFloat($(this).val());
						$('#confirmResignSumm').val(summ);
						let balanceSumm = fullSumm - summ;
						$('#confirmResignBalance').text($.number(balanceSumm, 2, '.', ' '));
						
						if (summ < fullSumm) $('#confirmResignCommentToBalance').closest('.resign__textblock').removeClass('resign__textblock_hidden');
						else $('#confirmResignCommentToBalance').closest('.resign__textblock').addClass('resign__textblock_hidden');
					});
					
					$('#confirmResignSumm').on('change keyup', function() {
						let summ = parseFloat($(this).val());
						let balanceSumm = fullSumm - summ;
						$('#confirmResignBalance').text($.number(balanceSumm, 2, '.', ' '));
						
						if (summ < fullSumm) $('#confirmResignCommentToBalance').closest('.resign__textblock').removeClass('resign__textblock_hidden');
						else $('#confirmResignCommentToBalance').closest('.resign__textblock').addClass('resign__textblock_hidden');
					});
				}
				
					
				
				$('#confirmResign').on(tapEvent, function() {
					let stat = true,
						summ = $('#confirmResignSumm'),
						params = {};
					
					params['resign'] = {
						id: id,
						from: 'admin',
						summ: parseFloat($(summ).val()),
						summ_to_balance: fullSumm - parseFloat($(summ).val()),
						stat: 0
					};	
					
					if (fullSumm) {
						let userId = $('#confirmResignUser'),
							order = $('#confirmResignOrder'),
							comment = $('#confirmResignComment'),
							commentToBalance = $('#confirmResignCommentToBalance');
						
						if ($(order).val() == '') {
							$(order).addClass('error');
							notify('Необходимо указать номер заказа.', 'error');
							stat = false;
						}
						
						if ($(summ).val() == '') {
							$(summ).addClass('error');
							notify('Необходимо указать сумму выплаты участнику.', 'error');
							stat = false;
						}
						if (parseFloat($(summ).val()) > fullSumm) {
							$(summ).addClass('error');
							$(summ).val(fullSumm);
							$('#confirmResignBalance').text($.number(0, 2, '.', ' '));
							notify('Сумма не должна привышать максимальную', 'error');
							stat = false;
						}
						
						if ($(comment).val() == '') {
							$(comment).addClass('error');
							notify('Необходимо указать комментарий.', 'error');
							stat = false;
						}
						
						if (parseFloat($(summ).val()) < fullSumm && $(commentToBalance).val() == '') {
							$(commentToBalance).addClass('error');
							notify('Необходимо указать комментарий по удержанию средств на балансе.', 'error');
							stat = false;
						}
						
						params['order'] = {
							user_id: parseInt($(userId).val()),
							order: $(order).val(),
							summ: parseFloat($(summ).val()),
							full_summ: fullSumm,
							comment: $(comment).val(),
							comment_to_balance: $(commentToBalance).val()
						};
					}
					
					
					if (stat) {
						accessResignWin.wait();
						$.post('/admin/change_resign_stat', params, function(response) {
							if (response) {
								notify('Заявка на увольнение утверждена!');
								$(thisRow).remove();
								accessResignWin.close();
								renderContentData();
							} else {
								notify('Ошибка! Заявка на увольнение не утверждена', 'error');
							}
							accessResignWin.wait(false);
						}).fail(function(e) {
							showError(e);	
							notify('Системная ошибка!', 'error');
							accessResignWin.wait(false);
						});
					}
					
						
				});
				
			}, function() {
				accessResignWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	//------------------------- Удалить заявку на увольнение
	$('body').off(tapEvent, '[removeresign]').on(tapEvent, '[removeresign]', function() {
		var thisItem = this,
			thisRow = $(thisItem).closest('tr'),
			block = $(thisItem).closest('tbody'),
			id = $(thisItem).attr('removeresign');
		
		popUp({
			title: 'Удалить заявку',
		    width: 400,
		    html: '<p class="green done info center">Вы действительно хотите удалить заявку?</p>',
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'removeResign', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(removeResignWin) {
			$('#removeResign').on(tapEvent, function() {
				removeResignWin.wait();
				$.post('/admin/remove_resign', {id: id}, function(response) {
					if (response) {
						notify('Заявка успешно удалена!');
						$(thisRow).remove();
						if ($(block).find('tr').length == 0) {
							$(block).html('<tr class="empty"><td colspan="6"><p class="empty center">Нет данных</p></td></tr>');
						}
						removeResignWin.close();
						
					} else {
						notify('Ошибка удаления заяки!', 'error');
					}
					removeResignWin.wait(false);
				}).fail(function(e) {
					showError(e);	
					notify('Системная ошибка!', 'error');
					removeResignWin.wait(false);
				});
			});
		});	
	});
	
	
	
	
//--></script>