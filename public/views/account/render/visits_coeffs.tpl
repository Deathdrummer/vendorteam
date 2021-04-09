<div class="popup__data">
	{% for stId, staticData in coeffs_data %}
		<h3>{{statics[stId]['name']}}</h3>
		<div class="reports mb40px" style="min-width: 0px !important">
			{% if staticData %}
				<div class="report">
					<table class="popup__table report__table_left minheight" style="min-width: 230px !important;">
						<thead>
							<tr>
								<td></td>
								<td><strong>Никнейм</strong></td>
							</tr>
						</thead>
						<tbody>
							{% for id, user in staticData.coeffs %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									<td class="w1 nopadding">
										<div class="image mini" style="background-image: url('public/images/{% if user.avatar %}users/mini/{{user.avatar}}{% else %}user_mini.jpg{% endif %}')"></div>
									</td>
									<td>{{user.nickname}}</td>
								</tr>
							{% endfor %}
						</tbody>
					</table>
					
					<div class="scroll" style="max-width: 714px !important">
						<table class="popup__table report__table_center minheight" id="koeffsData">
							<thead>
								<tr>
									{% for raidId, raid in staticData.raids %}
										<td class="nowidth">
											<small class="nowrap">Рейд № {{raidId}}</small>	
											<small class="nowrap">{{raid.name}}</small>
											<small class="nowrap">{{raid.date|d(true)}}</small>
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</thead>
							<tbody>
								{% for userId, user in staticData.coeffs %}
									<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
										{% for raidId, raid in staticData.raids %}
											<td class="text-center">
												{{user['raids'][raidId]['rate']}}
											</td>
										{% endfor %}
										<td class="p0"></td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
						
					</div>
					<form id="compoundForm">
						<table class="popup__table report__table_right minheight">
							<thead>
								<tr>
									<td><strong>Сумм. коэфф.</strong></td>
									<td><strong>Персонажей</strong></td>
									<td><strong>Эффективн.</strong></td>
									<td><strong>Штрафы</strong></td>
								</tr>
							</thead>
							<tbody>
								{% for id, user in staticData.coeffs %}
									<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
										<td class="w1 text-center">
											{{user.rate_summ|default(0)}}
										</td>
										<td class="w1 text-center">
											{{user.persones_count|default(0)}}
										</td>
										<td class="w1 text-center">
											{{user.effectiveness|default(0)}}
										</td>
										<td class="w1 text-center">
											{{user.fine|default(0)}}
										</td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</form>
				</div>
			{% endif %}
		</div>
	{% endfor %}
</div>