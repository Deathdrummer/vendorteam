{% if pollings %}
	<table class="popup__table">
		<thead>
			<tr>
				<td class="w280x">Название</td>
				<td>Описание</td>
				<td class="w80px">Отв/Вопр</td>
				<td class="w80px"></td>
			</tr>
		</thead>
		<tbody id="accountPollingsList">
			{% for polling in pollings %}
				<tr class="h50px">
					<td><strong class="fz12px" questiontitle>{{polling.title}}</strong></td>
					<td><p class="fz12px">{{polling.description}}</p></td>
					<td class="center"><strong>{{polling.count_answers}}/{{polling.count_questions}}</strong></td>
					<td class="center">
						
						<div class="buttons notop inline">
						{% if polling.count_answers > 0 and polling.count_answers < polling.count_questions %}
							<button class="verysmall fz10px h22px w86px pl5px pr5px justify-content-center" pollingopen="{{polling.id}}">Продолжить</button>
						{% elseif polling.count_answers == polling.count_questions %}
							<p class="green text-center fz12px">Пройден</p>
						{% else %}
							<button class="verysmall fz10px h22px pay w86px pl5px pr5px justify-content-center" pollingopen="{{polling.id}}">Пройти</button>
						{% endif %}
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>	
{% else %}
	<p class="empty center">Нет опросов</p>
{% endif %}