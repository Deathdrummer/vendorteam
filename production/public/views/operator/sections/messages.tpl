<div class="section" id="messagesSection">
	<div class="section__title">
		<h1>Сообщения</h1>
	</div>
	
	<div class="section__content" id="sectionContent">
		<div>
			{% if messages %}
				<ul class="tabstitles mb-0">
					{% set firstTab = 1 %}
					{% for type, statData in messages %}
						<li id="tab{{type}}"{% if firstTab == 1 %}class="active"{% endif %}>{% if type == 'complain' %}Жалобы{% else %}Сообщения{% endif %}</li>
						{% set firstTab = 0 %}
					{% endfor %}
				</ul>
				
				<div class="tabscontent">
					{% for type, statData in messages %}
						<div tabid="tab{{type}}">
							<ul class="tabstitles sub">
								{% for stat, messData in statData %}
									<li id="tab{{stat}}">{% if stat == 'actual' %}Актуальные{% else %}Архив{% endif %}</li>
								{% endfor %}
							</ul>
							
							<div class="tabscontent">
								{% for stat, messData in statData %}
									<div tabid="tab{{stat}}">
										<table>
											<thead>
												<tr>
													<td class="w1"></td>
													<td class="w190px">Никнейм</td>
													<td class="w190px">E-mail</td>
													<td>{% if type == 'complain' %}Жалоба{% else %}Сообщение{% endif %}</td>
													<td class="w190px">Дата и время</td>
													<td>Статус</td>
												</tr>
											</thead>
											<tbody>
												{% for message in messData %}
													<tr>
														<td><img src="{{base_url()}}public/images/users/mini/{{message.from_avatar}}" alt=""></td>
														<td>{{message.from_nickname}}</td>
														<td>{{message.from_email}}</td>
														<td class="block" messdata="{{message.message}}" messtype="{% if type == 'complain' %}Жалоба{% else %}Сообщение{% endif %}"><div class="pre-line p-1">{{message.message|trimstring(100)}}</div></td>
														<td>{{message.date|d}} {{message.date|t}}</td>
														<td class="square_block center">
															{% if message.stat %}
																<div messstat="0" data="{{message.id}}" class="success" title="Не обработано"><i class="fa fa-check-square-o"></i></div>
															{% else %}
																<div messstat="1" data="{{message.id}}" class="forbidden" title="Обработано"><i class="fa fa-square-o"></i></div>
															{% endif %}
														</td>
													</tr>
												{% endfor %}
											</tbody>
										</table>
									</div>
								{% endfor %}
							</div>
							
						</div>
					{% endfor %}
				</div>
			{% else %}
				<p class="empty">Нет сообщений</p>
			{% endif %}
			
			
			
			
			{#{% if messages %}
							{% for type, data in messages %}
								<p>{% if type == 'mess' %}Сообщения{% elseif type == 'complain' %}Жалобы{% endif %}</p>
								
							{% endfor %}
						{% else %}
							<p class="empty">Нет сообщений</p>
						{% endif %}#}
		</div>
	</div>
</div>




<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	
	
	$('body').off(tapEvent, '[messdata]').on(tapEvent, '[messdata]', function() {
		var thisMess = $(this).attr('messdata'),
			thisType = $(this).attr('messtype');
			
		popUp({
			title: thisType,
		    width: 600,
		    html: '<div class="pre-line">'+thisMess+'</div>',
		    closeButton: 'Закрыть',
		}, function(win) {});
	});
	
	
	
	
	$('body').off(tapEvent, '[messstat]').on(tapEvent, '[messstat]', function() {
		var thisItem = this,
			stat = $(thisItem).attr('messstat'),
			thisId = $(thisItem).attr('data');
			
		$.post('/operator/change_message_stat', {id: thisId, stat: stat}, function(response) {
			if (response) {
				if (stat === '1') {
					$(thisItem).attr('messstat', '0').removeClass('forbidden').addClass('success').attr('title', 'Обработано');
				} else {
					$(thisItem).attr('messstat', '1').removeClass('success').addClass('forbidden').attr('title', 'Не обработано');
				}
				notify('Статус изменен!');
				//setContentData('messages');
			} else {
				notify('Ошибка изменения статуса!', 'error');
			}
		}, 'json').fail(function(e) {
			showError(e);
			notify('Системная ошибка!', 'error');
		});
	});
	
	
	
});
//--></script>