<form id="operatorDataForm" enctype="multipart/form-data" autocomplete="off">
	<div class="popup__data">
		<div class="changeavatar">
			<div class="popup__form_item">
				<div class="popup__field">
					<label class="popup__label" for="operatorNick">Никнейм:</label>
					<input autocomplete="off" type="text" id="operatorNick" name="operator_nick" placeholder="Ваш никнейм" value="{{nickname}}">
				</div>
			</div>
			<div class="popup__form_item">
				<label for="operatorFormAvatar" class="popup__file">
					<p class="popup__label">Аватарка:</p>
					<div class="icon">
						<img id="operatorAvatarImg" src="{{base_url()}}public/images/{% if avatar %}operators/{{avatar}}?{{time()}}{% else %}none.png{% endif %}" alt="">
						<span id="operatorFilename" class="filename">{% if avatar %}{{avatar}}{% endif %}</span>
					</div>
					<input type="file" id="operatorFormAvatar" name="operator_avatar">
				</label>
			</div>
		</div>
	</div>
</form>