{% if personages %}	
	<div slass="popupscroll">
		<table>
			<thead>
				<tr>
					<td>Ник</td>
					<td>Тип брони</td>
					<td>Сервер</td>
				</tr>
			</thead>
			<tbody>
				{% if personages %}	
					{% for item in personages %}
						<tr>
							<td>
								<p class="popuppersonagenick">{{item.nick}}</p>
							</td>
							<td>
								<p class="popuppersonagearmor">{{item.armor}}</p>
							</td>
							<td>
								<p class="popuppersonageserver">{{item.server}}</p>
							</td>
						</tr>
					{% endfor %}
				{% endif %}
			</tbody>
		</table>
	</div>
{% endif %}