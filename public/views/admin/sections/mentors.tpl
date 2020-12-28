<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Наставничество</h2>
		<div class="buttons notop" id="{{id}}SaveBlock">
			<button class="large" id="{{id}}Save" title="Сохранить"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список заявок</legend>
		
		<ul class="tabstitles">
			<li id="tabMentorsRequestsActive">Активные</li>
			<li id="tabMentorsRequestsDone">Выполнено</li>
		</ul>
		
		<div class="tabscontent">
			<div tabid="tabMentorsRequestsActive">
				<table>
					<thead>
						<tr>
							<td class="w260px">Заказчик</td>
							<td class="w260px">Наставник</td>
							<td class="w200px">Класс наставничества</td>
							<td></td>
							<td class="w220px">Дата создания заявки</td>
							<td class="w140px">Статус</td>
							<td class="w70px">Опции</td>
						</tr>
					</thead>
					<tbody>
						{% for mr in mentors_requests.active %}
							<tr>
								<td>
									<div class="d-flex align-items-center py-1">
										<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~mr.user.avatar)}}')"></div>
										<div class="ml5px">
											<p class="mb5px"><strong>{{mr.user.nickname|default('Неизвестно')}}</strong></p>
											<small>{{mr.user.static|default('Неизвестно')}}</small>
										</div>
									</div>
								 </td>
								<td>
									<div class="d-flex align-items-center py-1">
										<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~mr.mentor.avatar)}}')"></div>
										<div class="ml5px">
											<p class="mb5px"><strong>{{mr.mentor.nickname|default('Неизвестно')}}</strong></p>
											<small>{{mr.mentor.static|default('Неизвестно')}}</small>
										</div>
									</div>
								</td>
								<td>{{mr.class_name}}</td>
								<td></td>
								<td>{{mr.date|d}} в {{mr.date|t}}</td>
								<td statustitle>{{mr.status_text}}</td>
								<td class="text-center">
									<div class="buttons inline">
										<button class="main alt small w26px" mrchangestat="{{mr.id}}" mrstat="{{mr.status|default('null')}}" title="Сменить статус заявки"><i class="fa fa-check"></i></button>
										<button class="main pay small w26px" mrsettopay="{{mr.id}}"{% if mr.status != 1 %} disabled{% endif %} title="Отправить заявку на оплату"><i class="fa fa-money"></i></button>
									</div>
								</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
			<div tabid="tabMentorsRequestsDone">
				<table>
					<thead>
						<tr>
							<td class="w260px">Заказчик</td>
							<td class="w260px">Наставник</td>
							<td class="w200px">Класс наставничества</td>
							<td></td>
							<td class="w220px">Дата создания заявки</td>
							<td class="w220px">Отправлено на оплату</td>
						</tr>
					</thead>
					<tbody>
						{% for mr in mentors_requests.archive %}
							<tr>
								<td>
									<div class="d-flex align-items-center py-1">
										<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~mr.user.avatar)}}')"></div>
										<div class="ml5px">
											<p class="mb5px"><strong>{{mr.user.nickname|default('Неизвестно')}}</strong></p>
											<small>{{mr.user.static|default('Неизвестно')}}</small>
										</div>
									</div>
								 </td>
								<td>
									<div class="d-flex align-items-center py-1">
										<div class="avatar" style="background-image: url('{{base_url('public/images/users/mini/'~mr.mentor.avatar)}}')"></div>
										<div class="ml5px">
											<p class="mb5px"><strong>{{mr.mentor.nickname|default('Неизвестно')}}</strong></p>
											<small>{{mr.mentor.static|default('Неизвестно')}}</small>
										</div>
									</div>
								</td>
								<td>{{mr.class_name}}</td>
								<td></td>
								<td>{{mr.date|d}} в {{mr.date|t}}</td>
								<td>{{mr.done|d}} в {{mr.date|t}}</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		</div>
	</fieldset>
	
</div>


