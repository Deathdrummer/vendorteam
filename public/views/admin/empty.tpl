<div id="startPageNav" class="startpage noselect">
	<div class="row justify-content-center">
		{% for sectionTitle, sectionsList in sections %}
			<div class="col-12 col-sm-6 col-lg-auto">
				<p class="startpage__title">{{sectionTitle}}</p>
				<ul class="startpage__block">
					{% for url, title in sectionsList %}
						<li class="startpage__item" data-block="{{url}}">{% if title is iterable %}{{title.title}}{% else %}{{title}}{% endif %}</li>
					{% endfor %}
				</ul>
			</div>
		{% endfor %}
	</div>
</div>