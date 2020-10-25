{% if users %}
	{% set ul = users|length / 2 %}
	<div class="row">
		{% for usersPart in users|batch(ul|round(1, 'ceil')) %}
			<div class="col-12 col-md-6">
				<table>
					<thead>
						<tr>
							<td colspan="3">Список участников</td>
						</tr>
					</thead>
					<tbody>
						{% for user in usersPart %}
							<tr>
								<td class="nowidth nopadding">
									{% if user.avatar %}
										<div class="avatar" style="background-image: url('public/images/users/mini/{{user.avatar}}')"></div>
									{% else %}
										<div class="avatar" style="background-image: url('public/images/user_mini.jpg')"></div>
									{% endif %}
								</td>
								<td>{{user.nickname}}</td>
								<td class="nowidth">
									<div class="buttons">
										<button choosepopupcustomer="{{user.id}}|{{user.nickname}}|{{user.avatar}}"><i class="fa fa-check"></i></button>
									</div>
								</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		{% endfor %}
	</div>	
{% endif %}