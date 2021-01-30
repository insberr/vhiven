// vhiven is a hiven bot and api interaction library
module vhiven

import src.client
import eventbus

// HivenClient the hiven client
pub struct HivenClient {
pub mut:
	bot bool = true
	init_data string
	cl client.Client
}

// new_client create a new HivenClient
pub fn new_client() HivenClient {
	mut hcl := HivenClient{}
	return hcl
}

fn get_hcl() &HivenClient {
	return &HivenClient{}
}

// login to the client
pub fn (mut hcl HivenClient) login(token string) {
	mut cl := client.new_client()
	hcl.cl = cl
	hcl.cl.on('all_events', fn (recvr voidptr, eventdata voidptr, cl voidptr) {
		mut hcl := get_hcl()
		// change ready to init
		if eventdata.event == 'ready' {
			hcl.init_data = eventdata.data.str()
		}
		hcl.cl.get_subscriber().publish(eventdata.event, hcl, eventdata.data)
	})
	hcl.cl.login(token)
}

// on for events
pub fn (mut hcl HivenClient) on(etype string, evthandler eventbus.EventHandlerFn) {
	hcl.cl.get_subscriber().subscribe(etype, evthandler)
}
