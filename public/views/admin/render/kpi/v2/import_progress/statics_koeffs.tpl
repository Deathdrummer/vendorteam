<table class="popup__table">
	<thead>
		<tr class="h32px">
			<td><strong>Статик</strong></td>
			<td class="w80px"><strong>Коэфф.</strong></td>
		</tr>
	</thead>
	<tbody>
		{% if statics %}
			{% for stId, static in statics %}
				<tr>
					<td>
						<div class="d-flex align-items-center">
							<img src="{{base_url('public/filemanager/thumbs/'~static.icon)|no_file('public/images/deleted_mini.jpg')}}" alt="{{static.name}}" class="avatar h40px w40px">
							<p class="ml4px fz12px">{{static.name}}</p>
						</div>
					</td>
					<td class="center">
						<div class="field w60px">
							<input type="number" min="0" kpiv2periodstatics="{{stId}}" value="{{koeffs[stId]|default(0)}}" showrows>
						</div>
					</td>
				</tr>
			{% endfor %}
		{% endif %}
	</tbody>
</table>