
<div class="d-flex align-items-center justify-content-between">
	<strong class="fontcolor">{{action_from}}</strong>
	<strong class="fontcolor">{{action_date}}</strong>
</div>



<hr class="mb20px smooth">




{% if type == 1 %}
	<strong>Участник:</strong>
	<div class="d-flex mb15px">
		<img class="avatar w60px h60px" src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}">
		<div class="ml5px">
			<p class="mb5px"><strong class="fz16px">{{user.nickname}}</strong></p>
			<p class="fz14px mb-0">{{user.rank}}</p>
		</div>
	</div>
	
	
	<strong>Статики</strong>
	
	<div class="row">
		{% for period in ['before', 'after'] %}
			<div class="col">
				<strong class="fz14px">{{periods[period]}}</strong>
				<table>
					<thead>
						<tr>
							<td>Статик</td>
							<td class="w60px" title="Основной">Основн.</td>
							<td class="w60px" title="Лидер">Лидер</td>
						</tr>
					</thead>
					<tbody>
						{% for stId, stData in statics[period] %}
							<tr>
								<td>
									<div class="d-flex align-items-center">
										<img class="avatar w40px h40px" src="{{base_url('public/filemanager/thumbs/'~statics_data[stId]['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="{{statics_data[stId]['name']}}">
										
										<small class="ml5px">{{statics_data[stId]['name']|default('Статик удален')}}</small>
									</div>
								
								</td>
								<td class="center">{% if stData.main == 1 %}<i class="fa fa-check green"></i>{% endif %}</td>
								<td class="center">{% if stData.lider == 1 %}<i class="fa fa-check green"></i>{% endif %}</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		{% endfor %}
	</div>
	
	
			

{% elseif type in [2, 3] %}
	<table>
		<thead>
			<tr>
				<td>Участник</td>
				<td class="w100px">Статус</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<div class="d-flex">
						<img class="avatar w60px h60px" src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}">
						<div class="ml5px">
							<p class="mb10px"><strong class="fz16px">{{user.nickname}}</strong></p>
							<p class="fz14px mb-0">{{user.rank}}</p>
						</div>
					</div>
				</td>
				<td class="center">
					{% if stat == 1 %}
						<i class="fa fa-check green fz30px"></i>
						<p>Восстановлен</p>
					{% else %}
						{% if type == 2 %}
							<i class="fa fa-ban red fz30px"></i>
							<p>Исключен</p>
						{% elseif type == 3 %}
							<i class="fa fa-ban red fz30px"></i>
							<p>Удален</p>
						{% endif %}	
					{% endif %}
				</td>
			</tr>
		</tbody>
	</table>

{% elseif type == 4 %}
	<strong class="fz14px">Участники:</strong>
	{% if users %}
		<table>
			<thead>
				<tr>
					<td class="w40">Участник</td>
					<td>Старые платежные данные</td>
					<td>Новые платежные данные</td>
				</tr>
			</thead>
			<tbody>
				{% for uId, user in users_data %}
					<tr>
						<td>
							<div class="d-flex">
								<img class="avatar w40px h40px" src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}">
								<div class="ml5px">
									<p class="fz14px mb5px"><strong>{{user.nickname}}</strong></p>
									<span class="fz12px mb-0">{{ranks[user.rank]['name']}}</span>
								</div>
							</div>
						</td>
						<td>
							<p>{{users[uId]['payment_old']}}</p>
						</td>
						<td>
							<p>{{users[uId]['payment_new']}}</p>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	{% else	%}	
		<p class="empty">Нет данных</p>
	{% endif %}
	
{% elseif type == 5 %}	
			
	<h4 class="mb15px">{{pr_types_names[pr_type]}}</h4>
	<p>{{info|raw}}</p>
	
	{% if user %}
		<strong>Участник:</strong>
		<div class="d-flex">
			<img class="avatar w60px h60px" src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}">
			<div class="ml5px">
				<p class="fz14px mb5px"><strong>{{user.nickname}}</strong></p>
				<span class="fz12px">{{user.rank}}</span>
			</div>
		</div>
	{% endif %}


{% elseif type == 6 %}
	
	<strong>Участники:</strong>
	<table>
		<thead>
			<tr>
				<td>Участник</td>
				<td>Резерв</td>
				<td>Платежные даннные</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<div class="d-flex">
						<img class="avatar w40px h40px" src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}">
						<div class="ml5px">
							<p class="fz14px mb5px"><strong>{{user.nickname}}</strong></p>
							<span class="fz12px">{{user.rank}}</span>
						</div>
					</div>
				</td>
				<td{% if deposit_old != deposit_new %} class="changed" title="Изменено"{% endif %}>
					{% if deposit_old != deposit_new %}
						<p>До: <strong>{{deposit_old|number_format(2, '.', ' ')}}</strong> ₽</p>
						<p>После: <strong>{{deposit_new|number_format(2, '.', ' ')}}</strong> ₽</p>
					{% else %}
						<p><strong>{{deposit_old|number_format(2, '.', ' ')}}</strong> ₽</p>
					{% endif %}
					
				</td>
				<td{% if payment_old != payment_new %} class="changed" title="Изменено"{% endif %}>
					{% if payment_old != payment_new %}
						<p>До: {{payment_old}}</p>
						<p>После: {{payment_new}}</p>
					{% else %}
						<p>{{payment_old}}</p>
					{% endif %}
				</td>
			</tr>
		</tbody>
	</table>


{% elseif type == 7 %}
	{% if users %}
		<div class="d-flex align-items-center justify-content-between mb10px">
			<strong class="fz14px">Участники:</strong>
			<span class="fz14px">Общая сумма: <strong>{{total_summ|number_format(2, '.', ' ')}} ₽</strong></span>
		</div>
		
		
		
		<table>
			<thead>
				<tr>
					<td>Участник</td>
					<td class="w100px">Списанная сумма</td>
				</tr>
			</thead>
			<tbody>
				{% for user in users %}
					<tr>
						<td>
							<div class="d-flex">
								<img class="avatar w40px h40px" src="{{base_url('public/images/users/mini/'~users_data[user.user_id]['avatar'])|no_file('public/images/user_mini.jpg')}}" alt="{{users_data[user.user_id]['nickname']}}">
								<div class="ml5px">
									<p class="fz14px mb5px"><strong>{{users_data[user.user_id]['nickname']}}</strong></p>
									<span class="fz12px">{{ranks[users_data[user.user_id]['rank']]['name']}}</span>
								</div>
							</div>
						</td>
						<td><strong>{{user.summ|number_format(2, '.', ' ')}}</strong> ₽</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
		
		
	{% else %}
		<p class="empty">Нет данных</p>
	{% endif %}
	
{% endif %}