{% set inpName, id, value = '', '', '' %}
{% set pf = postfix|postfix_setting %}

{% for k, item in name|split('|') %}
	{% if k == 0 %}
		{% set inpName = item~pf %}
		{% set value = attribute(_context, item~pf) %}
		{% set id = item~pf %}
	{% else %}
		{% set inpName = inpName~'['~item~']' %}
		{% set value = value[item] %}
		{% set id = id~item %}
	{% endif %}
{% endfor %}


<div class="item {{class|default('w100')}}{% if inline %} inline{% endif %}">
	<div class="textarea">
		<label for="{{id}}"><span>{{label}}</span></label>
		<textarea 
			{% if editor %}editor="{{editor}}"{% endif %}
			name="{{inpName}}"
			id="{{id}}"
			rows="{{rows|default(6)}}"{% if placeholder %}
			placeholder="{{placeholder}}"{% endif %}>{% if value is defined and value is not empty %}{{value|default(default)}}{% endif %}</textarea>
	</div>
</div>