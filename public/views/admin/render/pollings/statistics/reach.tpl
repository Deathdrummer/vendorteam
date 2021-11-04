<div class="pollingstatreach">
	<div class="drow">
		<div class="dcol-4">
			<div class="pollingstatreach__block">
				<p>Общий охват</p>
				<span>{{all|length}}</span>
				
				<div class="pollingstatreach__users{% if not all %} pollingstatreach__users_empty{% endif %}">
					{% if all %}
						{% for userId in all %}
							<div class="d-flex align-items-center">
								<img src="{{base_url('public/images/users/mini/'~users[userId]['avatar'])|no_file('public/images/user_mini.jpg')}}" alt="{{users[userId]['nickname']}}" class="avatar h30px w30px mr5px">
								<div class="text-left">
									<small class="d-block fz12px">{{users[userId]['nickname']}}</small>
									<small class="d-block fz10px grayblue">{{statics[users[userId]['static']]}}</small>
								</div>
							</div>
						{% endfor %}
					{% endif %}
				</div>
			</div>
		</div>
		
		<div class="dcol-4">
			<div class="pollingstatreach__block">
				<p>ответили полностью</p>
				<span>{{done|length}}</span>
				
				<div class="pollingstatreach__users{% if not done %} pollingstatreach__users_empty{% endif %}">
					{% if done %}
						{% for userId in done %}
							<div class="d-flex align-items-center">
								<img src="{{base_url('public/images/users/mini/'~users[userId]['avatar'])|no_file('public/images/user_mini.jpg')}}" alt="{{users[userId]['nickname']}}" class="avatar h30px w30px mr5px">
								<div class="text-left">
									<small class="d-block fz12px">{{users[userId]['nickname']}}</small>
									<small class="d-block fz10px grayblue">{{statics[users[userId]['static']]}}</small>
								</div>
							</div>
						{% endfor %}
					{% endif %}
				</div>
			</div>
		</div>
		
		<div class="dcol-4">
			<div class="pollingstatreach__block">
				<p>ответили частично</p>
				<span>{{process|length}}</span>
				
				<div class="pollingstatreach__users{% if not process %} pollingstatreach__users_empty{% endif %}">
					{% if process %}
						{% for userId in process %}
							<div class="d-flex align-items-center">
								<img src="{{base_url('public/images/users/mini/'~users[userId]['avatar'])|no_file('public/images/user_mini.jpg')}}" alt="{{users[userId]['nickname']}}" class="avatar h30px w30px mr5px">
								<div class="text-left">
									<small class="d-block fz12px">{{users[userId]['nickname']}}</small>
									<small class="d-block fz10px grayblue">{{statics[users[userId]['static']]}}</small>
								</div>
							</div>
						{% endfor %}	
					{% endif %}
				</div>
			</div>
		</div>
		
		<div class="dcol-4">
			<div class="pollingstatreach__block">
				<p>Не отвечали</p>
				<span>{{nostart|length}}</span>
				
				<div class="pollingstatreach__users{% if not nostart %} pollingstatreach__users_empty{% endif %}">
					{% if nostart %}
						{% for userId in nostart %}
							<div class="d-flex align-items-center">
								<img src="{{base_url('public/images/users/mini/'~users[userId]['avatar'])|no_file('public/images/user_mini.jpg')}}" alt="{{users[userId]['nickname']}}" class="avatar h30px w30px mr5px">
								<div class="text-left">
									<small class="d-block fz12px">{{users[userId]['nickname']}}</small>
									<small class="d-block fz10px grayblue">{{statics[users[userId]['static']]}}</small>
								</div>
							</div>
						{% endfor %}
					{% endif %}
				</div>
			</div>
		</div>
	</div>
	
	
			
	
			
	
			
</div>



{# кто ответил статик -> участники (пометить тех, кто ответил) #}