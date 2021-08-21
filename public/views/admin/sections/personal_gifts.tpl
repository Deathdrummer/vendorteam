<div class="section" id="sectionPersonalGifts">
	<div class="section_title">
		<h2>Персональные подарки</h2>
		<div class="buttons notop">
			<button class="button fieldheight" id="personalGiftsButton" title="Список подарков"><i class="fa fa-gift"></i></button>
		</div>
	</div>
	
	{% if statics %}
		<ul class="tabstitles">
			{% for stId, stData in statics %}
				<li id="giftsStatic{{stId}}"><small class="fz11px">{{stData.name}}</small></li>
			{% endfor %}
		</ul>
		
		
		
		<div class="tabscontent">
			{% for stId, stData in statics %}
				<div tabid="giftsStatic{{stId}}">
					{% if users[stId] %}
						<div class="row">
						{% for usersPart in users[stId]|sortusers|chunktoparts(3, true) %}
							<div class="col-12 col-md-6 col-lg-4">
								<ul class="personalgiftslist">
									{% for user in usersPart %}
										<li class="personalgiftslist__item" giftuser="{{user.id}}">
											
											<div class="personalgiftslist__user noselect" giftuserhandle>
												<img src="{{base_url('public/images/users/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}" class="avatar w50px h50px">
												<div class="ml4px">
													<strong class="fz12px d-block mb3px">{{user.nickname}}</strong>
													<small class="fz11px d-block">{{ranks[user.rank]['name']}}</small>
												</div>
												
												<div class="ml-auto text-right">
													{% if user.counts.total > 0 %}
														<p class="fz14px mb3px">Всего: <strong>{{user.counts.total}}</strong></p>
														<p class="fz14px mb3px">В ожидании: <strong>{{user.counts.waiting}}</strong></p>
														<p class="fz14px">Принято: <strong>{{user.counts.taking}}</strong></p>
													{% else %}
														<span class="fz14px">Нет подарков</span>
													{% endif %}
												</div>
											</div>
											
											<div class="personalgiftslist__gifts" giftuserlist></div>
										</li>
									{% endfor %}
								</ul>
							</div>
						{% endfor %}
						</div>
					{% else %}
						<p class="empty">Нет участников</p>
					{% endif %}
				</div>
			{% endfor %}
		</div>
	{% endif %}
	
	
	
	
	
	
	
	
</div>


