{% if report %}
	<div class="report">
		<table class="w-16rem">
			<thead>
				<tr>
					<td>Участник</td>
				</tr>	
			</thead>
			<tbody>
				{% for uId, user in users %}
					<tr>
						<td class="h52px">
							<div class="d-flex align-items-center">
								<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)}}')"></div>
								<p>{{user.nickname}}</p>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
		<div class="scroll">
			<table>
				<thead>
					<tr>
						{% for rId, report in reports_titles.items %}
							<td class="nowidth"><p class="w120px">{{report.title}}</p></td>
						{% endfor %}
						<td class="p-0"></td>
					</tr>
				</thead>
				<tbody>
					{% for uId, user in users %}
						<tr>
							{% for rId, rTitle in reports_titles.items %}
								<td class="h52px">
									{% if report[uId][rId] %}
										<p>{{report[uId][rId]|number_format(2, '.', ' ')}} ₽</p>
									{% else %}
										-
									{% endif %}
								</td>
							{% endfor %}
							<td class="p-0"></td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
		<table class="w-24rem table_fixed">
			<thead>
				<td>Медианное значение</td>
				<td>Среднее значение</td>
				<td>Сумма</td>
			</thead>
			<tbody>
				{% for uId, user in users %}
					<tr>
						<td class="h52px">
							{% if totals[uId]['median'] %}<strong>{{totals[uId]['median']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
						</td>
						<td class="h52px">
							{% if totals[uId]['avg'] %}<strong>{{totals[uId]['avg']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
						</td>
						<td class="h52px">
							{% if totals[uId]['summ'] %}<strong>{{totals[uId]['summ']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
		
	</div>
		
{% endif %}