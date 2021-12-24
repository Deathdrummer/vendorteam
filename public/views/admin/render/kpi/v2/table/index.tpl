<table>
	<thead>
		<tr>
			<td class="w50px" title="ID Аккаунта"><strong>ID</strong></td>
			<td class="w130px"><strong>Сервер</strong></td>
			<td class="w130px"><strong>Персонаж</strong></td>
			<td class="w160px"><strong>Бустер</strong></td>
			{% if fields %}
				{% for fId, field in fields %}
					<td class="w{{field.width}}px" title="{{field.title}}"><strong class="d-block text-overflow w{{field.width - 10}}px">{{field.title}}</strong></td>
				{% endfor %}
			{% endif %}
			<td class="p0"></td>
		</tr>
	</thead>
	<tbody>
		{% for row in data %}
			<tr>
				<td>{{row['account_id']}}</td>
				<td>{{row['server']}}</td>
				<td>{{row['personage']}}</td>
				<td>
					<div class="row gutters-4 align-items-center justify-content-between">
						<div class="col">
							<span>{{row['booster']}}</span>
						</div>
						<div class="col-auto">
							<i class="fa fa-bars fz18px pointer blue blue_hovered" openboostershistorybtn="{{row['id']}}"></i>
						</div>
					</div>
				</td>
				{% if fields %}
					{% for fId, field in fields %}
						<td>{{row[fId]}}</td>
					{% endfor %}
				{% endif %}
				<td class="p0"></td>
			</tr>
		{% endfor %}
	</tbody>
</table>