{% if list %}
	{% for datePoint, items in list %}
		<tr>
			<td colspan="4" class="center lightblue_bg"><strong class="fz14px">{{datePoint|d}} {{datePoint|week}}</strong></td>
		</tr>
		{% for item in items %}
			{% include 'views/admin/render/adminsactions/item.tpl' with item %}
		{% endfor %}
	{% endfor %}
{% endif %}