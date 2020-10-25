{% if users %}
	<ul>
		{% for user in users %}
			<li chooseusertopaymentrequesttemp="{{user.id}}"{% if user.choosed %} class="choosed"{% endif %}>
				<p class="nickname">{{user.nickname}}</p>
				<input type="hidden" class="avatar" value="{{user.avatar}}">
				<div class="static">
					{% if user.static_icon %}
						<div class="image"><img src="{{base_url('public/filemanager/'~user.static_icon)}}" alt="{{user.static_name}}"></div>
					{% else %}
						<div class="image"><img src="{{base_url('public/images/deleted_mini.jpg')}}" alt="{{user.static_name}}"></div>
					{% endif %}
					<span>{{user.static_name}}</span>
				</div>
			</li>
		{% endfor %}
	</ul>
{% endif %}