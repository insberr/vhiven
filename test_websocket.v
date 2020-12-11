module main
import src.websocket as ws
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


fn on_ready(evtdata map[string]json2.Any) ? {
	println("On Ready")
}