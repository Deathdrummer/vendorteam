<div class="section" id="usersAddictSection">
	<div class="section_title">
		<h2>Рейд-лидеры</h2>
	</div>
	
	

	<div class="section__content" id="sectionContent">
		<table id="raidLidersTable">
			<thead>
				<tr>
					<td class="w240px">Участник</td>
					<td class="w250px">Звание</td>
					<td class="w200px">Статики</td>
					<td></td>
				</tr>
			</thead>
			
			<tbody>
				{% for user in liders|sortusers %}
					<tr userid="{{user.id}}">
						<td>
							<div class="d-flex align-items-center">
								<img src="{{base_url('public/images/users/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="" class="avatar w40px h40px">
								<div class="ml5px">
									<strong class="fz14px d-block">{{user.nickname}}</strong>
								</div>
							</div>
						</td>
						<td>
							<div class="select">
								<select name="rank_lider">
									{% if ranks %}
										<option value="">Нет звания</option>
										{% for rId, rank in ranks %}
											<option value="{{rId}}"{% if rId == user.rank_lider %} selected{% endif %}>{{rank.name}}</option>
										{% endfor %}
									{% else %}
										<option disabled selected value="">Нет звание</option>
									{% endif %}
								</select>
								<div class="select__caret"></div>
							</div>
						</td>
						<td>
							{% if user.statics %}
								<div class="scroll_y scroll_y_thin h50px">
									<ul>
										{% for stId, static in user.statics %}
											<li class="fz11px pt1px pb1px">{{statics[static]['name']}}</li>
										{% endfor %}
									</ul>
								</div>
							{% endif %}
						</td>
						<td></td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
</div>










<script type="text/javascript"><!--



$(document).off('renderSection').on('renderSection', function() {
	
	$('#raidLidersTable').ddrScrollTableY({
		height: 'calc(100vh - 200px)',
		minHeight: '80px',
		wrapBorderColor: '#c8ced4'
	});
	
	
	let changeFieldTOut;
	$('#usersAddictSection').changeInputs(function(input, event) {
		$(input).removeClass('changed');
		
		if (['select', 'text'].indexOf(event.st) != -1) {
			
			let tr = $(input).closest('tr'),
				userId = $(tr).attr('userid'),
				name = $(input).attr('name'),
				value = $(input).val() || null;
				
			saveFieldValue(userId, name, value, function() {
				$(input).addClass('changed');
			});
		}
		
		//console.log(input, event.st);
		
		
		/*$(input).closest('td').removeClass('changed');
		let userId = $(input).attr('userid'),
			field = $(input).attr('field'),
			value = null;
		
		if (!userId || !field) return false;
		if (event.st == 'checkbox') {
			value = $(input).is(':checked') ? 1 : 0;
		} else {
			value = $(input).val();
		}
		
		//clearTimeout(changeFieldTOut);
		changeFieldTOut = setTimeout(function() {
			saveFieldValue(userId, field, value, function() {
				$(input).closest('td').addClass('changed');
			});
			
		}, 500);*/
	});
	
	
	
	
	
});


function saveFieldValue(userId, field, value, callback) {
	$.post('/admin/set_lider_field', {user_id: userId, field: field, value: value}, function(response) {
		if (response) {
			if (callback && typeof callback == 'function') callback(response);
		} else {
			notify('Ошибка! Не удалось сохранить значение', 'error');
		}
	}).fail(function(e) {
		notify('Системная ошибка!', 'error');
		showError(e);
	});
}




$(document).ready(function() {
	
	
	
	
});
//--></script>