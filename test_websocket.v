module main

import src.client


fn main() {
	mut cl := client.new_client()
	cl.on("ready", on_ready)
	cl.on('error', on_error)

	cl.login('token')
	// cl.run()
	//ws.login(wstest,"token goes here")
}

fn on_error(recvr voidptr, args voidptr, client &client.Client) {
	println(args)
}
fn on_ready(recvr voidptr, args voidptr, client &client.Client) {
	println("On Ready")
}