<div class="list_item">
	<div>
		<div class="row">
			<div class="col-auto">
				{% include form~'field.tpl' with {'label': 'Название', 'name': 'accounts_access|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w300px', 'inline': 1} %}
			</div>
			<div class="col-auto">
				<strong>Меню</strong>
				<div><label for="nav1"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][guides]" value="1" id="nav1"> Образование</label></div>
				<div><label for="nav2"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][timesheet]" value="1" id="nav2"> Расписание</label></div>
				<div><label for="nav3"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][wallet]" value="1" id="nav3"> Выплаты</label></div>
				<div><label for="nav4"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][information]" value="1" id="nav4"> Важная информация</label></div>
				<div><label for="nav5"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][operators]" value="1" id="nav5"> Операторы</label></div>
				<div><label for="nav6"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][offtime]" value="1" id="nav6"> Выходные</label></div>
				<div><label for="nav7"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][vacation]" value="1" id="nav7"> Отпуск</label></div>
				<div><label for="nav8"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][personages]" value="1" id="nav8"> Мои персонажи</label></div>
				<div><label for="nav9"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][paymentorders]" value="1" id="nav9"> Мои заявки</label></div>
			</div>
			
			<div class="col-auto">
				<strong>Нижнее меню</strong>
				<div><label for="navdown1"><input type="checkbox" name="accounts_access[new_{{index}}][access][navdown][skype]" value="1" id="navdown1"> Ссылка скайп</label></div>
				<div><label for="navdown2"><input type="checkbox" name="accounts_access[new_{{index}}][access][navdown][complaints]" value="1" id="navdown2"> Заказ оплаты</label></div>
				<div><label for="navdown3"><input type="checkbox" name="accounts_access[new_{{index}}][access][navdown][message]" value="1" id="navdown3"> Форма для обращений</label></div>
			</div>
			
			<div class="col-auto">
				<strong>Контент</strong>
				<div><label for="content1"><input type="checkbox" name="accounts_access[new_{{index}}][access][content][compound]" value="1" id="content1"> Состав команды</label></div>
				<div><label for="content2"><input type="checkbox" name="accounts_access[new_{{index}}][access][content][news]" value="1" id="content2"> Новости</label></div>
			</div>
			
			<div class="col-auto">
				<strong>Ссылки</strong>
				<div><label for="links1"><input type="checkbox" name="accounts_access[new_{{index}}][access][links][paydata]" value="1" id="links1"> Платежные данные</label></div>
			</div>
		</div>
	</div>
</div>