<table>
	<thead>
		<tr>
			<td>Название</td>
			<td>Платежные периоды</td>
			<td class="nowidth" title="Показать период в личном кабинете">Показ.</td>
			<td class="w156px"></td>
		</tr>
	</thead>
	<tbody>
		{% if rewards_periods %}
			{% for period in rewards_periods %}
				<tr>
					<td rewardperiodtitle>{{period.title}}</td>
					<td>
						{% if period.reports_periods %}
							<ul>
								{% for p in period.reports_periods %}
									<li>{{p}}</li>
								{% endfor %}
							</ul>
						{% else %}
							<p class="empty">Нет данных</p>
						{% endif %}
					</td>
					<td class="center top pt-2">
						<div class="checkblock" title="Показать период в личном кабинете">
							<input id="showperiod{{period.id}}" showperiod="{{period.id}}"{% if period.stat %} checked{% endif %} type="checkbox">
							<label for="showperiod{{period.id}}"></label>
						</div>
					</td>
					<td class="top pt-2">
						<div class="buttons">
							<button rewardsperiodedit="{{period.id}}" title="Редактировать период" periodtitle="{{period.title}}"><i class="fa fa-edit"></i></button>
							<button class="pay" rewardssetstaticssumm="{{period.id}}" title="Задать бюджет статиков" periodtitle="{{period.title}}"><i class="fa fa-money"></i></button>
							<button class="alt" rewardsbuildreport="{{period.id}}" title="Задать бюджет статиков" periodtitle="{{period.title}}"><i class="fa fa-bar-chart"></i></button>
							<a class="button alt ml-1" target="_self" href="{{base_url('admin/rewards/export/'~period.id)}}" download="Премиальные выплаты ({{period.title}}).csv" title="Экспортировать отчет"><i class="fa fa-download"></i></a>
						</div>
					</td>
				</tr>
			{% endfor %}
		{% else %}
			<tr>
				<td colspan="6"><p class="empty center red">Нет данных</p></td>
			</tr>
		{% endif %}
	</tbody>
</table>		