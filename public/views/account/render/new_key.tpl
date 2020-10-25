<form id="newKeyForm">
	<div class="popup__title justify-content-between">
		<h6>{{period.name}}</h6>
		<input type="hidden" name="period_id" value="{{period.id}}">
		<div class="popup__select">
			<select name="key_type">
				{% if keys_types %}
					<option value="" disabled="" selected="">Тип ключа</option>
					{% for id, key in keys_types %}
						<option value="{{id}}">{{key}}</option>
					{% endfor %}
				{% else %}
					<option value="" disabled="" selected="">Нет типов</option>
				{% endif %}
			</select>
		</div>
	</div>
	
	
	<div class="popup__data">
		{% if users %}
			<div class="row gutters-5">
				{% for upk, usersPart in users|sortusers|chunktoparts(2, true) %}
					<div class="col-12 col-md-6">
						<table class="popup__table popup__table_hover">
							<thead{% if upk == 1 %} class="hidden-sm-down"{% endif %}>
								<tr>
									<td></td>
									<td><strong>Никнейм</strong></td>
									<td><strong>Явка</strong></td>
									<td><strong>Коэфф.</strong></td>
								</tr>
							</thead>
							<tbody>
								{% for k, user in usersPart %}
									<tr{% if user.id in offtime_users %} class="offtime" title="На выходном"{% endif %}>
										<td class="w1">
											<div class="image" style="background-image: url('public/images/{% if user.avatar %}users/mini/{{user.avatar}}{% else %}user_mini.jpg{% endif %}')"></div>
										</td>
										<td><p>{{user.nickname}}</p></td>
										<td class="w40px text-center">
											<input type="checkbox" value="0" name="key_users[{{user.id}}][appearance]">
										</td>
										<td class="w65px text-center">
											<input type="number" step="0.1" value="0" name="key_users[{{user.id}}][rate]">
										</td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
				{% endfor %}
			</div>
		{% else %}
			<p class="empty">Нет данных</p>
		{% endif %}
	</div>	
</form>