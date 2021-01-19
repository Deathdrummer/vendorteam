<div class="periods_activate_block">
	{% for k, name in {1: 'Универсальный', 2: 'Европа', 3: 'Америка'} %}
		<h3>{{name}}</h3>
		<div zone="{{k}}">
			<div class="mr-1">
				<label for="">Дата:</label>
				<div class="popup__field popup__field_date">
					<input type="text" class="setDatetoActivate" date="{{date('d-m-Y', data[k]['date'])}}" value="{% if data[k]['date'] %}{{data[k]['date']|d}}{% endif %}" />
				</div>
			</div>
			<div>
				<label for="">Время (ч):</label>
				<div class="popup__select w70px">
					<select class="activate_periods_time">
						{% for i in 0..24 %}
							<option value="{{i}}"{% if i == data[k]['time'] %} selected{% endif %}>{{i|add_zero}}</option>
						{% endfor %}
					</select>
					<div class="popup__select__caret"></div>
				</div>
			</div>
		</div>
	{% endfor %}
	<div class="button"><button activateperiods>Задать</button></div>
</div>


<script type="text/javascript"><!--
var d = new Date(); d.setDate(d.getDate() + 0); // установить ближайшую доступную дату
$('.setDatetoActivate').datepicker({
    dateFormat:         'd M yy г.',
    yearRange:          "2010:+10",
    numberOfMonths:     1,
    changeMonth:        true,
    changeYear:         true,
    monthNamesShort:    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября', 'декабря'],
    monthNames:         ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь', 'декабрь'],
    dayNamesMin:        ['вс','пн','вт','ср','чт','пт','сб',],
    firstDay:           1,
    minDate:            d,
    onSelect: function(stringDate, dateObj) {
    	$(this).attr('date', dateObj.selectedDay+'-'+(dateObj.selectedMonth+1)+'-'+dateObj.selectedYear);
    	$(this).closest('div[zone]').addClass('changed');
    }
});


$('.activate_periods_time').on('change', function() {
	$(this).closest('div[zone]').addClass('changed');
});

//--></script>