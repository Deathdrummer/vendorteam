{% if statics %}
	<table id="userStatics">
		<thead>
			<tr>
				<td>Статик</td>
				<td>Участн.</td>
				<td>Лидер</td>
				<td>Основ.</td>
			</tr>
		</thead>
		<tbody>
			{% for static in statics %}
				<tr userstaticschecks>
					<td>
						{{static.name}}
					</td>
					<td class="nowidth center">
						<div class="checkblock">
							{% if newset['part'][static.id] is defined %}
								<input id="static{{static.id}}part" staticpart="{{static.id}}" type="checkbox"{% if newset['part'][static.id] %} checked{% endif %} value="{{static.id}}">
							{% else %}
								<input id="static{{static.id}}part" staticpart="{{static.id}}" type="checkbox"{% if static.has %} checked{% endif %} value="{{static.id}}">
							{% endif %}
							
							<label for="static{{static.id}}part"></label>
						</div>
					</td>
					<td class="nowidth center">
						<div class="checkblock">
							{% if newset['lider'][static.id] is defined %}
								<input id="static{{static.id}}lider" staticlider="{{static.id}}" type="checkbox"{% if newset['lider'][static.id] %} checked{% endif %} value="{{static.id}}">
							{% else %}
								<input id="static{{static.id}}lider" staticlider="{{static.id}}" type="checkbox"{% if static.lider %} checked{% endif %} value="{{static.id}}">
							{% endif %}
							
							<label for="static{{static.id}}lider"></label>
						</div>
					</td>
					<td class="nowidth center">
						<div class="checkblock">
							{% if newset['main'][static.id] is defined %}
								<input id="static{{static.id}}main" staticmain="{{static.id}}" name="userStatics" type="radio"{% if newset['main'][static.id] %} checked{% endif %}{% if not newset['part'][static.id] %} disabled{% endif %} value="{{static.id}}">
							{% else %}
								<input id="static{{static.id}}main" staticmain="{{static.id}}" name="userStatics" type="radio"{% if static.main %} checked{% endif %}{% if not static.lider and not static.has %} disabled{% endif %} value="{{static.id}}">
							{% endif %}
							
							<label for="static{{static.id}}main"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}