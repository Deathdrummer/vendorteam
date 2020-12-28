<input type="hidden" id="stimulationUserId" value="{{user_id}}">
<div class="mb20px">
	<span>Коэффициент:</span>
	<div class="popup__select w100px">
		<select id="stimulationIndex">
			{% for i in 0..5 %}
				<option{% if index == i %} selected{% endif %} value="{{i}}">{{i}}</option>
			{% endfor %}
		</select>
		<div class="popup__select__caret"></div>
	</div>
</div>
	
<div>
	<span>Причина:</span>
	<div class="popup__textarea">
		<textarea id="stimulationMess" rows="5" resizey>{{message}}</textarea>
	</div>
</div>