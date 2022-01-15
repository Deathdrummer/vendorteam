<div class="row">
	<div class="col-6">
		<div class="mb20px">
			<p class="mb5px">Выберите файл:</p>
			<input type="file" id="kpiv2ImportProgressFile">
		</div>
		
		<div>
			<p class="mb5px">Финансовый период:</p>
			<div class="select">
				<select id="kpiv2PeriodId" class="fz14px">
					{% if periods %}
						<option value=""disabled selected>Выбрать</option>
						{% for period in periods %}
							<option value="{{period.id}}">{{period.title}} ({{period.date_start|d(true)}} - {{period.date_end|d(true)}})</option>
						{% endfor %}
					{% else %}
						<option value="" disabled selected>Нет периодов</option>
					{% endif %}
				</select>
				<div class="select__caret"></div>
			</div>
		</div>
	</div>
	<div class="col-6">
		<p class="mb5px">Коэффициенты:</p>
		<div class="h325px" id="kpiv2StaticsList"><p class="empty">Выберите период</p></div>
	</div>
</div>