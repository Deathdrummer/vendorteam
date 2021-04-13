<div id="addictPayUsersData">
	{% if users_data %}
		{% for stId, users in users_data %}
			<div class="mb-3">
				<div class="d-flex align-items-center mb-2">
					<div class="avatar mr-2" style="background-image: url('{{base_url('public/filemanager/'~statics[stId]['icon'])|is_file('public/images/deleted_mini.jpg')}}')"></div>
					<h3>{{statics[stId]['name']}}</h3>
				</div>
				
				<table>
					<thead>
						<tr>
							<td class="nowidth"></td>
							<td class="w200px">Никнейм</td>
							<td class="w150px">Звание</td>
							<td class="w100px">Сумма</td>
							<td class="w100px">Удержано в депозит</td>
							<td title="Соглашение">Согл.</td>
							<td class="w40px"></td>
						</tr>
					</thead>
					<tbody>
						{% for user in users %}
							<tr>
								<td class="nopadding">
									<div class="avatar" style="background-image: url('{{base_url('public/images/users/'~user.avatar)|is_file('public/images/user_mini.jpg')}}')"></div>
								</td>
								<td>{{user.nickname}}</td>
								<td>{{user.rank}}</td>
								<td>{{user.summ|number_format(2, '.', ' ')}}</td>
								<td>{{user.to_deposit|number_format(2, '.', ' ')}}</td>
								<td class="text-center">
									{% if user.agreement %}
										<i class="fa fa-check" style="color: #15c112;"></i>
									{% else %}
										<i class="fa fa-ban" style="color: #e87777;"></i>
									{% endif %}
								</td>
								<td class="text-center">
									<div class="checkblock">
										<input type="checkbox"{% if user.agreement %} checked{% endif %} id="cacladdictPay{{stId}}_{{user.user_id}}" addictpayuser="{{stId}}|{{user.user_id}}|{{user.summ}}|{{user.to_deposit}}">
										<label for="cacladdictPay{{stId}}_{{user.user_id}}"></label>
									</div>
								</td>
							</tr>
						{% endfor %}
					</tbody>
					<tfoot>
						<tr>
							<td colspan="7" class="right">Общая сумма: <strong totalsumm>{{totals[stId]|number_format(2, '.', ' ')}} р.</strong></td>
						</tr>
					</tfoot>
				</table>	
			</div>
		{% endfor %}
	{% endif %}
</div>