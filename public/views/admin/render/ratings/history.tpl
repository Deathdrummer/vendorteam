{% if history %}
	<div tabid="tabSubCoeffs">
		<table>
			<thead>
				<tr>
					<td class="w100px">От кого</td>
					<td class="w300px">Кому</td>
					<td class="w300px">Тип</td>
					<td>Коэффициент</td>
					<td class="w220px">Дата</td>
				</tr>
			</thead>
			<tbody>
				{% if history.coeffs %}
					{% for row in history.coeffs %}
						<tr>
							<td>{{row.from}}</td>
							<td>
								<div class="row gutters-5 align-items-center">
									<div class="col-auto">
										<div class="avatar" style="background-image: url('{{base_url('public/images/users/'~row.avatar)|is_file('public/images/user_mini.jpg')}}')"></div>
									</div>
									<div class="col">
										<p><strong>{{row.nickname}}</strong></p>
										<p><small>{{row.role}}</small></p>
										<small>{{row.rank}}</small>
									</div>
								</div>
							</td>
							<td>{{row.type}}</td>
							<td>
								{% if row.data.coeff %}
									<p><strong>{{row.data.coeff}}</strong></p>
								{% endif %}
								
								{% if row.data.index %}
									<p>Индекс: <strong>{{row.data.index}}</strong></p>
								{% endif %}
								
								{% if row.data.date %}
									<p>Дата: <strong>{{row.data.date|d}}</strong></p>
								{% endif %}
								
								{% if row.data.message %}
									<p class="mt-2">Причина: <strong class="raw">{{row.data.message|raw}}</strong></p>
								{% endif %}
							</td>
							<td class="relative">
								{{row.date|d}} в {{row.date|t}}
							</td>
						</tr>
					{% endfor %}
				{% else %}
					<tr><td colspan="5"><p class="empty center">Нет данных</p></td></tr>
				{% endif %}
			</tbody>
		</table>
	</div>

	<div tabid="tabSubOthers">
		<table>
			<thead>
				<tr>
					<td class="w100px">От кого</td>
					<td class="w300px">Кому</td>
					<td class="w300px">Тип</td>
					<td>Данные</td>
					<td>Причина</td>
					<td class="w220px">Дата</td>
					<td class="w50px">Статус</td>
				</tr>
			</thead>
			<tbody>
				{% if history.others %}
					{% for row in history.others %}
						<tr>
							<td>{{row.from}}</td>
							<td>
								<div class="row gutters-5 align-items-center">
									<div class="col-auto">
										<div class="avatar" style="background-image: url('{{base_url('public/images/users/'~row.avatar)|is_file('public/images/user_mini.jpg')}}')"></div>
									</div>
									<div class="col">
										<p><strong>{{row.nickname}}</strong></p>
										<p><small>{{row.role}}</small></p>
										<small>{{row.rank}}</small>
									</div>
								</div>
							</td>
							<td>{{row.type}}</td>
							<td>
								{% if row.data.coeff %}
									<p>Коэффициент: <strong>{{row.data.coeff}}</strong></p>
								{% endif %}
								
								{% if row.data.index is not null %}
									<p>Индекс: <strong>{{row.data.index}}</strong></p>
								{% endif %}
								
								{% if row.data.date %}
									<p>Дата: <strong>{{row.data.date|d}}</strong></p>
								{% endif %}
							</td>
							<td>
								{% if row.data.message %}
									<p class="raw">{{row.data.message|raw}}</p>
								{% endif %}
							</td>
							<td>
								{{row.date|d}} в {{row.date|t}}
							</td>
							<td class="text-center">
								{% if row.status == -1 %}
									<i class="removed fa fa-eraser" title="Удалено"></i>
								{% elseif row.status == 1 %}
									<i class="added fa fa-plus" title="Добавлено"></i>
								{% elseif row.status == 2 %}
									<i class="updated fa fa-refresh" title="Обновлено"></i>
								{% endif %}
							</td>
						</tr>
					{% endfor %}
				{% else %}
					<tr><td colspan="7"><p class="empty center">Нет данных</p></td></tr>
				{% endif %}
			</tbody>
		</table>
	</div>
{% endif %}