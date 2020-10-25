<div class="newsfeeds_item newsfeed">									
	<div class="d-flex justify-content-between align-items-start">
		<div class="newsfeed__title">
			<label>Заголовок</label>
			<input type="text" autocomplete="off" value="" placeholder="Заголовок поста">
		</div>
		<div class="newsfeed__date"></div>
	</div>
	
	<div class="newsfeed__file">
		<label>Иконка</label>
		<div class="file">
			<div>
				<label filemanager="png|jpg|jpeg">
					<div class="image">
						<img src="{{base_url()}}public//images/none.png" alt="Нет картинки">
					</div>
				</label>
				<div>
					<span class="image_name">Нет файла</span>
				</div>
			</div>
			<input type="hidden" value="" />
		</div>
	</div>
	
	<div class="newsfeed__content">
		<label><span>Содержание новости</span></label>
		<textarea editor rows="12"></textarea>
	</div>
	
	<div class="newsfeed__buttons">
		<button savefeedmessage="{{static_id}}">Сохранить</button>
	</div>
</div>