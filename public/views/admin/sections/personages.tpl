<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Персонажи</h2>
		<div class="buttons notop" id="{{id}}SaveBlock">
			<button class="large" id="{{id}}Save" title="Сохранить" disabled><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Персонажи и ID игр</legend>
	
	
		<ul class="tabstitles">
			<li id="tabGamesIds">ID игр</li>
			<li id="tabNewPersonages">Заявки от пользователей</li>
		</ul>
		
		
		<div class="tabscontent">
			<div tabid="tabGamesIds">
				<div class="d-flex align-items-center mb-4">
					<p>Поиск:</p>
					<div class="d-flex align-items-center">
						<div class="item inline">
							<div class="select">
								<select gameidsfilterfield>
									<option value="pgi.game_id">ID игры</option>
									<option value="u.nickname">Владелец</option>
								</select>
								<div class="select__caret"></div>
							</div>
						</div>
						
						<div class="item mt-0 ml-2">
							<div class="field">
								<input type="text" gameidsfilterval>
							</div>
						</div>
						
						<div class="item mt-0 ml-2">
							<div class="buttons mt-0">
								<button id="gameIdsSetSearch">Поиск</button>
								<button id="gameIdsSetFilter7" class="ml-5">Истекает через 7 дней</button>
								<button id="gameIdsSetFilter10">Истекает через 10 дней</button>
								<button id="gameIdsSetFilterUnactive">Неактивные</button>
								<button id="gameIdsResetFilter" class="remove">Сбросить</button>
							</div>
						</div>	
					</div>
					
					<div class="item mt-0 ml-auto">
						<div class="buttons">
							<button id="addGameId">Добавить ID игры</button>
						</div>
					</div>
				</div>
				
				<table class="table_hover" id="gamesIdsTable">
					<thead>
						<tr>
							{# <td class="w45px">ID</td> #}
							<td class="w150px">ID игры</td>
							<td class="w100px">Кол-во персонажей</td>
							<td></td>
							<td class="w320px">Действует до</td>
							<td class="w350px">Владелец</td>
							<td class="w100px">Операции</td>
						</tr>
					</thead>
					<tbody id="gameIdsList"></tbody>
				</table>
			</div>
			
			<div tabid="tabNewPersonages">
				{% if personages %}	
					<table>
						<thead>
							<tr>
								<td>Никнейм персонажа</td>
								<td>Тип брони</td>
								<td>Сервер</td>
								<td>Заявщик</td>
								<td>Удал.</td>
							</tr>
						</thead>
						<tbody id="noIdPersonages">
							{% for item in personages %}
								<tr>
									<td>
										<div class="text">
											<input type="hidden" class="personages_id" value="{{item.id}}">
											<input class="personages_nickname" type="text" value="{{item.nick}}">
										</div>
									</td>
									<td>
										<div class="select">
											<select class="personages_armor">
												<option{% if item.armor == 'Латы' %} selected{% endif %} value="Латы">Латы</option>
												<option{% if item.armor == 'Кольчуга' %} selected{% endif %} value="Кольчуга">Кольчуга</option>
												<option{% if item.armor == 'Кожа' %} selected{% endif %} value="Кожа">Кожа</option>
												<option{% if item.armor == 'Ткань' %} selected{% endif %} value="Ткань">Ткань</option>
											</select>
											<div class="select__caret"></div>
										</div>
									</td>
									<td>
										<div class="text">
											<input class="personages_server" type="text" value="{{item.server}}">
										</div>
									</td>
									<td>
										{% if item.user_nickname %}
											<div class="d-flex align-items-center">
												{% if item.user_avatar %}
													<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/users/mini/'~item.user_avatar)}}')" title="{{item.user_nickname}}"></div>
												{% else %}
													<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/user_mini.jpg')}}')" title="{{item.user_nickname}}"></div>
												{% endif %}
												<span>{{item.user_nickname}}</span>
											</div>
										{% else %}
											<p>Администратор</p>
										{% endif %}
									</td>
									<td class="nowidth">
										<div class="buttons">
											<button class="remove" removepersonage="{{item.id}}"><i class="fa fa-trash" title="Удалить заявку"></i></button>
										</div>
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				{% else %}
					<p class="empty">Нет данных</p>
				{% endif %}
			</div>
		</div>
	
	</fieldset>
		
