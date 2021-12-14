{% if count %}
	<h1 class="giftwin__title">Поздравляем!</h1>
	<h3 class="text-center fz26px">
		<span class="mr4px">Вам</span>
		<strong class="fz30px">{{count}}</strong>
		<span class="ml4px">{{count|padej(['подарок', 'подарка', 'подарков'])}}</span>
	</h3>
	<div class="giftwin__buttons">
		<button class="giftwin__button" id="getGifts">Получить!</button>
	</div>	
{% else %}
	<h1 class="giftwin__title">Подарков нет</h1>
	<h3 class="text-center fz26px">
		<span class="mr4px">Подарки были удалены или уже получены!</span>
	</h3>
	<div class="giftwin__buttons">
		<button class="giftwin__button" ddrpopupclose>Закрыть</button>
	</div>	
{% endif %}	