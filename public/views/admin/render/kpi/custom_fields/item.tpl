<tr>
	<td>
		<div class="popup__select w100">
			<select newkpicustomfieldtask class="fz12px">
				{% if custom_tasks.total %}
					<option disabled selected value="">Выберите задачу</option>
					{% for task in custom_tasks.items %}
						<option value="{{task.id}}">{{task.task}}</option>
					{% endfor %}
				{% else %}
					<option value="">Нет задач</option>
				{% endif %}
			</select>
			<div class="select__caret"></div>
		</div>
	</td>
	<td class="center">
		<div class="buttons">
			<button class="remove small w30px" newkpiperiodremovefield><i class="fa fa-trash" title="Удалить поле"></i></button>
		</div>
	</td>
</tr>