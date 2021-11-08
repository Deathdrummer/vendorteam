<tr>
	{% if type == 2 %}
		<td>
			<div class="select">
				<select name="to_rank" class="fz12px">
					{% if ranks %}
						{% for rId, rank in ranks %}
							<option value="{{rId}}"{% if to_rank == rId %} selected{% endif %}>{{rank.name}}</option>
						{% endfor %}
					{% endif %}
				</select>
				<div class="select__caret"></div>
			</div>
		</td>
	{% endif %}
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