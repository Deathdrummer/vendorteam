<form id="keysForm">
	<div class="popup__data">
		<div class="reports" style="min-width: 0px !important">
			{% if keys_data %}
				<div class="report">
					<table class="popup__table report__table_left minheight" style="min-width: 230px !important;">
						<thead>
							<tr>
								<td></td>
								<td><strong>Никнейм</strong></td>
							</tr>
						</thead>
						<tbody>
							{% for id, user in keys_data %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									<td class="w1 nopadding">
										<div class="image mini" style="background-image: url('public/images/{% if user.avatar %}users/mini/{{user.avatar}}{% else %}user_mini.jpg{% endif %}')"></div>
									</td>
									<td><strong>{{user.nickname}}</strong></td>
								</tr>
							{% endfor %}
							<tr>
								<td class="right" colspan="2">Сумма коэффициентов:</td>
							</tr>
						</tbody>
					</table>
					
					<div class="scroll" style="max-width: 714px !important">
						<table class="popup__table report__table_center minheight">
							<thead>
								<tr>
									{% for keyId, key in keys %}
										<td class="nowidth">
											<small class="nowrap">Ключ № {{keyId}}</small>	
											{% if is_lider %}
												<select class="keyitem__select" editkeytype="{{keyId}}">
													{% if keys_types %}
														{% for id, name in keys_types %}
															<option value="{{id}}"{% if key.name == name %} selected{% endif %}>{{name}}</option>
														{% endfor %}
													{% endif %}
												</select>
											{% else %}
												<small class="nowrap">{{key.name}}</small>
											{% endif %}
											<small class="nowrap">{{key.date|d(true)}}</small>
										</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</thead>
							<tbody>
								{% for id, user in keys_data %}
									<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
										{% for key in keys|keys %}
											<td class="center">
												{% if is_lider %}
													<input type="number" step="0.1" min="0" showrows editkeykoeff="{{id}}|{{key}}" class="w45px" value="{{user['keys'][key]|default(0)}}">
												{% else %}
													{{user['keys'][key]|default('-')}}
												{% endif %}
											</td>
										{% endfor %}
										<td class="p0"></td>
									</tr>
								{% endfor %}
								<tr>
									{% for keyId, key in keys %}
										<td>{{summ_koeff[keyId]}}</td>
									{% endfor %}
									<td class="p0"></td>
								</tr>
							</tbody>
						</table>
						
					</div>
					
					<table class="minheight report__table_right">
						<thead>
							<tr>
								<td><strong>Сумм. коэфф.</strong></td>
							</tr>
						</thead>
						<tbody>
							{% for id, user in keys_data %}
								<tr{% if user.color %} style="background-color: {{user.color}}"{% endif %}>
									<td class="w1 text-center">
										{{user.rate_summ|default(0)}}
									</td>
								</tr>
							{% endfor %}
							<tr>
								<td>{{all_summ_koeff}}</td>
							</tr>
						</tbody>
					</table>
				</div>
			{% endif %}
		</div>
	</div>
</form>
	

















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
							
							<tr>{% for key in keys %}
								<td><strong>{{key}}</strong></td>
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