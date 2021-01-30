// vhiven is a hiven bot and api interaction library
module vhiven

import src.structs as s
import eventbus

// HivenClient the hiven client
pub struct HivenClient {
pub mut:
	bot bool = true
	init_data string
	cl Client
}

// new_client create a new HivenClient
pub fn new_client() HivenClient {
	return HivenClient{}
}

// login to the client
pub fn (mut hcl HivenClient) login(token string) {
	println("hcl login")
	mut cl := new_ws_client()
	hcl.cl = cl

	cl.on('init', on_init_state)

	login(mut cl, hcl.bot, token)
}

fn on_init_state(recvr voidptr, data &s.InitState, cl &Client) ? {
	// println(data)
	// hcl.init_data = data.str()
	bus.publish('ready', cl, none)
}

// on for events
pub fn (mut hcl HivenClient) on(etype string, evthandler eventbus.EventHandlerFn) {
	get_subscriber().subscribe(etype, evthandler)
}
