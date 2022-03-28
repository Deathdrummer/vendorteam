<div class="popup__data">
	{% if statics %}
		<table>
			{% for id, name in statics %}
				<tr>
					<td><label class="popup__label" for="static{{id}}">{{name}}</label></td>
					<td class="w30 nowrap right">
						<div class="popup__field">
							<input 
								type="number"
								min="0"
								step="1000"
								id="static{{id}}"
								autocomplete="off"
								static="{{id}}"
								value="{% if set_cash[id] %}{{set_cash[id]}}{% else %}0{% endif %}"
								placeholder="{{currency}}">
						</div>	
					</td>
				</tr>
			{% endfor %}
		</table>
	{% endif %}
</div>