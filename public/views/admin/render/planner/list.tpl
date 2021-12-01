{% if items %}
	<div class="planner__items">
		<div class="drow dgutter-10">
			{% for k, day in items %}
				<div class="dcol-7 planner__item">
					{% if day %}
						<div class="planneritem{% if current == day %} planneritem_current{% endif %}">
							<span class="planneritem__date">{{day|d}}</span>
							<div class="planner__data">
								{% if data[day|date('j')] %}
									<div class="plannerlist">
										{% for user in data[day|date('j')] %}
											<div class="d-flex align-items-center" planneruser>
												<img src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="" class="avatar h30px w30px">
												<p class="ml4px fz12px" plannerusername>{{user.nickname}}</p>
												<div class="ml-auto d-flex align-items-center">
													<i class="fa fa-envelope fz14px fontcolor fontcolor_hovered" plannersendmessbtn="{{user.id}}" title="Отправить сообщение"></i>
												</div>
											</div>
										{% endfor %}
									</div>
								{% endif %}
							</div>
						</div>
					{% endif %}	
				</div>
			{% endfor %}
		</div>
	</div>
{% endif %}