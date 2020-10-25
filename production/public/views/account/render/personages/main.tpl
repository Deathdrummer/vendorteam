<ul class="tabstitles">
	<li id="tabpersonages" class="active"><p>Персонажи</p></li>
	<li id="tabresponses"><p>Запросы</p></li>
</ul>


<div class="tabscontent">
	<div tabid="tabpersonages" class="visible">
		{% if games_ids %}
			{% for item in games_ids %}
				<h4><small>ID аккаунта:</small> {{item.game_id}}</h4>
				<small>Действует до: <strong>{% if item.active %}{{item.date_end|d}}{% else %}Неактивен{% endif %}</strong></small>
				
				<table class="popup__table mb-3">
					<thead>
						<tr>
							<td>Никнейм</td>
							<td>Тип брони</td>
							<td>Сервер</td>
						</tr>
					</thead>
					<tbody>
						{% for personage in item.personages %}
							<tr>
								<td>{{personage.nick}}</td>
								<td>{{personage.armor}}</td>
								<td>{{personage.server}}</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			{% endfor %}
		{% endif %}
	</div>
	
	<div tabid="tabresponses">
		<table class="popup__table">
			<thead>
				<tr>
					<td>Ник</td>
					<td>Тип брони</td>
					<td>Сервер</td>
					<td>Опции</td>
				</tr>
			</thead>
			<tbody id="personesList"></tbody>
			<tfoot>
				<tr>
					<td colspan="4" class="right"><button id="addPersonage">Новая заявка</button></td>
				</tr>
			</tfoot>
		</table>
	</div>
</div>