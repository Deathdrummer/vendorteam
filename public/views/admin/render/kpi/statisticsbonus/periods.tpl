{% if periods %}
	<table>
		<thead>
			<tr>
				<td>Название</td>
				<td class="w80px">Опции</td>
			</tr>
		</thead>
		<tbody>
			{% for period in periods %}
				<tr>
					<td><strong kpireporttitle>Отчет по периоду: {{period.title}}</strong></td>
					<td>
						<div class="buttons">
							<button class="small w30px" kpistatbonusreport="{{period.id}}" title="Сформировать отчет"><i class="fa fa-check"></i></button>
							<button class="small w30px pay"{% if period.done %} disabled{% endif %} kpistatbonussendpercents="{{period.id}}" title="Отправить бонусные проценты"><i class="fa fa-percent"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}