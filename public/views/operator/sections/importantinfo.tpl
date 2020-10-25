<div class="section" id="importantinfoSection">
	<div class="section__title">
		<h1>Важная информация</h1>
	</div>
	
	<div class="section__buttons" id="sectionButtons">
		<button id="importantinfoSave" title="Сохранить настройки"><i class="fa fa-save"></i></button>
	</div>
	
	<div class="section__content" id="sectionContent">
		<div>
			<form id="importantinfoForm">
				<ul class="tabstitles">
					<li id="importantInfo1" class="active">{{important_info_setting[0]['title']|default('Раздел 1')}}</li>
					<li id="importantInfo2">{{important_info_setting[1]['title']|default('Раздел 2')}}</li>
					<li id="importantInfo3">{{important_info_setting[2]['title']|default('Раздел 3')}}</li>
					<li id="importantInfo4">{{important_info_setting[3]['title']|default('Раздел 4')}}</li>
					<li id="importantInfo5">{{important_info_setting[4]['title']|default('Раздел 5')}}</li>
					<li id="importantInfo6">{{important_info_setting[5]['title']|default('Раздел 6')}}</li>
					<li id="importantInfo7">{{important_info_setting[6]['title']|default('Раздел 7')}}</li>
					<li id="importantInfo8">{{important_info_setting[7]['title']|default('Раздел 8')}}</li>
				</ul>
				
				<div class="tabscontent">
					{% for i in 0..7 %}
						<div tabid="importantInfo{{i+1}}">
							<input type="text" name="important_info_setting[{{i}}][title]" value="{{important_info_setting[i]['title']}}">
							<textarea name="important_info_setting[{{i}}][data]" editor="importantinfo{{i}}" id="" cols="30" rows="10">{{important_info_setting[i]['data']}}</textarea>
							<label for="">Вкл</label>
							<input type="radio"{% if important_info_setting[i]['stat'] == 1 %} checked{% endif %} name="important_info_setting[{{i}}][stat]" value="1">
							<label for="">Выкл</label>
							<input type="radio"{% if important_info_setting[i]['stat'] == 0 %} checked{% endif %} name="important_info_setting[{{i}}][stat]" value="0">
						</div>
					{% endfor %}
				</div>		
			</form>
		</div>
	</div>
</div>




<script type="text/javascript"><!--
$(document).ready(function() {
	
	$('body').off(tapEvent, '#importantinfoSave').on(tapEvent, '#importantinfoSave', function() {
		var commonFormData = new FormData($('#importantinfoForm')[0]);
		$.ajax({
			type: 'POST',
			url: '/admin/save_settings',
			dataType: 'json',
			cache: false,
			contentType: false,
			processData: false,
			data: commonFormData,
			success: function(response) {
				if (response) notify('Настройки сохранены!');
				else notify('Ошибка сохранения данных', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
			}
		});
	});
	
	initEditors($('[tabid]:visible').find('[editor]'));
	
	onChangeTabs(function(thisItemTitle, thisItemContent) {
		initEditors($(thisItemContent).find('[editor]'));
	});
	
	
	
	
});
//--></script>