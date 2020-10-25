<div class="list_item">
	<div>
		{% include form~'field.tpl' with {'label': 'Название ранга', 'name': 'access_levels|new_'~index~'|name', 'placeholder': 'Название', 'postfix': 0, 'class': 'w20', 'inline': 1} %}
	</div>
</div>