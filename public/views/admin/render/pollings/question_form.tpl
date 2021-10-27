<div class="mb15px">
	<span class="fz14px">Вопрос:</span>
	<div class="textarea textarea_noresize">
		<textarea id="questionText" rows="3">{{title}}</textarea>
	</div>
</div>

<div class="mb15px">
	<span class="fz14px">Тип ответа:</span>
	<div class="select fz14px w200px">
		<select id="questionVariantsType" class="h24px">
			{% if answers_types %}
				<option disabled selected value="">Выбрать</option>
				{% for aTypeId, aType in answers_types %}
					<option value="{{aTypeId}}"{% if aTypeId == answers_type %} selected{% endif %}>{{aType}}</option>
				{% endfor %}
			{% else %}
				<option disabled>Нет данных</option>
			{% endif %}
		</select>
		<div class="select__caret"></div>
	</div>
</div>

<div class="mb15px" id="questionFormVariantsBlock"{% if answers_type == 3 %} hidden{% endif %}>
	<span class="fz14px">Варианты:</span>
	<table>
		<thead>
			<tr>
				<td class="w26px"></td>
				<td class="w30px"><strong class="fz12px">№</strong></td>
				<td><strong class="fz12px">Текст</strong></td>
				<td class="w62px"><strong class="fz12px">Баллы</strong></td>
				<td class="w50px"><strong class="fz12px">Опции</strong></td>
			</tr>
		</thead>
		<tbody id="pollingsQuestionsVariants">
			{% if variants %}
				{% for variant in variants %}
					{% include 'views/admin/render/pollings/question_variant.tpl' with variant %}
				{% endfor %}
			{% else %}
				<tr class="empty" pollingquestionvariantsnohandle>
					<td colspan="5"><p class="empty center fz12px">Нет вариантов</p></td>
				</tr>
			{% endif %}
		</tbody>
		<tfoot>
			<tr>
				<td colspan="5">
					<div class="buttons notop inline right">
						<button class="alt h20px fz10px pl8px pr8px" id="questionvariandAdd">Добавить</button>
					</div>
				</td>
			</tr>
		</tfoot>
	</table>
</div>