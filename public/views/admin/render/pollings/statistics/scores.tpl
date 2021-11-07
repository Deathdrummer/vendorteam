{% if scoresdata %}
	<div class="questionsscores">
		<div class="questionsscores__table_left">
			<table class="popup__table">
				<thead class="h100px">
					<tr>
						<td class="bottom"><strong>Участник / Вопросы</strong></td>
					</tr>
				</thead>
				<tbody>
					{% for userId, userData in scoresdata %}
						<tr>
							<td>
								<div class="d-flex">
									<img src="{{base_url('public/images/users/mini/'~userData.user.avatar)|no_file('public/images/deleted_mini.jpg')}}" alt="{{userData.user.nickname}}" class="avatar w40px h40px">
									<div class="ml5px">
										<strong class="fz13px d-block mb3px">{{userData.user.nickname}}</strong>
										<p class="fz11px grayblue mb0px">{{statics[userData.user.static]}}</p>
									</div>
								</div>
							</td>
						</tr>	
					{% endfor %}
				</tbody>
			</table>
		</div>
			
			
		<div class="scroll">
			<table class="popup__table report__table_center" id="questionsscoresTable">
				<thead class="h100px">
					<tr>
						{% for qId, question in questions %}
							<td class="w150px bottom"><p class="w150px fz12px mb0px">{{question}}</p></td>
						{% endfor %}
						<td class="p-0"></td>
					</tr>
				</thead>
				<tbody>
					{% for userId, userData in scoresdata %}
						<tr>
							{% for qId, question in questions %}
								<td class="center">
									{% if userData['questions'][qId]['scores_parcent'] %}
										<div class="progressbar mb2px">
											<progress class="progressbar__progress h12px" value="{{userData['questions'][qId]['scores_parcent']}}" max="100"></progress>
										</div>
										<strong class="fz14px">{{userData['questions'][qId]['scores_parcent']}}%</strong>
										<small class="grayblue fz10px">({{userData['questions'][qId]['scores_user']}} из {{userData['questions'][qId]['scores_max']}})</small>
									{% else %}
										<p class="empty grayblue fz12px">Нет баллов</p>
									{% endif %}
								</td>
							{% endfor %}
							<td class="p-0"></td>
						</tr>	
					{% endfor %}
				</tbody>
			</table>
		</div>
		
		
		<div class="questionsscores__table_right">
			<table class="popup__table">
				<thead class="h100px">
					<tr>
						<td class="bottom"><strong>Итого</strong></td>
					</tr>
				</thead>
				<tbody>
					{% for userId, userData in scoresdata %}
						<tr>
							<td class="center">
								{% if userData.total_parcent %}
									<div class="progressbar mb2px">
										<progress class="progressbar__progress h12px" value="{{userData.total_parcent}}" max="100"></progress>
									</div>
									<strong class="fz14px">{{userData.total_parcent}}%</strong>
									<small class="grayblue fz10px">{{userData.total_scores}} {{userData.total_scores|padej(['балл', 'балла', 'баллов'])}}</small>
								{% else %}
									<p class="empty grayblue fz12px">Нет баллов</p>
								{% endif %}
							</td>
						</tr>	
					{% endfor %}
				</tbody>
			</table>
		</div>
	</div>
		
{% endif %}