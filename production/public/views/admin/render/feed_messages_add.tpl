<div class="list_item">
	<div class="block">
		<title test="hey!!!"></title>
		<div class="item w40">
			<div class="field">
				<label><span>Заголовок</span></label>
				<input type="text" autocomplete="off" value="" placeholder="Заголовок поста">
			</div>
		</div>
		<div class="item">
			<div class="file">
				<label><span>Картинка</span></label>
				<div>
					<label for="" filemanager="png|jpg|jpeg">
						<div class="image">
							<img src="{{base_url('public/images/'~message.icon)}}" alt="{{message.icon|filename}}">
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
				<label><span>Сообщение</span></label>
				<textarea editor="feed{{rand(0,999)}}" rows="12"></textarea>
			</div>
		</div>
		
		<br>
		<h4>Также, клонировать новость в статики:</h4>
		{% for stId, stName in statics %}
			<div class="item inline">
				<label for="cloneToStatic{{stId}}">{{stName}}</label>
				<input id="cloneToStatic{{stId}}" class="clone_to_statics" type="checkbox" value="{{stId}}">
			</div>
		{% endfor %}
			
		
		<div class="buttons ml-0">
			<button savefeedmessage="{{static_id}}">Сохранить</button>
		</div>
	</div>
</div>