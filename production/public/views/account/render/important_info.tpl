<ul class="tabstitles">
	{% if agreement %}<li id="agreement" class="active"><p>Договор</p></li>{% endif %}
	{% if info %}
	{% for k, item in info %}
		{% if item.stat %}
			<li id="info{{k}}"><p>{{item.title}}</p></li>
		{% endif %}
	{% endfor %}
{% endif %}
</ul>	


<div class="tabscontent">
	{% if agreement %}<div tabid="agreement" class="visible">{{agreement|raw}}</div>{% endif %}
	{% if info %}
		{% for k, item in info %}
			{% if item.stat %}
				<div tabid="info{{k}}">{{item.data|raw}}</div>
			{% endif %}
		{% endfor %}
	{% endif %}
</div>