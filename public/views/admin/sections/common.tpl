<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Общие настройки</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	
	<ul class="tabstitles">
		<li id="common">Главное</li>
 		<li id="fieldsPay">Поля для формы оплаты</li>
		<li id="fieldsComplaints">Поля для предложений и жалоб</li>
		<li id="usersListPay">Список "Заказ Оплаты"</li>
		<li id="usersListComplaints">Список "Предложения и Жалобы"</li>
		<li id="resignsList">Заявки на увольнение</li>
		<li id="constants">Константы</li>
		<li id="agreement">Договор</li>
		<li id="importantInfo">Важная информация</li>
		<li id="commonMessage">Cообщение для НЕверифицированных</li>
		<li id="skype">Скайп</li>
		<li id="links">Ссылки</li>
	</ul>
	
	
	<div class="tabscontent">
		<div tabid="common">
			<h3>Главное</h3>
			
			<fieldset>
				<legend>SEO</legend>
				
				{% include form~'field.tpl' with {'label': 'Заголовок сайта', 'name': 'site_title', 'class': 'w30'} %}
				{% include form~'field.tpl' with {'label': 'Meta keywords', 'name': 'meta_keywords', 'class': 'w100'} %}
				{% include form~'field.tpl' with {'label': 'Meta description', 'name': 'meta_description', 'class': 'w100'} %}
				
			</fieldset>
			
			
			<fieldset>
				<legend>Элементы главной страницы</legend>
				
				
				{% include form~'field.tpl' with {'label': 'Основной заголовок', 'name': 'page_title', 'class': 'w30'} %}
				{% include form~'textarea.tpl' with {'label': 'Описание под заголовком', 'name': 'page_title_text', 'class': 'w30'} %}
				
				{% include form~'field.tpl' with {'label': 'Кнопка левая', 'name': 'button_left_title', 'class': 'w30'} %}
				{% include form~'textarea.tpl' with {'label': 'Текст под левой кнопкой', 'name': 'button_left_text', 'class': 'w50'} %}
				{% include form~'field.tpl' with {'label': 'Заголовок левого окна', 'name': 'left_popup_title', 'class': 'w30'} %}
				
				{% include form~'field.tpl' with {'label': 'Кнопка правая', 'name': 'button_right_title', 'class': 'w30'} %}
				{% include form~'textarea.tpl' with {'label': 'Текст под правой кнопкой', 'name': 'button_right_text', 'class': 'w50'} %}
				{% include form~'field.tpl' with {'label': 'Заголовок правого окна', 'name': 'right_popup_title', 'class': 'w30'} %}
				
				{% include form~'field.tpl' with {'label': 'Сообщение после отправки заявки', 'name': 'popup_success', 'class': 'w30'} %}
				{% include form~'file.tpl' with {'label': 'Фоновая картинка', 'name': 'page_image', 'ext': 'jpg'} %}
			</fieldset>
			
			
			
			<fieldset>
				<legend>Контактные данные</legend>
				
				{% include form~'field.tpl' with {'label': 'Заголовок письма', 'name': 'email_title', 'class': 'w30'} %}
				{% include form~'field.tpl' with {'label': 'E-mail (от кого)', 'name': 'email_from', 'class': 'w20'} %}
				{% include form~'field.tpl' with {'label': 'E-mail (куда отправлять)', 'name': 'email_to', 'class': 'w20'} %}
				
			</fieldset>
			
			
			
			<fieldset>
				<legend>Настройки окон ("заказ оплаты" и "предложения и жалобы")</legend>
				
				{% include form~'field.tpl' with {'label': 'Ширина окна', 'name': 'popup_width', 'class': 'w10'} %}
				{% include form~'textarea.tpl' with {'label': 'Текст во всплывающей форме заполнения данных пользователем', 'name': 'new_user_popup_text', 'class': 'w50'} %}
				
			</fieldset>
			
			
			<fieldset>
				<legend>Заявки на увольнение</legend>
				
				{% include form~'textarea.tpl' with {'label': 'Текст во всплывающей форме заяки на увольнение', 'name': 'resign_popup_text', 'class': 'w50'} %}
				
			</fieldset>
			
			
			<fieldset>
				<legend>Пользователи - исключения</legend>
				
				{% include form~'textarea.tpl' with {'label': 'Новый рейд (никнеймы)', 'name': 'admin_users', 'placeholder': 'Список в столбик', 'class': 'w30'} %}
				
			</fieldset>
			
			

			<fieldset>
				<legend>Авторизация в админ. панели</legend>
				
				{% include form~'field.tpl' with {'label': 'Новый логин', 'name': 'auth_login', 'placeholder': 'Назначьте логин', 'default': '', 'class': 'w20'} %}
				{% include form~'field.tpl' with {'label': 'Новый пароль', 'name': 'auth_pass', 'type': 'password', 'placeholder': 'Назначьте пароль', 'default': '', 'class': 'w20'} %}
				{% include form~'field.tpl' with {'label': 'Секретный ключ', 'name': 'secret_key', 'type': 'password', 'placeholder': 'Секретный ключ', 'default': '', 'class': 'w20'} %}
				
			</fieldset>
		</div>
		
		
		
		
		<div tabid="fieldsPay">
			<h3>Поля для формы оплаты</h3>
			
			<fieldset>
				<legend>Список полей</legend>
				
				<div class="list" id="fieldsPayBlock">
					{% if fields_pay_setting|length > 0 %}
						{% for i in fields_pay_setting|keys %}
							<div class="list_item">
								<div class="block">
									<title>{{i}}</title>
									
									{% include form~'field.tpl' with {'label': 'Лэйбл', 'name': 'fields_pay|'~i~'|label'} %}
									{% include form~'field.tpl' with {'label': 'Плейсхолдер', 'name': 'fields_pay|'~i~'|placeholder'} %}
									{% include form~'field.tpl' with {'label': 'Значение', 'name': 'fields_pay|'~i~'|values', 'placeholder': 'значение1,значение2,...', 'class': 'w100'} %}
									{% include form~'radio.tpl' with {'label': 'Тип поля', 'name': 'fields_pay|'~i~'|type', 'data': {'Строка': 'text', 'Телефон': 'tel', 'E-mail': 'email', 'Текстовое поле': 'textarea', 'Число': 'number', 'Выпадающий список': 'select'}} %}
									{% include form~'radio.tpl' with {'label': 'Обязательное поле', 'name': 'fields_pay|'~i~'|required', 'data': {'Да': '', 'Нет': 'empty'}} %}
									
									<div class="buttons">
										<button class="delete_field_pay" data-field_id="{{i}}">Удалить Поле</button>
									</div>
								</div>
							</div>
						{% endfor %}
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}		
				</div>
				
				<div class="buttons">
					<button class="large" id="addFieldPay">Добавить поле</button>
				</div>
				
			</fieldset>
		</div>
		
		
		<div tabid="fieldsComplaints">
			<h3>Поля для предложений и жалоб</h3>
			
			<fieldset>
				<legend>Список полей</legend>
				
				<div class="list" id="fieldsComplaintsBlock">
					{% if fields_complaints_setting|length > 0 %}
						{% for i in fields_complaints_setting|keys %}
							<div class="list_item">
								<div class="block">
									<title>{{i}}</title>
									
									{% include form~'field.tpl' with {'label': 'Лэйбл', 'name': 'fields_complaints|'~i~'|label'} %}
									{% include form~'field.tpl' with {'label': 'Плейсхолдер', 'name': 'fields_complaints|'~i~'|placeholder'} %}
									{% include form~'field.tpl' with {'label': 'Значение', 'name': 'fields_complaints|'~i~'|values', 'placeholder': 'значение1,значение2,...', 'class': 'w100'} %}
									{% include form~'radio.tpl' with {'label': 'Тип поля', 'name': 'fields_complaints|'~i~'|type', 'data': {'Строка': 'text', 'Телефон': 'tel', 'E-mail': 'email', 'Текстовое поле': 'textarea', 'Число': 'number', 'Выпадающий список': 'select'}} %}
									{% include form~'radio.tpl' with {'label': 'Обязательное поле', 'name': 'fields_complaints|'~i~'|required', 'data': {'Да': '', 'Нет': 'empty'}} %}
									
									<div class="buttons">
										<button class="delete_field_complaints" data-field_id="{{i}}">Удалить Поле</button>
									</div>
								</div>
							</div>
						{% endfor %}
					{% else %}
						<p class="empty">Нет данных</p>
					{% endif %}		
				</div>
				
				<div class="buttons">
					<button class="large" id="addFieldComplaints">Добавить поле</button>
				</div>
				
			</fieldset>
		</div>
		
		
		
		
		<div tabid="usersListPay">
			<h3>Список пользователей "{{button_left_title_setting}}"</h3>
			
			<fieldset>
				<legend>Список</legend>
				
				<ul class="tabstitles sub">
					<li id="ListPayactual">Актуальные</li>
					<li id="ListPayarchive">Архив</li>
				</ul>
				
				
				
				
				<div class="tabscontent">
					{% for stat, list in users_list_pay %}
						<div tabid="{% if stat == 1 %}ListPay{{stat}}{% else %}ListPay{{stat}}{% endif %}">
							{% if list|length > 0 %}
								{% set colsp = '' %}
								<table id="usersListPayTable">
									<thead>
										<tr>
											<td>Никнейм</td>
											<td>Статик</td>
											{% for k, item in fields_pay_setting %}
												{% set colsp = colsp~'|'~k %}
												<td>{{item.label}}</td>
											{% endfor %}
											<td>Дата</td>
											<td>Статус</td>
										</tr>
									</thead>
									
									<tbody>
										{% for kf, field in list %}
											<tr class="pointer">
												<input type="hidden" class="field_pay_id" value="{{field.user_id}}">
												<td class="field_pay_nickname">{{field.nickname}}</td>
												<td class="field_pay_static">{{field.static}}</td>
												{% for i in colsp|trim('|', 'left')|split('|') %}
													<td class="field_pay_{{i}}">{{field['field_pay_'~i]}}</td>
												{% endfor %}
												<td class="nowidth nowrap">{{field['date']|slice(0, -3)|d}} {{field['date']|slice(0, -3)|t}}</td>
												<td class="access_block nowidth center">
													{% if field['stat'] %}
														<div access="0" class="success" data-keyfield="{{kf}}" data-type="pay" title="разрешен"></div>
													{% else %}
														<div access="1" class="forbidden" data-keyfield="{{kf}}" data-type="pay" title="не разрешен"></div>
													{% endif %}
												</td>
											</tr>
										{% endfor %}
									</tbody>
								</table>
								
								
								{% if users_list_more %}
									<div class="buttons">
										<button id="usersListPayMore">Загрузить еще</button>
									</div>
								{% endif %}
								
							{% else %}
								<p class="empty">Нет данных</p>
							{% endif %}
						</div>
					{% endfor %}
				</div>
				
			</fieldset>
		</div>
		
		
		
		
		<div tabid="usersListComplaints">
			<h3>Список пользователей "{{button_right_title_setting}}"</h3>
			
			<fieldset>
				<legend>Список</legend>
				
				<ul class="tabstitles sub">
					<li id="ListComplaintsactual">Актуальные</li>
					<li id="ListComplaintsarchive">Архив</li>
				</ul>
				
				<div class="tabscontent">
					{% for stat, list in users_list_complaints %}
						<div tabid="{% if stat == 1 %}ListComplaints{{stat}}{% else %}ListComplaints{{stat}}{% endif %}">
							{% if list|length > 0 %}
								{% set colc = '' %}
								<table id="usersListComplaintsTable">
									<thead>
										<tr>
											<td>Никнейм</td>
											<td>Статик</td>
											{% for k, item in fields_complaints_setting %}
												{% set colc = colc~'|'~k %}
												<td>{{item.label}}</td>
												
											{% endfor %}
											<td>Дата</td>
											<td>Статус</td>
										</tr>
									</thead>
									
									<tbody>
										{% for kf, field in list %}
											<tr>
												<td>{{field.nickname}}</td>
												<td>{{field.static}}</td>
												{% for i in colc|trim('|', 'left')|split('|') %}
													<td>{{field['field_complaints_'~i]}}</td>
												{% endfor %}
												<td class="nowidth nowrap">{{field['date']|slice(0, -3)|d}} {{field['date']|slice(0, -3)|t}}</td>
												<td class="access_block nowidth center">
													{% if field['stat'] %}
														<div access="0" class="success" data-keyfield="{{kf}}" data-type="complaints" title="разрешен"></div>
													{% else %}
														<div access="1" class="forbidden" data-keyfield="{{kf}}" data-type="complaints" title="не разрешен"></div>
													{% endif %}
												</td>
											</tr>
										{% endfor %}
									</tbody>
								</table>
								
								{% if users_list_more %}
									<div class="buttons">
										<button id="usersListComplaintsMore">Загрузить еще</button>
									</div>
								{% endif %}
								
							{% else %}
								<p class="empty">Нет данных</p>
							{% endif %}
						</div>
					{% endfor %}
				</div>
				
			</fieldset>
		</div>
		
		
		
		
		<div tabid="resignsList">
			<h3>Заявки на увольнение</h3>
			
			<ul class="tabstitles sub">
				<li id="tabResignsActual">Актуальные</li>
				<li id="tabResignsArchive">Архив</li>
			</ul>
			
			<div class="tabscontent">
				<div tabid="tabResignsActual">
					<table>
						<thead>
							<tr>
								<td></td>
								<td class="w200px">Никнейм</td>
								<td class="w200px">Статик</td>
								<td>Причина увольнения</td>
								<td>Что изменить</td>
								<td class="w150px">Дата регистрации аккаунта</td>
								<td class="w150px">Дата подачи заявки</td>
								<td class="w150px">Дата для увольнения</td>
								<td class="w150px">Последний рабочий день</td>
								<td class="w60px">Статус</td>
							</tr>
						</thead>
						<tbody>
							{% if resigns[1] %}
								{% for item in resigns[1] %}
									<tr>
										<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
										<td>{{item.nickname}}</td>
										<td>{{item.static}}</td>
										<td><small>{{item.reason|raw}}</small></td>
										<td><small>{{item.comment|raw}}</small></td>
										<td>{{item.date_reg|d}}</td>
										<td>{{item.date_add|d}} <p>в {{item.date_add|t}}</p></td>
										<td>{{item.date_resign|d}}</td>
										<td>{{item.date_last|d}}</td>
										<td class="access_block center">
											{% if item.stat %}
												<div resign="0" class="success" data-id="{{item.id}}" title="Уволен"></div>
											{% else %}
												<div resign="1" class="forbidden" data-id="{{item.id}}" title="не уволен"></div>
											{% endif %}
										</td>
									</tr>
								{% endfor %}
							{% else %}
								<tr><td colspan="10"><p class="empty center">Нет данных</p></td></tr>
							{% endif %}
						</tbody>
					</table>	
				</div>
				<div tabid="tabResignsArchive">
					<table>
						<thead>
							<tr>
								<td></td>
								<td class="w200px">Никнейм</td>
								<td class="w200px">Статик</td>
								<td>Причина увольнения</td>
								<td>Что изменить</td>
								<td class="w150px">Дата регистрации аккаунта</td>
								<td class="w150px">Дата подачи заявки</td>
								<td class="w150px">Дата для увольнения</td>
								<td class="w150px">Последний рабочий день</td>
								<td class="w150px">Дата одобрения заявки</td>
								<td class="w150px">Подтвердил увольнение</td>
							</tr>
						</thead>
						<tbody>
							{% if resigns[0] %}
								{% for item in resigns[0] %}
									<tr>
										<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
										<td>{{item.nickname}}</td>
										<td>{{item.static}}</td>
										<td><small>{{item.reason|raw}}</small></td>
										<td><small>{{item.comment|raw}}</small></td>
										<td>{{item.date_reg|d}}</td>
										<td>{{item.date_add|d}} <p>в {{item.date_add|t}}</p></td>
										<td>{{item.date_resign|d}}</td>
										<td>{{item.date_last|d}}</td>
										<td>{{item.date_success|d}} <p>в {{item.date_success|t}}</p></td>
										<td>
											{% if item.from is same as(0) %}
												Администратор
											{% else %}
												<small>Оператор:</small>
												{{item.from}}
											{% endif %}
										</td>
										{#<td class="access_block center">
											{% if item.stat %}
												<div resign="0" class="success" data-id="{{item.id}}" title="Уволен"></div>
											{% else %}
												<div resign="1" class="forbidden" data-id="{{item.id}}" title="не уволен"></div>
											{% endif %}
										</td>#}
									</tr>
								{% endfor %}
							{% else %}
								<tr><td colspan="11"><p class="empty center">Нет данных</p></td></tr>
							{% endif %}
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		
		
		
		<div tabid="constants">
			<h3>Константы</h3>
			
			<ul class="tabstitles sub">
				<li id="tabReports">Расчетоы и отчеты</li>
				<li id="tabVacations">Бронирование выходных</li>
				<li id="tabDeposit">Депозит</li>
				<li id="tabRating">Рейтинг</li>
			</ul>
			
			<div class="tabscontent">
				<div tabid="tabReports">
					<fieldset>
						<legend>Константы для расчетов и отчета</legend>
						
						<div class="row">
							{% for k, variant in ['Сдельный отчет', 'Премиальный отчет'] %}
								<div class="col-auto">
									<small>{{variant}}</small>
									{% include form~'field.tpl' with {'label': 'Посещения', 'name': 'constants|'~(k+1)~'|visits', 'class': 'w100', 'type': 'number', 'step': '0.001'} %}
									{% include form~'field.tpl' with {'label': 'Персонажи', 'name': 'constants|'~(k+1)~'|persons', 'class': 'w100', 'type': 'number', 'step': '0.001'} %}
									{% include form~'field.tpl' with {'label': 'Эффективность', 'name': 'constants|'~(k+1)~'|effectiveness', 'class': 'w100', 'type': 'number', 'step': '0.001'} %}
									{% include form~'field.tpl' with {'label': 'Штрафы', 'name': 'constants|'~(k+1)~'|fine', 'class': 'w100', 'type': 'number', 'step': '0.001'} %}
								</div>
							{% endfor %}
						</div>
					</fieldset>
				</div>
				
				<div tabid="tabVacations">
					<fieldset>
						<legend>Бронирование выходных</legend>
						
						{% include form~'field.tpl' with {'label': 'Лимит бронирование в месяц', 'name': 'offtime_user_limit', 'class': 'w20', 'type': 'number', 'step': '1'} %}
					
					</fieldset>
				</div>
				
				<div tabid="tabDeposit">
					<fieldset>
						<legend>Процент отчисления в депозит по-умолчанию</legend>
						
						{% include form~'field.tpl' with {'label': 'Процент', 'name': 'default_deposit_percent', 'class': 'w10', 'type': 'number', 'step': '1'} %}
					
					</fieldset>
					
					<fieldset>
						<legend>Процент отчисления в депозит в заявках на оплату</legend>
						
						{% include form~'field.tpl' with {'label': 'Процент', 'name': 'payment_requests_deposit_percent', 'class': 'w10', 'type': 'number', 'step': '1'} %}
					
					</fieldset>
				</div>
				
				<div tabid="tabRating">
					<fieldset>
						<legend>Коэффициенты для рейтинга</legend>
						
						<div class="row">
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Активность', 'name': 'rating_coeffs|activity', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Личный скилл', 'name': 'rating_coeffs|skill', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Штрафы', 'name': 'rating_coeffs|fine', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Коэффициент посещений', 'name': 'rating_coeffs|visits', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
						</div>
						
						<div class="row mt-4">
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Выговоры', 'name': 'rating_coeffs|reprimands', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Форс мажорные выходные', 'name': 'rating_coeffs|forcemajeure', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Стимулирование', 'name': 'rating_coeffs|stimulations', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
							<div class="col-12 col-md-6 col-lg-3">
								{% include form~'textarea.tpl' with {'label': 'Наставничество', 'name': 'rating_coeffs|mentors', 'placeholder': 'коэффициент:баллы / перенос строки'} %}
							</div>
						</div>
					</fieldset>
					
					<fieldset>
						<legend>Как рассчитывается рейтинг</legend>
						
						{% include form~'textarea.tpl' with {'label': 'Описание', 'name': 'rating_desc', 'editor': 'ratingDesc', 'class': 'w100'} %}
					
					</fieldset>
				</div>
			</div>
		</div>
		
		
		
		
		
		<div tabid="agreement">
			<h3>Договор</h3>
			
			<ul class="tabstitles sub">
				<li id="toRaids">Рейдерам</li>
				<li id="toRaidliders">Рейд-лидерам</li>
			</ul>
			
			
			<div class="tabscontent">
				<div tabid="toRaids">
					<fieldset>
						<legend>Договор Рейдерам</legend>
						
						{% include form~'textarea.tpl' with {'label': 'Текст', 'name': 'agreement', 'editor': 'raiderContract', 'class': 'w100'} %}
						
					</fieldset>
					
				</div>	
				<div tabid="toRaidliders">
					<fieldset>
						<legend>Договор Рейд-лидерам</legend>
						
						{% include form~'textarea.tpl' with {'label': 'Текст', 'name': 'agreement_liders', 'editor': 'raidLiderContract', 'class': 'w100'} %}
						
					</fieldset>
					
				</div>	
			</div>
		</div>
		
		
		
		
		<div tabid="importantInfo">
			<h3>Важная информация</h3>
			
			<ul class="tabstitles sub">
				<li id="importantInfo1">{{important_info_setting[0]['title']|default('Раздел 1')}}</li>
				<li id="importantInfo2">{{important_info_setting[1]['title']|default('Раздел 2')}}</li>
				<li id="importantInfo3">{{important_info_setting[2]['title']|default('Раздел 3')}}</li>
				<li id="importantInfo4">{{important_info_setting[3]['title']|default('Раздел 4')}}</li>
				<li id="importantInfo5">{{important_info_setting[4]['title']|default('Раздел 5')}}</li>
				<li id="importantInfo6">{{important_info_setting[5]['title']|default('Раздел 6')}}</li>
				<li id="importantInfo7">{{important_info_setting[6]['title']|default('Раздел 7')}}</li>
				<li id="importantInfo8">{{important_info_setting[7]['title']|default('Раздел 8')}}</li>
			</ul>
			
			<div class="tabscontent">
				{% for i in 0..8 %}
					<div tabid="importantInfo{{i+1}}">
						<fieldset>
							<legend>Раздел {{i+1}}</legend>
								{% include form~'field.tpl' with {'label': 'Заголовок вкладки', 'name': 'important_info|'~i~'|title', 'class': 'w20'} %}
								{% include form~'radio.tpl' with {'label': 'Статус', 'name': 'important_info|'~i~'|stat', 'data': {'Выкл': 0, 'Вкл': 1}} %}
								{% include form~'radio.tpl' with {'label': 'Отображать для', 'name': 'important_info|'~i~'|for', 'data': {'Все': 1, 'Рейдеры': 2, 'Лидеры': 3}} %}
								{% include form~'textarea.tpl' with {'label': 'Текст', 'name': 'important_info|'~i~'|data', 'editor': 1, 'class': 'w100'} %}
							</fieldset>
						</fieldset>
					</div>
				{% endfor %}
				
			</div>		
		</div>
		
		
		
		
		
		
		<div tabid="commonMessage">
			<h3>Cообщение для НЕверифицированных</h3>
			
			<fieldset>
				<legend>Содержание сообщения</legend>
				
				{% include form~'textarea.tpl' with {'label': 'Текст сообщения', 'name': 'common_message', 'editor': 'commonMessage', 'class': 'w100'} %}
				
			</fieldset>
			
		</div>
		
		
		
		<div tabid="skype">
			<fieldset>
				<legend>Ссылка скайп</legend>
				
				{% include form~'field.tpl' with {'label': 'Логин скайп', 'name': 'skype_login', 'class': 'w20'} %}
				{% include form~'field.tpl' with {'label': 'Заголовок', 'name': 'skype_title', 'class': 'w20'} %}
				{% include form~'field.tpl' with {'label': 'Текст', 'name': 'skype_text', 'class': 'w20'} %}
				
			</fieldset>
		</div>
		
		
		<div tabid="links">
			<fieldset>
				<legend>Ссылки</legend>
				
				{% include form~'field.tpl' with {'label': 'Ссылка на отчет', 'name': 'raidliderreport', 'class': 'w100'} %}
				{% include form~'field.tpl' with {'label': 'Ссылка на платежные данные', 'name': 'paydataformlink', 'class': 'w100'} %}
				{% include form~'field.tpl' with {'label': 'Ссылка на форму обратной связи', 'name': 'callbackform', 'class': 'w100'} %}
				
			</fieldset>
		</div>
		
		
	</div>
</form>








<script type="text/javascript"><!--
$(document).ready(function() {
	
	// --------------------------------------------------------------------------------------- Сохранение основных настроек
	$('#commonSave').on(tapEvent, function(event) {
		var commonFormData = new FormData($('#common')[0]);
		$.ajax({
			type: 'POST',
			url: '/admin/save_settings',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: commonFormData,
			success: function(response) {
				if (response == 1) notify('Настройки сохранены!');
				else if (response == 2) location.reload();
				else notify('Ошибка сохранения данных', 'error');
			},
			error: function(e) {
				location.reload();
				//notify('Системная ошибка!', 'error');
				//showError(e);
			}
		});
	});
	
	
	//----------------------------------------------------------- Добавить поле платежа
	$('#addFieldPay').on(tapEvent, function() {
		if ($('#fieldsPayBlock').find('p.empty').length > 0) $('#fieldsPayBlock').find('p.empty').remove();
		renderTwigAdmin('render/fieldPay', {i: $('#fieldsPayBlock').children().length}, function(html) {
			$('#fieldsPayBlock').append(html);
		});
	});
	
	
	//------------------------- Удалить поле платежа
	$('body').off(tapEvent, '.delete_field_pay').on(tapEvent, '.delete_field_pay', function() {
		var thisItem = this,
			thisFieldId = $(thisItem).data('field_id');
		
		$.post('/admin/delete_pay_field', {index: thisFieldId}, function(response) {
			if (response) {
				$(thisItem).closest('.list_item').remove();
				notify('Поле удалено!');
			} else {
				notify('Ошибка!', 'error');
			}
		}).fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	//------------------------- Добавить поле предложений и жалоб
	$('#addFieldComplaints').on(tapEvent, function() {
		if ($('#fieldsComplaintsBlock').find('p.empty').length > 0) $('#fieldsComplaintsBlock').find('p.empty').remove();
		renderTwigAdmin('render/fieldComplaints', {i: $('#fieldsComplaintsBlock').children().length}, function(html) {
			$('#fieldsComplaintsBlock').append(html);
		});
	});
	
	
	//------------------------- Удалить поле предложений и жалоб
	$('body').off(tapEvent, '.delete_field_complaints').on(tapEvent, '.delete_field_complaints', function() {
		var thisItem = this,
			thisFieldId = $(thisItem).data('field_id');
		
		$.post('/admin/delete_complaints_field', {index: thisFieldId}, function(response) {
			if (response) {
				$(thisItem).closest('.list_item').remove();
				notify('Поле удалено!');
			} else {
				notify('Ошибка!', 'error');
			}
		}).fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
	
	
	
	//------------------------- Изменить статус "ЗАКАЗ ОПЛАТЫ" или "ПРЕДЛОЖЕНИЯ И ЖАЛОБЫ"
	$('body').off(tapEvent, '[access]').on(tapEvent, '[access]', function() {
		var thisItem = this,
			thisKeyField = $(thisItem).data('keyfield'),
			thisType = $(thisItem).data('type'),
			stat = $(thisItem).attr('access');
		
		$.post('/admin/set_'+thisType+'_field_stat', {id: thisKeyField, stat: stat}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('access', '0').removeClass('forbidden').addClass('success').attr('title', 'разрешен');
				} else {
					$(thisItem).attr('access', '1').removeClass('success').addClass('forbidden').attr('title', 'не разрешен');
				}
				
				notify('Статус изменен!');
			} else {
				notify('Ошибка!', 'error');
			}
		}).fail(function(e) {
			showError(e);	
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	//------------------------- Подгрузить список пользователей оплыты
	var startPay = 1;
	$('#usersListPayMore').on(tapEvent, function() {
		$.post('/admin/get_pay_list_more', {offset: (startPay * 30)}, function(response) {
			renderTwigAdmin('render/users_pay_more', response, function(html) {
				if (html != '') {
					$('#usersListPayTable tbody').append(html);
					startPay += 1;
				} else {
					$('#usersListPayMore').prop('disabled', true);
				}
			}); 
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	
	//------------------------- Подгрузить список пользователей предложений и жалоб
	var startComplaints = 1;
	$('#usersListComplaintsMore').on(tapEvent, function() {
		$.post('/admin/get_complaints_list_more', {offset: (startComplaints * 30)}, function(response) {
			renderTwigAdmin('render/users_complaints_more', response, function(html) {
				if (html != '') {
					$('#usersListComplaintsTable tbody').append(html);
					startComplaints += 1;
				} else {
					$('#usersListComplaintsMore').prop('disabled', true);
				}
			}); 
		}, 'json').fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
	});
	
	
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------------------------------------- Заявки на оплату
	$('body').off(tapEvent, '#usersListPayTable tbody tr td:not(:last-of-type)').on(tapEvent, '#usersListPayTable tbody tr td:not(:last-of-type)', function() {
		var thisTr = $(this).closest('tr'),
			user_id = $(thisTr).find('.field_pay_id').val(),
			nickname = $(thisTr).find('td.field_pay_nickname').text(),
			static = $(thisTr).find('td.field_pay_static').text(),
			pay0 = $(thisTr).find('td.field_pay_0').text(),
			pay1 = $(thisTr).find('td.field_pay_1').text();
		
		popUp({
			title: 'Заявка на оплату',
		    width: 400,
		    height: 300,
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'setPaymentRequest', title: 'Оформить заявку'}],
		    closeButton: 'Отмена',
		}, function(pRNewWin) {
			pRNewWin.wait();
			getAjaxHtml('reports/get_pay_blank', {user_id: user_id, nickname: nickname, static: static, pay0: pay0, pay1: pay1}, function(html) {
				pRNewWin.setData(html);
				
				$('#paymentRequestSumm').number(true, 2, '.', ' ');
				
				//--------------------------------------------------- Оформить заявку
				$('#setPaymentRequest').on(tapEvent, function() {
					var stat = true, users = [], order, summ, toDeposit, comment;
					if ($('#paymentRequestChoosenUsers').find('[paymentrequestchoosenuser]').length == 0) {
						$('#paymentRequestChoosenUsers').addClass('error');
						notify('Необходимо указать участников.', 'error');
						stat = false;
					}
					
					if ($('#paymentRequestOrder').val() == '') {
						$('#paymentRequestOrder').addClass('error');
						notify('Необходимо указать номер заказа.', 'error');
						stat = false;
					}
					
					if ($('#paymentRequestSumm').val() == '') {
						$('#paymentRequestSumm').addClass('error');
						notify('Необходимо указать сумму выплаты.', 'error');
						stat = false;
					}
					
					if (stat) {
						pRNewWin.wait();
						
						$('#paymentRequestChoosenUsers').find('[paymentrequestchoosenuser]').each(function() {
							users.push($(this).attr('paymentrequestchoosenuser'));
						});
						
						order = $('#paymentRequestOrder').val();
						summ = $('#paymentRequestSumm').val();
						toDeposit = $('#paymentRequestToDeposit').val();
						comment = $('#paymentRequestComment').val();
						
						$.post('/reports/set_users_orders', {users: users, order: order, summ: summ, to_deposit: toDeposit, comment: comment}, function(response) {	
							if (response) {
								notify('Заявка успешно оформлена!');
								pRNewWin.close();
								$(thisTr).find('[access]').trigger(tapEvent);
							} else {
								notify('Ошибка оформления заявки', 'error');
							}
							pRNewWin.wait(false);
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					}	
				});
				
				//--------------------------------------------------- Поиск участников
				/*var pRFUserTOut; 
				$('#paymentRequestFindUser').on('keyup', function() {
					clearTimeout(pRFUserTOut);
					pRFUserTOut = setTimeout(function() {
						var val = $('#paymentRequestFindUser').val();
						if (val.length == 0 || val.length >= 2) {
							$('#paymentRequestsUsers').addClass('wait');
							getAjaxHtml('reports/get_users', {query: val}, function(html) {
								$('#paymentRequestsUsers').html(html);
								$('#paymentRequestChoosenUsers li').each(function() {
									var thisId = $(this).attr('paymentrequestchoosenuser');
									if ($('#paymentRequestsUsers ul li[chooseusertopaymentrequest="'+thisId+'"]').length > 0) {
										$('#paymentRequestsUsers ul li[chooseusertopaymentrequest="'+thisId+'"]').addClass('choosed');
									}
								});
							}, function() {
								$('#paymentRequestsUsers').removeClass('wait');
								pRNewWin.correctPosition();
							});
						}
					}, 300);	
				});*/
				
				
				//--------------------------------------------------- Выбор участников
				/*$('body').off(tapEvent, '[chooseusertopaymentrequest]:not(.choosed)').on(tapEvent, '[chooseusertopaymentrequest]:not(.choosed)', function() {
					$(this).addClass('choosed');
					$('#paymentRequestChoosenUsers').removeClass('error');
					
					var addItem = '',
						thisUserId = $(this).attr('chooseusertopaymentrequest'),
						thisUserNickname = $(this).find('.nickname').text(),
						thisUserStaticImg = $(this).find('.static img').attr('src'),
						thisUserStaticName = $(this).find('.static span').text();
					
					addItem +=	'<li paymentrequestchoosenuser="'+thisUserId+'">';
					addItem +=		'<p class="nickname">'+thisUserNickname+'</p>';
					addItem +=		'<div class="static">';
					addItem +=			'<div class="image"><img src="'+thisUserStaticImg+'" alt=""></div>';
					addItem +=			'<span>'+thisUserStaticName+'</span>';
					addItem +=		'</div>';
					addItem +=		'<div class="remove" title="Удалить участника из списка"></div>';
					addItem +=	'</li>'
					
					$('#paymentRequestChoosenUsers').append(addItem);
				});*/
				
				
				//--------------------------------------------------- Удаление участникоы
				/*$('body').off(tapEvent, '[paymentrequestchoosenuser] .remove').on(tapEvent, '[paymentrequestchoosenuser] .remove', function() {
					var thisId = $(this).closest('[paymentrequestchoosenuser]').attr('paymentrequestchoosenuser');
					$(this).closest('[paymentrequestchoosenuser]').remove();
					$('[chooseusertopaymentrequest="'+thisId+'"]').removeClass('choosed');
				});*/
				
			}, function() {
				pRNewWin.wait(false);
			});
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------- Изменить статус "Заявки на увольнение"
	$('body').off(tapEvent, '[resign]').on(tapEvent, '[resign]', function() {
		var thisItem = this,
			id = $(thisItem).data('id'),
			stat = $(thisItem).attr('resign');
		
		$.post('/admin/change_resign_stat', {id: id, from: 'admin', stat: stat}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('resign', '0').removeClass('forbidden').addClass('success').attr('title', 'уволен');
				} else {
					$(thisItem).attr('resign', '1').removeClass('success').addClass('forbidden').attr('title', 'не уволен');
				}
				notify('Статус изменен!');
			} else {
				notify('Ошибка!', 'error');
			}
		}).fail(function(e) {
			showError(e);	
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	
	
});
//--></script>