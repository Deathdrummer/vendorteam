<div class="row gutters-8" id="walletParamsForm">
	<div class="col-3">
		<div class="d-flex align-items-center justify-content-between pr10px mb10px">
			<strong class="d-block">Статики</strong>
			<div checkbutton="walletparamstatics|0" class="h18px pointer">
				<i class="fa fa-square-o fz20px w18px" cls="fa fa-check-square-o|fa fa-square-o" title="Выбрать все\снять выделение"></i>
			</div>
		</div>
		
		{% if statics %}
			<ul class="scroll_y h300px">
				{% for stId, stName in statics %}
					<li class="d-flex align-items-center noselect">
						<div class="checkblock mr8px text-right">
							<input type="checkbox" id="walletParamStatic{{stId}}" walletparamstatics value="{{stId}}">
							<label for="walletParamStatic{{stId}}"></label>
						</div>
						<label for="walletParamStatic{{stId}}"><small>{{stName}}</small></label>
					</li>
				{% endfor %}
			</ul>
		{% else %}
			<p class="empty">Нет статиков</p>
		{% endif %}
	</div>
	<div class="col-3">
		<div class="d-flex align-items-center justify-content-between pr10px mb10px">
			<strong class="d-block">Звания</strong>
			<div checkbutton="walletparamranks" class="h18px pointer">
				<i class="fa fa-square-o fz20px w18px" cls="fa fa-check-square-o|fa fa-square-o" title="Выбрать все\снять выделение"></i>
			</div>
		</div>
		
		{% if ranks %}
			<ul class="scroll_y h300px">
				{% for rnId, rank in ranks %}
					<li class="d-flex align-items-center noselect">
						<div class="checkblock mr8px text-right">
							<input type="checkbox" id="walletParamRank{{rnId}}" walletparamranks value="{{rnId}}">
							<label for="walletParamRank{{rnId}}"></label>
						</div>
						<label for="walletParamRank{{rnId}}"><small>{{rank.name}}</small></label>
					</li>
				{% endfor %}
			</ul>
		{% else %}
			<p class="empty">Нет статиков</p>
		{% endif %}
	</div>
	<div class="col-3">
		<div class="d-flex align-items-center justify-content-between pr10px mb10px">
			<strong class="d-block">Роли</strong>
			<div checkbutton="walletparamroles" class="h18px pointer">
				<i class="fa fa-square-o fz20px w18px" cls="fa fa-check-square-o|fa fa-square-o" title="Выбрать все\снять выделение"></i>
			</div>
		</div>
		
		{% if roles %}
			<ul class="scroll_y h300px">
				{% for rlId, role in roles %}
					<li class="d-flex align-items-center noselect">
						<div class="checkblock mr8px text-right">
							<input type="checkbox" id="walletParamRole{{rlId}}" walletparamroles value="{{rlId}}">
							<label for="walletParamRole{{rlId}}"></label>
						</div>
						<label for="walletParamRole{{rlId}}"><small>{{role.name}}</small></label>
					</li>
				{% endfor %}
			</ul>
		{% else %}
			<p class="empty">Нет статиков</p>
		{% endif %}
	</div>
	<div class="col-3">
		<strong class="d-block mb10px">Состояния</strong>
		<ul class="scroll_y h300px">
			<li class="d-flex align-items-center noselect">
				<div class="checkblock mr8px text-right">
					<input type="checkbox" id="walletParamStateVerified" walletparamstates value="verification" checked>
					<label for="walletParamStateVerified"></label>
				</div>
				<label for="walletParamStateVerified"><small>Верифицированные</small></label>
			</li>
			<li class="d-flex align-items-center noselect">
				<div class="checkblock mr8px text-right">
					<input type="checkbox" id="walletParamStateExcluded" walletparamstates value="excluded">
					<label for="walletParamStateExcluded"></label>
				</div>
				<label for="walletParamStateDeleted"><small>Отстраненные</small></label>
			</li>
			<li class="d-flex align-items-center noselect">
				<div class="checkblock mr8px text-right">
					<input type="checkbox" id="walletParamStateDeleted" walletparamstates value="deleted">
					<label for="walletParamStateDeleted"></label>
				</div>
				<label for="walletParamStateDeleted"><small>Удаленные</small></label>
			</li>
		</ul>
	</div>
</div>