<div class="row gutters-10">
	<div class="col-5">
		<img src="{{base_url('public/images/users/'~avatar)|no_file('public/images/user.jpg')}}" alt="{{nickname}}" class="w100 bordered">
	</div>
	<div class="col-7">
		<ul class="usersv2usercard">
			<li class="usersv2usercard__item">
				<span>Никнейм</span>
				<strong>{{nickname}}</strong>
			</li>
			<li class="usersv2usercard__item">
				<span>Звание</span>
				<strong>{{rank.current_rank}}</strong>
				{% if rank.next_rank %}<span class="fontcolor"> -> {{rank.next_rank}} <small>({{rank.count_days}} д.)</small></span>{% endif %}
			</li>
			<li class="usersv2usercard__item">
				<span>Баланс</span>
				<strong>{{balance.current|number_format(2, '.', ' ')}} ₽</strong>
			</li>
			<li class="usersv2usercard__item">
				<span>Резерв</span>
				<div class="usersv2usercard__input">
					<input type="text" id="usersv2UserCardDeposit" value="{{deposit}}">
				</div>
				
				{#<strong contenteditable></strong>#}
			</li>
			<li class="usersv2usercard__item">
				<span>Плат. данные</span>
				<strong class="pointer" copytoclipboard="{{payment}}">{{payment}}</strong>
			</li>
			<li class="usersv2usercard__item">
				<span>Посещаемость</span>
				<strong>{{visits|round(1)}} %</strong>
			</li>
		</ul>
		
		<hr class="usersv2usercard__line">
		
		{% if statics %}
			<div class="usersv2usercard__statics">
				<div class="row gutters-5">
					{% for stId, static in statics %}
						<div class="col-4">
							<div class="usersv2usercardstatic">
								<img src="{{base_url('public/filemanager/thumbs/'~static.icon)}}" alt="{{static.name}}" class="usersv2usercardstatic__icon">
								<div class="usersv2usercardstatic__caption">
									<span class="usersv2usercardstatic__name text-overflow" title="{{static.name}}">{{static.name}}</span>
									<div class="usersv2usercardstatic__stat">
										{% if static.main %}<i class="fa fa-home" title="Основной статик"></i>{% endif %}
										{% if static.lider %}<div title="Лидер в статике"><svg><use xlink:href="#crown"></use></svg></div>{% endif %}
									</div>
								</div>
							</div>
						</div>
					{% endfor %}
				</div>
			</div>
		{% endif %}
	</div>
</div>





{% if balance.history %}
	<div class="mt20px">
		<strong class="mb4px fz14px">История списаний зачислений</strong>
		<table id="usersv2UserCard">
			<thead>
				<tr>
					<td class="w130px"><strong>Тип</strong></td>
					<td><strong>Название</strong></td>
					<td class="w130px"><strong>Дата</strong></td>
					<td class="w80px"><strong>Сумма</strong></td>
					<td class="w80px"><strong>В резерв</strong></td>
					<td class="w80px"><strong>Баланс</strong></td>
				</tr>
			</thead>
			<tbody>
				{% for item in balance.history|reverse %}
					<tr>
						<td><span class="fz12px">{{balance.types[item.type]}}</span></td>
						<td><span class="fz12px">{{item.title}}</span></td>
						<td><span class="fz12px">{{item.date|d}}</span></td>
						<td><strong>{{item.summ|number_format(0, '.', ' ')}}</strong> <small>₽</small></td>
						<td><strong>{{item.deposit|number_format(0, '.', ' ')}}</strong> <small>₽</small></td>
						<td><strong>{{item.current_balance|number_format(0, '.', ' ')}}</strong> <small>₽</small></td>
					</tr>
				{% endfor %}
			</tbody>
		</table>	
	</div>
		
{% endif %}