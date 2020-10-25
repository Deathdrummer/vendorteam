<form id="chapterForm">
	
	
	{% if id %} <input type="hidden" name="id" value="{{id}}">{% endif %}
	
	<label for="">Название</label>
	<input type="text" name="title"{% if title %} value="{{title}}"{% endif %} placeholder="Название">
	
	<label for="">Родительская Статья</label>
	<select name="parent_id" id="">
		<option value="0">Нет</option>
		{% for first in chapters %}
			<option value="{{first.id}}"{% if parent_id is defined and first.id == parent_id %} selected{% endif %}>{{first.title}}</option>
			{% if first.children %}
				{% for second in first.children %}
					<option value="{{second.id}}"{% if parent_id is defined and second.id == parent_id %} selected{% endif %}>&nbsp;{{second.title}}</option>
					{% if second.children %}
						{% for third in second.children %}
							<option value="{{third.id}}"{% if parent_id is defined and third.id == parent_id %} selected{% endif %}>&nbsp;&nbsp;{{third.title}}</option>
						{% endfor %}
					{% endif %}
				{% endfor %}
			{% endif %}
		{% endfor %}
	</select>
	
	<label for="">Порядок сортировки</label>
	<input type="number" name="sort"{% if sort %} value="{{sort}}"{% endif %} placeholder="Порядок сортировки">
	<br><br>
	<label for="">Контент</label>
	<textarea name="content" editor="newChapter{{rand(0,999)}}">{% if content %}{{content}}{% endif %}</textarea>
</form>