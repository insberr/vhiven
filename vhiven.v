// vhiven is a hiven bot and api interaction library
module vhiven

import src.structs as s
import eventbus

// HivenClient the hiven client
pub struct HivenClient {
pub mut:
	bot bool = true
	init_data string
	cl &client.Client
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
	mut cl := new_client()
	hcl.cl = cl

	cl.on('init', on_init)

	go login(mut cl, hcl.bot, token)
}

fn on_init(recvr voidptr, data &s.Init, cl &client.Client) ? {
	mut hcl := get_hcl()
	println(data)
	// hcl.init_data = data.str()
	hcl.cl.bus.publish('ready', cl, none)
}

// on for events
pub fn (mut hcl HivenClient) on(etype string, evthandler eventbus.EventHandlerFn) {
	mut bus := hcl.cl.bus
	fn get_subscriber() eventbus.Subscriber {
		return *bus.subscriber
	}
	get_subscriber().subscribe(etype, evthandler)
}
