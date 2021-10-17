{% if users %}
	<ul class="dropdownlist">
		{% for userId, user in users %}
			<li class="dropdownlist__item" adminshistorysearcheduser="{{userId}}">{{user.nickname}}</li>
		{% endfor %}
	</ul>
{% endif %}