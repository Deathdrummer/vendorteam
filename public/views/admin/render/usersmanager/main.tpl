<div class="usersmanager">
	<div class="row gutters-4">
		<div class="col-auto">
			<div class="usersmanager__title"><p class="mb-0">Статики</p></div>	
			<div class="usersmanager__container">
				<div class="usersmanager__wait" id="staticsWait">
					<div>
						<i class="fa fa-spinner fa-pulse fa-fw"></i>
						<span>Загрузка...</span>
					</div>
				</div>
				<div class="usersmanager__statics noselect" id="usersmanagerStatics">
					{% if statics %}
						<ul>
							{% for stId, static in statics %}
								<li class="usersmanagerstatic" umstatic="{{stId}}">
									<div class="usersmanagerstatic__icon" style="background-image: url('{{base_url('public/filemanager/'~static.icon)}}')"></div>
									<p class="usersmanagerstatic__name">{{static.name}}</p>
									<p class="usersmanagerstatic__count"><span countchoosedusers>0</span>/{{static.count_users}}</p>
								</li>
							{% endfor %}
						</ul>
					{% else %}
						<div class="usersmanager__empty">
							<p class="empty center">Нет статиков</p>
						</div>
					{% endif %}
				</div>
			</div>
				
		</div>
		<div class="col">
			<div class="usersmanager__title usersmanager__title_right">
				<p class="mb-0 mr-2">Участники</p>
				{% if choose_type == 'multiple' %}
					<span class="mb-0"><strong class="usersmanager__total"><span id="usersmanagerChoosedTotal">0</span>/<span id="usersmanagerCountAllUsers">{{count_all_users}}</span></strong></span>
				{% else %}
					<span class="mb-0"><strong class="usersmanager__total usersmanager__total_short">{{count_all_users}}</strong></span>
				{% endif %}
				
				<input type="hidden" id="usersmanagerTotal" value="{{count_all_users}}">
				
				<input type="text" class="usersmanager__input ml-auto" id="usersmanagerSearch" placeholder="Введите никнейм" autocomplete="off">
				
				{% if ranks %}
					<select id="usersmanagerRanks" class="usersmanager__input ml15px">
						<option disabled selected>Выберите звание</option>
						<option value="">Все звания</option>
						{% for rId, rank in ranks %}
							<option value="{{rId}}">{{rank.name}}</option>
						{% endfor %}
					</select>
				{% endif %}
				
				{% if choose_type == 'multiple' %}
					<div class="usersmanager__buttons ml15px">
						<button id="uMUncheckAllStatic" disabled title="Отменить выделение в статике"><i class="fa fa-minus-square-o"></i></button>
						<button id="uMCheckAllStatic" disabled title="Выделить все в статике"><i class="fa fa-check-square-o"></i></button>
						<button id="uMUncheckAll" class="ml10px" disabled title="Отменить выделение"><i class="fa fa-minus-square"></i></button>
						<button id="uMCheckAll" disabled title="Выделить все"><i class="fa fa-check-square"></i></button>
					</div>
				{% endif %}
			</div>	
			<div class="usersmanager__container">
				<div class="usersmanager__wait" id="usersWait">
					<div>
						<i class="fa fa-spinner fa-pulse fa-fw"></i>
						<span>Загрузка...</span>
					</div>
				</div>
				<div class="usersmanager__users" id="usersmanagerUsers"></div>
			</div>
		</div>
	</div>
</div>	