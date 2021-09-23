<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>История действий администраторов</h2>
	</div>
	
	
	<table id="adminsHistoryTable">
		<thead>
			<tr class="h40px">
				<td class="w250px"><strong>Администратор</strong></td>
				<td><strong>Операция</strong></td>
				<td class="w250px"><strong>Дата</strong></td>
				<td class="w60px"></td>
			</tr>
		</thead>
		<tbody id="adminsHistoryList">
			<tr>
				<td colspan="3">
					<p class="empty center"><i class="fa fa-spinner fa-pulse fa-fw"></i> Загрузка...</p>
				</td>
			</tr>
		</tbody>
	</table>	
</div>





<script type="text/javascript"><!--
	getAjaxHtml('admin/adminsactions/all', function(html, stat) {
		if (stat) {
			$('#adminsHistoryList').html(html);
			$('#adminsHistoryTable').ddrScrollTableY({height: 'calc(100vh - 200px)', offset: 1});
		} else {
			$('#adminsHistoryList').html('<tr><td colspan="4"><p class="empty center">Нет данных</p></td></tr>');
		}
		
		
		$('[adminsactionsmore]').on(tapEvent, function() {
			let id = $(this).attr('adminsactionsmore'),
				title = $(this).closest('tr').find('[adminsactionstype]').text(),
				from = $(this).closest('tr').find('[adminsactionsfrom]').text(),
				date = $(this).closest('tr').find('[adminsactionsdate]').text();
			
			popUp({
				title: title+'|4',
				width: 700,
				closeButton: 'Закрыть'
			}, function(adminsActionsWin) {
				adminsActionsWin.setData('admin/adminsactions/info', {id: id, from: from, date: date});
			});
		});
		
		
		
		
		
	}, function() {
		
	});
//--></script>