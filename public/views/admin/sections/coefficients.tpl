<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Коэффициенты</h2>
		
		<strong id="coefficientsPeriodName" class="ml-auto mr30px"></strong>
		<div id="coefficientsUserCard" class="ml-auto mr30px"></div>
		
		<div class="buttons notop">
			<button id="coefficientsPeriodsBtn" title="Периоды"><i class="fa fa-bars"></i></button>
			<button id="coefficientsUsersBtn" title="Участники"><i class="fa fa-user"></i></button>
		</div>
	</div>
	
	<div id="coefficientsPeriod">
		<div id="coefficientsStatics"></div>
		<div id="coefficientsBlock"></div>
	</div>
	
	<div id="coefficientsUser" hidden></div>
</div>



<script type="text/javascript"><!--
$(function() {
	let periodId = ddrStore('coefficients:periodId'),
		selectedStatics = ddrStore('coefficients:selectedStatics'),
		staticId = false;
	
	
	getStaticsTabs(true);
	
	$('#coefficientsStatics').on(tapEvent, 'li', function() {
		let d = $(this).attr('id').split('_');
		
		if (d[1] !== staticId) {
			staticId = d[1];
			getData();
		}
	});
	
	
	
	
	
	
	$('#coefficientsPeriodsBtn').on(tapEvent, function() {
		popUp({
			title: 'Коэффициенты всех участников|4',
			width: 1000,
			buttons: [{id: 'coefficientsPeriodsSetBtn', title: 'Показать'}],
			closeButton: 'Закрыть'
		}, function(coefficientsPeriodsWin) {
			coefficientsPeriodsWin.setData('coefficients/period/periods', {showstatics: 1}, function() {
				$('#coefficientsPeriods').ddrTable({minHeight: '50px', maxHeight: '70vh'});
				
				$('#coeffsStaticsGroups').find('[coeffsgroupbtn]').on(tapEvent, function() {
					let group = $(this).attr('coeffsgroupbtn');
					
					$('#coeffsStaticsGroups').find('button').removeClass('active');
					$(this).addClass('active');
					
					$('#coeffsStaticsList').find('[coeffsstaticgroup]').each(function() {
						if (group == 'all') $(this).setAttrib('checked');
						else if (group == 'none') $(this).removeAttrib('checked');
						else {
							if ($(this).attr('coeffsstaticgroup') == group) $(this).setAttrib('checked');
							else $(this).removeAttrib('checked');
						}
					});
					
					setChoosedStaticsIds();
				});
				
				
				$('#coeffsStaticsList').find('[coeffsstatic]').on('change', function() {
					setChoosedStaticsIds();
				});
				
				
				function setChoosedStaticsIds() {
					let sStatics = [];
					$('#coeffsStaticsList').find('[coeffsstatic]:checked').each(function() {
						let stId = $(this).attr('coeffsstatic');
						sStatics.push(isInt(stId) ? parseInt(stId) : stId);
					});
					ddrStore('coefficients:selectedStatics', sStatics);
					selectedStatics = sStatics;
				}
				
				
				
				
				$('#coefficientsPeriodsSetBtn').on(tapEvent, function() {
					let checkedPeriod = $('#coefficientsPeriods').find('[coefficientschooseperiod]:checked');
					if (!checkedPeriod.length)  {
						notify('Необходимо выбрать период!', 'error');
					} else {
						periodId = checkedPeriod.val();
						ddrStore('coefficients:periodId', periodId);
						
						$('#coefficientsUserCard').setAttrib('hidden');
						$('#coefficientsUserCard').html('');
						
						$('#coefficientsPeriod[hidden]').removeAttrib('hidden');
						$('#coefficientsUser:not([hidden])').setAttrib('hidden');
						
						
						coefficientsPeriodsWin.close();
						getStaticsTabs();
					}	
				});
				
			});
		});
	});
	
	
	
	
	
	
	$('#coefficientsUsersBtn').on(tapEvent, function() {
		usersManager({
			title: 'Коэффициенты участника|4',
			chooseType: 'single', // multiple Тип выборки одиночный или множественный
			returnFields: 'id, nickname, avatar',
			waitToChoose: true,
			//closeToChoose: true,
			onChoose: function(data, coeffsUserMngrWin) {
				let {id: user_id, nickname, avatar} = Object.values(data)[0];
				
				
				coeffsUserMngrWin.setData('coefficients/period/periods', {multiple: 1}, function() {
					//coeffsUserMngrWin.setTitle('Выбрать период');
					coeffsUserMngrWin.setButtons([{id: 'coeffsPeridosUserChooseBtn', title: 'Показать', disabled: 1}], 'Закрыть');
					coeffsUserMngrWin.setWidth(500, function() {
						$('#coefficientsPeriods').ddrTable({minHeight: '50px', maxHeight: '70vh'});
					});
					coeffsUserMngrWin.wait(false);
					
					
					
					$('[coefficientschooseperiod]').on('change', function() {
						if ($('#coefficientsPeriods').find('[coefficientschooseperiod]:checked').length) {
							$('#coeffsPeridosUserChooseBtn').removeAttrib('disabled');
						} else {
							$('#coeffsPeridosUserChooseBtn').setAttrib('disabled');
						}
					});
					
					$('#coeffsPeriodsCheckallBtn').on(tapEvent, function() {
						$('#coefficientsPeriods').find('[coefficientschooseperiod]:not(:checked)').each(function() {
							$(this).setAttrib('checked');
						});
						$('#coeffsPeridosUserChooseBtn').removeAttrib('disabled');
					});
					
					$('#coeffsPeriodsUncheckallBtn').on(tapEvent, function() {
						$('#coefficientsPeriods').find('[coefficientschooseperiod]:checked').each(function() {
							$(this).removeAttrib('checked');
						});
						$('#coeffsPeridosUserChooseBtn').setAttrib('disabled');
					});
					
					
					
					
					
					$('#coeffsPeridosUserChooseBtn').on(tapEvent, function() {
						coeffsUserMngrWin.close();
						let periods = [];
						$('#coefficientsPeriods').find('[coefficientschooseperiod]:checked').each(function() {
							periods.push($(this).val());
						});
						
						
						$('#coefficientsPeriod:not([hidden])').setAttrib('hidden');
						$('#coefficientsUser[hidden]').removeAttrib('hidden');
						$('#coefficientsPeriodName:not([hidden])').setAttrib('hidden');
						$('#coefficientsUserCard').setAttrib('hidden');
						$('#coefficientsUserCard').html('');
						$('#coefficientsUser').setWaitToBlock('Загрузка...', 'h200px');
						
						
						getAjaxHtml('coefficients/user', {user_id: user_id, periods: periods, nickname: nickname, avatar: avatar}, function(html, _, headers) {
							$('#coefficientsUserCard').html('<div class="d-flex align-items-center">\
								<img src="'+location.origin+'/'+headers.avatar+'" alt="" class="avatar h34px w34px">\
								<p class="ml4px fz14px">'+cyrillicDecode(headers.nickname)+'</p>\
								</div>');
							
							$('#coefficientsUserCard').removeAttrib('hidden');
							$('#coefficientsUser').html(html);
							$('.scroll').ddrScrollTable();
							
							$('#coefficientsUserStatics').find('li:first').addClass('active');
							$('#coefficientsUserStaticsContent').find('[tabid]:first').addClass('visible');
							
							
							
							let editRaidKoeffTOut;
							$('[koeffsdatauser]').find('[editkoeff]').onChangeNumberInput(function(value, input) {
								var d = $(input).attr('editkoeff').split('|');
								clearTimeout(editRaidKoeffTOut);
								editRaidKoeffTOut = setTimeout(function() {
									$.post('/account/edit_raid_koeff', {id: d[0], user_id: d[1], raid_id: d[2], rate: value}, function(response) {
										if (!response) {
											$(input).addClass('error');
											notify('Ошибка сохранения коэффициента!', 'error');
										} else {
											$(input).addClass('changed');
										}
									}).fail(function(e) {
										showError(e);
										notify('Системная ошибка!', 'error');
									});
								}, 200);
							});
							
							
							
							let editCompoundTOut;
							$('[compoundformuser]').find('[setcompound]').onChangeNumberInput(function(value, input) {
								var d = $(input).attr('setcompound').split('|'),
									periodId = d[0],
									staticId = d[1],
									userId = d[2],
									field = d[3];
								
								clearTimeout(editCompoundTOut);
								editCompoundTOut = setTimeout(function() {
									$.post('/account/set_compound_item', {period_id: periodId, static_id: staticId, user_id: userId, field: field, value: value}, function(response) {
										if (!response) {
											$(input).addClass('error');
											notify('Ошибка сохранения коэффициента!', 'error');
										} else {
											$(input).addClass('changed');
										}
									}).fail(function(e) {
										showError(e);
										notify('Системная ошибка!', 'error');
									});
								}, 200);
							});
							
						}); // ajaxHtml
						
					});
					
				});			
				
			}
		});
	});
	
	
	
	
	
	
	


	//---------------------------------------------------------------------------------------------------------





	function getStaticsTabs(init = false) {
		getAjaxHtml('coefficients/period/statics_tabs', {selected_statics: selectedStatics}, function(html, stat) {
			if (stat) $('#coefficientsStatics').html(html);
			else $('#coefficientsStatics').html('<p class="empty fz14px pl5px">Нет статиков</p>');
			
			let hashData = location.hash.substr(1, location.hash.length).split('.'),
				d = /coefficientsStatic_/.test(hashData[1]) ? hashData[1].split('_') : $('#coefficientsStatics').find('li:first').attr('id').split('_'),
				hasInTabs = $('#coefficientsStatics').find('li#coefficientsStatic_'+d[1]).length;
			
			if ((init && hasInTabs) || hasInTabs) {
				staticId = d[1];
			} else {
				let firstTab = $('#coefficientsStatics').find('li:first').attr('id').split('_');
				staticId = firstTab[1];
			}
			
			$('#coefficientsPeriod[hidden]').removeAttrib('hidden');
			$('#coefficientsUserCard').setAttrib('hidden');
			$('#coefficientsUserCard').html('');
			$('#coefficientsUser:not([hidden])').setAttrib('hidden');
			
			getData();
		});
	}
	
	
	
	
	






	function getData() {
		$('#coefficientsBlock').setWaitToBlock('Загрузка...', 'h200px');
		
		$('#coefficientsStatics').find('li#coefficientsStatic_'+staticId).addClass('active');
		$('#coefficientsPeriodName:not([hidden])').setAttrib('hidden');
		
		getAjaxHtml('coefficients/period', {period_id: periodId, static_id: staticId}, function(html, stat, headers) {
			$('#coefficientsBlock').html(html);
			$('.scroll').ddrScrollTable();
			$('#coefficientsPeriodName[hidden]').removeAttrib('hidden');
			if (headers.period_name) $('#coefficientsPeriodName').text(cyrillicDecode(headers.period_name));
			
			let editRaidKoeffTOut;
			$('#koeffsData').find('[editkoeff]').onChangeNumberInput(function(value, input) {
				var d = $(input).attr('editkoeff').split('|');
				clearTimeout(editRaidKoeffTOut);
				editRaidKoeffTOut = setTimeout(function() {
					$.post('/account/edit_raid_koeff', {id: d[0], user_id: d[1], raid_id: d[2], rate: value}, function(response) {
						if (!response) {
							$(input).addClass('error');
							notify('Ошибка сохранения коэффициента!', 'error');
						} else {
							$(input).addClass('changed');
						}
					}).fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				}, 200);
			});
			
			
			let editRaidTypeTOut;
			$('#koeffsData').find('[editraidtype]').on('change', function() {
				var select = this,
					keyId = $(select).attr('editraidtype'),
					thisTypeId = $(select).val();
				
				clearTimeout(editRaidTypeTOut);
				editRaidTypeTOut = setTimeout(function() {
					$.post('/account/edit_raid_type', {id: keyId, type: thisTypeId}, function(response) {
						if (!response) {
							$(select).addClass('error');
							notify('Ошибка сохранения типа рейда!', 'error');
						} else {
							$(select).addClass('changed');
						}
					}).fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				}, 200);
			});
			
			
			let editCompoundTOut;
			$('#compoundForm').find('[setcompound]').onChangeNumberInput(function(value, input) {
				var d = $(input).attr('setcompound').split('|'),
					userId = d[0],
					field = d[1];
				
				clearTimeout(editCompoundTOut);
				editCompoundTOut = setTimeout(function() {
					$.post('/account/set_compound_item', {period_id: periodId, static_id: staticId, user_id: userId, field: field, value: value}, function(response) {
						if (!response) {
							$(input).addClass('error');
							notify('Ошибка сохранения коэффициента!', 'error');
						} else {
							$(input).addClass('changed');
						}
					}).fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				}, 200);
			});
			
			
		}, function() {
			
		});
	}
});
//--></script>