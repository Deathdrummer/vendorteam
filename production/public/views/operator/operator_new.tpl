<!DOCTYPE html>
<!--[if IE]><![endif]-->
<!--[if IE 8 ]><html dir="ltr" lang="ru" class="ie8"><![endif]-->
<!--[if IE 9 ]><html dir="ltr" lang="ru" class="ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html dir="ltr" lang="ru">
<head>
	<meta charset="UTF-8" />
	<meta name="author" content="Дмитрий Сайтотворец" />
	<meta name="copyright" content="ShopDevelop &copy; Web разработка" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<meta name="format-detection" content="telephone=no"> <!-- отключение автоопределения номеров для Safari (iPhone / IPod / IPad) и Android браузера -->
	<meta http-equiv="x-rim-auto-match" content="none"> <!-- отключение автоопределения номеров для BlackBerry -->
	<meta name="keywords" content="">
	<meta name="description" content="">
	<link rel="shortcut icon" href="{{base_url('public/images/favicon.png')}}" />
	
	<link rel="stylesheet" href="{{base_url('public/css/plugins.min.css')}}">
	<script src="{{base_url('public/js/plugins.min.js')}}"></script>
	
	<script src="{{base_url('public/js/assets/functions.js')}}"></script>
	<script src="{{base_url('public/js/assets/common.js')}}"></script>
	
	<link rel="stylesheet" href="{{base_url('public/css/operator.min.css')}}">
	<script src="{{base_url('public/js/operator.js')}}"></script>
	
	<title>Кабинет оператора</title> 