<script type="text/javascript"><!--
	$(document).off('renderSection').on('renderSection', function() {
		ddrInitTabs('sectionPersonalGifts');
		
		
		$('#personalGiftsButton').on(tapEvent, function() {
			popUp({
				title: 'Персональные подарки участникам',
			    width: 1000,
			    buttons: [{id: 'addGift', title: 'Добавить'}],
			    closeButton: 'Закрыть'
			}, function(personalGiftsWin) {
				personalGiftsWin.setData('gifts/init', {fields: ['title', 'diapason']}, function() {
					$('#giftsList').ddrCRUD({
						addSelector: '#addGift', // селектор для добавления новой записи
						data: {
							getList: {section: 'personal', fields: ['title', 'diapason']},
							add: {fields: ['title', 'diapason']},
							save: {section: 'personal', fields_items: ['title', 'diapason']}
						},
						confirms: {
							getList: function() {
								$('#giftsList').closest('table').ddrScrollTableY({height: '70vh', wrapBorderColor: '#d7dbde'});
							}
						},
						emptyList: '<tr><td colspan="4"><p class="empty">Нет данных</p></td></tr>',
						functions: 'gifts', // PHP функции, например: account/personages/[get,add,save,update,remove]
						removeConfirm: true,
						popup: personalGiftsWin
					});
				});
			});
		});
		
		
		
		
		
		
		
		
		
		
		
		$('[giftuserhandle]').on(tapEvent, function() {
			
			let block = $(this).closest('[giftuser]'),
				isOpened = $(block).hasClass('personalgiftslist_item_opened');
				userId = $(block).attr('giftuser'),
				giftsListBlock = $(block).find('[giftuserlist]');
			
			if (!isOpened) {
				
				$('#sectionPersonalGifts').find('.personalgiftslist_item_opened').find('[giftuserlist]').html('');
				
				$(block).append('<div class="waitabsblock"><i class="fa fa-spinner fa-pulse fz30px"></i></div>');
				
				(function getUserGiftsList() {
					getAjaxHtml('admin/personalgifts/get_user_list', {user_id: userId}, function(html) {
						$(giftsListBlock).html(html);
						
						let giftsListBlockScrTable = $(giftsListBlock).find('table').ddrScrollTableY({height: '300px', cls: 'scroll_y_thin'});
						giftsListBlockScrTable.reInit();
						
						let changeGiftValueTOut;
						$('[personalusersgifts]').onChangeNumberInput(function(value, input) {
							let giftId = $(input).attr('personalusersgifts');
							clearTimeout(changeGiftValueTOut);
							changeGiftValueTOut = setTimeout(function() {
								$.post('admin/personalgifts/change_gift_value', {id: giftId, value: value}, function(response) {
									if (response) {
										$(input).addClass('changed');
									} else {
										$(input).addClass('error');
										notify('Ошибка сохранения значения!', 'error');
									}
								}).fail(function(e) {
									showError(e);
									notify('Системная ошибка!', 'error');
								});
							}, 300);
						});
						
						
						
						
						$('[personalusersgiftsremove]').on(tapEvent, function() {
							let tr = $(this).closest('tr'),
								countRows = $(this).closest('tbody').find('tr').length,
								giftId = $(this).attr('personalusersgiftsremove');
							
							$.post('admin/personalgifts/remove_gift', {id: giftId}, function(response) {
								if (response) {
									if (countRows == 1) $(tr).replaceWith('<tr><td colspan="4"><p class="empty center fz11px">Нет подарков</p></td></tr>');
									else $(tr).remove();
									notify('Подарок успешно удален!');
									giftsListBlockScrTable.reInit();
								} else {
									notify('Ошибка удаления подарка!', 'error');
								}
							}).fail(function(e) {
								showError(e);
								notify('Системная ошибка!', 'error');
							});
						});
						
						
						
						
						$('[personalgiftsadd]').on(tapEvent, function() {
							let userId = $(this).attr('personalgiftsadd');
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
								personalGiftsAddWin.setData('admin/personalgifts/get', {section: 'personal'}, function(html) {
									
									$('#personalGiftsList').ddrScrollTableY({height: '600px', cls: 'scroll_y_thin'});
									
									$('#personalGiftsList').find('[personalgifttoadd]').on('change', function() {
										let countChecked = $('#personalGiftsList').find('[personalgifttoadd]:checked').length;
										if (countChecked) $('#personalGiftsAddBtn').removeAttrib('disabled');
										else $('#personalGiftsAddBtn').setAttrib('disabled');
									});
									
									$('#personalGiftsAddBtn').on(tapEvent, function() {
										personalGiftsAddWin.wait();
										let giftsToAdd = [];
										$('#personalGiftsList').find('[personalgifttoadd]:checked').each(function() {
											let giftId = $(this).val();
											giftsToAdd.push(parseInt(giftId));
										});
										
										$.post('admin/personalgifts/add', {user_id: userId, gifts: giftsToAdd}, function(response) {
											if (response) {
												personalGiftsAddWin.close();
												notify('Подарки успешно добавлены');
												getUserGiftsList();
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
						
					}, function() {
						$(block).find('.waitabsblock').remove();
					});			
				})();
				
				
					
				
				
				
				
			} else {
				$(giftsListBlock).html('');
			}
			
			
			
			
			
				
			
			//$(block).find('[giftuserlist]')
			
			
			$(block).toggleClass('personalgiftslist_item_opened');
		});
		
		
	});
//--></script>