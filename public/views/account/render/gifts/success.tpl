{% if count %}
	<h1 class="giftwin__title giftwin__title_small">Подарок успешно получен!</h1>
	
	<div class="giftwin__value">
		<small>{{count|padej(['остался', 'осталось', 'осталось'])}} еще</small>
		<strong>{{count}}</strong>
		<span>{{count|padej(['подарок', 'подарка', 'подарков'])}}</span>
	</div>
	
	<div class="giftwin__buttons">
		<button class="giftwin__button giftwin__button_small" id="getNextGiftBtn">Получить</button>
		<button class="giftwin__button giftwin__button_small giftwin__button_close" id="closeGiftsWinBtn">Закрыть</button>
	</div>
	
{% else %}
	<h1 class="giftwin__title giftwin__title_small">Все подарки получены!</h1>
	
	<div class="giftwin__buttons">
		<button class="giftwin__button giftwin__button_small giftwin__button_close" id="closeGiftsWinBtn">Закрыть</button>
	</div>
{% endif %}