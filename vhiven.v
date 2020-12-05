module vhiven
import src.websocket

pub struct Client {
pub mut:
	user string
}

pub fn new_client() Client {
	c := Client{user: 'insbott'}
	return c
}

pub fn (c Client) login(token string) {
	println('Logged in: Token: $token')
}
