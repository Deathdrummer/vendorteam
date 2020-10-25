<tr showgamepersonages="{{id}}">
	<td>
		<div class="text">
			<input type="text" name="game_id" value="{{game_id}}">
		</div>
	</td>
	<td>0</td>
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
			<span>Не привязан</span>
			<div class="buttons ml-auto" hidden>
				<button setgameiduser title="Привязать/Перепривязать владельца"><i class="fa fa-user"></i></button>
				<button removegameiduser{% if not item.user_id %} disabled{% endif %} class="remove removegiuser" title="Отвязать владельца"><i class="fa fa-user"></i></button>
			</div>
		</div>
	</td>
	<td>
		<div class="buttons nowrap">
			<button update="{{id}}"><i class="fa fa-save"></i></button>
			<button remove="{{id}}" class="remove"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>