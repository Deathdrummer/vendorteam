<div popup id="button1" data-class="" wraptoclose data-action="main/form_order" data-width="{{popup_width_setting}}" data-button="Отправить" data-closetime="5" data-cancel="Отмена" data-callback="addPayItem">
	<title>{{left_popup_title_setting}}</title>
	
	<popupform>
		{% for k, item in fields_pay_setting %}
			{% set rules = item.required %}
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
		
		<div class="popup__form_item">
			<div class="button__block_text">
				{{button_left_text_setting|raw}}
			</div>
		</div>
			
		
		<input type="hidden" name="user_id" value="{{id}}">
		<input type="hidden" name="user_avatar" value="{{avatar}}">
		<input type="hidden" name="nickname" value="{{nickname|default('Не задано')}}">
		<input type="hidden" name="static" value="{{main_static|default('Не задан')}}">
		<input type="hidden" name="site_protocol" value="{{site_protocol}}">
		<input type="hidden" name="site_url" value="{{page_url}}">
		<input type="hidden" name="from" value="{{email_from_setting}}">
		<input type="hidden" name="to" value="{{email_to_setting}}">
		<input type="hidden" name="title" value="{{email_title_setting}}">
		<input type="hidden" name="template" value="account/email/send_pay">
	</popupform>
	
	<success notitle>
		<h1 class="text-center">{{popup_success_setting}}</h1>
	</success>
	
	<li submit><svg><use xlink:href="#complaints"></use></svg><span>{{button_left_title_setting}}</span></li>
</div>