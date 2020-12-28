<h4 class="mb-3">Необходимо заполнить коэффициенты для рейтингов!</h4>

<p class="mb-2">по следующим статикам:</p>

{% if statics %}
	<ul class="ratingstatics">
		{% for static in statics %}
			<li class="ratingstatics__item">
				<div class="ratingstatics__icon">
					<img src="{{base_url('public/filemanager/'~static.icon)|is_file('public/images/deleted_mini.jpg')}}">
				</div>
				<div class="ratingstatics__title"><p>{{static.title}}</p></div>
			</li>
		{% endfor %}	
	</ul>
{% endif %}