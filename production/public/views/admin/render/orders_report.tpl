{% if orders_data %}
	{% for static, orders in orders_data %}
		<h2>{{static}}</h2>
		
		<div class="report">
			<table class="orders">
				<thead>
					<tr>
						<td>Автор</td>
						<td>Дата</td>
						<td>Тип рейда</td>
						<td>Список заказов</td>
					</tr>
				</thead>
				<tbody>
					{% for raidId, order in orders %}
						<tr>
							<td>{{order.from}}</td>
							<td class="w20">{{order.date|d}}</td>
							<td class="w14">{{order.name}}</td>
							<td class="noheight">
								<ul class="list_overflow orders nowrap">
									{% for order in order.orders %}
										<li>{{order}}</li>
									{% endfor %}
								</ul>
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
	{% endfor %}
{% endif %}