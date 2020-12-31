module vhiven

import src.client
import eventbus

pub struct HivenClient {
pub mut:
	bot bool = true
	init_data string
}

pub fn new_client() HivenClient {
	mut hcl := HivenClient{}
	return hcl
}

pub fn (mut hcl HivenClient) login(token string) {
	mut cl := client.new_client(mut hcl)
	cl.on('init', fn (recvr voidptr, hivenclient voidptr, cl &client.Client) {
		println('ready i guess')
	})
	cl.login(token)
}

pub fn (mut hcl HivenClient) on(etype string, evthandler eventbus.EventHandlerFn) {
	client.get_subscriber().subscribe(etype, evthandler)
}
