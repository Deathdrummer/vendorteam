<form id="replaceFilesForm">
	<table>	
		<tr>
			<td><label for="newDirName">Куда переместить:</label></td>
			<td class="w70 nowrap right">
				
				{% if dirs|keys[0] != currentdir or dirs|length > 1 or dirs[currentdir] is not empty %}
					<div class="select w100">
						<select name="path">
							{% for firstName, firstData in dirs %}
								{% if currentdir != firstName %}
									<option value="{{firstName}}">{{firstName|decodedirsfiles}}</option>
								{% endif %}
								{% if firstData %}
									{% for secondName, secondData in firstData %}
										{% if currentdir != firstName~'/'~secondName %}
											<option value="{{firstName}}/{{secondName}}">&nbsp&nbsp&nbsp{{secondName|decodedirsfiles}}</option>
										{% endif %}
										{% if secondData %}
											{% for thirdName, thirdData in secondData %}
												{% if currentdir != firstName~'/'~secondName~'/'~thirdName %}
													<option value="{{firstName}}/{{secondName}}/{{thirdName}}">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp{{thirdName|decodedirsfiles}}</option>
												{% endif %}
												{% if thirdData %}	
													{% for forthName, forthData in thirdData %}
														{% if currentdir != firstName~'/'~secondName~'/'~thirdName~'/'~thirdName %}
															<option value="{{firstName}}/{{secondName}}/{{thirdName}}/{{forthName}}">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp{{forthName|decodedirsfiles}}</option>
														{% endif %}
													{% endfor %}	
												{% endif %}
											{% endfor %}
										{% endif %}
									{% endfor %}
								{% endif %}
							{% endfor %}
						</select>
					</div>
				{% else %}
					<p class="empty">Нет директорий для перемещения</p>
				{% endif %}
			</td>
		</tr>
	</table>
</form>