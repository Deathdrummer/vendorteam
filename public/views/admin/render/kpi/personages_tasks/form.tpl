{% if tasks %}
	<div class="drow dgutter-10" id="kpiTasksItemms">
		{% for taskId, task in tasks %}
			<div class="dcol-5">
				<div class="kpitasksgriditemwrap">
					<input type="checkbox" id="kpiTasksGridItem{{taskId}}"{% if personage_tasks[taskId] %} checked{% endif %} kpitaskitemtask value="{{taskId}}">
					<label class="kpitasksgriditem" for="kpiTasksGridItem{{taskId}}">
						<p class="kpitasksgriditem__task" kpitaskitemtasktext>{{task.task}}</p>
						
						<div class="kpitasksgriditem__field">
							<small class="kpitasksgriditem__label">Повторить:</small>
							<div class="popup__field">
								<input type="number" max="999" min="1" showrows kpitaskitemrepeats value="{{personage_tasks[taskId]|default(1)}}">
							</div>
						</div>
					</label>
				</div>
			</div>
		{% endfor %}
	</div>
{% endif %}