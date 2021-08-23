{% if tasks %}
	<div class="d-flex align-items-center mb15px">
		<p class="mb-0 mr10px fz14px">Название шаблона</p>	
		<div class="popup__field w400px">
			<input type="text" placeholder="Введите название" id="kpiFormTemplateTitle" value="{{title}}">
		</div>
	</div>
	
	<div class="drow dgutter-10" id="kpiFormTemplateTasks">
		{% for taskId, task in tasks %}
			<div class="dcol-5">
				<div class="kpitasksgriditemwrap" kpitasksgriditem>
					<input type="checkbox" id="kpiTasksGridItemPlanned{{taskId}}" kpitaskitemtask value="{{taskId}}"{% if taskId in template_tasks|keys %} checked{% endif %}>
					<label class="kpitasksgriditem" for="kpiTasksGridItemPlanned{{taskId}}">
						<p class="kpitasksgriditem__task">{{task.task}}</p>
						
						<div class="kpitasksgriditem__field">
							<small class="kpitasksgriditem__label">Повторить:</small>
							<div class="popup__field">
								<input type="number" max="999" min="1" showrows kpitaskitemtaskrepeats value="{{template_tasks[taskId]|default('1')}}">
							</div>
						</div>
					</label>
				</div>
			</div>
		{% endfor %}
	</div>
{% endif %}