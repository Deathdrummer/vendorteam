{% if report_statics %}
	<table>
		{% for id, name in report_statics %}
			<tr>
				<td><label for="static{{id}}">{{name}}</label></td>
				<td class="w30 nowrap">
					<div class="number">
						<input type="text" min="0" step="1000" id="static{{id}}" autocomplete="off" static="{{id}}" value="{% if set_cash[id] %}{{set_cash[id]}}{% else %}0{% endif %}">
						<span> руб.</span>
					</div>
				</td>
			</tr>
		{% endfor %}
	</table>
{% endif %}