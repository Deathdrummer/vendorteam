<tr>
	<td class="center">
		{% if item.type in [1,2] %}
			<img src="{{base_url('public/images/users/mini/'~item.icon)|no_file('public/images/deleted_mini.jpg')}}" class="avatar w50px h50px" alt="{{item.icon}}">
		{% else %}
			<img src="{{base_url('public/filemanager/'~item.icon)|no_file('public/images/deleted_mini.jpg')}}" class="avatar w50px h50px" alt="{{item.icon}}">
		{% endif %}
	</td>
	<td class="texttop"><small>{{item.text}}</small></td>
	<td>
	  	{% if item.statics %}
	  		<ul class="scroll_y scroll_y_thin h50px">
	  			{% for static in item.statics %}
	  				<li>
	  					<small>{{statics[static]['name']}}</small>
	  				</li>
	  			{% endfor %}
	  		</ul>
	  	{% endif %}
		
	</td>
	<td>{{item.date|d}} в {{item.date|t}}</td>
	<td class="center">
		<div class="buttons inline">
			<button class="small w30px" mininewsfeedupdate="{{item.id}}"><i class="fa fa-edit"></i></button>
			<button class="small w30px remove" mininewsfeedremove="{{item.id}}"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>