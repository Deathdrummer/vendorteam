{% if personages %}	
	<div slass="popupscroll">
		<table class="mb-2">
			<thead>
				<tr>
					<td>Ник</td>
					<td>Тип брони</td>
					<td>Сервер</td>
					<td class="w200px">Заявщик</td>
					<td class="nowidth">Выб.</td>
				</tr>
			</thead>
			<tbody id="userPersonagesListPopup">
				{% if personages %}	
					{% for item in personages %}
						<tr>
							<td>
								<p class="popuppersonagenick">{{item.nick}}</p>
							</td>
							<td>
								<p class="popuppersonagearmor">{{item.armor}}</p>
							</td>
							<td>
								<p class="popuppersonageserver">{{item.server}}</p>
							</td>
							<td>
								{% if item.user_nickname %}
									<input type="hidden" class="popuppersonageusernickname" value="{{item.user_nickname}}">
									<div class="d-flex align-items-center">
										<div class="usercard d-flex align-items-center">
											{% if item.user_avatar %}
												<input type="hidden" class="popuppersonageuseravatar" value="{{base_url('public/images/users/mini/'~item.user_avatar)}}">
												<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/users/mini/'~item.user_avatar)}}')" title="{{item.user_nickname}}"></div>
											{% else %}
												<input type="hidden" class="popuppersonageuseravatar" value="{{base_url('public/images/user_mini.jpg')}}">
												<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/user_mini.jpg')}}')" title="{{item.user_nickname}}"></div>
											{% endif %}
											<span>{{item.user_nickname}}</span>
										</div>
									</div>
								{% else %}
									<input type="hidden" class="popuppersonageusernickname" value="">
									<input type="hidden" class="popuppersonageuseravatar" value="{{base_url('public/images/user_mini.jpg')}}">
									<span>Админиcтратор</span>
								{% endif %}
							</td>
							<td class="center">
								<div class="checkblock">
									<input type="checkbox" personagefromuser id="choosePersonageFromUsers{{item.id}}" value="{{item.id}}">
									<label for="choosePersonageFromUsers{{item.id}}"></label>
								</div>
							</td>
						</tr>
					{% endfor %}
				{% endif %}
			</tbody>
		</table>
	</div>
{% endif %}