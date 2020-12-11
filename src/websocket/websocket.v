module websocket
import src.events
import x.websocket
import x.json2
import src.opcodes
import eventbus
// using this because i have no idea what voidpointers are and this one has documentation

struct ClosedReason {
	code int
	reason string
}

const (
	hiven = "wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json"
	test = "wss://echo.websocket.org"
	bus = eventbus.new()
)

pub fn get_subscriber() eventbus.Subscriber {
	return *bus.subscriber
}

pub fn login(mut client &websocket.Client, token string) ? {
	packet := opcodes.login(token)
	client.write_str(packet)? // should send it
}

pub fn new_websocket() &websocket.Client { 
	println('New websocket created')
	socket := c_websocket(hiven, openfn, closefn, messagefn, false)
	return socket
}


fn c_websocket(url string, openfn websocket.SocketOpenFn, closefn websocket.SocketCloseFn, messagefn websocket.SocketMessageFn,start bool) &websocket.Client {
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

fn openfn(mut c websocket.Client) ? {
	bus.publish("open", none, none)
}
fn closefn(mut c websocket.Client, code int, reason string) ? {
	bus.publish("close",none, ClosedReason{code: code, reason: reason})
}
fn messagefn(mut c websocket.Client, msg &websocket.Message) ? {
	msgdata := string(msg.payload)
	bus.publish("message",none, msgdata)
}