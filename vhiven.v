// vhiven is a hiven bot and api interaction library
module vhiven

import src.structs as s
import eventbus

// HivenClient the hiven client
pub struct HivenClient {
pub mut:
	bot bool = true
	init_data string
	cl &Client
}

// new_client create a new HivenClient
pub fn new_client() &HivenClient {
	mut hcl := &HivenClient{}
	return &hcl
}

fn get_hcl() &HivenClient {
	return &HivenClient{}
}

// login to the client
pub fn (mut hcl HivenClient) login(token string) {
	println("hcl login")
	mut cl := new_ws_client()
	hcl.cl = cl

	cl.on('init', on_init)

	login(mut cl, hcl.bot, token)
}

fn on_init(recvr voidptr, data &s.Init, cl &Client) ? {
	mut hcl := get_hcl()
	println(data)
	// hcl.init_data = data.str()
	hcl.cl.bus.publish('ready', cl, none)
}

fn get_subscriber(mut hcl HivenClient) eventbus.Subscriber {
	mut bus := hcl.cl.bus
	return *bus.subscriber
}
// on for events
pub fn (mut hcl HivenClient) on(etype string, evthandler eventbus.EventHandlerFn) {
	get_subscriber(mut hcl).subscribe(etype, evthandler)
}
