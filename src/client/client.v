module client
import src.websocket as ws
import eventbus
import time
import x.websocket
import x.json2
pub struct Client {
pub mut:
	ws &websocket.Client
	token string
	bot bool = true
	bus eventbus.Subscriber
	firstevent bool = true
	handlers map[string]Onevent = map[string]Onevent
}
type Onevent = fn (eventdata map[string]json2.Any) ?
pub fn (mut c Client) run() ? { // this function blocks until the client stops
	go c.ws.listen()
	time.sleep(5) // allow for stuff to get done
	if c.bot == true {
		ws.login(c.ws,"Bot $c.token")
	} else {
		ws.login(c.ws, c.token)
	}
}

pub fn (mut c Client) on(etype string, evthandler Onevent) {
	c.handlers[etype] = evthandler
}
 
// client.on("ready") is called when we recive the first event

fn (mut c Client) ready(receiver voidptr, args voidptr, sender voidptr) {

}

pub fn new_client(token string) Client {
	socket := ws.new_websocket()
	mut cl := Client{
		token: token
		bus: ws.get_subscriber()
		ws: socket
	}
	cl.bus.subscribe('ready', cl.ready)
	return cl
}