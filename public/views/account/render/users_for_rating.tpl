<form id="usersRatings">
	<table class="popup__table ratingusers">
		<thead>
			<tr>
				<td class="w200px">Участник</td>
				<td class="w250px"><small class="ratingusers__periodname">Персонажи и штрафы за последние 4 сохраненных периода</small></td>
				<td class="w72px" title="Активность (Развитие корпоративного аккаунта)">Активн.</td>
				<td class="w72px" title="Личный скилл">Личный скилл</td>
				<td class="w72px" title="Штрафы">Штрафы</td>
				<td class="w72px" title="Коэффициент посещений">Посещ.</td>
				<td></td>
			</tr>
		</thead>
		<tbody>
			<input type="hidden" name="period_id" value="{{ratings_period}}">
			<input type="hidden" name="static_id" value="{{static_id}}">
			{% for u in users|sortusers %}
				<tr>
					<td>
						<input type="hidden" name="data[{{u.id}}][period_id]" value="{{ratings_period}}">
						<input type="hidden" name="data[{{u.id}}][static_id]" value="{{static_id}}">
						<input type="hidden" name="data[{{u.id}}][user_id]" value="{{u.id}}">
						<div class="ratinguser" userid="{{u.id}}">
							<div class="ratinguser__image" style="background-image: url('{{base_url('public/images/users/'~u.avatar)|is_file('public/images/user_mini.jpg')}}')">
								<div class="ratinguser__stat {#online#}"></div>
							</div>
							<div class="ratinguser__name mr-auto">
								<strong>{{u.nickname}}</strong>
								<small>{{u.role}}</small>
								<small>{{u.rank}}</small>
							</div>
						</div>
					</td>
					<td>
					<div class="mb-1">
						<span class="ratingusers__periodlabel">Персонажи:</span>
						<ul class="ratingusers__periodlist">
							{% for periodId, periodTitle in periods_names %}
								<li title="{{periodTitle}}">{{data[u.id][periodId]['persones']|default('-')}}</li>
							{% endfor %}
						</ul>
					</div>
					<div>
						<span class="ratingusers__periodlabel">Ошибки:</span>
						<ul class="ratingusers__periodlist">
							{% for periodId, periodTitle in periods_names %}
								<li title="{{periodTitle}}">{{data[u.id][periodId]['fine']|default('-')}}</li>
							{% endfor %}
						</ul>
					</div>
					</td>
					<td class="text-center">
						<input type="number" name="data[{{u.id}}][activity]" step="0.1" min="1" max="5" showrows class="w50px" value="{{saved[u.id]['activity']|default(1)}}">
					</td>
					<td class="text-center">
						<input type="number" name="data[{{u.id}}][skill]" step="0.1" min="1" max="5" showrows class="w50px" value="{{saved[u.id]['skill']|default(0)}}">
					</td>
					<td class="text-center">
						<input type="number" name="data[{{u.id}}][fine]" step="0.1" showrows class="w50px" value="{{data[u.id]['fine_summ']}}">
					</td>
					<td class="text-center">
						<input type="number" name="data[{{u.id}}][visits]" step="0.1" showrows class="w56px" value="{{visits[u.id]}}">
					</td>
					<td></td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
</form>