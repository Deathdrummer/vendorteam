{% if statics %}
	<h4>Выберите статики</h4>
	<div id="staticsAmountList">
		<table>
			<thead>
				<tr>
					<td>Статик</td>
					<td class="center"><i class="fa fa-check-square fa-2x" id="staticsAmountSetAll"></i></td>
				</tr>
			</thead>
			<tbody>
				{% for stId, static in statics %}
					<tr>
						<td>
							<div class="d-flex align-items-center">
								<div class="avatar mini mr-2" style="background-image: url('{{base_url('public/filemanager/thumbs/'~static.icon)}}')"></div>
								<p>{{static.name}}</p>
							</div>
						</td>
						<td class="nowidth center">
							<div class="checkblock">
								<input id="staticsAmount{{stId}}" type="checkbox" value="{{stId}}">
								<label for="staticsAmount{{stId}}"></label>
							</div>
						</td>
					</tr>
				{% endfor %}
			</tbody>
		</table>
	</div>
		
{% endif %}