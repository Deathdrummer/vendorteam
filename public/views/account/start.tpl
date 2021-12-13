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
	
	<title>{% if not site_title_setting %}Заголовок{% else %}{{site_title_setting}}{% endif %}</title> 
</head>
<body class="body_start">
	{% if svg_sparite %}{{svg_sparite|raw}}{% endif %} {# Вставляем SVG спрайт #}
	
	<main class="main start" style="background-image: url('{{base_url('public/filemanager/'~page_image_setting)}}')">
		<div class="startblock" id="startContent">
			<header class="header">
				<div class="container">
					<div class="row gutters-5 header__block justify-content-between align-items-center">
						<div class="col-auto">
							<div class="header__logo">
								<p><strong style="font-size: 1em">W</strong>ow<strong style="font-size: 1em">V</strong>endor<strong style="font-size: 1em">T</strong>eam - <strong style="font-size: 1em">R</strong>aids</p>
							</div>
						</div>
						<div class="col-auto">
							{% if logout %}
								<div class="header__account" id="logout">
									<i class="fa fa-sign-out"></i>
									<p>Выйти</p>
								</div>
							{% else %}
								{% if is_auth %}
									<a href="account" class="header__account">
										<div class="avatar" style="background-image: url('{{avatar}}')"></div>
										<p>Личный кабинет</p>
									</a>
								{% else %}
									<div class="header__account" id="account">
										<i class="fa fa-user-circle-o"></i>
										<p>Войти<span class="hidden-xs-down"> в ЛК</span></p>
									</div>
								{% endif %}
							{% endif %}
						</div>
					</div>
				</div>
			</header>
			
			
			<div class="content">
				<div class="container">
					<div class="title">
						<h1>{{page_title_setting}}</h1>
					</div>
					
					<div class="desc">
						<p>{{page_title_text_setting}}</p>
					</div>
					
					
					
					<div class="triggersblock" hidden>
						<h2>6 весомых причин</h2>
						
						<div class="row mt-3 mt-md-5">
							<div class="col-12 col-md-6 col-lg-4">
								<div class="triggers">
									<div class="trigger">
										<div class="trigger__image">
											<img src="{{base_url()}}public/images/start_trigger1.png" alt="">
										</div>
										<div class="trigger__title">
											<h3>Выплаты раз в неделю</h3>
										</div>
										<div class="trigger__text">
											<p>Вам НЕ НУЖНО париться в неудобном офисе, соблюдать скучный дресскод или тратить время на дорогу 
											в забитом общественном транспорте! Работа на дому комфортна и сэкономит кучу сил!</p>
										</div>
									</div>
								</div>
							</div>
							<div class="col-12 col-md-6 col-lg-4">
								<div class="triggers">
									<div class="trigger">
										<div class="trigger__image">
											<img src="{{base_url()}}public/images/start_trigger1.png" alt="">
										</div>
										<div class="trigger__title">
											<h3>Выплаты раз в неделю</h3>
										</div>
										<div class="trigger__text">
											<p>Вам НЕ НУЖНО париться в неудобном офисе, соблюдать скучный дресскод или тратить время на дорогу 
											в забитом общественном транспорте! Работа на дому комфортна и сэкономит кучу сил!</p>
										</div>
									</div>
								</div>
							</div>
							<div class="col-12 col-md-6 col-lg-4">
								<div class="triggers">
									<div class="trigger">
										<div class="trigger__image">
											<img src="{{base_url()}}public/images/start_trigger1.png" alt="">
										</div>
										<div class="trigger__title">
											<h3>Выплаты раз в неделю</h3>
										</div>
										<div class="trigger__text">
											<p>Вам НЕ НУЖНО париться в неудобном офисе, соблюдать скучный дресскод или тратить время на дорогу 
											в забитом общественном транспорте! Работа на дому комфортна и сэкономит кучу сил!</p>
										</div>
									</div>
								</div>
							</div>
							<div class="col-12 col-md-6 col-lg-4">
								<div class="triggers">
									<div class="trigger">
										<div class="trigger__image">
											<img src="{{base_url()}}public/images/start_trigger1.png" alt="">
										</div>
										<div class="trigger__title">
											<h3>Выплаты раз в неделю</h3>
										</div>
										<div class="trigger__text">
											<p>Вам НЕ НУЖНО париться в неудобном офисе, соблюдать скучный дресскод или тратить время на дорогу 
											в забитом общественном транспорте! Работа на дому комфортна и сэкономит кучу сил!</p>
										</div>
									</div>
								</div>
							</div>
							<div class="col-12 col-md-6 col-lg-4">
								<div class="triggers">
									<div class="trigger">
										<div class="trigger__image">
											<img src="{{base_url()}}public/images/start_trigger1.png" alt="">
										</div>
										<div class="trigger__title">
											<h3>Выплаты раз в неделю</h3>
										</div>
										<div class="trigger__text">
											<p>Вам НЕ НУЖНО париться в неудобном офисе, соблюдать скучный дресскод или тратить время на дорогу 
											в забитом общественном транспорте! Работа на дому комфортна и сэкономит кучу сил!</p>
										</div>
									</div>
								</div>
							</div>
							<div class="col-12 col-md-6 col-lg-4">
								<div class="triggers">
									<div class="trigger">
										<div class="trigger__image">
											<img src="{{base_url()}}public/images/start_trigger1.png" alt="">
										</div>
										<div class="trigger__title">
											<h3>Выплаты раз в неделю</h3>
										</div>
										<div class="trigger__text">
											<p>Вам НЕ НУЖНО париться в неудобном офисе, соблюдать скучный дресскод или тратить время на дорогу 
											в забитом общественном транспорте! Работа на дому комфортна и сэкономит кучу сил!</p>
										</div>
									</div>
								</div>
							</div>
						</div>	
					</div>
				</div>
			</div>
			
			<footer class="footer">
				<div class="container">
					<small>Запрещено любое копирование материалов ресурса без письменного согласия владельца.</small>
					<small>© 2013-2020 by WowVendorTeam LLC. All rights reserved</small>
				</div>
			</footer>
			
		</div>
		
		
		
		
		{#<section class="start" style="background-image: url('{{base_url()}}public/account/images/{{page_image_setting.path}}{{page_image_setting.name}}')">
			
			{% if logout %}
				<button class="account_button" id="logout">Выйти</button>
			{% else %}
				<button class="account_button" id="account"><i class="fa fa-user-circle-o"></i> Личный кабинет</button>
			{% endif %}
			
			<div class="container">
				<div class="start__content">
					<h1>{{page_title_setting|raw}}</h1>
				</div>
			</div>
		</section>
		<div class="start__bg start__bg_bottom" id="startBgBottom">
			<img src="{{base_url()}}public/account/images/background_bottom.jpg" alt="">
		</div>#}
	</main>
	
	<script src="https://cdn.socket.io/3.1.3/socket.io.min.js" integrity="sha384-cPwlPLvBTa3sKAgddT6krw0cJat7egBga3DJepJyrLl4Q9/5WLra3rrnMcyTyOnh" crossorigin="anonymous"></script>
	<script src="{{base_url('public/js/socket.js')}}"></script>
</body>
</html>

<!-- Если сайт на хостинге - выполнять функции ниже -->
{% if hosting %}
	
{% endif %}