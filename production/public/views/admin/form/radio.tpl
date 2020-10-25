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


<div class="item{% if class %} {{class}}{% endif %}{% if inline %} inline{% endif %}">
	<div class="radio">
		{% if not nolabel %}<label><span>{{label}}</span></label>{% endif %}
		<div class="radio_items">
			{% for thislabel, thisvalue in data %}
				<div class="radio_items_item">
					<label for="{{id~thisvalue}}">
						{% if value == thisvalue %}
							<input type="radio" checked name="{{inpName}}" id="{{id~thisvalue}}" value="{{thisvalue}}" {% if placeholder %} placeholder="{{placeholder}}"{% endif %}>
						{% else %}
							<input type="radio" name="{{inpName}}" id="{{id~thisvalue}}" value="{{thisvalue}}" {% if placeholder %} placeholder="{{placeholder}}"{% endif %}>
						{% endif %}
						<span>{{thislabel}}</span>
					</label>
				</div>
			{% endfor %}
		</div>
	</div>
</div>