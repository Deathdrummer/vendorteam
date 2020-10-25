
<div class="row">
	{% if text %}
		<div class="col-12 mb-5">{{text|raw}}</div>
	{% endif %}
	
	<div class="col-12{% if image %} col-md-7{% endif %}">
		<div class="popup__title mb-0">
			<div class="image">
				<img src="public/filemanager/{{static.icon}}" alt="">
				{#<img src="{{base_url('public/filemanager/'~item.static_icon)}}" class="image" alt="">#}
			</div>
			<h6>{{static.name}}</h6>
		</div>
		
		{% if statistics %}
			<table class="popup__table mb-5">
				<thead>
					<tr>
						<td>Участник</td>
						<td>Среднемесячная зарплата</td>
					</tr>
				</thead>
				<tbody>
					{% for row in ['self', 'lider', 'customer'] %}
						{% if statistics[row] %}
							<tr>
								<td>
									{% if statistics[row]['avatar'] %}
										<img src="{{base_url('public/images/users/mini/'~statistics[row]['avatar'])}}" class="image" alt="{{statistics[row]['nickname']}}" title="{{statistics[row]['nickname']}}">
									{% else %}
										<img src="public/images/user_mini.jpg" alt="{{statistics[row]['nickname']}}" class="image" title="{{statistics[row]['nickname']}}">	
									{% endif %}
									<span class="ml-1">{{statistics[row]['nickname']}}</span>	
								</td>
								<td>
									{% if statistics[row]['pay'] %}
										{{statistics[row]['pay']|number_format(2, '.', ' ')}} руб.
									{% else %}
										<p class="empty">Нет данных</p>
									{% endif %}	
								</td>
							</tr>
						{% endif %}	
					{% endfor %}
				</tbody>	
			</table>
		{% else %}
			<p class="empty">Нет данных</p>
		{% endif %}
	</div>
	{% if image %}
		<div class="col-12 col-md-5">
			<img class="respimage" src="public/filemanager/{{image}}" alt="Нет картинки">
		</div>
	{% endif %}
</div>