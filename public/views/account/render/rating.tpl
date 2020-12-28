<ul class="tabstitles">
	<li id="tabRating" class="active"><p>Рейтинг</p></li>
	<li id="tabDesc"><p>Как рассчитывается</p></li>
</ul>


<div class="tabscontent">
	<div tabid="tabRating" class="visible">
		{% if rating %}
			<h1 class="text-center">{{rating}} <small>{{rating|padej(['балл', 'балла', 'баллов'])}}</small></h1>
			
			<table>
				<tr>
					<td>Активность:</td>
					<td><strong>{{activity}}</strong> <small>{{activity|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
				<tr>
					<td>Личный скилл:</td>
					<td><strong>{{skill}}</strong> <small>{{skill|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
				<tr>
					<td>Штрафы:</td>
					<td><strong>{{fine}}</strong> <small>{{fine|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
				<tr>
					<td>Коэффициент посещений:</td>
					<td><strong>{{visits}}</strong><small>{{visits|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
				<tr>
					<td>Выговоры:</td>
					<td><strong>{{reprimands}}</strong> <small>{{reprimands|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
				<tr>
					<td>Форс мажор:</td>
					<td><strong>{{forcemajeure}}</strong> <small>{{forcemajeure|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
				<tr>
					<td>Наставники:</td>
					<td><strong>{{stimulations}}</strong><small>{{stimulations|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
				<tr>
					<td>Стимулирование:</td>
					<td><strong>{{mentors}}</strong> <small>{{mentors|padej(['балл', 'балла', 'баллов'])}}</small></td>
				</tr>
			</table>
		{% else %}
			<h1 class="text-center"><small>Нет рейтинга</small></h1>
		{% endif %}
	</div>
	
	<div tabid="tabDesc">
		{{rating_desc|raw}}
	</div>
</div>		