module client

import time
import x.websocket
import src.structs
import eventbus

const bus = eventbus.new()
const socket_url = 'wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json'

pub struct Client {
pub mut:
	ws         &websocket.Client
	bot        bool = true
	firstevent bool = true
	heartbeat  u64 = 30000
	last_heartbeat u64
	closed bool
mut:
	token string
}

struct ClosedReason {
pub:
	code   int
	reason string
}

/*
Websocket Info

After connection {"op": 2, "d": {"token": "128CharacterToken"}}

op codes
1 heartbeat
2 is login
3 pingpong
6 Request Presence Subscriptions
7 member
*/

pub fn get_subscriber() eventbus.Subscriber {
	return *bus.subscriber
}

pub fn (mut cl Client) on(etype string, evthandler eventbus.EventHandlerFn) {
	get_subscriber().subscribe(etype, evthandler)
}


pub fn new_client() &Client {
	mut socket := websocket.new_client(socket_url) or { panic('Unable to connect') }
	mut cl := &Client{
		ws: socket
	}

	cl.ws.on_open_ref(openfn, &cl)
	cl.ws.on_message_ref(messagefn, &cl)
	cl.ws.on_close_ref(closefn, &cl)
	cl.ws.on_error_ref(errorfn, &cl)

	return cl
}

pub fn (mut cl Client) login(token string) {
	cl.token = token
	
	cl.ws.connect() or { println(err) }
	
	cl.ws.write_str('{"op": 2, "d": { "token": "Bot $cl.token" }}')
	go cl.ws.listen()
	time.sleep(30)
}

fn run_heartbeat(mut ws websocket.Client, mut cl Client) {
	for {
		now := time.now().unix_time_milli()
		if now - cl.last_heartbeat > cl.heartbeat {
			ws.write_str('{"op":3}')
			println('sent op 3')
			cl.last_heartbeat = now
		}
	}
}


pub fn (mut c Client) run() ? { // this function blocks until the client stops
	// allow for stuff to get done
	// if c.bot == true {
	// ws.login(c.ws,"Bot $c.token")
	// } else {
	// ws.login(c.ws, c.token)
	// }
	for {
	}
}

//=== Websocket events ===

fn openfn(mut ws websocket.Client, cl &Client) ? {
	// println('websocket opened')
	bus.publish('open', cl, none)
}

fn closefn(mut c websocket.Client, code int, reason string, mut cl &Client) ? {
	cl.closed = true
	bus.publish('close', cl, ClosedReason{
		code: code
		reason: reason
	})
}

fn messagefn(mut c websocket.Client, msg &websocket.Message, mut cl Client) ? {
	if msg.payload.len > 0 {
		mut pck := structs.socket_msg_parse(msg) ?
		// println(pck)
		match pck.op {
			0 {
				match pck.e {
					'INIT_STATE' {
						bus.publish('ready', cl, none)
					}
					'HOUSE_JOIN' { }
					'HOUSE_MEMBER_ENTER' { }
					'HOUSE_MEMBER_UPDATE' { }
					'MESSAGE_CREATE' {
						structs.message_create_parse(pck.d)
						bus.publish('message', cl, structs.message_create_parse(pck.d))
					}
					'TYPING_START' {
						println('user started typing')
					}
					else { println('Event `$pck.e` not added') }
				}
				
				// msg := structs.message(pck.d)
				// bus.publish('message', cl, pck.d)
			}
			1 {
				// println('op 1 got hbt')
				cl.heartbeat = pck.d["hbt_int"].str().u64()
				go run_heartbeat(mut c, mut cl)
				// activate_heartbeat(pck.d['hbt_int'].int(), mut c, mut cl)
			}
			2 { println('got 2') }
			3 { println('got 3') }
			4 { println('got 4') }
			5 { println('got 5') }
			6 { println('got 6') }
			7 { println('got 7') }
			8 { println('got 8') }
			else { println('INVALID OPCODE: $pck.op DATA: $pck.d') }
		}
		// print(pck.d)
		// bus.publish('message', cl, message)
	}
}

fn errorfn(mut ws websocket.Client, err string, mut cl Client) ? {
	// println('Error: $err')
	bus.publish('error', cl, err)
}

/*
fn activate_heartbeat(timeb int, mut c websocket.Client, mut cl Client) {
	println('HEARTBEAT SET TO: ' + timeb.str())
	c.write_str('{"op":1}')
	cl.heartbeat = timeb
}
*/


