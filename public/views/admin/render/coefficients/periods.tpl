{% if periods %}
	<div class="row gutters-5">
		<div class="{% if showstatics %}col-5{% else %}col-12{% endif %}">
			<strong class="fz12px">Выбрать период</strong>
			<hr class="smooth mt0px mb10px">
			{% if multiple %}
				<div class="popup__buttons mb10px">
					<button class="popup__buttons_main fz10px h18px pt5px pb5px" id="coeffsPeriodsCheckallBtn">Выбрать все</button>
					<button class="popup__buttons_main fz10px h18px pt5px pb5px" id="coeffsPeriodsUncheckallBtn">Снять выделение</button>
				</div>
			{% endif %}
			<table id="coefficientsPeriods">
				<thead>
					<tr>
						<td>Период</td>
						<td class="center w60px">
							{% if multiple %}
								<i class="fa fa-check" coeffsperiodscheckallbtn></i>
							{% else %}
								<i class="fa fa-check"></i>
							{% endif %}
						</td>
					</tr>
				</thead>
				<tbody>
					{% for period in periods %}
						<tr>
							<td>{{period.name}}</td>
							<td class="center">
								{% if multiple %}
									<div class="checkblock">
											<input type="checkbox" id="coeffsChoosePeriod{{period.id}}" coefficientschooseperiod value="{{period.id}}">
											<label for="coeffsChoosePeriod{{period.id}}"></label>
										</div>
									</td>
								{% else %}
									<div class="checkblock">
										<input type="radio" name="coeffsChoosePeriod" id="coeffsChoosePeriod{{period.id}}" coefficientschooseperiod value="{{period.id}}">
										<label for="coeffsChoosePeriod{{period.id}}"></label>
									</div>
								{% endif %}
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
		
		{% if showstatics %}
			
			<div class="col-7">
				<strong class="fz12px">Выбрать статики</strong>
				<hr class="smooth mt0px mb10px">
				<div class="usersv2buttons mb30px" id="coeffsStaticsGroups">
					<button class="fz13px" coeffsgroupbtn="none">Нет</button>
					<button class="fz13px" coeffsgroupbtn="all">Все</button>
					<button class="fz13px" coeffsgroupbtn="1">Рейды</button>
					<button class="fz13px" coeffsgroupbtn="2">Группа</button>
					<button class="fz13px" coeffsgroupbtn="3">Инактив</button>
				</div>
				
				{% if statics %}
					<div class="usersv2statics" id="coeffsStaticsList">
						<div class="row gutters-5">
							{% for staticsPart in statics|chunktoparts(3, true) %}
								<div class="col-4">
									{% for stId, static in staticsPart %}
										<div class="usersv2statics__item">
											<input type="checkbox" id="coeffsStatic{{stId}}" coeffsstatic="{{stId}}" coeffsstaticgroup="{{static.group}}"{% if static.checked %} checked{% endif %}>
											<label for="coeffsStatic{{stId}}">
												<div class="d-flex align-items-center">
													<img src="{{base_url('public/filemanager/thumbs/'~static.icon)|no_file('public/images/deleted_mini.jpg')}}" alt="{{static.name}}" class="avatar w40px h40px">
													<span class="fz12px ml4px fontcolor">{{static.name}}</span>
												</div>
											</label>
										</div>
									{% endfor %}
								</div>
							{% endfor %}
						</div>	
					</div>
				{% else %}
					<p class="empty center">Нет статиков</p>
				{% endif %}
			</div>
		{% endif %}
	</div>
{% else %}
	<p class="empty">Нет периодов</p>
{% endif %}