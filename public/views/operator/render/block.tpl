{% if items %}
	<div class="ddrblock">
		{% for item in items %}
			<div class="ddrblock__item">
				{% if file_exists('public/views/admin/form/'~item.component~'.tpl') %}
					{% set comp = 'views/admin/form/'~item.component~'.tpl' %}
				{% elseif file_exists('public/views/admin/form/'~item.component~'.tpl') %}
					{% set comp = 'views/admin/form/'~item.component~'.tpl' %}
				{% endif %}
				{% include comp with item.data %}
			</div>
		{% endfor %}
	</div>
{% endif %}