<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Образование</h2>
		<div class="buttons notop" id="{{id}}SaveBlock">
			<button class="large" id="{{id}}Save" title="Сохранить"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	<fieldset>
		<legend>Разделы</legend>
		
		
		<div class="buttons">
			<button id="guidesNewChapter">Создать раздел</button>
		</div>
		
		<div class="guides">
			<ul>
				{% for first in chapters %}
					<li>
						<span>
							<strong editchapter="{{first.id}}" title="Редактировать">{{first.title}}</strong>
							<sup deletechapter="{{first.id}}" title="Удалить"><i class="fa fa-trash"></i></sup>
						</span>
							
						{% if first.children %}
							<ul>
								{% for second in first.children %}
									<li>
										<span>
											<strong editchapter="{{second.id}}" title="Редактировать">{{second.title}}</strong>
											<sup deletechapter="{{second.id}}" title="Удалить"><i class="fa fa-trash"></i></sup>
										</span>
										
										{% if second.children %}
											<ul>
												{% for third in second.children %}
													<li>
														<span>
															<strong editchapter="{{third.id}}" title="Редактировать">{{third.title}}</strong>
															<sup deletechapter="{{third.id}}" title="Удалить"><i class="fa fa-trash"></i></v>
														</span>
														
														{% if third.children %}
															<ul>
																{% for forth in third.children %}
																	<li>
																		<span>
																			<strong editchapter="{{forth.id}}" title="Редактировать">{{forth.title}}</strong>
																			<sup deletechapter="{{forth.id}}" title="Удалить"><i class="fa fa-trash"></i></sup>
																		</span>
																	</li>
																{% endfor %}
															</ul>
														{% endif %}
													</li>
												{% endfor %}
											</ul>	
										{% endif %}
									</li>
								{% endfor %}
							</ul>
						{% endif %}
					</li>
				{% endfor %}
			</ul>
		</div>
		
	</fieldset>
</div>







<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	$('body').off(tapEvent, '#guidesNewChapter').on(tapEvent, '#guidesNewChapter', function() {
		popUp({
			title: 'Новый раздел',
		    width: 1300,
		    wrapToClose: false,
		    buttons: [{id: 'guidesAddChapter', title: 'Добавить'}],
		    closeButton: 'Отмена',
		}, function(newChapterWin) {
			newChapterWin.wait();
			getAjaxHtml('admin/guide_chapters_new', {}, function(html) {
				newChapterWin.setData(html, false);
				
				initEditors($('.popup__content').find('[editor]'));
				
				$('#guidesAddChapter').on(tapEvent, function() {
					var f = new FormData($('#chapterForm')[0]);
					$.ajax({
						type: 'POST',
						url: '/admin/guide_chapter_save',
						dataType: 'json',
						cache: false,
						contentType: false,
						processData: false,
						data: f,
						success: function(response) {
							if (response) {
								newChapterWin.close();
								renderSection();
							}
						},
						error: function(e, status) {
							notify('Системная ошибка отправки данных!', 'error');
							showError(e);
						},
						complete: function() {
							newChapterWin.wait(false);
						}
					});
				});
				
			}, function() {
				newChapterWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	$('body').off(tapEvent, '[editchapter]').on(tapEvent, '[editchapter]', function() {
		var id = $(this).attr('editchapter');
		
		popUp({
			title: 'Редактировать раздел',
		    width: 1300,
		    wrapToClose: false,
		    buttons: [{id: 'guidesUpdateChapter', title: 'Обновить'}],
		    closeButton: 'Отмена',
		}, function(newChapterWin) {
			newChapterWin.wait();
			getAjaxHtml('admin/guide_chapters_edit', {id: id}, function(html) {
				
				newChapterWin.setData(html, false);
				initEditors($('.popup__content').find('[editor]'));
				
				$('#guidesUpdateChapter').on(tapEvent, function() {
					var f = new FormData($('#chapterForm')[0]);
					f.append('update', 1);
					$.ajax({
						type: 'POST',
						url: '/admin/guide_chapter_save',
						dataType: 'json',
						cache: false,
						contentType: false,
						processData: false,
						data: f,
						success: function(response) {
							if (response) {
								newChapterWin.close();
								renderSection();
							}
						},
						error: function(e, status) {
							notify('Системная ошибка отправки данных!', 'error');
							showError(e);
						},
						complete: function() {
							newChapterWin.wait(false);
						}
					});
				});
				
			}, function() {
				newChapterWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	$('body').off(tapEvent, '[deletechapter]').on(tapEvent, '[deletechapter]', function() {
		var id = $(this).attr('deletechapter');
		popUp({
			title: 'Удалить раздел',
		    width: 500,
		    height: false,
		    html: '<p class="center">Вы действительно хотите удалить раздел?</p>',
		    buttons: [{id: 'deleteChapter', title: 'Удалить'}],
		    closeButton: 'Отмена',
		}, function(deleteChapterWin) {
			
			$('#deleteChapter').on(tapEvent, function() {
				deleteChapterWin.wait();
				
				$.post('/admin/guide_chapter_delete', {id: id}, function(response) {
					if (response) {
						notify('Раздел успешно удален!');
						deleteChapterWin.close();
						renderSection();
					} else {
						deleteChapterWin.wait(false);
						notify('Ошибка удаления раздела!', 'error');
					}
				}, 'json').fail(function(e) {
					notify('Системная ошибка!', 'error');
					showError(e);
				});
			});
			
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	$('body').off('change', '#guidesChooseChapter').on('change', '#guidesChooseChapter', function() {
		var thisChapterId = $(this).val();
		getAjaxHtml('admin/get_guide_chapter', {id: thisChapterId}, function(html) {
			$('#ChoosedChapterContent').html(html);
			initEditors();
		});
	});
	
	
	
	$('body').off(tapEvent, '#guideChapterContentSave').on(tapEvent, '#guideChapterContentSave', function() {
		var f = new FormData($('#guideChapterEditForm')[0]);
		$.ajax({
			type: 'POST',
			url: '/admin/guide_chapter_content_save',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: f,
			success: function(response) {
				if (response) {
					notify('Сохранено!');
				}
			},
			error: function(e, status) {
				notify('Системная ошибка отправки данных!', 'error');
				showError(e);
			}
		});
	});
	
	
	
	
});
//--></script>