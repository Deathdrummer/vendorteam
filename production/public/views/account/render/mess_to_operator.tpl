<div class="popup__title">
	<h6>Оператору: {{nickname}}</h6>
</div>
<div class="popup__data">
	<div class="popup__form_item">
		<div class="popup__textarea popup__textarea_long">
			<label class="popup__label" for="operatorFormNickname">{% if type == 'mess' %}Сообщение:{% elseif type == 'complain' %}Жалоба:{% endif %}</label>
			<textarea name="" rows="10" id="messToOperator"></textarea>
		</div>
	</div>
</div>

