{% if ranks %}
	<div class="buttons inline notop mb5px">
		<button class="button alt2 h20px pl10px pr10px fz10px" usersv2rankslistcheck="1"{% if all_disabled %} disabled{% endif %}>Выделить все</button>
		<button class="button alt2 h20px pl10px pr10px fz10px" usersv2rankslistcheck="0"{% if none_disabled %} disabled{% endif %}>Снять выделение</button>
	</div>
	
	<ul class="usersv2staticslist" id="usersv2RanksList">
		{% for rId, rank in ranks %}
			<li>
				<input type="checkbox" id="usersRanksList{{rId}}" usersv2rankslistitem="{{rId}}"{% if rank.checked %} checked{% endif %}>
				<label for="usersRanksList{{rId}}" class="usersv2staticsitem">
					<div class="usersv2staticsitem__static pt4px pb4px">
						<span class="fz16px">{{rank.name}}</span>
					</div>
				</label>
			</li>
		{% endfor %}
	</ul>
{% else %}
	<p class="empty center fz12px">Нет данных</p>
{% endif %}