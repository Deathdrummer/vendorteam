<tr class="new">
	{# <td>-</td> #}
	<td>
		<div class="text">
			<input type="text" name="game_id">
		</div>
	</td>
	<td>-</td>
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
					{% if item.avatar %}
						<div class="avatar w40px h40px mr-1" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}')" title="{{item.nickname}}"></div>
					{% endif %}
					<span>{{item.nickname|default('Не привязан')}}</span>
					<input type="hidden" name="user_id" value="{{item.user_id}}">
				</div>
					
				<div class="buttons ml-auto">
					<button setgameiduser title="Привязать/Перепривязать владельца"><i class="fa fa-user"></i></button>
					<button removegameiduser{% if not item.user_id %} disabled{% endif %} class="remove removegiuser" title="Отвязать владельца"><i class="fa fa-user"></i></button>
				</div>
			</div>
		</td>
	<td>
		<div class="buttons">
			<button save><i class="fa fa-save"></i></button>
		</div>
	</td>
</tr>