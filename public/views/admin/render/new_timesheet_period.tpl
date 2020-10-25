<tr>
	<td><div class="text"><input type="text" placeholder="Название периода"></div></td>
	<td>
		<div class="select">
			<select name="" id="">
				{% for item in weeks %}
					<option value="{{item}}">{{item|d}}</option>
				{% endfor %}
			</select>
		</div>
	</td>
	<td class="nowidth"><div class="buttons"><button class="button saveTimesheetPeriod" title="Сохранить период"><i class="fa fa-save"></i></button></div></td>
	<td></td>
</tr>