<tr>
	<td>
		<div class="field">
			<input type="text" name="title" value="{{title}}" placeholder="Введите название шаблона">
		</div>
	</td>
	<td>
		<div class="textarea">
			<textarea rows="2" name="text" class="h40px fz12px noresize" placeholder="Введите тест шаблона">{{text}}</textarea>
		</div>
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button mininewsfeedcode="{{type}}" class="small pay w30px" title="Вставить код"><i class="fa fa-code"></i></button>
			<button{% if id %} update="{{id}}"{% else %} save{% endif %} class="small w30px"><i class="fa fa-save"></i></button>
			<button{% if id %} remove="{{id}}"{% else %} remove{% endif %} class="small remove w30px"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>