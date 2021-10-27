<table id="pollingQuestionsTable">
	<thead>
		<tr>
			<td class="w40px"></td>
			<td class="w30px">№</td>
			<td><strong class="fz12px">Вопрос</strong></td>
			<td class="w80px"><strong class="fz12px">Вариантов ответа</strong></td>
			<td class="w100px"><strong class="fz12px">Тип ответа</strong></td>
			<td class="w90px"><strong class="fz12px">Операции</strong></td>
		</tr>
	</thead>
	<tbody id="pollingQuestions">
		{% if questions %}
			{% for k, question in questions %}
				<tr pollingquestion="{{question.id}}">
					<td class="graggable center">
						<i class="fa fa-ellipsis-v grayblue fz18px"></i>
					</td>
					<td class="center"><strong pollingquestionorder>{{k+1}}</strong></td>
					<td class="graggable top pt5px pb5px">
						<p class="fz12px">{{question.title}}</p>
					</td>
					<td class="center">
						{% if question.answers_type == 3 %}
							<strong title="Кастомный">К</strong>
						{% else %}
							<strong>{{question.variants_count}}</strong>
						{% endif %}
					</td>
					<td class="graggable">
						<small>{{answerstypes[question.answers_type]}}</small>
					</td>
					<td class="center" pollingquestionnohandle>
						<div class="buttons notop inline">
							<button class="h22px w28px pl0px pr0px" pollingquestionedit="{{question.id}}" title="Редактировать вопрос"><i class="fa fa-edit fz12px"></i></button>
							<button class="h22px w28px pl0px pr0px remove" pollingquestionremove="{{question.id}}" title="Удалить вопрос"><i class="fa fa-remove fz12px"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		{% else %}
			<tr class="empty">
				<td colspan="6">
					<p class="empty center">Нет вопросов</p>
				</td>
			</tr>
		{% endif %}
	</tbody>
</table>