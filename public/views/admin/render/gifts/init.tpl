<table>
	<thead>
		<tr>
			{% if not fields or 'title' in fields %}<td>Название</td>{% endif %}
			{% if not fields or 'chance' in fields %}<td class="w100px">Вероятность выпадения</td>{% endif %}
			{% if not fields or 'percents' in fields %}<td class="w100px">Ценность</td>{% endif %}
			{% if not fields or 'diapason' in fields %}<td class="w220px">Диапазон единиц награды</td>{% endif %}
			<td class="w250px">Действие</td>
			<td class="w80px">Опции</td>
		</tr>
	</thead>
	<tbody id="giftsList"></tbody>
</table>