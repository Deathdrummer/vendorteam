<form id="userDataForm" enctype="multipart/form-data" autocomplete="off">
	<div class="popup__data">
		<div class="changeavatar">
			<div class="popup__form_item">
				<div class="popup__field">
					<label class="popup__label" for="updateUserNick">Никнейм:</label>
					<input autocomplete="off" type="text" id="updateUserNick" name="user_nick" placeholder="Ваш никнейм" value="{{user_nickname}}">
				</div>	
			</div>
			<div class="popup__form_item">
				<label for="updateUserAvatar" class="popup__file">
					<p class="popup__label">Аватарка:</p>
					<div class="icon">
						<img id="userAvatarImg" src="{{base_url()}}public/images/{% if user_avatar %}users/{{user_avatar}}?{{time()}}{% else %}none.png{% endif %}" alt="">
						{% if user_avatar %}<span id="userFilename" class="filename">{{user_avatar}}</span>{% endif %}
					</div>
					<input type="file" id="updateUserAvatar" name="user_avatar">
				</label>
			</div>
			<div class="popup__form_item">
				<p>{{new_user_popup_text_setting}}</p>
			</div>
			{% if lider %}
				<div class="popup__form_item">
					<p class="popup__label">Цвет:</p>
					
					<input type="hidden" name="user_color" value="{{user_color}}">
					
					<div class="popup__color">
						<div id="chooseColor" {% if user_color %} style="background-color: {{user_color}}"{% endif %}></div>
					</div>
				</div>
			{% endif %}
		</div>
	</div>
</form>