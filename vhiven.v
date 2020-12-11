module vhiven
import src.client as ws_client
import x.websocket

pub struct HivenClient {
pub mut:
  	user string 
	bot bool = true
	internalclient ws_client.Client 
}

pub fn new_client() HivenClient {
	return HivenClient{}
}

pub fn (c HivenClient) login(token string) {
	if c.bot == false {
		ws.login(token)
	} else {
		ws.login('Bot $token')
	}
	// Start websocket and stuff
}
