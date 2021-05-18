<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Статистика (доходы)</h2>
	</div>
	
	
	<ul class="tabstitles">
		<li id="tabStaticsAmount" class="active">Доход статиков</li>
		<li id="tabUsersAmount">Доход участников</li>
		<li id="tabRanksAmount">Доход званий</li>
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
						<button id="ratingPeriods" class="fieldheight" title="Периоды"><i class="fa fa-calculator"></i></button>
					</div>
				</div>
				
				
				<div id="" class="reports noborder"></div>
			</fieldset>
		</div>
		
		
		<div tabid="tabRanksAmount">
			<fieldset>
				<legend>Отчет</legend>
				
				<div class="item inline">
					<div class="buttons notop">
						<button id="ratingPeriods" class="fieldheight" title="Периоды"><i class="fa fa-calculator"></i></button>
					</div>
				</div>
				
				
				<div id="" class="reports noborder"></div>
			</fieldset>
		</div>
	
	
</div>








<script type="text/javascript"><!--
	
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
					if (checkedLength) {
						$('#sAChooseStatics:disabled').removeAttrib('disabled');
					} else {
						$('#sAChooseStatics:not(:disabled)').setAttrib('disabled');
					}
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
						
						$('#reportsAmountSetAll').on(tapEvent, function() {
							$('#reportsAmountList').find('input[type="checkbox"]:not(:checked)').each(function() {
								$(this).setAttrib('checked');
							});
							$('#sAChooseReports:disabled').removeAttrib('disabled');
						});
						
						
						$('#reportsAmountList').find('input[type="checkbox"]').on(tapEvent, function() {
							let checkedLength = $('#reportsAmountList').find('input[type="checkbox"]:checked').length;
							if (checkedLength) {
								$('#sAChooseReports:disabled').removeAttrib('disabled');
							} else {
								$('#sAChooseReports:not(:disabled)').setAttrib('disabled');
							}
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
	
	
	
//--></script>