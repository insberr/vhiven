// vhiven is a hiven bot and api interaction
module vhiven

import src.client
import eventbus

// HivenClient the hiven client
pub struct HivenClient {
pub mut:
	bot bool = true
	init_data string
}

// new_client create a new HivenClient
pub fn new_client() HivenClient {
	mut hcl := HivenClient{}
	return hcl
}

// login login to the client
pub fn (mut hcl HivenClient) login(token string) {
	mut cl := client.new_client(mut hcl)
	cl.on('all_events', fn (recvr voidptr, eventdata client.EventData, cl client.Client) {
		// change ready to init
		if eventdata.event == 'ready' {
			hcl.init_data = eventdata.data.str()
		}
		client.get_subscriber().publish(eventdata.event string, hcl HivenClient, eventdata.data client.DataAny)
	})
	cl.login(token)
}

// on for events
pub fn (mut hcl HivenClient) on(etype string, evthandler eventbus.EventHandlerFn) {
	client.get_subscriber().subscribe(etype, evthandler)
}
