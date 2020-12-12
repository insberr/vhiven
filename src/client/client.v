module client

import eventbus
import time
import x.websocket
import x.json2

const (
	bus = eventbus.new()
)

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

pub fn new_client() Client {
	println('New client created')
	mut socket := websocket.new_client("wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json") or { panic("Unable to connect") }
	mut cl := Client{
		ws: socket
	}
	return cl
}

pub fn (mut cl Client) login(token string) {

	cl.ws.connect()
    go cl.ws.listen()
	time.sleep(5)
	

	cl.ws.on_open_ref(openfn, &cl)
	cl.ws.on_message_ref(messagefn, &cl)
	cl.ws.on_close_ref(closefn, &cl)

}



fn get_subscriber() eventbus.Subscriber {
	return *bus.subscriber
}

pub fn (mut c Client) run() ? { // this function blocks until the client stops
	
	 // allow for stuff to get done
	// if c.bot == true {
	//    ws.login(c.ws,"Bot $c.token")
	//} else {
	//	ws.login(c.ws, c.token)
	//}
	for {}
}

pub fn (mut c Client) on(etype string, evthandler eventbus.EventHandlerFn) {
	mut sub := bus.subscriber
	sub.subscribe(etype, evthandler)
}
 


fn (mut c Client) ready() {
	println("ready to login")
	// login

}


fn opn(n voidptr, na voidptr, mut client &Client) {
	println('opn ran')
	client.ready()
}



fn openfn(mut c websocket.Client, cl &Client) ? {
	println('websocket opened')
	bus.publish("open", none, cl)
}

fn closefn(mut c websocket.Client, code int, reason string, cl &Client) ? {
	bus.publish("close", ClosedReason{code: code, reason: reason}, cl)
}

fn messagefn(mut c websocket.Client, msg &websocket.Message, cl &Client) ? {
	msgdata := string(msg.payload)
	bus.publish("message", msgdata, cl)
}
