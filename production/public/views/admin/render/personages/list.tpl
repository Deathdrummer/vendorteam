<table>
	<thead>
		<tr>
			<td>Ник</td>
			<td>Тип брони</td>
			<td>Сервер</td>
			<td class="w200px">Заявщик</td>
			<td class="nowidth">Опции</td>
		</tr>
	</thead>
	<tbody id="userPersonagesList">
		{% if personages %}	
			{% for item in personages %}
				<tr>
					<td>
						<p>{{item.nick}}</p>
					</td>
					<td>
						<p>{{item.armor}}</p>
					</td>
					<td>
						<p>{{item.server}}</p>
					</td>
					<td>
						{% if item.user_nickname %}
							<div class="d-flex align-items-center">
								<div class="usercard d-flex align-items-center">
									{% if item.user_avatar %}
									<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/users/mini/'~item.user_avatar)}}')" title="{{item.user_nickname}}"></div>
									{% else %}
										<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/user_mini.jpg')}}')" title="{{item.user_nickname}}"></div>
									{% endif %}
									<span>{{item.user_nickname}}</span>
								</div>
							</div>
						{% else %}
							<span>Администратор</span>
						{% endif %}
					</td>
					<td>
						<div class="buttons nowrap">
							<button class="remove" untiegameidpersonage="{{item.id}}" title="Отвязать персонажа"><i class="fa fa-user"></i></button>
							<button class="remove" removegameidpersonage="{{item.id}}" title="Удалить персонажа"><i class="fa fa-trash"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		{% endif %}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="6">
				<div class="buttons">
					<button class="small" gameidaddpersonagefromusers>Добавить персонажа из заявок</button>
					<button class="small" gameidaddpersonage>Создать персонажа</button>
				</div>
			</td>
		</tr>
	</tfoot>
</table>