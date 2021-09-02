<div id="miniNewsFeedForm">
	<div class="row mb20px">
		<div class="col-auto w130px">
			<p class="fz14px">Сообщение:</p>
		</div>
		<div class="col">
			<div class="popup__textarea">
				<textarea name="text" rows="2" class="noresize noheight fz14px h52px pt4px pb4px" placeholder="110 - 120 символов" rules="empty">{{text}}</textarea>
			</div>
		</div>
	</div>


	<div class="row mb20px">
		<div class="col-auto w130px">
			<p class="fz14px">Иконка:</p>
		</div>
		<div class="col">
			<div class="popup__file">
				<div>
					<label for="miniNewsFeedIcon" filemanager="images">
						<div class="image">
							{% if icon %}
								{% if icon|filename(2)|is_img_file %}
									<img src="{{base_url('public/filemanager/'~icon|freshfile)|no_file('public/images/deleted.jpg')}}" alt="{{icon}}">
								{% else %}
									<img src="{{base_url('public/images/filetypes/'~icon|filename(2))}}.png" alt="{{icon}}">
								{% endif %}
							{% else %}
								<img src="{{base_url('public/images/none.png')}}" alt="">
							{% endif %}
						</div>
					</label>
					<div>
						<span class="image_name">{% if icon %}{{icon|filename}}{% else %}нет файла{% endif %}</span>
						<button class="remove filemanager_remove" title="Удалить"><i class="fa fa-trash"></i></button>
					</div>
				</div>
				<input type="hidden" name="icon" id="miniNewsFeedIcon" value="{{icon}}" rules="empty" />
			</div>
		</div>
	</div>


	<div class="row">
		<div class="col-auto w130px">
			<p class="fz14px">Статики:</p>
			<div>
				<small class="fz11px d-block mb5px pointer pointer_colored" mininewsfeedstatics="all">Выбрать все</small>
				<small class="fz11px d-block pointer pointer_colored" mininewsfeedstatics="none">Снять выделение</small>
			</div>
		</div>
		<div class="col">
			{% if allstatics %}
				<div class="drow dgutter-5" id="miniNewsFeedStaticsBlock">
					{% for stId, static in allstatics %}
						<div class="dcol-3">
							<div class="chooseblock">
								<input id="miniNewsFeedStatic{{stId}}" type="checkbox" mininewsfedstatic value="{{stId}}"{% if stId in statics %} checked{% endif %}>
								<label for="miniNewsFeedStatic{{stId}}" class="d-flex align-items-center mb5px">
									<img src="{{base_url('public/filemanager/'~static.icon)}}" class="avatar h30px w30px mr5px" alt="{{static.name}}">
									<p class="mb-0 fz11px">{{static.name}}</p>
								</label>
							</div>
						</div>
					{% endfor %}
				</div>
			{% else %}
				<p class="empty">нет статиков</p>
			{% endif %}
			
			<input type="hidden" name="_countstatics" id="miniNewsFormCountStatics" rules="num:1">
		</div>
	</div>
</div>