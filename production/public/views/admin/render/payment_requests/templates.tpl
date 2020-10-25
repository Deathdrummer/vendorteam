{% if templates %}
	{% for item in templates  %}
		<tr>
			<td>
				<div class="popup__field">
					<input type="text" name="name" value="{{item.name}}">
				</div>
			</td>
			<td>
				<div class="buttons">
					<button paymentrequestseditlist="{{item.id}}" title="Редактировать список"><i class="fa fa-newspaper-o"></i></button>
				</div>
			</td>
			<td>
				<div class="buttons">
					<button update="{{item.id}}"><i class="fa fa-refresh"></i></button>
					<button remove="{{item.id}}" class="remove"><i class="fa fa-trash"></i></button>
				</div>
			</td>
		</tr>
	{% endfor %}
{% endif %}