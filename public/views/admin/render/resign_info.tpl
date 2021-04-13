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
				<li><strong>Последний рабочий день</strong>{{resign.date_last|d}}</li>
			</ul>
		</div>
		
		<div class="col">
			<div class="resign__textblock">
				<h4>Причина увольнения</h4>
				<p>{{resign.reason|raw}}</p>
			</div>
			<div class="resign__textblock">
				<h4>Что бы вы хотели изменить</h4>
				<p>{{resign.comment|raw}}</p>
			</div>
		</div>
	</div>
</div>