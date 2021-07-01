<tr>
	<td>
		<div class="popup__field">
			<input type="text" name="task" value="{{task}}" placeholder="Описание задачи..." rules="empty" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="popup__select w100">
			<select name="type" rules="empty">
				<option selected disabled value="">Выбрать</option>
				<option value="bool"{% if type == 'bool' %} selected{% endif %}>Да/Нет</option>
				<option value="koeff"{% if type == 'koeff' %} selected{% endif %}>Коэфф.</option>
			</select>
			<div class="select__caret"></div>
		</div>
	</td>
	<td>
		<div class="popup__select w100">
			<select name="score" rules="empty">
				<option selected disabled value="">Выбрать</option>
				{% for scr in 1..10 %}
					<option value="{{scr}}"{% if scr == score %} selected{% endif %}>{{scr}}</option>
				{% endfor %}
			</select>
			<div class="select__caret"></div>
		</div>
	</td>
	<td class="center">
		<div class="buttons">
			<button class="small w30px" update="{{id}}"><i class="fa fa-save"></i></button>
			<button class="small remove w30px" remove="{{id}}"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>