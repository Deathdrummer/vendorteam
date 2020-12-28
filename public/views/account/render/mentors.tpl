<div class="popup__data">
	<ul class="tabstitles">
		<li id="tabMentorsInner" noroute class="active"><p>Мой состав</p></li>
		<li id="tabMentorsOuter" noroute><p>Общий список</p></li>
	</ul>
	
	<div class="tabscontent">
		<div tabid="tabMentorsInner" class="visible">
			{% if mentors.inner %}
				<div class="mentors">
					<table class="popup__table">
						<thead>
							<tr>
								<td class="w70px">Рейтинг</td>
								<td>Участник</td>
								<td class="w200px">Статики</td>
								<td class="w200px">Классы</td>
								<td class="w45px"></td>
							</tr>
						</thead>
						<tbody>
							{% for mentor in mentors.inner %}
								<tr>
									<td class="center">1.00</td>
									<td>
										<div class="mentor" userid="{{mentor.id}}">
											<div class="mentor__image" style="background-image: url({{base_url('public/images/')}}{% if mentor.avatar %}users/{{mentor.avatar}}{% else %}user_mini.jpg{% endif %})">
											</div>
											<div class="mentor__name mr-auto">
												<strong>{{mentor.nickname}}</strong>
												<span>{{mentor.role}}</span>
												<span>{{mentor.rank}}</span>
											</div>
										</div>
									</td>
									<td class="aligntop">
										{% if mentor.statics %}
											<div class="mentor__list">
												{% for static in mentor.statics %}
													<small>{{static.name}}</small>
												{% endfor %}
											</div>
										{% endif %}
									</td>
									<td class="aligntop">
										{% if mentor.classes %}
											<div class="mentor__list mentor__list_mentors">
												{% for cls in mentor.classes %}
													<small 
														class="item{% if cls.mentor_to_me %} mentor_to_me {% elseif cls.mentor %} mentor{% endif %}"
														title="{% if cls.mentor_to_me %} Наставник моего класса {% elseif cls.mentor %} Наставник{% endif %}">
														{{cls.name}}
													</small>
												{% endfor %}
											</div>
										{% endif %}
									</td>
									<td>
										<div class="buttons">
											<button{% if mentor.classes_to_me is not iterable %} disabled{% endif %} class="small w34px main pl-0 pr-0" choosementor="{{mentor.classes_to_me|json_encode}}"><i class="fa fa-check"></i></button>
										</div>
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
			{% else %}
				<p class="empty center">Нет данных</p>
			{% endif %}
		</div>
		<div tabid="tabMentorsOuter">
			{% if mentors.outer %}
				<div class="mentors">
					<table class="popup__table">
						<thead>
							<tr>
								<td class="w70px">Рейтинг</td>
								<td>Участник</td>
								<td class="w200px">Статики</td>
								<td class="w200px">Классы</td>
								<td class="w45px"></td>
							</tr>
						</thead>
						<tbody>
							{% for mentor in mentors.outer %}
								<tr>
									<td class="center">1.00</td>
									<td>
										<div class="mentor" userid="{{mentor.id}}">
											<div class="mentor__image" style="background-image: url({{base_url('public/images/')}}{% if mentor.avatar %}users/{{mentor.avatar}}{% else %}user_mini.jpg{% endif %})">
											</div>
											<div class="mentor__name mr-auto">
												<strong>{{mentor.nickname}}</strong>
												<span>{{mentor.role}}</span>
												<span>{{mentor.rank}}</span>
											</div>
										</div>
									</td>
									<td class="aligntop">
										{% if mentor.statics %}
											<div class="mentor__list">
												{% for static in mentor.statics %}
													<small>{{static.name}}</small>
												{% endfor %}
											</div>
										{% endif %}
									</td>
									<td class="aligntop">
										{% if mentor.classes %}
											<div class="mentor__list mentor__list_mentors">
												{% for cls in mentor.classes %}
													<small 
														class="item{% if cls.mentor_to_me %} mentor_to_me {% elseif cls.mentor %} mentor{% endif %}"
														title="{% if cls.mentor_to_me %} Наставник моего класса {% elseif cls.mentor %} Наставник{% endif %}">
														{{cls.name}}
													</small>
												{% endfor %}
											</div>
										{% endif %}
									</td>
									<td>
										<div class="buttons">
											<button{% if mentor.classes_to_me is not iterable %} disabled{% endif %} class="small w34px main pl-0 pr-0" choosementor="{{mentor.classes_to_me|json_encode}}"><i class="fa fa-check"></i></button>
										</div>
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
			{% else %}
				<p class="empty center">Нет данных</p>
			{% endif %}
		</div>
	</div>
</div>