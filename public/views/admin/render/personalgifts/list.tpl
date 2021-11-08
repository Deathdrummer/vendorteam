{% if gifts %}
	<table id="personalGiftsList">
		<thead>
			<tr>
				<td>Название</td>
				<td>Действие</td>
				<td class="w61px">Кол-во</td>
				<td class="w20px"></td>
			</tr>
		</thead>
		<tbody>
			{% for gift in gifts %}
				<tr>
					<td>{{gift.title}}</td>
					<td>
						{{actions[gift.action]}} от <strong>{{gift.items_from}}</strong> до <strong>{{gift.items_to}}</strong>
						{% if gift.action == 'balance' %}руб.{% elseif gift.action == 'stage' %}дн.{% endif %}
					</td>
					<td>
						<div class="field w50px">
							<input type="number" showrows min="1" personalgifttoaddcount value="1">
						</div>
					</td>
					<td class="center">
						<div class="checkblock right">
							<input id="personalgiftschoose{{gift.id}}" type="checkbox" personalgifttoadd value="{{gift.id}}">
							<label for="personalgiftschoose{{gift.id}}"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% else %}
	<p class="empty center">Нет подарков</p>
{% endif %}