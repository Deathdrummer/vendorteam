<table>	
	<tr>
		<td><label for="imageWidthField">ширина</label></td>
		<td class="w40 nowrap right">
			<div class="number">
				<input type="number" id="imageWidthField" showrows min="0" step="100" autocomplete="off" value="{{width|default('0')}}">
				<span> пикс.</span>
			</div>
		</td>
	</tr>
	<tr>
		<td><label for="imageHeightField">высота</label></td>
		<td class="w40 nowrap right">
			<div class="number">
				<input type="number" id="imageHeightField" showrows min="0" step="100" autocomplete="off" value="{{height|default('0')}}">
				<span> пикс.</span>
			</div>
		</td>
	</tr>
</table>