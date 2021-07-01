<div class="row gutters-5 mb20px">
	<div class="col-6">
		<label class="d-block w100">Название периода:</label>
		<div class="popup__field">
			<input type="text" id="newKpiPeriodTitle" placeholder="Введите название" autocomplete="off">
		</div>
	</div>
	<div class="col-3">
		<label>Дата с:</label>
		<div class="popup__field popup__field_date">
			<input type="text" id="newKpiPeriodDateStart" placeholder="Выбрать" autocomplete="off">
		</div>
	</div>
	<div class="col-3">
		<label>Дата по:</label>
		<div class="popup__field popup__field_date">
			<input type="text" id="newKpiPeriodDateEnd" placeholder="Выбрать" autocomplete="off">
		</div>
	</div>
</div>

<div class="row gutters-5">
	<div class="col-3">
		<label>Выбрать период:</label>
		<table class="popup__table" id="kpiPeriodsList">
			<thead>
				<tr class="h32px">
					<td>Период</td>
					<td class="w40px"></td>
				</tr>
			</thead>
				
			<tbody>
				{% if periods %}
					{% for pId, period in periods %}
						<tr>
							<td>{{period.name}}</td>
							<td class="center">
								<div class="checkblock">
									<input type="radio" name="reportperiodforkpi" id="reportPeriodForKpi{{pId}}" value="{{pId}}">
									<label for="reportPeriodForKpi{{pId}}"></label>
								</div>
							</td>
						</tr>
					{% endfor %}
				{% endif %}
			</tbody>
		</table>
	</div>
	
	<div class="col-3">
		<label>Выбрать статики:</label>
		<table class="popup__table" id="kpiStaticsList">
			<thead>
				<tr class="h32px">
					<td>Статик</td>
					<td class="w40px center"><i class="fa fa-check-square fz20px" newkpiperiodcheckallstatics></i></td>
				</tr>
			</thead>
				
			<tbody id="newKpiPeriodStatics">
				{% if statics %}
					{% for stId, staticName in statics %}
						<tr>
							<td>{{staticName}}</td>
							<td class="center">
								<div class="checkblock">
									<input type="checkbox" id="reportStaticForKpi{{stId}}" newkpiperiodstatic value="{{stId}}">
									<label for="reportStaticForKpi{{stId}}"></label>
								</div>
							</td>
						</tr>
					{% endfor %}
				{% endif %}
			</tbody>
		</table>
	</div>
	
	<div class="col-6">
		<label>Поля:</label>
		<table class="popup__table" id="kpiFieldsList">
			<thead>
				<tr class="h32px">
					<td>Название поля</td>
					<td class="w80px">Бальность</td>
					<td class="w42px"></td>
				</tr>
			</thead>
			
			<tbody id="newKpiPeriodFields">
				<tr>
					<td><small>Посещаемость</small></td>
					<td>
						<div class="popup__field">
							<input type="number" min="1" max="100" showrows newkpiperiodfieldscore>
						</div>
					</td>
					<td class="center">
						<div class="checkblock">
							<input type="checkbox" id="kpiFieldsVisits" newkpiperiodfield checked value="visits">
							<label for="kpiFieldsVisits"></label>
						</div>
					</td>
				</tr>
				<tr>
					<td><small>Штрафы</small></td>
					<td>
						<div class="popup__field">
							<input type="number" min="1" max="100" showrows newkpiperiodfieldscore>
						</div>
					</td>
					<td class="center">
						<div class="checkblock">
							<input type="checkbox" id="kpiFieldsFine" newkpiperiodfield checked value="fine">
							<label for="kpiFieldsFine"></label>
						</div>
					</td>
				</tr>
				<tr>
					<td><small>Активность на персонажах</small></td>
					<td>
						<div class="popup__field">
							<input type="number" min="1" max="100" showrows newkpiperiodfieldscore>
						</div>
					</td>
					<td class="center">
						<div class="checkblock">
							<input type="checkbox" id="kpiFieldsTasks" newkpiperiodfield checked value="personages">
							<label for="kpiFieldsTasks"></label>
						</div>
					</td>
				</tr>
			</tbody>
				
			<tbody id="newKpiPeriodCustomFields"></tbody>
			
			<tfoot>
				<tr>
					<td colspan="4">
						<div class="buttons right">
							<button class="custom small pl10px pr10px h22px fz12px" id="newKpiPeriodAddField">Добавить поле</button>
						</div>
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
</div>

		