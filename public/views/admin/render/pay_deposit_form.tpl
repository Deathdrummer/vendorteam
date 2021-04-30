<div class="resign">
	<div class="row">
		<div class="col-6">
			<div class="resign__avatar">
				<img src="{{base_url('public/images/users/'~resign.avatar)}}" alt="">
			</div>
		</div>
		<div class="col-6">
			<h3 class="resign__name">{{resign.nickname}}</h3>	
			
			<div class="resign__static">
				<div style="background-image: url('{{base_url('public/filemanager/'~resign.static.icon)}}')"></div>
				<p>{{resign.static.name}}</p>
			</div>
			
			<ul class="resign__info">
				<li><strong>Назначенная дата увольнения</strong>{{resign.date_resign|d}}</li>
				<li><strong>Последний рабочий день</strong>{{resign.date_last|d}}</li>
				<li class="large"><strong>Резерв</strong><h3 >{{resign.deposit|number_format(2, '.', ' ')}} <small>₽</small></h3></li>
				
				{% if resign.deposit > 0 %}
					<li>
						<strong>Процент от суммы выплаты</strong>
						<div class="popup__select">
							<select id="chengeSummPercent">
								{% for percent in [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100] %}
									<option value="{{resign.deposit / 100 * percent}}"{% if percent == 100 %} selected{% endif %}>{{percent}}%</option>
								{% endfor %}
							</select>
							<div class="popup__select__caret"></div>
						</div>
					</li>	
				{% endif %}
			</ul>
		</div>
		
		{% if resign.deposit > 0 %}
			<div class="col mt40px">
				<input type="hidden" id="confirmResignUser" value="{{resign.user_id}}">	
				<div class="resign__textblock mt20px">
					<h4>Итоговая суммы выплаты</h4>
					<div class="d-flex align-items-end">
						<div class="popup__field w230px">
							<input type="hidden" id="confirmResignFullSumm" value="{{resign.deposit}}">
							<input type="number" showrows id="confirmResignSumm" value="{{resign.deposit}}">
						</div>
						<strong class="ml-2">₽</strong>
						<span class="ml40px">На баланс уйдет: <strong id="confirmResignBalance">0</strong> <small>₽</small></span>
					</div>
				</div>
				<div class="resign__textblock mt20px">
					<h4>Номер заказа</h4>
					<div class="popup__field w230px">
						<input type="text" id="confirmResignOrder">
					</div>
				</div>
				<div class="resign__textblock mt20px">
					<h4>Комментарий</h4>
					<div class="popup__textarea">
						<textarea rows="5" id="confirmResignComment"></textarea>
					</div>
				</div>
				<div class="resign__textblock mt20px resign__textblock_hidden">
					<h4>Комментарий по удержанию в баланс</h4>
					<div class="popup__textarea">
						<textarea rows="5" id="confirmResignCommentToBalance"></textarea>
					</div>
				</div>
			</div>
		{% endif %}
	</div>
</div>