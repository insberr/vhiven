module websocket
import src.events
import x.websocket
import x.json2
import src.opcodes
// using this because i have no idea what voidpointers are and this one has documentation

const (
	hiven = "wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json"
	test = "wss://echo.websocket.org"
)

pub fn login(mut client &websocket.Client, token string) ? {
	packet := opcodes.login(token)
	client.write_str(packet)? // should send it
}

pub fn new_websocket(openfn websocket.SocketOpenFn, closefn websocket.SocketCloseFn, messagefn websocket.SocketMessageFn) &websocket.Client { 
	println('New websocket created')
	return c_websocket(hiven, openfn, closefn, messagefn, true)
}

fn c_websocket(url string, openfn websocket.SocketOpenFn, closefn websocket.SocketCloseFn, messagefn websocket.SocketMessageFn, start bool) &websocket.Client {
	mut ws := websocket.new_client(url) or {panic("Unable to connect")}
	ws.on_close(closefn)
	ws.on_message(messagefn)
	ws.on_open(openfn)
	if start {
	ws.connect()  or { println(err) }
	go ws.listen() or { println(err) }
	}
	return ws // this is a &websocket.Client not a websocket.Client
}
