{% if users %}
	<ul>
		{% for user in users %}
			<li chooseusertogameid="{{user.id}}"{% if user.tied %} class="gray" title="Привязан к другому аккаунту"{% endif %}>
				<p class="nickname">{{user.nickname}}</p>
				<input type="hidden" class="avatar" value="{{user.avatar}}">
				<div class="static">
					{% if user.static_icon %}
						<div class="image"><img src="{{base_url()}}public/filemanager/{{user.static_icon}}" alt=""></div>
					{% else %}
						<div class="image"><img src="{{base_url()}}public/images/deleted_mini.jpg" alt=""></div>
					{% endif %}
					<span>{{user.static_name}}</span>
				</div>
			</li>
		{% endfor %}
	</ul>
{% endif %}