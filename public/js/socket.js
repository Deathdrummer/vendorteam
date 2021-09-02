if (location.hostname != 'localhost') {
	const userId = parseInt(getCookie('id')) || '';
	socket = io.connect("https://vendorteam.ru:5050/accounts", {query:'user_id='+userId});


	socket.emit('user_online', userId);



	socket.emit('take_users_online', users => {
		$.each(users, function(k, user) {
			$('[userid="'+user['user_id']+'"]').find('.staticuser__stat').addClass('online');
		});
	});


	socket.on('set_online_user', (userId) => {
		$('[userid="'+userId+'"]').find('.staticuser__stat').addClass('online');
	});


	socket.on('set_offline_user', (userId) => {
		$('[userid="'+userId+'"]').find('.staticuser__stat').removeClass('online');
	});
	
	
	
	
	socket.on('usersmessages:new', (userId) => {
		$('[newmessages]:not(.leftblocktopicon_active)').addClass('leftblocktopicon_active');
		let countMess = parseInt($('[newmessagecounter]:visible').text()) || 0;
		$('[newmessagecounter]').text(++countMess);
	});
	
	
	
	socket.on('usersmessages:setread', (messId) => {
		let readCount = parseInt($('[messtousersreadcount="'+messId+'"]').text());
		$('[messtousersreadcount="'+messId+'"]').text(readCount+1);
	});
	
	
	socket.on('mininewsfeed:reload', () => {
		getAjaxHtml('mininewsfeed/account_list', function(html) {
			$('#miniNewsFeedAccountBlock').html(html);
		}, function() {});
	});
	
	
	let date = new Date(),
		hours = date.getHours(),
		minutes = date.getMinutes();
		
	
	console.log(date.getHours(), date.getMinutes());
	
	setInterval(() => {
		if ((hours == '00' || hours == 0) && (minutes > 0 && minutes < 20)) {
			getAjaxHtml('mininewsfeed/account_list', function(html) {
				$('#miniNewsFeedAccountBlock').html(html);
			}, function() {});
		}
	}, 600000);
	
}	