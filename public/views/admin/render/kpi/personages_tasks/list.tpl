<div kpitaskslist class="ddrlist">
	{% if tasks_list %}
		{% for type, tasks in tasks_list|ksort %}
			<div>
				<strong class="fz12px">{{types[type]}}</strong>
				<ul class="kpitasksitem__list" kpitaskslist>
					{% for task in tasks %}
						<li>
							<small>{{task.task}}</small>
							<small><strong class="fz11px d-block w22px">Х{{task.repeats}}</strong></small>
						</li>
					{% endfor %}
				</ul>
			</div>
		{% endfor %}
	{% else %}
		<p class="kpitasksitem__empty">Нет задач</p>
	{% endif %}
</div>