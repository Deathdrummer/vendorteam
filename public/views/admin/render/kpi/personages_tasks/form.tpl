{% if tasks %}
	<div id="progressPlanPersonages">
		<ul class="tabstitles h30px">
			<li id="tabTasksPlanned">Плановые</li>
			<li id="tabTasksBonus">Бонусные</li>
		</ul>
		
		<div class="tabscontent" id="kpiTasksItemms">
			<div tabid="tabTasksPlanned">
				<div class="drow dgutter-10">
					{% for taskId, task in tasks %}
						<div class="dcol-5">
							<div class="kpitasksgriditemwrap">
								<input type="checkbox" id="kpiTasksGridItemPlanned{{taskId}}"{% if personage_tasks[1][taskId] %} checked{% endif %} kpitaskitemtask value="{{taskId}}">
								<label class="kpitasksgriditem" for="kpiTasksGridItemPlanned{{taskId}}">
									<p class="kpitasksgriditem__task" kpitaskitemtasktext>{{task.task}}</p>
									
									<div class="kpitasksgriditem__field">
										<small class="kpitasksgriditem__label">Повторить:</small>
										<div class="popup__field">
											<input type="number" max="999" min="1" showrows kpitaskitemrepeats value="{{personage_tasks[1][taskId]|default(1)}}">
											<input type="hidden" kpitaskitemtasktype value="1">
										</div>
									</div>
								</label>
							</div>
						</div>
					{% endfor %}
				</div>
			</div>
			<div tabid="tabTasksBonus">
				<div class="drow dgutter-10">
					{% for taskId, task in tasks %}
						<div class="dcol-5">
							<div class="kpitasksgriditemwrap">
								<input type="checkbox" id="kpiTasksGridItemBonus{{taskId}}"{% if personage_tasks[2][taskId] %} checked{% endif %} kpitaskitemtask value="{{taskId}}">
								<label class="kpitasksgriditem" for="kpiTasksGridItemBonus{{taskId}}">
									<p class="kpitasksgriditem__task" kpitaskitemtasktext>{{task.task}}</p>
									
									<div class="kpitasksgriditem__field">
										<small class="kpitasksgriditem__label">Повторить:</small>
										<div class="popup__field">
											<input type="number" max="999" min="1" showrows kpitaskitemrepeats value="{{personage_tasks[2][taskId]|default(1)}}">
											<input type="hidden" kpitaskitemtasktype value="2">
										</div>
									</div>
								</label>
							</div>
						</div>
					{% endfor %}
				</div>
			</div>
		</div>
	</div>
{% endif %}