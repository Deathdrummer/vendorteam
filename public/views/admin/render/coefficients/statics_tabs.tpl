<ul class="tabstitles">
	{% if statics %}
		{% for stId, static in statics %}
			<li id="coefficientsStatic_{{stId}}">
				<img src="{{base_url('public/filemanager/thumbs/'~static['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="" class="avatar w30px h30px">
				<p class="fz12px ml4px">{{static['name']}}</p>
			</li>
		{% endfor %}
	{% else %}
		<p class="empty fz14px pl5px">Нет данных</p>
	{% endif %}
</ul>