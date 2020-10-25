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
	
	<title>Авторизация | Кабинет оператора</title> 
</head>
<body>
	<main class="main d-flex align-items-center">
		<form action="/operator" method="POST" class="auth_form" autocomplete="off">
			<h2>Авторизация</h2>
			<p>Кабинет оператора</p>
			
			<input type="text" name="login" autocomplete="off" placeholder="Логин" tabindex="1" readonly{% if error_login %} class="error"{% endif %}>
			<input type="password" name="password" autocomplete="off" placeholder="Пароль" tabindex="2" readonly{% if error_password %} class="error"{% endif %}>
			<input type="hidden" name="auth" value="1">
			<button type="submit" id="authOperator" tabindex="3"><i class="fa fa-sign-in"></i> Войти</button>
		</form>
	</main>
	
</body>
</html>


<!-- Если сайт на хостинге - выполнять функции -->
{% if hosting %}{% endif %}


<script type="text/javascript"><!--
$(document).ready(function() {
	$('#authOperator').on(tapEvent, function() {
		if ($('input[name="login"]').val() == '' || $('input[name="password"]').val() == '') {
			$('input[name="login"], input[name="password"]').addClass('error');
			return false;
		}
	});
});
//--></script>