</head>
<body>
	{% if svg_sparite %}{{svg_sparite|raw}}{% endif %} {# Вставляем SVG спрайт #}
	
	{% include 'views/layout/nav_mobile.tpl' %}
	
	<main class="main">
		<div class="row no-gutters align-items-stretch flex-nowrap account">
			<div class="col-auto hidden-sm-down">
				{% include 'views/layout/aside.tpl' with {} %}
			</div>
			<div class="col">
				<div class="contentblock">
					
					<div class="row justify-content-between align-items-center hidden-md-up mobileheader">
						<div class="col-auto">
							<p>w<span>o</span>wteam</p>
						</div>
						<div class="col-auto">
							<i class="fa fa-bars" id="mobileNavButton"></i>
						</div>
					</div>
					
					{% if statics %}
						<div class="staticsblock">
							<svg class="staticsblock__arrow staticsblock__arrow_left" id="staticsPrev"><use xlink:href="#arrow"></use></svg>
							<div id="accountStatics">
								{% set stCounter = 1 %}
								{% for staticId, static in statics %}
									<div accountstatic="{{staticId}}" class="static{% if stCounter %} active{% endif %}" title="{% if static.main %}Основной{% endif %}{% if static.lider %} Лидер{% endif %}">
										<div class="static__icon">
											<img src="{{base_url()}}public/account/images/{{static.icon}}" alt="">
										</div>
										<div class="static__title">
											<p>{{static.name}}</p>
										</div>
										<div class="static__stat">
											{% if static.lider %}<svg class="lider"><use xlink:href="#crown"></use></svg>{% endif %}
											{% if static.main %}<i class="fa fa-home main"></i>{% endif %}
										</div>
									</div>
									{% set stCounter = 0 %}
								{% endfor %}
							</div>
							<svg class="staticsblock__arrow" id="staticsNext"><use xlink:href="#arrow"></use></svg>
						</div>
					{% endif %}
						
					
					{% if statics %}
						{% for i, staticId in statics|keys %}
							<div class="{% if i == 0 %}staticscontent staticscontent_visible{% else %}staticscontent{% endif %}" staticscontent="{{staticId}}">
								<div class="row gutters-10 mt-4">
									<div class="col-12 col-md-auto">
										<div class="column column_staticusers">
											<div class="column__title">
												<p>Состав команды</p>
											</div>
											
											<div class="column__content">
												<div class="row gutters-5">
													<div class="col-12"> <!-- <div class="col-5"> -->
														<div class="staticpanel">
															<div class="staticusers noselect">
																{% for friend in friends[staticId] %}
																	<div class="staticuser" userid="{{friend.id}}">
																		<div class="staticuser__image" style="background-image: url({{base_url()}}public/account/images/{% if friend.avatar %}users/{{friend.avatar}}{% else %}user_mini.jpg{% endif %})">
																			<div class="staticuser__stat {#online#}"></div>
																		</div>
																		<div class="staticuser__name mr-auto">
																			<p>{{friend.nickname}}</p>
																			<span>{{friend.role}}</span>
																			<span>{{friend.rank}}</span>
																		</div>
																		<div class="staticuser__info">
																			<div class="staticuser__mess" hidden>
																				<svg><use xlink:href="#message"></use></svg>
																				<span>1</span>
																			</div>
																		</div>
																	</div>
																{% endfor %}
															</div>
															{% if statics[staticId]['lider'] %}
																<div class="staticbuttons" id="staticLiderButtons">
																	<button setcompound="{{staticId}}">Коэффициенты</button>
																	<button newraid="{{staticId}}">Создать рейд</button>
																</div>
															{% endif %}
														</div>
													</div>
													<div class="col-7" hidden> <!-- hidden убрать -->
														<div class="messages">
															<div class="messages__block">
																<div class="message">
																	<div class="message__image">
																		<img src="{{base_url()}}public/account/images/operator.jpg" alt="">
																	</div>
																	<div class="message__content">
																		<div class="message__title">
																			<p>Имя участника (роль)</p>
																			<small>12.03.2019</small>
																		</div>
																		<p class="message__text">Lorem Ipsum is simply dummy text of the printing and typesetting industry. 
																		Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</p>
																	</div>
																	
																</div>
																
																{% for i in 1..15 %}
																	<div class="message">
																		<div class="message__image">
																			<img src="{{base_url()}}public/account/images/i.jpg" alt="">
																		</div>
																		<div class="message__content">
																			<div class="message__title">
																				<p>Имя участника (роль)</p>
																				<small>12.03.2019</small>
																			</div>
																			<p class="message__text">Lorem Ipsum</p>
																		</div>
																	</div>
																{% endfor %}
																
															</div>
															
															
															<div class="send_message">
																<div class="send_message__image">
																	<img src="{{base_url()}}public/account/images/i.jpg" alt="">
																</div>
																<div class="send_message__content">
																	<div class="textarea" contenteditable="true"></div>
																</div>
																<div class="send_message__send" title="Отправить сообщение">
																	<svg id="staticSendMessage"><use xlink:href="#send_message"></use></svg>
																</div>
															</div>
														</div>
													</div>
												</div>		
											</div>
										</div> <!--  -->	
									</div>
									<div class="col-12 col-md">
										<div class="column">
											<div class="column__title">
												<p>Новости</p>
											</div>
											<div class="column__content">
												<div class="newsblock">
													<div class="news">
														{% if feed_messages[staticId] %}
															{% for message in feed_messages[staticId] %}
																<div class="news_item">
																	<div class="news_item__image">
																		<img src="{{base_url()}}public/account/images/{% if message.icon %}{{message.icon}}{% else %}news.jpg{% endif %}" alt="{{message.title}}">
																	</div>
																	<div class="news_item__content">
																		<h3>{{message.title}}</h3>
																		<small>{{message.date|d}}</small>
																		<p>{{message.message|raw}}</p>
																	</div>
																</div>
															{% endfor %}
														{% else %}
															<p class="empty">Нет данных</p>
														{% endif %}
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						{% endfor %}
					{% endif %}
					
				</div>
			</div>
		</div>
	</main>
	
	<!-- <div scrolltop><svg><use xlink:href="#arrow_left"></use></svg></div> -->
</body>
</html>