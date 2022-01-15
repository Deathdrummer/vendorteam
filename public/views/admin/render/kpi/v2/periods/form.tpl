<div class="row gutters-5 mb20px">
	<div class="col-6">
		<div class="mb20px">
			<label class="d-block w100">Название периода:</label>
			<div class="popup__field">
				<input type="text" id="newKpiPeriodTitle" placeholder="Введите название" autocomplete="off">
			</div>
		</div>
		<div class="mb20px">
			<label>Дата с:</label>
			<div class="popup__field popup__field_date">
				<input type="text" id="newKpiv2PeriodDateStart" placeholder="Выбрать" autocomplete="off">
			</div>
		</div>
	</div>
	<div class="col-6">
		<div class="mb20px">
			<label class="d-block w100">Вариант выплаты:</label>
			<div class="popup__select">
				<select id="newKpiPeriodPayoutType" class="fz14px">
					<option disabled selected value="">Выбрать...</option>
					<option value="1">Регулярный</option>
					<option value="2">Высокий</option>
				</select>
				<div class="popup__select__caret"></div>
			</div>
		</div>
		<div>
			<label>Дата по:</label>
			<div class="popup__field popup__field_date">
				<input type="text" id="newKpiv2PeriodDateEnd" placeholder="Выбрать" autocomplete="off">
			</div>
		</div>
	</div>
</div>


<div class="row gutters-5 mb20px">
	<div class="col-6">
		<label>Выбрать период:</label>
		<table class="popup__table" id="kpiv2PeriodsList">
			<thead>
				<tr class="h32px">
					<td><strong>Период</strong></td>
					<td class="w40px"></td>
				</tr>
			</thead>
				
			<tbody>
				{% if periods %}
					{% for pId, period in periods %}
						<tr>
							<td><p class="fz12px">{{period.name}}</p></td>
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
	<div class="col-6">
		<label>Коэффициенты:</label>
		<table class="popup__table" id="kpiv2StaticsList">
			<thead>
				<tr class="h32px">
					<td><strong>Статик</strong></td>
					<td class="w80px"><strong>Коэфф.</strong></td>
				</tr>
			</thead>
				
			<tbody>
				{% if statics %}
					{% for stId, static in statics %}
						<tr>
							<td>
								<div class="d-flex align-items-center">
									<img src="{{base_url('public/filemanager/thumbs/'~static.icon)|no_file('public/images/deleted_mini.jpg')}}" alt="{{static.name}}" class="avatar h40px w40px">
									<p class="ml4px fz12px">{{static.name}}</p>
								</div>
							</td>
							<td class="center">
								<div class="field w60px">
									<input type="number" min="0" kpiv2periodstatics="{{stId}}" value="0" showrows>
								</div>
							</td>
						</tr>
					{% endfor %}
				{% endif %}
			</tbody>
		</table>
	</div>
</div>