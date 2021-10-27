<tr>
	<td class="top pt10px">
		<div class="field">
			<input type="text" name="title" value="{{title}}" rules="string" autocomplete="off" placeholder="Введите название">
		</div>
	</td>
	<td class="top pt10px pb10px">
		<div class="textarea">
			<textarea class="fz12px noresize pt5px" name="description" rows="7" placeholder="Введите описание" autocomplete="off" rules="empty|string">{{description}}</textarea>
		</div>
	</td>
	<td class="center top pt10px">{{count_users_answers|default('0')}}</td>
	<td class="top pt10px">
		<div class="d-flex justify-content-between">
			<p>{{date|d}}</p>
			<p>{{date|t}}</p>
		</div>
	</td>
	<td class="top pt10px">
		<div class="drow dgutters-10">
			<div class="dcol-2">
				<div class="d-flex justify-content-between">
					<strong class="fz13px">Участники</strong>
					<i class="fa fa-bars fz20px pointer" pollingauditoryusers="{{id}}" title="Управление аудиторией"></i>
				</div>
					
				<ul class="scroll_y scroll_y_thin h70px" pollingauditoryuserslist>
					{% if users %}
						{% for uId, user in users %}
							<li>{{user.nickname}}</li>
						{% endfor %}
					{% else %}
						<li><p class="empty fz12px">Участники не выбраны</p></li>
					{% endif %}
				</ul>
			</div>
			<div class="dcol-2">
				<div class="d-flex justify-content-between">
					<strong class="fz13px">Статики</strong>
					<i class="fa fa-bars fz20px pointer" pollingauditorystatics="{{id}}" title="Управление аудиторией"></i>
				</div>
					
				<ul class="scroll_y scroll_y_thin h70px" pollingauditorystaticslist>
					{% if statics %}
						{% for stId, static in statics %}
							<li>{{static.name}}</li>
						{% endfor %}
					{% else %}
						<li><p class="empty fz12px">Статики не выбраны</p></li>
					{% endif %}
				</ul>
			</div>
		</div>
	</td>
	<td class="center top">
		<div class="d-flex">
			<div class="w100 pt10px">
				<strong pollingcountquestions>{{count_questions|default('0')}}</strong>
			</div>
			<div class="buttons inline notop ml5px pt10px">
				<button class="small w30px" pollingquestions="{{id}}" title="Управление вопросами"><i class="fa fa-bars"></i></button>
			</div>
		</div>
	</td>
	<td class="top pt10px">
	
		<div class="field">
			<input type="text" placeholder="Сразу" autocomplete="off" pollingdatestart value="{{start_date|d}}">
		</div>
		<input type="hidden" name="start_date" value="{{date('Y-m-d', start_date)}}" pollingdatestartvalue>
		
		<div class="row gutters-5 mt10px" pollingstarttime{% if not start_hours and not start_minutes %} %} hidden{% endif %}>
			<div class="col-auto">
				<div class="select w50px">
					<select name="start_hours">
						{% for h in 0..23 %}
							<option value="{{h}}"{% if start_hours and h == start_hours %} selected{% endif %}>{{h|add_zero}}</option>
						{% endfor %}
					</select>
					<div class="select__caret"></div>
				</div>
				<sub>ч.</sub>
			</div>
			<div class="col-auto">
				<div class="select w50px">
					<select name="start_minutes">
						{% if minutes %}
							{% for m in minutes %}
								<option value="{{m}}"{% if start_minutes and m == start_minutes %} selected{% endif %}>{{m|add_zero}}</option>
							{% endfor %}
						{% endif %}
					</select>
					<div class="select__caret"></div>
				</div>
				<sub>мин.</sub>
			</div>
		</div>
	</td>
	<td class="center top">
		<div class="checkblock pt10px">
			<input type="checkbox" pollingsstatus="{{id}}" id="pollingsStatus{{id}}"{% if status %} checked{% endif %}{% if not count_questions %} disabled{% endif %}>
			<label for="pollingsStatus{{id}}"></label>
		</div>
	</td>
	<td class="top center pt6px">
		<div class="buttons inline notop">
			<button class="small w30px" update="{{id}}" title="Обновить"><i class="fa fa-save"></i></button>
			<button class="small w30px remove" remove="{{id}}" title="Удалить опрос"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>