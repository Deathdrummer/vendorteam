{% if personages %}
	{% for item in personages %}
		{% if item.approved %}
			<tr>
				<td class="w30">
					<p>{{item.nick}}</p>
				<td>
					<p>{{item.armor}}</p>
				</td>
				<td class="w30">
					<p>{{item.server}}</p>
				</td>
				<td class="center w80px"><i title="Утвержден" class="fa fa-check"></i></td>
			</tr>
		{% else %}
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
					<button update="{{item.id}}" class="popup__button"><i class="fa fa-refresh"></i></button>
					<button remove="{{item.id}}" class="popup__button popup__button_remove"><i class="fa fa-trash"></i></button>
				</td>
			</tr>
		{% endif %}
	{% endfor %}
{% endif %}