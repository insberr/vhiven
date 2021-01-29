module main

import src.client
import src.structs as s
import os
import zztkm.vdotenv
import x.json2

fn main() {
	vdotenv.load()

    bot_token := os.getenv('TOKEN')
    
	mut cl := client.new_client()
	cl.bot = false

	cl.on('ready', fn (recvr voidptr, args voidptr, client &client.Client) {
		println('test: ready')
	})

	cl.on('open', fn (recvr voidptr, args voidptr, cl &client.Client) {
		println('test: websocket open')
	})

	cl.on('close', fn (recvr voidptr, reason &client.ClosedReason, cl &client.Client) {
		println('test: websocket closed. Reason: $reason.reason, code: $reason.code')
	})
	
	cl.on('error', on_error)

	cl.on('message', fn (recvr voidptr, msg &s.Message, cl &client.Client) {
		println(msg.content)
	})

	cl.login(bot_token)
	// cl.run()
	//ws.login(wstest,"token goes here")
}


fn on_error(recvr voidptr, err voidptr, client &client.Client) {
	println(err)
}