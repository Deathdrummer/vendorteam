{% if questions_total %}
	{% set iter = 1 %}
	{% for questionId, data in questions_total %}
		<div class="mb50px">
			<h3 class="fz16px mb15px">{{iter}}. {{questions[questionId]}}</h3>
			{% if data.variants %}
				{% for variantId, answrsCount in data.variants %}
					<div class="mb15px">
						{% if variantId != 'other' %}
							<p class="fz12px mb3px">{{variants[questionId][variantId]|default('Другое')}}</p>
						{% else %}
							<p class="fz12px mb3px pointer" openothervariantanswers>Другое <i class="fa fa-chevron-down"></i></p>
						{% endif %}
						
						<div class="progressbar">
							<progress class="progressbar__progress h16px" value="{{answrsCount}}" max="{{total[questionId]}}"></progress>
							<div class="progressbar__value w70px d-flex justify-content-between align-items-center">
								<h4 class="fz14px">{{((100 / total[questionId]) * answrsCount)|round(1)}}%</h4>
								<span class="fz14px text-right">({{answrsCount}})</span>
							</div>
						</div>
						
						{% if variantId == 'other' and data.other %}
							<ul class="pollingstatotherlist" othervariantanswerslist>
								{% for otherAnswer in data.other %}
									<li>{{otherAnswer}}</li>
								{% endfor %}
							</ul>
						{% endif %}
					</div>
				{% endfor %}
			{% else %}
				<p class="fz14px">Этот вопрос со свободным ответом</p>
			{% endif %}
		</div>
		{% set iter = iter + 1 %}
	{% endfor %}
{% endif %}