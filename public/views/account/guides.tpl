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
	<meta name="keywords" content="{{meta_keywords_setting}}">
	<meta name="description" content="{{meta_description_setting}}">
	<link rel="shortcut icon" href="{{base_url('public/images/favicon.png')}}" />
	
	<link rel="stylesheet" href="{{base_url('public/css/plugins.min.css')}}">
	<script src="{{base_url('public/js/plugins.min.js')}}"></script>
	
	<script src="{{base_url('public/js/assets/functions.js')}}"></script>
	<script src="{{base_url('public/js/assets/common.js')}}"></script>
	
	<link rel="stylesheet" href="{{base_url('public/css/account.min.css')}}">
	<script src="{{base_url('public/js/account.js')}}"></script>
	
	<!-- Если сайт на хостинге - выполнять функции ниже -->
	{% if hosting %}{% endif %}
	
	<title>Образование</title> 
</head>
<body>
	{% if svg_sparite %}{{svg_sparite|raw}}{% endif %} {# Вставляем SVG спрайт #}
	
	
	<div class="mobilenavwrap"></div>
	<div class="mobilenav" id="mobileNavBlock">
		<div class="mobilenav__close" id="mobileNavButtonClose"></div>
		<aside class="leftblock" id="accountLeftBlock">
			<div class="leftblock__block leftblock__block_top mb-3" id="accountTopBlock">
				<h1 class="leftblock__title leftblock__title_left">Образование</h1>
				<div class="leftblock__logout">
					<a href="{{base_url('account')}}" title="Вернуться в личный кабинет"><i class="fa fa-angle-left"></i>Вернуться в ЛК</a>
				</div>
			</div>
			<div class="leftblock__block leftblock__block_navblock noselect ml-0 mr-0" id="accountNavBlock">
				{% if chapters %}
					<ul class="leftblock__guides leftblock__guides_first">
						{% for first in chapters %}
							<li>
								{% if first.children %}
									<div guideropensubnav><span>{{first.title}}</span> <i></i></div>
									<ul class="leftblock__guides leftblock__guides_second">
										{% for second in first.children %}
											<li>
												{% if second.children %}
													<div guideropensubnav><span>{{second.title}}</span> <i></i></div>
													<ul class="leftblock__guides leftblock__guides_third">
														{% for third in second.children %}
															<li>
																{% if third.children %}
																	<div guideropensubnav><span>{{third.title}}</span> <i></i></div>
																	<ul class="leftblock__guides leftblock__guides_forth">
																		{% for forth in third.children %}
																			<li><div guideschapter="{{forth.id}}"><span>{{forth.title}}</span></div></li>
																		{% endfor %}
																	</ul>
																{% else %}	
																	<div guideschapter="{{third.id}}"><span>{{third.title}}</span></div>
																{% endif %}
															</li>
														{% endfor %}
													</ul>	
												{% else %}
													<div guideschapter="{{second.id}}"><span>{{second.title}}</span></div>
												{% endif %}
											</li>
										{% endfor %}
									</ul>
								{% else %}
									<div guideschapter="{{first.id}}"><span>{{first.title}}</span></div>
								{% endif %}
								
							</li>
						{% endfor %}
					</ul>
				{% endif %}
			</div>
			<div class="leftblock__block leftblock__block_bottom mt-3 p-0" id="accountBottomBlock"></div>
		</aside>
	</div>
	
	
	
	
	
	<main class="main">
		<div class="row no-gutters align-items-stretch flex-nowrap account">
			<div class="col-auto hidden-sm-down">
				<aside class="leftblock" id="accountLeftBlock">
					<div class="leftblock__block leftblock__block_top mb-3" id="accountTopBlock">
						<h1 class="leftblock__title leftblock__title_left">Образование</h1>
						<div class="leftblock__logout">
							<a href="{{base_url('account')}}" title="Вернуться в личный кабинет"><i class="fa fa-angle-left"></i>Вернуться в ЛК</a>
						</div>
					</div>
					<div class="leftblock__block leftblock__block_navblock noselect ml-0 mr-0" id="accountNavBlock">
						{% if chapters %}
							<ul class="leftblock__guides leftblock__guides_first">
								{% for first in chapters %}
									<li>
										{% if first.children %}
											<div guideropensubnav><span>{{first.title}}</span> <i></i></div>
											<ul class="leftblock__guides leftblock__guides_second">
												{% for second in first.children %}
													<li>
														{% if second.children %}
															<div guideropensubnav><span>{{second.title}}</span> <i></i></div>
															<ul class="leftblock__guides leftblock__guides_third">
																{% for third in second.children %}
																	<li>
																		{% if third.children %}
																			<div guideropensubnav><span>{{third.title}}</span> <i></i></div>
																			<ul class="leftblock__guides leftblock__guides_forth">
																				{% for forth in third.children %}
																					<li><div guideschapter="{{forth.id}}"><span>{{forth.title}}</span></div></li>
																				{% endfor %}
																			</ul>
																		{% else %}	
																			<div guideschapter="{{third.id}}"><span>{{third.title}}</span></div>
																		{% endif %}
																	</li>
																{% endfor %}
															</ul>	
														{% else %}
															<div guideschapter="{{second.id}}"><span>{{second.title}}</span></div>
														{% endif %}
													</li>
												{% endfor %}
											</ul>
										{% else %}
											<div guideschapter="{{first.id}}"><span>{{first.title}}</span></div>
										{% endif %}
										
									</li>
								{% endfor %}
							</ul>
						{% endif %}
					</div>
					<div class="leftblock__block leftblock__block_bottom mt-3 p-0" id="accountBottomBlock"></div>
				</aside>
			</div>
			<div class="col">
				<div class="contentblock contentblock__guides">
					<div class="row justify-content-between align-items-center hidden-md-up mobileheader">
						<div class="col-auto">
							<p>w<span>o</span>wteam</p>
						</div>
						<div class="col-auto">
							<i class="fa fa-bars" id="mobileNavButton"></i>
						</div>
					</div>
					
					<div class="contentblock__wait">
						<div>
							<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
							<span>Загрузка...</span>
						</div>
					</div>
					<div id="guidesContent"><p class="empty">Нет данных</p></div>
				</div>
			</div>
		</div>
	</main>
	
	
	{#{% include 'views/layout/footer.tpl' %}#}
	<div scrolltop><svg><use xlink:href="#arrow"></use></svg></div>
</body>
</html>