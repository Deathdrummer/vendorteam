<div class="popup__title">
	<h6>Выберите диапазон</h6>
</div>

<div class="popup__data">
	{% if reports_patterns %}
		<ul class="tabstitles">
			<li id="tabRaids" class="active"><p>Рейды</p></li>
			<li id="tabKeys"><p>Ключи</p></li>
		</ul>
		
		
		<div class="tabscontent">
			<div tabid="tabRaids" class="visible">
			
				<div class="payments">
					<table class="popup__table popup__table_hover">
						<thead>
							<tr>
								<td>Название</td>
								<td>Отчет</td>
							</tr>
						</thead>
						<tbody>
							{% for id, pattern in reports_patterns['raids']['wallet'] %}
								<tr>
									<td>{{pattern.report_name}}</td>
									<td class="w1 center">
										<i patternid="{{id}}" patternname="{{pattern.report_name}}" title="Показать отчет" class="fa fa-table"></i>
									</td>	
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
						
			</div>
			
			<div tabid="tabKeys">
				<div class="payments">
					<table class="popup__table popup__table_hover">
						<thead>
							<tr>
								<td>Название</td>
								<td>Отчет</td>
							</tr>
						</thead>
						<tbody>
							{% for id, pattern in reports_patterns['keys']['wallet'] %}
								<tr>
									<td>{{pattern.report_name}}</td>
									<td class="w1 center">
										<i patternkeyid="{{id}}"} patternname="{{pattern.report_name}}" title="Показать отчет" class="fa fa-table"></i>
									</td>	
								</tr>
							{% endfor %}
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		
		
		
		{# <div class="tabscontent">
			{% for type in ['raids', 'keys'] %}
				<div tabid="tab{{type}}"{% if type == 'raids' %} class="visible"{% endif %}>
					<div class="payments">
						<table class="popup__table popup__table_hover">
							<thead>
								<tr>
									<td>Название</td>
									<td>Отчет</td>
								</tr>
							</thead>
							<tbody>
								{% for id, pattern in reports_patterns[type] %}
									<tr>
										<td>{{pattern.report_name}}</td>
										<td class="w1 center">
											<i{% if type == 'raids' %} patternid="{{id}}"{% else %} patternkeyid="{{id}}"{% endif %} patternname="{{pattern.report_name}}" title="Показать отчет" class="fa fa-table"></i>
										</td>	
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
				</div>
			{% endfor %}
		</div>	 #}
	{% endif %}
</div>