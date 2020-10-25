{% if access %}
	<table>
		<thead>
			<tr>
				<td>Тип доступа</td>
				<td title="Выбрать">Выб.</td>
			</tr>
		</thead>
		<tbody>
			{% for id, item in access %}
				<tr>
					<td title="{{item.desc}}">{{item.title}}</td>
					<td class="nowidth center">
						<div class="checkblock">
							<input id="{{id}}" type="checkbox"{% if id in has_access %} checked{% endif %}>
							<label for="{{id}}"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}