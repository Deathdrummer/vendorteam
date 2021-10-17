<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>История действий администраторов</h2>
	</div>
	
	
	<div class="row gutters-6 align-items-center mb-3">
		<div class="col-auto mr20px">
			<div class="row gutters-5">
				<div class="col">
					<p class="fz12px mb2px">Дата от:</p>
					<div class="field field_date small">
						<input type="text" id="adminsHistoryDateStart" autocomplete="off" placeholder="Дата от">
					</div>
				</div>
				<div class="col">
					<p class="fz12px mb2px">Дата до:</p>
					<div class="field field_date small">
						<input type="text" id="adminsHistoryDateEnd" autocomplete="off" placeholder="Дата до">
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-auto">
			<p class="fz12px mb2px">Администратор:</p>
			<div class="select small fz14px">
				<select id="adminsHistoryAdmins" disabled></select>
				<div class="select__caret"></div>
			</div>
		</div>
		
		<div class="col-auto">
			<p class="fz12px mb2px">Тип операции:</p>
			<div class="select small fz14px">
				<select id="adminsHistoryAdminactions" disabled></select>
				<div class="select__caret"></div>
			</div>
		</div>
		
		<div class="col-auto">
			<p class="fz12px mb2px">Участник:</p>
			<div class="field small w250px" id="adminsHistorySearchUsers">
				<input type="text" id="adminsHistoryUserNickname" placeholder="Никнейм">
				<div class="field__dropdown" id="adminsHistoryFoundedUsers"></div>
			</div>
			<input type="hidden" id="adminsHistoryUser">
		</div>
		
		
		
		
		{# <div class="col-auto">
			<div class="field small">
				<input type="text" id="searchUsersField" placeholder="Введите никнейм">
			</div>
		</div>
		<div class="col-auto">
			<div class="select small">
				<select id="searchUsersType">
					<option value="nickname">По никнейму</option>
					<option value="payment">По платежным данным</option>
				</select>
				<div class="select__caret"></div>
			</div>
		</div>
		<div class="col-auto">
			<div class="buttons notop">
				<button class="small" id="setSearchFromUsers">Поиск</button>
			</div>
		</div>
		<div class="col-auto">
			<div class="buttons notop">
				<button class="small remove" disabled id="resetSearchFromUsers">Сбросить</button>
			</div>
		</div> #}
		
		
		
		<div class="col-auto ml-auto">
			<div class="buttons notop">
				<button class="" adminshistoryfilterbtn>Показать</button>
			</div>
		</div>
	</div>
	
	
	<table id="adminsHistoryTable">
		<thead>
			<tr class="h40px">
				<td class="w150px"><strong>Администратор</strong></td>
				<td class="w300px"><strong>Операция</strong></td>
				<td class="w60px"><strong>Время</strong></td>
				<td><strong>Подробно</strong></td>
				{# <td class="w60px"></td> #}
			</tr>
		</thead>
		<tbody id="adminsHistoryList">
			<tr>
				<td colspan="5">
					<p class="empty center"><i class="fa fa-spinner fa-pulse fa-fw"></i> Загрузка...</p>
				</td>
			</tr>
		</tbody>
	</table>	
</div>





<script type="text/javascript"><!--
$(function() {
	let ddrScrollTableY;
	
	const params = {
		date_start: null,
		date_end: null,
		admin: null,
		actiontype: null,
		user: null
	};
	
	
	
	getAjaxHtml('admin/adminsactions/admins', function(html) {
		$('#adminsHistoryAdmins').html(html);
		$('#adminsHistoryAdmins').removeAttrib('disabled');
	});
	
	getAjaxHtml('admin/adminsactions/actions', function(html) {
		$('#adminsHistoryAdminactions').html(html);
		$('#adminsHistoryAdminactions').removeAttrib('disabled');
	});
	
	
	getHistory();
	
	datePicker('#adminsHistoryDateStart', '#adminsHistoryDateEnd', 'm:1', true);
	
	
	
	let adminsHistoryUsersTOut;
	$('#adminsHistorySearchUsers').changeInputs(function(input) {
		let string = $(input).val();
		if (string.length > 2) {
			clearTimeout(adminsHistoryUsersTOut);
			adminsHistoryUsersTOut = setTimeout(function() {
				getAjaxHtml('admin/adminsactions/search_users', {string: string}, function(html, stat) {
					if (stat) $('#adminsHistoryFoundedUsers').html(html);
					else notify('Ничего не найдено!', 'info');
				});
			}, 500);
		} else {
			$('#adminsHistoryUser').val('');
		}
	});
	
	
	
	
	
	$('#adminsHistoryFoundedUsers').on(tapEvent, '[adminshistorysearcheduser]', function() {
		let userId = $(this).attr('adminshistorysearcheduser'),
			userNickname = $(this).text();
		$('#adminsHistoryUser').val(userId);
		$('#adminsHistoryUserNickname').val(userNickname);
		$('#adminsHistoryFoundedUsers').empty();
	});
	
	
	
	$('[adminshistoryfilterbtn]').on(tapEvent, function() {
		$('#adminsHistoryList').html('<tr><td colspan="5"><p class="empty center"><i class="fa fa-spinner fa-pulse fa-fw"></i> Загрузка...</p></td></tr>');
		params.date_start = $('#adminsHistoryDateStart').attr('date');
		params.date_end = $('#adminsHistoryDateEnd').attr('date');
		params.admin = $('#adminsHistoryAdmins').val();
		params.actiontype = $('#adminsHistoryAdminactions').val();
		params.user = $('#adminsHistoryUser').val();
		getHistory();
	});
	
	
	
	
	
	
	
	
	
	
	
	
	function getHistory(callback) {
		getAjaxHtml('admin/adminsactions/all', params, function(html, stat) {
			if (stat) {
				$('#adminsHistoryList').html(html);
				if (ddrScrollTableY) {
					ddrScrollTableY.reInit();
				} else {
					ddrScrollTableY = $('#adminsHistoryTable').ddrScrollTableY({height: 'calc(100vh - 250px)', offset: 1, wrapBorderColor: '#ccd2d8'});
				}
			} else {
				$('#adminsHistoryList').html('<tr><td colspan="5"><p class="empty center">Нет данных</p></td></tr>');
			}
		}, function() {
			if (callback && typeof callback == 'function') callback();
		});
	};
});
//--></script>