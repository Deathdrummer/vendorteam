{% if count %}
	<p>подарок успешно получен!</p>
	<p>{{count|padej(['остался', 'осталось', 'осталось'])}} еще {{count}} {{count|padej(['подарок', 'подарка', 'подарков'])}}</p>
	<button id="getNextGiftBtn">Получить еще</button>

	<button id="closeGiftsWinBtn">Закрыть</button>
{% else %}
	<h3 class="text-center">Все подарки получены!</h3>
	<button id="closeGiftsWinBtn">Закрыть</button>
{% endif %}
