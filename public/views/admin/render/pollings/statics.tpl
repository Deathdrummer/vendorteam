{% if statics %}
	<table id="pollingsStaticsTable">
		<thead>
			<tr>
				<td><strong>Статик</strong></td>
				<td class="w50px center"><i class="fa fa-check-square fz18px" id="pollingsStaticsChoodeAll"></i></td>
			</tr>
		</thead>
		<tbody>
			{% for stId, static in statics %}
				<tr>
					<td>
						<div class="d-flex align-items-center">
							<img src="{{base_url('public/filemanager/thumbs/'~static.icon)}}" alt="{{static.name}}" class="avatar w40px h40px mr5px">
							<p>{{static.name}}</p>
						</div>
					</td>
					<td class="center">
						<div class="checkblock">
							<input type="checkbox" id="pollingsStatics{{stId}}" pollingsstatic="{{stId}}"{% if stId in choosed_statics %} checked{% endif %}>
							<label for="pollingsStatics{{stId}}"></label>
						</div>
					</td>
				</tr>
			{% endfor %}
		</tbody>
	</table>
{% endif %}