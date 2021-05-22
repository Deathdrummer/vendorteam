{% if statics %}
	<input type="hidden" id="countAllUsers" value="{{count_all_users}}">
	<ul>
		{% for stId, static in statics %}
			<li class="usersmanagerstatic" umstatic="{{stId}}">
				<div class="usersmanagerstatic__icon" style="background-image: url('{{base_url('public/filemanager/'~static.icon)}}')"></div>
				<p class="usersmanagerstatic__name">{{static.name}}</p>
				<p class="usersmanagerstatic__count"><span countchoosedusers>0</span>/{{static.count_users}}</p>
			</li>
		{% endfor %}
	</ul>
{% else %}
	<div class="usersmanager__empty">
		<p class="empty center">Нет статиков</p>
	</div>
{% endif %}