{% if report %}
	<ul class="tabstitles mt-2">
		{% for staticId in report|keys %}
			<li id="tabKpiStat{{staticId}}">{{statics[staticId]}}</li>
		{% endfor %}
	</ul>
	
	
	<div class="tabscontent" id="kpiReport">
		<input type="hidden" name="periods" value="{{kpi_periods_ids|json_encode()}}">
		{% for staticId, users in report %}
		<div tabid="tabKpiStat{{staticId}}">
			<div class="kpireport noselect">
				<table>
					<thead>
						<tr>
							<td class="w200px">Участник</td>
							<td class="w40px">NDA</td>
							<td class="w200px">Платежные реквизиты</td>
							<td class="w200px">Посещаемость</td>
							<td class="w200px">Дополнительные задачи</td>
							<td class="w200px">Задачи для персонажей</td>
							<td></td>
							<td class="w120px">Итого</td>
						</tr>
					</thead>
					<tbody>
						{% for uId, user in users %}
							<tr kpibonusstatuser="{{uId}}">
								<td class="h72px">
									<div class="d-flex align-items-center mt4px mb4px">
										<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}')"></div>
										<div class="ml4px">
											<strong>{{user.nickname}}</strong>
											<p class="fz11px mt3px">{{user.rank}}</p>
										</div>	
									</div>
								</td>
								<td class="center">{% if user.nda %}<i class="fa fa-check"></i> {% else %}<i class="fa fa-ban"></i>{% endif %}</td>
								<td><p class="fz12px">{{user.payment}}</p></td>
								
								<td class="center">
									<input type="hidden" kpibonusvisits value="{{user.percents.visits|round(1)}}">	
									{{user.percents.visits|round(1)|default('-')}} %
								</td>
								<td class="center">
									<input type="hidden" kpibonuscustom value="{{user.percents.custom|round(1)}}">	
									{{user.percents.custom|round(1)|default('-')}} %
								</td>
								<td class="center">
									<input type="hidden" kpibonuspersonages value="{{user.percents.personages|round(1)}}">	
									{{user.percents.personages|round(1)|default('-')}} %
								</td>
								<td></td>
								<td class="center">
									<div class="d-inline-flex align-items-center">
										{% if is_saved %}
											{{user.percents.total|round(1)|default('-')}}
										{% else %}
											<div class="field w80px">
												<input type="number" step="0.1" showrows kpibonustotal value="{{user.percents.total|round(1)|default(0)}}">
											</div>
										{% endif %}
										<span class="ml3px">%</span>
									</div>
								</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		</div>
		{% endfor %}
	</div>
{% endif %}