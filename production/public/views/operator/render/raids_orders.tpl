{% if orders_data %}
	{% for static, orders in orders_data %}
		{% if static in orders_data.access_statics|keys %}
			<h2>{{orders_data.access_statics[static]}}</h2>
			<div class="orders">
				<div class="scroll">
					{% for raidId, order in orders %}
						<ul class="orders__item">
							<li>
								<p><small>тип:</small> {{order.name}}</p>
								<p><small>автор:</small> {{order.from}}</p>
								<p><small>дата:</small> {{order.date|d}}</p>
							</li>
							{% for id, order in order.orders|slice(0, order.orders.length - 1) %}
								<li>
									<div class="field">
										<input type="text" changeorder="{{id}}" value="{{order}}">
									</div>
								</li>
							{% endfor %}
							<li>
								{% for id, order in order.orders|slice(-1) %}
									<div class="textarea">
										<textarea changeorder="{{id}}" rows="4">{{order}}</textarea>
									</div>
								{% endfor %}
							</li>
						</ul>
					{% endfor %}
				</div>
			</div>
		{% endif %}
	{% endfor %}
{% endif %}