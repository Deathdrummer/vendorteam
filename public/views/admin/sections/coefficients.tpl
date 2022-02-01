<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Коэффициенты</h2>
		
		<strong id="coefficientsPeriodName" class="ml-auto mr30px"></strong>
		
		<div class="buttons notop">
			<button id="coefficientsPeriodsBtn"><i class="fa fa-bars"></i></button>
		</div>
	</div>
	
	<div id="coefficientsStatics"></div>
	
	<div id="coefficientsBlock"></div>
	
</div>



<script type="text/javascript"><!--
$(function() {
	let periodId = ddrStore('coefficients:periodId'),
		staticId = false;
	getAjaxHtml('coefficients/data/statics', function(html, stat) {
		if (stat) $('#coefficientsStatics').html(html);
		else $('#coefficientsStatics').html('<p class="empty fz14px pl5px">Нет статиков</p>');
		
		let hashData = ddrInitTabs(),
			d = hashData[1] !== undefined ? hashData[1].split('_') : $('#coefficientsStatics').find('li:first').attr('id').split('_');
			staticId = d[1];
		
		getData();
		
		
		$('#coefficientsStatics').on(tapEvent, 'li', function() {
			let d = $(this).attr('id').split('_');
				staticId = d[1];
			getData();
		});
	});





	$('#coefficientsPeriodsBtn').on(tapEvent, function() {
		popUp({
			title: 'Периоды',
			width: 500,
			closeButton: 'Закрыть'
		}, function(coefficientsPeriodsWin) {
			coefficientsPeriodsWin.setData('coefficients/data/periods', function() {
				$('#coefficientsPeriods').ddrTable({minHeight: '50px', maxHeight: '70vh'});
			
				$('[coefficientschooseperiod]').on(tapEvent, function() {
					periodId = $(this).attr('coefficientschooseperiod');
					ddrStore('coefficients:periodId', periodId);
					coefficientsPeriodsWin.close();
					getData();
				});
			
			
			
			});
		});
	});




	function getData() {
		$('#coefficientsBlock').setWaitToBlock('Загрузка...', 'h200px');
		getAjaxHtml('coefficients/data', {period_id: periodId, static_id: staticId}, function(html, stat, headers) {
			$('#coefficientsBlock').html(html);
			$('.scroll').ddrScrollTable();
			$('#coefficientsPeriodName').text(cyrillicDecode(headers.period_name));
			
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