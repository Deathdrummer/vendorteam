<div class="popup__form">
	<div class="popup__form_item">
		<div><label for="">Ник</label></div>
		<div>
			<div class="field">
				<input type="text" class="nickname">
				<input type="hidden" value="{{game_id}}" class="game_id">
			</div>
		</div>
	</div>
	
	<div class="popup__form_item">
		<div><label for="">Тип брони</label></div>
		<div>
			<div class="select">
				<select class="armor">
					<option value="">-</option>
					<option value="Латы">Латы</option>
					<option value="Кольчуга">Кольчуга</option>
					<option value="Кожа">Кожа</option>
					<option value="Ткань">Ткань</option>
				</select>
				<div class="select__caret"></div>
			</div>
		</div>
	</div>
	
	<div class="popup__form_item">
		<div><label for="">Сервер</label></div>
		<div>
			<div class="field">
				<input type="text" class="server">
			</div>
		</div>
	</div>
</div>