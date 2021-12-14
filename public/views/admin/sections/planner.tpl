<div class="section" id="{{id}}">
	<div class="section_title noselect">
		<h2>Планировщик</h2>
		
		<strong id="plannerMonth" class="planner__date fontcolor"></strong>
		
		
		
		<div class="plannertypes mr40px" plannerpanel id="plannerTypes">
			<div class="plannertypes__item" title="Верифицированные">
				<input type="radio" name="plannertype" id="plannertypesVerify" plannerdatatype="birthdays" checked>
				<label for="plannertypesVerify">Дни рождения</label>
			</div>
			
			{# <div class="plannertypes__item" title="Новые">
				<input type="radio" name="plannertype" id="plannertypesNew" usersv2showlist="new">
				<label for="plannertypesNew">Н</label>
			</div> #}
		</div>
		
		
		<div class="usersv2showlists mr40px" plannerpanel id="plannerShowLists">
			<div class="usersv2showlists__item" title="Верифицированные">
				<input type="checkbox" id="usersv2showlistsVerify" plannershowlist="verify">
				<label for="usersv2showlistsVerify">В</label>
			</div>
			
			<div class="usersv2showlists__item" title="Новые">
				<input type="checkbox" id="usersv2showlistsNew" plannershowlist="new">
				<label for="usersv2showlistsNew">Н</label>
			</div>
			
			<div class="usersv2showlists__item" title="Отстраненные">
				<input type="checkbox" id="usersv2showlistsExcluded" plannershowlist="excluded">
				<label for="usersv2showlistsExcluded">О</label>
			</div>
			
			<div class="usersv2showlists__item" title="Замороженные">
				<input type="checkbox" id="usersv2showlistsFrozen" plannershowlist="frozen">
				<label for="usersv2showlistsFrozen">З</label>
			</div>
			
			<div class="usersv2showlists__item" title="Удаленные">
				<input type="checkbox" id="usersv2showlistsDeleted" plannershowlist="deleted">
				<label for="usersv2showlistsDeleted">У</label>
			</div>
		</div>
		
		
		
		<div class="buttons notop inline minspace" id="plannerButtons">
			<button listoffsetbtn="prev" title="Назад" disabled><i class="fa fa-arrow-left"></i></button>
			<button class="alt2" listoffsetbtn="reset" title="Сбросить" disabled><i class="fa fa-refresh"></i></button>
			<button listoffsetbtn="next" title="Вперед" disabled><i class="fa fa-arrow-right"></i></button>
		</div>
	</div>
	
	
	
	<div class="planner">
		<div class="planner__week">
			<div class="drow dgutter-10">
				{% for day in ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'] %}
					<div class="dcol-7 planner__weekitem">
						<div class="weekitem">
							<p>{{day}}</p>
						</div>
					</div>
				{% endfor %}
			</div>
		</div>
		<div class="planner__list">
			<div id="plannerLoading"></div>
			<div id="plennerList"></div>
		</div>
	</div>
	
	
	
	
</div>



<script type="text/javascript"><!--
$(function() {
	ddrStore('planner:offset', 0);
	
	let offset = ddrStore('planner:offset') || 0,
		type = 'birthdays';
	
	
	getList();
	
	$('[listoffsetbtn]').on(tapEvent, function() {
		let dir = $(this).attr('listoffsetbtn');
		if (dir == 'prev') offset -= 1;
		else if (dir == 'next') offset += 1;
		else if (dir == 'reset') offset = 0;
		
		getList(function() {
			ddrStore('planner:offset', parseInt(offset));
		});
	});
	
	
	
	
	
	
	//-------------------- Выбор и запоминание типов списков
	let shoosedLists = ddrStore('planner:showlists') || [];
	if (shoosedLists.length) {
		$('#plannerShowLists').find('[plannershowlist]').each(function(k, item) {
			let listType = $(item).attr('plannershowlist');
			if (shoosedLists.indexOf(listType) !== -1) $(item).setAttrib('checked');
		});
	}
		
	
	$('#plannerShowLists').find('[plannershowlist]').on('change', function() {
		let checkedShowLists = [];
		$('#plannerShowLists').find('[plannershowlist]:checked').each(function() {
			checkedShowLists.push($(this).attr('plannershowlist'));
		});
		ddrStore('planner:showlists', checkedShowLists);
		getList();
	});
	
	
	
	
	
	
	
	
	
	
	
	
	// ------------------------- Отправить сообщение
	/*$('body').off(tapEvent, '[plannersendmessbtn]').on(tapEvent, '[plannersendmessbtn]', function() {
		let userId = parseInt($(this).attr('plannersendmessbtn')),
			nickname = $(this).closest('[planneruser]').find('[plannerusername]').text();
		
		popUp({
			title: 'Отправить сообщение|4',
			width: 500,
			buttons: [{id: 'plannerSendMessBtn', title: 'Отправить'}],
			buttonsAlign: 'right',
			closePos: 'left',
			closeButton: 'Отмена'
		}, function(plannerSendMessWin) {
			plannerSendMessWin.setData('planner/message', {nickname: nickname}, function() {
				$('#plannerSendMessBtn').on(tapEvent, function() {
					let message = $('#plannerMessage').val(),
						title = $('#plannerTitle').val(),
						stat = true;
					
					if (!message) {
						$('#plannerMessage').addClass('error');
						stat = false;
					}
					
					if (!title) {
						$('#plannerTitle').addClass('error');
						stat = false;
					}
					
					
					if (stat) {
						plannerSendMessWin.wait();
						$.post('planner/message/send', {user_id: userId, title: title, message: message}, function(response) {
							if (response) {
								notify('Сообщение успешно отправлено!');
								plannerSendMessWin.close();
								socket.emit('usersmessages:send', [userId]);
							} else {
								notify('Ошибка отправки сообщения!');
							}
							plannerSendMessWin.wait(false);
						}).fail(function(e) {
							plannerSendMessWin.wait(false);
							showError(e);
							notify('Системная ошибка!', 'error');
						});
					}
				});
				
			});
		});
	});*/
	
	
	
	
	
	
	
	// ------------------------- Отправить подарок
	$('body').off(tapEvent, '[plannergiftsbtn]').on(tapEvent, '[plannergiftsbtn]', function() {
		let userId = $(this).attr('plannergiftsbtn');
		popUp({
			title: 'Добавить подарки',
		    width: 600,
		    buttons: [{id: 'personalGiftsAddBtn', title: 'Выбрать'}],
		    buttonsAlign: 'left',
		    disabledButtons: true,
		    closePos: 'left',
		    closeByButton: false,
		    closeButton: 'Отмена',
		    winClass: false,
		    contentToCenter: false,
		    buttonsOnTop: false,
		    topClose: true
		}, function(personalGiftsAddWin) {
			personalGiftsAddWin.setData('admin/personalgifts/get', {section: 'personal', message: 1}, function(html) {
				
				$('#personalGiftsList').ddrScrollTableY({height: '600px', cls: 'scroll_y_thin'});
				
				$('#personalGiftsList').find('[personalgifttoadd]').on('change', function() {
					let countChecked = $('#personalGiftsList').find('[personalgifttoadd]:checked').length;
					if (countChecked) $('#personalGiftsAddBtn').removeAttrib('disabled');
					else $('#personalGiftsAddBtn').setAttrib('disabled');
				});
				
				$('#personalGiftsAddBtn').on(tapEvent, function() {
					personalGiftsAddWin.wait();
					let giftsToAdd = [], message = '';
					$('#personalGiftsList').find('[personalgifttoadd]:checked').each(function() {
						let giftId = $(this).val(),
							count = $(this).closest('tr').find('[personalgifttoaddcount]').val();
						giftsToAdd.push({
							id: parseInt(giftId),
							count: count
						});
					});
					
					message = $('#personalGiftsMessage').val().trim();
					
					$.post('admin/personalgifts/add', {user_id: userId, gifts: giftsToAdd, message: message}, function(response) {
						if (response) {
							personalGiftsAddWin.close();
							notify('Подарки успешно добавлены');
							socket.emit('gifts:new', userId, giftsToAdd.length);
						} else {
							personalGiftsAddWin.wait(false);
							notify('Ошибка добавления подарков', 'error');
						}
					}).fail(function(e) {
						personalGiftsAddWin.wait(false);
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				});
				
				
				
			});
			
				
			
		});
	});
	
	
	
	
	
	
	
	function getList(callback) {
		$('#plannerLoading').addClass('planner_loading');
		$('[plannerpanel]').addClass('plannertypes_disabled');
		$('#plannerButtons').find('button').prop('disabled', true);
		
		Promise.all([
			getAjaxHtml('planner/list', {type: type, offset: offset, show_lists: ddrStore('planner:showlists')}),
			getAjaxJson('planner/list/date', {offset: offset})
		]).then(([html, date]) => {
			$('#plannerMonth').text(date.json.month+' '+date.json.year+' г.');
			$('#plennerList').html(html.html);
			$('#plannerLoading').removeClass('planner_loading');
			$('[plannerpanel]').removeClass('plannertypes_disabled');
			$('#plannerButtons').find('button:not([listoffsetbtn="reset"])').prop('disabled', false);
			if (offset != 0) $('#plannerButtons').find('button[listoffsetbtn="reset"]').prop('disabled', false);
			else $('#plannerButtons').find('button[listoffsetbtn="reset"]').prop('disabled', true);
			
			if (callback && typeof callback == 'function') callback();
		});
	}
	
	
	
});
//--></script>	