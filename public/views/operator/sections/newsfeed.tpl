<div class="section" id="newsfeedSection">
	<div class="section__title">
		<h1>Лента новостей</h1>
	</div>
	
	<div class="section__content" id="sectionContent">
		<div>
			<ul class="tabstitles">
				{% for stId, staticName in statics %}
					<li id="static{{stId}}">{{staticName}}</li>
				{% endfor %}
			</ul>
			
			
			
			<div class="tabscontent">
				{% for stId, staticName in statics %}
					<div tabid="static{{stId}}">
						<div class="section__buttons nowidth">
							<button feedmessageadd="{{stId}}" title="Добавить новость"><i class="fa fa-plus mr-1"></i> <span>Добавить новость</span></button>
						</div>
						
						<div class="newsfeeds" id="feedMessagesBlock{{stId}}">
							{% if feed_messages[stId] is defined %}
								{% for message in feed_messages[stId] %}
									<div class="newsfeeds_item newsfeed">
										
										<div class="d-flex justify-content-between align-items-start">
											<div class="newsfeed__title">
												<label>Заголовок</label>
												<input type="text" autocomplete="off" value="{{message.title}}" placeholder="Заголовок поста">
											</div>
											<div class="newsfeed__date">{{message.date|d}} {{message.date|t}}</div>
										</div>
										
										<div class="newsfeed__file">
											<label>Иконка</label>
											<div class="file">
												<div>
													<label filemanager="png|jpg|jpeg">
														<div class="image">
															<img src="{{base_url()}}public/filemanager/{{message.icon}}" alt="{{message.icon|filename}}">
														</div>
													</label>
													<div>
														<span class="image_name">{% if message.icon %}{{message.icon|filename}}{% else %}нет файла{% endif %}</span>
													</div>
												</div>
												<input type="hidden" value="{{message.icon}}" />
											</div>
										</div>
										
										<div class="newsfeed__content">
											<label>Содержание новости</label>
											<textarea editor class="w100" rows="12">{{message.message}}</textarea>
										</div>
										
										<div class="newsfeed__buttons">
											<button updatefeedmessage="{{message.id}}">Обновить</button>
											<button removefeedmessage="{{message.id}}" class="remove">Удалить</button>
										</div>
									</div>
								{% endfor %}
							{% endif %}
						</div>
					</div>
				{% endfor %}
			</div>
		</div>	
	</div>
</div>





<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	
	$('[editor]').on(tapEvent, function() {
		if (!$(this).hasClass('summernote_activated')) {
			initEditors(this);
		}
	});
	
	
	//initEditors($('[tabid]:visible').find('[editor]'));
	
	$('body').off(tapEvent, '[feedmessageadd]').on(tapEvent, '[feedmessageadd]', function() {
		var thisStatic = $(this).attr('feedmessageadd');
		getAjaxHtml('operator/newsfeed_add', {static_id: thisStatic}, function(html) {
			$('#feedMessagesBlock'+thisStatic).prepend(html);
		}, function() {
			initEditors($('[editor][new]'));
		});
	});
	
	$('body').off(tapEvent, '.newsfeed__content').on(tapEvent, '.newsfeed__content', function() {
		$(this).removeClass('error');
	});
	
	
	/*onChangeTabs(function(thisItemTitle, thisItemContent) {
		initEditors($(thisItemContent).find('[editor]'));
	});*/
	
	
	
	
	$('body').off(tapEvent, '[savefeedmessage]').on(tapEvent, '[savefeedmessage]', function() {
		var thisMessStatic = $(this).attr('savefeedmessage'),
			thisBlock = $(this).closest('.newsfeeds_item'),
			thisTitle = $(thisBlock).find('input[type="text"]').val(),
			thisIcon = $(thisBlock).find('input[type="hidden"]').val(),
			thisMessage = $(thisBlock).find('textarea').val(),
			thisDataBlock = $(thisBlock).find('.newsfeed__date'),
			thisButtonsBlock = $(thisBlock).find('.newsfeed__buttons'),
			stat = true,
			cloneToStatics = [];
			
		if ($(this).closest('.list_item').find('.clone_to_statics:checked').length > 0) {
			$(this).closest('.list_item').find('.clone_to_statics:checked').each(function() {
				cloneToStatics.push($(this).val());
			});
		}
		
		if (thisTitle == '') {
			stat = false;
			$(thisBlock).find('input[type="text"]').addClass('error');
		}
		
		if (thisMessage == '<p><br></p>') {
			stat = false;
			notify('Ошибка! Необходимо заполнить содержание новости!', 'error');
			$(thisBlock).find('.newsfeed__content').addClass('error');
		}
		
		if (stat) {
			$.post('/admin/save_feed_message', {static: thisMessStatic, clone_to_statics: cloneToStatics, title: thisTitle, icon: thisIcon, message: thisMessage}, function(data) {
				if (data.id) {
					$(thisButtonsBlock).html('<button updatefeedmessage="'+data.id+'">Обновить</button> <button removefeedmessage="'+data.id+'" class="remove">Удалить</button>');
					$(thisDataBlock).text(data.date);
				}
			}, 'json').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		}	
	});
	
	
	$('body').off(tapEvent, '[updatefeedmessage]').on(tapEvent, '[updatefeedmessage]', function() {
		var thisMessId = $(this).attr('updatefeedmessage'),
			thisTitle = $(this).closest('.newsfeeds_item').find('input[type="text"]').val(),
			thisIcon = $(this).closest('.newsfeeds_item').find('input[type="hidden"]').val(),
			thisMessage = $(this).closest('.newsfeeds_item').find('textarea').val();
		
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
			thisBlock = $(this).closest('.newsfeeds_item');
		
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