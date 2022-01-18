{% if data %}
	<ul class="tabstitles sub">
		{% for static, rows in data %}
			<li id="kpiv2_data_static_list{{static}}" class="d-flex align-items-center">
				<img src="{{base_url('public/filemanager/thumbs/'~statics[static]['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="" class="avatar w20px h20px">
				<p class="fz11px ml3px">{{statics[static]['name']}}</p>
			</li>
		{% endfor %}
	</ul>
	
	
	<div class="tabscontent" id="kpiv2ReportData">
		{% for static, rows in data %}
			<div tabid="kpiv2_data_static_list{{static}}">
				<table>
					<thead>
						<tr>
							<td class="w250px"><strong>Бустер</strong></td>
							<td class="w500px"><strong>Посещаемость</strong></td>
							<td class="w500px"><strong>Прогресс выполнения плана</strong></td>
							<td class="w120px"><strong>Сумма</strong></td>
							<td class="p0"></td>
						</tr>
					</thead>
					<tbody>
						{% for row in rows %}
							<tr>
								<td>
									<div class="d-flex align-items-center">
										<img src="{{base_url('public/images/users/mini/'~row.avatar)|no_file('public/images/user_mini.jpg')}}" alt="" class="avatar w40px h40px mr4px">
										<div>
											<p>{{row['booster']|capitalize}}</p>
											<p class="fz10px grayblue mt4px">{{ranks[row.rank]['name']}}</p>
										</div>
									</div>
								</td>
								<td>
									<div class="progressbar progressbar_center">
										<progress class="progressbar__progress h30px" value="{{row.koeff_percent|round(1)|default(0)}}" max="100"></progress>
										<div class="progressbar__value">
											<strong>{{row.koeff_user|default(0)}} из {{row.koeff_static|default(0)}} ({{row.koeff_percent|round(1)|default(0)}} %)</strong>
										</div>
									</div>
									<input type="hidden" name="report[{{static}}][{{row.id}}][koeff_user]" value="{{row.koeff_user|default(0)}}">
									<input type="hidden" name="report[{{static}}][{{row.id}}][koeff_static]" value="{{row.koeff_static|default(0)}}">
									<input type="hidden" name="report[{{static}}][{{row.id}}][koeff_percent]" value="{{row.koeff_percent|round(1)|default(0)}}">
								</td>
								<td>
									<div class="row align-items-center gutters-10">
										<div class="col">
											<div class="progressbar progressbar_center">
												<progress class="progressbar__progress h30px" value="{{row['progress']|default(0)}}" max="100" kpiv2progressbar></progress>
												<div class="progressbar__value">
													<strong kpiv2progressbarnum>{{row['progress']|default(0)}} %</strong>
												</div>
											</div>
										</div>
										<div class="col-auto">
											<div class="d-flex align-items-center">
												<div class="field w52px">
													<input
														type="number"
														name="report[{{static}}][{{row.id}}][progress]"
														min="0"
														value="{{row['progress']|default(0)}}"
														kpiv2progressfield="{{static}}|{{row.rank}}|{{payout_type}}|{{row.factor}}"
														showrows>
												</div>
												<strong class="ml3px">%</strong>
											</div>
										</div>
									</div>
								</td>
								<td>
									<div class="d-flex align-items-center">
										<div class="field">
											<input
												type="text"
												name="report[{{static}}][{{row.id}}][summ]"
												value="{{row['summ']|default(0)}}"
												kpiv2amountfield="{{static}}|{{row.rank}}|{{payout_type}}|{{row.factor}}">
										</div>
										<small class="ml3px fz12px">₽</small>
									</div>
								</td>
								<td></td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		{% endfor %}
	</div>		
{% endif %}