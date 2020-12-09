module websocket

import x.websocket
import x.json2 // using this because i have no idea what voidpointers are and this one has documentation

fn makeopcode(opcode int, data map[string]json2.Any) string { // Creates the json to send to server
	mut inst := map[string]json2.Any
	inst['op'] = opcode
	inst['data'] = data
	return inst.str()
}

fn makeloginpacket(token string) string {
	mut data := map[string]json2.Any
	data["token"] = token
	return makeopcode(2,data)
}

pub fn new_websocket() {
	println('New websocket created')
	mut ws_client := websocket.new_client('wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json') or { return }
	ws_client.connect()
	ws_client.listen() or { println(err) }
}