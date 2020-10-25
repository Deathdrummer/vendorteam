<div class="popup__title">
	<h6>Расписание приемных часов</h6>
</div>
<div class="popup__data">
	<div class="operators">
		<div class="drow p-2">
			{% if operators %}
				{% for operatorId, operator in operators %}
					<div class="dcol-1 dcol-sm-2 dcol-md-3 dcol-lg-5 dcol-xl-6 mb-3">
						<div class="operator">
							<div class="operator__top">
								<div class="operator__image">
									<img src="public/images/operators/{{operator.avatar}}" alt="">
								</div>
								<p class="operator__nickname">{{operator.nickname}}</p>
								<div class="operator__stat"></div>
							</div>
							<div class="operator__bottom">
								<div class="operator__timesheet">
									{% if operator.hourssheet %}
										{% if operator.hourssheet.today %}
											<ul>
												<li class="title">Сегодня <span>{{date('d.m')}}</span></li>
												{% for item in operator.hourssheet.today %}
													<li>{{item.h_start|add_zero}}:{{item.m_start|add_zero}} - {{item.h_end|add_zero}}:{{item.m_end|add_zero}}</li>
												{% endfor %}
											</ul>
										{% endif %}
										
										{% if operator.hourssheet.tomorrow %}
											<ul>
												<li class="title">Завтра <span>{{date('d.m', time() + 86400)}}</span></li>
												{% for item in operator.hourssheet.tomorrow %}
													<li>{{item.h_start|add_zero}}:{{item.m_start|add_zero}} - {{item.h_end|add_zero}}:{{item.m_end|add_zero}}</li>
												{% endfor %}
											</ul>
										{% endif %}
									{% else %}	
										<p class="empty">Записи нет</p>
									{% endif %}
								</div>
								<div class="operator__buttons">
									<button operatorsendmess="{{operatorId}}|{{operator.nickname}}|mess">Написать</button>
									<button operatorsendcomplain="{{operatorId}}|{{operator.nickname}}|complain">Пожаловаться</button>
								</div>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty center">Нет активных операторов</p>
			{% endif %}
		</div>
	</div>
</div>


		