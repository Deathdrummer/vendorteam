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
	<link rel="shortcut icon" href="{{base_url()}}public/images/favicon.png" />
	
	<link rel="stylesheet" href="{{base_url('public/css/plugins.min.css')}}">
	<link rel="stylesheet" href="{{base_url('public/css/admin.min.css')}}">
	
	<title>Административная панель</title> 
</head>
<body>
	{% if svg_sparite %}{{svg_sparite|raw}}{% endif %}
	<header class="header">
		<div class="header__item mr-4">
			<button id="openNav" touch="opened"><i class="navigation fa fa-bars"></i></button>
			<nav class="main_nav noselect">
				{% for sectionTitle, sectionsList in sections %}
					<div class="main_nav_item">
						<p>{{sectionTitle}}</p>
						<ul>
							{% for url, title in sectionsList %}
								<li data-block="{{url}}">{% if title is iterable %}{{title.title}}{% else %}{{title}}{% endif %}</li>
							{% endfor %}
						</ul>
					</div>
				{% endfor %}
			</nav>
		</div>
		<div class="header__item mr-auto">
			<p>Административная панель</p>
		</div>
		<div class="header__item">
			<button id="goToSite" class="home" title="Перейти на сайт"><i class="fa fa-home"></i></button>
			<button id="adminLogout" title="Выход"><i class="fa fa-sign-out"></i></button>
		</div>
	</header>
	
	
	
	<main class="main">
		<div id="sectionWait">
			<div class="info">
				<i class="fa fa-spinner fa-pulse fa-fw"></i>
				<p></p>
			</div>
		</div>
		<section id="section"></section>
	</main>
	
	{#---------------------------------------------------- Образцы 
	{% include form~'field.tpl' with {'label': 'Заголовок сайта', 'name': 'site_title', 'class': 'w20'} %}
	{% include form~'textarea.tpl' with {'label': 'Meta description', 'name': 'meta_description', 'class': 'w20'} %}
	{% include form~'file.tpl' with {'label': 'Иконка', 'name': 'statics', 'ext': 'jpg|jpeg|png|gif'} %}
	{% include form~'checkbox.tpl' with {'label': 'Тип отзывов', 'name': 'reviews_type', 'data': {'Инстаграм': 'insta', 'Свои': 'self'}, 'class': 'w20'} %}
	{% include form~'radio.tpl' with {'label': 'Тип отзывов', 'name': 'reviews_type', 'data': {'Инстаграм': 'insta', 'Свои': 'self'}, 'class': 'w20'} %} 
	{% include form~'color.tpl' with {'label': 'Favicon', 'name': 'color', 'path': '', 'inline': 1, 'class': 'w10'} %}
	#}
	
	<footer class="footer">
		<p>© <a href="https://shopdevelop.ru" target="_blank" title="Перейти на сайт shopdevelop.ru">ShopDevelop</a> 2011 - {{date}} г.</p>
	</footer>
	
	
	{# Оформление коды summernote #}
	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.css">
	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/theme/monokai.css">
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/2.36.0/formatting.js"></script>
	<script src="{{base_url('public/js/plugins.min.js')}}"></script>
	<script src="{{base_url('public/js/assets/functions.js')}}"></script>
	<script src="{{base_url('public/js/assets/common.js')}}"></script>
	<script src="https://cdn.socket.io/3.1.3/socket.io.min.js" integrity="sha384-cPwlPLvBTa3sKAgddT6krw0cJat7egBga3DJepJyrLl4Q9/5WLra3rrnMcyTyOnh" crossorigin="anonymous"></script>
	<script src="{{base_url('public/js/socket.js')}}"></script>
	<script src="{{base_url('public/js/admin.js')}}"></script>
</body>
</html>



{# <script src="https://cdn.socket.io/4.1.2/socket.io.min.js" integrity="sha384-toS6mmwu70G0fw54EGlWWeA4z3dyJ+dlXBtSURSKN4vyRFOcxd3Bzjj/AoOwY+Rg" crossorigin="anonymous"></script>
<script type="text/javascript"><!--
	var socket = io.connect('http://vendorteam.loc:5000');
	
	socket.on('connect', () => {
		console.log('connect');
		socket.on('set online', (userId) => {
			notify(userId);
		});
	});
	
//--></script> #}