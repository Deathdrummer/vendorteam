{% if statics %}
	{% for stId, static in statics %}
		<li class="usersv2staticstabs__item{% if current_static == stId %} usersv2staticstabs__item_active{% endif %}" usersv2tabsstatic="{{stId}}">
			<div><img src="{{base_url('public/filemanager/thumbs/'~static.icon)|no_file('public/images/deleted_mini.jpg')}}" alt="{{static.name}}" class="avatar"></div>
			<strong>{{static.name}}</strong>
		</li>
	{% endfor %}
{% else %}
	<li class="usersv2staticstabs__item usersv2staticstabs__item_static"><p class="empty center fz12px">Все участники</p></li>
{% endif %}