<form id="chapterForm" autocomplete="off">
	<div class="popup__data">
		<div class="guideschapter">
			{% if id %} <input type="hidden" name="id" value="{{id}}">{% endif %}
			<div class="popup__form_item">
				<div class="popup__field">
					<label class="popup__label">Название</label>
					<input type="text" name="title"{% if title %} value="{{title}}"{% endif %} placeholder="Название">
				</div>
			</div>
			
			<div class="popup__form_item">
				<div class="popup__field">
					<label class="popup__label">Родительская Статья</label>
					<div class="popup__select">
						<select name="parent_id">
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
					</div>
				</div>
			</div>
			
			<div class="popup__form_item">
				<div class="popup__field popup__field_number">
					<label class="popup__label">Порядок сортировки</label>
					<input type="number" showrows name="sort" value="{% if sort %}{{sort}}{% else %}0{% endif %}" placeholder="Порядок сортировки">
				</div>
			</div>
			
			<div class="popup__form_item">
				<div class="popup__textarea popup__textarea_long">
					<label class="popup__label">Контент</label>
					<textarea name="content" editor="guidesUpdateChapter{{id}}">{% if content %}{{content}}{% endif %}</textarea>
				</div>
			</div>
		</div>
	</div>
</form>