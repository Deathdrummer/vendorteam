<div class="usersv2buttons mb30px" id="usersv2StaticsGroups">
	<button usersv2groupbtn="none">Нет</button>
	<button usersv2groupbtn="all">Все</button>
	<button usersv2groupbtn="1">Рейды</button>
	<button usersv2groupbtn="2">Группа</button>
	<button usersv2groupbtn="3">Инактив</button>
</div>



{% if statics %}
	<div class="usersv2statics" id="usersv2StaticsList">
		<div class="row gutters-5">
			{% for staticsPart in statics|chunktoparts(3, true) %}
				<div class="col-4">
					{% for stId, static in staticsPart %}
						<div class="usersv2statics__item">
							<input type="checkbox" id="usersStati{{stId}}" usersv2static="{{stId}}" usersv2staticgroup="{{static.group}}"{% if static.checked %} checked{% endif %}>
							<label for="usersStati{{stId}}">
								<div class="d-flex align-items-center">
									<img src="{{base_url('public/filemanager/thumbs/'~static.icon)|no_file('public/images/deleted_mini.jpg')}}" alt="{{static.name}}" class="avatar w40px h40px">
									<span class="fz12px ml4px fontcolor">{{static.name}}</span>
								</div>
							</label>
						</div>
					{% endfor %}
				</div>
			{% endfor %}
		</div>	
	</div>
{% else %}
	<p class="empty center">Нет статиков</p>
{% endif %}