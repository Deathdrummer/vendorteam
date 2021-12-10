{% if ranks %}
	<ul class="usersv2staticslist noselect" id="usersv2RanksToUserList">
		{% for rId, rank in ranks %}
			<li>
				<input type="radio" name="usersv2RanksSetRank" id="userSetRank{{rId}}" usersv2rankssetrank="{{rId}}"{% if rId == current %} checked{% endif %}>
				<label for="userSetRank{{rId}}" class="usersv2staticsitem">
					<div class="usersv2staticsitem__static pt4px pb4px">
						<span class="fz14px">{{rank.name}}</span>
					</div>
				</label>
			</li>
		{% endfor %}
	</ul>
{% else %}
	<p class="empty center fz12px">Нет данных</p>
{% endif %}