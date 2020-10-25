<form id="newFolderForm">
	<table>	
		<tr>
			<td><label for="newDirName">Родительская категория:</label></td>
			<td class="w60 nowrap right">
				<div class="select w100">
					<select name="path">
						<option value="">---</option>
						{% if dirs %}
							{% for firstName, firstData in dirs %}
								<option value="{{firstName}}">{{firstName|decodedirsfiles}}</option>
								{% if firstData %}
									{% for secondName, secondData in firstData %}
										<option value="{{firstName}}/{{secondName}}">&nbsp&nbsp&nbsp{{secondName|decodedirsfiles}}</option>
											{% if secondData %}
												{% for thirdName, thirdData in secondData %}
													<option value="{{firstName}}/{{secondName}}/{{thirdName}}">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp{{thirdName|decodedirsfiles}}</option>
												{% endfor %}
											{% endif %}
									{% endfor %}
								{% endif %}
							{% endfor %}
						{% endif %}
					</select>
				</div>
			</td>
		</tr>
		<tr>
			<td><label for="newDirName">Название директории:</label></td>
			<td class="w60 nowrap right">
				<div class="text">
					<input type="text" name="title" placeholder="Название директории">
				</div>
			</td>
		</tr>
	</table>
</form>