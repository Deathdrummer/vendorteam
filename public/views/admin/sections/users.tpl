<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Участники</h2>
		<div class="buttons notop" id="{{id}}SaveBlock">
			<button class="large" id="{{id}}Save" title="Сохранить"><i class="fa fa-save"></i> <span>Сохранить</span></button>
			<button class="large" hidden id="raidersColorsSave" title="Сохранить цвета"><i class="fa fa-save"></i> <span>Сохранить цвета</span></button>
		</div>
	</div>
	
	<fieldset>
		<legend>Список участников</legend>
		
		<input type="hidden" id="sortField" value="{{sort_field}}">
		<input type="hidden" id="sortOrder" value="{{sort_order}}">
		
		<div id="usersWaitBlock"></div>
		
		<div class="row gutters-6 align-items-center mb-3">
			<div class="col-auto">
				<div class="field small">
					<input type="text" id="searchUsersField" placeholder="Введите никнейм">
				</div>
			</div>
			<div class="col-auto">
				<div class="select small">
					<select id="searchUsersType">
						<option value="nickname">По никнейму</option>
						<option value="payment">По платежным данным</option>
					</select>
					<div class="select__caret"></div>
				</div>
			</div>
			<div class="col-auto">
				<div class="buttons notop">
					<button class="small" id="setSearchFromUsers">Поиск</button>
				</div>
			</div>
			<div class="col-auto">
				<div class="buttons notop">
					<button class="small remove" disabled id="resetSearchFromUsers">Сбросить</button>
				</div>
			</div>
			
			<div class="col-auto ml30px">
				<p>Участников онлайн: <strong id="onlineUsersCount">--</strong></p>
			</div>
			
			<div class="col-auto ml-auto">
				<span>Группировка:</span>
			</div>
			<div class="col-auto">
				<div class="select small">
					<select id="staticsGroup">
						<option value="">Все</option>
						<option value="1">Рейды</option>
						<option value="2">Группа</option>
						<option value="3">Инактив</option>
					</select>
					<div class="select__caret"></div>
				</div>
			</div>
		</div>
		
		<ul class="tabstitles">
			{% if permissions is not defined or id~'.verifyUsers' in permissions %}<li id="verifyUsers">Верифицированные</li>{% endif %}
			{% if permissions is not defined or id~'.newUsers' in permissions %}<li id="newUsers">Новые</li>{% endif %}
			{% if permissions is not defined or id~'.excludedUsers' in permissions %}<li id="excludedUsers">Отстраненные</li>{% endif %}
			{% if permissions is not defined or id~'.deletedUsers' in permissions %}<li id="deletedUsers">Удаленные</li>{% endif %}
			{% if permissions is not defined or id~'.depositUsers' in permissions %}<li id="depositUsers">Резерв</li>{% endif %}
			{% if permissions is not defined or id~'.balance' in permissions %}<li id="balance">Баланс</li>{% endif %}
			{% if permissions is not defined or id~'.colorsUsers' in permissions %}<li id="colorsUsers">Цвета рейдеров</li>{% endif %}
		</ul>
		
		
		<div class="tabscontent">
			{% for tabid, udata in {'verifyUsers': users.verify, 'newUsers': users.new, 'excludedUsers': users.excluded, 'deletedUsers': users.deleted} %}
				
				{% if permissions is not defined or id~'.'~tabid in permissions %}
				<div tabid="{{tabid}}">
					{% if udata|length > 0 %}
						<ul class="tabstitles sub">
							{% if udata[0] is defined %}
								<li id="tab0">Статик не задан</li>
							{% endif %}
							{% for sId, sData in statics %}
								{% if udata[sId] is defined %}
									<li id="tab{{sId}}" group="{{statics[sId]['group']}}">{% if sId == 0 %}Статик не задан{% else %}{{statics[sId]['name']|default('Статик удален')}}{% endif %}</li>
								{% endif %}
							{% endfor %}
						</ul>
						
						<div class="tabscontent">
							{% for staticId, usersData in udata %}
								<div tabid="tab{{staticId}}" class="scroll">
									<strong>{% if staticId == 0 %}Статик не задан{% else %}{{statics[staticId]['name']|default('Статик удален')}}{% endif %}</strong>
									
									{% if usersData %}
										<table id="{{tabid}}Table">
											<thead>
												<tr>
													<td></td>
													{% if tabid == 'verifyUsers' or tabid == 'newUsers' %}<td class="nowidth" title="Цвет">Цвет</td>{% endif %}
													<td class="w150px{% if sort_field == 'u.nickname' %} active{% endif %}">Никнейм <i class="fa fa-sort" userssortfield="u.nickname" sortorder="{{sort_order}}"></i></td>
													<td class="nowrap{% if sort_field == 'us.lider' %} active{% endif %}">Лидер <i class="fa fa-sort" userssortfield="us.lider" sortorder="{{sort_order}}"></i></td>
													<td class="nowrap{% if sort_field == 'u.agreement' %} active{% endif %}" title="Соглашение">Согл. <i class="fa fa-sort" userssortfield="u.agreement" sortorder="{{sort_order}}"></i></td>
													<td class="w140px{% if sort_field == 'u.rank' %} active{% endif %}">Звание <i class="fa fa-sort" userssortfield="u.rank" sortorder="{{sort_order}}"></i></td>
													<td class="w150px{% if sort_field == 'u.email' %} active{% endif %}">E-mail <i class="fa fa-sort" userssortfield="u.email" sortorder="{{sort_order}}"></i></td>
													<td class="w156px{% if sort_field == 'u.reg_date' %} active{% endif %}">Дата регистрации <i class="fa fa-sort" userssortfield="u.reg_date" sortorder="{{sort_order}}"></i></td>
													<td class="nowidth">Стаж дн.</td>
													<td class="w150px">Средство платежа</td>
													<td{% if sort_field == 'u.birthday' %} class="active"{% endif %}>Дата рождения <i class="fa fa-sort" userssortfield="u.birthday" sortorder="{{sort_order}}"></i></td>
													<td class="nowrap" title="Процент отчисления в депозит">Пр.от.</td>
													<!-- <td>Ранг</td> -->
													<td class="w100px{% if sort_field == 'u.role' %} active{% endif %}">Роль <i class="fa fa-sort" userssortfield="u.role" sortorder="{{sort_order}}"></i></td>
													<td class="w100px">Доступ</td>
													<td class="w50px" title="Соглашение о неразглашении конфиденциальной информации">NDA</td>
													<td class="nowidth">Статики</td>
													<td class="nowidth">Классы</td>
													{% if tabid == 'verifyUsers' %}<td class="nowidth" title="Персонажи">Персон.</td>{% endif %}
													{% if tabid == 'deletedUsers' %}<td class="nowidth" title="Восстановить участника">Восст.</td>{% endif %}
													<td class="nowidth" {% if tabid == 'newUsers' or tabid == 'excludedUsers' %}colspan="2{% endif %}">Опции</td>
												</tr>
											</thead>
											
											<tbody userslistrows>
												{% for k, user in usersData %}
													<tr userid="{{user.id}}"{% if user.nickname %} usernickname="{{user.nickname}}"{% endif %}{% if user.payment %} userpayment="{{user.payment}}"{% endif %}>
														<td class="nowidth nopadding">
															{% if user.avatar %}
																<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)}}')" title="{{user.nickname}}">
																	{% if user.excluded %}
																		<i class="fa fa-minus-circle fz18px mt3px ml3px" style="color: #c54747;" title="Отстранен"></i>
																	{% endif %}
																</div>
															{% elseif user.deleted %}
																<div class="avatar" style="background-image: url({{base_url('public/images/deleted_mini.jpg')}})" title="Нет аватарки"></div>
															{% else %}
																<div class="avatar" style="background-image: url({{base_url('public/images/user_mini.jpg')}})" title="Нет аватарки"></div>
															{% endif %}
														</td>
														{% if tabid == 'verifyUsers' or tabid == 'newUsers' %}
															<td class="center">
																<div class="color">
																	<div setstaticusercolor style="background-color: {{user.color}}"></div>
																	<input type="hidden" class="user_color" value="{{user.color}}">
																</div>
															</td>
														{% endif %}	
														<td class="nowidth">
															<div class="text">
																<input type="text" class="user_nickname wpx50" value="{{user.nickname}}" placeholder="Не задан">
															</div>
														</td>
														<td class="nowidth center">
															{% if user.lider == 1 %}
																<i class="fa fa-check"></i>
															{% else %}
																<i class="fa fa-ban"></i>
															{% endif %}
														</td>
														<td class="nowidth center">
															{% if user.agreement == 1 %}
																<i class="fa fa-check"></i>
															{% else %}
																<i class="fa fa-ban"></i>
															{% endif %}
														</td>
														<td>{{user.rank|default('не задано')}}</td>
														<td>{{user.email}}</td>
														<td class="nowidth">
															<div class="date">
																<input type="text" class="user_reg_date" value="{{user.reg_date|d}}" date="">
															</div>
														</td>
														<td class="nowidth nowrap">
															<div class="number short">
																<input type="number" showrows class="user_stage" value="{{user.stage|default(0)}}">
															</div>
															<span class="ml-1"></span>
														</td>
														<td class="nowidth">
															<input type="hidden" class="user_payment_origin" value="{{user.payment}}">
															<div class="text">
																<input type="text" class="user_payment" value="{{user.payment}}">
															</div>
														</td>
														<td class="nowidth">
															<div class="date w150px">
																<input type="text" class="user_birthday" value="{% if user.birthday %}{{user.birthday|d}}{% endif %}" date="">
															</div>
														</td>
														<td class="nowidth">
															<div class="number w54px">
																<input type="number" showrows class="user_deposit_percent" value="{{user.deposit_percent|default(0)}}">
															</div>
														</td>
														<td class="nowidth">
															{% if roles|length > 0 %}
																<div class="select wpx40">
																	<select class="user_role">
																		<option value="" selected="" disabled="">Задать</option>
																		{% for id, role in roles %}
																			<option value="{{id}}"{% if id == user.role %} selected=""{% endif %}>{{role.name}}</option>
																		{% endfor %}
																	</select>
																	<div class="select__caret"></div>
																</div>		
															{% else %}
																<p class="empty">Создайте роли</p>
															{% endif %}
														</td>
														<td class="nowidth">
															{% if accounts_access|length > 0 %}
																<div class="select wpx40">
																	<select class="user_access">
																		<option value="0" selected>По-умолчанию</option>
																		{% for id, access in accounts_access %}
																			<option value="{{id}}"{% if id == user.access %} selected=""{% endif %}>{{access.name}}</option>
																		{% endfor %}
																	</select>
																	<div class="select__caret"></div>
																</div>		
															{% else %}
																<p class="empty">Создайте доступы</p>
															{% endif %}
														</td>
														<td class="center">
															<div class="checkblock">
																<input type="checkbox" id="checkNDA{{user.id}}" setusernda="{{user.id}}"{% if user.nda %} checked{% endif %}>
																<label for="checkNDA{{user.id}}"></label>
															</div>
														</td>
														<td class="nowidth center">
															<input type="hidden" class="user_statics" value="{{user.static}}">
															<div class="buttons inline notop">
																<button class="alt" setuserstatics="{{user.id}}" title="Задать статики"><i class="fa fa-th-list"></i></button>
															</div>
														</td>
														<td class="nowidth center">
															<input type="hidden" class="user_classes" value="{{user.class}}">
															<div class="buttons inline notop">
																<button class="alt" setuserclasses="{{user.id}}" title="Задать классы"><i class="fa fa-th-list"></i></button>
															</div>
														</td>
														{% if tabid == 'newUsers' %}
															<td class="nowidth center">
																<div class="buttons inline notop">
																	<button class="large update" setuserdata="{{user.id}}" title="Подтвердить"><i class="fa fa-check"></i></button>
																</div>
															</td>
															<td class="nowidth center">
																<div class="buttons inline notop">
																	<button class="remove large" deleteuser="{{user.id}}"{% if tabid == 'deletedUsers' %} disabled{% endif %} title="Удалить"><i class="fa fa-trash"></i></button>
																</div>
															</td>
														{% elseif tabid == 'verifyUsers' %}
															<td class="nowidth center">
																<div class="buttons inline notop">
																	<button class="alt" setuserpersonages="{{user.id}}" title="Утвердить персонажей"><i class="fa fa-th-list"></i></button>
																</div>
															</td>
															<td class="nowidth center">
																<div class="buttons inline notop">
																	<button class="remove large" deleteuser="{{user.id}}"{% if tabid == 'deletedUsers' %} disabled{% endif %} title="Удалить"><i class="fa fa-trash"></i></button>
																</div>
															</td>
														{% elseif tabid == 'deletedUsers' %}
															<td class="center">
																<div class="checkblock">
																	<input type="checkbox" id="recoveryUser{{staticId}}{{user.id}}{{user.role}}" class="recovery_user">
																	<label for="recoveryUser{{staticId}}{{user.id}}{{user.role}}"></label>
																</div>
															</td>
															<td class="nowidth center">
																<div class="buttons inline notop">
																	<button class="large" setuserdata="{{user.id}}" title="Обновить"><i class="fa fa-save"></i></button>
																</div>
															</td>
														{% elseif tabid == 'excludedUsers' %}
															<td class="nowidth center">
																<div class="buttons inline notop">
																	<button class="large" setuserdata="{{user.id}}" title="Обновить"><i class="fa fa-save"></i></button>
																</div>
															</td>
															<td class="nowidth center">
																<div class="buttons inline notop">
																	<button class="large alt2" includeuser="{{user.id}}" title="Восстановить исключенного участника"><i class="fa fa-refresh"></i></button>
																</div>
															</td>
														{% endif %}
													</tr>
												{% endfor %}
											</tbody>
										</table>
										<br>
										<br>
									{% else %}
										<p class="empty">Нет данных</p>
									{% endif %}
								</div>
							{% endfor %}
						</div>
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}
				</div>
				{% endif %}
			{% endfor %}
			
			
			{% if permissions is not defined or id~'.depositUsers' in permissions %}
			<div tabid="depositUsers">

				<h4 class="mb-2">Общий Резерв: <strong>{{currency(deposit['global'])}}</strong></h4>
				
				<div class="row">
					<div class="col-6">
						<div class="d-flex align-items-center justify-content-between">
							<h4>Резерв по статикам:</h4>
							{#<div class="buttons mb10px">
								<button id="depositUsersList" disabled>Сохранить</button>
							</div>#}
						</div>
						
						
						
						<div id="depositTables">
							<table>
								<thead class="main">
									<tr class="h40px">
										<td colspan="2"><h4>Статик</h4></td>
										<td class="w250px">Средство платежа</td>
										<td class="w150px"><h4>Резерв</h4></td>
									</tr>
								</thead>
							</table>
							{% for stId, deposit in deposit['statics'] %}
								<table>
									<thead class="hover">
										<tr class="h50px">
											<td colspan="2"><h4>{% if stId == 0 %}Статик не задан{% else %}{{statics[stId]['name']|default('Статик удален')}}{% endif %}</h4></td>
											<td class="w250px"></td>
											<td class="w150px"><h4>{{currency(deposit)}}</h4></td>
										</tr>
									</thead>
									<tbody hidden deposituserslist>
										{% for user in deposit_users[stId] %}
											<tr usernickname="{{user.nickname}}">
												<td class="nowidth nopadding noheight">
													{% if user.avatar %}
														<div class="avatar mini" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)}}')" title="{{user.nickname}}"></div>
													{% elseif user.deleted %}
														<div class="avatar mini" style="background-image: url({{base_url('public/images/deleted_mini.jpg')}})" title="Нет аватарки"></div>
													{% else %}
														<div class="avatar mini" style="background-image: url({{base_url('public/images/user_mini.jpg')}})" title="Нет аватарки"></div>
													{% endif %}
												</td>
												<td class="noheight">{{user.nickname|default('Не задан')}}</td>
												<td>
													<input type="hidden" class="deposit_user_payment_origin" value="{{user.payment}}">
													<div class="text">
														<input type="text" class="deposit_user_payment" value="{{user.payment}}">
													</div>
												</td>
												<td class="noheight">
													<div class="number">
														<input type="hidden" class="deposit_user_id" value="{{user.id}}">
														<input type="number" class="deposit_user_deposit" originval="{{user.deposit|default(0)}}" value="{{user.deposit|default(0)}}">
													</div>
													<span>{{currency}}</span>
												</td>
											</tr>
										{% endfor %}
									</tbody>
								</table>
							{% endfor %}
						</div>
					</div>
					<div class="col-6">
						<div class="d-flex align-items-center justify-content-end">
							<h4>Выплаты из общего резерва:</h4>
						</div>
						
						<table id="globalDeposit">
							<thead class="main">
								<tr class="h40px">
									<td class="nowidth"></td>
									<td class="w180px">Никнейм</td>
									<td>Причина</td>
									<td class="w100px">Сумма</td>
									<td class="w130px">Дата</td>
									<td class="w50px">Статус</td>
								</tr>
							</thead>
							<tbody>
								{% if deposit_history %}
									{% for item in deposit_history %}
										<tr>
											<td class="nopadding"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)|no_file('public/images/user_mini.jpg')}}')"></div></td>
											<td>{{item.nickname}}</td>
											<td>{{item.reason}}</td>
											<td>{{currency(item.summ)}}</td>
											<td>{{item.date|d}}</td>
											<td>{{item.stat}}</td>
										</tr>	
									{% endfor %}
								{% else %}
									<tr>
										<td colspan="6"><p class="empty center">нет данных</p></td>
									</tr>	
								{% endif %}
							</tbody>
						</table>
					</div>
				</div>
				
				
					
				
				
				
				{#<table>
					<thead>
						<tr>
							<td>Статик</td>
							<td>Резерв</td>
						</tr>
					</thead>
					<tbody>
						{% for stId, deposit in deposit['statics'] %}
						<tr>
							<td>{{statics[stId]['name']|default('Статик не задан')}}</td>
							<td>{{currency(deposit)}}</td>
						</tr>
						{% endfor %}
					</tbody>
				</table>#}
				
					
			</div>
			{% endif %}
			
			
			{% if permissions is not defined or id~'.balance' in permissions %}
			<div tabid="balance">
				
				<div class="row">
					<div class="col-12 col-md-8 col-lg-9">
						
						<div class="d-flex align-items-center justify-content-between h46px">
							<h3 class="mb-0 mr-auto">Список</h3>
							<h4 class="mr-4 mt2px">Общий баланс: <strong>{{currency(balance.total)}}</strong></h4>
							<div class="buttons mb10px">
								<button class="small" id="resetBalance"{% if balance.total == 0 %} disabled{% endif %}>Списать баланс</button>
							</div>
						</div>
						
						<table>
							<thead>
								<tr>
									<td class="w300px">Участник</td>
									<td class="w300px">Статик</td>
									<td>Причина удержания</td>
									<td class="w160px">Сумма</td>
								</tr>
							</thead>
							<tbody>
								{% if balance.items %}
									{% for item in balance.items %}
										<tr>
											<td class="nowidth nopadding">
												<div class="d-flex align-items-center">
													<div class="avatar mr-2" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)|no_file('public/images/user_mini.jpg')}}')" title="{{item.nickname}}"></div>
													<p>{{item.nickname}}</p>
												</div>
											</td>
											<td class="nowidth nopadding">
												<div class="d-flex align-items-center">
													<div class="avatar mr-2" style="background-image: url('{{base_url('public/filemanager/'~item.static.icon)|no_file('public/images/deleted_mini.jpg')}}')" title="{{item.static.name}}"></div>
													<p>{{item.static.name}}</p>
												</div>
											</td>
											<td>
												<small class="format">{{item.comment}}</small>
											</td>
											<td>
												{% if item.reset %}
													<strike title="Списано" style="color: #afafaf;"><strong>{{currency(item.summ, '<small>₽</small>')}}</strong></strike>
												{% else %}
													<strong style="color: #5db553;">{{currency(item.summ, '<small>₽</small>')}}</strong> 
												{% endif %}
											</td>
										</tr>
									{% endfor %}
								{% else %}
									<tr><td colspan="5"><p class="empty center">Нет данных</p></td></tr>
								{% endif %}	
							</tbody>
						</table>
					</div>
					<div class="col-12 col-md-4 col-lg-3">
						<div class="d-flex align-items-center h46px">
							<h3 class="mb-0 text-right">История</h3>
						</div>
						<table>
							<thead>
								<tr>
									<td class="w70">Дата списания</td>
									<td>Сумма списания</td>
								</tr>
							</thead>
							<tbody>
								{% if balance_history %}
									{% for item in balance_history %}
										<tr>
											<td>{{item.date|d}} в {{item.date|t}}</td>
											<td><strong>{{currency(item.summ, '<small>₽</small>')}}</strong></td>
										</tr>
									{% endfor %}
								{% else %}
									<tr><td colspan="2"><p class="empty center">Нет данных</p></td></tr>	
								{% endif %}
							</tbody>
						</table>
					</div>
				</div>	
			</div>
			{% endif %}
			
			
			{% if permissions is not defined or id~'.colorsUsers' in permissions %}
			<div tabid="colorsUsers">
				<form id="raidersColorsForm">
					<fieldset>
						<legend>Список цветов</legend>
						
						<div class="list" id="raiderColorsBlock">
							{% if raiders_colors|length > 0 %}
								{% for id in raiders_colors|keys %}
									<div class="list_item">
										<div>
											{% include form~'color.tpl' with {'label': 'Цвет', 'name': 'raiders_colors|'~id~'|color', 'postfix': 0, 'class': 'w70px'} %}
											{% include form~'field.tpl' with {'label': 'Название цвета', 'name': 'raiders_colors|'~id~'|name', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
											<div class="buttons right ml-auto">
												<button class="remove remove_raders_color fieldheight" data-id="{{id}}" title="Удалить Цвет"><i class="fa fa-trash"></i></button>
											</div>
										</div>
									</div>
								{% endfor %}
							{% else %}
								<p class="empty">Нет данных</p>
							{% endif %}	
						</div>
						
						<div class="buttons">
							<button class="large" id="raidersColorsAdd">Добавить Цвет</button>
						</div>
						
					</fieldset>
				</form>
			</div>
			{% endif %}
		</div>
		
		
	</fieldset>
</div>








<script type="text/javascript"><!--

if (location.hostname != 'localhost') {
	
	
	socket.emit('take_users_online', users => {
		$.each(users, function(k, item) {
			$('#users').find('[userid="'+item['user_id']+'"]').find('.avatar').addClass('avatar_online').attr('title', 'Онлайн');
		});
		let countUsersOnline = Object.keys(users).length;
		$('#onlineUsersCount').text(countUsersOnline);
	});
	
	
	

	socket.on('set_online_user', (userId, users) => {
		let countUsersOnline = Object.keys(users).length;
		$('#users').find('[userid="'+userId+'"]').find('.avatar').addClass('avatar_online').attr('title', 'Онлайн');
		$('#onlineUsersCount').text(countUsersOnline);
	});


	socket.on('set_offline_user', (userId, users) => {
		$('#users').find('[userid="'+userId+'"]').find('.avatar').removeClass('avatar_online').removeAttrib('title');
		let countUsersOnline = Object.keys(users).length;
		$('#onlineUsersCount').text(countUsersOnline);
	});

}
	







$(document).ready(function() {
	
	//------------------------------------------------------------ Выбор группы
	var groupFromCache = lscache.get('staticsGroup');
	if (groupFromCache) {
		$('#staticsGroup').find('option[value="'+groupFromCache+'"]').setAttrib('selected');
		$('[group]:not([group="'+groupFromCache+'"])').setAttrib('hidden');
		$('.tabstitles.sub').find('li').removeClass('active');
		$('.tabstitles.sub').find('li:visible:first').addClass('active');
		var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
		
		$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
		$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
	} 
	
	$('#staticsGroup').on('change', function() {
		var group = $('#staticsGroup').val() || false;
		lscache.set('staticsGroup', group);
		$('[group]').removeAttrib('hidden');
		if (group) {
			$('[group]:not([group="'+group+'"])').setAttrib('hidden');
			$('.tabstitles.sub').find('li').removeClass('active');
			$('.tabstitles.sub').find('li:visible:first').addClass('active');
			var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
			
			$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
			$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
		} else {
			$('.tabstitles.sub').find('li').removeClass('active');
			$('.tabstitles.sub').find('li:first').addClass('active');
			var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
			
			$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
			$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
		}
	});
	
	
	
	
	//---------------------------------------------------------------------- Цвета
	dynamicList({
		listBlock: '#raiderColorsBlock', 	// - ID блока списка
		addButton: '#raidersColorsAdd', 	// - ID кнопки добавления элемента списка
		template: 'raiders_colors_add', 	// - Файл шаблона template: 'render/'+template+'.tpl'
		removeButton: '.remove_raders_color',	// - Класс кнопки удаления элемента списка
		removeQuestion: 'Удалить цвет?',
		removeMessage: 'Цвет успешно удален!',
		phpFunctionRemove: 'admin/raiders_colors_remove' 	// - Функция обработки в PHP
	});
	
	$('#raidersColorsSave').on(tapEvent, function() {
		var raidersColorsForm = new FormData($('#raidersColorsForm')[0]);
		$.ajax({
			type: 'POST',
			url: '/admin/raiders_colors_add',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: raidersColorsForm,
			success: function(response) {
				if (response) notify('Настройки цветов сохранены!');
				else notify('Ошибка сохранения настроек цветов!', 'error');
			},
			error: function(e) {
				console.log(e);	
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	
	
	
	
	//---------------------------------------------------------------------- Задать цвет рейдера
	var raidersColorsData,
		raidersColorsUserId,
		raidersColorBlock,
		raidersColorsTooltip = new jBox('Tooltip', {
		attach: '[setstaticusercolor]',
		trigger: 'click',
		closeOnMouseleave: true,
		addClass: 'raiderscolorswrap',
		outside: 'x',
		ignoreDelay: true,
		zIndex: 1200,
		//pointer: 'left',
		//pointTo: 'left',
		position: {
		  x: 'right',
		  y: 'center'
		},
		content: '<i class="fa fa-bars"></i>'
	});
		
	getAjaxHtml('account/get_raiders_colors', {}, function(html) {
		raidersColorsTooltip.setContent(html);
	});	
	
	$('body').on(tapEvent, function(e) {
		if ($('[setstaticusercolor]:hover').length == 0 && $('body').find('.raiderscolorswrap:visible').length > 0 && $('body').find('.raiderscolors:hover').length  == 0) {
			raidersColorsTooltip.close();
		}
	});
	
	
	
	$('[setstaticusercolor]').on(tapEvent, function() {
		raidersColorsUserId = $(this).closest('[userid]').attr('userid');
		raidersColorBlock = this;
	});
	
	
	
	$('body').on(tapEvent, '[chooseraidercolor]', function() {
		var thisRaiderColor = $(this).attr('chooseraidercolor');
		$.post('/account/change_user_color', {user_id: raidersColorsUserId, color: thisRaiderColor}, function(response) {
			if (response) {
				notify('Цвет пользователя задан!');
				$(raidersColorBlock).css('background-color', thisRaiderColor);
				raidersColorsTooltip.close();
			} else {
				notify('Ошибка! Цвет пользователя не задан!', 'error');
			}
		});
	});
	
	
	
	
	
	
	
	
	
	$('#users').find('.user_deposit').number(true, 2, '.', ' ');
	
	if ($('.user_reg_date').length > 0) {
		$('.user_reg_date').each(function() {
			$(this).datepicker({
		        dateFormat:         'd M yy г.',
		        yearRange:          "2010:+100",
		        numberOfMonths:     1,
		        changeMonth:        true,
		        changeYear:         true,
		        monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
		        monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
		        dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
		        firstDay:           1,
		        minDate:            new Date(2010, 0, 1, 0, 0, 0),
		        maxDate:            0,
		        onSelect: function(stringDate, dateObj) {
		            var rangeDay = rangeMonth = rangeYaer = 0;
		            var selectedDay = parseInt(dateObj.selectedDay),
		            	selectedMonth = parseInt(dateObj.selectedMonth),
		            	selectedYear = parseInt(dateObj.selectedYear);
		            
		            var formDay = '0'+selectedDay, formMonth = '0'+(selectedMonth + 1);
		            $(this).attr('date', selectedYear+'-'+formMonth.substr(-2)+'-'+formDay.substr(-2));
		            $(this).attr('name', 'users[][reg_date]');
		        }
		    });
		});
	}
	
	
	if ($('.user_birthday').length > 0) {
		$('.user_birthday').each(function() {
			$(this).datepicker({
		        dateFormat:         'd M yy г.',
		        yearRange:          "2010:+100",
		        numberOfMonths:     1,
		        changeMonth:        true,
		        changeYear:         true,
		        monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
		        monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
		        dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
		        firstDay:           1,
		        minDate:            new Date(2010, 0, 1, 0, 0, 0),
		        maxDate:            0,
		        onSelect: function(stringDate, dateObj) {
		            var rangeDay = rangeMonth = rangeYaer = 0;
		            var selectedDay = parseInt(dateObj.selectedDay),
		            	selectedMonth = parseInt(dateObj.selectedMonth),
		            	selectedYear = parseInt(dateObj.selectedYear);
		            
		            var formDay = '0'+selectedDay, formMonth = '0'+(selectedMonth + 1);
		            $(this).attr('date', selectedYear+'-'+formMonth.substr(-2)+'-'+formDay.substr(-2));
		            $(this).attr('name', 'users[][reg_date]');
		        }
		    });
		});
	}
	
	
	
	
	$('[userslistrows]').changeRowInputs(function(row) {
		$(row).addClass('changed');
	});
	
	
	$('body').off('focus', '.hasDatepicker').on('focus', '.hasDatepicker', function() {
		var thisItem = this,
			thisDate = $(thisItem).attr('date');
		$(thisItem).one('blur', function() {
			setTimeout(function() {
				if ($(thisItem).attr('date') != thisDate) {
					$(thisItem).closest('tr').addClass('changed');
				}
			}, 200);
		});
	});
	
	
	
	
	
	
	//------------------------------------------------------------ Поиск по участникам
	$('#setSearchFromUsers').on(tapEvent, function() {
		var searchFieldData = $('#searchUsersField').val(),
			searchUsersType = $('#searchUsersType').val();
		
		if (!searchFieldData) $('#searchUsersField').addClass('error');
		else {
			$('.tabstitles.sub').children().removeAttrib('hidden');
			$('[userslistrows], [deposituserslist]').find('tr').each(function() {
				var thisRow = this;
				var thisNickName = $(this).attr('usernickname'),
					thisPayment = $(this).attr('userpayment');
				
				var patt = new RegExp(searchFieldData, 'im');
				
				if (searchUsersType == 'nickname') {
					if (!patt.test(thisNickName)) {
						$(thisRow).setAttrib('hidden');
					} else {
						$(thisRow).removeAttrib('hidden');
					}
				} else if (searchUsersType == 'payment') {
					if (!patt.test(thisPayment)) {
						$(thisRow).setAttrib('hidden');
					} else {
						$(thisRow).removeAttrib('hidden');
					}
				}	
			});
			
			
			$('#depositTables').find('[deposituserslist]').each(function() {
				if ($(this).children('tr:not([hidden])').length) {
					$(this).removeAttrib('hidden');
				}
			});
			
						
			$('[userslistrows]').each(function() {
				if ($(this).children().not('[hidden]').length == 0) {
					var id = $(this).closest('[tabid]').attr('tabid');
					$(this).closest('.tabscontent').siblings('.tabstitles.sub').find('#'+id).setAttrib('hidden');
				}
			});
			
			$('.tabstitles.sub').find('li').removeClass('active');
			$('.tabstitles.sub').find('li:visible:first').addClass('active');
			var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
			
			$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
			$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
			
			$('#resetSearchFromUsers').removeAttrib('disabled');
		}	
	});
	
	$('#resetSearchFromUsers').on(tapEvent, function() {
		$('[userslistrows]').find('tr').each(function() {
			$(this).removeAttrib('hidden');
		});
		
		$('[deposituserslist]').find('tr').each(function() {
			$(this).setAttrib('hidden');
		});
		$('.tabstitles.sub').children().removeAttrib('hidden');
		$('#searchUsersField').val('');
		
		$('.tabstitles.sub').find('li').removeClass('active');
		$('.tabstitles.sub').find('li:visible:first').addClass('active');
		var tabId = $('.tabstitles.sub').find('li:visible:first').attr('id');
		
		$('.tabstitles.sub').siblings('.tabscontent').children('div').removeClass('visible');
		$('.tabstitles.sub').siblings('.tabscontent').children('div[tabid="'+tabId+'"]').addClass('visible');
		
		
		$('#resetSearchFromUsers').setAttrib('disabled');
	});
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Кнопка "сохранить" верифицированных пользователей скрыть или нет
	if (!/verifyUsers/.test(location.hash) && !/#users/.test(location.hash)) $('#usersSave').addClass('hidden');
	$('.tabstitles:not(.sub)').on(tapEvent, 'li', function() {
		if ($(this).attr('id') == 'verifyUsers') {
			$('#usersSave').removeClass('hidden');
		} else {
			$('#usersSave').addClass('hidden');
		}
	});
	
	if (/colorsUsers/.test(location.hash)) $('#raidersColorsSave').removeAttrib('hidden');
	else $('#raidersColorsSave').setAttrib('hidden');
	$('.tabstitles:not(.sub)').on(tapEvent, 'li', function() {
		if ($(this).attr('id') == 'colorsUsers') {
			$('#raidersColorsSave').removeAttrib('hidden');
		} else {
			$('#raidersColorsSave').setAttrib('hidden');
		}
	});
	
	
	
	var thisField = $('#sortField').val(),
		thisOrder = $('#sortOrder').val();
		
	$('[userssortfield]').on(tapEvent, function() {
		thisField = $(this).attr('userssortfield');
		thisOrder = $(this).attr('sortorder');
		renderSection({field: thisField, order: (thisOrder == 'ASC' ? 'DESC' : 'ASC')});
	});
	
	
	
	$('body').on('keyup', 'input:focus', function(e) {
		if (e.keyCode == 13 && $('[tabid="verifyUsers"]').hasClass('visible')) {
			$('#usersSave').trigger('click');
			return false;
		} 
	});
	
	
	
	
	
	//-------------------------------------------------------------- Задать статики пользователя
	$('#users').on(tapEvent, '[setuserstatics]', function() {
		$(this).removeClass('error');
		var thisUserRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserstatics');
			thisInput = $(this).closest('td').find('input.user_statics'),
			thisUserName = $(thisUserRow).find('.user_nickname').val();
			
		popUp({
			title: '<small>Статики: <strong>'+thisUserName+'</strong></small>',
		    width: 500,
		    //buttons: [{id: 'buildUserStatics', title: 'Применить'}],
		    //closeButton: 'Закрыть',
		}, function(userStaticsWin) {
			userStaticsWin.wait();
			newSet = thisInput.val() ? JSON.parse(thisInput.val()) : false;
			
			$.post('/admin/get_users_statics', {user_id: thisUserId, newset: newSet}, function(html) {
				if (html) {
					userStaticsWin.setData(html, false);
					$('#userStatics').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
					
					$('[staticpart], [staticlider]').on('change', function() {
						var thisStaticId = $(this).attr('staticpart') || $(this).attr('staticlider'),
							thisItem = $(this)[0].hasAttribute('staticpart') ? 'part' : 'lider',
							staticPart = $('[staticpart="'+thisStaticId+'"]'),
							staticLider = $('[staticlider="'+thisStaticId+'"]'),
							staticMain = $('[staticmain="'+thisStaticId+'"]');
						
						if (thisItem == 'part') {
							$(staticLider).prop('checked', false);
							$(staticLider)[0].removeAttribute('checked');
							
						} else if (thisItem == 'lider') {
							$(staticPart).prop('checked', true);
							$(staticPart)[0].setAttribute('checked', true);
						}	
						
						if ($(staticPart).is(':checked')) {
							$(staticMain).prop('disabled', false);
							$(staticMain)[0].removeAttribute('disabled');
							if ($('[staticmain]:checked').length == 0) {
								$(staticMain).prop('checked', true);
								$(staticMain)[0].setAttribute('checked', true);
							}
						} else {
							$(staticMain).prop('checked', false);
							$(staticMain)[0].removeAttribute('checked');
							$(staticMain)[0].setAttribute('disabled', true);
							$(staticMain).prop('disabled', true);
						}
					});
				} else {
					userStaticsWin.setData('<p class="empty center">Нет данных</p>', false);
				}
				userStaticsWin.wait(false);
				
				$('#userStatics').on('change', 'input[type="checkbox"], input[type="radio"]', function() {
					if ($('[staticmain]:checked').length == 0) {
						notify('Необходимо указать хотя бы один статик основным!', 'error');
					} else {
						userStaticsWin.wait();
						var staticPartData = {},
							staticLiderData = {},
							staticMainData = {};
						$('[userstaticschecks]').each(function() {
							var staticPart = $(this).find('[staticpart]'),
								staticLider = $(this).find('[staticlider]'),
								staticMain = $(this).find('[staticmain]'),
								staticPartId = $(staticPart).attr('staticpart'),
								staticLiderId = $(staticLider).attr('staticlider'),
								staticMainId = $(staticMain).attr('staticmain'),
								staticPartChecked = $(staticPart).is(':checked') ? 1 : 0,
								staticLiderChecked = $(staticLider).is(':checked') ? 1 : 0,
								staticMainChecked = $(staticMain).is(':checked') ? 1 : 0;
							
							staticPartData[staticPartId] = staticPartChecked;
							staticLiderData[staticLiderId] = staticLiderChecked;
							staticMainData[staticMainId] = staticMainChecked;
						});
						
						
						$.post('/admin/set_user_statics', {
							user_id: thisUserId,
							user_statics: {part: staticPartData, lider: staticLiderData, main: staticMainData}
						}, function(stat) {
							if (stat) $(thisInput).val(JSON.stringify({part: staticPartData, lider: staticLiderData, main: staticMainData}));
							else $(thisInput).val('');
							userStaticsWin.wait(false);
							//userStaticsWin.close();
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					}	
				});
				
			}, 'html').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Задать классы пользователя
	$('#users').on(tapEvent, '[setuserclasses]', function() {
		$(this).removeClass('error');
		var thisUserRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserclasses');
			thisInput = $(this).closest('td').find('input.user_statics'),
			thisUserName = $(thisUserRow).find('.user_nickname').val();
			
		popUp({
			title: '<small>Классы: <strong>'+thisUserName+'</strong></small>',
		    width: 500,
		    //buttons: [{id: 'buildUserStatics', title: 'Применить'}],
		    //closeButton: 'Закрыть',
		}, function(userClassesWin) {
			userClassesWin.wait();
			newSet = thisInput.val() ? JSON.parse(thisInput.val()) : false;
			
			$.post('/admin/get_users_classes', {user_id: thisUserId, newset: newSet}, function(html) {
				if (html) {
					userClassesWin.setData(html, false);
					$('#userClasses').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				} else {
					userClassesWin.setData('<p class="empty center">Нет данных</p>', false);
				}
				userClassesWin.wait(false);
				
				$('#userClasses').on('change', 'input[type="checkbox"]', function() {
					var thisStaticId = $(this).attr('classpart') || $(this).attr('classmentor'),
						thisItem = $(this)[0].hasAttribute('classpart') ? 'part' : 'mentor',
						classPart = $('[classpart="'+thisStaticId+'"]'),
						classMentor = $('[classmentor="'+thisStaticId+'"]');
					
					if (thisItem == 'part' && $(classPart).is(':checked') == false) {
						$(classMentor).removeAttrib('checked');
					}
					
					if (thisItem == 'mentor' && $(classMentor).is(':checked')) {
						$(classPart).setAttrib('checked');
					}
					
					userClassesWin.wait();
					var classPartData = {},
						classMentorData = {};
					$('[usersclasseschecks]').each(function() {
						var classPart = $(this).find('[classpart]'),
							classMentor = $(this).find('[classmentor]'),
							classPartId = $(classPart).attr('classpart'),
							classMentorId = $(classMentor).attr('classmentor'),
							classPartChecked = $(classPart).is(':checked') ? 1 : 0,
							classMentorChecked = $(classMentor).is(':checked') ? 1 : 0;
						
						classPartData[classPartId] = classPartChecked;
						classMentorData[classMentorId] = classMentorChecked;
					});
					
					
					$.post('/admin/set_user_classes', {
						user_id: thisUserId,
						user_classes: {part: classPartData, mentor: classMentorData}
					}, function(stat) {
						if (stat) $(thisInput).val(JSON.stringify({part: classPartData, mentor: classMentorData}));
						else $(thisInput).val('');
						userClassesWin.wait(false);
						//userStaticsWin.close();
					}, 'json').fail(function(e) {
						userClassesWin.wait(false);
						notify('Системная ошибка!', 'error');
						showError(e);
					});
				});
				
			}, 'html').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Персонажи пользователя
	$('#users').on(tapEvent, '[setuserpersonages]', function() {
		$(this).removeClass('error');
		var thisUserRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserpersonages');
			thisUserName = $(thisUserRow).find('.user_nickname').val();
			
		popUp({
			title: '<small>Персонажи: <strong>'+thisUserName+'</strong></small>',
		    width: 1000,
		    //buttons: [{id: 'userPersonagesSave', title: 'Сохранить', disabled: 1}],
		    closeButton: 'Закрыть'
		}, function(userPersonagesWin) {
			userPersonagesWin.wait();
			
			getAjaxHtml('admin/personages/get', {from_id: thisUserId, users_list: 1}, function(html) {
				userPersonagesWin.setData(html, false);
				$('#userPersonagesList').ddrScrollTableY({height: '80vh', wrapBorderColor: '#d7dbde'});
				
				$('#userPersonagesList').changeRowInputs(function(row, item) {
					$(row).addClass('changed');
					$('#userPersonagesSave').removeAttrib('disabled');
				});
				
				$('#userPersonagesSave').on(tapEvent, function() {
					userPersonagesWin.wait();
					var formData = new FormData($('#userPersonagesForm')[0]);
					
					$.ajax({
						type: 'POST',
						url: '/admin/personages/save',
						dataType: 'json',
						cache: false,
						contentType: false,
						processData: false,
						data: formData,
						success: function(r) {
							notify('Персонажи успешно сохранены!');
							userPersonagesWin.close();
						},
						error: function(e, status) {
							notify('Системная ошибка отправки данных!', 'error');
							showError(e);
						},
						complete: function() {
							userPersonagesWin.wait(false);
						}
					});
				});
				
			}, function() {
				userPersonagesWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Задать данные верифицированных пользователей
	$('#usersSave').on(tapEvent, function() {
		var usersData = [];
		if ($('[tabid="verifyUsers"]').find('tbody tr.changed').length == 0) {
			notify('Нет данных для сохранения!', 'info');
			return false;
		}
		
		$('[tabid="verifyUsers"]').find('tbody tr.changed').each(function() {
			var thisRow = $(this),
				thisUserId = $(this).attr('userid'),
				thisUserColor = $(thisRow).find('.user_color'),
				thisUserNickname = $(thisRow).find('.user_nickname'),
				thisUserRegDate = $(thisRow).find('.user_reg_date').attr('date') || false,
				thisUserStage = $(thisRow).find('.user_stage'),
				thisUserPayment = $(thisRow).find('.user_payment'),
				thisUserPaymentOrigin = $(thisRow).find('.user_payment_origin'),
				thisUserBirthday = $(thisRow).find('.user_birthday').attr('date') || false,
				thisUserDepositPercent = $(thisRow).find('.user_deposit_percent'),
				thisUserRole = $(thisRow).find('.user_role'),
				thisUserAccess = $(thisRow).find('.user_access');
			
			var user = {
				id: thisUserId,
				color: $(thisUserColor).val(),
				nickname: $(thisUserNickname).val(),
				reg_date: thisUserRegDate,
				stage: thisUserStage.val(),
				payment: $(thisUserPayment).val(),
				payment_origin: $(thisUserPaymentOrigin).val(),
				birthday: thisUserBirthday,
				deposit_percent: $(thisUserDepositPercent).val(),
				role: $(thisUserRole).val(),
				access: $(thisUserAccess).val()
			}
			
			usersData.push(user);
		});
		
		
		$.ajax({
			type: 'POST',
			url: '/admin/set_users_data',
			dataType: 'json',
			data: {users: usersData},
			success: function(response) {
				if (response) {
					renderSection({field: thisField, order: thisOrder});
					notify('Данные пользователей обновлены!');
				} else {
					notify('Ошибка!', 'error');
				}
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	

	
	
	
	
	
	
	
	//-------------------------------------------------------------- Верифицировать, обновить или восстановить пользователя
	$('#users').on(tapEvent, '[setuserdata]', function() {
		var thisRow = $(this).closest('tr'),
			thisUserId = $(this).attr('setuserdata'),
			thisUserRegDate = $(thisRow).find('.user_reg_date').attr('date') || false,
			thisUserStage = $(thisRow).find('.user_stage'),
			thisUserPayment = $(thisRow).find('.user_payment'),
			thisUserNickname = $(thisRow).find('.user_nickname'),
			thisUserColor = $(thisRow).find('.user_color'),
			thisUserBirthday = $(thisRow).find('.user_birthday').attr('date') || false,
			thisUserStatics = $(thisRow).find('.user_statics'),
			//thisUserAccessLevel = $(thisRow).find('.user_access_level'),
			thisUserRole = $(thisRow).find('.user_role'),
			verification = $(thisRow).find('.recovery_user').length ? ($(thisRow).find('.recovery_user').is(':checked') ? 1 : 0) : 1,
			stat = true;
		
		
		if (verification && !$(thisUserStatics).val()) {
			$(thisUserStatics).closest('td').find('button').addClass('error');
			notify('Необходимо задать как минимум, один статик!', 'info');
			stat = false;
		}
		
		/*if (! $(thisUserAccessLevel).val()) {
			$(thisUserAccessLevel).addClass('error');
			notify('Необходимо выбрать ранг', 'error');
			stat = false;
		}*/
		
		
		
		if (verification && !$(thisUserRole).val()) {
			$(thisUserRole).addClass('error');
			notify('Необходимо выбрать роль', 'error');
			stat = false;
		}
		
			
		if (stat) {
			$.post('/admin/set_user_data', {
				verification: verification,
				user_id: thisUserId,
				user_nickname: $(thisUserNickname).val(),
				user_color: $(thisUserColor).val(),
				//user_access_level: $(thisUserAccessLevel).val(),
				user_role: $(thisUserRole).val(),
				user_payment: $(thisUserPayment).val(),
				user_birthday: thisUserBirthday,
				user_reg_date: thisUserRegDate,
				user_stage: thisUserStage.val()
			}, function(response) {
				if (response) {
					renderSection({field: thisField, order: thisOrder});
					notify('Пользователь успешно верифицирован!');
				} else {
					notify('Ошибка!', 'error');
				}
			}, 'json').fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		}
	});
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Вернуть исключенного участника
	$('body').off(tapEvent, '[includeuser]').on(tapEvent, '[includeuser]', function() {
		let userId = $(this).attr('includeuser');
		$.post('/admin/include_user', {id: userId}, function(response) {
			if (response) {
				notify('Участник успешно восстановлен!');
				renderSection({field: thisField, order: thisOrder});
			} else {
				notify('Ошибка восстановления участника!', 'error');
			}
		});
	});
	
	
	
	
	
	

	//-------------------------------------------------------------- Пометить участника как удаленного
	$('body').off(tapEvent, '[deleteuser]').on(tapEvent, '[deleteuser]', function() {
		var thisItem = this;
		popUp({
			title: 'Удалить участника?',
		    width: 500,
		    closeButton: 'Отмена',
		}, function(deleteUserWin) {
			
			deleteUserWin.setData('admin/get_delete_user_form', function() {
				
				$('[deleteuserbtn]').on(tapEvent, function() {
					let type = $(this).attr('deleteuserbtn');
					if (type == 'exclude') {
						let thisUserId = $(thisItem).attr('deleteuser');
						$.post('/admin/exclude_user', {id: thisUserId}, function(response) {
							if (response) {
								notify('Участник отстранен!');
								renderSection({field: thisField, order: thisOrder});
							} else {
								notify('Ошибка отстранения участника!', 'error');
							}
							deleteUserWin.close();
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
							deleteUserWin.close();
						});
					} else if (type == 'delete') {
						let thisUserId = $(thisItem).attr('deleteuser');
						$.post('/admin/delete_user', {id: thisUserId}, function(response) {
							if (response) {
								notify('Участник удален!');
								renderSection({field: thisField, order: thisOrder});
							} else {
								notify('Ошибка удаления участника!', 'error');
							}
							deleteUserWin.close();
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
							deleteUserWin.close();
						});
					}
				});
			});
				
		});
	});
	
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Резерв
	$('#depositTables').find('thead').on(tapEvent, function() {
		var closed = $(this).siblings('tbody').attr('hidden') ? true : false;
		if (!closed) {
			$(this).siblings('tbody').setAttrib('hidden');
		} else {
			$('#depositTables').find('tbody').setAttrib('hidden');
			$(this).siblings('tbody').removeAttrib('hidden');
		}
	});
	
	
	let depositUsersTOut;
	$('[deposituserslist]').changeRowInputs(function(row, item) {
		clearTimeout(depositUsersTOut);
		depositUsersTOut = setTimeout(function() {
			let userId = parseFloat($(row).find('.deposit_user_id').val()),
				payment = $(row).find('.deposit_user_payment').val(),
				paymentOrigin = $(row).find('.deposit_user_payment_origin').val(),
				deposit = parseFloat($(row).find('.deposit_user_deposit').val()),
				depositOrigin = parseFloat($(row).find('[originval]').attr('originval'));
			
			$.post('/admin/deposit_update', {
				id: userId,
				payment: payment,
				payment_origin: paymentOrigin,
				deposit: deposit,
				deposit_origin: depositOrigin
			}, function(response) {
				if (response) {
					$(row).addClass('changed');
					//notify('Резервы успешно сохранены!');
					//$('[deposituserslist]').find('tr.changed').removeClass('changed');
					//renderSection();
				}
			}).fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		}, 300);
	});
	
	
	/*$('#depositUsersList').on(tapEvent, function() {
		var depositUpdateData = [];
		if ($('[deposituserslist]').find('tr.changed').length > 0) {
			$('[deposituserslist]').find('tr.changed').each(function() {
				var thisUserId = parseFloat($(this).find('.deposit_user_id').val()),
					thisPayment = $(this).find('.deposit_user_payment').val(),
					thisDeposit = parseFloat($(this).find('.deposit_user_deposit').val()),
					thisDepositOrigin = parseFloat($(this).find('[originval]').attr('originval'));
				depositUpdateData.push({
					id: thisUserId,
					payment: thisPayment,
					deposit: thisDeposit,
					deposit_origin: thisDepositOrigin
				});
			});
			
			$.post('/admin/deposit_update', {deposit: depositUpdateData}, function(response) {
				if (response) {
					notify('Резервы успешно сохранены!');
					$('[deposituserslist]').find('tr.changed').removeClass('changed');
					renderSection();
				}
			}).fail(function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			});
		} else {
			notify('Нет данных для сохранения', 'info');
		}
	});*/
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------- Баланс
	$('#resetBalance').on(tapEvent, function() {
		$.post('/admin/reset_balance', function(response) {
			if (response) {
				notify('Баланс успешно списан!');
				renderSection();
			}
		}).fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	
	
	
	
	$('[setusernda]').on(tapEvent, function() {
		let userId = $(this).attr('setusernda'),
			isChecked = $(this).is(':checked');
		
		$.post('/admin/change_nda_stat', {user_id: userId, stat: isChecked}, function(response) {
			if (response) {
				notify('NDA статус успешно изменен!');
			} else {
				notify('Ошибка изменения NDA статуса!', 'error');
			}
		}).fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	
	
});

//--></script>