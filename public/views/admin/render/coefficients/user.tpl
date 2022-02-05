{% if compounds.data %}
	<ul class="tabstitles" id="coefficientsUserStatics">
		{% for staticId in compounds.data|keys %}
			<li id="coefficientsUserStatic{{staticId}}">
				<img src="{{base_url('public/filemanager/thumbs/'~statics[staticId]['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="" class="avatar w30px h30px">
				<p class="fz11px ml3px">{{statics[staticId]['name']}}</p>
			</li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent" id="coefficientsUserStaticsContent">
		{% for staticId, compounds_data in compounds.data %}
			<div tabid="coefficientsUserStatic{{staticId}}">
				<div class="reports noborder noselect">
					<div class="report">
						<div>
							<table class="report__table_left w170px">
								<thead>
									<tr>
										<td><strong>Периоды / Рейды</strong></td>
									</tr>
								</thead>
								<tbody>
									{% for periodId, row in compounds_data %}
										{% if row.raids %}
											<tr>
												<td class="h90px">{{periods_names[periodId]['period_name']}}</td>
											</tr>	
										{% endif %}
									{% endfor %}
								</tbody>
							</table>
						</div>
						
						<div class="scroll">
							<table class="report__table_center" koeffsdatauser>
								<thead>
									<tr>
										<td colspan="{{compounds.raids_count}}"></td>
										<td class="p0"></td>
									</tr>
								</thead>
								<tbody>
									{% for row in compounds_data %}
										{% if row.raids %}
											<tr>
												{% for raidId, raidData in row.raids %}
													<td class="h90px w100px">
														<small class="nowrap fz11px mb3px d-block">Рейд № <strong class="fz12px">{{raidId}}</strong></small>
														
														{% if raids_types[raidData.type] %}
															<p class="fz10px text-overflow w90px h12px grayblue" title="{{raids_types[raidData.type]['name']}}">{{raids_types[raidData.type]['name']}}</p>
														{% else %}
															<p class="fz10px text-overflow w90px h12px grayblue" title="Тип рейда удален">Тип рейда удален</p>
														{% endif %}
														
														<strong class="nowrap fz11px d-block">{{raidData.date|d(true)}}</strong>
														<div class="field mt12px w60px">
															<input type="number" class="h26px" showrows step="0.1" min="0" showrows editkoeff="{{raidData['id']}}|{{row.user_id}}|{{raidId}}" value="{{raidData.rate|default(0)}}">
														</div>
													</td>
												{% endfor %}
												<td colspan="{{compounds.raids_count - row.raids|length}}" class="h90px p0"></td>
											</tr>
										{% endif %}
									{% endfor %}
								</tbody>
							</table>
						</div>
						
						<div>
							<table class="report__table_right minheight">
								<thead>
									<tr>
										<td class="w60px"><strong>Сумм. коэфф.</strong></td>
										<td class="w70px" title="Персонажей"><strong>Персон.</strong></td>
										<td class="w70px" title="Эффективность"><strong>Эффект.</strong></td>
										<td class="w70px" title="Штрафы"><strong>Штрафы</strong></td>
									</tr>
								</thead>
								<tbody compoundformuser>
									{% for periodId, row in compounds_data %}
										{% if row.raids %}
											<tr>
												<td class="text-center h90px">
													<strong>{{row.summ_coeffs|default(0)}}</strong>
												</td>
												<td class="text-center h90px">
													<div class="field w60px">
														<input type="number" class="h26px" showrows step="0.1" value="{{row.persones_count|default(0)}}" setcompound="{{periodId}}|{{staticId}}|{{row.user_id}}|persones_count">
													</div>
												</td>
												<td class="text-center h90px">
													<div class="field w60px">
														<input type="number" class="h26px" showrows step="0.1" value="{{row.effectiveness|default(0)}}" setcompound="{{periodId}}|{{staticId}}|{{row.user_id}}|effectiveness">
													</div>
												</td>
												<td class="text-center h90px">
													<div class="field w60px">
														<input type="number" class="h26px" showrows step="0.1" value="{{row.fine|default(0)}}" setcompound="{{periodId}}|{{staticId}}|{{row.user_id}}|fine">
													</div>
												</td>
											</tr>
										{% endif %}
									{% endfor %}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		{% endfor %}
	</div>	
{% endif %}