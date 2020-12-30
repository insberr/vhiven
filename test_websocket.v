module main

import src.client
import os
import zztkm.vdotenv

fn main() {
	vdotenv.load()

    bot_token := os.getenv('TOKEN')
    
	mut cl := client.new_client()

	cl.on('open', fn (recvr voidptr, args voidptr, cl &client.Client) {
		println('client on fn in test on_open')
	})

	cl.on('close', fn (recvr voidptr, reason &client.ClosedReason, cl &client.Client) {
		println('cl.on close closed')
		println(reason)
	})
	cl.on("ready", on_ready)
	cl.on('error', on_error)

	cl.on('message', fn (recvr voidptr, msg voidptr, cl &client.Client) {
		println(msg)
	})

	cl.login(bot_token)
	// cl.run()
	//ws.login(wstest,"token goes here")
}


fn on_error(recvr voidptr, args voidptr, client &client.Client) {
	println(args)
}
fn on_ready(recvr voidptr, args voidptr, client &client.Client) {
	println("On Ready")
}