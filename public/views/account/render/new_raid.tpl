<form id="newRaidForm">
	<div class="popup__title justify-content-between">
		<h6>{{period.name}}</h6>
		<input type="hidden" name="period_id" value="{{period.id}}">
		<div class="popup__select">
			<select name="raid_type">
				{% if raids_types %}
					<option value="" disabled="" selected="">Тип рейда</option>
					{% for id, raid in raids_types %}
						<option value="{{id}}">{{raid}}</option>
					{% endfor %}
				{% else %}
					<option value="" disabled="" selected="">Нет типов</option>
				{% endif %}
			</select>
		</div>
	</div>
	
	
	<div class="popup__data">
		<ul class="tabstitles pt-2 px-1" id="raidStaticTabs">
			<li id="raidStaticUsers" class="active"><p>Список участников</p></li>
			<li id="raidStaticOrders"><p>Список заказов</p></li>
		</ul>
		
		<div class="tabscontent">
			<div tabid="raidStaticUsers" class="visible">
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
													<input type="checkbox"{% if user.nickname not in admin_users and user.id not in offtime_users %} checked value="1"{% else %} value="0"{% endif %} name="raid_users[{{user.id}}][appearance]">
												</td>
												<td class="w65px text-center">
													<input type="number" step="0.1" value="{% if user.nickname in admin_users or user.id in offtime_users %}0{% else %}1{% endif %}" name="raid_users[{{user.id}}][rate]">
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
			<div tabid="raidStaticOrders">
				<table class="popup__table popup__table_hover" id="newRaidOrders">
					<thead>
						<tr>
							<td class="w110px"><strong>№ заказа</strong></td>
							<td><strong>Значение</strong></td>
						</tr>
					</thead>
					<tbody>
						<tr>	
							<td><p>Заказ 1</p></td>
							<td><div class="popup__field"><input type="text" autocomplete="off" name="raid_orders[0]"></div></td>
						</tr>
					</tbody>
					<tfoot>
						<tr>	
							<td><p>Комментарий</p></td>
							<td><div class="popup__textarea popup__textarea_long"><textarea name="raid_orders[]" rows="5"></textarea></div></td>
						</tr>
					</tfoot>
				</table>
			</div>
		</div>
	</div>	
</form>