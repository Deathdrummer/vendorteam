{% if questions %}
	{% set iter = 1 %}
	<div class="userquestions"></div>
	{% for qId, qTitle in questions %}
		<div class="userquestions__item">
			<h4 class="userquestions__question"><span>{{iter}}.</span> {{qTitle}}</h4>
			{% if useranswers[qId] %}
					<ul class="userquestions__variants">
						{% if useranswers[qId]['variants'] %}
							{% for variant in useranswers[qId]['variants'] %}
								<li>
									<span>{{variants[variant]['content']}}</span>
									<span>({{variants[variant]['scores']}} {{variants[variant]['scores']|padej(['балл', 'балла', 'боллов'])}})</span>
								</li>
							{% endfor %}
						{% endif %}
						
						{% if useranswers[qId]['other'] %}
							<li>
								<span><strong>Другое:</strong> {{useranswers[qId]['other']}}</span>
								<span></span>
							</li>
						{% endif %}
						
						{% if useranswers[qId]['custom'] %}
							<li>
								<span><strong>Свой ответ:</strong> {{useranswers[qId]['custom']}}</span>
								<span></span>
							</li>
						{% endif %}
					</ul>
			{% else %}
				<p class="userquestions__empty">Ответ не дан</p>
			{% endif %}
		</div>
			
		{% set iter = iter + 1 %}
	{% endfor %}
{% endif %}


<p class="userquestions__scores">Всего баллов: <strong>{{total_scores}}</strong></p>