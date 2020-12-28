{% if statics %}
	<form id="ratingsReportForm">
		<ul class="tabstitles sub mt-2">
			{% for staticId, staticName in statics %}
				<li id="tabStatic{{staticId}}">{{staticName}}</li>
			{% endfor %}
		</ul>
		
		<div class="tabscontent" subcontent>
			{% for staticId, staticName in statics %}
				<div tabid="tabStatic{{staticId}}">
					{% if report[staticId] %}
						<table class="ratingusers">
							<thead>
								<tr>
									<td class="w300px">Участник</td>
									<td class="w240px"><small class="ratingusers__periodname">Персонажи и штрафы за последние 4 сохраненных периода</small></td>
									<td class="w120px" title="Активность (Развитие корпоративного аккаунта)">Активность</td>
									<td class="w120px" title="Личный скилл">Личный скилл</td>
									<td class="w120px" title="Штрафы">Штрафы</td>
									<td class="w120px" title="Коэффициент посещений">Коэффициент посещений</td>
									<td class="w120px" >Выговоры</td>
									<td class="w120px" >Форс мажорные выходные</td>
									<td class="w120px" >Стимулирование</td>
									<td class="w120px" >Наставничество</td>
									<td></td>
								</tr>
							</thead>
							<tbody>
								{% for item in report[staticId]|sortusers %}
									<tr userid="{{item.user_id}}">
										<td>
											<input type="hidden" name="data[{{item.id}}][id]" value="{{item.id}}">
											<div class="row gutters-5 align-items-center">
												<div class="col-auto">
													<div class="avatar" style="background-image: url('{{base_url('public/images/users/'~item.avatar)|is_file('public/images/user_mini.jpg')}}')"></div>
												</div>
												<div class="col">
													<p><strong>{{item.nickname}}</strong></p>
													<p><small>{{item.role}}</small></p>
													<small>{{item.rank}}</small>
												</div>
											</div>
										</td>
										<td>
											<div class="mb-1">
												<span class="ratingusers__periodlabel">Персонажи:</span>
												<ul class="ratingusers__periodlist">
													{% for periodId, periodTitle in info.periods_names %}
														<li title="{{periodTitle}}">{{info['data'][staticId][item.id][periodId]['persones']|default('-')}}</li>
													{% endfor %}
												</ul>
											</div>
											<div>
												<span class="ratingusers__periodlabel">Ошибки:</span>
												<ul class="ratingusers__periodlist">
													{% for periodId, periodTitle in info.periods_names %}
														<li title="{{periodTitle}}">{{info['data'][staticId][item.id][periodId]['fine']|default('-')}}</li>
													{% endfor %}
												</ul>
											</div>
										</td>
										<td class="text-center">
											<div class="field w100px">	
												<input type="number" name="data[{{item.id}}][activity]" htype="1" step="0.1" min="1" max="5" showrows value="{{item.activity|default(1)}}">
											</div>
										</td>
										<td class="text-center">
											<div class="field w100px">
												<input type="number" name="data[{{item.id}}][skill]" htype="2" step="0.1" min="1" max="5" showrows value="{{item.skill|default(0)}}">
											</div>
										</td>
										<td class="text-center">
											<div class="field w100px">
												<input type="number" name="data[{{item.id}}][fine]" htype="3" step="0.1" showrows value="{{item.fine}}">
											</div>
										</td>
										<td class="text-center">
											<div class="field w100px">
												<input type="number" name="data[{{item.id}}][visits]" htype="4" step="0.1" showrows value="{{item.visits}}">
											</div>
										</td>
										<td class="text-center">
											<strong>{{item.reprimands|default('-')}}</strong>
										</td>
										<td class="text-center">
											<strong>{{item.forcemajeure|default('-')}}</strong>
										</td>
										<td class="text-center">
											<strong>{{item.stimulation|default('-')}}</strong>
										</td>
										<td class="text-center">
											<strong>{{item.mentor|default('-')}}</strong>
										</td>
										<td></td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					{% else %}
						<p class="empty center">Нет данных</p>
					{% endif %}
				</div>
			</form>
		{% endfor %}
	</div>
{% else %}
	<p class="empty center">Нет данных</p>
{% endif %}