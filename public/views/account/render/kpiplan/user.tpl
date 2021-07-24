<div class="kpiuserplan">

	<p class="format fz14px mb30px">{{default_text}}</p>

	{% if formdata.visits or formdata.fine %}
		<div class="kpiuserplan__row">
			{% if formdata.visits %}
				<div class="process">
					<p class="process__label">Посещаемость:</p>
					<div class="progressbar">
						<progress class="progressbar__progress" value="{{formdata.visits.fact|default(0)}}" max="{{formdata.visits.need|default(0)}}"></progress>
						<div class="progressbar__value">
							<strong>{{formdata.visits.fact|default(0)}}</strong> <small>из</small> <strong>{{formdata.visits.need|default(0)}}</strong>
						</div>
						<div class="progressbar__stat">
							{% if formdata.visits.fact >= formdata.visits.need %}
								<i class="fa fa-check progressbar__stat_done"></i>
							{% else %}
								<i class="fa fa-close progressbar__stat_fail"></i>
							{% endif %}
						</div>
					</div>
				</div>
			{% endif %}
			
			{% if formdata.fine %}
				<div class="process">
					<p class="process__label">Штрафы:</p>
					<div class="progressbar">
						<progress class="progressbar__progress progressbar__progress_red" value="{{formdata.fine.fact|default(0)}}" max="{{formdata.fine.need|default(0)}}"></progress>
						<div class="progressbar__value">
							<strong>{{formdata.fine.fact|default(0)}}</strong> <small>из</small> <strong>{{formdata.fine.need|default(0)}}</strong>
						</div>
						<div class="progressbar__stat">
							{% if formdata.fine.need == 0 %}
								<i class="fa fa-ban progressbar__stat_empty"></i>
							{% elseif formdata.fine.fact < formdata.fine.need %}
								<i class="fa fa-check progressbar__stat_done"></i>
							{% else %}
								<i class="fa fa-close progressbar__stat_fail"></i>
							{% endif %}
						</div>
					</div>
				</div>
			{% endif %}
		</div>
	{% endif %}
	
	
	
	{% if formdata.custom_fields %}
		<div class="kpiuserplan__row">
			<p class="kpiuserplan__title">Дополнительные задачи</p>
			
			<div class="kpiusercustomtasks">
				{% for field, cFData in custom_fields %}
					<div class="kpiusercustomtasks__row">
						<li class="kpiusercustomtasks__item personagetasks__item{% if formdata['custom_fields'][field]['fact'] == formdata['custom_fields'][field]['need'] %} personagetasks__item_done{% elseif formdata['custom_fields'][field]['fact'] > formdata['custom_fields'][field]['need'] and cFData['type'] != 'bool' %} personagetasks__item_verydone{% elseif formdata['custom_fields'][field]['fact'] > formdata['custom_fields'][field]['need'] and cFData['type'] == 'bool' %} personagetasks__item_done{% endif %}">
							<small class="personagetasks__task">{{cFData['task']}}</small>
							<div class="personagetasks__values">
								{% if cFData['type'] == 'koeff' %}
								<strong>{{formdata['custom_fields'][field]['fact']|default(0)}}</strong>
								<span>из</span>
								<strong>{{formdata['custom_fields'][field]['need']}}</strong>
							{% elseif cFData['type'] == 'bool' %}
								{% if formdata['custom_fields'][field]['fact'] %}
									<i class="fa fa-check done"></i>
								{% else %}
									<i class="fa fa-close fail"></i>
								{% endif %}
							{% endif %}
							</div>
						</li>
					</div>
				{% endfor %}
			</div>
		</div>
	{% endif %}
	
	
	{% if formdata.tasks %}
	<div class="kpiuserplan__row">
		<p class="kpiuserplan__title">Активность на персонажах</p>
		
		{% for personageId, tasks in formdata.tasks %}
			<div class="personagetasks">
				<div class="personagetasks__personage">
					<strong>{{personages[user_id][personageId]['game_id_name']}}</strong>
					<span>{{personages[user_id][personageId]['nick']}}</span>
					<span>{{personages[user_id][personageId]['server']}}</span>
					<span>{{personages[user_id][personageId]['armor']}}</span>
				</div>
				
				<ul class="personagetasks__list">
					{% for taskId, task in tasks %}
						<li class="personagetasks__item{% if progress[user_id][personageId][taskId] == task.repeats %} personagetasks__item_done{% elseif progress[user_id][personageId][taskId] > task.repeats %} personagetasks__item_verydone{% endif %}" ptasksitem>
							<small class="personagetasks__task">{{task.task}}</small>
							<div class="personagetasks__values">
								<strong>{{progress[user_id][personageId][taskId]|default(0)}}</strong>
								<span>из</span>
								<strong>{{task.repeats}}</strong>
							</div>
						</li>
					{% endfor %}
				</ul>
			</div>	
		{% endfor %}
	</div>
	{% endif %}
</div>