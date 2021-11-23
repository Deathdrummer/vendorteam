{% if statics %}
	<ul class="usersv2staticslist">
		{% for stId, static in statics %}
			<li>
				<input type="checkbox" id="userstatic{{stId}}" usersv2taticlistitem="{{stId}}"{% if static.checked %} checked{% endif %}>
				<label for="userstatic{{stId}}" class="usersv2staticsitem">
					<div class="usersv2staticsitem__static">
						<img src="{{base_url('public/filemanager/thumbs/'~static.icon)|no_file('public/images/deleted_mini.jpg')}}" class="avatar" alt="{{static.name}}">
						<span>{{static.name}}</span>
					</div>
					
					<span class="usersv2staticsitem__checks">
						<div>
							<input type="checkbox" id="userstaticLider{{stId}}" usersv2taticlider="{{stId}}"{% if static.lider %} checked{% endif %}>
							<label for="userstaticLider{{stId}}"></label>
						</div>
						<div>
							<input type="radio" name="userstaticMain" id="userstaticMain{{stId}}" usersv2taticmain="{{stId}}"{% if static.main %} checked{% endif %}>
							<label for="userstaticMain{{stId}}"></label>
						</div>
					</span>
				</label>
			</li>
		{% endfor %}
	</ul>
{% else %}
	<p class="empty center fz12px">Нет данных</p>
{% endif %}