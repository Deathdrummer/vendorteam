{% if classes %}
	<table id="userClasses">
		<thead>
			<tr>
				<td>Статик</td>
				<td>Участн.</td>
				<td>Ментор</td>
			</tr>
		</thead>
		<tbody>
			{% for cls in classes %}
				<tr usersclasseschecks>
					<td>
						{{cls.name}}
					</td>
					<td class="nowidth center">
						<div class="checkblock">
							{% if newset['part'][cls.id] is defined %}
								<input id="class{{cls.id}}part" classpart="{{cls.id}}" type="checkbox"{% if newset['part'][cls.id] %} checked{% endif %} value="{{cls.id}}">
							{% else %}
								<input id="class{{cls.id}}part" classpart="{{cls.id}}" type="checkbox"{% if cls.has %} checked{% endif %} value="{{cls.id}}">
							{% endif %}
							
							<label for="class{{cls.id}}part"></label>
						</div>
					</td>
					<td class="nowidth center">
						<div class="checkblock">
							{% if newset['mentor'][cls.id] is defined %}
								<input id="class{{cls.id}}mentor" classmentor="{{cls.id}}" type="checkbox"{% if newset['mentor'][cls.id] %} checked{% endif %} value="{{cls.id}}">
							{% else %}
								<input id="class{{cls.id}}mentor" classmentor="{{cls.id}}" type="checkbox"{% if cls.mentor %} checked{% endif %} value="{{cls.id}}">
							{% endif %}
							
							<label for="class{{cls.id}}mentor"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}