<div class="row">
	<div class="col-6">
		<p>Все столбцы</p>
		<ul class="usersv2__list" id="usersFieldsAll">
			{% if fields %}
				{% for field, fData in fields %}
					<li userslistfield="{{field}}"><span>{{fData.title}}</span></li>
				{% endfor %}
			{% else %}
				<p class="empty">Столбцы не загрузились</p>
			{% endif %}
		</ul>
	</div>
	<div class="col-6">
		<p>Отобразить в таблице</p>
		<ul class="usersv2__list usersv2__list_totable" id="usersFieldsToTable">
			{% if selected_fields %}
				{% for field, fData in selected_fields %}
					<li userslistfield="{{field}}"><span>{{fData.title}}</span></li>
				{% endfor %}
			{% endif %}
		</ul>
	</div>
</div>