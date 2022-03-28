<div class="d-flex align-items-center justify-content-between mb14px">
	<div class="d-flex align-items-center">
		<div class="avatar mr-3" style="background-image: url('{{base_url('public/filemanager/thumbs/'~static.icon)}}')"></div>
		<span>{{static_name}}</span>
	</div>
	<span>Общий бюджет: <strong>{{currency(cash, '<small>₽</small>')}}</strong></span>
</div>	

<table>
	<thead>
		<tr>
			<td>Участник</td>
			<td>Способ оплаты</td>
			<td>Сумма</td>
		</tr>
	</thead>
	<tbody>
		{% if users %}
			{% for uid, user in users %}
				<tr>
					<td>
						<div class="d-flex align-items-center">
							<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/images/users/mini/'~users_data[uid])}}')"></div>
							<p>{{user.nickname}}</p>
						</div>
					</td>
					<td>{{user.pay_method}}</td>
					<td>{{currency(user.payment, '<small>₽</small>')}}</td>
				</tr>
			{% endfor %}
		{% else %}
			<tr>
				<td colspan="3"><p class="empty">Нет данных</p></td>
			</tr>
		{% endif %}
	</tbody>
</table>