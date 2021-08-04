<tr>
	<td>
		<div class="popup__field">
			<input type="text" name="title" placeholder="Название..." rules="empty" value="{{title}}" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="popup__field">
			<input type="number" name="chance" showrows min="1" rules="empty::введите число" value="{{chance}}" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="d-flex align-items-center">
			<div class="popup__field">
				<input type="number" name="percents" showrows min="1" rules="empty::введите число" value="{{percents}}" autocomplete="off">
			</div>
			<small class="ml3px fz14px">%</small>
		</div>
	</td>
	<td>
		<div class="d-flex align-items-center justify-content-between">
			<div class="d-flex align-items-center">
				<small class="mr3px fz14px">от</small>
				<div class="popup__field mr10px w80px">
					<input type="number" name="items_from" min="1" showrows rules="empty::введите число" value="{{items_from}}" autocomplete="off">
				</div>
			</div>
			<div class="d-flex align-items-center">
				<small class="mr3px fz14px">до</small>
				<div class="popup__field w80px">
					<input type="number" name="items_to" min="1" showrows rules="empty::введите число" value="{{items_to}}" autocomplete="off">
				</div>
			</div>
		</div>
	</td>
	<td>
		<div class="popup__select">
			<select name="action" rules="empty">
				{% if actions %}
					<option disabled selected value="">Выбрать</option>
					{% for list_action, title in actions %}
						<option value="{{list_action}}"{% if list_action == action %} selected{% endif %}>{{title}}</option>
					{% endfor %}
				{% else %}
					<option value="">Нет данных</option>
				{% endif %}
			</select>
			<div class="select__caret"></div>
		</div>
	</td>
	<td class="center">
		<div class="buttons">
			<button class="small w30px" update="{{id}}"><i class="fa fa-save"></i></button>
			<button class="small remove w30px" remove="{{id}}"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>