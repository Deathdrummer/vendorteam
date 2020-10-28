<div class="section" id="mainSection">
	<div class="section__title">
		<h1>Главная страница</h1>
	</div>
	
	
	
	{#{% include 'views/operator/render/block.tpl' with {
		'items': [
			{'component': 'field', 'data': {'foo': 'bar1'}},
			{'component': 'color', 'data': {'foo': 'bar2'}},
			{'component': 'radio', 'data': {'foo': 'bar2'}}
		]
	} %}#}
	
	
	
	{#<div class="section__buttons" id="sectionButtons">
			
	</div>
	
	<div class="section__content" id="sectionContent">
		
	</div>#}
</div>