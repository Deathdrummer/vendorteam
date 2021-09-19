<tr>
	<td>
		<div class="field">
			<input type="text" name="nickname" value="{{nickname}}" placeholder="От 3 до 100 символов..." autocomplete="off" rules="empty|length:3,100">
		</div>
	</td>
	<td>
		<div class="field">
			<input type="text" name="password" value="{{password}}" placeholder="От 3 до 100 символов..." autocomplete="off" rules="empty|length:3,100">
		</div>
	</td>
	<td></td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="pay" adminspermissions title="Доступы"><i class="fa fa-sliders"></i></button>
		</div>
		<input type="hidden" name="permissions" permissionsinput value="{{permissions}}">
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button{% if id %} update="{{id}}"{% else %} save{% endif %} class="small w30px"><i class="fa fa-save"></i></button>
			<button{% if id %} remove="{{id}}"{% else %} remove{% endif %} class="small remove w30px"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>