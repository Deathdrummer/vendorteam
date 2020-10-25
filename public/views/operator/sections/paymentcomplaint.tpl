<div class="section" id="paymentcomplaintSection">
	<div class="section__title">
		<h1>Оплата и жалобы</h1>
	</div>
	
	{#<div class="section__buttons" id="sectionButtons">
			
	</div>#}
	
	<div class="section__content" id="sectionContent">
		<div>
			
			<ul class="tabstitles">
				<li id="usersPay" class="active">Заказ оплаты</li>
				<li id="usersComplaints">Предложения и жалобы</li>
			</ul>
			
			
			<div class="tabscontent">
				<div tabid="usersPay">
					<ul class="tabstitles sub">
						<li id="ListPayactual">Актуальные</li>
						<li id="ListPayarchive">Архив</li>
					</ul>
					
					<div class="tabscontent">
						{% for stat, list in users_list_pay %}
							<div tabid="ListPay{{stat}}">
								{% if list|length > 0 %}
									{% set colsp = '' %}
									<table id="usersListPayTable">
										<thead>
											<tr>
												<td>Никнейм</td>
												<td>Статик</td>
												{% for k, item in fields_pay_setting %}
													{% set colsp = colsp~'|'~k %}
													<td>{{item.label}}</td>
												{% endfor %}
												<td>Дата</td>
												<td>Статус</td>
											</tr>
										</thead>
										
										<tbody>
											{% for kf, field in list %}
												<tr>
													<td>{{field.nickname}}</td>
													<td>{{field.static}}</td>
													{% for i in colsp|trim('|', 'left')|split('|') %}
														<td>{{field['field_pay_'~i]}}</td>
													{% endfor %}
													<td class="nowidth nowrap">{{field['date']|slice(0, -3)|d}} {{field['date']|slice(0, -3)|t}}</td>
													<td class="access_block nowidth center">
														{% if field['stat'] %}
															<div access="0" class="success" data-keyfield="{{kf}}" data-type="pay" title="разрешен"></div>
														{% else %}
															<div access="1" class="forbidden" data-keyfield="{{kf}}" data-type="pay" title="не разрешен"></div>
														{% endif %}
													</td>
												</tr>
											{% endfor %}
										</tbody>
									</table>
									
									
									{% if users_list_more %}
										<div class="buttons">
											<button id="usersListPayMore">Загрузить еще</button>
										</div>
									{% endif %}
									
								{% else %}
									<p class="empty">Нет данных</p>
								{% endif %}
							</div>
						{% endfor %}
					</div>
				</div>
				
				
				
				<div tabid="usersComplaints">
					<ul class="tabstitles sub">
						<li id="ListComplaintsactual">Актуальные</li>
						<li id="ListComplaintsarchive">Архив</li>
					</ul>
					
					<div class="tabscontent">
						{% for stat, list in users_list_complaints %}
							<div tabid="{% if stat == 1 %}ListComplaints{{stat}}{% else %}ListComplaints{{stat}}{% endif %}">
								{% if list|length > 0 %}
									{% set colc = '' %}
									<table id="usersListComplaintsTable">
										<thead>
											<tr>
												<td>Никнейм</td>
												<td>Статик</td>
												{% for k, item in fields_complaints_setting %}
													{% set colc = colc~'|'~k %}
													<td>{{item.label}}</td>
													
												{% endfor %}
												<td>Дата</td>
												<td>Статус</td>
											</tr>
										</thead>
										
										<tbody>
											{% for kf, field in list %}
												<tr>
													<td>{{field.nickname}}</td>
													<td>{{field.static}}</td>
													{% for i in colc|trim('|', 'left')|split('|') %}
														<td>{{field['field_complaints_'~i]}}</td>
													{% endfor %}
													<td class="nowidth nowrap">{{field['date']|slice(0, -3)|d}} {{field['date']|slice(0, -3)|t}}</td>
													<td class="access_block nowidth center">
														{% if field['stat'] %}
															<div access="0" class="success" data-keyfield="{{kf}}" data-type="complaints" title="разрешен"></div>
														{% else %}
															<div access="1" class="forbidden" data-keyfield="{{kf}}" data-type="complaints" title="не разрешен"></div>
														{% endif %}
													</td>
												</tr>
											{% endfor %}
										</tbody>
									</table>
									
									{% if users_list_more %}
										<div class="buttons">
											<button id="usersListComplaintsMore">Загрузить еще</button>
										</div>
									{% endif %}
									
								{% else %}
									<p class="empty">Нет данных</p>
								{% endif %}
							</div>
						{% endfor %}
					</div>
				</div>
			</div>
				
		</div>
	</div>
</div>





<script type="text/javascript"><!--
$(document).ready(function() {
	//------------------------- Изменить статус "ЗАКАЗ ОПЛАТЫ" или "ПРЕДЛОЖЕНИЯ И ЖАЛОБЫ"
	$('body').off(tapEvent, '[access]').on(tapEvent, '[access]', function() {
		var thisItem = this,
			thisKeyField = $(thisItem).data('keyfield'),
			thisType = $(thisItem).data('type'),
			stat = $(thisItem).attr('access');
		
		$.post('/admin/set_'+thisType+'_field_stat', {id: thisKeyField, stat: stat}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('access', '0').removeClass('forbidden').addClass('success').attr('title', 'разрешен');
				} else {
					$(thisItem).attr('access', '1').removeClass('success').addClass('forbidden').attr('title', 'не разрешен');
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
});
//--></script>