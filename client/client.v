module client

import structs

import time
import net.websocket
import x.json2
import eventbus

const bus = eventbus.new()

// wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json
const socket_url = 'wss://swarm-dev.hiven.io/socket?encoding=json'

// Client websocket client struct
/*
pub struct Client {
pub:
	eb &eventbus.EventBus
pub mut:
	ws             &websocket.Client
	bot            bool = true
	firstevent     bool = true
	heartbeat      u64  = 30000
	last_heartbeat u64
	closed         bool
	is_pinging     bool
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
fn get_subscriber() eventbus.Subscriber {
	return *bus.subscriber
}


pub fn (mut cl Client) on(etype string, evthandler eventbus.EventHandlerFn) {
	get_subscriber().subscribe(etype, evthandler)
}

fn new_ws_client() Client {
	mut socket := websocket.new_client(socket_url) or { panic('Unable to connect') }
	mut cl := Client{
		ws: socket
		eb: bus
	}

	cl.ws.on_open_ref(openfn, &cl)
	cl.ws.on_message_ref(messagefn, &cl)
	cl.ws.on_close_ref(closefn, &cl)
	cl.ws.on_error_ref(errorfn, &cl)

	return cl
}

fn login(mut cl Client, bot bool, token string) {
	println('logging in')
	cl.token = token
	cl.bot = bot

	cl.ws.connect() or { panic('Failed to connect: $err') }

	mut auth_token := ''
	if cl.bot == true {
		auth_token = 'Bot $cl.token'
	} else {
		auth_token = cl.token
	}

	cl.ws.write_str('{"op": 2, "d": { "token": "$auth_token" }}') or {
		panic('Failed to authenticate: $err')
	}

	go cl.ws.listen()
	time.sleep(30)

	for {
		// Change this to try and reopen the client
		if cl.closed {
			return
		}
		time.sleep_ms(200)
		now := time.now().unix_time_milli()
		if now - cl.last_heartbeat > cl.heartbeat {
			cl.ws.write_str('{ "op": 3 }') or { panic('failed to send op: $err') }
			bus.publish('socket', cl, 'opcode 3 (heartbeat) was sent.')
			cl.last_heartbeat = now
		}
	}
}

//=== Websocket events ===

fn openfn(mut ws websocket.Client, mut cl Client) ? {
	bus.publish('socketopen', cl, none)
}

fn closefn(mut c websocket.Client, code int, reason string, mut cl Client) ? {
	cl.closed = true
	bus.publish('socketclose', cl, ClosedReason{
		code: code
		reason: reason
	})
}

fn messagefn(mut c websocket.Client, msg &websocket.Message, mut cl Client) ? {
	if msg.payload.len > 0 {
		mut packet := socket_msg_parse(msg) ?

		match packet.op {
			0 {
				match packet.e {
					'INIT_STATE' {
						// println( packet.d )
						ready_state_data := ready_state_parse(packet.d)
						// println( ptr_str(cl) )
						// println(x)

						bus.publish('ready', cl, ready_state_data)
					}
					'PRESENCE_UPDATE' {}
					'RELATIONSHIP_UPDATE' {}
					'MESSAGE_CREATE' {
						message_create_data := message_create_parse(packet.d, mut cl)
						bus.publish('message', cl, message_create_data)
					}
					'MESSAGE_DELETE' { bus.publish('msg_delete', cl, packet.d) }
					'MESSAGE_UPDATE' { bus.publish('msg_update', cl, packet.d) }
					'ROOM_CREATE' { bus.publish('room_created', cl, packet.d) }
					'ROOM_UPDATE' {}
					'ROOM_DELETE' {}
					'HOUSE_JOIN' { bus.publish('house_enter', cl, packet.d) }
					'HOUSE_LEAVE' { bus.publish('house_exit', cl, packet.d) }
					'HOUSE_MEMBER_JOIN' { bus.publish('member_join', cl, packet.d) }
					'HOUSE_MEMBER_EXIT' { bus.publish('member_leave', cl, packet.d) }
					'HOUSE_MEMBER_ENTER' {}
					'HOUSE_MEMBER_UPDATE' {}
					'HOUSE_MEMBERS_CHUNK' {}
					'BATCH_HOUSE_MEMBER_UPDATE' {}
					'HOUSE_ENTITY_UPDATE' {}
					'HOUSE_DOWN' { bus.publish('house_down', cl, packet.d) }
					'TYPING_START' { bus.publish('typing', cl, packet.d) }
					else { println('Event `$packet.e` not added') }
				}
			}
			1 {
				cl.heartbeat = packet.d['hbt_int'].str().u64()
			}
			2 {
				println('got 2')
			}
			3 {
				println('got 3')
			}
			4 {
				println('got 4')
			}
			5 {
				println('got 5')
			}
			6 {
				println('got 6')
			}
			7 {
				println('got 7')
			}
			8 {
				println('got 8')
			}
			else {
				println('Invalid opcode recived: $packet.op\nData: $packet.d')
			}
		}
	}
}

fn errorfn(mut ws websocket.Client, err string, mut cl Client) ? {
	bus.publish('error', cl, Error{ e: err })
}
*/