{% for item in game_ids %}
	<tr showgamepersonages="{{item.id}}">
		<td>
			<div class="text">
				<input type="text" name="game_id" value="{{item.game_id}}">
			</div>
		</td>
		<td>{{item.personages_count}}</td>
		<td></td>
		<td class="date_end">
			<div class="d-flex align-items-center">
				{% if item.date_end is null %}
					<p extenddate="{{item.date_end}}">-</p>
				{% else %}
					<p extenddate="{{item.date_end}}">{{item.date_end|d}}</p>
				{% endif %}
				
				<div class="d-flex align-items-center ml-auto">
					<small>Продлить на:</small>
					<div class="number short mx-1">
						<input name="extend" showrows type="number">
					</div>
					<small>дн.</small>
				</div>
			</div>
		</td>
		<td class="w350px">
			<div class="d-flex align-items-center">
				<div class="usercard d-flex align-items-center">
					{% if item.avatar and item.nickname %}
						<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}')" title="{{item.nickname}}"></div>
					{% elseif not item.avatar and item.nickname %}
						<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/user_mini.jpg')}}')" title="{{item.nickname}}"></div>
					{% endif %}
					<span>{{item.nickname|default('Не привязан')}}</span>
					<input type="hidden" name="user_id" value="{{item.user_id}}">
				</div>
					
				<div class="buttons ml-auto">
					<button setgameiduser="{{item.id}}" title="Привязать/Перепривязать владельца"><i class="fa fa-user"></i></button>
					<button{% if item.user_id %} removegameiduser="{{item.id}}"{% else %} removegameiduser disabled{% endif %} class="remove removegiuser" title="Отвязать владельца"><i class="fa fa-user"></i></button>
				</div>
			</div>
		</td>
		<td>
			<div class="buttons nowrap">
				<button update="{{item.id}}"><i class="fa fa-save"></i></button>
				<button remove="{{item.id}}" class="remove"><i class="fa fa-trash"></i></button>
			</div>
		</td>
	</tr>
{% endfor %}