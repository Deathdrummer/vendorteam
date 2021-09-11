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
	<div class="checkbox">
		{% if label %}<label><span>{{label}}</span></label>{% endif %}
		<div class="checkbox_items">
			{% for thislabel, thisvalue in data %}
				<div class="checkbox_items_item">
					<span>{{thislabel}}</span>
					<div class="checkbox_items_item_block noselect">
						<label for="{{id~thisvalue}}0">
							<input type="radio" {% if value[thisvalue] is not defined or value[thisvalue] == '0' %}checked{% endif %} id="{{id~thisvalue}}0" name="{{inpName}}[{{thisvalue}}]" value="0">
							<span>нет</span>
						</label>
						<label for="{{id~thisvalue}}1">
							<input type="radio" {% if value[thisvalue] == '1' %}checked{% endif %} id="{{id~thisvalue}}1" name="{{inpName}}[{{thisvalue}}]" value="1">
							<span>да</span>
						</label>
					</div>
				</div>
			{% endfor %}
		</div>
	</div>
</div>