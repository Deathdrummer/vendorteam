<div class="report mt20px">
	<table class="w300px">
		<thead>
			<tr>
				<td>Статики</td>
			</tr>
		</thead>
		<tbody>
			{% if statics %}
				{% for stId, static in statics %}
					<tr class="h45px pointer" rewardstid="{{stId}}">
						<td class="nopadding">
							<div class="row gutters-5 align-items-center">
								<div class="col-auto">
									<div class="avatar mini" style="background-image: url('{{base_url('public/filemanager/'~static.icon)|is_file('public/images/deleted_mini.jpg')}}')"></div>
								</div>
								<div class="col">
									<p>{{static.name}}</p>
								</div>
							</div>
						</td>
					</tr>
				{% endfor %}
			{% endif %}
		</tbody>
		<tfoot>
			<tr>
				<td><strong>Итого по периоду</strong></td>
			</tr>
		</tfoot>
	</table>
	
	<div class="scroll">
		<table>
			<thead>
				<tr>
					{% for pId, period in periods %}
						<td class="w100px"><small>{{period.name}}</small></td>
					{% endfor %}
					<td></td>
				</tr>
			</thead>
			<tbody>
				{% for stId, periods in report %}
					<tr class="h45px">
						{% for pId, summ in periods %}
							<td>
								{{summ|number_format(2, '.', ' ')}} <small>₽</small>
							</td>
						{% endfor %}
						<td></td>
					</tr>
				{% endfor %}
			</tbody>
			<tfoot>
				<tr>
					{% for pId, period in periods %}
						<td class="w100px"><strong>{{total_periods[pId]|number_format(2, '.', ' ')}} <small>₽</small></strong></td>
					{% endfor %}
					<td></td>
				</tr>
			</tfoot>
		</table>
	</div>
	
	<table class="w150px">
		<thead>
			<tr>
				<td><strong>Итого по статикам</strong></td>
			</tr>
		</thead>
		<tbody>
			{% for stId, periods in report %}
				<tr class="h45px">
					<td><strong>{{total_statics[stId]|number_format(2, '.', ' ')}} <small>₽</small></strong></td>
				</tr>
			{% endfor %}
		</tbody>
		<tfoot>
			<tr>
				<td></td>
			</tr>
		</tfoot>
	</table>
</div>