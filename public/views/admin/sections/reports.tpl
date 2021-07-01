<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Отчеты</h2>
	</div>
	
	<ul class="tabstitles">
		<li id="main" class="active">Выплаты участникам</li>
		<li id="rewards">Премии</li>
		<li id="second">Список заказов</li>
		<li id="paymentsPatterns">Payment Brago</li>
		<li id="paymentRequests">Заявки на оплату</li>
		<li id="keys">Ключи</li>
		<li id="wallet">Выплата баланса</li>
	</ul>
	
	
	
	<div class="tabscontent">
		<div tabid="main" class="visible">
			<fieldset>
				<legend>Выплаты участникам</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<input type="hidden" id="staticsCashData" value="">
						<button id="setStaticsCash" class="fieldheight" title="Бюджет статиков"><i class="fa fa-rub"></i></button>
						
						<input type="hidden" id="choosenPeriodId" value="">
						<button id="periodsButton" class="fieldheight" title="Периоды"><i class="fa fa-calculator"></i></button>
						
						<button id="setMainReport" class="fieldheight alt ml-5" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
						<input type="hidden" id="reportVariant" value="">
						
						<button id="reportPatternsButton" class="fieldheight alt" title="Отчеты"><i class="fa fa-list-alt"></i></button>
						<button id="saveMainReport" class="fieldheight alt" disabled title="Сохранить отчет"><i class="fa fa-save"></i></button>
					</div>
				</div>
				
				<div class="item inline"><h3 id="mainReportTitle"></h3></div>
				
				<div id="mainReport" class="reports mt-3"></div>
			</fieldset>
		</div>
		
		
		
		
		
		<div tabid="rewards">
			<fieldset>
				<legend>Премии</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<button id="rewardsPeriods" class="fieldheight" title="Премиальные пириоды"><i class="fa fa-calculator"></i></button>
					</div>
				</div>
				
				<div class="item inline"><h3 id="rewardsReportTitle"></h3></div>
				
				<div id="rewardsReport" class="reports mt-3"></div>
			</fieldset>
		</div>
		
		
		
		
		
		<div tabid="second">
			<fieldset>
				<legend>Список заказов</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<input type="hidden" id="ordersReportperiodId" value=''>
						<button ordersperiodsbutton class="fieldheight" title="Периоды"><i class="fa fa-calculator"></i></button>
						
						<button id="setOrdersReport" class="nowrap fieldheight alt ml-5" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
						<a id="saveOrdersReport" class=" button nowrap fieldheight alt" download="" href="{{base_url('reports/export_orders')}}"><i class="fa fa-download"></i></a>
						
					</div>
				</div>
				
				
				<div id="ordersReport" class="reports mt-3"></div>
			</fieldset>
		</div>
		
		
		
		
		
		
		<div tabid="paymentsPatterns">
			<fieldset>
				<legend>Выплаты по диапазонам</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<input type="hidden" id="staticsCashData" value=''>
						<button id="choosePaymentsPatterns" class="fieldheight" title="Выбрать диапазоны"><i class="fa fa-list"></i></button>
						<a class="button fieldheight" id="downloadPaymentsPatterns" href="#" download="" disabled><i class="fa fa-download"></i></a>
					</div>
				</div>
				
				<div id="paymentsPatternsReport" class="reports mt-3"></div>
				
			</fieldset>
		</div>
		
		
		
		
		
		<div tabid="paymentRequests">
			<fieldset>
				<legend>Заявки на оплату</legend>
				
				<div class="d-flex align-items-center">
					<div class="item inline">
						<div class="buttons notop">
							<button id="paymentRequestsNew" class="fieldheight" title="Новая заявка на оплату"><i class="fa fa-plus"></i></button>
							<button id="paymentRequestsTemplates" class="fieldheight ml-0" title="Новая заявка из шаблона"><i class="fa fa-newspaper-o"></i></button>
							<a class="button fieldheight" target="_self" href="{{base_url()}}reports/paymentrequest_export" download="Заявки_на_оплату_{{date('Y-m-d_H_i')}}.csv" title="Экспортировать отчет"><i class="fa fa-download"></i></a>
							<button id="paymentRequestsSetStatToAll" class="fieldheight ml-0" title="Рассчитать все заявки"><i class="fa fa-list-ol"></i></button>
							<button id="setSalaryBtn" class="fieldheight ml-0" title="Рассчитать оклады"><i class="fa fa-money"></i></button>
							<button id="addictPayBtn" class="fieldheight ml-0 pay" title="Дополнительные выплаты"><i class="fa fa-money"></i></button>
						</div>
					</div>
					
					
					<div class="item inline ml-5">
						<div class="select">
							<select id="paymentRequestsFindUsersField">
								<option value="nickname">Никнейм</option>
								<option value="payment">Способ оплаты</option>
								<option value="order">№ заказа</option>
								<option value="summ">Сумма заказа</option>
							</select>
							<div class="select__caret"></div>
						</div>
					</div>
					
					<div class="item inline ml-1">
						<div class="field">
							<input type="text" id="paymentRequestsFindUsersValue">
						</div>
					</div>
					
					<div class="item inline ml-1">
						<div class="buttons notop">
							<button id="paymentRequestsFindUsersButton">Поиск</button>
						</div>
					</div>
				</div>
					
			</fieldset>
			
			{% if payment_requests_list %}
				<fieldset>
					<legend>Список заявок</legend>
					
					<table id="paymentRequestsList">
						<thead>
							<tr>
								<td class="w1"></td>
								<td class="nowrap" paymentrequestsort="nickname">Никнейм <i class="fa fa-sort"></i></td>
								<td class="nowrap" paymentrequestsort="static">Статик <i class="fa fa-sort"></i></td>
								<td class="nowrap" paymentrequestsort="payment">Способ оплаты <i class="fa fa-sort"></i></td>
								<td class="nowrap" paymentrequestsort="order">№ заказа <i class="fa fa-sort"></i></td>
								<td class="nowrap" paymentrequestsort="summ">Сумма заказа <i class="fa fa-sort"></i></td>
								<td>Удержано в резерв</td>
								<td>Комментарий</td>
								<td>Дата</td>
								{#<td class="w1">Расчет</td>#}
							</tr>
						</thead>
						{% for item in payment_requests_list %}
							<tbody>
								<tr>
									<td class="nopadding">
										{% if item.avatar %}
											<div class="avatar mini" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}')"></div>
										{% else %}
											<div class="avatar mini" style="background-image: url('{{base_url('public/images/user_mini.jpg')}}')"></div>
										{% endif %}
									</td>
									<td>{{item.nickname}}</td>
									<td class="w200px">
										<div class="d-flex align-items-center">
											<div class="mr-1">
												{% if item.static_icon %}
													<img style="width: 26px" src="{{base_url('public/filemanager/'~item.static_icon)}}" alt="">
												{% else %}
													<img style="width: 26px" src="{{base_url('public/images/deleted_mini.jpg')}}" alt="">
												{% endif %}
											</div>
											<div>{{item.static_name}}</div>
										</div>
									</td>
									<td>{{item.payment}}</td>
									<td>{{item.order}}</td>
									<td class="nowrap">{{item.summ|number_format(2, '.', ' ')}} <small>руб.</small></td>
									<td class="nowrap">{{item.to_deposit|number_format(2, '.', ' ')}} <small>руб.</small></td>
									<td><small style="word-break: break-all; white-space: pre-wrap;">{{item.comment}}</small></td>
									<td class="nowrap">{{item.date|d}} {{item.date|t}}</td>
									{#<td class="square_block center">
										{% if item.paid %}
											<div prpaydone="0" data="{{item.id}}|{{item.user_id}}|{{item.summ}}" class="success" title="Не рассчитан"><i class="fa fa-check-square-o"></i></div>
										{% else %}
											<div prpaydone="1" data="{{item.id}}|{{item.user_id}}|{{item.summ}}" class="forbidden" title="рассчитан"><i class="fa fa-square-o"></i></div>
										{% endif %}
									</td>#}
								</tr>
							</tbody>
						{% endfor %}
					</table>
				</fieldset>
			{% endif %}
		</div>
		
		<div tabid="keys">
			<fieldset>
				<legend>Ключи</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<input type="hidden" id="staticsCashDataKeys" value="">
						<button id="setStaticsCashKeys" class="fieldheight" title="Бюджет статиков"><i class="fa fa-rub"></i></button>
						
						<input type="hidden" id="choosenPeriodIdKeys" value="">
						<button id="periodsKeysButton" class="fieldheight" title="Периоды"><i class="fa fa-calculator"></i></button>
						
						<button id="setKeysReport" class="fieldheight alt ml-5" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
						<button id="reportPatternsKeysButton" class="fieldheight alt" title="Отчеты"><i class="fa fa-list-alt"></i></button>
						<button id="saveKeysReport" class="fieldheight alt" title="Сохранить отчет"><i class="fa fa-save"></i></button>
					</div>
				</div>
				
				<div class="item inline"><h3 id="keysReportTitle"></h3></div>
				
				<div id="keysReport" class="reports mt-3"></div>
			</fieldset>
		</div>
		
		<div tabid="wallet">
			<fieldset>
				<legend>Выплата баланса</legend>
				
				<div class="item inline">
					<div class="d-flex">
						<div class="buttons notop">
							<button id="buildWalletPayments" class="fieldheight" title="Сформировать платежные данные"><i class="fa fa-bar-chart"></i></button>
							<button id="getWalletReportsList" class="fieldheight" title="Платежные поручения"><i class="fa fa-list-alt"></i></button>
							<button id="saveWalletOrder" disabled class="fieldheight" title="Сохранить платежное поручение"><i class="fa fa-save"></i></button>
						</div>
						<div class="ml30px">
							<h3 class="mb-0" id="savedReportTitle"></h3>
							<p id="savedReportDate"></p>
						</div>
					</div>
						
				</div>
				
				<div id="walletReport" class="reports mt-3"></div>
			</fieldset>
		</div>
		
	</div>	
</div>










<script type="text/javascript"><!--
$(document).ready(function() {
	
	//------------------------------------------------------------------------------------------------ 1 Отчет
	
	
	// ------------------------Сформировать первый отчет
	$('#setMainReport').on(tapEvent, function() {
		var staticsCash = $('#staticsCashData').val(),
			periodId = $('#choosenPeriodId').val(),
			stat = true;
		
		if (!staticsCash) {
			notify('Ошибка! Необходимо задать бюджет для статиков!', 'error');
			$('#setStaticsCash').addClass('fail error');
			stat = false;
		}
		
		if (!periodId) {
			notify('Ошибка! Необходимо указать коэффициенты!', 'error');
			$('#periodsButton').addClass('fail error');
			stat = false;
		}
		
		if(stat) {
			popUp({
				title: 'Выбрать вариант отчета',
			    width: 500,
			    closeButton: 'Отмена',
			}, function(reportVariantWin) {
				reportVariantWin.wait();
				getAjaxHtml('reports/get_report_variants', function(html) {
					reportVariantWin.setData(html, false);
					
					$('[choosereportrariant]').on(tapEvent, function() {
						reportVariantWin.wait();
						var reportVariant = $(this).attr('choosereportrariant');
						if(stat) {
							getAjaxHtml('reports/get_main_report', {cash: staticsCash, period_id: periodId, variant: reportVariant}, function(html) {
								$('#mainReport').html(html);
								$('#mainReport').ready(function() {
									$('.scroll').ddrScrollTable();
									$('#mainReportTitle').text('');
								});
								$('[id^="tabstatic"]:first').addClass('active');
								$('[tabid^="tabstatic"]:first').addClass('visible');
								$('#reportVariant').val(reportVariant);
								reportVariantWin.close();
								$('#saveMainReport').removeAttrib('disabled');
							});
						}
					});
				}, function() {
					reportVariantWin.wait(false);
				});
			});
		}
	});
	
	
	
	// ---------------------------------- Задать бюджет статиков
	$('#setStaticsCash').on(tapEvent, function() {
		$(this).removeClass('fail error');
		popUp({
			title: 'Задать бюджет статиков',
		    width: 500,
		    html: '<div id="staticsCash"></div>',
		    buttons: [{id: 'setStaticsCashButton', title: 'Задать бюджет'}],
		    closeButton: 'Отмена'
		}, function(staticsCashWin) {
			staticsCashWin.wait();
			
			var data = $('#staticsCashData').val() || {};
			$.post('/reports/get_statics_to_cash', {set_cash: data}, function(html) {
				if (html) {
					$('#staticsCash').html(html);
					$('#staticsCash').find('input').number(true, 0, '.', ' ');
					$('#staticsCash').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
					
					var checkedStat = true,
						checks = $('#staticsCash').find('[choosestatictodeposit]');
					$('#staticsDepositCheckAll').on(tapEvent, function() {
						checkedStat = !checkedStat;
						
						$(checks).each(function() {
							if (checkedStat) $(this).setAttrib('checked');
							else $(this).removeAttrib('checked');
						});
					});
					
					$('#setStaticsCashButton').on(tapEvent, function() {
						var staticsCash = {};
						$('#staticsCash').find('[choosestatictodeposit]:checked').each(function() {
							var thisInput = $(this).closest('tr').find('input[static]');
								staticId = $(thisInput).attr('static'),
								staticValue = parseInt($(thisInput).val());
							staticsCash[staticId] = staticValue;
						});
						
						$('#staticsCashData').val(JSON.stringify(staticsCash));
						staticsCashWin.close();
						$('#setStaticsCash').addClass('done');
						notify('Бюджет статиков задан!');
						$('#saveMainReport').setAttrib('disabled');
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
	var periodsWin, currentPeriodToTime, setPeriodStartTime, choosenPeriods; 
	$('#periodsButton').on(tapEvent, function() {
		$(this).removeClass('error fail');
		choosenPeriods = [];
		popUp({
			title: 'Периоды',
		    width: 700,
		    buttons: [{id: 'newPeriod', title: 'Новый период', disabled: true, class: 'alt'}, {id: 'choosePeriods', title: 'Выбрать периоды', disabled: true}]
		}, function(pRWin) {
			periodsWin = pRWin;
			periodsWin.wait();
			
			getAjaxHtml('reports/get_reports_periods', {edit: 1}, function(html) {
				periodsWin.setData(html, false);
				$('#periodsList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				
				$('#choosePeriods').on(tapEvent, function() {
					$('#choosenPeriodId').val(JSON.stringify(choosenPeriods));
					if (choosenPeriods.length > 1) notify('Периоды выбраны!');
					else notify('Период выбран!');
					$('#periodsButton').addClass('done');
					periodsWin.close();
					$('#saveMainReport').setAttrib('disabled');
				});
				
				
				
				//---------------------------------------- Задать время активации периода
				setPeriodStartTime = new jBox('Tooltip', {
					attach: '[setperiodstarttime]',
					trigger: 'click',
					addClass: 'setperiodstarttime',
					outside: 'x',
					ignoreDelay: true,
					zIndex: 1000,
					position: {
					  x: 'right',
					  y: 'center'
					}
				});
				
				$('.popup').scroll(function() {
					setPeriodStartTime.close();
				});
					
				
				$('#newPeriod').prop('disabled', false);
				$('#choosePeriods').prop('disabled', false);
			}, function() {
				periodsWin.wait(false);
			});
			
			$('#newPeriod').on(tapEvent, function() {
				$.post('/reports/new_period', function(html) {
					$('#periodsList tbody').prepend(html);
					
					$('#periodsList tbody').find('.saveperiod').off(tapEvent);
					$('#periodsList tbody').find('.saveperiod').on(tapEvent, function() {
						var thisRow = $(this).closest('tr'),
							thisName = $(thisRow).find('input').val();
						
						if (thisName != '') {
							$.post('/reports/save_period', {name: thisName}, function(periodId) {
								if (periodId) {
									notify('Период успешно сохранен!');
									
									var html = '<td>'+thisName+'</td>';
										html += '<td class="nowidth"><div class="buttons"><button class="remove" title="Удалить период" periodtoarchive="'+periodId+'"><i class="fa fa-trash"></i></button></div></td>';
										html += '<td class="nowidth"><div class="buttons"><button title="Выбрать период" chooseperiod="'+periodId+'"><i class="fa fa-calculator"></i></button></div></td>';
										html += '<td class="nowidth">';
										html += 	'<div class="buttons">';
										html += 		'<button setperiodstarttime="'+periodId+'" title="Задать время активации"><i class="fa fa-clock-o"></i></button>';
										html += 	'</div>'
										html += '</td>';
										html += '<td class="nowidth center">';
										html += 	'<div class="checkblock">';
										html += 		'<input id="actualperiod'+periodId+'" setactualperiod="'+periodId+'|u" name="setactiveperiodu" type="radio">';
										html += 		'<label for="actualperiod'+periodId+'"></label>';
										html += 	'</div>';
										html += '</td>';
										html += '<td class="nowidth center">';
										html += 	'<div class="checkblock">';
										html += 		'<input id="actualperiod'+periodId+'" setactualperiod="'+periodId+'|e" name="setactiveperiode" type="radio">';
										html += 		'<label for="actualperiod'+periodId+'"></label>';
										html += 	'</div>';
										html += '</td>';
										html += '<td class="nowidth center">';
										html += 	'<div class="checkblock">';
										html += 		'<input id="actualperiod'+periodId+'" setactualperiod="'+periodId+'|a" name="setactiveperioda" type="radio">';
										html += 		'<label for="actualperiod'+periodId+'"></label>';
										html += 	'</div>';
										html += '</td>';
										html += '<td class="nowidth center">';
										html += 	'<div class="checkblock">';
										html += 		'<input id="closedperiod'+periodId+'" closeperiod="'+periodId+'" type="checkbox">';
										html += 		'<label for="closedperiod'+periodId+'"></label>';
										html += 	'</div>';
										html += '</td>';
										html += '<td class="nowidth center">';
										html += 	'<div class="checkblock">';
										html += 		'<input id="toVisitsPeriod'+periodId+'" choosetovisits="'+periodId+'" type="checkbox">';
										html += 		'<label for="toVisitsPeriod'+periodId+'"></label>';
										html += 	'</div>';
										html += '</td>';
									$(thisRow).html(html);
								}
							});
						} else {
							notify('Ошибка! Название не может быть пустым!', 'error');
							$(thisRow).find('input').addClass('error');
						}	
					});
				}, 'html').fail(function(e) {
					showError(e);
					notify('Системная ошибка!', 'error');
				});
			});
		});
	});
	
	
	
	
	
	//---------------------------------------- Выбрать период
	$('body').off(tapEvent, '[chooseperiod]').on(tapEvent, '[chooseperiod]', function() {
		var thisId = parseInt($(this).attr('chooseperiod'));
		if ($(this).hasClass('done')) {
			$(this).removeClass('pay done');
			choosenPeriods.splice(choosenPeriods.indexOf(thisId), 1);
		} else {
			choosenPeriods.push(thisId);
			$(this).addClass('pay done');
		}
	});
	
	
	
	$('body').off(tapEvent, '[activateperiods]').on(tapEvent, '[activateperiods]', function() {
		var data = [],
			items = $(this).closest('.periods_activate_block').children('div.changed:not(.button)');
		if (items.length) {
			$(items).each(function() {
				var zone = parseInt($(this).attr('zone')),
					time = $(this).find('.activate_periods_time').val() || null,
					date = $(this).find('[date]').attr('date') || null;
				data.push({
					zone: zone,
					date: date,
					time: time
				});
			});
			$.post('/reports/set_timer_activate_periods', {data: data, period: currentPeriodToTime}, function(response) {
				if (response == 1) {
					notify('Активация периодов успешно задана!');
					setPeriodStartTime.close();
					$('body').find('[setperiodstarttime]').removeClass('opened');
				} else if (response == 2) {
					notify('Необходимо задать данные', 'info');
				} else {
					notify('Ошибка! Активация периодов не задана!', 'error');
				}
			});
		} else {
			notify('Необходимо задать данные', 'info');
		}	
	});
	
	
	$('body').on(tapEvent, function(e) {
		if ($('[setperiodstarttime]:hover').length == 0 && $('body').find('.setperiodstarttime:visible').length > 0 && $('body').find('.setperiodstarttime:hover').length == 0 && $('body').find('.ui-datepicker:hover').length == 0) {
			setPeriodStartTime.close();
			$('body').find('[setperiodstarttime]').removeClass('opened');
		}
	});
	
	
	
	
	
	$('body').off(tapEvent, '[setperiodstarttime]').on(tapEvent, '[setperiodstarttime]', function() {
		var thisItem = this;
		currentPeriodToTime = $(thisItem).attr('setperiodstarttime');
		if (!$(thisItem).hasClass('opened')) {
			$('body').find('[setperiodstarttime]').removeClass('opened');
			$(thisItem).addClass('opened');
			setPeriodStartTime.open({ajax: {
				url: '/reports/get_periods_activate_block',
				data: {period: currentPeriodToTime},
				reload: true
			}});
		} else {
			$(thisItem).removeClass('opened');
			setPeriodStartTime.close();
		}
	});
	
	
	
	$('body').off(tapEvent, '[setactualperiod]').on(tapEvent, '[setactualperiod]', function() {
		var data = $(this).attr('setactualperiod').split('|'),
			thisPeriodId = data[0],
			thisZone = data[1];
		
		$.post('/reports/set_active_period', {id: thisPeriodId, zone: thisZone}, function(response) {
			if (response) notify('Период активирован!');
			else notify('Период не активирован!', 'error');
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	$('body').off(tapEvent, '[closeperiod]').on(tapEvent, '[closeperiod]', function() {
		var thisPeriodId = $(this).attr('closeperiod');
		
		$.post('/reports/close_period', {id: thisPeriodId}, function(response) {
			if (response) notify('Статус изменен!');
			else notify('Статус не изменен!', 'error');
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	$('body').off(tapEvent, '[choosetovisits]').on(tapEvent, '[choosetovisits]', function() {
		var thisPeriodId = $(this).attr('choosetovisits');
		
		$.post('/reports/period_to_visits', {id: thisPeriodId}, function(response) {
			if (response) notify('Статус изменен!');
			else notify('Статус не изменен!', 'error');
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	$('body').off(tapEvent, '[periodtoarchive]').on(tapEvent, '[periodtoarchive]', function() {
		var thisItem = this,
			thisPeriodId = $(thisItem).attr('periodtoarchive');
			
		periodsWin.dialog('<p>Вы действительно хотите удалить период?</p>', 'Да', 'Отмена', function() {
			$.post('/reports/period_to_archive', {id: thisPeriodId}, function(response) {
				if (response) {
					$(thisItem).closest('tr').remove();
				 	notify('Период помещен в архив!');
				 	periodsWin.dialog(false);
				} else notify('Ошибка перемещения в архив!', 'error');
			}, 'json').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// ----------------------------- Открыть список паттернов первого отчета
	var reportPatternsWin;
	$('#reportPatternsButton').on(tapEvent, function() {
		popUp({
			title: 'Сохраненные отчеты',
		    width: 800,
		    html: '<div id="reportPatternsList"></div>',
		    winClass: 'reportpatternslist',
		}, function(rPWin) {
			reportPatternsWin = rPWin;
			reportPatternsWin.wait();
			var html = '', limit = 5, offset = 0;
			
			getAjaxHtml('reports/get_main_reports_patterns', {limit: limit, offset: offset}, function(html) {
				$('#reportPatternsList').html(html);
				$('#reportPatternsList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				
				if ($(html).find('tbody').children('tr').length == limit) {
					reportPatternsWin.setButtons([{id: 'getEarlyPatterns', title: 'Вниз'}, {id: 'getOlderPatterns', title: 'Вверх'}]);
				}
			}, function() {
				reportPatternsWin.wait(false);
			});
			
			
			
			// Открыть ниже
			$('.reportpatternslist').on(tapEvent, '#getEarlyPatterns', function() {
				reportPatternsWin.wait();
				offset += limit;
				getAjaxHtml('reports/get_main_reports_patterns', {limit: limit, offset: offset}, function(html, stat) {
					if (stat) {
						$('#getOlderPatterns').prop('disabled', false);
						$('#reportPatternsList').html(html);
						$('#reportPatternsList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
					} else {
						$('#getEarlyPatterns').prop('disabled', true);
						notify('Это самые последние отчеты!', 'info');
						offset -= limit;
					}
				}, function() {
					reportPatternsWin.wait(false);
				});
			});
			
			// Открыть выше
			$('.reportpatternslist').on(tapEvent, '#getOlderPatterns', function() {
				if (offset == 0) {
					notify('Это самые последние отчеты!', 'info');
					$('#getOlderPatterns').prop('disabled', true);
					return true;
				}
				reportPatternsWin.wait();
				offset -= limit;
				getAjaxHtml('reports/get_main_reports_patterns', {limit: limit, offset: offset}, function(html, stat) {
					if (stat) {
						$('#reportPatternsList').html(html);
						$('#getEarlyPatterns').prop('disabled', false);
					} else {
						$('#getOlderPatterns').prop('disabled', true);
						notify('Это самые последние отчеты!', 'info');
					}
				}, function() {
					reportPatternsWin.wait(false);
				});
			});
			
		});
	});
	
	
	// ----------------------------- Сформировать первый отчет по паттерну
	$('body').off(tapEvent, '[patternid]').on(tapEvent, '[patternid]', function() {
		var thisPatternId = $(this).attr('patternid'),
			thisPatternTitle = $(this).closest('tr').children('td:first').text();
		reportPatternsWin.wait();
		getAjaxHtml('reports/get_main_report', {pattern_id: thisPatternId}, function(html, stat) {
			$('#mainReportTitle').text(thisPatternTitle);
			$('#mainReport').html(html);
			$('#mainReport').ready(function() {
				$('.scroll').ddrScrollTable();
			});
			$('[id^="tabstatic"]:first').addClass('active');
			$('[tabid^="tabstatic"]:first').addClass('visible');
			if (!stat) notify('Нет данных!', 'info');
			reportPatternsWin.close();
		}, function() {
			reportPatternsWin.wait(false);
		});
	});
	
	
	// ----------------------------- отправить сохраненный отчет в архив
	$('body').off(tapEvent, '[patterntoarchive]').on(tapEvent, '[patterntoarchive]', function() {
		var thisItem = this,
			thisPatternId = $(thisItem).attr('patterntoarchive');
		
		reportPatternsWin.dialog('<p>Вы действительно хотите удалить отчет?</p>', 'Да', 'Отмена', function() {
			reportPatternsWin.wait();
			$.post('/reports/pattern_to_archive', {pattern_id: thisPatternId}, function(response) {
				if (response) {
					notify('Отчет отправлен в архив');
					$(thisItem).closest('tr').remove();
					reportPatternsWin.wait(false);
					reportPatternsWin.dialog(false);
				} else {
					notify('Ошибка! Не удалось отправить отчет в архив', 'error');
				}
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	// --------------------------------------------- Сохранить паттерн первого отчета
	$('#saveMainReport').on(tapEvent, function() {
		var staticsCash = $('#staticsCashData').val(),
			periodId = $('#choosenPeriodId').val(),
			reportVariant = $('#reportVariant').val()
			stat = true;
		
		$('#setStaticsCash, #choosenPeriodId').removeClass('error');
		if (staticsCash == '') {stat = false; $('#setStaticsCash').addClass('fail error');}
		if (periodId == '') {stat = false; $('#periodsButton').addClass('fail error');}
		if (!reportVariant) {stat = false; notify('Необходимо выбрать вариант отчета!', 'error')}
		
		if (stat) {
			var html = '<div class="popup__form_item">';
				html += 	'<div><label for="">Название отчета</label></div>';
				html += 	'<div><div class="field"><input type="text" id="mainReportName" autocomplete="off" /></div></div>';
				html += '</div>';
				
			popUp({
				title: 'Сохранить отчет',
			    width: 440,
			    html: html,
			    wrapToClose: true,
			    winClass: false,
			    buttons: [{id: 'saveMainReportPattern', title: 'Сохранить'}],
			    closeButton: 'Отмена'
			}, function(savePatternWin) {
				$('#saveMainReportPattern').on(tapEvent, function() {
					var reportName = $('#mainReportName').val();
					if (reportName == '') {
						$('#mainReportName').addClass('error');
						notify('Ошибка! Необходимо необходимо ввести название отчета!', 'error');
					} else {
						savePatternWin.wait();
						$.post('/reports/save_main_report_pattern', {
							name: reportName,
							cash: staticsCash,
							period_id: periodId,
							variant: reportVariant
						}, function(response) {
							if (response) notify('Данные успешно сохранены!');
							savePatternWin.close();
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
							savePatternWin.wait(false);
						});
					}
				});	
			});	
		} else {
			notify('Ошибка! Необходимо необходимо заполнить все данные!', 'error');
		}
	});
	
	
	
	
	
	// --------------------------------------- Изменить статус выплаты участника
	$('body').off(tapEvent, '[paydone]').on(tapEvent, '[paydone]', function() {
		var thisItem = this,
			stat = $(thisItem).attr('paydone'),
			thisData = $(thisItem).attr('data').split('|'),
			patternId = thisData[0],
			staticId = thisData[1],
			userId = thisData[2],
			cash = thisData[4],
			toDeposit = thisData[3];
			
		$.post('/reports/change_paydone_stat', {
			stat: stat,
			pattern_id: patternId,
			static_id: staticId,
			user_id: userId,
			cash: cash,
			to_deposit: toDeposit
		}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('paydone', '0').removeClass('forbidden').addClass('success').attr('title', 'Выплачен');
				} else {
					$(thisItem).attr('paydone', '1').removeClass('success').addClass('forbidden').attr('title', 'Не выплачен');
				}
				notify('Статус изменен!');
			} else {
				notify('Ошибка изменения статуса!', 'error');
			}
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	// --------------------------------------- Изменить статус выплаты всех участников
	$('body').off(tapEvent, '[paydoneall]').on(tapEvent, '[paydoneall]', function() {
		var data = [], items = [];
		$(this).closest('table').find('.forbidden:not(.disabled)').each(function() {
			var thisItem = this,
				stat = $(thisItem).attr('paydone'),
				thisData = $(thisItem).attr('data').split('|'),
				patternId = thisData[0],
				staticId = thisData[1],
				userId = thisData[2],
				cash = thisData[4],
				toDeposit = thisData[3];
				
			data.push({
				stat: stat,
				pattern_id: patternId,
				static_id: staticId,
				user_id: userId,
				cash: cash,
				to_deposit: toDeposit
			});	
			
			if (stat === '1') $(thisItem).attr('paydone', '0').removeClass('forbidden').addClass('success').attr('title', 'Выплачен');
		});
		
		
		$.post('/reports/change_paydone_stat_all', {data: data}, function() {
			notify('Статус выплат изменен!');
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------------- 2 отчет
	
	
	// ------------------------------------------------ Периоды
	var periodsOrdersWin;
	$('[ordersperiodsbutton]').on(tapEvent, function() {
		$(this).removeClass('error fail');
		popUp({
			title: 'Периоды',
		    width: 500,
		    buttons: [{id: 'newperiod', title: 'Новый период', disabled: true}]
		}, function(cOWin) {
			periodsOrdersWin = cOWin;
			periodsOrdersWin.wait();
			
			getAjaxHtml('reports/get_reports_periods', {to_orders: 1}, function(html) {
				periodsOrdersWin.setData(html, false);
				$('#periodsList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				$('#newPeriod').prop('disabled', false);
			}, function() {
				periodsOrdersWin.wait(false);
			});
		});
	});
	
	$('body').off(tapEvent, '[chooseorderperiod]').on(tapEvent, '[chooseorderperiod]', function() {
		var thisId = $(this).attr('chooseorderperiod'),
			thisTitle = $(this).closest('tr').find('td:first').text();
		$('#ordersReportperiodId').val(thisId);
		$('#ordersReportperiodId').attr('periodtitle', thisTitle);
		notify('Период выбран!');
		$('[ordersperiodsbutton]').addClass('done');
		periodsOrdersWin.close();
	});
	
	
	
	
	// -------------------------------------------------------------------------- Сформировать 2 отчет
	$('#setOrdersReport').on(tapEvent, function() {
		var periodId = $('#ordersReportperiodId').val();
		if (periodId == '') $('[ordersperiodsbutton]').addClass('fail error');
		else {
			getAjaxHtml('reports/set_orders_report', {period_id: periodId}, function(html) {
				$('#ordersReport').html(html);
			});
		}
	});
	
	
	
	$('#saveOrdersReport').on(tapEvent, function(e) {
		var periodId = $('#ordersReportperiodId').val();
			periodTitle = $('#ordersReportperiodId').attr('periodtitle');
		
		if (periodId == '') {
			e.preventDefault();
			$('[ordersperiodsbutton]').addClass('fail error');
		} else {
			$('#saveOrdersReport').attr('download', 'Список заказов ('+periodTitle+').csv').attr('href', location.origin+'/reports/export_orders/'+periodId);
			//location.href = location.origin+'/reports/export_orders/'+periodId;
		}
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------------- 3 отчет
	
	
	$('#choosePaymentsPatterns').on(tapEvent, function() {
		popUp({
			title: 'Выбрать диапазоны',
		    width: 600,
		    html: '<div id="reportPaymentsPatternsList"></div>',
		    buttons: [{id: 'getEarlyPaymentsPatterns', title: 'Показать более ранние'}, {id: 'buildPaymentsPatterns', title: 'Показать отчет'}]
		}, function(paymentsPatternsWin) {
			paymentsPatternsWin.wait();
			var html = '', limit = 5, offset = 0;
			
			getAjaxHtml('reports/get_patterns_list', {limit: limit, offset: offset}, function(html, stat) {
				$('#reportPaymentsPatternsList').html(html);
				$('#reportPaymentsPatternsList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				if (!stat) $('#getEarlyPaymentsPatterns').prop('disabled', true);
			}, function() {
				paymentsPatternsWin.wait(false);
			});
			
			
			$('#getEarlyPaymentsPatterns').on(tapEvent, function() {
				paymentsPatternsWin.wait();
				offset += limit;
				getAjaxHtml('reports/get_patterns_list', {limit: limit, offset: offset}, function(html, stat) {
					if (stat) $('#reportPaymentsPatternsList tbody').append(html);
					else {
						$('#getEarlyPaymentsPatterns').prop('disabled', true);
						notify('Это самые последние диапазоны!', 'info');
					}
				}, function() {
					paymentsPatternsWin.wait(false);
				});
			});
			
			
			
			$('#buildPaymentsPatterns').on(tapEvent, function() {
				paymentsPatternsWin.wait();
				var checkedPatterns = [];
				$('#reportPaymentsPatternsList [paymentspatternid]').each(function() {
					if ($(this).hasClass('success')) {
						checkedPatterns.push($(this).attr('paymentspatternid'));
					}
				});
				
				if (checkedPatterns.length > 0) {
					getAjaxHtml('reports/build_payments_patterns_report', {patterns: checkedPatterns}, function(html) {
						$('#paymentsPatternsReport').html(html);
						$('[id^="tabpaybrago"]:first').addClass('active');
						$('[tabid^="tabpaybrago"]:first').addClass('visible');
						$('#downloadPaymentsPatterns').removeAttrib('disabled');
						paymentsPatternsWin.close();
						
						
						$('body').off(tapEvent, '#downloadPaymentsPatterns').on(tapEvent, '#downloadPaymentsPatterns', function() {
							$(this).attr('download', 'Выплаты по диапазонам.csv').attr('href', location.origin+'/reports/download_payments_patterns_report/'+checkedPatterns.join('|'));
						});
						
					}, function() {
						paymentsPatternsWin.wait(false);
					});
				} else {
					notify('Необходимо выбрать диапазоны', 'info');
					paymentsPatternsWin.wait(false);
				}
			});
			
		});
		
	});
	
	
	
	
	
	
	
	
	
	// ------------------------------------------- Сформировать первый отчет по паттерну
	$('body').off(tapEvent, '[choosepattern]').on(tapEvent, '[choosepattern]', function() {	
		var thisItem = this,
			stat = $(thisItem).attr('choosepattern');
			
		if (stat === '1') {
			$(thisItem).attr('choosepattern', '0').removeClass('forbidden').addClass('success').attr('title', 'Выбран');
		} else {
			$(thisItem).attr('choosepattern', '1').removeClass('success').addClass('forbidden').attr('title', 'не выюран');
		}
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------------- Заявки на оплату
	$('#paymentRequestsNew').on(tapEvent, function() {
		popUp({
			title: 'Новая заявка на оплату',
		    width: 800,
		    height: 300,
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'setPaymentRequest', title: 'Оформить заявку', disabled: 1}],
		    closeButton: 'Отмена',
		}, function(pRNewWin) {
			pRNewWin.wait();
			getAjaxHtml('reports/get_users', {start: 1}, function(startHtml) {
				pRNewWin.setData(startHtml, false);
				$('#setPaymentRequest').removeAttrib('disabled');
				$('#paymentRequestSumm').number(true, 2, '.', ' ');
				
				//--------------------------------------------------- Оформить заявку
				$('#setPaymentRequest').on(tapEvent, function() {
					var stat = true, users = [], order, summ, comment, toDeposit;
					if ($('#paymentRequestChoosenUsers').find('[paymentrequestchoosenuser]').length == 0) {
						$('#paymentRequestChoosenUsers').addClass('error');
						notify('Необходимо указать участников.', 'error');
						stat = false;
					}
					
					if ($('#paymentRequestOrder').val() == '') {
						$('#paymentRequestOrder').addClass('error');
						notify('Необходимо указать номер заказа.', 'error');
						stat = false;
					}
					
					if ($('#paymentRequestSumm').val() == '') {
						$('#paymentRequestSumm').addClass('error');
						notify('Необходимо указать сумму выплаты.', 'error');
						stat = false;
					}
					
					if (stat) {
						pRNewWin.wait();
						
						$('#paymentRequestChoosenUsers').find('[paymentrequestchoosenuser]').each(function() {
							users.push($(this).attr('paymentrequestchoosenuser'));
						});
						
						order = $('#paymentRequestOrder').val();
						summ = $('#paymentRequestSumm').val();
						toDeposit = $('#paymentRequestToDeposit').is(':checked');
						comment = $('#paymentRequestComment').val();
						
						$.post('/reports/set_users_orders', {users: users, order: order, summ: summ, to_deposit: toDeposit, comment: comment}, function(response) {	
							if (response) {
								notify('Заявка успешно оформлена!');
								pRNewWin.close();
							} else {
								notify('Ошибка оформления заявки', 'error');
							}
							pRNewWin.wait(false);
							renderSection({field: getSortField(), order: getSortOrder()});
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							pRNewWin.wait(false);
							showError(e);
						});
					}	
				});
				
				//--------------------------------------------------- Поиск участников
				var pRFUserTOut; 
				$('#paymentRequestFindUser').on('keyup', function() {
					clearTimeout(pRFUserTOut);
					pRFUserTOut = setTimeout(function() {
						var val = $('#paymentRequestFindUser').val();
						if (val.length == 0 || val.length >= 2) {
							$('#paymentRequestsUsers').addClass('wait');
							getAjaxHtml('reports/get_users', {query: val}, function(html) {
								$('#paymentRequestsUsers').html(html);
								$('#paymentRequestChoosenUsers li').each(function() {
									var thisId = $(this).attr('paymentrequestchoosenuser');
									if ($('#paymentRequestsUsers ul li[chooseusertopaymentrequest="'+thisId+'"]').length > 0) {
										$('#paymentRequestsUsers ul li[chooseusertopaymentrequest="'+thisId+'"]').addClass('choosed');
									}
								});
							}, function() {
								$('#paymentRequestsUsers').removeClass('wait');
								pRNewWin.correctPosition();
							});
						}
					}, 300);	
				});
				
				
				//--------------------------------------------------- Выбор участников
				$('body').off(tapEvent, '[chooseusertopaymentrequest]:not(.choosed)').on(tapEvent, '[chooseusertopaymentrequest]:not(.choosed)', function() {
					$(this).addClass('choosed');
					$('#paymentRequestChoosenUsers').removeClass('error');
					
					var addItem = '',
						thisUserId = $(this).attr('chooseusertopaymentrequest'),
						thisUserNickname = $(this).find('.nickname').text(),
						thisUserStaticImg = $(this).find('.static img').attr('src'),
						thisUserStaticName = $(this).find('.static span').text();
					
					addItem +=	'<li paymentrequestchoosenuser="'+thisUserId+'">';
					addItem +=		'<p class="nickname">'+thisUserNickname+'</p>';
					addItem +=		'<div class="static">';
					addItem +=			'<div class="image"><img src="'+thisUserStaticImg+'" alt=""></div>';
					addItem +=			'<span>'+thisUserStaticName+'</span>';
					addItem +=		'</div>';
					addItem +=		'<div class="remove" title="Удалить участника из списка"></div>';
					addItem +=	'</li>'
					
					$('#paymentRequestChoosenUsers').append(addItem);
				});
				
				
				//--------------------------------------------------- Удаление участникоы
				$('body').off(tapEvent, '[paymentrequestchoosenuser] .remove').on(tapEvent, '[paymentrequestchoosenuser] .remove', function() {
					var thisId = $(this).closest('[paymentrequestchoosenuser]').attr('paymentrequestchoosenuser');
					$(this).closest('[paymentrequestchoosenuser]').remove();
					$('[chooseusertopaymentrequest="'+thisId+'"]').removeClass('choosed');
				});
				
			}, function() {
				pRNewWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	// --------------------------------------- Заявки на оплату: изменить статус выплаты [функция]
	function serPrPayDone(thisItem, nostat) {
		var paid = $(thisItem).attr('prpaydone'),
			d = $(thisItem).attr('data').split('|'),
			thisId = d[0],
			thisUserId = d[1],
			summ = d[2],
			pause = nostat || false;
			
		$.post('/reports/change_paymentrequest_stat', {paid: paid, id: thisId, user_id: thisUserId, summ: summ, pause: pause}, function(response) {
			if (response) {
				if (paid === '1') {
					$(thisItem).attr('prpaydone', '0').removeClass('forbidden').addClass('success').attr('title', 'разрешен');
				} else {
					$(thisItem).attr('prpaydone', '1').removeClass('success').addClass('forbidden').attr('title', 'не разрешен');
				}
				if (!nostat) notify('Статус изменен!');
				//renderSection({field: getSortField(), order: getSortOrder()});
			} else {
				if (!nostat) notify('Ошибка изменения статуса!', 'error');
			}
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	}
	
	
	//$('#sectionWait').addClass('visible');
	
	// --------------------------------------- Заявки на оплату: изменить статус выплаты
	$('body').off(tapEvent, '[prpaydone]').on(tapEvent, '[prpaydone]', function() {
		serPrPayDone(this);
	});
	
	
	// --------------------------------------- Заявки на оплату: изменить статус выплаты всех
	$('#paymentRequestsSetStatToAll').on(tapEvent, function() {
		popUp({
			title: 'Рассчет заявок',
		    width: 400,
		    html: '<p class="center red error info">Рассчитать все заявки?</p>',
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id : 'paymentRequestsSetStatToAllButton', title: 'Рассчитать'}],
		    closeButton: false,
		}, function(paymentRequestsSetStatToAllWin) {
			
			$('#paymentRequestsSetStatToAllButton').on(tapEvent, function() {
				paymentRequestsSetStatToAllWin.wait();
				var data = [],
					iterator,
					i = 0;
				$('[tabid="paymentRequestsPaidnopaid"] #paymentRequestsList').find('[prpaydone]').each(function() {
					data.push(this);
				});
				
				iterator = setInterval(function() {
					if (data[i] == undefined) {
						clearInterval(iterator);
						paymentRequestsSetStatToAllWin.close();
						notify('Статус заявок изменен!');
					} else {
						serPrPayDone(data[i], true);
						i++;
					}
				}, 50);
			});
		});
	});
	
	
	
	
	
	
	
	
	// --------------------------------------- Рассчитать оклады
	$('body').off(tapEvent, '#setSalaryBtn').on(tapEvent, '#setSalaryBtn', function() {
		popUp({
			title: 'Расчет окладов',
		    width: 400,
		    wrapToClose: true,
		    winClass: false,
		    //buttons: ,
		    closeButton: 'Закрыть',
		}, function(salaryWin) {
			salaryWin.wait();
			getAjaxHtml('reports/get_periods_to_salary', function(html) {
				salaryWin.setData(html, false);
				
				$('[periodid]').on(tapEvent, function() {
					var id = $(this).attr('periodid'),
						title = $(this).attr('periodtitle');
					
					salaryWin.wait();
					getAjaxHtml('reports/get_salary_form', {period_id: id, period_title: title}, function(html) {
						salaryWin.setWidth(600);
						salaryWin.setButtons([{id : 'calcSalary', title: 'Рассчитать'}], 'Отмена');
						salaryWin.setData(html, false);
						
						$('#salaryStatics').ddrScrollTableY({height: '360px', wrapBorderColor: '#d7dbde'});
						$('[salarysumm]').number(true, 0, ',', ' ');
						
						
						$('#calcSalary').on(tapEvent, function() {
							var stat = true;
							
							if ($('#salaryFormStatics').find('[choosedstatic]:checked').length == 0) {
								notify('Необходимо выбрать хотя бы один статик!', 'error');
								stat = false;
							}
							
							if ($('#salesOrder').val() == '') {
								notify('Необходимо заполнить поле [номер заказа]!', 'error');
								$('#salesOrder').addClass('error');
								stat = false;
							}
							
							if ($('#salesComment').val() == '') {
								notify('Необходимо заполнить поле [комментарий]!', 'error');
								$('#salesComment').addClass('error');
								stat = false;
							}
								
							
							
							var data = [],
								salesOrder = $('#salesOrder').val(),
								salesComment = $('#salesComment').val(),
								toDeposit = $('#paymentRequestToDeposit').is(':checked'),
								salaryCoeffErrors = false,
								salarySummErrors = false;
							
							$('#salaryFormStatics').find('tr').each(function() {
								if ($(this).find('[choosedstatic]:checked').length) {
									var staticId = $(this).find('[choosedstatic]').attr('choosedstatic'),
										salaryCoeff = $(this).find('[salarycoeff]').val(),
										salarySumm = $(this).find('[salarysumm]').val();
									
									if (!salaryCoeff) {
										$(this).find('[salarycoeff]').addClass('error');
										salaryCoeffErrors = true;
										stat = false;
									}
									
									if (!salarySumm) {
										$(this).find('[salarysumm]').addClass('error');
										salarySummErrors = true;
										stat = false;
									}
									
									data.push({
										static_id: staticId,
										coeff: parseFloat(salaryCoeff),
										summ: parseInt(salarySumm)
									});
								}
							});
							
							if (salaryCoeffErrors) {
								notify('Необходимо корректно прописать коэффициент!', 'error');
							}
							
							if (salarySummErrors) {
								notify('Необходимо корректно прописать сумму!', 'error');
							}
							
							
							
							if (stat) {
								salaryWin.wait();
								getAjaxHtml('reports/calc_salary_orders', {period_id: id, data: data, order: salesOrder, comment: salesComment, to_deposit: toDeposit}, function(html) {
									salaryWin.setWidth(1000);
									salaryWin.setData(html, false);
									salaryWin.setButtons([{id : 'setSalary', title: 'Сформировать заявки'}], 'Отмена');
									
									$('#setSalary').on(tapEvent, function() {
										salaryWin.wait();
										$.post('/reports/set_salary_orders', {period_id: id, data: data, order: salesOrder, comment: salesComment, to_deposit: toDeposit}, function(response) {
											if (response) {
												salaryWin.close();
												notify('Заявки успешно оформлены!');
											} else {
												salaryWin.wait(false);
												notify('Ошибка формирования заявки!', 'error');
											}
										}).fail(function(e) {
											salaryWin.wait(false);
											showError(e);
											notify('Системная ошибка!', 'error');
										});
									});
								}, function() {
									salaryWin.wait(false);
								});	
							}
							
						});
						
					}, function() {
						salaryWin.wait(false);
					});
				});
				
				
				
			}, function() {
				salaryWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// --------------------------------------- Дополнительные выплаты
	$('#addictPayBtn').on(tapEvent, function() {
		popUp({
			title: 'Дополнительные выплаты',
		    width: 450,
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'calcAddictPay', title: 'Рассчитать'}],
		    closeButton: 'Закрыть',
		}, function(addictPayWin) {
			addictPayWin.wait();
			getAjaxHtml('reports/get_addictpay_form', function(html) {
				addictPayWin.setData(html, false);
				$('#salaryStatics').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				
				
				$('#calcAddictPay').on(tapEvent, function() {
					let order = $('#addictPayOrder'),
						comment = $('#addictPayComment'),
						toDeposit = ($('#paymentRequestToDeposit').is(':checked') ? 1 : 0),
						choosedStatics = [],
						stat = true;
					
					
					if ($('#addictPayFormStatics').find('input[type="checkbox"]:checked').length == 0) {
						notify('Необходимо выбрать хотя бы один статик!', 'error');
						stat = false;
					}
					
					if ($(order).val() == '') {
						notify('Необходимо заполнить поле [номер заказа]!', 'error');
						$(order).addClass('error');
						stat = false;
					}
					
					if ($(comment).val() == '') {
						notify('Необходимо заполнить поле [комментарий к оплатам]!', 'error');
						$(comment).addClass('error');
						stat = false;
					}
					
					if (stat) {
						addictPayWin.wait();
						$('#addictPayFormStatics').find('input[type="checkbox"]:checked').each(function() {
							choosedStatics.push(parseInt($(this).val()));
						});
						
						getAjaxHtml('reports/calc_addictpay', {statics: choosedStatics, to_deposit: toDeposit}, function(html) {
							addictPayWin.setWidth(700);
							addictPayWin.setData(html, false);
							addictPayWin.setButtons([{id: 'setAddictPayUsers', title: 'Сформировать заявки'}]);
							
							$('[addictpayuser]').on('change', function() {
								let totalSumm = 0;
								$(this).closest('tbody').find('input[type="checkbox"]:checked').each(function() {
									let d = $(this).attr('addictpayuser').split('|'),
										summ = parseInt(d[2]);
									totalSumm += summ;
								});
								$(this).closest('tbody').siblings('tfoot').find('[totalsumm]').text($.number(totalSumm, 2, '.', ' ')+' ₽');
							});
							
							
							
							$('#setAddictPayUsers').on(tapEvent, function() {
								addictPayWin.wait();
								let ordersData = [];
								$('#addictPayUsersData').find('input[type="checkbox"]:checked').each(function() {
									let d = $(this).attr('addictpayuser').split('|'),
										static = parseInt(d[0]),
										user = parseInt(d[1]),
										summ = parseInt(d[2]),
										deposit = parseInt(d[3]);
									
									ordersData.push({
										static: static,
										user: user,
										summ: summ,
										to_deposit: deposit
									});
								});
								
								if (ordersData) {
									$.post('/reports/set_addictpay_orders', {users: ordersData, order: $(order).val(), comment: $(comment).val(), to_deposit: toDeposit}, function(response) {
										if (response) {
											addictPayWin.close();
											notify('Заявки успешно сформированны!');
										} else {
											notify('Ошибка формирования заявок!', 'error');
											addictPayWin.wait(false);
										}
									}, 'json').fail(function(e) {
										addictPayWin.wait(false);
										showError(e);
										notify('Системная ошибка!', 'error');
									});
									
								} else {
									notify('Необходимо выбрать хотя бы одного участника!', 'error');
								}
							});
							
						}, function() {
							addictPayWin.wait(false);
						});
					}
					
					
				});
				
			}, function() {
				addictPayWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	

	// --------------------------------------- Сортировка списка заявок
	$('body').off(tapEvent, '[paymentrequestsort]').on(tapEvent, '[paymentrequestsort]', function() {
		setSortField($(this).attr('paymentrequestsort'));
		setSortOrder();
		renderSection({field: getSortField(), order: getSortOrder()});
	});
	
	
	
	
	
	
	$('body').off(tapEvent, '#paymentRequestsFindUsersButton').on(tapEvent, '#paymentRequestsFindUsersButton', function() {
		var findField = $('#paymentRequestsFindUsersField').val();
		var findValue = $('#paymentRequestsFindUsersValue').val();
		
		if (findValue == '') {
			$('#paymentRequestsFindUsersValue').addClass('error');
			notify('Поле не может быть пустым!', 'info');
			return false;
		}
		
		setSortField('id');
		setSortOrder('DESC');
		
		if (findValue.length > 0) {
			renderSection({field: getSortField(), order: getSortOrder(), search_field: findField, search_value: findValue});
		} else {
			renderSection({field: getSortField(), order: getSortOrder()});
		}
	});
	
	
	
	
	
	
	
	
	$('body').off(tapEvent, '#paymentRequestsTemplates').on(tapEvent, '#paymentRequestsTemplates', function() {
		popUp({
			title: 'Шаблоны',
		    width: 500,
		    height: false,
		    html: '',
		    wrapToClose: true,
		    winClass: false,
		    buttons: false,
		    closeButton: false,
		}, function(pRTWin) {
			pRTWin.wait();
			
			(function paymentRequestsGetList() {
				getAjaxHtml('admin/paymentrequests/main', {}, function(html) {
					pRTWin.setData(html, false);
					
					$('#paymentRequestsTemplatesList').ddrCRUD({
						addSelector: '#paymentRequestsTemplatesAdd',
						emptyList: '<tr><td colspan="3">Нет данных</td></tr>',
						functions: 'admin/paymentrequests',
						confirms: {}, // add save update remove
						removeConfirm: true,
						listDirection: 'bottom',
						popup: pRTWin
					}, function(list) {
						pRTWin.wait(false);
						
						$('#paymentRequestsTemplatesList').on(tapEvent, '[paymentrequestseditlist]', function() {
							var thisRowId = parseInt($(this).attr('paymentrequestseditlist')),
								thisTempTitle = $(this).closest('tr').find('input[name="name"]').val();
							
							pRTWin.setTitle('Шаблон: '+thisTempTitle);
							pRTWin.setWidth(600);
							pRTWin.wait();
							getAjaxHtml('admin/paymentrequests/get_users', {pr_id: thisRowId}, function(html) {
								pRTWin.setData(html, false);
								pRTWin.setButtons([
									{id: 'paymentRequestsSetFromTemp', title: 'Оформить'},
									{id: 'paymentRequestsSave', title: 'Сохранить'},
									{id: 'paymentRequestsBack', title: 'Назад', cls: 'remove'}
								]);
								
								//--------------------------------------------------- Поиск участников
								var pRFTUserTOut; 
								$('#paymentRequestTempFindUser').on('keyup', function() {
									clearTimeout(pRFTUserTOut);
									pRFTUserTOut = setTimeout(function() {
										var val = $('#paymentRequestTempFindUser').val();
										if (val.length == 0 || val.length >= 2) {
											$('#paymentRequestsTempUsers').addClass('wait');
											
											var choosedTempUsers = [];
											$('#paymentRequestTempChoosen').find('[removechoosenuser]').each(function() {
												choosedTempUsers.push($(this).attr('removechoosenuser'));
											});
											
											getAjaxHtml('admin/paymentrequests/find_users', {choosed: choosedTempUsers, query: val}, function(html) {
												$('#paymentRequestsTempUsers').html(html);
											}, function() {
												$('#paymentRequestsTempUsers').removeClass('wait');
												//setgameiduserWin.correctPosition();
											});
										}
									}, 300);	
								});
								
								$('#paymentRequestsTempUsers').on(tapEvent, '[chooseusertopaymentrequesttemp]:not(.choosed)', function() {
									var choosenUserId = $(this).attr('chooseusertopaymentrequesttemp'),
										choosenUserCard = $(this).html();
									
									var html = '<tr chooseduserid="'+choosenUserId+'">';
										html += 	'<td class="w140px">'+choosenUserCard+'</td>';
										html += 	'<td>';
										html += 		'<div class="popup__field"><input type="text" summ /></div>';
										html += 		'<input type="hidden" name="pr_coosen_user_id" value="'+choosenUserId+'" />';
										html += 	'</td>';
										html += 	'<td class="w40px"><div class="buttons"><button removechoosenuser="'+choosenUserId+'" class="remove" title="Удалить из списка"><i class="fa fa-trash"></i></button></div></td>';
										html += '</tr>';
									
									$('#paymentRequestTempChoosen').append(html);
									$(this).addClass('choosed');
								});
								
								
								$('#paymentRequestTempChoosen').on(tapEvent, '[removechoosenuser]', function() {
									var thisUserId = $(this).attr('removechoosenuser');
									$('#paymentRequestsTempUsers').find('[chooseusertopaymentrequesttemp="'+thisUserId+'"]').removeClass('choosed');
									$(this).closest('tr').remove();
								});
								
								
								$('#paymentRequestTempChoosen').on('keyup', '[summ]', function() {
									$(this).closest('tr.error').removeClass('error');
								});
								
								
								// Сохранить или вернуться
								$('#paymentRequestsBack, #paymentRequestsSave, #paymentRequestsSetFromTemp').on(tapEvent, function() {
									var thisButtonId = $(this).attr('id'),
										tempDataToSave = [],
										tempDataToCheckout = [];
										
									if (thisButtonId == 'paymentRequestsSave' || thisButtonId == 'paymentRequestsSetFromTemp') {
										var stat = true,
											tempOrder = $('#paymentRequestTempOrder').val(),
											tempComment = $('#paymentRequestTempComment').val();
										
										if (thisButtonId == 'paymentRequestsSetFromTemp' && tempOrder == '') {
											$('#paymentRequestTempOrder').addClass('error');
											stat = false;
										}
										
										$('#paymentRequestTempChoosen').children('tr').each(function() {
											var thisRow = this,
												thisUserId = parseInt($(thisRow).attr('chooseduserid')),
												thisUserSumm = $(thisRow).find('[summ]').val() ? parseInt($(thisRow).find('[summ]').val()) : false;
												
											if (thisUserSumm === false || isNaN(thisUserSumm)) {
												$(thisRow).addClass('error');
												stat = false;
											}
											
											tempDataToSave.push({
												pr_id: thisRowId,
												user_id: thisUserId,
												summ: thisUserSumm
											});
											
											tempDataToCheckout.push({
												user_id: thisUserId,
												summ: thisUserSumm,
												order: tempOrder,
												comment: tempComment
											});
										});
										
										if (stat) {
											// -------------------- Сохранить шаблон
											if (thisButtonId == 'paymentRequestsSave') {
												$.post('/admin/paymentrequests/save_temp_data', {pr_id: thisRowId, data: tempDataToSave}, function(response) {
													if (response) {
														notify('Данные успешно сохранены!');
													} else {
														notify('Ошибка сохранения данных', 'error');
													}
												});
											}
											
											// -------------------- Оформить
											if (thisButtonId == 'paymentRequestsSetFromTemp') {
												if ($('#paymentRequestTempChoosen').children().length > 0) {
													var toDeposit = $('#paymentRequestToDeposit').is(':checked');
													$.post('/admin/paymentrequests/set_checkout', {to_deposit: toDeposit, data: tempDataToCheckout}, function(response) {
														if (response) {
															notify('Заявки на оплату оформлены успешно!');
														} else {
															notify('Ошибка оформления заявок', 'error');
														}
													});
												} else {
													notify('Ошибка! Список пользователей пуст', 'error');
													stat = false;
												}
												
											}
											
										} else {
											notify('Ошибка! Необходимо правильно заполнить поля!', 'error');
										}	
									}
									
									if ((thisButtonId == 'paymentRequestsBack') || ((thisButtonId == 'paymentRequestsSave' || thisButtonId == 'paymentRequestsSetFromTemp') && stat)) {
										pRTWin.setTitle('Шаблон');
										pRTWin.removeButtons();
										pRTWin.setWidth(500);
										paymentRequestsGetList();
									}
								});
							}, function() {
								pRTWin.wait(false);
							});
						});
					});
				}, function() {
					
				});
			})();
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------- Getter
	function getSortField() {
		return lscache.get('paymentRequestSortField') || 'nickname';
	}
	function getSortOrder() {
		return lscache.get('paymentRequestSortOrder') || 'ASC';
	}
	
	
	
	//---------- Setter
	function setSortField(value) {
		if (!value) return false;
		lscache.set('paymentRequestSortField', value);
	}
	function setSortOrder(value) {
		if (value) lscache.set('paymentRequestSortOrder', value);
		else {
			var order = lscache.get('paymentRequestSortOrder');
			if (!order) {
				lscache.set('paymentRequestSortOrder', 'ASC');
			} else if (order == 'ASC') {
				lscache.set('paymentRequestSortOrder', 'DESC');
			} else if (order == 'DESC') {
				lscache.set('paymentRequestSortOrder', 'ASC');
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ отчет "Ключи"
	
	
	
	// ------------------------Сформировать отчет по ключам
	$('#setKeysReport').on(tapEvent, function() {
		var staticsCash = $('#staticsCashDataKeys').val(),
			periodId = $('#choosenPeriodIdKeys').val(),
			stat = true;
		
		if (!staticsCash) {
			notify('Ошибка! Необходимо задать бюджет для статиков!', 'error');
			$('#setStaticsCashKeys').addClass('fail error');
			stat = false;
		}
		
		if (!periodId) {
			notify('Ошибка! Необходимо указать период!', 'error');
			$('#periodsKeysButton').addClass('fail error');
			stat = false;
		}
		
		if(stat) {
			getAjaxHtml('reports/get_keys_report', {cash: staticsCash, period_id: periodId}, function(html) {
				$('#keysReport').html(html);
				$('#keysReport').ready(function() {
					$('.scroll').ddrScrollTable();
					ddrInitTabs();
				});
				$('[id^="tabstatic"]:first').addClass('active');
				$('[tabid^="tabstatic"]:first').addClass('visible');
			});
		}
	});
	
	
	
	
	
	// ---------------------------------- Задать бюджет статиков
	$('#setStaticsCashKeys').on(tapEvent, function() {
		$(this).removeClass('fail error');
		popUp({
			title: 'Задать бюджет статиков',
		    width: 500,
		    html: '<div id="staticsCashKeys"></div>',
		    buttons: [{id: 'setStaticsCashKeysButton', title: 'Задать бюджет'}],
		    closeButton: 'Отмена'
		}, function(staticsCasKeyshWin) {
			staticsCasKeyshWin.wait();
			
			var data = $('#staticsCashDataKeys').val() || {};
			$.post('/reports/get_statics_to_cash', {set_cash: data}, function(html) {
				if (html) {
					$('#staticsCashKeys').html(html);
					$('#staticsCashKeys').find('input').number(true, 0, '.', ' ');
					$('#staticsCashKeys').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
					
					var checkedStat = true,
						checks = $('#staticsCashKeys').find('[choosestatictodeposit]');
					$('#staticsDepositCheckAll').on(tapEvent, function() {
						checkedStat = !checkedStat;
						$(checks).each(function() {
							if (checkedStat) $(this).setAttrib('checked');
							else $(this).removeAttrib('checked');
						});
					});
					
					$('#setStaticsCashKeysButton').on(tapEvent, function() {
						var staticsCashKeys = {};
						$('#staticsCashKeys').find('[choosestatictodeposit]:checked').each(function() {
							var thisInput = $(this).closest('tr').find('input[static]');
								staticId = $(thisInput).attr('static'),
								staticValue = parseInt($(thisInput).val());
							staticsCashKeys[staticId] = staticValue;
						});

						$('#staticsCashDataKeys').val(JSON.stringify(staticsCashKeys));
						staticsCasKeyshWin.close();
						$('#setStaticsCashKeys').addClass('done');
						notify('Бюджет статиков задан!');
					});
					
				} else {
					$('#staticsCashKeys').html('<p class="empty center">Нет данных</p>');
				}
				staticsCasKeyshWin.wait(false);
				
			}, 'html').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
				staticsCasKeyshWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	// ----------------------------- Открыть список паттернов отчета по ключам
	var reportPatternsKeysWin;
	$('#reportPatternsKeysButton').on(tapEvent, function() {
		popUp({
			title: 'Сохраненные отчеты',
		    width: 800,
		    html: '<div id="reportPatternsKeysList"></div>',
		    winClass: 'reportpatternskeyslist'
		}, function(rPKWin) {
			reportPatternsKeysWin = rPKWin;
			reportPatternsKeysWin.wait();
			var html = '', limit = 5, offset = 0;
			
			getAjaxHtml('reports/get_keys_reports_patterns', {limit: limit, offset: offset}, function(html) {
				$('#reportPatternsKeysList').html(html);
				$('#reportPatternsKeysList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				if ($(html).find('tbody').children('tr').length == limit) {
					reportPatternsKeysWin.setButtons([{id: 'getEarlyPatterns', title: 'Вниз'}, {id: 'getOlderPatterns', title: 'Вверх'}]);
				}
			}, function() {
				reportPatternsKeysWin.wait(false);
			});
			
			
			// Открыть ниже
			$('.reportpatternskeyslist').on(tapEvent, '#getEarlyPatterns', function() {
				reportPatternsKeysWin.wait();
				offset += limit;
				getAjaxHtml('reports/get_keys_reports_patterns', {limit: limit, offset: offset, is_key: 1}, function(html, stat) {
					if (stat) {
						$('#getOlderPatterns').prop('disabled', false);
						$('#reportPatternsKeysList').html(html);
					} else {
						$('#getEarlyPatterns').prop('disabled', true);
						notify('Это самые последние отчеты!', 'info');
						offset -= limit;
					}
				}, function() {
					reportPatternsKeysWin.wait(false);
				});
			});
			
			// Открыть выше
			$('.reportpatternskeyslist').on(tapEvent, '#getOlderPatterns', function() {
				if (offset == 0) {
					notify('Это самые последние отчеты!', 'info');
					$('#getOlderPatterns').prop('disabled', true);
					return true;
				}
				reportPatternsKeysWin.wait();
				offset -= limit;
				getAjaxHtml('reports/get_keys_reports_patterns', {limit: limit, offset: offset, is_key: 1}, function(html, stat) {
					if (stat) {
						$('#reportPatternsKeysList').html(html);
						$('#getEarlyPatterns').prop('disabled', false);
					} else {
						$('#getOlderPatterns').prop('disabled', true);
						notify('Это самые последние отчеты!', 'info');
					}
				}, function() {
					reportPatternsKeysWin.wait(false);
				});
			});
			
		});
	});
	
	
	// ----------------------------- Сформировать отчет по ключам по паттерну
	$('body').off(tapEvent, '[patternkeyid]').on(tapEvent, '[patternkeyid]', function() {
		var thisPatternId = $(this).attr('patternkeyid'),
			thisPatternTitle = $(this).closest('tr').children('td:first').text();
		reportPatternsKeysWin.wait();
		getAjaxHtml('reports/get_keys_report', {pattern_id: thisPatternId}, function(html, stat) {
			$('#keysReportTitle').text(thisPatternTitle);
			$('#keysReport').html(html);
			$('#keysReport').ready(function() {
				$('.scroll').ddrScrollTable()
				ddrInitTabs();
			});
			$('[id^="tabstatic"]:first').addClass('active');
			$('[tabid^="tabstatic"]:first').addClass('visible');
			if (!stat) notify('Нет данных!', 'info');
			reportPatternsKeysWin.close();
		}, function() {
			reportPatternsKeysWin.wait(false);
		});
	});
	
	
	// ----------------------------- отправить сохраненный отчет в архив
	$('body').off(tapEvent, '[patternkeytoarchive]').on(tapEvent, '[patternkeytoarchive]', function() {
		var thisItem = this,
			thisPatternId = $(thisItem).attr('patternkeytoarchive');
		
		reportPatternsKeysWin.dialog('<p>Вы действительно хотите удалить отчет?</p>', 'Да', 'Отмена', function() {
			reportPatternsKeysWin.wait();
			$.post('/reports/pattern_key_to_archive', {pattern_id: thisPatternId}, function(response) {
				if (response) {
					notify('Отчет отправлен в архив');
					$(thisItem).closest('tr').remove();
					reportPatternsKeysWin.wait(false);
					reportPatternsKeysWin.dialog(false);
				} else {
					notify('Ошибка! Не удалось отправить отчет в архив', 'error');
				}
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	// --------------------------------------------- Сохранить паттерн отчета по ключам
	$('#saveKeysReport').on(tapEvent, function() {
		var staticsCash = $('#staticsCashDataKeys').val(),
			periodId = $('#choosenPeriodIdKeys').val(),
			stat = true;
		
		$('#setStaticsCashKeys, #choosenPeriodIdKeys').removeClass('error');
		if (staticsCash == '') {stat = false; $('#setStaticsCashKeys').addClass('fail error');}
		if (periodId == '') {stat = false; $('#periodsKeysButton').addClass('fail error');}
		
		if (stat) {
			var html = '<div class="popup__form_item">';
				html += 	'<div><label for="">Название отчета</label></div>';
				html += 	'<div><div class="field"><input type="text" id="keysReportName" autocomplete="off" /></div></div>';
				html += '</div>';
				
			popUp({
				title: 'Сохранить отчет',
			    width: 440,
			    html: html,
			    wrapToClose: true,
			    winClass: false,
			    buttons: [{id: 'saveKeysReportPattern', title: 'Сохранить'}],
			    closeButton: 'Отмена'
			}, function(savePatternWin) {
				$('#saveKeysReportPattern').on(tapEvent, function() {
					var reportName = $('#keysReportName').val();
					if (reportName == '') {
						$('#keysReportName').addClass('error');
						notify('Ошибка! Необходимо необходимо ввести название отчета!', 'error');
					} else {
						savePatternWin.wait();
						$.post('/reports/save_keys_report_pattern', {
							name: reportName,
							cash: staticsCash,
							period_id: periodId
						}, function(response) {
							if (response) notify('Данные успешно сохранены!');
							savePatternWin.close();
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
							savePatternWin.wait(false);
						});
					}
				});	
			});	
		} else {
			notify('Ошибка! Необходимо необходимо заполнить все данные!', 'error');
		}
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
			cash: cash,
		}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('paydonekey', '0').removeClass('forbidden').addClass('success').attr('title', 'Выплачен');
				} else {
					$(thisItem).attr('paydonekey', '1').removeClass('success').addClass('forbidden').attr('title', 'Не выплачен');
				}
				notify('Статус изменен!');
			} else {
				notify('Ошибка изменения статуса!', 'error');
			}
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	// --------------------------------------- Изменить статус выплаты всех участников
	$('body').off(tapEvent, '[paydonekeyall]').on(tapEvent, '[paydonekeyall]', function() {
		var data = [], items = [];
		$(this).closest('table').find('.forbidden:not(.disabled)').each(function() {
			var thisItem = this,
				stat = $(thisItem).attr('paydonekey'),
				thisData = $(thisItem).attr('data').split('|'),
				patternId = thisData[0],
				staticId = thisData[1],
				userId = thisData[2],
				cash = thisData[3];
				
			data.push({
				stat: stat,
				pattern_id: patternId,
				static_id: staticId,
				user_id: userId,
				cash: cash,
			});	
			
			if (stat === '1') $(thisItem).attr('paydonekey', '0').removeClass('forbidden').addClass('success').attr('title', 'Выплачен');
		});
		
		
		$.post('/reports/change_paydone_key_stat_all', {data: data}, function() {
			notify('Статус выплат изменен!');
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
	
	
	
	// ------------------------------------------------ Периоды
	var periodsWin; 
	$('#periodsKeysButton').on(tapEvent, function() {
		$(this).removeClass('error fail');
		popUp({
			title: 'Периоды',
		    width: 500
		}, function(pRWin) {
			periodsWin = pRWin;
			periodsWin.wait();
			
			getAjaxHtml('reports/get_reports_periods', function(html) {
				periodsWin.setData(html, false);
				$('#periodsList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
			}, function() {
				periodsWin.wait(false);
			});
			
			$('body').off(tapEvent, '[chooseperiod]').on(tapEvent, '[chooseperiod]', function() {
				var thisId = $(this).attr('chooseperiod');
				$('#choosenPeriodIdKeys').val(thisId);
				notify('Период выбран!');
				$('#periodsKeysButton').addClass('done');
				periodsWin.close();
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Премии
	$('#rewardsPeriods').on(tapEvent, function() {
		popUp({
			title: 'Премиальные периоды',
			closeButton: 'Закрыть'
		}, function(rewardsPeriodsWin) {
			(function openPeriods() {
				rewardsPeriodsWin.wait();
				
				getAjaxHtml('admin/rewards/get_periods', function(html) {
					rewardsPeriodsWin.setTitle('Премиальные периоды');
					rewardsPeriodsWin.setWidth(750);
					rewardsPeriodsWin.setButtons([{id: 'newRewardPeriod', title: 'Новый период'}], 'Закрыть');
					rewardsPeriodsWin.setData(html, false);
					$('#rewardsPeriodsList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				}, function() {
					rewardsPeriodsWin.wait(false);
					
					
					// --------------------------------------- Изменить статус периода
					$('[showperiod]').on('change', function() {
						let periodId = $(this).attr('showperiod'),
							stat = $(this).is(':checked');
						$.post('admin/rewards/change_stat', {period_id: periodId, stat: stat}, function(response) {
							if (!response) {
								notify('Ошибка изменения статуса!', 'error');
							} else {
								notify('Статус изменен!');
							}
						}).fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					});
					
					
					
					
					// --------------------------------------- Новый период \ редактировать период
					$('#newRewardPeriod, [rewardsperiodedit]').on(tapEvent, function() {
						let periodId = $(this).attr('rewardsperiodedit') || false,
							url = periodId ? 'edit_period' : 'new_period',
							title = periodId ? 'Изменить период' : 'Новый период',
							button = periodId ? [{id: 'updateRewardsPeriod', title: 'Обновить'}, {id: 'goBack', title: 'Назад'}] : [{id: 'addRewardsPeriod', title: 'Создать'}, {id: 'goBack', title: 'Назад'}],
							params = periodId ? {period_id: periodId} : {};
						
						getAjaxHtml('admin/rewards/'+url, params, function(html) {
							rewardsPeriodsWin.setData(html, false);
							rewardsPeriodsWin.setTitle(title);
							rewardsPeriodsWin.setButtons(button, 'Отмена');
							rewardsPeriodsWin.setWidth(500);
						}, function() {
							rewardsPeriodsWin.wait(false);
							
							var choosedPeriods = [];
							$('#reportsPeriods [periodid].choosed').each(function() {
								let periodId = $(this).attr('periodid');
								choosedPeriods.push(parseInt(periodId));
							});
							$('#countChoosedReports').text($('#reportsPeriods [periodid].choosed').length);
							
							
							$('[periodid]').on(tapEvent, function() {
								var thisItem = this,
									id = parseInt($(thisItem).attr('periodid'));
								
								if ($(thisItem).hasClass('choosed')) {
									$(thisItem).removeClass('choosed');
									var index = choosedPeriods.indexOf(id);
									if (index !== -1) choosedPeriods.splice(index, 1);
									$('#countChoosedReports').text(choosedPeriods.length);
								} else if ($(thisItem).hasClass('choosed') == false) {
									$(thisItem).addClass('choosed');
									choosedPeriods.push(id);
									$('#countChoosedReports').text(choosedPeriods.length);
								}
							});
							
							
							$('#addRewardsPeriod, #updateRewardsPeriod').on(tapEvent, function() {
								var stat = true;
								if (choosedPeriods.length == 0) {
									notify('Необходимо выбрать хотя бы один период!', 'error');
									stat = false;
								} 
								
								if ($('#newRewardPeriodTitle').val() == '') {
									$('#newRewardPeriodTitle').addClass('error');
									notify('Необходимо указать название периода!', 'error');
									stat = false;
								}
								
								if (stat) {
									rewardsPeriodsWin.wait();
									
									if (periodId) {
										$.post('/admin/rewards/update_period', {
											period_id: periodId,
											title: $('#newRewardPeriodTitle').val(),
											periods: choosedPeriods
										}, function() {
											rewardsPeriodsWin.wait(false);
											openPeriods();
										}).fail(function(e) {
											notify('Системная ошибка!', 'error');
											showError(e);
										});
									} else {
										$.post('/admin/rewards/add_period', {
											title: $('#newRewardPeriodTitle').val(),
											periods: choosedPeriods
										}, function() {
											rewardsPeriodsWin.wait(false);
											openPeriods();
										}).fail(function(e) {
											notify('Системная ошибка!', 'error');
											showError(e);
										});
									}	
								}
							});
							
							
							$('#goBack').on(tapEvent, function() {
								rewardsPeriodsWin.wait();
								openPeriods();
							});
						});
					});
					
					
					
					
					// --------------------------------------- Задать бюджет статиков
					$('[rewardssetstaticssumm]').on(tapEvent, function() {
						let rewardPeriodId = $(this).attr('rewardssetstaticssumm');
						
						getAjaxHtml('admin/rewards/get_statics_form', {period_id: rewardPeriodId}, function(html) {
							rewardsPeriodsWin.setData(html, false);
							rewardsPeriodsWin.setTitle('Премии: Задать бюджет статиков');
							rewardsPeriodsWin.setButtons([{id: 'setStaticsSumm', title: 'Задать'}, {id: 'goBack', title: 'Назад'}], 'Отмена');
							rewardsPeriodsWin.setWidth(900);
							
							
							$('#setStaticsSumm').on(tapEvent, function() {
								rewardsPeriodsWin.wait();
								sendFormData('#rewardsStaticsSum', {
									url: 'admin/rewards/set_statics_summ',
									params: {reward_period_id: rewardPeriodId},
									success: function(response) {
										if (response) {
											openPeriods();
										} else {
											notify('Ошибка перемещения файлов', 'error');
										}
									},
									complete: function() {
										//rewardsPeriodsWin.wait(false);
									}
								});
							});
							
							
							$('#goBack').on(tapEvent, function() {
								rewardsPeriodsWin.wait();
								openPeriods();
							});
							
							
						}, function() {
							$('.scroll').ddrScrollTable();
						});
					});
					
					
					
					
					
					// --------------------------------------- Внести суммы в баланс
					$('[rewardssettowallet]').on(tapEvent, function() {
						let thisButton = this,
							rewardPeriodId = $(this).attr('rewardssettowallet'),
							periodTitle = $(thisButton).closest('tr').find('[rewardperiodtitle]').text();
						rewardsPeriodsWin.wait();
						
						$.post('/admin/rewards/set_to_wallet', {period_id: rewardPeriodId, report_title: periodTitle}, function(response) {
							if (response) {
								$(thisButton).setAttrib('disabled');
								$(thisButton).siblings('[rewardsperiodedit]').setAttrib('disabled');
								$(thisButton).siblings('[rewardssetstaticssumm]').setAttrib('disabled');
								notify('Суммы успешно отправлены!');
							} else {
								notify('Ошибка отправки сумм в баланс!');
							}
							rewardsPeriodsWin.wait(false);
						}).fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					});
					
					
					
					
					
					
					
					// --------------------------------------- Сформировать отчет
					$('[rewardsbuildreport]').on(tapEvent, function() {
						let rewardPeriodId = $(this).attr('rewardsbuildreport'),
							rewardPeriodTitle = $(this).closest('tr').find('[rewardperiodtitle]').text();
						
						rewardsPeriodsWin.wait();
						getAjaxHtml('admin/rewards/get_report', {period_id: rewardPeriodId}, function(html) {
							$('#rewardsReport').html(html);
							$('#rewardsReportTitle').html('<small>Премиальный период:</small> '+rewardPeriodTitle);
							rewardsPeriodsWin.close();
							
							$('[rewardstid]').on(tapEvent, function() {
								let staticId = $(this).attr('rewardstid');
								
								popUp({
									title: 'Отчет по статику',
								    width: 600,
								    height: false,
								    html: '',
								    wrapToClose: true,
								    winClass: false,
								    buttons: false,
								    closeButton: false,
								}, function(rewardStaticReportWin) {
									rewardStaticReportWin.wait();
									getAjaxHtml('admin/rewards/get_static_report', {period_id: rewardPeriodId, static_id: staticId}, function(html) {
										rewardStaticReportWin.setData(html, false);
									}, function() {
										rewardStaticReportWin.wait(false);
									});
								});
							});
							
							
							
						}, function() {
							$('.scroll').ddrScrollTable();
						});
					});
					
					
					
					
				});
			})();
			
		});
	});


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------ Выплата баланса
	
	
	// Сформировать список выплат
	$('#buildWalletPayments').on(tapEvent, function() {
		$('#savedReportTitle, #savedReportDate').text('');
		
		popUp({
			title: 'Сформировать список выплат',
		    width: 900,
		    buttons: [{id: 'buildWPData', title: 'Сформировать', disabled: 1}],
		    closeButton: 'Отмена',
		}, function(buildWPDataWin) {
			buildWPDataWin.wait();
			getAjaxHtml('reports/wallet/get_params_to_build', function(html) {
				buildWPDataWin.setData(html, false);
				$('#buildWPData').removeAttrib('disabled');
			}, function() {
				buildWPDataWin.wait(false);
			});
			
			$('#buildWPData').on(tapEvent, function() {
				let walletParamStatics = $('#walletParamsForm').find('[walletparamstatics]:checked'),
					walletParamRanks = $('#walletParamsForm').find('[walletparamranks]:checked'),
					walletParamRoles = $('#walletParamsForm').find('[walletparamroles]:checked'),
					walletParamStates = $('#walletParamsForm').find('[walletparamstates]:checked'),
					params = {statics: [], ranks: [], roles: [], states: []},
					paramsStat = true;
				
				if (walletParamStatics.length == 0) {notify('Необходимо выбрать хотя бы один статик!', 'info'); paramsStat = false;}
				if (walletParamRanks.length == 0) {notify('Необходимо выбрать хотя бы одно звание!', 'info'); paramsStat = false;}
				if (walletParamRoles.length == 0) {notify('Необходимо выбрать хотя бы одну роль!', 'info'); paramsStat = false;}
				if (walletParamStates.length == 0) {notify('Необходимо выбрать хотя бы одно состояние!', 'info'); paramsStat = false;}
				
				
				
				$(walletParamStatics).each(function(k, input) {
					params.statics.push(parseInt($(input).val()));
				});
				
				$(walletParamRanks).each(function(k, input) {
					params.ranks.push(parseInt($(input).val()));
				});
				
				$(walletParamRoles).each(function(k, input) {
					params.roles.push(parseInt($(input).val()));
				});
				
				$(walletParamStates).each(function(k, input) {
					params.states.push($(input).val());
				});
				
				
				if (paramsStat) {
					(function setPayout() {
						buildWPDataWin.wait();
						getAjaxHtml('reports/wallet/build_payments', params, function(html, stat) {
							if (!stat) notify('Нет данных для формирования списка!', 'info');
							$('#walletReport').html(html);
							buildWPDataWin.wait(false);
							if (!stat) return;
							
							buildWPDataWin.close();
							ddrInitTabs();
							
							$('#saveWalletOrder').removeAttrib('disabled');
							$('#walletReport').find('[walletpayout], [wallettodeposit]').number(true, 1, '.', ' ');
							
							
							// изменение полы "выпатить"
							$('[walletpayout]').onChangeNumberInput(function(value, payoutInput) {
								let thisTr = $(payoutInput).closest('tr'),
									initDeposit = parseFloat($(thisTr).find('input[initdeposit]').val()),
									initPercentToDeposit = parseFloat($(thisTr).find('input[initpercenttodeposit]').val()),
									initBalance = parseFloat($(thisTr).find('input[initwalletbalance]').val()),
									initPayout = parseFloat($(thisTr).find('input[initpayout]').val()),
									initToDeposit = parseFloat($(thisTr).find('input[inittodeposit]').val()),
									initMaxToDeposit = parseFloat($(thisTr).find('input[initmaxtodeposit]').val()),
									toDepositInput = $(thisTr).find('[wallettodeposit]');
								
								
								if (value >= initPayout && value <= initBalance) {
									$(toDepositInput).val((initBalance - value).toFixed(1));
								} else if (value > initBalance) {
									$(payoutInput).val(initBalance.toFixed(1));
									$(toDepositInput).val(0);
									notify('Достигнута максимальная сумма для выплаты!', 'info');
								}
							});
							
							
							// изменение полы "в резерв"
							$('[wallettodeposit]').onChangeNumberInput(function(value, toDepositInput) {
								let thisTr = $(toDepositInput).closest('tr'),
									initDeposit = parseFloat($(thisTr).find('input[initdeposit]').val()),
									initPercentToDeposit = parseFloat($(thisTr).find('input[initpercenttodeposit]').val()),
									initBalance = parseFloat($(thisTr).find('input[initwalletbalance]').val()),
									initPayout = parseFloat($(thisTr).find('input[initpayout]').val()),
									initToDeposit = parseFloat($(thisTr).find('input[inittodeposit]').val()),
									initMaxToDeposit = parseFloat($(thisTr).find('input[initmaxtodeposit]').val()),
									payoutInput = $(thisTr).find('[walletpayout]'),
									payoutValue = parseFloat($(payoutInput).val()).toFixed(1);
								
								
								if (value >= (initBalance - payoutValue)) {
									if (initBalance - payoutValue > 0) {
										$(toDepositInput).val((initBalance - payoutValue).toFixed(1));
										notify('Достигнута максимальная сумма для выплаты в резерв!', 'info');
									} else {
										$(toDepositInput).val(0);
										notify('Нет доступных средств для выплаты в резерв!', 'info');
									}
								} else if (value > initMaxToDeposit) {
									$(toDepositInput).val(initMaxToDeposit);
									notify('Достигнута максимальная сумма для наполнения резерва!', 'info');
								} else if (value < 0) {
									$(toDepositInput).val(0);
									notify('Сумма для выплаты в резерв не может быть меньше нуля!', 'info');
								}
							});
							
							
							// Вернуть исходные значения
							$('[walletreturntoinit]').on(tapEvent, function() {
								let thisTr = $(this).closest('tr'),
									initToDeposit = parseFloat($(thisTr).find('input[inittodeposit]').val()),
									initPayout = parseFloat($(thisTr).find('input[initpayout]').val());
								
								$(thisTr).find('[walletpayout]').val(initPayout);
								$(thisTr).find('[wallettodeposit]').val(initToDeposit);
							});
							
							
							// всю сумму в оплату
							$('[walletalltopayout]').on(tapEvent, function() {
								let thisTr = $(this).closest('tr'),
									initBalance = parseFloat($(thisTr).find('input[initwalletbalance]').val()),
									payoutInput = $(thisTr).find('[walletpayout]'),
									toDepositInput = $(thisTr).find('[wallettodeposit]');
								
								$(toDepositInput).val(0);
								$(payoutInput).val(initBalance.toFixed(1));
							});
							
							
							// максимально возможную сумму в резерв
							$('[walletsetmaxtodeposit]').on(tapEvent, function() {
								let thisTr = $(this).closest('tr'),
									initDeposit = parseFloat($(thisTr).find('input[initdeposit]').val()),
									initPercentToDeposit = parseFloat($(thisTr).find('input[initpercenttodeposit]').val()),
									initBalance = parseFloat($(thisTr).find('input[initwalletbalance]').val()),
									initPayout = parseFloat($(thisTr).find('input[initpayout]').val()),
									initToDeposit = parseFloat($(thisTr).find('input[inittodeposit]').val()),
									initMaxToDeposit = parseFloat($(thisTr).find('input[initmaxtodeposit]').val()),
									payoutInput = $(thisTr).find('[walletpayout]'),
									toDepositInput = $(thisTr).find('[wallettodeposit]');
								
								let calcMaxTodeposit = initMaxToDeposit <= initBalance ? initMaxToDeposit : initBalance,
									calcToPayout = (initBalance - calcMaxTodeposit).toFixed(1);
								
								$(toDepositInput).val(calcMaxTodeposit.toFixed(1));
								$(payoutInput).val(calcToPayout);
							});
							
							
							// Выделить/снять выделение всех участников статика
							$('[walletselectstatic]').on(tapEvent, function() {
								let thisBtn = this,
									stat = $(thisBtn).attr('walletselectstatic');
								
								if (stat == 1) {
									$(thisBtn).closest('table').children('tbody').find('[walletcheckeduser]:not([disabled]):checked').each(function() {
										$(this).removeAttrib('checked');
									});
									$(thisBtn).attr('walletselectstatic', 0);
								} else if (stat == 0) {
									$(thisBtn).closest('table').children('tbody').find('[walletcheckeduser]:not([disabled]):not(:checked)').each(function() {
										$(this).setAttrib('checked');
									});
									$(thisBtn).attr('walletselectstatic', 1);
								}
							});
							
							
							
							
							// Сохранить отчет и выплатить суммы
							$('#saveWalletOrder').on(tapEvent, function() {
								popUp({
									title: 'Отчет по выплатам',
								    width: 400,
								    buttons: [{id: 'saveAndPayout', title: 'Сохранить и выплатить'}],
								    closeButton: false,
								}, function(saveAndPayoutWin) {
									saveAndPayoutWin.wait();
									getAjaxHtml('reports/wallet/get_save_blank', function(html) {
										saveAndPayoutWin.setData(html, false);
									}, function() {
										saveAndPayoutWin.wait(false);
									});
									
									
									$('#saveAndPayout').on(tapEvent, function() {
										let reportTitleInp = $('#walletReportTitle');
										
										if (reportTitleInp.val() == '') {
											notify('Необходимо ввести название отчета', 'info');
											$(reportTitleInp).addClass('error');
										
										} else {
											let payData = [],
												rows = $('#walletReport').find('[walletuserrow]');
											
											if (rows.length) {
												saveAndPayoutWin.wait();
												$(rows).each(function() {
													let thisRow = this;
													if ($(thisRow).find('[walletcheckeduser]').is(':checked') == false) return true;
													let d = $(thisRow).attr('walletuserrow').split('|'),
														staticId = d[0],
														userId = d[1],
														payout = parseFloat($(thisRow).find('[walletpayout]').val()).toFixed(1),
														toDeposit = parseFloat($(thisRow).find('[wallettodeposit]').val()).toFixed(1);
														
													payData.push({
														user_id: userId,
														static_id: staticId,
														payout: payout,
														to_deposit: toDeposit
													});
												});
												
												if (payData) {
													$.post('/reports/wallet/set_payout', {paydata: payData, title: reportTitleInp.val()}, function(response) {
														if (response) {
															saveAndPayoutWin.close();
															setPayout();
														} else {
															notify('Ошибка сохранения данных!', 'error');
															saveAndPayoutWin.wait(false);
														}
													}).fail(function(e) {
														notify('Системная ошибка!', 'error');
														saveAndPayoutWin.wait(false);
														showError(e);
													});
												} else {
													notify('Нет данных для сохранения отчета и совершения выплат', 'info');
													saveAndPayoutWin.close();
												}
												
											} else {
												notify('Не выбрано ни одного участника', 'info');
											}
										}
											
									});
														
								});
								
							});
							
						}, function() {});
					})();
				}
			});
		});
	});
	
	
	
	
	
	
	
	// открыть список сохраненных отчетов по оплатам
	$('#getWalletReportsList').on(tapEvent, function() {
		popUp({
			title: 'Сохраненные отчеты',
		    width: 500,
		    closeButton: 'Закрыть'
		}, function(reportsListWin) {
			reportsListWin.wait();
			getAjaxHtml('reports/wallet/get_reports', function(html) {
				reportsListWin.setData(html, false);
				reportsListWin.wait(false);
				$('#walletReportsList').ddrScrollTableY({height: '400px', wrapBorderColor: '#d7dbde'});
				
				$('[buildsavedreport]').on(tapEvent, function() {
					reportsListWin.wait();
					let reportId = $(this).attr('buildsavedreport'),
						reportTitle = $(this).closest('tr').find('[reporttitle]').text(),
						reportDate = $(this).closest('tr').find('[reportdate]').text();
						
					getAjaxHtml('reports/wallet/get_saved_report', {report_id: reportId}, function(html) {
						$('#walletReport').html(html);
						ddrInitTabs();
						reportsListWin.close();
						$('#savedReportTitle').text(reportTitle);
						$('#savedReportDate').text('от '+reportDate);
						
					}, function() {
						reportsListWin.wait(false);
					});
				});
				
			}, function() {
				reportsListWin.wait(false);
			});
		});
	});
	
	
	
	/*$('#walletOrders').on(tapEvent, function() {
		popUp({
			title: 'Платежные поручения',
		    //width: 500,
		    //buttons: [{id: 'newWalletReport', title: 'Новое плат. поручение'}],
		    //closeButton: 'Закрыть',
		}, function(walletOrdersWin) {
			
			(function getWalletOrdersList() {
				console.log('getWalletOrdersList');
				walletOrdersWin.setTitle('Платежные поручения');
				walletOrdersWin.setButtons([{id: 'newWalletReport', title: 'Новое плат. поручение'}], 'Закрыть');
				walletOrdersWin.setWidth(500);
				
				$(newWalletReport).on(tapEvent, function() {
					walletOrdersWin.setTitle('Новое платежное поручение');
					walletOrdersWin.setButtons([{id: 'addWalletReport', title: 'Создать', cls: 'alt'}, {id: 'toWalletOrdersList', title: 'Назад'}], 'Закрыть');
					
					$('#toWalletOrdersList').on(tapEvent, function() {
						getWalletOrdersList();
					});
					
					
					$('#addWalletReport').on(tapEvent, function() {
						console.log('addWalletReport');
					});
					
				});
			})();
			
			
			
			
		});
	});*/
	
	
	
	
	
	
	
	
	
	
	
});
//--></script>