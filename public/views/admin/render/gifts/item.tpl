<tr>
	{% if not fields or 'title' in fields %}
		<td>
			<div class="popup__field">
				<input type="text" name="title" placeholder="Название..." rules="empty" value="{{gift.title}}" autocomplete="off">
			</div>
		</td>
	{% endif %}
	
	{% if not fields or 'chance' in fields %}
		<td>
			<div class="popup__field">
				<input type="number" name="chance" showrows min="1" rules="empty::введите число" value="{{gift.chance}}" autocomplete="off">
			</div>
		</td>
	{% endif %}
	
	{% if not fields or 'percents' in fields %}
		<td>
			<div class="d-flex align-items-center">
				<div class="popup__field">
					<input type="number" name="percents" showrows min="1" rules="empty::введите число" value="{{gift.percents}}" autocomplete="off">
				</div>
				<small class="ml3px fz14px">%</small>
			</div>
		</td>
	{% endif %}
	
	{% if not fields or 'diapason' in fields %}
		<td>
			<div class="d-flex align-items-center justify-content-between">
				<div class="d-flex align-items-center">
					<small class="mr3px fz14px">от</small>
					<div class="popup__field mr10px w80px">
						<input type="number" name="items_from" min="1" showrows rules="empty::введите число" value="{{gift.items_from}}" autocomplete="off">
					</div>
				</div>
				<div class="d-flex align-items-center">
					<small class="mr3px fz14px">до</small>
					<div class="popup__field w80px">
						<input type="number" name="items_to" min="1" showrows rules="empty::введите число" value="{{gift.items_to}}" autocomplete="off">
					</div>
				</div>
			</div>
		</td>
	{% endif %}
		
	<td>
		<div class="popup__select">
			<select name="action" rules="empty">
				{% if actions %}
					<option disabled selected value="">Выбрать</option>
					{% for list_action, title in actions %}
						<option value="{{list_action}}"{% if list_action == gift.action %} selected{% endif %}>{{title}}</option>
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
			<button class="small w30px" update="{% if gift.id %}{{gift.id}}{% else %}{{id}}{% endif %}"><i class="fa fa-save"></i></button>
			<button class="small remove w30px" remove="{% if gift.id %}{{gift.id}}{% else %}{{id}}{% endif %}"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>