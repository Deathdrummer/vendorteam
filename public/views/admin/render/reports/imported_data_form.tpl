{% if import_data %}
	<div id="importPaymentRequestsContainer">
		<div class="mb10px text-right">
			<button id="importPaymentRequestsMassOrder" class="simplebutton h30px alt2" title="Общий номер заказа"><i class="fa fa-fax"></i></button>
			<button id="importPaymentRequestsMassComment" class="simplebutton h30px alt2" title="Общий комментарий"><i class="fa fa-commenting-o"></i></button>
		</div>
		
		<ul class="tabstitles sub">
			{% for staticId in import_data|keys %}
				<li id="importpaymentrequestsTab{{staticId}}">
					<img src="{{base_url('public/filemanager/thumbs/'~statics[staticId]['icon'])|no_file('public/images/deleted_mini.jpg')}}" alt="" class="avatar w26px h26px">
					<strong class="ml3px fz12px d-block">{{statics[staticId]['name']}}</strong>
				</li>
			{% endfor %}
		</ul>
		
		
		<div class="tabscontent" id="importPaymentRequestsContent">
			{% for staticId, items in import_data %}
				<div tabid="importpaymentrequestsTab{{staticId}}">
					<table>
						<thead>
							<tr>
								<td class="w200px">Участник</td>
								<td class="w200px">Способ оплаты</td>
								<td class="w200px">№ заказа</td>
								<td class="w120px">Сумма заказа</td>
								<td>Комментарий</td>
								<td class="w60px">Опции</td>
							</tr>
						</thead>
						<tbody>
							{% for row in items %}
								{% if staticId != 'not_exist' %}
									<tr>
										<td>
											<input type="hidden" name="imported_orders[{{row.id}}][user_id]" value="{{row.id}}">
											<input type="hidden" name="imported_orders[{{row.id}}][nickname]" value="{{row.booster}}">
											<input type="hidden" name="imported_orders[{{row.id}}][avatar]" value="{{row.avatar}}">
											<input type="hidden" name="imported_orders[{{row.id}}][payment]" value="{{row.payment}}">
											<input type="hidden" name="imported_orders[{{row.id}}][static]" value="{{staticId}}">
											
											<div class="d-flex align-items-center">
												<img src="{{base_url('public/images/users/mini/'~row.avatar)|no_file('public/images/user_mini.jpg')}}" alt="" class="avatar w40px h40px">
												<div class="ml3px">
													<strong class="fz14px d-block">{{row.booster}}</strong>
													<p class="fz12px mt4px grayblue">{{ranks[row.rank]['name']}}</p>
												</div>
											</div>
										</td>
										<td><p class="fz14px">{{row.payment}}</p></td>
										<td>
											<div class="field">
												<input type="text" name="imported_orders[{{row.id}}][order]" importedordersorder value="{{row.order}}">
											</div>
										</td>
										<td>
											<div class="d-flex align-items-end">
												<div class="field w100px">
													<input type="text" name="imported_orders[{{row.id}}][summ]" importedorderssumm value="{{row.summ}}">
												</div>
												<strong class="fz13px ml3px pb2px">₽</strong>
											</div>
										</td>
										<td>
											<div class="textarea">
												<textarea name="imported_orders[{{row.id}}][comment]" importedorderscomment rows="3">{{row.comment}}</textarea>
											</div>
										</td>
										<td class="center">
											<div class="buttons notop inline">
												<button class="small remove w30px" importedordersremoverow title="Удалить запись"><i class="fa fa-trash"></i></button>
											</div>
										</td>
									</tr>
								{% else %}
									<tr>
										<td>
											<div class="d-flex align-items-center">
												<img src="{{base_url('public/images/deleted_mini.jpg')}}" alt="Отсутствует в базе" class="avatar w40px h40px">
												<div class="ml3px">
													<strong class="fz14px d-block">{{row.booster}}</strong>
													<p class="fz12px mt4px red">Отсутствует в базе</p>
												</div>
											</div>
										</td>
										<td><p class="fz14px">-</p></td>
										<td><p class="fz14px">-</p></td>
										<td><p class="fz14px">-</p></td>
										<td><p class="fz14px">-</p></td>
										<td class="center"><p class="fz14px">-</p></td>
									</tr>
								{% endif %}
							{% endfor %}
						</tbody>
					</table>
				</div>
			{% endfor %}
		</div>
	</div>
{% else %}
	<p class="empty">Нет данных</p>
{% endif %}