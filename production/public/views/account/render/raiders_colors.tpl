{% if raiders_colors %}
<div class="drow dgutter-10 raiderscolors">
	{% for item in raiders_colors %}
		<div class="dcol-5">
			<div class="raiderscolors__item"{% if attr %} {{attr}}{% else %} chooseraidercolor{% endif %}="{{item.color}}" title="{{item.name}}" style="background-color: {{item.color}}">
				<small>{{item.name}}</small>
			</div>
		</div>
	{% endfor %}
</div>
{% else %}
	<p>Нет ни одного цвета</p>
{% endif %}
