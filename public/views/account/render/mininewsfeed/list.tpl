<div class="mininews noselect">
	{% if mini_newsfeed %}
		{% for newsitem in mini_newsfeed %}
			<div class="mininewsitem">
				<div class="mininewsitem__icon">
					{% if newsitem.type in [1, 2] %} {# если ДР или присвоение звания #}
						<img src="{{base_url('public/images/users/mini/'~newsitem.icon)|no_file('public/images/user_mini.jpg')}}" alt="" class="avatar">
					{% else %}
						<img src="{{base_url('public/filemanager/'~newsitem.icon)|no_file('public/images/deleted_mini.jpg')}}" alt="" class="avatar">
					{% endif %}
				</div>
				<div class="mininewsitem__content">
					<p class="format">{{newsitem.text}}</p>
				</div>
				<div class="mininewsitem__date"><small>{{newsitem.date|d(true)}}</small></div>
			</div>	
		{% endfor %}
	{% else %}
		<p class="empty fz12px">Нет событий</p>
	{% endif %}
</div>	