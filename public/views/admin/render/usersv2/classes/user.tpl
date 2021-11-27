{% if classes %}
	<ul class="usersv2staticslist">
		{% for clId, cls in classes %}
			<li>
				<input type="checkbox" id="userclass{{clId}}" usersv2classeslistitem="{{clId}}"{% if cls.checked %} checked{% endif %}>
				<label for="userclass{{clId}}" class="usersv2staticsitem">
					<div class="usersv2staticsitem__static">
						<span>{{cls.name}}</span>
					</div>
					
					<span class="usersv2staticsitem__checks">
						<div>
							<input type="checkbox" id="usersv2classesMentor{{clId}}" class="mentor" usersv2classesmentor="{{clId}}"{% if cls.mentor %} checked{% endif %}>
							<label for="usersv2classesMentor{{clId}}"></label>
						</div>
					</span>
				</label>
			</li>
		{% endfor %}
	</ul>
{% else %}
	<p class="empty center fz12px">Нет данных</p>
{% endif %}