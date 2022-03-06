var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io')(http, {
	cors: {
		origin: "*",
	}
});
var port = 5000;

io.set('origins', 'http://vendorteam.loc:'+port);

io.on('connection', (socket) => {
	
	socket.join('some room');

	// and then later
	socket.to('some room').emit('newclientconnect', { description: 'Приветствие!'}); // in
	socket.emit('newclientconnect', { description: 'Приветствую тебя!'});
	

	socket.on('disconnect', () => {
		socket.broadcast.emit('clientdisconnect', { description: 'клиент ушел!'});
	});

});

http.listen(port, () => {
	console.log('listening on *:'+port);
});