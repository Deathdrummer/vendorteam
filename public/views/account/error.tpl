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
	
	<title>Ошибка 404</title> 
</head>
<body>
	
	{% if svg_sparite %}
		{{svg_sparite|raw}} {# Вставляем SVG спрайт #}
	{% endif %}
	
	<main class="main">
		<section class="start" style="background-image: url('{{base_url()}}public/account/images/{{page_image_setting.path}}{{page_image_setting.name}}')">
			
			<div class="container">
				<div class="start__content start__content_error">
					
					<h1>Ошибка 404</h1>
					<h4>такой страницы не существует</h4>
					<a href="/">Перейти на главную</a>
					
				</div>
			</div>
		</section>
	</main>
	
</body>
</html>




<!-- Если сайт на хостинге - выполнять функции ниже -->
{% if hosting %}
	
{% endif %}