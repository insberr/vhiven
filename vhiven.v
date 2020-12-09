module vhiven
import src.websocket as ws

pub struct HivenClient {
pub mut:
	user string // maybe add the websocket to the hiven client?
}

pub fn new_client() HivenClient {
	ws.new_websocket()
	c := HivenClient{user: 'insbott'}
	return c
}

pub fn (c HivenClient) login(token string) {
	println('Logged in: Token: $token')
}
