<div class="mb20px">
	<span class="d-block">Дата:</span>
	<div class="popup__field popup__field_date w273px">
		<input type="text" name="date" autocomplete="off"{% if date %} value="{{date|d}}"{% endif %} autocomplete="off" id="reprimandsDate"{% if date %} date="{{date('Y-m-d', date)}}"{% endif %}>
	</div>
</div>	

<div>
	<span>Причина:</span>
	<div class="popup__textarea">
		<textarea id="reprimandsMess" rows="5" resizey>{% if message %}{{message|raw}}{% endif %}</textarea>
	</div>
</div>