module client
import src.websocket as ws

pub struct Client {
pub mut:
	ws &websocket.Client
	token string
	bot bool = true
}

//                              vvvv chage this later
pub fn (c Client) login(token) events string {
	if c.bot == true {
		ws.login("Bot $token")
	} else {
		ws.login(token)
	}
	return "Logged in"
}

