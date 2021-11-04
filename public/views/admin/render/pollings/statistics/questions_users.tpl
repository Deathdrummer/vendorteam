<div class="row gutters-10">
	<div class="col-3">
		<strong class="mb2px fz14px">Статики</strong>
		<div class="pollingstatstatics" id="pollingStatStatics">
			{% if statics %}
				{% for stId, static in statics %}
					<div class="pollingstatstatics__item" qustatic="{{stId}}">
						<img src="{{base_url('public/filemanager/thumbs/'~static.icon)|no_file('public/images/deleted_mini.jpg')}}" alt="{{static.name}}" class="avatar w26px h26px">
						<span class="ml5px fz12px">{{static.name}}</span>
					</div>
				{% endfor %}
			{% endif %}
		</div>
		
		<strong class="mb2px fz14px">Участники</strong>
		<div class="pollingstatusers pollingstatusers_empty" id="pollingStatUsers">
			{% if users %}
				{% for uId, user in users %}
					<div class="pollingstatusers__item pollingstatusers__item_hidden" qustaticgroup="{{user.static}}" quuser="{{uId}}">
						<img src="{{base_url('public/images/users/mini/'~user.avatar)|no_file('public/images/user_mini.jpg')}}" alt="{{user.nickname}}" class="avatar w30px h30px">
						<span class="ml5px fz12px">{{user.nickname}}</span>
					</div>
				{% endfor %}
			{% endif %}
		</div>
	</div>
	<div class="col-9">
		<div class="pollingstatusersblock" id="userQquestionsBlock"></div>
	</div>
</div>



		