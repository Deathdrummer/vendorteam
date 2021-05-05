{% if users %}
	<div class="drow dgutter-4">
		{% for user in users %}
			<div class="dcol-6">
				<div class="usersmanageruser{% if user.choosed %} choosed choosed_{{choose_type}}{% endif %}" umuser="{{user.static}}|{{user.id}}"{% if choose_type == 'single' %} single title="Уже выбран"{% endif %}>
					<div class="usersmanageruser__avatar" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user.jpg')}}');"></div>
					<p class="usersmanageruser__nickname">{{user.nickname}}</p>
				</div>
			</div>
		{% endfor %}
	</div>
{% else %}
	<div class="usersmanager__empty">
		<p class="empty center">Нет участников</p>
	</div>
{% endif %}