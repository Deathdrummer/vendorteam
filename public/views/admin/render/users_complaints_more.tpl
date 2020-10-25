{% if users_list_complaints|length > 0 %}
	{% set colc = '' %}
	
	{% for k, item in fields_complaints_setting %}
		{% set colc = colc~'|'~k %}
	{% endfor %}
	
	{% for kf, field in users_list_complaints %}
		<tr>
			{% for i in colc|trim('|', 'left')|split('|') %}
				<td>{{field['field_complaints_'~i]}}</td>
			{% endfor %}
			<td>{{field['date']|slice(0, -3)|date("d-m-Y H:i")}}</td>
			<td class="access_block">
				{% if field['stat'] %}
					<div access="0" class="success" data-keyfield="{{kf}}" data-type="complaints" title="разрешен"></div>
				{% else %}
					<div access="1" class="forbidden" data-keyfield="{{kf}}" data-type="complaints" title="не разрешен"></div>
				{% endif %}
			</td>
		</tr>
	{% endfor %}
{% endif %}