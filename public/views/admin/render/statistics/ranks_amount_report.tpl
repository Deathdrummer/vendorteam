{% if report %}
	<ul class="tabstitles sub">
		{% for static in report|keys %}
			<li id="tabStaticAmount{{static}}">{{statics[static]}}</li>
		{% endfor %}
	</ul>
	
	
	<div class="tabscontent">
		{% for static, ranksData in report %}
			<div tabid="tabStaticAmount{{static}}">
				
				<div class="report">
					<div>
						<table class="w-16rem">
							<thead>
								<tr>
									<td>Звание</td>
								</tr>	
							</thead>
							<tbody>
								{% for rank in ranksData|keys|sort %}
									<tr>
										<td class="h52px">
											<p>{{ranks[rank]['name']}}</p>
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
								{% for rId, timepoints in ranksData|sort %}
									<tr>
										{% for timepoint in reports_titles %}
											<td class="h52px">
												{% if report[static][rId][timepoint] %}
													<p>{{report[static][rId][timepoint]|number_format(2, '.', ' ')}} ₽</p>
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
								{% for rId, timepoints in ranksData|sort %}
									<tr>
										<td class="h52px">
											{% if totals[static][rId]['median'] %}<strong>{{totals[static][rId]['median']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
										</td>
										<td class="h52px">
											{% if totals[static][rId]['avg'] %}<strong>{{totals[static][rId]['avg']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
										</td>
										<td class="h52px">
											{% if totals[static][rId]['summ'] %}<strong>{{totals[static][rId]['summ']|number_format(2, '.', ' ')}} ₽</strong>{% else %}-{% endif %}
										</td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
				</div>
				
				
				
			</div>
		{% endfor %}
	</div>
{% endif %}