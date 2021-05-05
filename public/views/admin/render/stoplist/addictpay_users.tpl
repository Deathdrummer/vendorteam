{% if users %}
	{% for user in users %}
		<tr>
			<td>
				<div class="d-flex align-items-center">
					<div class="avatar mini mr-1" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}');"></div>
					<p>{{user.nickname}}</p>
				</div>	
			</td>
			<td>
				<div class="d-flex align-items-center">
					<div class="avatar mini mr-1" style="background-image: url('{{base_url('public/filemanager/'~user.static_icon)|no_file('public/images/deleted_mini.jpg')}}');"></div>
					<p>{{user.static_name}}</p>
				</div>
			</td>
			<td></td>
			<td class="center">
				<div class="buttons inline">
					<button class="remove" stoplistremoveaddictpay="{{user.ins_id}}" title="Удалить"><i class="fa fa-trash"></i></button>
				</div>
			</td>
		</tr>
	{% endfor %}
{% endif %}