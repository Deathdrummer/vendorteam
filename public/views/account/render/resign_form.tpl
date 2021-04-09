<div class="popup__data">
	<div class="popup__form resign">
		<div class="row">
			<div class="col">
				<div class="popup__form_item">
					<div class="popup__field w-17rem">
						<input type="hidden" id="resignCurrentDate" value="{{current_date}}">
						<label class="popup__label" for="chooseResignDate">Дата заявки:</label>
						<input autocomplete="off" type="text" id="chooseResignDate" name="user_nick" placeholder="Выберите дату" value="{{current_date_format}}">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="popup__form_item">
					<div class="popup__field w-17rem">
						<input type="hidden" id="resignLastDate" value="{{last_date}}">
						<label class="popup__label">Дата последнего рабочего дня:</label>
						<p id="resignLastday" class="resign__lastdate">{{last_date_format}}</p>
					</div>
				</div>
			</div>
		</div>
		
		
		<div class="popup__form_item">
			<div class="popup__textarea popup__textarea_long">
				<label class="popup__label">Причина ухода:</label>
				<textarea name="" id="resignReason" rows="5"></textarea>
			</div>
		</div>
		
		
		<div class="popup__form_item">
			<div class="popup__textarea popup__textarea_long">
				<label class="popup__label">Что бы Вы хотели улучшить:</label>
				<textarea name="" id="resignComment" rows="5"></textarea>
			</div>
		</div>
		
		
		
		<p>{{resign_text|raw}}</p>
		
	</div>
</div>