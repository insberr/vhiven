// vhiven is a hiven bot and api interaction library
module vhiven

// import src.structs as s

// HivenClient the hiven client
pub struct HivenClient {
pub mut:
	bot       bool = true
	init_data string
	cl        Client
}

// new_client create a new HivenClient
pub fn new_client() HivenClient {
	return HivenClient{}
}

// login to the client
// `token` is a string of the bot or user auth token
pub fn (mut hcl HivenClient) login(token string) {
	mut cl := new_ws_client()
	hcl.cl = cl

	login(mut cl, hcl.bot, token)
}
