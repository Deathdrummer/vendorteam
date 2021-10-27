<h3 class="pollingswin__question">{{title}}</h3>

<hr class="smooth pollingswin__border">

{% if answers_type == 3%}
	<div class="popup__textarea popup__textarea_long">
		<textarea class="" rows="5" questioncustom placeholder="Ваш ответ..." autocomplete="ogg">{{answered}}</textarea>
	</div>
{% elseif variants %}
	<ul class="pollingswin__variants">
		{% for variant in variants %}
			<li>
				{% if answers_type == 1 %}
					<input type="radio" name="questionVariant{{question_id}}" id="questionVariant{{variant.id}}" questionvariant="{{variant.id}}"{% if answered and variant.id in answered %} checked{% endif %}>
				{% else %}
					<input type="checkbox" id="questionVariant{{variant.id}}" questionvariant="{{variant.id}}"{% if answered and variant.id in answered %} checked{% endif %}>
				{% endif %}
				<label class="pollingswin__variant" for="questionVariant{{variant.id}}">{{variant.content}}</label>
			</li>
		{% endfor %}
	</ul>
{% endif %}