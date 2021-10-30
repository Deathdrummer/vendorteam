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
				{% elseif answers_type == 2 %}
					<input type="checkbox" id="questionVariant{{variant.id}}" questionvariant="{{variant.id}}"{% if answered and variant.id in answered %} checked{% endif %}>
				{% endif %}
				<label class="pollingswin__variant" for="questionVariant{{variant.id}}">{{variant.content}}</label>
			</li>
		{% endfor %}
		
		{% if other_variant %}
			<li questionothervariant>
				{% if answers_type == 1 %}
					<input type="radio" name="questionVariant{{question_id}}" id="questionVariantOther" questionvariant="other"{% if answered_other or other %} checked{% endif %}>
				{% elseif answers_type == 2 %}
					<input type="checkbox" id="questionVariantOther" questionvariant="other"{% if answered_other or other %} checked{% endif %}>
				{% endif %}
				<label class="pollingswin__variant pollingswin__variant_other" for="questionVariantOther">
					<span class="mr10px">Другое:</span>
					<div id="questionVariantOtherField" class="pollingswin__otherfield format" contenteditable>{{answered_other|default(other)}}</div>
				</label>
			</li>
		{% endif %}
	</ul>
{% endif %}