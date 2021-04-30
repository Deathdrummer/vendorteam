<div class="resign">
	<div class="row">
		<div class="col-6">
			<div class="resign__avatar">
				<img src="{{base_url('public/images/users/'~resign.avatar)}}" alt="">
			</div>
		</div>
		<div class="col-6">
			<h3 class="resign__name">{{resign.nickname}}</h3>	
			
			<div class="resign__static">
				<div style="background-image: url('{{base_url('public/filemanager/'~resign.static.icon)}}')"></div>
				<p>{{resign.static.name}}</p>
			</div>
			
			<ul class="resign__info">
				<li><strong>Дата регистрации аккаунта</strong>{{resign.reg_date|d}}</li>
				<li><strong>Дата подачи заявки</strong>{{resign.date_add|d}} в {{resign.date_add|t}}</li>
				<li><strong>Назначенная дата увольнения</strong>{{resign.date_resign|d}}</li>
				{% if disableedit %}
					<li><strong>Последний рабочий день</strong>{{resign.date_last|d}}</li>
				{% else %}
					<li class="d-flex align-items-center">
						<strong>Посл. рабочий день</strong>
						<div class="field inline">
							<input type="text" id="lastWorkDay" value="{{resign.date_last|d}}">
						</div>
					</li>
				{% endif %}
				
				{% if resign.summ is not same as(null) %}
					<li><strong>Выплаченная сумма</strong>{{resign.summ|number_format(2, '.', ' ')}} <small>₽</small></li>
				{% endif %}
				
				{% if resign.summ is not same as(null) %}
					<li><strong>Ударжано на баланс</strong>{{resign.summ_to_balance|number_format(2, '.', ' ')}} <small>₽</small></li>
				{% endif %}
				
			</ul>
		</div>
		
		<div class="col mt40px">
			<div class="resign__textblock">
				<h4>Причина увольнения</h4>
				<p>{{resign.reason|raw}}</p>
			</div>
			<div class="resign__textblock mt30px">
				<h4>Что бы вы хотели изменить</h4>
				<p>{{resign.comment|raw}}</p>
			</div>
		</div>
	</div>
</div>