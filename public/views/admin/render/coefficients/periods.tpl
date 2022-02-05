{% if periods %}
	{% if multiple %}
		<div class="popup__buttons mb10px">
			<button class="popup__buttons_main fz10px h18px pt5px pb5px" id="coeffsPeriodsCheckallBtn">Выбрать все</button>
			<button class="popup__buttons_main fz10px h18px pt5px pb5px" id="coeffsPeriodsUncheckallBtn">Снять выделение</button>
		</div>
	{% endif %}
	<table id="coefficientsPeriods">
		<thead>
			<tr>
				<td>Период</td>
				<td class="center{% if multiple %} w60px{% else %} w50px{% endif %}">
					{% if multiple %}
						<i class="fa fa-check" coeffsperiodscheckallbtn></i>
					{% else %}
						<i class="fa fa-check"></i>
					{% endif %}
				</td>
			</tr>
		</thead>
		<tbody>
			{% for period in periods %}
				<tr>
					<td>{{period.name}}</td>
					{% if multiple %}
						<td class="center">
						
							<div class="checkblock">
								<input type="checkbox" id="coeffsChoosePeriod{{period.id}}" coefficientschooseperiod value="{{period.id}}">
								<label for="coeffsChoosePeriod{{period.id}}"></label>
							</div>
						</td>
					{% else %}
						<td>
							<div class="buttons">
								<button class="small w30px" coefficientschooseperiod="{{period.id}}"><i class="fa fa-check"></i></button>
							</div>
						</td>
						{% endif %}
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% else %}
	<p class="empty">Нет периодов</p>
{% endif %}