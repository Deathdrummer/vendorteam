<div id="userMessages">
	{% if messages %}
		<ul class="tabstitles">
			<li id="userMessage0" class="h30px"><p>Новые</p></li>
			<li id="userMessage1" class="h30px"><p>Прочитанные</p></li>
		</ul>
		
		<div class="tabscontent">
			{% for stat in [0, 1] %}
				<div tabid="userMessage{{stat}}">
					{% if messages[stat] %}
						<table class="popup__table">
							<thead>
								<td class="h20px">Сообщение</td>
								<td class="w40px h20px"></td>
							</thead>
							<tbody>
								{% for message in messages[stat] %}
									<tr>
										<td class="h54px">{{message.title}}</td>
										<td class="h54px">
											<button class="h24px w30px" title="Посмотреть сообщение" usersmessagesshow="{{message.id}}|{{stat}}"><i class="fa fa-eye"></i></button>
										</td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					{% else %}
						<p class="empty center">Нет сообщений</p>
					{% endif %}		
				</div>
			{% endfor %}
		</div>
	{% endif %}
</div>