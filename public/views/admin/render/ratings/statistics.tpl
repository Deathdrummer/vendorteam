<div class="reports noborder">
	<div class="report">
		<table class="w300px">
			<thead>
				<tr>
					<td>Статики</td>
				</tr>
			</thead>
			<tbody>
				{% if statics %}
					{% for stId, static in statics %}
						<tr class="h45px" stid="{{static.id}}">
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
		</table>	
		<div class="scroll">
			<table>
				<thead>
					<tr>
						{% for period in periods %}
							<td class="w100px"><small>{{period.title}}</small></td>
						{% endfor %}
						<td></td>
					</tr>
				</thead>
				<tbody>
					{% for stId, static in statics %}
						<tr class="h45px">
							{% for period in periods %}
								<td class="text-center">
									{% if period.id in statistics[stId] %}<div class="buttons inline center"><button class="button small" showkoeffsreport="{{stId}}" title="Посмотреть отчет"><i class="fa fa-check"></i></button></div>{% else %}-{% endif %}
								</td>
							{% endfor %}
							<td></td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
	</div>
</div>