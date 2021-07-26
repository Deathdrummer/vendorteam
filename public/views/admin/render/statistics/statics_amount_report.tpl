{% if report %}
	<div class="report">
		<div>
			<table class="w-18rem">
				<thead>
					<tr>
						<td>Статик</td>
					</tr>	
				</thead>
				<tbody>
					{% for stId, static in statics %}
						<tr>
							<td class="h52px">
								<div class="d-flex align-items-center">
									<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/filemanager/thumbs/'~static.icon)}}')"></div>
									<p>{{static.name}}</p>
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
						{% for rId, report in reports_titles.items %}
							<td class="nowidth"><p class="w120px">{{report.title}}</p></td>
						{% endfor %}
						<td class="p-0"></td>
					</tr>
				</thead>
				<tbody>
					{% for stId, static in statics %}
						<tr>
							{% for rId, rTitle in reports_titles.items %}
								<td class="h52px">
									{% if report[stId][rId] %}
										<p>{{report[stId][rId]|number_format(2, '.', ' ')}} ₽</p>
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
					{% for stId, static in statics %}
						<tr>
							<td class="h52px">
								{% if totals[stId]['median'] %}<strong>{{totals[stId]['median']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
							</td>
							<td class="h52px">
								{% if totals[stId]['avg'] %}<strong>{{totals[stId]['avg']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
							</td>
							<td class="h52px">
								{% if totals[stId]['summ'] %}<strong>{{totals[stId]['summ']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
	</div>
		
{% endif %}