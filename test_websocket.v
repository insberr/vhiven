module main
import src.opcodes as op
import x.websocket
import src.client
import os
import x.json2

struct Testpassin {
	test string
}

fn main() {
	mut cl := client.new_client("abc")
	cl.on("ready",on_ready)
	cl.run()
	//ws.login(wstest,"token goes here")
}


fn on_ready(n voidptr, na voidptr, client &client.Client) {
	println("On Ready")
}