{% if classes %}
	<p class="text-center mb10px">Выбрать класс</p>
	<ul class="popup__list">
		{% for clsId, cls in classes %}
			<li title="Выбрать класс" choosementorsclass="{{clsId}}|{{cls.user_id}}">
				<span>{{cls.class_name}}</span>
			</li>
		{% endfor %}
	</ul>
{% else %}
	<p class="empty center">Нет данных</p>
{% endif %}