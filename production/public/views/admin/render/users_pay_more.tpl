{% if users_list_pay|length > 0 %}
	{% set colsp = '' %}
	
	{% for k, item in fields_pay_setting %}
		{% set colsp = colsp~'|'~k %}
	{% endfor %}
	
	{% for kf, field in users_list_pay %}
		<tr>
			{% for i in colsp|trim('|', 'left')|split('|') %}
				<td>{{field['field_pay_'~i]}}</td>
			{% endfor %}
			<td>{{field['date']|slice(0, -3)|date("d-m-Y H:i")}}</td>
			<td class="access_block">
				{% if field['stat'] %}
					<div access="0" class="success" data-keyfield="{{kf}}" data-type="pay" title="разрешен"></div>
				{% else %}
					<div access="1" class="forbidden" data-keyfield="{{kf}}" data-type="pay" title="не разрешен"></div>
				{% endif %}
			</td>
		</tr>
	{% endfor %}
{% endif %}