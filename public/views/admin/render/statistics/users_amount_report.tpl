{% if report %}
	<div class="report">
		<div>
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
		</div>
			
		<div class="scroll">
			<table>
				<thead>
					<tr>
						{% for timepoint in reports_titles %}
							<td class="nowidth"><p class="w130px">{{timepoint|month('full')|upper}} {{date('Y', timepoint)}} г.</p></td>
						{% endfor %}
						<td class="p-0"></td>
					</tr>
				</thead>
				<tbody>
					{% for uId, user in users %}
						<tr>
							{% for timepoint in reports_titles %}
								<td class="h52px">
									{% if report[uId][timepoint] %}
										<p>{{report[uId][timepoint]|number_format(2, '.', ' ')}} ₽</p>
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
		
		<div>
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
	</div>
		
{% endif %}