<div class="drow dgutter-20 adminpermissions" id="adminPermissionsForm">
	{% for sectionTitle, sectionsList in sections %}
		<div class="dcol-4" permissionsblock>
			<div class="d-flex align-items-center justify-content-between h40px">
				<strong>{{sectionTitle}}</strong>
				<i class="fa fa-check-square pointer fz22px green" permissionscheckall title="Выделить все"></i>
			</div>
			
			<table class="clear w100">
				<tbody>
					{% for url, title in sectionsList %}
						{% if url not in ['admins'] %}
							<tr class="adminpermissions__item">
								<td class="pr4px"><span class="fz14px d-block"> {% if title is iterable %}{{title['title']}}{% else %}{{title}}{% endif %}</span></td>
								<td>
									{% if title is iterable %}
										<i class="fa fa-angle-down fz26px pointer" title="Раскрыть список подразделов" opensubitems="{{url}}"></i>
									{% endif %}
								</td>
								<td class="text-right w26px pt6px">
									<div class="checkblock h30px">
										<input id="check{{url}}" type="checkbox" permission="{{url}}"{% if url in permissions %} checked{% endif %}>
										<label for="check{{url}}" title="Выбрать"></label>
									</div>
								</td>
							</tr>
						{% endif %}
						
						{% if title is iterable %}
							<tr class="adminpermissions__subitems" subitems="{{url}}">
								<td colspan="3">
									<table class="clear w100">
										{% for suburl, subtitle in title.items %}
											<tr>
												<td><span class="fz12px d-block">{{subtitle}}</span></td>
												<td class="text-right w30px pt6px">
													<div class="checkblock adminpermissions__checkboxsmall">
														<input id="check{{url~suburl}}" type="checkbox" permissionsub permission="{{url~'.'~suburl}}"{% if url~'.'~suburl in permissions %} checked{% endif %}>
														<label for="check{{url~suburl}}" title="Выбрать"></label>
													</div>
												</td>
											</tr>
										{% endfor %}
									</table>
								</td>	
							</tr>
						{% endif %}
					{% endfor %}
				</tbody>
			</table>
		</div>
	{% endfor %}
</div>