{#<td class="access_block nowidth center">
	{% if field['stat'] %}
		<div access="0" class="success" data-keyfield="{{kf}}" data-type="pay" title="разрешен"></div>
	{% else %}
		<div access="1" class="forbidden" data-keyfield="{{kf}}" data-type="pay" title="не разрешен"></div>
	{% endif %}
</td>#}



<script type="text/javascript"><!--
$(document).ready(function() {
	
	// Сменить статус заявки
	$('[mrchangestat]').off(tapEvent).on(tapEvent, function() {
		let thisButton = this,
			titleSelector = $(this).closest('tr').find('[statustitle]')
			setPayButton = $(this).closest('tr').find('[mrsettopay]'),
			reqId = $(this).attr('mrchangestat'),
			thisStat = $(this).attr('mrstat'),
			listHtml = '';
			
			listHtml += '<ul class="popup__list">';
			if (thisStat != 'null') listHtml +=	'<li title="Выбрать статус \'На рассмотрении\'" mrstatitem="" mrstattitle="На рассмотрении"><span>На рассмотрении</span></li>';
			if (thisStat != 1) 		listHtml += '<li title="Выбрать статус \'Одобрено\'" mrstatitem="1" mrstattitle="Одобрено"><span>Одобрено</span></li>';
			if (thisStat != 0) 		listHtml += '<li title="Выбрать статус \'Отказано\'" mrstatitem="0" mrstattitle="Отказано"><span>Отказано</span></li>';
			listHtml += '</ul>';
		
		popUp({
			title: 'Сменить статус заявки',
			html: listHtml,
		    width: 400,
		    closeButton: 'Отмена',
		}, function(mrChangeStatWin) {
			$('[mrstatitem]').on(tapEvent, function() {
				mrChangeStatWin.wait();
				let stat = $(this).attr('mrstatitem') || null,
					stTitle = $(this).attr('mrstattitle');
					
				$.post('/admin/mentors/change_stat', {id: reqId, stat: stat}, function(response) {
					if (response) {
						$(titleSelector).text(stTitle);
						$(thisButton).attr('mrstat', (stat === null ? 'null' : stat));
						
						if (stat != 1) $(setPayButton).setAttrib('disabled');
						else $(setPayButton).removeAttrib('disabled');
						
						mrChangeStatWin.close();
						notify('Ззаявка успешно отправлена!');
					} else {
						notify('Ошибка отправки заявки!', 'error');
						mrChangeStatWin.wait(false);
					}
				});
			});
			
		});
	});
	
	
	
	// Отправить заявку на оплату
	$('[mrsettopay]').off(tapEvent).on(tapEvent, function() {
		let thisRow = $(this).closest('tr'),
			reqId = $(this).attr('mrsettopay');
		
		popUp({
			title: 'Отправить заявку',
		    //html: '<p class="center info large strong">Вы действительно хотите отправить заявку на оплату?</p>',
		    width: 500,
		    buttons: [{id: 'setToPay', title: 'Отправить'}],
		    closeButton: 'Отмена',
		}, function(mrSetToPayWin) {
			mrSetToPayWin.wait();
			getAjaxHtml('admin/mentors/get_pay_blank', {id: reqId}, function(html) {
				mrSetToPayWin.setData(html);
			}, function() {
				mrSetToPayWin.wait(false);
			});
			
			$('#setToPay').on(tapEvent, function() {
				mrSetToPayWin.wait();
				sendFormData('#mrPaymentBlank', {
					url: 'admin/mentors/set_to_pay',
					success: function(response) {
						if (response) {
							notify('Заявка на оплату успешно отправлена!');
							$(thisRow).remove();
							mrSetToPayWin.close();
						} else {
							notify('Ошибка отправки заявки!', 'error');
						}
						mrSetToPayWin.wait(false);
					},
					error: function() {
						notify('Неизвестная ошибка!', 'error');
						mrSetToPayWin.wait(false);
					}
				});
			});
		});
	});
	
});
//--></script>