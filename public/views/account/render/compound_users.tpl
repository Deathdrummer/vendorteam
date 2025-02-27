<div class="popup__data">
	<div class="reports" style="min-width: 0px !important">
		{% if compounds_data %}
			<div class="report">
				<div>
					<table class="popup__table report__table_left minheight" style="min-width: 230px !important;">
						<thead>
							<tr>
								<td class="nowidth">№</td>
								<td></td>
								<td class="sort{{sortField == 'nickname' ? ' sorted' : ''}}" sortkoeffsdata="nickname|string">
									<strong>Никнейм</strong>
									<i class="fa fa-sort"></i>
								</td>
							</tr>
						</thead>
						<tbody>
							{% set counter = 1 %}
							{% for id, user in compounds_data|sortBy(sortField, sortOrder, sortFieldType) %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									<td class="text-center"><strong>{{counter}}</strong></td>
									<td class="w1 nopadding">
										<div class="image mini" style="background-image: url('public/images/{% if user.avatar %}users/mini/{{user.avatar}}{% else %}user_mini.jpg{% endif %}')">{% if user.is_resign and is_lider %}<div class="resign" title="Увольняется"></div>{% endif %}</div>
									</td>
									<td>{{user.nickname}}</td>
								</tr>
								{% set counter = counter + 1 %}
							{% endfor %}
						</tbody>
					</table>
				</div>

				<div class="scroll" style="max-width: 714px !important">
					<table class="popup__table report__table_center minheight" id="koeffsData">
						<thead>
							<tr>
								{% for raidId, raid in raids %}
									<td class="nowidth">
										<small class="nowrap">Рейд № {{raidId}}</small>	
										{% if is_lider %}
											<select class="keyitem__select" editraidtype="{{raidId}}">
												{% if raids_types %}
													{% for rtId, rt in raids_types %}
														<option value="{{rtId}}"{% if raid.name == rt.name %} selected{% endif %}>{{rt.name}}</option>
													{% endfor %}
												{% endif %}
											</select>
										{% else %}
											<small class="nowrap">{{raid.name}}</small>
										{% endif %}
										<small class="nowrap">{{raid.date|d(true)}}</small>
									</td>
								{% endfor %}
								<td class="p0"></td>
							</tr>
						</thead>
						<tbody>
							{% for userId, user in compounds_data|sortBy(sortField, sortOrder, sortFieldType) %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									{% for raidId, raid in raids %}
										<td class="text-center">
											{% if is_lider %}
												<input type="number" step="0.1" min="0" showrows editkoeff="{{user['raids'][raidId]['id']}}|{{userId}}|{{raidId}}" class="w50px" value="{{user['raids'][raidId]['rate']|default(0)}}">
											{% else %}
												{{user['raids'][raidId]['rate']}}
											{% endif %}
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
					
				</div>
				<div id="compoundForm">
					<table class="popup__table report__table_right minheight w340px">
						<thead>
							<tr>
								<td class="sort{{sortField == 'rate_summ' ? ' sorted' : ''}}" sortkoeffsdata="rate_summ|number">
									<strong>Сумм. коэфф.</strong>
									<i class="fa fa-sort"></i>
								</td>
								{% if settings.showfields.persones_count %}
									<td class="sort{{sortField == 'persones_count' ? ' sorted' : ''}}" sortkoeffsdata="persones_count|number">
										<strong>Персонажей</strong>
										<i class="fa fa-sort"></i>
									</td>
								{% endif %}
								{% if settings.showfields.effectiveness %}
									<td class="sort{{sortField == 'effectiveness' ? ' sorted' : ''}}" sortkoeffsdata="effectiveness|number">
										<strong>Эффективн.</strong>
										<i class="fa fa-sort"></i>
									</td>
								{% endif %}
								<td class="sort{{sortField == 'fine' ? ' sorted' : ''}}" sortkoeffsdata="fine|number">
									<strong>Штрафы</strong>
									<i class="fa fa-sort"></i>
								</td>
							</tr>
						</thead>
						<tbody>
							{% for id, user in compounds_data|sortBy(sortField, sortOrder, sortFieldType) %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									<td class="w1 text-center">
										{{user.rate_summ|default(0)}}
									</td>
									
									{% if settings.showfields.persones_count %}
										<td class="w1 text-center">
											{% if is_lider %}
												<input type="number" step="0.1" value="{{user.persones_count|default(0)}}" name="compound_users[{{id}}][persones_count]" setcompound="{{id}}|persones_count">
											{% else %}
												{{user.persones_count|default(0)}}
											{% endif %}
										</td>
									{% endif %}
									
									{% if settings.showfields.effectiveness %}
										<td class="w1 text-center">
											{% if is_lider %}
												<input type="number" step="0.1" value="{{user.effectiveness|default(0)}}" name="compound_users[{{id}}][effectiveness]" setcompound="{{id}}|effectiveness">
											{% else %}
												{{user.effectiveness|default(0)}}
											{% endif %}
										</td>
									{% endif %}
									
									<td class="w1 text-center">
										{% if is_lider %}
											<input type="number" step="0.1" value="{{user.fine|default(0)}}" name="compound_users[{{id}}][fine]" setcompound="{{id}}|fine">
										{% else %}
											{{user.fine|default(0)}}
										{% endif %}
									</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
			</div>
		{% endif %}
	</div>
</div>
	

















{#<form id="compoundForm">
	<div class="popup__data">
		<div class="compound d-flex">
			{% if compounds_data %}
				<table class="popup__table">
					<thead>
						<tr>
							<td></td>
							<td><strong>Никнейм</strong></td>
						</tr>
					</thead>
					<tbody>
						{% for id, user in compounds_data %}
							<tr>
								<td class="w1 h52px">
									<div class="image" style="background-image: url('public/images/{% if user.avatar %}users/mini/{{user.avatar}}{% else %}user_mini.jpg{% endif %}')"></div>
								</td>
								<td><p>{{user.nickname}}</p></td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
				
				<div class="scroll">
					<table class="popup__table">
						<thead>
							
							<tr>{% for raid in raids %}
								<td><strong>{{raid}}</strong></td>
								{% endfor %}
							</tr>
							
						</thead>
					</table>
				</div>
				
				
				<table class="popup__table">
					<thead>
						<tr>
							<td><strong>Персонажей</strong></td>
							<td><strong>Эффективн.</strong></td>
							<td><strong>Штрафы</strong></td>
						</tr>
					</thead>
					<tbody>
						{% for id, user in compounds_data %}
							<tr>
								<td class="w1 text-center h52px">
									{% if is_lider %}
										<input type="number" step="0.1" value="{{user.persones_count|default(0)}}" name="compound_users[{{id}}][persones_count]">
									{% else %}
										{{user.persones_count|default(0)}}
									{% endif %}
								</td>
								<td class="w1 text-center">
									{% if is_lider %}
										<input type="number" step="0.1" value="{{user.effectiveness|default(0)}}" name="compound_users[{{id}}][effectiveness]">
									{% else %}
										{{user.effectiveness|default(0)}}
									{% endif %}
								</td>
								<td class="w1 text-center">
									{% if is_lider %}
										<input type="number" step="0.1" value="{{user.fine|default(0)}}" name="compound_users[{{id}}][fine]">
									{% else %}
										{{user.fine|default(0)}}
									{% endif %}
								</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			{% endif %}
		</div>
	</div>
</form>#}