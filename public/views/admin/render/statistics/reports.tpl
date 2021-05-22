{% if reports.total %}
	<div class="d-flex align-items-end justify-content-between mb10px">
		<h4>Выберите отчеты ({{reports.total}})</h4>
		{% if type == 1 %}
			<div class="popup__select">
				<select id="reportsAmountType">
					<option value="0">Все</option>
					<option value="1">Обычные расчеты</option>
					<option value="2">Ключи</option>
					<option value="3">Премии</option>
				</select>
				<div class="popup__select__caret"></div>
			</div>
		{% endif %}
	</div>
	
	<div id="reportsAmountList">
		<table>
			<thead>
				<tr>
					<td>Отчет</td>
					<td class="center"><i class="fa fa-check-square fa-2x" id="reportsAmountSetAll"></i></td>
				</tr>
			</thead>
			<tbody>
				{% for id, data in reports.items %}
					<tr type="{{data.type}}">
						<td>
							<div class="d-flex align-items-center">
								<p>{{data.title}}</p>
							</div>
						</td>
						<td class="nowidth center">
							<div class="checkblock">
								<input id="reportsAmount{{id}}" type="checkbox" value="{{id}}">
								<label for="reportsAmount{{id}}"></label>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
{% endif %}