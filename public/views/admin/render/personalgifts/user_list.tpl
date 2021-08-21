<table class="clear">
	<thead>
		<tr>
			<td>Название</td>
			<td class="w100px">Источник</td>
			<td class="w200px">Награда</td>
			<td class="w110px">Статус</td>
			<td class="w26px"></td>
		</tr>
	</thead>
	<tbody>
		{% if gifts %}
			{% for gift in gifts %}
				<tr>
					<td><p class="fz12px">{{gift.title}}</p></td>
					<td><small class="fz12px">{{sections[gift.section]}}</small></td>
					<td>
						<div class="d-flex align-items-center">
							<small class="fz12px">{{actions[gift.action]}}</small>
							{% if gift.date_taking %}
								<strong class="fz12px ml-auto">{{gift.value}}</strong>
							{% else %}
								<input class="fz11px w46px h24px ml-auto" type="number" showrows personalusersgifts="{{gift.id}}" value="{{gift.value}}">
							{% endif %}
							<small class="ml3px w16px">{% if gift.action == 'balance' %}₽{% elseif gift.action == 'stage' %}дн.{% endif %}</small>
						</div>
						</p>
					</td>
					<td>
						{% if gift.date_taking %}
							<strong class="fz11px d-block mb3px">Принят:</strong>
							<small class="fz10px d-block">{{gift.date_taking|d(true)}} в {{gift.date_taking|t}}</small>
						{% else %}
							<strong class="fz11px">Ожидает</strong>
						{% endif %}
					</td>
					<td class="text-center">
						{% if gift.date_taking is null %}
							<i class="fa fa-trash pointer red" personalusersgiftsremove="{{gift.id}}" title="Удалить подарок"></i>
						{% endif %}
					</td>
				</tr>
			{% endfor %}
		{% else %}
			<tr><td colspan="5"><p class="empty center fz11px">Нет подарков</p></td></tr>
		{% endif %}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="5" class="text-right">
				<button class="small h20px" personalgiftsadd="{{user_id}}">Добавить подарки</button>
			</td>
		</tr>
	</tfoot>
</table>                              