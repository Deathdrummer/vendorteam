<aside class="leftblock" id="accountLeftBlock">
	<div class="leftblock__block leftblock__block_top mb-2 mb-md-3" id="accountTopBlock">
		<div class="d-flex justify-content-between">
			<div class="leftblock__avatar mb-2">
				{% if is_resignation and resign_notify %}
					<div class="resign"><i class="fa fa-user-times" title="Уволен"></i></div>
				{% endif %}
				
				{% if avatar %}
					<img useravatarimg src="public/images/users/{{avatar}}?{{time()}}" alt="">
				{% else %}
					<img useravatarimg src="public/images/user.jpg" alt="">
				{% endif %}
				<button class="leftblock__changebutton" id="changeAvatar">Изменить</button>
			</div>
			
			<div class="leftblock__icons">
				<div class="leftblocktopicon" newmessages title="Сообщения от администрации">
					<svg newmessage class="w30px h30px"><use xlink:href="#message"></use><span class="leftblocktopicon__counter" newmessagecounter></span></svg>
				</div>
				
				
				<div class="leftblocktopicon" getgifts title="Подарки">
					<i class="fa fa-gift"></i>
					<span class="leftblocktopicon__counter" giftscounter></span>
				</div>
				
				<div class="leftblocktopicon" getpollings title="Опросы">
					<svg class="w30px h40px"><use xlink:href="#polling"></use><span class="leftblocktopicon__counter" pollingcounter></span></svg>
				</div>
				
				{# <div class="leftblocktopicon leftblocktopicon_active">
					<i class="fa fa-gift"></i>
					<span class="leftblocktopicon__counter">5</span>
				</div> #}
			
			
			
				{# <div class="newmessage" hidden title="Есть новые письма">
					<svg newmessage class="w30px h30px tada infinite animated animated5s pointer"><use xlink:href="#message"></use><span class="newmessage__counter" newmessagecounter></span></svg>
				</div>
				
				<div class="tadainterval infinite animated animated5s h22px" getgifts title="Получить подарки">
					
				</div> #}
			</div>
		</div>
			
		<p class="leftblock__nickname">
			<span accountnickname>{{nickname|default('Не задано')}}</span>
			<i class="fa fa-edit" id="changeNickname" title="Редактировать мои данные"></i>
		</p>
		
		<ul class="leftblock__infolist">
			<li class="nowrap"><span title="Способ оплаты">Сп. опл.:</span> <strong class="fz14px" userpaymentdata>{{payment|default('Не задан')}}</strong></li>
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
			<li><span>Мой резерв:</span> <strong>{{deposit|number_format(2, '.', ' ')}} руб.</strong></li>
			
			<li walletbalance class="pointer"><span>Мой баланс:</span> <strong>{{balance|number_format(2, '.', ' ')}} руб.</strong> <sup>NDA {% if nda %}<i class="fa fa-check"></i>{% else %}<i class="fa fa-ban"></i>{% endif %}</sup></li>
			
			{% if id in [2,21] %}
				<li myrating class="pointer"><span>Рейтинг:</span> <strong>{{rating|default('Нет рейтинга')}}</strong></li>
			{% endif %}
			
			<li hidden>
				<div class="row gutters-5 justify-content-evenly">
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
			{#{% if not is_resignation %}<button class="small" resign title="Создать заявку на увольнение"><i class="fa fa-user-times"></i>Уволиться</button>{% endif %}#}
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
					{% if not access or access.nav.kpi %}<li mykpiplan><svg><use xlink:href="#weekend"></use></svg><span>Мой KPI план</span></li>{% endif %}
				</ul>	
			{% endif %}
		</div>
	</div>
	
	<div class="leftblock__block leftblock__block_icons mt-2 mt-md-3">
		<ul class="drow dgutter-10">
			{% if notionlink_setting %}
				<li class="dcol-5"><a href="{{notionlink_setting}}" target="_blank" title="Notion"><img src="{{base_url('public/images/navicons/icon_notion.png')}}" alt=""></a></li>
			{% endif %}
			
			{% if screenshot %}
				<li class="dcol-5"><a href="{{screenshot}}" target="_blank" title="Скриншот"><img src="{{base_url('public/images/navicons/icon_screenshot.png')}}" alt=""></a></li>
			{% endif %}
			
			{% if paydataformlink_setting %}
				<li class="dcol-5"><a href="{{paydataformlink_setting}}" target="_blank" title="Заполнить форму"><img src="{{base_url('public/images/navicons/icon_paydata.png')}}" alt=""></a></li>
			{% endif %}
			
			{% if psyhologylink_setting %}
				<li class="dcol-5"><a href="{{psyhologylink_setting}}" target="_blank" title="Запись к Психологу"><img src="{{base_url('public/images/navicons/icon_psyhology.png')}}" alt=""></a></li>
			{% endif %}
			
			{% if raidliderreport_setting and is_lider %}
				<li class="dcol-5"><a href="{{raidliderreport_setting}}" target="_blank" title="Перейти к отчету"><img src="{{base_url('public/images/navicons/icon_report.png')}}" alt=""></a></li>
			{% endif %}
			{#<li><img src="{{base_url('public/images/navicons/icon_paydata.png')}}" alt=""></li>#}
		</ul>
	</div>
	
	
	<div class="leftblock__block leftblock__block_bottom{% if not is_verify_user %} p-0{% endif %}" id="accountBottomBlock">
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
						<li paymentorder><svg><use xlink:href="#complaints"></use></svg><span>{{button_left_title_setting}}</span></li>
						{#{% include 'views/account/render/payment_order.tpl' %}#}
					{% endif %}
					
					{% if not access or access.navdown.message %}<li onclick="window.open('{{callbackform_setting}}')"><svg><use xlink:href="#message"></use></svg><span>Обращение в Support отдел</span></li>{% endif %}
					{#{% include 'views/account/render/complaints.tpl' %}#}
				</ul>
			{% endif %}
		</div>
	</div>
</aside>