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
	<input type="hidden" id="operatorNickname" value="{{nickname}}">
	
	{#{% include 'views/layout/header.tpl' with {operator: 1} %}#}
	{% include 'views/operator/layout/nav_mobile.tpl' %}
	
	<main class="main">
		<div class="row no-gutters align-items-stretch flex-nowrap operator">
			<div class="col-auto hidden-sm-down">
				{% include 'views/operator/layout/aside.tpl' with {} %}
			</div>
			<div class="col">
				<div class="contentblock">
					<div class="wait" id="contentblockWaitBlock">
						<figure>
							<i class="fa fa-spinner fa-pulse"></i>
							<figcaption>Загрузка...</figcaption>
						</figure>
					</div>
					<div id="operatorContent"></div>
				</div>
			</div>
		</div>
	</main>
	
	{#{% include 'views/layout/footer.tpl' with {operator: 1} %}#}
	<div scrolltop><svg><use xlink:href="#arrow"></use></svg></div>
</body>
</html>


<!-- Если сайт на хостинге - выполнять функции ниже -->
{% if hosting %}
	
{% endif %}