{% if fields %}
	{% for fId, fData in fields %}
		<li kpiv2field="{{fId}}">
			<span class="mr-auto">{{fData.title}}</span>
			<i class="fa fa-cog" kpiv2fieldsettingbtn="{{fId}}" title="Изменить натройки"></i>
			<i class="fa fa-trash remove" kpiv2fieldremovebtn="{{fId}}" title="Удалить столбец"></i>
		</li>
	{% endfor %}
{% endif %}