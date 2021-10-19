{% if statics %}
	<table id="raidLidersable">
		<thead>
			<tr>
				<td class="w250px">Статики \ Звания РЛ</td>
				{% if ranks_liders %}
					{% for rLId, rankLider in ranks_liders %}
						<td style="min-width:  200px; width: calc(80% / {{ranks_liders|length}})"><small class="fz12px">{{rankLider.name}}</small></td>
					{% endfor %}
				{% endif %}
			</tr>
		</thead>
		<tbody>
			{% for stId, static in statics %}
				<tr>
					<td class="top pt10px">
						<div class="d-flex align-items-center">
							<img src="{{base_url('public/filemanager/thumbs/'~static.icon)}}" alt="{{static.name}}" class="avatar w40px h40px mr5px">
							<p>{{static.name}}</p>
						</div>
					</td>
					{% if ranks %}
						{% for rLId, rankLider in ranks_liders %}
							<td class="w100px simplelist">
								{% if ranks_liders %}
									{% for rId, rank in ranks %}
										<div class="row gutters-4 align-items-center mt4px mb4px pt4px">
											<div class="col">
												<small>{{rank.name}}</small>
											</div>
											<div class="col-auto">
												<div class="d-flex align-items-end w100px">
													<div class="field small">
														<input type="number" showrows rlsinput="{{stId}}|{{rLId}}|{{rId}}" value="{{summs[stId][rLId][rId]}}">
													</div>
													<small class="ml4px fz16px">₽</small>
												</div>
											</div>
										</div>
									{% endfor %}
								{% endif %}
							</td>
						{% endfor %}
					{% endif %}
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}