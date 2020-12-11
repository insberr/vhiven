module client
import eventbus
import time
import x.websocket
import x.json2

const (
	bus = eventbus.new()
)


fn get_subscriber() eventbus.Subscriber {
	return *bus.subscriber
}

pub struct Client {
pub mut:
	ws &websocket.Client
	token string
	bot bool = true
	firstevent bool = true
	
}

struct ClosedReason { 
	pub:
		code int
		reason string
}

pub fn (mut c Client) run() ? { // this function blocks until the client stops
	c.ws.listen()
	time.sleep(5) // allow for stuff to get done
	// if c.bot == true {
	//	ws.login(c.ws,"Bot $c.token")
	//} else {
	//	ws.login(c.ws, c.token)
	//}
	for {}
}

pub fn (mut c Client) on(etype string, evthandler eventbus.EventHandlerFn) {
	get_subscriber().subscribe(etype, evthandler)
}
 


fn (mut c Client) ready() {
	println("ready to login")
	// login

}


fn opn(n voidptr, na voidptr, mut client &Client) {
	client.ready()
}

pub fn new_client(token string) Client {
	socket := websocket.new_client("wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json") or { panic("Unable to connect") }
	mut cl := Client{
		token: token
		ws: socket
	}
	cl.ws.on_open_ref(openfn, &cl)
	cl.ws.on_close_ref(closefn, &cl)
	cl.on("open", opn)
	return cl
}

fn openfn(mut c websocket.Client, cl &Client) ? {
	bus.publish("open", cl, none)
}
fn closefn(mut c websocket.Client, code int, reason string, cl &Client) ? {
	bus.publish("close",cl, ClosedReason{code: code, reason: reason})
}
fn messagefn(mut c websocket.Client, msg &websocket.Message, cl &Client) ? {
	msgdata := string(msg.payload)
	bus.publish("message",cl, msgdata)
}