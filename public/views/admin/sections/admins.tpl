<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Администраторы</h2>
	</div>
	
	
	<table>
		<thead>
			<tr>
				<td class="w300px"><strong>Логин</strong></td>
				<td class="w300px"><strong>Пароль</strong></td>
				<td></td>
				<td class="w80px"><strong>Доступы</strong></td>
				<td class="w80px"><strong>Опции</strong></td>
			</tr>
		</thead>
		<tbody id="adminsList"></tbody>
		<tfoot>
			<tr>
				<td colspan="5">
					<div class="buttons right notop">
						<button id="adminsAddBtn" class="small">Добавить</button>
					</div>
				</td>
			</tr>
		</tfoot>
	</table>	
</div>



<script type="text/javascript"><!--
	
	$('#adminsList').ddrCRUD({
		addSelector: '#adminsAddBtn',
		emptyList: '<tr><td colspan="5"><p class="empty">Нет данных</p></td></tr>', // Текст при пустом листе
		functions: 'admin/admins', // PHP функции, например: account/personages/[get,add,save,update,remove]
		removeConfirm: true
	});
	
	
	$('#adminsList').on(tapEvent, '[adminspermissions]', function() {
		let input = $(this).closest('td').find('[permissionsinput]'),
			nickName = $(this).closest('tr').find('[name="nickname"]').val(),
			saveUpdateBtns = $(this).closest('tr').find('[save], [update]'),
			permissions = [];
		
		popUp({
			title: 'Настройка доступов <b>'+nickName+'</b>|4',
			width: 1000,
			closePos: 'left',
			closeButton: 'Закрыть'
		}, function(adminsPermissionsWin) {
			let checkedPermissions = $(input).val().split(',');
			
			adminsPermissionsWin.setData('admin/admins/permissions', {permissions: checkedPermissions}, function() {
				$('[permissionscheckall]').on(tapEvent, function() {
					if ($(this).attr('permissionscheckall') != 1) {
						$(this).closest('[permissionsblock]').find('[permission]').each(function() {
							$(this).setAttrib('checked');
						});
						$(this).setAttrib('permissionscheckall', 1);
					} else {
						$(this).closest('[permissionsblock]').find('[permission]').each(function() {
							$(this).removeAttrib('checked');
						});
						$(this).setAttrib('permissionscheckall', 0);
					}
					permissions = [];
					$('#adminPermissionsForm').find('[permission]:checked').each(function() {
						permissions.push($(this).attr('permission'));
					});
					$(input).val(permissions.join(','));
					$(saveUpdateBtns).removeAttrib('disabled');
				});
				
				
				$('[permission]').on('change', function() {
					let url = $(this).attr('permission'),
						subitems = $(this).closest('tr').siblings('tr[subitems="'+url+'"]'),
						isSub = !!subitems,
						isChecked = !$(this).is(':checked');
					if (subitems.length) {
						$(subitems).find('[permission]').each(function() {
							if (isChecked) $(this).removeAttrib('checked');
							else $(this).setAttrib('checked');
						});
					}
					
					if (isSub) $(this).closest('[subitems]').prev('.adminpermissions__item').find('[permission]:not([permissionsub])').setAttrib('checked');
					
					permissions = [];
					$('#adminPermissionsForm').find('[permission]:checked').each(function() {
						permissions.push($(this).attr('permission'));
					});
					$(input).val(permissions.join(','));
					$(saveUpdateBtns).removeAttrib('disabled');
				});	
				
				
				
				
				$('[opensubitems]').on(tapEvent, function() {
					let url = $(this).attr('opensubitems'),
						isOpened = $('[subitems="'+url+'"]').hasClass('adminpermissions__subitems_opened');
					
					if (isOpened) {
						$('[subitems="'+url+'"]').removeClass('adminpermissions__subitems_opened');
					} else {
						$('[subitems="'+url+'"]').addClass('adminpermissions__subitems_opened');
					}
					
				});	
			});
		});
	});
	
	
	
//--></script>