module websocket

import x.websocket

pub fn new_websocket() {
	println('New websocket created')
	mut ws_client := websocket.new_client('wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json') or { return }
	ws_client.connect()
	ws_client.listen() or { println(err) }
}