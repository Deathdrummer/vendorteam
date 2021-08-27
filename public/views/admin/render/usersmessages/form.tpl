<div class="usersmessages" id="usersMessageForm">
	
	<div class="usersmessages__users" id="usersFormBlock">
		{% if message.to %}
			{% for staticId, usersList in message.to %}
				<div usersmessagesstaticcontainer>
					<p class="fz12px mb3px" usersmessagesstaticname><strong>{{statics[staticId]}}</strong></p>
					{% if usersList %}
						<div class="drow dgutter-10">
							{% for uId, user in usersList %}
								{% if user.stat is not defined or user.stat == 0 %}
									<div class="dcol-14" usersmessagesuserblock>
										<div class="usersmessages__user usersmessagesuser" usersmessagesuserremove title="Удалить {{user.nickname}}">
											<input type="hidden" name="users[]" messuser value="{{uId}}">
											<div class="usersmessagesuser__avatar">
												<img src="{{base_url('public/images/users/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}" class="avatar w100 h50px">
												{# {% if user.stat == 0 %}
													<div class="usersmessagesuser__stat usersmessagesuser__stat_wait">
														<i class="fa fa-times"></i>
													</div>
												{% endif %} #}
											</div>
											<p class="fz11px mt3px text-center text-overflow">{{user.nickname}}</p>
										</div>
									</div>
								{% elseif user.stat == 1 %}
									<div class="dcol-14" usersmessagesuserblock>
										<div class="usersmessages__user usersmessagesuser" title="{{user.nickname}} - Прочитано">
											<input type="hidden" name="users[]" value="{{uId}}">
											<div class="usersmessagesuser__avatar usersmessagesuser__avatar_disabled">
												<img src="{{base_url('public/images/users/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}" class="avatar w100 h50px">
												<div class="usersmessagesuser__stat usersmessagesuser__stat_done">
													<i class="fa fa-check"></i>
												</div>
											</div>
											<p class="fz11px mt3px text-center text-overflow">{{user.nickname}}</p>
										</div>
									</div>
								{% endif %}
							{% endfor %}
						</div>
					{% endif %}
				</div>
			{% endfor %}
		{% endif %}	
	</div>
	
	<div class="usersmessages__title mb20px">
		<p class="fz14px mb4px">Заголовок сообщения</p>
		<div class="popup__field">
			<input type="text" id="usersMessageTitle" rules="empty" name="title" value="{{message.title}}" placeholder="Введите название" autocomplete="off">
		</div>
	</div>
		
	<div class="usersmessages__message">
		<div class="d-flex align-items-center justify-content-between">
			<p class="fz14px mb4px">Сообщение</p>
			<i id="codeMap" class="fa fa-code pointer fz20px" title="Карта кода"></i>
		</div>
		
		<textarea id="usersMessage" hidden>{{message.message}}</textarea>
		{% if edit %}
			<input type="hidden" name="_usersmessagehidden" rules="empty" id="usersMessageHidden" value="{{message.message}}">
		{% endif %}
	</div>
</div>