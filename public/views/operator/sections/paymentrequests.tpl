<div class="section" id="paymentrequestsSection">
	<div class="section__title">
		<h1>Заявки на оплату</h1>
	</div>
	
	<div class="section__buttons" id="sectionButtons">
		<button id="paymentRequestsNew" title="Новая заявка на оплату"><i class="fa fa-plus"></i></button>
		<a class="button" target="_self" href="{{base_url('reports/paymentrequest_export')}}" download="Заявки_на_оплату_{{date('Y-m-d_H_i')}}.csv" title="Экспортировать отчет"><i class="fa fa-download"></i></a>
		
		<div class="item inline ml-5">
			<div class="select">
				<select id="paymentRequestsFindUsersField">
					<option value="nickname">Никнейм</option>
					<option value="payment">Способ оплаты</option>
					<option value="order">№ заказа</option>
					<option value="summ">Сумма заказа</option>
				</select>
				<div class="select__caret"></div>
			</div>
		</div>
		
		<div class="item inline">
			<div class="field">
				<input type="text" id="paymentRequestsFindUsersValue" autocomplete="off" placeholder="Поиск...">
			</div>
		</div>
		
		<div class="item inline">
			<div class="buttons notop">
				<button id="paymentRequestsFindUsersButton"><i class="fa fa-search"></i></button>
			</div>
		</div>
	</div>
	
	<div class="section__content" id="sectionContent">
		<div>
			{% if payment_requests_list %}
				<ul class="tabstitles">
					{% for paid in payment_requests_list|keys %}
						<li id="paymentRequestsPaid{{paid}}">{{payment_requests_titles[paid]}}</li>	
					{% endfor %}
				</ul>	
				<div class="tabscontent">
					{% for paid, items in payment_requests_list %}
						<div tabid="paymentRequestsPaid{{paid}}">
							<table id="paymentRequestsList">
								<thead>
									<tr>
										<td class="w1"></td>
										<td class="nowrap" paymentrequestsort="nickname">Никнейм <i class="fa fa-sort"></i></td>
										<td class="nowrap" paymentrequestsort="static">Статик <i class="fa fa-sort"></i></td>
										<td class="nowrap" paymentrequestsort="payment">Способ оплаты <i class="fa fa-sort"></i></td>
										<td class="nowrap" paymentrequestsort="order">№ заказа <i class="fa fa-sort"></i></td>
										<td class="nowrap" paymentrequestsort="summ">Сумма заказа <i class="fa fa-sort"></i></td>
										<td>Комментарий</td>
										<td>Дата</td>
										<td class="w1">Расчет</td>
									</tr>
								</thead>
								{% for item in items %}
									<tbody>
										<tr>
											<td class="nopadding">
												{% if item.avatar %}
													<div class="avatar mini" style="background-image: url('{{base_url('public/images/users/mini/'~item.avatar)}}')"></div>
												{% else %}
													<div class="avatar mini" style="background-image: url('{{base_url('public/images/user_mini.jpg')}}')"></div>
												{% endif %}
											</td>
											<td>{{item.nickname}}</td>
											<td>
												<div class="d-flex align-items-center">
													<div class="mr-1">
														{% if item.static_icon %}
															<img style="width: 26px" src="{{base_url('public/filemanager/'~item.static_icon)}}" alt="">
														{% else %}
															<img style="width: 26px" src="{{base_url('public/images/deleted_mini.jpg')}}" alt="">
														{% endif %}
													</div>
													<div>{{item.static_name}}</div>
												</div>
											</td>
											<td>{{item.payment}}</td>
											<td>{{item.order}}</td>
											<td class="nowrap">{{item.summ|number_format(2, '.', ' ')}} <small>руб.</small></td>
											<td><small>{{item.comment}}</small></td>
											<td class="nowrap">{{item.date|d}} {{item.date|t}}</td>
											<td class="center">
												<div class="checkblock">
													<input type="checkbox" id="paymentItem{{item.id}}" prpaydone="{{item.id}}"{% if item.paid == 1 %} checked{% endif %}>
													<label for="paymentItem{{item.id}}"></label>
												</div>
											</td>
										</tr>
									</tbody>
								{% endfor %}
							</table>
						</div>
					{% endfor %}
				</div>
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}
		</div>
	</div>
