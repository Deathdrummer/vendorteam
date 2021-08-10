{% if gifts %}
	<div class="gift__carditems">
		<div class="drow dgutter-20">
			{% for gift in gifts %}
				<div class="dcol-3">
					<div class="gift__card">
						<div class="giftcard">
							<h4 class="giftcard__title">{{gift.title}}</h4>
							<div class="giftcard__value">
								<small>{{actions[gift.action]}}</small>
								<strong>{{gift.value}}</strong>
								{% if gift.action == 'balance' %}
									<span>{{gift.value|padej(['рубль', 'рубля', 'рублей'])}}</span>
								{% elseif gift.action == 'stage' %}
									<span>{{gift.value|padej(['день', 'дня', 'дней'])}}</span>
								{% endif %}
							</div>
						</div>
					</div>
				</div>
			{% endfor %}
		</div>
	</div>
{% endif %}