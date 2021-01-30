module client

import time
import x.websocket
import x.json2
import src.structs
import eventbus

const bus = eventbus.new()
const socket_url = 'wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json'

// Client websocket client struct
pub struct Client {
pub mut:
	ws         &websocket.Client
	bot        bool = true
	firstevent bool = true
	heartbeat  u64 = 30000
	last_heartbeat u64
	closed bool
	is_pinging bool
	bus &eventbus.EventBus
mut:
	token string
}


pub struct ClosedReason {
pub:
	code   int
	reason string
}

pub struct Error {
pub:
	e string
}


pub type DataAny = map[string]json2.Any | structs.Message | structs.Init
pub struct EventData {
pub mut:
	event string
	data DataAny
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

// get_subscriber get the eventbus
pub fn get_subscriber() eventbus.Subscriber {
	return *bus.subscriber
}

pub fn (mut cl Client) on(etype string, evthandler eventbus.EventHandlerFn) {
	get_subscriber().subscribe(etype, evthandler)
}


pub fn new_client() Client {
	mut socket := websocket.new_client(socket_url) or { panic('Unable to connect') }
	mut cl := Client{
		ws: socket
		bus: bus
	}

	cl.ws.on_open_ref(openfn, &cl)
	cl.ws.on_message_ref(messagefn, &cl)
	cl.ws.on_close_ref(closefn, &cl)
	cl.ws.on_error_ref(errorfn, &cl)

	return &cl
}

pub fn (mut cl Client) login(bot bool, token string) {
	cl.token = token
	cl.bot = bot
	
	cl.ws.connect() or {
		bus.publish('socket_error', cl, "Failed to connect: $err")
		panic('Failed to connect: $err')
	}

	mut auth_token := ""
	if cl.bot == true {
		auth_token = "Bot $cl.token"
	} else {
		auth_token = cl.token
	}

	cl.ws.write_str('{"op": 2, "d": { "token": "$auth_token" }}') or {
		bus.publish('socket_error', cl, "Failed to authenticate: $err")
		panic('Failed to authenticate: $err')
	}

	go cl.ws.listen()
	time.sleep(30)

	for {
		// Change this to try and reopen the client
		if cl.closed {
			return
		}
		time.sleep_ms(500)
		now := time.now().unix_time_milli()
		if now - cl.last_heartbeat > cl.heartbeat {
			cl.ws.write_str('{ "op": 3 }') or { panic("failed to send op: $err") }
			bus.publish('socket_op3', cl, "opcode 3 (heartbeat) was sent.")
			cl.last_heartbeat = now
		}
	}
}

/* === Websocket events === */

fn openfn(mut ws websocket.Client, mut cl &Client) ? {
	bus.publish('socket_open', cl, none)
}

fn closefn(mut c websocket.Client, code int, reason string, mut cl &Client) ? {
	cl.closed = true
	bus.publish('socket_close', cl, ClosedReason{
		code: code
		reason: reason
	})
}

fn messagefn(mut c websocket.Client, msg &websocket.Message, mut cl Client) ? {
	if msg.payload.len > 0 {
		mut pck := structs.socket_msg_parse(msg) ?

		match pck.op {
			0 {
				match pck.e {
					'INIT_STATE' { bus.publish('init', cl, structs.init_state_parse(pck.d)) }
					'PRESENCE_UPDATE' { }
					'RELATIONSHIP_UPDATE' { }
					'MESSAGE_CREATE' { bus.publish('message', cl, structs.message_create_parse(pck.d)) }
					'MESSAGE_DELETE' { bus.publish('msg_delete', cl, pck.d) }
					'MESSAGE_UPDATE' { bus.publish('msg_update', cl, pck.d) }
					'ROOM_CREATE' { bus.publish('room_created', cl, pck.d) }
					'ROOM_UPDATE' { }
					'ROOM_DELETE' { }
					'HOUSE_JOIN' { bus.publish('house_enter', cl, pck.d) }
					'HOUSE_LEAVE' { bus.publish('house_exit', cl, pck.d) }
					'HOUSE_MEMBER_JOIN' { bus.publish('member_join', cl, pck.d) }
					'HOUSE_MEMBER_EXIT' { bus.publish('member_leave', cl, pck.d) }
					'HOUSE_MEMBER_ENTER' { }
					'HOUSE_MEMBER_UPDATE' { }
					'HOUSE_MEMBERS_CHUNK' { }
					'BATCH_HOUSE_MEMBER_UPDATE' { }
					'HOUSE_ENTITY_UPDATE' { }
					'HOUSE_DOWN' { bus.publish('house_down', cl, pck.d) }
					'TYPING_START' { bus.publish('typing', cl, pck.d) }
					else { println('Event `$pck.e` not added') }
				}
			}
			1 {
				cl.heartbeat = pck.d["hbt_int"].str().u64()
			}
			2 { println('got 2') }
			3 { println('got 3') }
			4 { println('got 4') }
			5 { println('got 5') }
			6 { println('got 6') }
			7 { println('got 7') }
			8 { println('got 8') }
			else { println('Invalid opcode recived: $pck.op\nData: $pck.d') }
		}
	}
}

fn errorfn(mut ws websocket.Client, err string, mut cl Client) ? {
	bus.publish('socket_error', cl, Error{e: err})
}
