<tr>
	<td class="w30">
		<div class="popup__field">
			<input type="text" name="nick" value="{{nick}}">
		</div>
	</td>
	<td>
		<div class="popup__select popup__select_long">
			<select name="armor" >
				<option{% if armor == 'Латы' %} selected{% endif %} value="Латы">Латы</option>
				<option{% if armor == 'Кольчуга' %} selected{% endif %} value="Кольчуга">Кольчуга</option>
				<option{% if armor == 'Кожа' %} selected{% endif %} value="Кожа">Кожа</option>
				<option{% if armor == 'Ткань' %} selected{% endif %} value="Ткань">Ткань</option>
			</select>
		</div>
	</td>
	<td class="w30">
		<div class="popup__field">
			<input type="text" name="server" value="{{server}}">
		</div>
	</td>
	<td class="w80px nowrap">
		<button update="{{id}}" class="popup__button"><i class="fa fa-refresh"></i></button>
		<button remove="{{id}}" class="popup__button popup__button_remove"><i class="fa fa-trash"></i></button>
	</td>
</tr>