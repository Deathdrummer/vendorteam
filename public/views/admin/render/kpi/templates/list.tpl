{% if templates %}
	<table>
		<thead>
			<tr>
				<td>Шаблон</td>
				<td class="w60px" title="Активировать">Активн.</td>
				<td class="w80px">Опции</td>
			</tr>
		</thead>
		<tbody>
			{% for template in templates %}
				<tr>
					<td>{{template.title}}</td>
					<td class="center">
						<div class="popup__checkbox">
							<input type="radio" name="kpitemplatestctivate" id="kpiTemplatesActivate{{template.id}}" kpitemplatesactivate="{{template.id}}"{% if template.active %} checked{% endif %}>
							<label for="kpiTemplatesActivate{{template.id}}"></label>
						</div>
					</td>
					<td class="center">
						<div class="buttons notop inline">
							<button class="small w30px" kpiedittemplate="{{template.id}}" title="Изменить шаблон"><i class="fa fa-edit"></i></button>
							<button class="small w30px remove" kpiremovetemplate="{{template.id}}"><i class="fa fa-trash"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% else %}
	<p class="empty center">Нет шаблонов</p>
{% endif %}