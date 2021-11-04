<div class="row gutters-10">
	<div class="col-auto">
		<ul class="pollingstat__nav" id="pollingstatNav">
			<li><span class="pollingstat__navitem pollingstat__navitem_active" pollingstatopensection="reach" pollingstatnavactive>Охват</span></li>
			<li><span class="pollingstat__navitem" pollingstatopensection="questions_total">Общая сводка</span></li>
			<li><span class="pollingstat__navitem" pollingstatopensection="questions_users">Сводка по участникам</span></li>
			<li><span class="pollingstat__navitem" pollingstatopensection="scores">Сводка по баллам</span></li>
		</ul>
	</div>
	<div class="col">
		<div id="pollingStatSection" class="pollingstat__content pollingstat__content_loading">
			{% if section %}
				{% for item in section %}
					<p>{{item.id}}</p>
				{% endfor %}
			{% endif %}
		</div>
	</div>
</div>