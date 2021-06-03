{% if data %}
	{% for stId, users in data %}
		<div class="mb-3">
			<h3>{{statics[stId]}}</h3>
			<table>
				<thead>
					<tr>
						<td class="nowidth"></td>
						<td class="w200px">Никнейм</td>
						<td class="w150px">№ заказа</td>
						<td class="w100px">Сумма</td>
						{#<td class="w100px">Удержано в депозит</td>#}
						<td>Комментарий</td>
					</tr>
				</thead>
				<tbody>
					{% for user in users %}
						<tr>
							<td class="nopadding">
								<div class="avatar" style="background-image: url('{{base_url('public/images/users/'~user.avatar)|is_file('public/images/user_mini.jpg')}}')"></div>
							</td>
							<td>{{user.nickname}}</td>
							<td>{{user.order}}</td>
							<td><strong>{{user.summ|number_format(2, '.', ' ')}} ₽</strong></td>
							{#<td><strong>{{user.to_deposit|number_format(2, '.', ' ')}} ₽</strong></td>#}
							<td><small>{{user.comment}}</small></td>
						</tr>
					{% endfor %}
				</tbody>
				<tfoot>
					<tr>
						<td colspan="5" class="right">Общая сумма: <strong>{{total[stId]|number_format(2, '.', ' ')}} ₽</strong></td>
					</tr>
				</tfoot>
			</table>	
		</div>
	{% endfor %}
{% endif %}