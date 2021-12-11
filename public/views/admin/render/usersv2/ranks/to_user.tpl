{% if ranks %}
	<ul class="usersv2staticslist noselect" id="usersv2RanksToUserList">
		{% for rId, rank in ranks %}
			<li>
				<input type="radio" name="usersv2RanksSetRank" id="userSetRank{{rId}}" usersv2rankssetrank="{{rId}}"{# {% if rId == current %} checked{% endif %} #}>
				<label for="userSetRank{{rId}}" class="usersv2staticsitem{% if rId == current %} usersv2staticsitem_active{% endif %}">
					<div class="usersv2staticsitem__static pt4px pb4px">
						<span class="fz14px">{{rank.name}}</span>
					</div>
				</label>
			</li>
		{% endfor %}
	</ul>
	
	<div class="buttons text-right notop mt5px">
		<button class="button h20px pl10px pr10px fz10px" id="usersv2RanksToUserSetBtn" disabled>Подтвердить</button>
	</div>
{% else %}
	<p class="empty center fz12px">Нет данных</p>
{% endif %}