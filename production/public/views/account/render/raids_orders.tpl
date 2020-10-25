{% if orders_data %}
	{% for static, orders in orders_data %}

		{% if static in orders_data.access_statics|keys %}
			<h2>{{orders_data.access_statics[static]}}</h2>
			<div class="report">
				<div class="scroll">
					<table>
						<thead>
							<tr>
								{% for raidId, order in orders %}
									<td>
										<p>{{order.from}}</p>
										<p>{{order.date|d}}</p>
										<p>{{order.name}}</p>
										<p></p>
									</td>
								{% endfor %}
							</tr>
						</thead>
						<tbody>
							<tr>
							{% for raidId, order in orders %}
								<td>
									{% for id, order in order.orders %}
										<input type="text" changeorder="{{id}}" value="{{order}}">
									{% endfor %}
								</td>
							{% endfor %}
						</tr>
					</tbody>
					</table>
				</div>
			</div>
		{% endif %}
	{% endfor %}
{% endif %}