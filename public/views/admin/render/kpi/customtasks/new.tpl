<tr>
	<td>
		<div class="popup__field">
			<input type="text" name="task" placeholder="Описание задачи..." rules="empty" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="popup__select w100">
			<select name="type" rules="empty">
				<option selected disabled value="">Выбрать</option>
				<option value="bool">Да/Нет</option>
				<option value="koeff">Коэфф.</option>
			</select>
			<div class="select__caret"></div>
		</div>
	</td>
	<td>
		<div class="popup__select w100">
			<select name="score" rules="empty">
				<option selected disabled value="">Выбрать</option>
				{% for scr in 1..10 %}
					<option value="{{scr}}">{{scr}}</option>
				{% endfor %}
			</select>
			<div class="select__caret"></div>
		</div>
	</td>
	<td class="center">
		<div class="buttons">
			<button class="small w30px" save><i class="fa fa-save"></i></button>
			<button class="small remove w30px" remove><i class="fa fa-ban"></i></button>
		</div>
	</td>
</tr>