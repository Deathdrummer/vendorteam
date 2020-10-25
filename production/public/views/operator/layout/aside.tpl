<aside class="leftblock" id="operatorLeftBlock">
	<div class="leftblock__block leftblock__block_top mb-2 mb-md-3" id="operatorTopBlock">
		<div class="leftblock__avatar mb-2">
			{% if avatar %}
				<img operatoravatarimg src="public/images/operators/{{avatar}}?{{time()}}" alt="">
			{% else %}
				<img operatoravatarimg src="public/images/user.jpg" alt="">
			{% endif %}
			<button class="leftblock__changebutton" id="changeAvatar">Изменить</button>
		</div>
		
		<p class="leftblock__nickname">
			<span operatornickname>{{nickname|default('Не задано')}}</span>
			<i class="fa fa-edit" id="changeNickname"></i>
		</p>
		
		<div class="leftblock__logout">
			<button operatorlogout title="Выйти из кабинета оператора"><i class="fa fa-sign-out"></i> Выход</button>
		</div>
	</div>
	
	<div class="leftblock__block leftblock__block_navblock" id="operatorNavBlock">
		<div class="leftblock__nav noselect">
			<ul operatorSections class="noselect">
				<li id="main" url="main" hash="main" title="Главная страница"><i class="fa fa-home"></i><span>Главная страница</span></li>
				{% for id, item in data_access %}
					{% if id in access and item.url %}
						<li id="{{item.id}}" url="{{item.url}}" hash="{{item.hash}}" title="{{item.desc}}">
							<i class="fa fa-{{item.icon|default('bars')}}"></i>
							<span>{{item.title}}</span>
						</li>
					{% endif %}
				{% endfor %}
				<li id="messages" url="messages" hash="messages" title="Главная страница"><i class="fa fa-envelope"></i><span>Сообщения</span></li>
			</ul>
		</div>
	</div>
	
	<div class="leftblock__block leftblock__block_bottom mt-2 mt-md-3{% if not is_verify_user %} p-0{% endif %}" id="operatorBottomBlock">
		<div class="leftblock__nav leftblock__nav_bottom noselect p-0">
			{#<p>Доступные статики</p>
			<ul>
				{% for sId, static in access_statics %}
					<li><img src="{{base_url()}}public/images/{{static.icon}}" alt=""><span>{{static.name}}</span></li>		
				{% endfor %}	
			</ul>#}
		</div>
	</div>
</aside>