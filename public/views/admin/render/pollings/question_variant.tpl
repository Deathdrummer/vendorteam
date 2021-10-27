<tr pollingquestionvariant="{{id}}">
	<td class="center graggable"><i class="fa fa-ellipsis-v grayblue fz14px"></i></td>
	<td class="center graggable">
		<strong pollingsvariantindex></strong>
	</td>
	<td pollingquestionvariantsnohandle>
		<div class="textarea textarea_vertical">
			<textarea pollingvariantcontent rows="3" class="pt2px pb2px fz12px">{{content}}</textarea>
		</div>
	</td>
	<td pollingquestionvariantsnohandle>
		<div class="field">
			<input type="number" min="0" max="100" pollingvariantscores showrows placeholder="0" value="{{scores}}">
		</div>
	</td>
	<td class="center" pollingquestionvariantsnohandle>
		<div class="buttons notop inline">
			<button class="h20px w26px pl0px pr0px remove" pollingquestionvariantremove title="Удалить вариант"><i class="fa fa-trash fz11px"></i></button>
		</div>
	</td>
</tr>