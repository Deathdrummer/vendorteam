<ul class="tabstitles h-xl-50px">
	{% if statics %}
		{% for stId, static in statics %}
			<li id="coefficientsStatic_{{stId}}" class="d-block pl3px pr3px text-center">
				<img src="{{base_url('public/filemanager/thumbs/'~static['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="" class="avatar w20px h20px mx-auto mt3px hidden-lg-down">
				<div class="mt3px">
					<p class="fz11px">{{static['name']}}</p>
				</div>
			</li>
		{% endfor %}
	{% else %}
		<p class="empty fz14px pl5px">Нет данных</p>
	{% endif %}
</ul>