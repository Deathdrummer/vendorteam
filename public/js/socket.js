if (isHosting() && location.pathname == '/account') {
	let cookieUserId = getCookie('id', true);
	
	const userId = cookieUserId ? parseInt(cookieUserId) : false;
	
	if (userId) {
		
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
			let staticId = $('[staticscontent].staticscontent_visible').attr('staticscontent');
			getStaticMiniNews(staticId);
		});
		
		
		

		let staticId = $('[staticscontent].staticscontent_visible').attr('staticscontent');
		getStaticMiniNews(staticId);

		$('[accountstatic]').on(tapEvent, function() {
			staticId = $(this).attr('accountstatic');
			getStaticMiniNews(staticId);
		});



		function getStaticMiniNews(staticId) {
			if ($('[staticscontent="'+staticId+'"]').length) {
				getAjaxHtml('mininewsfeed/account_list', {static_id: staticId}, function(html) {
					$('[staticscontent="'+staticId+'"]').find('[mininewsfeedaccountblock]').html(html);			
				}, function() {});
			}
		}
		
		
			
		let testingMiniNFTime = setInterval(() => {
			let date = new Date();
			if (date.getMinutes() % 5 == 0 && date.getSeconds() == 1) {
				clearInterval(testingMiniNFTime);
				setInterval(() => { 
					let staticId = $('[staticscontent].staticscontent_visible').attr('staticscontent');
					getStaticMiniNews(staticId);
				}, (300 * 1000));
			}
		}, 1000);
		
		
		
		
		
		
		
		//--------------------------------------- подарки
		socket.on('gifts:update', (userId) => {
			getAjaxJson('gifts/get_count_gifts', {user_id: userId}, function(count) {
				$('[giftscounter]').text(count);
				$('[getgifts]:not(.leftblocktopicon_active)').addClass('leftblocktopicon_active');
				$('[getgifts]').attr('title', 'Есть новые подарки!');
				notify('У Вас есть новые подарки!', 'success', 10);
			}, function() {
				//setCookie('gifts', giftsLength);
			});
		});
		
		
		
		
		
		
		
		//--------------------------------------- опросы
		socket.on('pollings:new', (pollingId) => {
			getAjaxJson('pollings/account/has_user_in_polling', {user_id: userId, polling_id: pollingId}, function(count) {
				if (count) {
					setTimeout(function() {
						setCookie('pollings', count);
					}, (10 * 1000));
					
					$('[pollingcounter]').text(count);
					$('[getpollings]:not(.leftblocktopicon_active)').addClass('leftblocktopicon_active');
					$('[getpollings]').attr('title', 'Есть новые опросы!');
					notify('У вас есть новый опрос!', 'success', 10);
				}
			});
		});
		
		
		let testingTime = setInterval(() => {
			let date = new Date();
			if (date.getMinutes() % 5 == 0 && date.getSeconds() == 1) {
				clearInterval(testingTime);
				setInterval(() => { 
					getAjaxJson('pollings/account/reload_pollings', {user_id: userId}, function(count) {
						if (count) {
							setCookie('pollings', count);
							$('[pollingcounter]').text(count);
							$('[getpollings]:not(.leftblocktopicon_active)').addClass('leftblocktopicon_active');
							$('[getpollings]').attr('title', 'Есть новые опросы!');
						
						} else {
							deleteCookie('pollings');
							$('[pollingcounter]').text('');
							$('[getpollings].leftblocktopicon_active').removeClass('leftblocktopicon_active');
							$('[getpollings]').removeAttrib('title');
						}		
					});
				}, (300 * 1000));
			}
		}, 1000);
		
	
	
	
	
	}
} else {
	//socket = io.connect("https://vendorteam.ru:5050/accounts");
}