{% if calendar %}
	<h4>Выберите месяц</h4>
	<div class="calendarpopup noselect" id="calendarPopup">
		{% for year, monthes in calendar %}
			<div class="calendarpopup__block">
				<p class="calendarpopup__year">{{year}} г.</p>
				<div class="calendarpopup__monthes">
					{% for month in monthes %}
						<div>
							<input type="checkbox" id="calendar{{md5(year~month.timepoint~month.month)}}" value="{{month.timepoint}}">
							<label for="calendar{{md5(year~month.timepoint~month.month)}}" class="calendarpopup__month">
								<span>{{month.month}}</span>
							</label>
						</div>
					{% endfor %}
				</div>
			</div>
		{% endfor %}
	</div>
{% endif %}