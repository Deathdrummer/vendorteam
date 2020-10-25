<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Лента новостей</h2>
	</div>
	
	
	<ul class="tabstitles">
		{% for stId, staticName in statics %}
			<li id="static{{stId}}">{{staticName}}</li>
		{% endfor %}
	</ul>
	
	
	
	<div class="tabscontent">
		{% for stId, staticName in statics %}
			<div tabid="static{{stId}}">
				
				<h3>{{staticName}}</h3>
						
				<fieldset>
					<legend>Панель управления</legend>
					<div class="buttons">
						<button feedmessageadd="{{stId}}">Добавить новость</button>
					</div>
				</fieldset>
				
				
				
				<fieldset>
					<legend>Список новостей</legend>
					<div class="list" id="feedMessagesBlock{{stId}}">
						{% if feed_messages[stId] is defined %}
							{% for message in feed_messages[stId] %}
								<div class="list_item">
									<div class="block">
										<title>{{message.date|d}} {{message.date|t}}</title>
										
										<div class="item w40">
											<div class="field">
												<label><span>Заголовок</span></label>
												<input type="text" autocomplete="off" value="{{message.title}}" placeholder="Заголовок поста">
											</div>
										</div>
										<div class="item">
											<div class="file">
												<label><span>Картинка</span></label>
												<div>
													<label for="" filemanager="png|jpg|jpeg">
														<div class="image">
															<img src="{{base_url('public/filemanager/'~message.icon)}}" alt="{{message.icon|filename}}">
														</div>
													</label>
													<div>
														<span class="image_name">{% if message.icon %}{{message.icon|filename}}{% else %}нет файла{% endif %}</span>
													</div>
												</div>
												<input type="hidden" value="{{message.icon}}" />
											</div>
										</div>
										<div class="item w60">
											<div class="textarea">
												<label><span>Содержание новости</span></label>
												<textarea editor="feed{{message.date}}" rows="12">{{message.message}}</textarea>
											</div>
										</div>
										
										<div class="buttons ml-0">
											<button updatefeedmessage="{{message.id}}">Обновить</button>
											<button removefeedmessage="{{message.id}}" class="remove">Удалить</button>
										</div>
									</div>
								</div>
							{% endfor %}
						{% else %}
							<p class="empty">Нет данных</p>
						{% endif %}
					</div>
				</fieldset>
			</div>
		{% endfor %}
	</div>
	
</div>





<script type="text/javascript"><!--
$(document).ready(function() {
	
	$('[feedmessageadd]').on(tapEvent, function() {
		var thisStatic = $(this).attr('feedmessageadd');
		getAjaxHtml('admin/feed_message_add', {static_id: thisStatic}, function(html) {
			$('#feedMessagesBlock'+thisStatic).prepend(html);
			initEditors($('#feedMessagesBlock'+thisStatic).find('[editor]'));
		}, function() {
			
		});
	});
	
	
	
	$('body').off(tapEvent, '[savefeedmessage]').on(tapEvent, '[savefeedmessage]', function() {
		var thisMessStatic = $(this).attr('savefeedmessage')
			thisTitle = $(this).closest('.list_item').find('input[type="text"]').val(),
			thisIcon = $(this).closest('.list_item').find('input[type="hidden"]').val(),
			thisMessage = $(this).closest('.list_item').find('textarea').val(),
			thisDataBlock = $(this).closest('.list_item').find('title'),
			thisButtonsBlock = $(this).closest('.list_item').find('.buttons'),
			cloneToStatics = [];
			
		if ($(this).closest('.list_item').find('.clone_to_statics:checked').length > 0) {
			$(this).closest('.list_item').find('.clone_to_statics:checked').each(function() {
				cloneToStatics.push($(this).val());
			});
		}
		
		$.post('/admin/save_feed_message', {static: thisMessStatic, clone_to_statics: cloneToStatics, title: thisTitle, icon: thisIcon, message: thisMessage}, function(data) {
			if (data.id) {
				$(thisButtonsBlock).html('<button updatefeedmessage="'+data.id+'">Обновить</button> \
					<button removefeedmessage="'+data.id+'" class="remove">Удалить</button>');
				$(thisDataBlock).text(data.date);
			}
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	$('body').off(tapEvent, '[updatefeedmessage]').on(tapEvent, '[updatefeedmessage]', function() {
		var thisMessId = $(this).attr('updatefeedmessage'),
			thisTitle = $(this).closest('.list_item').find('input[type="text"]').val(),
			thisIcon = $(this).closest('.list_item').find('input[type="hidden"]').val(),
			thisMessage = $(this).closest('.list_item').find('textarea').val();
		
		$.post('/admin/update_feed_message', {id: thisMessId, title: thisTitle, icon: thisIcon, message: thisMessage}, function(response) {
			if (response) {
				notify('Новость обновлена!');
			}
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	$('body').off(tapEvent, '[removefeedmessage]').on(tapEvent, '[removefeedmessage]', function() {
		var thisMessId = $(this).attr('removefeedmessage'),
			thisBlock = $(this).closest('.list_item');
		
		popUp({
			title: 'Удалить новость?',
		    width: 500,
		    buttons: [{id: 'removeConfirm'+thisMessId, title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(removeWin) {
			$('#removeConfirm'+thisMessId).on(tapEvent, function() {
				$.post('/admin/remove_feed_message', {id: thisMessId}, function(response) {
					if (response) {
						$(thisBlock).remove();
						notify('Новость удаена!');
						removeWin.close();
					}
				}, 'json').fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
					removeWin.close();
				});
			});
		});	
	});
});
//--></script>