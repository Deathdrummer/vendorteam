<table>
	<thead>
		<tr>
			<td>Ник</td>
			<td>Тип брони</td>
			<td>Сервер</td>
			<td class="w200px">Заявщик</td>
			<td class="w112px">Опции</td>
		</tr>
	</thead>
	<tbody id="userPersonagesList">
		{% if personages %}	
			{% for item in personages %}
				<tr>
					<td>
						<div class="field">
							<input type="text" p_nick value="{{item.nick}}">
						</div>
					</td>
					<td>
						<div class="select">
							<select p_armor>
								<option{% if item.armor == 'Латы' %} selected{% endif %} value="Латы">Латы</option>
								<option{% if item.armor == 'Кольчуга' %} selected{% endif %} value="Кольчуга">Кольчуга</option>
								<option{% if item.armor == 'Кожа' %} selected{% endif %} value="Кожа">Кожа</option>
								<option{% if item.armor == 'Ткань' %} selected{% endif %} value="Ткань">Ткань</option>
							</select>
							<div class="select__caret"></div>
						</div>
					</td>
					<td>
						<div class="field">
							<input type="text" p_server value="{{item.server}}">
						</div>
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
					<td class="center">
						<div class="buttons inline nowrap">
							<button class="small w30px" updategameidpersonage="{{item.id}}" title="Изменить данные персонажа" disabled><i class="fa fa-save"></i></button>
							<button class="small w30px remove" untiegameidpersonage="{{item.id}}" title="Отвязать персонажа"><i class="fa fa-user"></i></button>
							<button class="small w30px remove" removegameidpersonage="{{item.id}}" title="Удалить персонажа"><i class="fa fa-trash"></i></button>
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