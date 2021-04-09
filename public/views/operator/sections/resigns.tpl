<div class="section" id="ratingsSection">
	<div class="section__title">
		<h1>Заявки на увольнение</h1>
	</div>
	
	{#<div class="section__buttons" id="sectionButtons">
		<button id="importantinfoSave" title="Сохранить настройки"><i class="fa fa-save"></i></button>
	</div>#}
	
	<div class="section__content" id="sectionContent">
		<div>
			{#<p>Поиск по участнику</p>
			<div class="row align-items-center mb-3">
				<div class="col-auto">
					<div class="field">
						<input type="text" id="searchEventsField" placeholder="Введите никнейм">
					</div>
				</div>
				<div class="col-auto">
					<div class="buttons notop">
						<button id="setSearchFromEvents">Поиск</button>
						<button class="remove" disabled id="resetSearchFromEvents">Сбросить</button>
					</div>
				</div>
			</div>#}
			
			<div id="resignsList">
				<ul class="tabstitles">
					<li id="tabResignsActual" class="active">Актуальные</li>
					<li id="tabResignsArchive">Архив</li>
				</ul>
				
				<div class="tabscontent">
					<div tabid="tabResignsActual" class="visible">
						<table>
							<thead>
								<tr>
									<td></td>
									<td class="w200px">Никнейм</td>
									<td class="w200px">Статик</td>
									<td>Причина увольнения</td>
									<td>Что изменить</td>
									<td class="w150px">Дата регистрации аккаунта</td>
									<td class="w150px">Дата подачи заявки</td>
									<td class="w150px">Дата для увольнения</td>
									<td class="w150px">Последний рабочий день</td>
									<td class="w60px">Статус</td>
								</tr>
							</thead>
							<tbody>
								{% if resigns[1] %}
									{% for item in resigns[1] %}
										<tr>
											<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
											<td>{{item.nickname}}</td>
											<td>{{item.static}}</td>
											<td><small>{{item.reason|raw}}</small></td>
											<td><small>{{item.comment|raw}}</small></td>
											<td>{{item.date_reg|d}}</td>
											<td>{{item.date_add|d}} <p>в {{item.date_add|t}}</p></td>
											<td>{{item.date_resign|d}}</td>
											<td>{{item.date_last|d}}</td>
											<td class="access_block center">
												{% if item.stat %}
													<div resign="0" class="success" data-id="{{item.id}}" title="Уволен"></div>
												{% else %}
													<div resign="1" class="forbidden" data-id="{{item.id}}" title="не уволен"></div>
												{% endif %}
											</td>
										</tr>
									{% endfor %}
								{% else %}
									<tr><td colspan="10"><p class="empty center">Нет данных</p></td></tr>
								{% endif %}
							</tbody>
						</table>	
					</div>
					<div tabid="tabResignsArchive">
						<table>
							<thead>
								<tr>
									<td></td>
									<td class="w200px">Никнейм</td>
									<td class="w200px">Статик</td>
									<td>Причина увольнения</td>
									<td>Что изменить</td>
									<td class="w150px">Дата регистрации аккаунта</td>
									<td class="w150px">Дата подачи заявки</td>
									<td class="w150px">Дата для увольнения</td>
									<td class="w150px">Последний рабочий день</td>
									<td class="w150px">Дата одобрения заявки</td>
									<td class="w150px">Подтвердил увольнение</td>
								</tr>
							</thead>
							<tbody>
								{% if resigns[0] %}
									{% for item in resigns[0] %}
										<tr>
											<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
											<td>{{item.nickname}}</td>
											<td>{{item.static}}</td>
											<td><small>{{item.reason|raw}}</small></td>
											<td><small>{{item.comment|raw}}</small></td>
											<td>{{item.date_reg|d}}</td>
											<td>{{item.date_add|d}} <p>в {{item.date_add|t}}</p></td>
											<td>{{item.date_resign|d}}</td>
											<td>{{item.date_last|d}}</td>
											<td>{{item.date_success|d}} <p>в {{item.date_success|t}}</p></td>
											<td>
												{% if item.from is same as(0) %}
													Администратор
												{% else %}
													<small>Оператор:</small>
													{{item.from}}
												{% endif %}
											</td>
											{#<td class="access_block center">
												{% if item.stat %}
													<div resign="0" class="success" data-id="{{item.id}}" title="Уволен"></div>
												{% else %}
													<div resign="1" class="forbidden" data-id="{{item.id}}" title="не уволен"></div>
												{% endif %}
											</td>#}
										</tr>
									{% endfor %}
								{% else %}
									<tr><td colspan="11"><p class="empty center">Нет данных</p></td></tr>
								{% endif %}
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>




<script type="text/javascript"><!--
	

	var hash = location.hash.split('.');

	if (hash[1] != undefined) {
		$('.tabstitles').find('li').removeClass('active');
		$('.tabscontent').find('[tabid]').removeClass('visible');
		
		$('#'+hash[1]).addClass('active');
		$('[tabid="'+hash[1]+'"]').addClass('visible');
	}
	

	//------------------------- Изменить статус "Заявки на увольнение"
	$('body').off(tapEvent, '[resign]').on(tapEvent, '[resign]', function() {
		var thisItem = this,
			id = $(thisItem).data('id'),
			stat = $(thisItem).attr('resign'),
			from = getCookie('operator_id');
		
		$.post('/admin/change_resign_stat', {id: id, from: from, stat: stat}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('resign', '0').removeClass('forbidden').addClass('success').attr('title', 'уволен');
				} else {
					$(thisItem).attr('resign', '1').removeClass('success').addClass('forbidden').attr('title', 'не уволен');
				}
				notify('Статус изменен!');
			} else {
				notify('Ошибка!', 'error');
			}
		}).fail(function(e) {
			showError(e);	
			notify('Системная ошибка!', 'error');
		});
	});
//--></script>