{% set inpName, id, value = '', '', '' %}
{% set pf = postfix|postfix_setting %}

{% for k, item in name|split('|') %}
	{% if k == 0 %}
		{% set inpName = item~pf %}
		{% set value = attribute(_context, item~pf) %}
		{% set id = item~pf %}
	{% else %}
		{% set inpName = inpName~'['~item~']' %}
		{% set value = value[item] %}
		{% set id = id~item %}
	{% endif %}
{% endfor %}


<div class="item{% if inline %} inline{% endif %}">
	<div class="file">
		<label for="{{id}}"><span>{{label}}</span></label>
		<div>
			<label for="{{id}}" filemanager="{{ext}}">
				<div class="image">
					{% if value %}
						{% if value|filename(2)|is_img_file %}
							<img src="{{base_url()}}public/filemanager/{{value|freshfile}}" alt="{{value}}">
						{% else %}
							<img src="{{base_url()}}public/images/filetypes/{{value|filename(2)}}.png" alt="{{value}}">
						{% endif %}
					{% else %}
						<img src="{{base_url()}}public/images/none.png" alt="">
					{% endif %}
				</div>
			</label>
			<div>
				<span class="image_name">{% if value %}{{value|filename}}{% else %}нет файла{% endif %}</span>
				<button class="remove filemanager_remove" title="Удалить"><i class="fa fa-trash"></i></button>
			</div>
		</div>
		<input type="hidden" name="{{inpName}}" id="{{id}}" value="{{value}}" />
	</div>
</div>