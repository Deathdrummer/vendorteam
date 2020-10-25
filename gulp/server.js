var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io')(http);
var port = 80;

app.get('/', (req, res) => {
	res.sendFile(__dirname + '/socket_io.html');
});

var clients = 0;
//var nsp = io; //.of('http://vendorteam.loc:80');
io.set('origins', 'http://vendorteam.loc:'+port);

io.on('connection', (socket) => {
	
	socket.join('some room');

	// and then later
	socket.to('some room').emit('newclientconnect', { description: 'Приветствие!'});
	socket.emit('newclientconnect', { description: 'Приветствую тебя!'});
	
	/*console.log('user connected');
	
	
	console.log(socket.id);
	
	//notify(socket.id);
	clients++;
	socket.emit('newclientconnect', { description: 'Приветствую!'});
	socket.broadcast.emit('newclientconnect', { description: clients + ' клиентов!'});
	
	socket.on('disconnect', () => {
		clients--;
		console.log('user disconnected');
		socket.broadcast.emit('clientdisconnect', { description: 'клиент ушел! Осталось '+clients + ' клиентов!'});
	});*/
	
	/*socket.join("room-"+clients);
	
	
	nsp.in("room-"+clients).emit('newclientconnect', { description: 'Hey, welcome!'});
	socket.broadcast.emit('newclientconnect', { description: clients + ' clients connected!'});
	clients++;
	*/
});

http.listen(port, () => {
	console.log('listening on *:'+port);
});









/*var app = require('express')(),
	http = require('http').Server(app),
	io = require('socket.io')(http);


app.set('port', 3001);

http.listen(3001, function() {
    console.log('Слушается порт: 3001');
});

app.get('/', function(req, res) {
    res.sendFile(__dirname + '/socket_io.html');
});


var users = {},
	count = 0;


io.on('connection', function(socket) {
	
	users[socket.id] = {
		id: socket.id
	};
	
	++count;
	
	io.emit('users', users, count);
	
	socket.on('disconnect', function() {
		delete users[socket.id];
        io.emit('users', users, --count);
    });
    
    
    
    
});*/