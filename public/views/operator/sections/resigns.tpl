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
								<td class="nowidth"></td>
								<td class="w200px">Никнейм</td>
								<td>Статик</td>
								<td class="w240px">Дата подачи заявки</td>
								<td class="w110px" title="Опции">Опции.</td>
							</tr>
						</thead>
						<tbody>
							{% if resigns[1] %}
								{% for item in resigns[1] %}
									<tr>
										<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
										<td>{{item.nickname}}</td>
										<td>{{item.static}}</td>
										<td>{{item.date_add|d}} в {{item.date_add|t}}</td>
										<td class="center">
											<div class="buttons inline">
												<button class="alt" showresign="{{item.id}}" title="Посмотреть заявку на увольнение"><i class="fa fa-eye"></i></button>
												<button class="pay" accessresign="{{item.id}}" title="Подтвердить увольнение"><i class="fa fa-check"></i></button>
											</div>
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
								<tr><td colspan="5"><p class="empty center">Нет данных</p></td></tr>
							{% endif %}
						</tbody>
					</table>	
				</div>
				<div tabid="tabResignsArchive">
					<table>
						<thead>
							<tr>
								<td class="nowidth"></td>
								<td class="w200px">Никнейм</td>
								<td>Статик</td>
								<td class="w240px">Дата подачи заявки</td>
								<td class="w240px">Дата одобрения заявки</td>
								<td class="w150px" title="Подтвердил увольнение">Подтвердил</td>
								<td class="w60px">Опции</td>
							</tr>
						</thead>
						<tbody>
							{% if resigns[0] %}
								{% for item in resigns[0] %}
									<tr>
										<td class="nopadding nowidth"><div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}');"></div></td>
										<td>{{item.nickname}}</td>
										<td>{{item.static}}</td>
										<td>{{item.date_add|d}} в {{item.date_add|t}}</td>
										<td>{{item.date_success|d}} в {{item.date_success|t}}</td>
										<td>
											{% if item.from is same as(0) %}
												Администратор
											{% else %}
												<small>Оператор:</small>
												{{item.from}}
											{% endif %}
										</td>
										<td class="center">
											<div class="buttons inline">
												<button class="alt" showresign="{{item.id}}" title="Посмотреть заявку на увольнение"><i class="fa fa-eye"></i></button>
											</div>
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
								<tr><td colspan="6"><p class="empty center">Нет данных</p></td></tr>
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
	$('body').off(tapEvent, '[accessresign]').on(tapEvent, '[accessresign]', function() {
		var thisItem = this,
			thisRow = $(thisItem).closest('tr'),
			id = $(thisItem).attr('accessresign');
		
		$.post('/admin/change_resign_stat', {id: id, from: 'admin', stat: 0}, function(response) {
			if (response) {
				notify('Заявка на увольнение утверждена!');
				$(thisRow).remove();
			} else {
				notify('Ошибка! Заявка на увольнение не утверждена', 'error');
			}
		}).fail(function(e) {
			showError(e);	
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	//------------------------- Посмотреть заявку на увольнение
	$('body').off(tapEvent, '[showresign]').on(tapEvent, '[showresign]', function() {
		var thisItem = this,
			id = $(thisItem).attr('showresign');
		
		popUp({
			title: 'Заявка на увольнение',
		    width: 800,
		    closeButton: 'Закрыть',
		}, function(showResignWin) {
			showResignWin.wait();
			getAjaxHtml('admin/show_resign', {id: id}, function(html) {
				showResignWin.setData(html);
			}, function() {
				showResignWin.wait(false);
			});
		});
	});
	
	
	
	
//--></script>