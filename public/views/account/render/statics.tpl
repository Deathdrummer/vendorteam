{% if statics %}
	<div class="popup__title">
		<h6>Выберите статик</h6>
	</div>
	<ul class="popup__list">
		{% for stId, stData in statics %}
			<li {{attr|default('static')}}="{{stId}}">
				<div class="image wpx30"><img src="{{base_url('public/filemanager/')}}{{stData.icon}}" alt=""></div>
				<span>{{stData.name}}</span>
			</li>
		{% endfor %}
	</ul>
{% endif %}