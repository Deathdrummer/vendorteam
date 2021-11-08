<table class="popup__table">
	<thead>
		<tr>
			{% if type == 2 %}
				<td class="w180px">Звание</td>
			{% endif %}
			<td>Текст</td>
			<td class="w115px">Опции</td>
		</tr>
	</thead>
	<tbody id="{{list_id}}"></tbody>
	<tfoot>
		<tr>
			<td colspan="{% if type == 2 %}3{% else %}2{% endif %}">
				<div class="buttons notop right">
					<button id="{{btn_id}}" class="small">Добавить</button>
				</div>
			</td>
		</tr>
	</tfoot>
</table>