<div class="section" id="ordersSection">
	<div class="section__title">
		<h1>Заказы</h1>
	</div>
	
	<div class="section__buttons" id="sectionButtons">
		<input type="hidden" id="ordersReportPeriodId" value=''>
		<button id="chooseOrdersPeriod" title="Периоды"><i class="fa fa-calculator"></i></button>
		<button id="setOrdersReport" class="alt ml-5" title="Сформировать отчет"><i class="fa fa-bar-chart"></i></button>
		<button id="saveOrdersReport" class="alt" title="Сохранить заказы" disabled><i class="fa fa-save"></i></button>
	</div>
	
	<div class="section__content" id="sectionContent">
		<div id="ordersReport" class="reports"></div>
	</div>
</div>


	




<script type="text/javascript"><!--
$(document).ready(function() {
	
	// ------------------------------------------------ Периоды
	$('body').off(tapEvent, '#chooseOrdersPeriod').on(tapEvent, '#chooseOrdersPeriod', function() {
		$(this).removeClass('error fail');
		popUp({
			title: 'Периоды',
		    width: 500
		}, function(periodsWin) {
			periodsWin.wait();
			getAjaxHtml('operator/get_reports_periods', function(html) {
				periodsWin.setData(html, false);
				$('[chooseperiod]').on(tapEvent, function() {
					var thisId = $(this).attr('chooseperiod');
					$('#ordersReportPeriodId').val(thisId);
					notify('Период выбран!');
					$('#chooseOrdersPeriod').addClass('done');
					periodsWin.close();
				});
			}, function() {
				periodsWin.wait(false);
			});	
		});
	});
	
	
	
	
	
	// -------------------------------------------------------------------------- Сформировать 2 отчет
	$('#setOrdersReport').on(tapEvent, function() {
		var periodId = $('#ordersReportPeriodId').val();
		if (periodId == '') {
			$('#chooseOrdersPeriod').addClass('fail error');
		} else {
			contentWait();
			$.post('/operator/set_orders_report', {period_id: periodId}, function(html) {	
				if (html.trim()) {
					$('#ordersReport').html(html);
					$('.scroll').ddrScrollX();
				} else {
					$('#ordersReport').html('<p class="empty center">Нет данных</p>');
				}
				contentWait(false);
			}, 'html').fail(function(e) {
				showError(e);
				notify('Системная ошибка!', 'error');
			});
		}	
	});
	
	
	
	
	$('body').off('keyup', '[changeorder]').on('keyup', '[changeorder]', function() {
		if ($(this).val() == '') $(this).addClass('error');
		else  $(this).addClass('changed');
		$('#saveOrdersReport').removeAttrib('disabled');
	});
	
	
	
	$('body').off(tapEvent, '#saveOrdersReport').on(tapEvent, '#saveOrdersReport', function() {
		var periodId = $('#ordersReportPeriodId').val()
			ordersData = [],
			fieldsStat = true;
		
		$('#ordersReport').find('[changeorder]').each(function(k, field) {
			if ($(field).val() == '') {
				$(field).addClass('error');
				fieldsStat = false;
				notify('Ошибка! Все поля должны быть заполнены!', 'error');
				return true;
			}
			var orderId = $(field).attr('changeorder'),
				orderVal = $(field).val();
			ordersData.push({
				id: orderId,
				value: orderVal
			}); 
		});
		
		
		if (fieldsStat) {
			contentWait();
			getAjaxHtml('operator/update_orders', {period_id: periodId, data: ordersData}, function(html, stat) {
				//$('#ordersReport').html(html);
				if (stat) notify('Заказы обновлены!');
				$('#ordersReport').find('[changeorder]').removeClass('changed');
				contentWait(false);
			});
		}
	});
	
	
	
	
});
//--></script>