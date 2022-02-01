{% if compounds_data %}
	<div class="popup__data">	
		<div class="reports noborder">	
			<div class="report">
				<div>
					<table class="popup__table report__table_left minheight w230px">
						<thead>
							<tr>
								<td><strong>Участник</strong></td>
							</tr>
						</thead>
						<tbody>
							{% for id, user in compounds_data|sortusers %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									<td>
										<div class="d-flex align-items-center">
											<div class="resign">
												{% if user.is_resign %}<div class="resign__icon" title="Увольняется"></div>{% endif %}
												<img src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="" class="avatar w40px h40px">
											</div>
											<p class="ml4px">{{user.nickname}}</p>
										</div>
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>

				<div class="scroll">
					<table class="popup__table report__table_center minheight" id="koeffsData">
						<thead>
							<tr>
								{% for raidId, raid in raids %}
									<td>
										<div class="w120px">
											<small class="nowrap fz12px mb3px d-block">Рейд № {{raidId}}</small>
											<div class="select">
												<select class="keyitem__select h22px fz12px" editraidtype="{{raidId}}">
													{% if raids_types %}
														{% for rtId, rt in raids_types %}
															<option value="{{rtId}}"{% if raid.name == rt.name %} selected{% endif %}>{{rt.name}}</option>
														{% endfor %}
													{% endif %}
												</select>
												<div class="select__caret"></div>
											</div>
											<strong class="nowrap fz12px mt3px d-block">{{raid.date|d(true)}}</strong>
										</div>
									</td>
								{% endfor %}
								<td class="p0"></td>
							</tr>
						</thead>
						<tbody>
							{% for userId, user in compounds_data|sortusers %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									{% for raidId, raid in raids %}
										<td class="text-center">
											<div class="field w60px">
												<input type="number" class="h26px" showrows step="0.1" min="0" showrows editkoeff="{{user['raids'][raidId]['id']}}|{{userId}}|{{raidId}}" value="{{user['raids'][raidId]['rate']|default(0)}}">
											</div>
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
				
				<div>
					<table class="popup__table report__table_right minheight">
						<thead>
							<tr>
								<td class="w60px"><strong>Сумм. коэфф.</strong></td>
								<td class="w70px" title="Персонажей"><strong>Персон.</strong></td>
								<td class="w70px" title="Эффективность"><strong>Эффект.</strong></td>
								<td class="w70px" title="Штрафы"><strong>Штрафы</strong></td>
							</tr>
						</thead>
						<tbody id="compoundForm">
							{% for id, user in compounds_data|sortusers %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									<td class="text-center">
										{{user.rate_summ|default(0)}}
									</td>
									<td class="text-center">
										<div class="field w60px">
											<input type="number" class="h26px" showrows step="0.1" value="{{user.persones_count|default(0)}}" setcompound="{{id}}|persones_count">
										</div>
									</td>
									<td class="text-center">
										<div class="field w60px">
											<input type="number" class="h26px" showrows step="0.1" value="{{user.effectiveness|default(0)}}" setcompound="{{id}}|effectiveness">
										</div>
									</td>
									<td class="text-center">
										<div class="field w60px">
											<input type="number" class="h26px" showrows step="0.1" value="{{user.fine|default(0)}}" setcompound="{{id}}|fine">
										</div>
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
			</div>
		</div>		
	</div>
{% endif %}