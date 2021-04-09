{% if not to_orders %}
	<table id="periodsList">
		<thead>
			<tr>
				<td>Название периода</td>
				{% if edit %}
					<td colspan="3" class="nowidth">Операции</td>
				{% else %}
					<td class="nowidth" title="Выбрать">Выбр.</td>
				{% endif %}
				{% if edit %}			
					<td class="nowrap" title="Активный (Универсальный)">Актив. У</td>
					<td class="nowrap" title="Активный (Европа)">Актив. Е</td>
					<td class="nowrap" title="Активный (Америка)">Актив. А</td>
					<td class="nowrap" title="Закрыт">Закр.</td>
					<td class="nowrap" title="Отобразить для 'Мои посещения'">Посещ.</td>
				{% endif %}
			</tr>
		</thead>
		<tbody>
			{% if periods %}	
				{% for period in periods %}
					<tr>
						<td>{{period.name}}</td>
						{% if edit %}
							<td class="nowidth">
								<div class="buttons">
									<button class="remove" title="В архив" periodtoarchive="{{period.id}}"><i class="fa fa-trash"></i></button>
								</div>
							</td>
						{% endif %}
						
						<td class="nowidth"><div class="buttons"><button title="Выбрать период" chooseperiod="{{period.id}}"><i class="fa fa-calculator"></i></button></div></td>
						
						{% if edit %}
							<td class="nowidth">
								<div class="buttons">
									<button setperiodstarttime="{{period.id}}" title="Задать время активации"><i class="fa fa-clock-o"></i></button>
								</div>
							</td>
						{% endif %}
						
						{% if edit %}
							<td class="nowidth center">
								<div class="checkblock">
									<input id="actualperiod{{period.id}}u" setactualperiod="{{period.id}}|u"{% if period.active_u %} checked{% endif %} name="setactiveperiodu" type="radio">
									<label for="actualperiod{{period.id}}u"></label>
								</div>
							</td>
							<td class="nowidth center">
								<div class="checkblock">
									<input id="actualperiod{{period.id}}e" setactualperiod="{{period.id}}|e"{% if period.active_e %} checked{% endif %} name="setactiveperiode" type="radio">
									<label for="actualperiod{{period.id}}e"></label>
								</div>
							</td>
							<td class="nowidth center">
								<div class="checkblock">
									<input id="actualperiod{{period.id}}a" setactualperiod="{{period.id}}|a"{% if period.active_a %} checked{% endif %} name="setactiveperioda" type="radio">
									<label for="actualperiod{{period.id}}a"></label>
								</div>
							</td>
							<td class="nowidth center">
								<div class="checkblock">
									<input id="closedperiod{{period.id}}" closeperiod="{{period.id}}"{% if period.closed %} checked{% endif %} type="checkbox">
									<label for="closedperiod{{period.id}}"></label>
								</div>
							</td>
							<td class="nowidth center">
								<div class="checkblock">
									<input id="toVisitsPeriod{{period.id}}" choosetovisits="{{period.id}}"{% if period.to_visits %} checked{% endif %} type="checkbox">
									<label for="toVisitsPeriod{{period.id}}"></label>
								</div>
							</td>	
						{% endif %}
					</tr>
				{% endfor %}
			{% endif %}
		</tbody>
	</table>
{% else %}
	<table id="periodsList">
		<thead>
			<tr>
				<td>Название периода</td>
				<td class="nowidth" title="Выбрать">Выбр.</td>
			</tr>
		</thead>
		<tbody>
			{% if periods %}	
				{% for period in periods %}
					<tr>
						<td>{{period.name}}</td>
						<td class="nowidth"><div class="buttons"><button title="Выбрать период" chooseorderperiod="{{period.id}}"><i class="fa fa-check"></i></button></div></td>
					</tr>
				{% endfor %}
			{% endif %}
		</tbody>
	</table>
{% endif %}