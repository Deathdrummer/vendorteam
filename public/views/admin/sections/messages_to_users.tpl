<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Сообщения участникам</h2>
		<div class="buttons notop">
			<button class="large" id="usersMessagesNewBtn" title="Новое сообщение">Новое сообщение</button>
		</div>
	</div>
	
	<table>
		<thead>
			<tr>
				<td><strong>Сообщение</strong></td>
				<td class="w220px">Дата</td>
				<td class="w140px">Статус прочтения</td>
				<td class="w80px">Операции</td>
			</tr>
		</thead>
		<tbody id="usersMessagesList">
			<tr class="empty">
				<td colspan="4" class="center"><i class="fa fa-spinner fa-pulse fa-fw fz30px"></i></td>
			</tr>
		</tbody>
	</table>
</div>







<script type="text/javascript"><!--

	let codeMap = '<pre class="fz10px" id="codeMapBlock">\
					<p class="fz16px text-left"><span class="select pointer">[id]</span> - ID участника</p>\
					<p class="fz16px text-left"><span class="select pointer">[email]</span> - E-mail</p>\
					<p class="fz16px text-left"><span class="select pointer">[avatar]</span> - Аватар</p>\
					<p class="fz16px text-left"><span class="select pointer">[nickname]</span> - Никнейм</p>\
					<p class="fz16px text-left"><span class="select pointer">[birthday]</span> - День рождения</p>\
					<p class="fz16px text-left"><span class="select pointer">[deposit]</span> - Текущий резерв</p>\
					<p class="fz16px text-left"><span class="select pointer">[deposit_percent]</span> - Процент отчислений в резерв</p>\
					<p class="fz16px text-left"><span class="select pointer">[payment]</span> - Платежные данные</p>\
					<p class="fz16px text-left"><span class="select pointer">[rank]</span> - Звание</p>\
					<p class="fz16px text-left"><span class="select pointer">[reg_date]</span> - Дата регистрации</p>\
					<p class="fz16px text-left"><span class="select pointer">[stage]</span> - Стаж</p>\
					<p class="fz16px text-left"><span class="select pointer">[screenshot]</span> - Скриншот</p>\
					<p class="fz16px text-left"><span class="select pointer">[main_static]</span> - Основной статик</p>\
					<p class="fz16px text-left"><span class="select pointer">[statics]</span> - Список статиков</p></pre>';


	
	(getMessages = function () {
		getAjaxHtml('messages/admin/list', function(html, stat) {
			if (!stat) $('#usersMessagesList').html('<tr class="empty"><td colspan="4" class="center"><p class="empty center">Нет сообщений</p></td></tr>');
			else $('#usersMessagesList').html(html);
			
			$('[messtousersshow]').on(tapEvent, function() {
				let id = $(this).attr('messtousersshow');
					
				popUp({
					title: 'Редактировать сообщение',
				    width: 900,
				    buttons: [{id: 'messToUserUpdateBtn', title: 'Обновить'}],
				    closePos: 'left',
				    closeButton: 'Закрыть',
				}, function(messToUserWin) {
					messToUserWin.setData('messages/admin/form', {id: id}, function() {
						messToUserWin.wait();
						initEditors('#usersMessage', function() {
							messToUserWin.wait(false);
						});
						
						$('#codeMap').on(tapEvent, function() {
							messToUserWin.dialog(codeMap, '', 'Закрыть');
							$('#codeMapBlock').find('.select').on(tapEvent, function() {
								let str = $(this).text();
								copyStringToClipboard(str);
								notify('Шаблон скопирован');
								messToUserWin.dialog(false);
							});
						});
						
						$('[usersmessagesuserremove]').on(tapEvent, function() {
							let userBlock = $(this).closest('[usersmessagesuserblock]'),
								staticNlock = $(this).closest('[usersmessagesstaticcontainer]');
							
							$(userBlock).remove();
							
							if ($(staticNlock).find('[usersmessagesuserblock]').length == 0) {
								$(staticNlock).remove();
							}
							notify('Участник удален!');
						});
						
						$('#messToUserUpdateBtn').on(tapEvent, function() {
							let message = $('#usersMessage').summernote('code'),
								users = $('#usersFormBlock').find('[messuser]');
							message = message.trim().replace('<p><br></p>', '');
							
							$('#usersMessageHidden').val(message);
							
							if (!message) {
								$('.note-editor').addClass('note-editor_error');
								
								$('.note-editor_error').on(tapEvent, function() {
									$(this).removeClass('note-editor_error');
								});
							}
							
							if (users.length) {
								$('#usersMessageForm').formSubmit({
									url: 'messages/admin/update',
									fields: {id: id, message: message},
									formError: function(errors) {
										messToUserWin.wait(false);
									},
									before: function() {
										messToUserWin.wait();
									},
									success: function() {
										getMessages();
										messToUserWin.close();
									},
									error: function() {
										messToUserWin.wait(false);
									}
								});
							} else {
								notify('Ошибка! Должен быть хотя бы один участник с непрочитанным статусом!', 'error');
								$('#messToUserUpdateBtn').setAttrib('disabled');
							} 
						});
						
					});
				});
			});
			
			
			
			$('[messtousersremove]').on(tapEvent, function() {
				let id = $(this).attr('messtousersremove'),
					row = $(this).closest('tr')
					countRows = $(row).siblings('tr').length;
					
				popUp({
					title: 'Удалить сообщение',
				    width: 400,
				    html: '<p class="info center fz16px">Вы действительно хотите удалить сообщение?</p>',
				    buttons: [{id: 'messToUsersRemoveBtn', title: 'Удалить'}],
				    closePos: 'left',
				    closeButton: 'Отмена'
				}, function(messToUsersRemoveWin) {
					$('#messToUsersRemoveBtn').on(tapEvent, function() {
						messToUsersRemoveWin.wait();
						$.post('messages/admin/remove', {id: id}, function(response) {
							if (response) {
								if (countRows == 0) {
									$(row).replaceWith('<tr class="empty"><td colspan="4" class="center"><p class="empty center">Нет сообщений</p></td></tr>');
								} else {
									$(row).remove();
								}
								notify('Сообщение удалено!');
								messToUsersRemoveWin.close();
							} else {
								messToUsersRemoveWin.wait(false);
							}
						}).fail(function(e) {
							showError(e);
							notify('Системная ошибка!', 'error');
						});
					});
				});
			});
			
			
			
		}, function() {});
	})();
	
	
	
	
	$('#usersMessagesNewBtn').on(tapEvent, function() {
		usersManager({
			title: 'Выбрать участников',
			choosedStatic: false, // последний выбранный статик
			choosedUsers: false, // выбранные участники: объект [{user:..., static:..., ...}] или функция с коллбэком, в которые передаются данные: [{user:..., static:..., ...}] 
			chooseType: 'multiple', // multiple Тип выборки одиночный или множественный
			returnFields: 'id nickname avatar static', // при выборе участников какие поля вывести
			onChoose: function(users, uMWin) {
				uMWin.wait();
				uMWin.setData('messages/admin/form', {users: users}, function() {
					uMWin.setTitle('Создать сообщение');
					uMWin.setButtons([{id: 'usersMessagesAddBtn', title: 'Создать'}], 'Закрыть');
					
					initEditors('#usersMessage', function() {
						uMWin.wait(false);
					});
					
					$('[usersmessagesuserremove]').on(tapEvent, function() {
						let userBlock = $(this).closest('[usersmessagesuserblock]'),
							staticNlock = $(this).closest('[usersmessagesstaticcontainer]');
						
						$(userBlock).remove();
						
						if ($(staticNlock).find('[usersmessagesuserblock]').length == 0) {
							$(staticNlock).remove();
						}
						notify('Участник удален!');
					});
					
					$('#codeMap').on(tapEvent, function() {
						uMWin.dialog(codeMap, '', 'Закрыть');
						$('#codeMapBlock').find('.select').on(tapEvent, function() {
							let str = $(this).text();
							copyStringToClipboard(str);
							notify('Шаблон скопирован');
							uMWin.dialog(false);
						});
					});
					
				
					$('#usersMessagesAddBtn').on(tapEvent, function() {
						let title = $('#usersMessageTitle').val(),
							message = $('#usersMessage').summernote('code'),
							users = $('#usersFormBlock').find('[messuser]');
							stat = true;
						
						message = message.trim().replace('<p><br></p>', '');
						
						if (!message) {
							$('.note-editor').addClass('note-editor_error');
							
							$('.note-editor_error').on(tapEvent, function() {
								$(this).removeClass('note-editor_error');
							});
							stat = false;
						}
						
						if (!title) {
							$('#usersMessageTitle').errorLabel('Ошибка! Поле не может быть пустым!');
							stat = false;
						}
						
						if (users.length == 0) {
							notify('Ошибка! Необходимо добавить хотя бы одного участника!', 'error');
							$('#usersMessagesAddBtn').setAttrib('disabled');
							stat = false;
						}
						 
						if (stat) {
							uMWin.wait();
							$('#usersMessageForm').formSubmit({
								url: 'messages/admin/add',
								fields: {title: title, message: message},
								returnFields: function(fields) {
									let usersIds = [];
									$.each(fields, function(k, item) {
										if (item.name == 'users[]') usersIds.push(item.value);
									});
									socket.emit('usersmessages:send', usersIds);
								},
								formError: function(errors) {
									uMWin.wait(false);
								},
								before: function() {
									uMWin.wait();
								},
								success: function() {
									uMWin.close();
									getMessages();
									notify('Сообщение успешно отправлено!');
								},
								error: function() {
									uMWin.wait(false);
								}
							});
						}
					});
					
					
					
					
				});
				
				
				
				
			}
		});
	});
	
	
	
	
	
	
	
	
	
	
		
	
	
	
	
//--></script>