</div>













<script type="text/javascript"><!--
$(document).ready(function() {
	//-------------------------------------------------------------------------------------------------------------------- Заявки на оплату
	$('#paymentRequestsNew').on(tapEvent, function() {
		popUp({
			title: 'Новая заявка на оплату',
		    width: 800,
		    height: 300,
		    wrapToClose: true,
		    winClass: false,
		    buttons: [{id: 'setPaymentRequest', title: 'Оформить заявку', disabled: 1}],
		    closeButton: 'Отмена',
		}, function(pRNewWin) {
			pRNewWin.wait();
			getAjaxHtml('reports/get_users', {start: 1}, function(startHtml) {
				pRNewWin.setData(startHtml);
				$('#setPaymentRequest').setAttrib('disabled', false);
				$('#paymentRequestSumm').number(true, 2, '.', ' ');
				
				//--------------------------------------------------- Оформить заявку
				$('#setPaymentRequest').on(tapEvent, function() {
					var stat = true, users = [], order, summ, comment;
					if ($('#paymentRequestChoosenUsers').find('[paymentrequestchoosenuser]').length == 0) {
						$('#paymentRequestChoosenUsers').addClass('error');
						notify('Необходимо указать участников.', 'error');
						stat = false;
					}
					
					if ($('#paymentRequestOrder').val() == '') {
						$('#paymentRequestOrder').addClass('error');
						notify('Необходимо указать номер заказа.', 'error');
						stat = false;
					}
					
					if ($('#paymentRequestSumm').val() == '') {
						$('#paymentRequestSumm').addClass('error');
						notify('Необходимо указать сумму выплаты.', 'error');
						stat = false;
					}
					
					if (stat) {
						pRNewWin.wait();
						
						$('#paymentRequestChoosenUsers').find('[paymentrequestchoosenuser]').each(function() {
							users.push($(this).attr('paymentrequestchoosenuser'));
						});
						
						order = $('#paymentRequestOrder').val();
						summ = $('#paymentRequestSumm').val();
						comment = $('#paymentRequestComment').val();
						
						$.post('/reports/set_users_orders', {users: users, order: order, summ: summ, comment: comment}, function(response) {
							console.log(response);		
							if (response) {
								notify('Заявка успешно оформлена!');
								pRNewWin.close();
							} else {
								notify('Ошибка оформления заявки', 'error');
							}
							pRNewWin.wait(false);
							setContentData('paymentrequests', {field: getSortField(), order: getSortOrder()});
						}, 'json').fail(function(e) {
							notify('Системная ошибка!', 'error');
							showError(e);
						});
					}	
				});
				
				//--------------------------------------------------- Поиск участников
				var pRFUserTOut; 
				$('#paymentRequestFindUser').on('keyup', function() {
					clearTimeout(pRFUserTOut);
					pRFUserTOut = setTimeout(function() {
						var val = $('#paymentRequestFindUser').val();
						if (val.length == 0 || val.length >= 2) {
							$('#paymentRequestsUsers').addClass('wait');
							getAjaxHtml('reports/get_users', {query: val}, function(html) {
								$('#paymentRequestsUsers').html(html);
								$('#paymentRequestChoosenUsers li').each(function() {
									var thisId = $(this).attr('paymentrequestchoosenuser');
									if ($('#paymentRequestsUsers ul li[chooseusertopaymentrequest="'+thisId+'"]').length > 0) {
										$('#paymentRequestsUsers ul li[chooseusertopaymentrequest="'+thisId+'"]').addClass('choosed');
									}
								});
							}, function() {
								$('#paymentRequestsUsers').removeClass('wait');
								pRNewWin.correctPosition();
							});
						}
					}, 300);	
				});
				
				
				//--------------------------------------------------- Выбор участников
				$('body').off(tapEvent, '[chooseusertopaymentrequest]:not(.choosed)').on(tapEvent, '[chooseusertopaymentrequest]:not(.choosed)', function() {
					$(this).addClass('choosed');
					$('#paymentRequestChoosenUsers').removeClass('error');
					
					var addItem = '',
						thisUserId = $(this).attr('chooseusertopaymentrequest'),
						thisUserNickname = $(this).find('.nickname').text(),
						thisUserStaticImg = $(this).find('.static img').attr('src'),
						thisUserStaticName = $(this).find('.static span').text();
					
					addItem +=	'<li paymentrequestchoosenuser="'+thisUserId+'">';
					addItem +=		'<p class="nickname">'+thisUserNickname+'</p>';
					addItem +=		'<div class="static">';
					addItem +=			'<div class="image"><img src="'+thisUserStaticImg+'" alt=""></div>';
					addItem +=			'<span>'+thisUserStaticName+'</span>';
					addItem +=		'</div>';
					addItem +=		'<div class="remove" title="Удалить участника из списка"></div>';
					addItem +=	'</li>'
					
					$('#paymentRequestChoosenUsers').append(addItem);
				});
				
				
				//--------------------------------------------------- Удаление участникоы
				$('body').off(tapEvent, '[paymentrequestchoosenuser] .remove').on(tapEvent, '[paymentrequestchoosenuser] .remove', function() {
					var thisId = $(this).closest('[paymentrequestchoosenuser]').attr('paymentrequestchoosenuser');
					$(this).closest('[paymentrequestchoosenuser]').remove();
					$('[chooseusertopaymentrequest="'+thisId+'"]').removeClass('choosed');
				});
				
			}, function() {
				pRNewWin.wait(false);
			});
		});
	});
	
	
	
	
	
	// --------------------------------------- Заявки на оплату: изменить статус выплаты
	$('body').off(tapEvent, '[prpaydone]').on(tapEvent, '[prpaydone]', function() {
		var thisItem = this,
			thisId = $(thisItem).attr('prpaydone'),
			paid = $(thisItem).is(':checked') ? 1 : 0;
			
		$.post('/operator/change_paymentrequest_stat', {id: thisId, paid: paid}, function(response) {
			if (response) {
				notify('Статус изменен!');
				//setContentData('paymentrequests', {field: getSortField(), order: getSortOrder()});
			} else {
				notify('Ошибка изменения статуса!', 'error');
			}
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
	
	
	

	// --------------------------------------- Сортировка списка заявок
	$('body').off(tapEvent, '[paymentrequestsort]').on(tapEvent, '[paymentrequestsort]', function() {
		setSortField($(this).attr('paymentrequestsort'));
		setSortOrder();
		setContentData('paymentrequests', {field: getSortField(), order: getSortOrder()});
	});
	
	
	
	
	
	
	$('body').off(tapEvent, '#paymentRequestsFindUsersButton').on(tapEvent, '#paymentRequestsFindUsersButton', function() {
		var findField = $('#paymentRequestsFindUsersField').val();
		var findValue = $('#paymentRequestsFindUsersValue').val();
		
		if (findValue.length > 0) {
			setContentData('paymentrequests', {field: getSortField(), order: getSortOrder(), search_field: findField, search_value: findValue});
		} else {
			setContentData('paymentrequests', {field: getSortField(), order: getSortOrder()});
		}
	});
	
	
	
	
	
	
	//---------- Getter
	function getSortField() {
		return lscache.get('paymentRequestSortField') || 'nickname';
	}
	function getSortOrder() {
		return lscache.get('paymentRequestSortOrder') || 'ASC';
	}
	
	
	
	//---------- Setter
	function setSortField(value) {
		if (!value) return false;
		lscache.set('paymentRequestSortField', value);
	}
	function setSortOrder() {
		var order = lscache.get('paymentRequestSortOrder');
		if (!order) {
			lscache.set('paymentRequestSortOrder', 'ASC');
		} else if (order == 'ASC') {
			lscache.set('paymentRequestSortOrder', 'DESC');
		} else if (order == 'DESC') {
			lscache.set('paymentRequestSortOrder', 'ASC');
		} 
	}
});
//--></script>