{% if statics %}
	<table>
		<thead>
			<tr>
				<td>Статик</td>
				<td title="Выбрать">Выб.</td>
			</tr>
		</thead>
		<tbody>
			{% for stId, stName in statics %}
				<tr>
					<td>{{stName}}</td>
					<td class="nowidth center">
						<div class="checkblock">
							<input id="{{stId}}" type="checkbox"{% if stId in has_statics %} checked{% endif %}>
							<label for="{{stId}}"></label>
						</div>
					</td>
				</tr>
			{% endfor %}	
		</tbody>
	</table>
{% endif %}