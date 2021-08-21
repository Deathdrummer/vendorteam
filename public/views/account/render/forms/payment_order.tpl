<div class="popup__form" id="paymentOrderForm">
	{% for k, item in fields %}
		{% set rules = '' %}
		{% set rules = rules~item.required %}
		
		{% set rand = rand() %}
		
		{% if item.type == 'text' %}
			{% set rules = rules~'||length:3,100|Ошибка! Длина строки должна быть от 3 до 100 символов!' %}
		{% endif %}
		
		{% if item.type == 'tel' %}
			{% set rules = rules~'||phone|Ошибка! Номер введен неверно!' %}
		{% endif %}
		
		{% if item.type == 'email' %}
			{% set rules = rules~'||email|Ошибка! E-mail введен неверно!' %}
		{% endif %}
		
		{% if item.type == 'number' %}
			{% set rules = rules~'||number|Ошибка! Поле должно содержать только число' %}
		{% endif %}
		
		{% if item.type == 'textarea' %}
			{% set rules = rules~'||length:3,1000|Ошибка! Длина строки должна быть от 3 до 1000 символов!' %}
		{% endif %}
		
		{% if item.type == 'select' %}
			{% set rules = rules~'||length:3,1000|Ошибка! Длина строки должна быть от 3 до 1000 символов!' %}
		{% endif %}
		
		
		<div class="popup__form_item{% if item.type == 'textarea' %} textarea{% endif %}">
			{% if item.type == 'textarea' %}
				<div class="popup__textarea popup__textarea_long">
					<label class="popup__label" for="fieldPay{{k~rand}}">{{item.label}}</label>
					<textarea name="field_pay_{{k}}" rows="5" rules="{{rules|trim('||', 'left')}}" id="fieldPay{{k~rand}}" rows="5" placeholder="{{item.placeholder}}"></textarea>
				</div>
			{% elseif item.type == 'select' %}
				<div class="popup__select">
					<label class="popup__label" for="fieldPay{{k~rand}}">{{item.label}}</label>
					<select name="field_pay_{{k}}" rules="{{rules|trim('||', 'left')}}" id="fieldPay{{k~rand}}">
						{% for val in item.values|split(',') %}
							<option value="{{val|trim}}">{{val|trim}}</option>
						{% endfor %}
					</select>
					<div class="select__caret"></div>
				</div>
			{% else %}
				<div class="popup__field">
					<label class="popup__label" for="fieldPay{{k~rand}}">{{item.label}}</label>
					<input type="{{item.type}}" name="field_pay_{{k}}" rules="{{rules|trim('||', 'left')}}" id="fieldPay{{k~rand}}" placeholder="{{item.placeholder}}">
				</div>
			{% endif %}
		</div>
	{% endfor %}
</div>