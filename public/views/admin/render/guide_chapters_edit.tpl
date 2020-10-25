<form id="guideChapterEditForm">
	<input type="hidden" name="id" value="{{id}}">
	
	
	{% include 'admin/views/form/textarea.tpl' with {'label': 'Контент', 'name': 'content', 'editor': 'editChapter'~rand(0,999), 'postfix': 0} %}
	
	<div class="buttons">
		<button id="guideChapterContentSave">Сохранить</button>
	</div>
</form>