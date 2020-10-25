<form class="section" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Средства платежа</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<fieldset>
		<legend>Список платежей</legend>
		
		<div class="list" id="paymentsTypesBlock">
			{% if payments_types|length > 0 %}
				{% for id in payments_types|keys %}
					<div class="list_item">
						<div>
							{% include form~'field.tpl' with {'label': 'Средство платежа', 'name': 'payments_types|'~id~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
							<div class="buttons right ml-auto">
								<button class="remove remove_payments_type" data-id="{{id}}">Удалить средство платежа</button>
							</div>
						</div>
					</div>
				{% endfor %}
			{% else %}
				<p class="empty">Нет данных</p>
			{% endif %}	
		</div>
		
		<div class="buttons">
			<button class="large" id="paymentsTypesAdd">Добавить средство платежа</button>
		</div>
		
	</fieldset>
	
</form>






<script type="text/javascript"><!--
$(document).ready(function() {
	
});
//--></script>