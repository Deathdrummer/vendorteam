{% if users %}
	<ul class="tabstitles sub">
		{% for staticId, usersList in users %}
			<li id="tabStatic{{staticId}}">{{statics[staticId]}}</li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent" userscontent>
		{% for staticId, usersList in users %}
			<div tabid="tabStatic{{staticId}}">
				<table>
					<thead>
						<tr>
							<td class="w300px">Участник</td>
							<td class="w130px">Форс мажорные выходныые</td>
							<td class="w130px">Выговоры</td>
							<td class="w130px">Стимулирование</td>
							<td></td>
							<td>Действия</td>
						</tr>
					</thead>
					<tbody>
						{% for user in usersList|sortusers %}
							<tr>
								<td>
									<div class="row gutters-5 align-items-center">
										<div class="col-auto">
											<div class="avatar" style="background-image: url('{{base_url('public/images/users/'~user.avatar)|is_file('public/images/user_mini.jpg')}}')"></div>
										</div>
										<div class="col">
											<p><strong>{{user.nickname}}</strong></p>
											<p><small>{{user.role}}</small></p>
											<small>{{user.rank}}</small>
										</div>
									</div>
								</td>
								<td class="text-center"><strong forcemajeure>{{user.forcemajeure|default('-')}}</strong></td>
								<td class="text-center"><strong reprimands>{{user.reprimands|default('-')}}</strong></td>
								<td class="text-center"><strong stimulation>{{user.stimulation|default('-')}}</strong></td>
								<td></td>
								<td class="w150px center">
									<div class="buttons nowrap notop">
										<button class="w45px pay" title="Стимулирование" setstimulation="{{user.id}}"><i class="fa fa-thumbs-o-up"></i></button>
										<button class="w45px" title="Форс мажор" setforcemajeure="{{user.id}}"><i class="fa fa-bolt"></i></button>
										<button class="w45px remove" title="Выговоры" setreprimand="{{user.id}}"><i class="fa fa-exclamation-triangle"></i></button>
									</div>
								</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>	
			</div>
		{% endfor %}
	</div>
{% else %}
	<p class="empty center">Нет данных</p>
{% endif %}