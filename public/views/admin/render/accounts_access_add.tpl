<div class="list_item">
	<div>
		<div class="row">
			<div class="col-auto">
				{% include form~'field.tpl' with {'label': 'Название', 'name': 'accounts_access|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w300px', 'inline': 1} %}
			</div>
			<div class="col-auto">
				<strong>Меню</strong>
				<div><label for="nav_new_{{index}}_1"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][guides]" value="1" id="nav_new_{{index}}_1"> Образование</label></div>
				<div><label for="nav_new_{{index}}_2"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][timesheet]" value="1" id="nav_new_{{index}}_2"> Расписание</label></div>
				<div><label for="nav_new_{{index}}_3"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][wallet]" value="1" id="nav_new_{{index}}_3"> Выплаты</label></div>
				<div><label for="nav_new_{{index}}_4"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][information]" value="1" id="nav_new_{{index}}_4"> Важная информация</label></div>
				<div><label for="nav_new_{{index}}_5"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][operators]" value="1" id="nav_new_{{index}}_5"> Операторы</label></div>
				<div><label for="nav_new_{{index}}_6"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][offtime]" value="1" id="nav_new_{{index}}_6"> Выходные</label></div>
				<div><label for="nav_new_{{index}}_7"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][vacation]" value="1" id="nav_new_{{index}}_7"> Отпуск</label></div>
				<div><label for="nav_new_{{index}}_8"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][personages]" value="1" id="nav_new_{{index}}_8"> Мои персонажи</label></div>
				<div><label for="nav_new_{{index}}_9"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][paymentorders]" value="1" id="nav_new_{{index}}_9"> Мои заявки</label></div>
				<div><label for="nav_new_{{index}}_10"><input type="checkbox" name="accounts_access[new_{{index}}][access][nav][visitsrate]" value="1" id="nav_new_{{index}}_10"> Моя посещаемость</label></div>
			</div>
			
			<div class="col-auto">
				<strong>Нижнее меню</strong>
				<div><label for="navdown_new_{{index}}_1"><input type="checkbox" name="accounts_access[new_{{index}}][access][navdown][skype]" value="1" id="navdown_new_{{index}}_1"> Ссылка скайп</label></div>
				<div><label for="navdown_new_{{index}}_2"><input type="checkbox" name="accounts_access[new_{{index}}][access][navdown][complaints]" value="1" id="navdown_new_{{index}}_2"> Заказ оплаты</label></div>
				<div><label for="navdown_new_{{index}}_3"><input type="checkbox" name="accounts_access[new_{{index}}][access][navdown][message]" value="1" id="navdown_new_{{index}}_3"> Форма для обращений</label></div>
			</div>
			
			<div class="col-auto">
				<strong>Контент</strong>
				<div><label for="content_new_{{index}}_1"><input type="checkbox" name="accounts_access[new_{{index}}][access][content][compound]" value="1" id="content_new_{{index}}_1"> Состав команды</label></div>
				<div><label for="content_new_{{index}}_2"><input type="checkbox" name="accounts_access[new_{{index}}][access][content][news]" value="1" id="content_new_{{index}}_2"> Новости</label></div>
			</div>
			
			<div class="col-auto">
				<strong>Ссылки</strong>
				<div><label for="links_new_{{index}}_1"><input type="checkbox" name="accounts_access[new_{{index}}][access][links][paydata]" value="1" id="links_new_{{index}}_1"> Платежные данные</label></div>
				<div><label for="links_new_{{index}}_2"><input type="checkbox" name="accounts_access[new_{{index}}][access][links][mentors]" value="1" id="links_new_{{index}}_2"> Наставники</label></div>
			</div>
		</div>
	</div>
</div>