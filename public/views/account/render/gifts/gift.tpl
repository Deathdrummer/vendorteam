{% if gift %}
	<h1 class="giftwin__title giftwin__title_small">{{gift.title}}</h1>
	
	<div class="giftwin__value">
		<small>{{actions[gift.action]}}</small>
		<strong>{{gift.value}}</strong>
		{% if gift.action == 'balance' %}
			<span>{{gift.value|padej(['рубль', 'рубля', 'рублей'])}}</span>
		{% elseif gift.action == 'stage' %}
			<span>{{gift.value|padej(['день', 'дня', 'дней'])}}</span>
		{% endif %}
	</div>
	
	
	
	
	{% if gift.message %}
		<div class="giftwin__message">
		<hr class="giftwin__line">
			<h3>Сообщение</h3>
			<p class="format">{{gift.message}}</p>
		</div>
	{% endif %}
		
	
	
	<div class="giftwin__buttons">
		<button class="giftwin__button giftwin__button_small" id="takeGiftBtn" giftid="{{gift.id}}">Получить</button>
	</div>
{% else %}
	<h3 class="text-center">Все подарки получены!</h3>
	<button class="giftwin__button giftwin__button_small giftwin__button_close" id="closeGiftsWinBtn">Закрыть</button>
{% endif %}