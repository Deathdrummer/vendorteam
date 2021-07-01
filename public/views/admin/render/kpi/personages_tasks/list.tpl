<ul class="kpitasksitem__list" kpitaskslist>
	{% if tasks_list %}
			{% for task in tasks_list %}
				<li>
					<small>{{task.task}}</small>
					<small><strong class="fz11px d-block w22px">Х{{task.repeats}}</strong></small>
				</li>
			{% endfor %}
		
	{% else %}
		<p class="kpitasksitem__empty">Нет задач</p>
	{% endif %}
</ul>