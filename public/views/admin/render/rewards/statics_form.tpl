<div class="reports noborder">
	<div class="report">
		<div>
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
		</div>
			
		<form class="scroll noselect" id="rewardsStaticsSum">
			<table>
				<thead>
					<tr>
						{% for pId, ptitle in periods %}
							<td class="w100px"><small>{{ptitle}}</small></td>
						{% endfor %}
						<td></td>
					</tr>
				</thead>
				<tbody>
					{% for stId, static in statics %}
						<tr class="h45px">
							{% for pId, ptitle in periods %}
								<td class="text-center">
									<div class="popup__field">
										<input type="number" name="amounts[{{pId}}][{{stId}}]" showrows value="{{rewards[pId][stId]|default('0')}}">
									</div>
								</td>
							{% endfor %}
							<td></td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</form>
	</div>
</div>