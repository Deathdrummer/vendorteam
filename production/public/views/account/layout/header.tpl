<header class="header operator" id="header"> <!-- шапка только для оператора -->
	<div class="header__item">
		<p>Vendorteam</p>
	</div>
	
	{#<div class="header__item ml-5">
		<div class="buttons">
			{% for id, item in data_access %}
				{% if id in access %}
					<button id="{{item.id}}" title="{{item.title}}"><i class="fa fa-{{item.icon|default('bars')}}"></i></button>
				{% endif %}
			{% endfor %}
		</div>
	</div>#}
	
	<div class="header__item ml-auto">
		<div class="buttons right">
			<button id="operatorLogout" title="Выйти из кабинета оператора"><i class="fa fa-sign-out"></i></button>
		</div>
	</div>
</header>
	