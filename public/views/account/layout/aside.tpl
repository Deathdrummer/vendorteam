<aside class="leftblock" id="accountLeftBlock">
	<div class="leftblock__block leftblock__block_top mb-2 mb-md-3" id="accountTopBlock">
		<div class="leftblock__avatar mb-2">
			{% if avatar %}
				<img useravatarimg src="public/images/users/{{avatar}}?{{time()}}" alt="">
			{% else %}
				<img useravatarimg src="public/images/user.jpg" alt="">
			{% endif %}
			<button class="leftblock__changebutton" id="changeAvatar">Изменить</button>
		</div>
		
		<p class="leftblock__nickname">
			<span accountnickname>{{nickname|default('Не задано')}}</span>
			<i class="fa fa-edit" id="changeNickname"></i>
		</p>
		
		<ul class="leftblock__infolist">
			<li class="nowrap"><span>Способ оплаты:</span> <strong title="{{payment|default('Не задан')}}">{{payment|default('Не задан')}}</strong></li>
			<li><span>Роль:</span> <strong>{{role|default('Не задана')}}</strong></li>
			<li><span>Звание:</span> 
				<strong>
					{% if rank.rank_name %}
						{{rank.rank_name}}
					{% else %}
						Не задано
					{% endif %}
				</strong>
			</li>
			{% if rank.next_rank is defined and rank.next_rank is not empty and rank.rank_name is not empty %}
				<li><span title="Следующее звание">След. зв.:</span> <strong>{{rank.next_rank.next_rank}}</strong> <sup>({{rank.next_rank.count_days}} дн.)</sup></li>
			{% endif %}
			<li><span>Резерв:</span> <strong>{{deposit|number_format(2, '.', ' ')}} руб.</strong></li>
			
			{% if id in [2,21] %}
				<li myrating class="pointer"><span>Рейтинг:</span> <strong>{{rating|default('Нет рейтинга')}}</strong></li>
			{% endif %}
			
			<li>
				<div class="row gutters-5 justifн-content-evenly">
					{% if statistics_setting[main_static]['access'] == 1 %}
					<div class="col-3">
						<a class="link" showstatistics title="Посмотреть статистику">
							<div class="icon icon_stat"></div>
							<div>
								<span>статистика</span>
								{#<small>рейд-лидера</small>#}
							</div>
						</a>
					</div>
					{% endif %}
					
					{% if is_lider %}
					<div class="col-3">
						<a class="link" href="{{raidliderreport_setting}}" target="_blank" title="Перейти к отчету">
							<div class="icon icon_table"></div>
							<div>
								<span>Отчет</span>
								{#<small>рейд-лидера</small>#}
							</div>
						</a>
					</div>
					{% endif %}
					
					{% if not access or access.links.paydata %}
					<div class="col-3">
						<a class="link" href="{{paydataformlink_setting}}" target="_blank" title="Заполнить форму">
							<div class="icon icon_table"></div>
							<div>
								<span>Платежные данные</span>
								{#<small>рейд-лидера</small>#}
							</div>
						</a>
					</div>
					{% endif %}

					{#{% if not access or access.links.mentors %}
					<div class="col-3">
						<a class="link" title="Мой рейтинг">
							<div class="icon icon_table"></div>
							<div>
								<span>Рейтинг</span>
							</div>
						</a>
					</div>
					{% endif %}#}
				</div>
			</li>
		</ul>
		
		<div class="leftblock__logout">
			<button logout title="Выйти из личного кабинета"><i class="fa fa-sign-out"></i>Выход</button>
			<button class="small" resign title="Создать заявку на увольнение"><i class="fa fa-user-times"></i>Уволиться</button>
		</div>
		
	</div>
	<div class="leftblock__block leftblock__block_navblock" id="accountNavBlock">
		<div class="leftblock__nav noselect">
			{% if is_verify_user %}
				<ul>
					{#<li hidden><svg><use xlink:href="#notifications"></use></svg><span>Уведомление</span><i>1</i></li>
					<li hidden><svg><use xlink:href="#message"></use></svg><span>Cообщение</span><i>2</i></li>#}
					{% if not access or access.nav.guides %}<li><a href="account/guides"><svg><use xlink:href="#book"></use></svg><span>Образование</span></a></li>{% endif %}
					{#<li hidden><svg><use xlink:href="#vacation"></use></svg><span>Отпуск</span></li>
					<li hidden><svg><use xlink:href="#profile"></use></svg><span>Соло заказы</span></li>#}
					{% if not access or access.nav.timesheet %}<li timesheetperiodbutton><svg><use xlink:href="#calendar"></use></svg><span>Расписание</span></li>{% endif %}
					{% if not access or access.nav.wallet %}<li reportpatternsbutton><svg><use xlink:href="#wallet"></use></svg><span>Выплаты</span></li>{% endif %}
					{% if not access or access.nav.information %}<li importantinfo><svg><use xlink:href="#information"></use></svg><span>Важная информация</span></li>{% endif %}
					{% if not access or access.nav.operators %}<li operators><svg><use xlink:href="#information"></use></svg><span>Операторы</span></li>{% endif %}
					{% if role and statics|length > 0 %}
						{% if not access or access.nav.offtime %}<li getofftime><svg><use xlink:href="#weekend"></use></svg><span>Выходные</span></li>{% endif %}
						{% if not access or access.nav.vacation %}<li getvacation><svg><use xlink:href="#vacation"></use></svg><span>Отпуск</span></li>{% endif %}
					{% endif %}
					{% if not access or access.nav.personages %}<li getpersonages><svg><use xlink:href="#weekend"></use></svg><span>Мои персонажи</span></li>{% endif %}
					{% if not access or access.nav.paymentorders %}<li paymentorders><svg><use xlink:href="#weekend"></use></svg><span>Мои заявки</span></li>{% endif %}
					{% if not access or access.nav.visitsrate %}<li visitsrate><svg><use xlink:href="#weekend"></use></svg><span>Моя посещаемость</span></li>{% endif %}
				</ul>	
			{% endif %}
		</div>
	</div>
	<div class="leftblock__block leftblock__block_bottom mt-2 mt-md-3{% if not is_verify_user %} p-0{% endif %}" id="accountBottomBlock">
		<div class="leftblock__nav leftblock__nav_bottom noselect">
			{% if is_verify_user %}
				<ul>
					{% if skype_login_setting and (not access or access.navdown.skype) %}
						<li class="link">
							<a href="skype:{{skype_login_setting}}?chat">
								<div class="d-flex">
									<svg><use xlink:href="#skype"></use></svg>
									<div>
										<span>{{skype_title_setting}}</span>
										<small>{{skype_text_setting}}</small>
									</div>
								</div>
								
							</a>
						</li>
					{% endif %}
					
					{% if not access or access.navdown.complaints %}
						{% include 'views/account/render/payment_order.tpl' %}
					{% endif %}
					
					{% if not access or access.navdown.message %}<li onclick="window.open('{{callbackform_setting}}')"><svg><use xlink:href="#message"></use></svg><span>Форма для обращений</span></li>{% endif %}
					{#{% include 'views/account/render/complaints.tpl' %}#}
				</ul>
			{% endif %}
		</div>
	</div>
</aside>