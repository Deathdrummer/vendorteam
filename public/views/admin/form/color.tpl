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

<div class="item {{class|default('w10')}}{% if inline %} inline{% endif %}">
	<div class="field">
		<label for="{{id}}"><span>{{label}}</span></label>
		<input 
			type="color" 
			autocomplete="off"
			name="{{inpName}}" 
			id="{{id}}" 
			value="{% if value is empty and default is not empty %}{{default}}{% else %}{{value}}{% endif %}"
			{% if placeholder %} placeholder="{{placeholder}}"{% endif %}>
	</div>
</div>