<tr>
	<td class="w30">
		<div class="popup__field">
			<input type="text" name="nick" value="{{item.nick}}">
		</div>
	</td>
	<td>
		<div class="popup__select popup__select_long">
			<select name="armor">
				<option{% if item.armor == 'Латы' %} selected{% endif %} value="Латы">Латы</option>
				<option{% if item.armor == 'Кольчуга' %} selected{% endif %} value="Кольчуга">Кольчуга</option>
				<option{% if item.armor == 'Кожа' %} selected{% endif %} value="Кожа">Кожа</option>
				<option{% if item.armor == 'Ткань' %} selected{% endif %} value="Ткань">Ткань</option>
			</select>
		</div>
	</td>
	<td class="w30">
		<div class="popup__field">
			<input type="text" name="server" value="{{item.server}}">
		</div>
	</td>
	<td class="nowrap w80px">
		<button save class="popup__button"><i class="fa fa-save"></i></button>
		<button remove class="popup__button popup__button_remove"><i class="fa fa-ban"></i></button>
	</td>
</tr>