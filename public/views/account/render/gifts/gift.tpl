{% if gift %}
	<div class="giftcard">
		<h1 class="giftcard__title">{{gift.title}}</h1>
		<div class="giftcard__value">
			<small>{{actions[gift.action]}}</small>
			<strong>{{gift.value}}</strong>
			{% if gift.action == 'balance' %}
				<span>{{gift.value|padej(['рубль', 'рубля', 'рублей'])}}</span>
			{% elseif gift.action == 'stage' %}
				<span>{{gift.value|padej(['день', 'дня', 'дней'])}}</span>
			{% endif %}
		</div>
		<div class="giftcard__button">
			<button id="takeGiftBtn" giftid="{{gift.id}}">Получить</button>
		</div>
	</div>
{% else %}
	<h3 class="text-center">Все подарки получены!</h3>
	<button id="closeGiftsWinBtn">Закрыть</button>
{% endif %}