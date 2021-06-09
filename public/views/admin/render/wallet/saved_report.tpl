{% if report %}
	<ul class="tabstitles sub mt-2">
		{% for stId, stName in statics %}
			<li id="tabWalletReportStatic{{stId}}">{{stName}}</li>
		{% endfor %}
	</ul>
	
	<div class="tabscontent">
		{% for stId in statics|keys %}
			<div tabid="tabWalletReportStatic{{stId}}">
				<table>
					<thead>
						<tr>
							<td class="w250px">Участник</td>
							<td class="w150px">Выплачено</td>
							<td class="w150px">Отправлено в резерв</td>
							<td class="p0"></td>
						</tr>
					</thead>
					<tbody>
						{% for userId, user in report[stId] %}
							<tr walletuserrow="{{stId}}|{{userId}}">
								<td>
									<div class="d-flex align-items-center">
										<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}')"></div>
										<p>{{user.nickname}}</p>
									</div>
								</td>
								<td>{% if user.summ %}{{user.summ|number_format(1, '.', ' ')}} <small>₽</small>{% else %}0 <small>₽</small>{% endif %}</td>
								<td>{% if user.to_deposit %}{{user.to_deposit|number_format(1, '.', ' ')}} <small>₽</small>{% else %}0 <small>₽</small>{% endif %}</td>
								<td class="p0"></td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		{% endfor %}
	</div>
{% endif %}