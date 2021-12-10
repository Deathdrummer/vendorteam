<tr userid="{{id}}">
	<td class="center"><strong usersv2num></strong></td>
	<td>
		<div class="d-flex align-items-center justify-content-between">
			<img src="{{base_url('public/images/users/mini/'~avatar)|no_file('public/images/user_mini.jpg')}}" userv2card="{{id}}" alt="{{nickname}}" class="avatar w40px h40px pointer" title="Карточка участника «{{nickname}}»">
			<div class="field ml4px w170px">
				<input type="text" value="{{nickname}}" class="fz12px" userfield="nickname">
			</div>
		</div>
	</td>
	{% if fields %}
		{% for field, value in fields %}
			<td class="{% if field in ['lider', 'nda', 'stage', 'color', 'agreement'] %}center{% endif %} text-overflow"{% if field == 'rank' %} usersv2ranktd{% endif %}>
				{% if field in ['email', 'rank'] %}
					{% if field == 'email' %}
						<span class="text-overflow fz14px pointer" title="{{value}}" copytoclipboard="{{value}}">{{value}}</span>
					{% elseif field == 'rank' %}
						<div class="row gutters-4 align-items-center">
							<div class="col">
								<p class="text-overflow fz14px" usersv2currentrank title="{{ranks[value.current]}}">{{ranks[value.current]}}</p>
								<p {% if not fields['rank']['next'] %} style="display:none;"{% endif %} class="text-overflow mt3px"><i class="fa fa-arrow-right mr3px"></i> <span class="fz12px" usersv2nextrank>{{fields['rank']['next']['next_rank']}}</span> <small>(<small usersv2nextcountdays>{{fields['rank']['next']['count_days']}}</small> дн.)</small></p>
							</div>
							<div class="col-auto">
								<div title="Изменить звание"><i class="fa fa-bars fz18px pointer blue blue_hovered" usersv2setrank="{{id}}|{{value.current}}"></i></div>
							</div>
						</div>
					{% endif %}
				
				{% elseif field in ['nda'] %}
					<div class="checkblock">
						<input type="checkbox" id="{{field~id}}" {% if value %} checked{% endif %} userfield="{{field}}">
						<label for="{{field~id}}"></label>
					</div>
				
				{% elseif field in ['lider', 'agreement'] %}
					{% if value %}
						<i class="fa fa-check fz16px"></i>
					{% else %}
						<strong>-</strong>
					{% endif %}
				
				{% elseif field in ['stage', 'deposit_percent'] %}
					<div class="row gutters-4 align-items-center">
						<div class="col">
							<div class="field">
								<input type="number" value="{{value}}" class="fz14px" showrows userfield="{{field}}">
							</div>
						</div>
						{% if field == 'stage' %}
							<div class="col-auto">
								{% if frozen %}
									<div title="Разморожить стаж"><i class="fa fa-stop-circle fz18px pointer red red_hovered" usersv2freezestage="{{id}}"></i></div>
								{% else %}
									<div title="Заморозить стаж"><i class="fa fa-play-circle fz18px pointer green green_hovered" usersv2freezestage="{{id}}"></i></div>
								{% endif %}
							</div>
						{% endif %}
					</div>
				
				{% elseif field in ['payment'] %}
					{% if field == 'payment' %}
						<div class="d-flex align-items-center">
							<div class="field">
								<input type="text" class="fz12px" value="{{value}}" userfield="{{field}}">
							</div>
							<div class="buttons notop inline ml3px">
								<button class="pay h30px pl0px pr0px w30px" copytoclipboard="{{value}}"><i class="fa fa-copy"></i></button>
							</div>
						</div>
							
					{% endif %}
				
				{% elseif field in ['reg_date', 'birthday'] %}
					<div class="date">
						<input type="text" value="{{value|d}}" class="fz12px" date userfield="{{field}}">
					</div>
					
				{# {% elseif field in ['statics'] %}
					<div class="scrollblock h50px pt2px pb2px">
						{% if value %}
							{% for stId in value %}
								<p class="fz10px">{{statics[stId]}}</p>
							{% endfor %}
						{% else %}
							
						{% endif %}
					</div> #}
				
				{% elseif field in ['role', 'access'] %}
					<div class="select">
						{% if field == 'role' %}
							<select userfield="{{field}}" class="fz12px">
								{% if roles %}
									<option selected disabled>Не выбрана</option>
									{% for rId, role in roles %}
										<option value="{{rId}}"{% if value == rId %} selected{% endif %}>{{role}}</option>
									{% endfor %}
								{% else %}
									<option selected disabled>Нет ролей</option>
								{% endif %}
							</select>
						{% elseif field == 'access' %}
							<select userfield="{{field}}" class="fz12px">
								{% if access %}
									<option selected disabled>Не выбран</option>
									{% for aId, name in access %}
										<option value="{{aId}}"{% if value == aId %} selected{% endif %}>{{name}}</option>
									{% endfor %}
								{% else %}
									<option selected disabled>Нет доступов</option>
								{% endif %}
							</select>
						{% endif %}
						<div class="select__caret"></div>
					</div>
				
				{% elseif field == 'color' %}	
					<div class="d-inline-block rounded bordered pointer color w30px h30px" userv2color style="background-color: {{value}}"></div>
					
				{% endif %}
			</td>
			
			{# <td class="{% if field in ['lider', 'nda'] %}center{% endif %}">
			{% if value %}
				<i class="fa fa-check fz16px"></i>
			{% else %}
				<strong>-</strong>
			{% endif %}
			
			
			{% if field in ['lider', 'nda'] %}
				<td class="center">
					
				</td>
			{# {% elseif field == 'nda' %}
				<td class="center">
					{% if value %}
						<i class="fa fa-check fz16px"></i>
					{% else %}
						<strong>-</strong>
					{% endif %}
				</td> 
			{% else %}
				<td>{{value|join}}</td>
			{% endif %}
			</td> #}#}
		{% endfor %}
	{% endif %}
	<td class="p-0"></td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="small w28px alt2" userv2statics="{{id}}" title="Статики"><i class="fa fa-th-list fz14px"></i></button>
		</div>
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="small w28px alt2" userv2classes="{{id}}" title="Классы"><i class="fa fa-th-list fz14px"></i></button>
		</div>
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="small w28px alt2" userv2personages="{{id}}" title="Персонажи"><i class="fa fa-th-list fz14px"></i></button>
		</div>
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="small w28px" userv2card="{{id}}" title="Карточка участника"><i class="fa fa-id-card"></i></button>
			{% if is_main_admin %}
				<a href="{{base_url('account?visituser='~id|encrypt|url_encode)}}" target="_blank" class="button w28px h24px" title="Перейти в ЛК участника"><i class="fa fa-user"></i></a>
			{% endif %}
			
			
			{% if excluded %}
				<button class="small w28px pay" returnexcludeduser="{{id}}" title="Вернуть отстраненного участника"><i class="fa fa-user-o"></i><i class="icon fa fa-plus"></i></button>
			{% else %}
				<button class="small w28px remove" excludeuser="{{id}}" title="Отстранить участника"><i class="fa fa-user-o"></i><i class="icon fa fa-ban"></i></button>
			{% endif %}
			
			{% if deleted %}
				<button class="small w28px pay" returndeleteduser="{{id}}" title="Вернуть удаленного участника"><i class="fa fa-level-up"></i></button>
			{% else %}
				<button class="small w28px remove" deleteuser="{{id}}" title="Удалить участника"><i class="fa fa-ban"></i></button>
			{% endif %}
		</div>
	</td>
</tr>