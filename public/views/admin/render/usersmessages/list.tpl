{% if messages %}
	{% for mess in messages %}
		<tr>
			<td>{{mess.title}}</td>
			<td>{{mess.date|d}} в {{mess.date|t}}</td>
			<td class="center{% if mess.users_done == mess.users_all %} usersmessages__list_done{% endif %}"><strong messtousersreadcount="{{mess.id}}">{{mess.users_done}}</strong> из <strong>{{mess.users_all}}</strong></td>
			<td class="center top pt9px">
				<div class="buttons inline notop">
					<button class="small w30px pay" messtousersshow="{{mess.id}}" title="Посмотреть состояние"><i class="fa fa-eye"></i></button>
					<button class="small w30px remove" messtousersremove="{{mess.id}}" title="Удалить"><i class="fa fa-trash"></i></button>
				</div>
			</td>
		</tr>
	{% endfor %}
{% endif %}