</div>












<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	
	$('#gamesIdsTable').ddrScrollTableY({
		height: 'calc(100vh - 420px)',
		minHeight: '300px',
		//wrapBorderColor: false,
		offset: 0
	});
	
	
	
	
	$('#personagesSave').on(tapEvent, function() {
		var saveButton = this,
			data = [],
			changedRows = $('#noIdPersonages').find('.changed');
		if (changedRows.length > 0) {
			$(changedRows).each(function() {
				var thisRow = this,
					id = $(thisRow).find('.personages_id').val(),
					nick = $(thisRow).find('.personages_nickname').val(),
					armor = $(thisRow).find('.personages_armor').val();
					server = $(thisRow).find('.personages_server').val(),
					game_id = $(thisRow).find('.personages_game_id').val();
				
				data.push({
					id: parseInt(id),
					nick: nick,
					armor: armor,
					server: server,
					game_id: game_id ? parseInt(game_id) : null,
					approved: game_id ? 1 : 0
				});
			});
			
			
			$.post('/admin/personages/save', {personages: data}, function(response) {
				if (response) {
					$(changedRows).each(function() {
						if ($(this).find('.personages_game_id').val() != null) {
							$(this).remove();
						} else {
							$(this).removeClass('changed');
						}
					});
					notify('Персонажи успешно сохранены!');
					$(saveButton).setAttrib('disabled');
				} else {
					notify('Ошибка сохранения персонажей!', 'error');
				}
			}, 'json').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		} else {
			notify('Нет данных для сохранения!', 'info');
		}	
	});
	
	
	$('#noIdPersonages').changeRowInputs(function(row, item, type) {
		$('#personagesSave').removeAttrib('disabled');
		$(row).addClass('changed');
		if (type == 'select' && $(item).hasClass('personages_game_id')) {
			var selectedGameId = $(item).val(),
				userId = $(item).attr('user');
			$('[user]:not([user="'+userId+'"]) option[value="'+selectedGameId+'"]').remove();
		}
	});

	
	
	
	$('body').off(tapEvent, '[removepersonage]').on(tapEvent, '[removepersonage]', function() {
		var thisItem = this,
			thisPersonageId = $(thisItem).attr('removepersonage'),
			thisRow = $(thisItem).closest('tr');
		
		popUp({
			title: 'Удалить заявку',
		    width: 400,
		    html: '<p class="center">Вы действительно хотите удалить заявку?</p>',
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'removePersonage', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(removePersonageWin) {
			$('#removePersonage').on(tapEvent, function() {
				$.post('/admin/personages/remove', {id: thisPersonageId}, function(response) {
					if (response) {
						$(thisRow).remove();
						notify('Персонаж успешно удален!');
						removePersonageWin.close();
					} else {
						notify('Ошибка! Не удалось удалить персонажа!', 'error');
					}
				});
			});
		});	
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('#gameIdsList').ddrCRUD({
		addSelector: '#addGameId',
		emptyList: '<tr><td colspan="7">Нет данных</td></tr>',
		functions: 'admin/game_ids',
		confirms: {
			add: function() {
				$('#gamesIdsTable').parent().scrollTop(999999);
			},
			remove: function(thisRow) {
				if ($(thisRow).next('tr.personageslist').length > 0) $(thisRow).next('tr.personageslist').remove();
			}
		},
		removeConfirm: true,
	}, function(list) {
		$('#gameIdsList').changeRowInputs(function(row, item) {
			$(row).addClass('changed');
			//$(row).find('save').removeAttrib('disabled');
		});
		
		// продление аккаунта (установка даты)
		$('#gameIdsList').on('change keyup', 'input[name="extend"]', function() {
			var thisVal 	= parseInt($(this).val()),
				dateStated	= parseInt($(this).closest('td.date_end').find('p[extenddate]').attr('extenddate')) || false;
			if (isNaN(thisVal)) return false;
			
			var setDays		= thisVal,
				msNow 		= Math.trunc(new Date().getTime() / 1000) * 1000,
				msStated 	= dateStated ? dateStated * 1000 : msNow;
			
			if (msStated <= msNow) {
				console.log('y');
				var d = new Date();
					d.setTime(msNow + (setDays * 86400000));
				$(this).closest('td.date_end').find('p[extenddate]').text(d.getDate()+' '+monthNames[d.getMonth() + 1]+' '+d.getFullYear()+' г.');
			} else {
				var d = new Date();
					d.setTime(msStated + (setDays * 86400000));
				$(this).closest('td.date_end').find('p[extenddate]').text(d.getDate()+' '+monthNames[d.getMonth() + 1]+' '+d.getFullYear()+' г.');
			}
		});
		
		
		
		
		// привязать пользователя
		$('#gameIdsList').on(tapEvent, '[setgameiduser]', function() {
			var thisButton = this,
				gameId = $(thisButton).attr('setgameiduser')
				thisRow = $(thisButton).closest('tr'),
				thisUserCard = $(thisRow).find('.usercard'),
				thisTiedUser = $(thisUserCard).find('[name="user_id"]').val() || false;
			
			popUp({
				title: 'Привязать участника',
			    width: 500,
			    html: '<div class="field"><input type="text" id="usersToGameFindUser" autocomplete="off"/></div><div id="usersToGameUsers" class="payment_requests_users noselect"></div>',
			    buttons: [{id: 'chooseGameIdUser', title: 'Привязать участника'}],
			    closeButton: 'Отмена',
			}, function(setgameiduserWin) {
				$('#usersToGameUsers').addClass('wait');
				getAjaxHtml('admin/game_ids/get_users_to_game', {tied_user: thisTiedUser, query: 0}, function(html) {
					$('#usersToGameUsers').html(html);
					$('#usersToGameUsers').removeClass('wait');
					//--------------------------------------------------- Поиск участников
					var pRFUserTOut; 
					$('#usersToGameFindUser').on('keyup', function() {
						clearTimeout(pRFUserTOut);
						pRFUserTOut = setTimeout(function() {
							var val = $('#usersToGameFindUser').val();
							if (val.length == 0 || val.length >= 2) {
								$('#usersToGameUsers').addClass('wait');
								getAjaxHtml('admin/game_ids/get_users_to_game', {tied_user: thisTiedUser, query: val}, function(html) {
									$('#usersToGameUsers').html(html);
								}, function() {
									$('#usersToGameUsers').removeClass('wait');
									setgameiduserWin.correctPosition();
								});
							}
						}, 300);	
					});
					
					
					
					//--------------------------------------------------- Выбор участников
					$('body').off(tapEvent, '[chooseusertogameid]').on(tapEvent, '[chooseusertogameid]', function() {
						var addItem = '',
							thisUserId = $(this).attr('chooseusertogameid'),
							thisUserNickname = $(this).find('.nickname').text(),
							thisUserAvatar = $(this).find('.avatar').val() ? location.origin+'/public/images/users/'+($(this).find('.avatar').val()) : location.origin+'/public/images/user_mini.jpg';
						
						var html = '';
							html += '<div class="avatar w40px h40px mr-1" style="background-image: url('+thisUserAvatar+')" title="'+thisUserNickname+'"></div>';
							html += '<span>'+thisUserNickname+'</span>';
							html += '<input type="hidden" name="user_id" value="'+thisUserId+'" />';
						
						$(thisRow).addClass('changed');
						$(thisRow).find('[update], [save], button.removegiuser[disabled]').removeAttrib('disabled');
						$(thisUserCard).html(html);
						setgameiduserWin.close();
					});
					
				}, function() {
				});
			});
		});
		
		
		
		
		
		// отвязать пользователя
		$('#gameIdsList').on(tapEvent, '[removegameiduser]', function() {
			let gameId = $(this).attr('removegameiduser'),
				thisRow = $(this).closest('tr');
			
			popUp({
				title: 'Отвязать участника',
			    width: 400,
			    html: '<p>Вы действительно хотите отвязать участника?</p>',
			    buttons: [{id: 'untieGameIdUser', title: 'Отвязать'}],
			    closeButton: 'Отмена',
			}, function(untieGameIdUserWin) {
				$('#untieGameIdUser').on(tapEvent, function() {
					$.post('/admin/game_ids/untie_user_to_game', {game_id: gameId}, function(response) {
						if (response) {
							$(thisRow).find('.usercard').html('<span>Не привязан</span>');
							$(thisRow).find('button.removegiuser').setAttrib('disabled');
							untieGameIdUserWin.close();
						} else {
							notify('Ошибка! Не удалось отвязать участника', 'error');
							untieGameIdUserWin.close();
						}
					});
				});
			});
		});
		
		
		
		
		// поиск
		$('#gameIdsSetSearch').on(tapEvent, function() {
			let field = $('[gameidsfilterfield]').val(),
				value = $('[gameidsfilterval]').val();
			list.search(field, value, 'both');
		});
		
		
		// истекает через 7 дней
		$('#gameIdsSetFilter7').on(tapEvent, function() {
			let date7 = getTimePoint('d:8', 's'),
				dateNow = getTimePoint('s');
			list.where([
				{
					method: 'where',
					rule: 'pgi.date_end >',
					value: dateNow['t']
				}, {
					method: 'where',
					rule: 'pgi.date_end <=',
					value: date7['t']
				}
			]);
		});
		
		
		//  истекает через 10 дней
		$('#gameIdsSetFilter10').on(tapEvent, function() {
			let date10 = getTimePoint('d:11', 's'),
				dateNow = getTimePoint('s');
			list.where([
				{
					method: 'where',
					rule: 'pgi.date_end >',
					value: dateNow['t']
				}, {
					method: 'where',
					rule: 'pgi.date_end <=',
					value: date10['t']
				}
			]);
		});
		
		
		// неактивные
		$('#gameIdsSetFilterUnactive').on(tapEvent, function() {
			let dateNow = getTimePoint('s');
			list.where([
				{
					method: 'where',
					rule: 'pgi.date_end <=',
					value: dateNow['t'] + 86400
				}
			]);
		});
		
		
		// сбросить
		$('#gameIdsResetFilter').on(tapEvent, function() {
			list.reset();
		});
		
	});
	
	
	
	
	$('#gameIdsList').off(tapEvent, '[showgamepersonages]').on(tapEvent, '[showgamepersonages]', function(e) {
		if ($.inArray(e.target.localName, ['i', 'button', 'input']) != -1) return false;
		
		var thisRow = this,
			thisId = $(thisRow).attr('showgamepersonages'),
			thisBlockId = 'personagesList'+thisId;
		
			
		if ($(thisRow).hasClass('opened') || $(thisRow).next('tr.personageslist').length > 0) {
			$(thisRow).next('tr.personageslist').remove();
			$(thisRow).removeClass('opened');
		} else {
			$('#gameIdsList').children('tr').removeClass('opened');
			$('#gameIdsList').children('tr.personageslist').remove();
			$(thisRow).addClass('opened');
			$(this).after('<tr class="personageslist opened"><td class="nopadding nohover" colspan="7"><div id="'+thisBlockId+'" style="width: 100%; padding: 10px;"></div></td></tr>');
			
			getAjaxHtml('admin/personages/get', {game_id: thisId}, function(html) {
				$('#'+thisBlockId).html(html);
				
				// создать персонажа
				$('#'+thisBlockId).find('[gameidaddpersonage]').on(tapEvent, function() {
					popUp({
						title: 'Новый персонаж',
					    width: 400,
					    wrapToClose: false,
					    buttons: [{id: 'gameIdAddPersonage', title: 'Создать'}],
					    closeButton: 'Отмена',
					}, function(gameIdAddPersonageWin) {
						gameIdAddPersonageWin.wait();
						getAjaxHtml('admin/personages/get_form', {game_id: thisId}, function(html) {
							gameIdAddPersonageWin.setData(html, false);
							$('#gameIdAddPersonage').on(tapEvent, function() {
								var nickname = $('.nickname'),
									armor = $('.armor'),
									server = $('.server'),
									stat = true;
								
								if ($(nickname).val() == '') {
									$(nickname).addClass('error');
									stat = false;
								}
								
								if ($(armor).val() == '') {
									$(armor).addClass('error');
									stat = false;
								}
								
								if ($(server).val() == '') {
									$(server).addClass('error');
									stat = false;
								}
								
								if (stat) {
									$.post('/admin/personages/save_form', {game_id: $('.game_id').val(), nick: $(nickname).val(), armor: $(armor).val(), server: $(server).val()}, function(insetId) {
										if (insetId) {
											var html = '';
												html += '<tr>';
												html += 	'<td><div class="field"><input type="text" p_nick value="'+$(nickname).val()+'"></div></td>';
												html += 	'<td>';
												html += 		'<div class="select">';
												html +=				'<select p_armor>';
												html += 				'<option'+($(armor).val() == 'Латы' ? ' selected' : '')+' value="Латы">Латы</option>';
												html += 				'<option'+($(armor).val() == 'Кольчуга' ? ' selected' : '')+' value="Кольчуга">Кольчуга</option>';
												html += 				'<option'+($(armor).val() == 'Кожа' ? ' selected' : '')+' value="Кожа">Кожа</option>';
												html += 				'<option'+($(armor).val() == 'Ткань' ? ' selected' : '')+' value="Ткань">Ткань</option>';
												html += 			'</select>';
												html += 			'<div class="select__caret"></div>';
												html += 		'</div>';
												html += 	'</td>';
												html += 	'<td><div class="field"><input type="text" p_server value="'+$(server).val()+'"></div></td>';
												html += 	'<td><span>Администратор</span></td>';
												html += 	'<td class="center">';
												html += 		'<div class="buttons inline nowrap">';
												html += 			'<button class="small w30px" updategameidpersonage="'+insetId+'" title="Изменить данные персонажа" disabled><i class="fa fa-save"></i></button>\n';
												html +=				'<button class="small w30px remove" untiegameidpersonage="'+insetId+'" title="Отвязать персонажа"><i class="fa fa-user"></i></button>\n';
												html +=				'<button class="small w30px remove" removegameidpersonage="'+insetId+'" title="Удалить персонажа"><i class="fa fa-trash"></i></button>';
												html +=			'</div>';
												html += 	'</td>';
												html += '</tr>';
											
											$('#'+thisBlockId).find('#userPersonagesList').append(html);
											gameIdAddPersonageWin.close();
											notify('Персонаж создан!');
											
										} else {
											notify('Ошибка! Персонаж не создан!', 'error');
										}
									}, 'json');
								}
							});
						}, function() {
							gameIdAddPersonageWin.wait(false);
						});
					});
				});
				
				
				
				
				// Добавить персонажа из заявок
				$('#'+thisBlockId).find('[gameidaddpersonagefromusers]').on(tapEvent, function() {
					popUp({
						title: 'Персонажи из заявок',
					    width: 700,
					    buttons: [{id: 'gameIdAddPersonageFromUsers', title: 'Добавить', 'disabled': 1}],
					    closeButton: 'Отмена',
					}, function(gameIdAddPersonageFromUsersWin) {
						var thisUserId = $(thisRow).find('[name="user_id"]').val() || false;
						getAjaxHtml('admin/personages/get', {from_id: thisUserId, popup: 1}, function(html, stat) {
							if (stat) gameIdAddPersonageFromUsersWin.setData(html, false);
							else gameIdAddPersonageFromUsersWin.setData('<p class="empty center">Нет данных</p>', false);
							
							if ($('#userPersonagesListPopup').find('tr').length > 0) $('#gameIdAddPersonageFromUsers').removeAttrib('disabled');
							
							$('#gameIdAddPersonageFromUsers').on(tapEvent, function() {
								gameIdAddPersonageFromUsersWin.wait();
								var personagesIds = [],
									parsonagesData = [],
									checkedPersonages = $('#userPersonagesListPopup').find('[personagefromuser]:checked');
								
								if (checkedPersonages.length > 0) {
									$(checkedPersonages).each(function() {
										var thisPersonageId = $(this).val(),
											thisRow = $(this).closest('tr'),
											thisNick = $(thisRow).find('.popuppersonagenick').text(),
											thisArmor = $(thisRow).find('.popuppersonagearmor').text(),
											thisServer = $(thisRow).find('.popuppersonageserver').text(),
											thisUserNickname = $(thisRow).find('.popuppersonageusernickname').val() || false,
											thisUserAvatar = $(thisRow).find('.popuppersonageuseravatar').val();
										
										personagesIds.push(thisPersonageId);
										parsonagesData.push({
											id: thisPersonageId,
											nick: thisNick,
											armor: thisArmor,
											server: thisServer,
											user_nickname: thisUserNickname,
											user_avatar: thisUserAvatar
										});
									});
								}
								
								$.post('/admin/game_ids/tie_personages_to_game_id', {game_id: thisId, personages_ids: personagesIds}, function(response) {	
									if (response) {
										var html = '';
										$.each(parsonagesData, function(k, item) {
											html += '<tr>';
											html += 	'<td><div class="field"><input type="text" p_nick value="'+item.nick+'"></div></td>';
											html += 	'<td>';
											html += 		'<div class="select">';
											html +=				'<select p_armor>';
											html += 				'<option'+(item.armor == 'Латы' ? ' selected' : '')+' value="Латы">Латы</option>';
											html += 				'<option'+(item.armor == 'Кольчуга' ? ' selected' : '')+' value="Кольчуга">Кольчуга</option>';
											html += 				'<option'+(item.armor == 'Кожа' ? ' selected' : '')+' value="Кожа">Кожа</option>';
											html += 				'<option'+(item.armor == 'Ткань' ? ' selected' : '')+' value="Ткань">Ткань</option>';
											html += 			'</select>';
											html += 			'<div class="select__caret"></div>';
											html += 		'</div>';
											html += 	'</td>';
											html += 	'<td><div class="field"><input type="text" p_server value="'+item.server+'"></div></td>';
											html += 	'<td>';
											if (item.user_nickname == false) {
												html += '<span>Администратор</span>';
											} else {
												html += '<div class="d-flex align-items-center">';
												html += 	'<div class="usercard d-flex align-items-center">';
												html += 		'<div class="avatar w40px h40px mr-1" style="background-image: url('+item.user_avatar+')" title="'+item.user_nickname+'"></div>';
												html += 		'<span>'+item.user_nickname+'</span>';
												html += 	'</div>';
												html += '</div>';
											}
											html += 	'</td>';
											html += 	'<td class="center">';
											html += 		'<div class="buttons inline nowrap">';
											html += 			'<button class="small w30px" updategameidpersonage="'+item.id+'" title="Изменить данные персонажа" disabled><i class="fa fa-save"></i></button>\n';
											html +=				'<button class="small w30px remove" untiegameidpersonage="'+item.id+'" title="Отвязать персонажа"><i class="fa fa-user"></i></button>\n';
											html +=				'<button class="small w30px remove" removegameidpersonage="'+item.id+'" title="Удалить персонажа"><i class="fa fa-trash"></i></button>';
											html +=			'</div>';
											html += 	'</td>';
											html += '</tr>';
										});
										
										$('#'+thisBlockId).find('#userPersonagesList').append(html);
										gameIdAddPersonageFromUsersWin.close();
										notify('Персонажи успешно привязаны к ID игры!');
									} else {
										notify('Ошибка! Персонажи не привязаны к ID игры!');
										gameIdAddPersonageFromUsersWin.wait(false);
									}
								}, 'json');
								
							});
							
							
							//$('[gameidpersonageaddfromusers]')
							
							
							
						}, function() {
							
						});
					});
				});
				
				
				
				$('#'+thisBlockId).changeInputs(function(selector) {
					$(selector).closest('tr').find('[updategameidpersonage]').removeAttrib('disabled');
				});
				
				
				// изменить данные перонажа
				$('#'+thisBlockId).on(tapEvent, '[updategameidpersonage]', function() {
					let tr = $(this).closest('tr'),
						id = $(this).attr('updategameidpersonage'),
						nick = $(tr).find('[p_nick]').val(),
						armor = $(tr).find('[p_armor]').val(),
						server = $(tr).find('[p_server]').val();
					
					$.post('/admin/personages/update', {id: id, nick: nick, armor: armor, server: server}, function(response) {
						if (response) {
							notify('Данные персонажа успешно обновлены!');
						} else {
							notify('Ошибка! Данные персонажа не обновились!');
						}
						$(tr).removeClass('changed');
						$(tr).find('[updategameidpersonage]').setAttrib('disabled');
					}).fail(function(e) {
						showError(e);
						notify('Системная ошибка!', 'error');
					});
				});
				
				
				
				
				// отвязать перонажа
				$('#'+thisBlockId).on(tapEvent, '[untiegameidpersonage]', function() {
					var thisRow = $(this).closest('tr'),
						thisPersonageId = $(this).attr('untiegameidpersonage');
					popUp({
						title: 'Отвязать персонажа',
					    width: 400,
					    html: '<p>Вы действительно хотите отвязать персонажа?</p>',
					    buttons: [{id: 'untieGameIdPersonage', title: 'Отвязать'}],
					    closeButton: 'Отмена',
					}, function(untieGameIdPersonageWin) {
						$('#untieGameIdPersonage').on(tapEvent, function() {
							untieGameIdPersonageWin.wait();
							$.post('/admin/personages/untie', {id: thisPersonageId}, function(response) {
								if (response) {
									notify('Персонаж успешно отвязан!');
									$(thisRow).remove();
								} else {
									notify('Ошибка! Персонаж не отвязан!', 'error');
								}
								untieGameIdPersonageWin.close();
							}, 'json');
						});
					});
				});
				
				
				// удалить перонажа
				$('#'+thisBlockId).on(tapEvent, '[removegameidpersonage]', function() {
					var thisRow = $(this).closest('tr'),
						thisPersonageId = $(this).attr('removegameidpersonage');
					popUp({
						title: 'Удалить персонажа',
					    width: 400,
					    html: '<p>Вы действительно хотите удалить персонажа?</p>',
					    buttons: [{id: 'removeGameIdPersonage', title: 'Удалить'}],
					    closeButton: 'Отмена',
					}, function(removeGameIdPersonageWin) {
						$('#removeGameIdPersonage').on(tapEvent, function() {
							removeGameIdPersonageWin.wait();
							$.post('/admin/personages/remove', {id: thisPersonageId}, function(response) {
								if (response) {
									notify('Персонаж успешно удален!');
									$(thisRow).remove();
								} else {
									notify('Ошибка! Персонаж не удален!', 'error');
								}
								removeGameIdPersonageWin.close();
							}, 'json');
						});
					});
				});
				
			}, function() {
				
			});
		}
	});
	
});

//--></script>