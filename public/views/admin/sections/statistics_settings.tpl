<form class="section" id="{{id}}">
	<div class="section_title">
		<h2>Статистика (настройки)</h2>
		<div class="buttons notop" id="{{id}}SaveBlock">
			<button class="large" id="{{id}}Save" title="Сохранить"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	<fieldset>
		<legend>Список статиков</legend>
		
		{% if statics %}
			<ul class="tabstitles">
				{% for stId, stData in statics %}
					<li id="statisticsStatic{{stId}}">{{stData.name}}</li>
				{% endfor %}
			</ul>
		{% endif %}
		
		
		
		{% if statics %}
			<div class="tabscontent">
				{% for stId, stData in statics %}
					<div tabid="statisticsStatic{{stId}}">
						<div class="list">
							<div class="list_item">
								<div class="block">
									<h3>{{stData.name}}</h3>
									{% include form~'file.tpl' with {'label': 'Картинка', 'name': 'statistics|'~stId~'|image', 'ext': 'jpg|png'} %}
									{% include form~'textarea.tpl' with {'label': 'Текст всплывающего окна', 'name': 'statistics|'~stId~'|text', 'editor': 'statisticsText'~stId, 'class': 'w100'} %}
									{% include form~'radio.tpl' with {'label': 'Отображать статистику', 'name': 'statistics|'~stId~'|access', 'data': {'Нет': 0, 'Да': 1}} %} 
									
									
									<div class="d-flex align-items-end">
										<div class="buttons text-left">
											<button choosecustomer="{{stId}}">Выбрать участника</button>
											<input type="hidden" class="customer_id" name="statistics_setting[{{stId}}][customer][id]" value="">
											<input type="hidden" class="customer_nickname" name="statistics_setting[{{stId}}][customer][nickname]" value="">
											<input type="hidden" class="customer_avatar" name="statistics_setting[{{stId}}][customer][avatar]" value="">
										</div>
										
										<div class="ml-3">
											<p>Выбранный участник:</p>
											{% if statistics_setting[stId]['customer']['id'] is not null %}
												<img id="customerAvatar{{stId}}" src="{{base_url('public/images/users/mini/'~statistics_setting[stId]['customer']['avatar'])}}" alt="">
												<span id="customerNickname{{stId}}">{{statistics_setting[stId]['customer']['nickname']}}</span>
											{% else %}
												<img id="customerAvatar{{stId}}" src="{{base_url('public/images/user_mini.jpg')}}" alt="Участник не выбран">
												<span id="customerNickname{{stId}}">Участник не выбран</span>
											{% endif %}
										</div>
									</div>
										
								</div>
							</div>
						</div>
					</div>
				{% endfor %}
			</div>
		{% else %}
			<p class="empty">Нет статиков</p>
		{% endif %}
	</fieldset>
</form>





<script type="text/javascript"><!--
$(document).ready(function() {
	//-------------------------------------------------------------- Задать данные верифицированных пользователей
	$('#statistics_settingsSave').on(tapEvent, function(event) {
		var statisticsFormData = new FormData($('#statistics_settings')[0]);
		$.ajax({
			type: 'POST',
			url: '/admin/save_settings',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: statisticsFormData,
			success: function(response) {
				if (response) notify('Настройки сохранены!');
				else notify('Ошибка сохранения данных', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	
	
	
	
	$('[choosecustomer]').on(tapEvent, function() {
		var thisStaticRow = this,
			thisStaticId = $(thisStaticRow).attr('choosecustomer');
		
		popUp({
			title: 'Выбрать произвольного пользователя',
		    width: 600,
		    height: false,
		    html: '',
		    wrapToClose: true,
		    winClass: false,
		    buttons: false,
		    closeButton: false,
		}, function(statisticsUsersWin) {
			statisticsUsersWin.wait();
			getAjaxHtml('admin/statistics_get_users', {static_id: thisStaticId}, function(html) {
				statisticsUsersWin.setData(html, false);
				
				$('[choosepopupcustomer]').on(tapEvent, function() {
					var thisCustomer = $(this).attr('choosepopupcustomer').split('|'),
						thisCustomerId = thisCustomer[0],
						thisCustomerNickname = thisCustomer[1],
						thisCustomerAvatar = thisCustomer[2];
					
					$(thisStaticRow).siblings('.customer_id').val(thisCustomerId);
					$(thisStaticRow).siblings('.customer_nickname').val(thisCustomerNickname);
					$(thisStaticRow).siblings('.customer_avatar').val(thisCustomerAvatar);
					
					
					$('#customerAvatar'+thisStaticId).attr('src', location.origin+'/public/images/users/mini/'+thisCustomerAvatar);
					$('#customerNickname'+thisStaticId).text(thisCustomerNickname);
					
					statisticsUsersWin.close();
				});
				
				
			}, function() {
				statisticsUsersWin.wait(false);
			});
		});
		
		
	});
	
	
	
	
});
//--></script>