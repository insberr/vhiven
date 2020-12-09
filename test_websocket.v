module main
import src.websocket as ws
import src.opcodes as op
import x.websocket
import os
fn main() {
	packet := op.login("abc123")
	println(packet)
	mut wstest := ws.new_websocket(onopen,onclose,onmessage)
	ws.login(wstest,"abc123")
	for {}
	//ws.login(wstest,"token goes here")
}


fn onclose(mut c websocket.Client, code int, reason string) ? {
	println("hey we are in onclose")
	println(reason)
}
fn onmessage(mut c websocket.Client, msg &websocket.Message) ? {
	messagetext := string(msg.payload) // []byte, how to make string?
	println("hey we are in onmessage")
	println(messagetext)
}

fn onopen(mut c websocket.Client) ? {
	println("in onopen")
	c.write_str("hello world")
}
