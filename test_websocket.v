// Language: V
module main

import net.websocket
import zztkm.vdotenv
import os
import x.json2
import time
// wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json

const hiven_endpoint = "wss://swarm.hiven.io/socket?encoding=json&compression=text_json"

fn main() {
	vdotenv.load()
	bot_token := os.getenv('INSBERR_TOKEN')

	// let's connect to the websocket in vlang
	mut websocket := websocket.new_client(hiven_endpoint) or { panic("Could not connect to websocket") }
	websocket.connect() or { panic("Could not connect to websocket on connect") }
	websocket.on_message(on_message) 
	go websocket.listen() // or { panic("Uh oh") }
	login(mut websocket, bot_token) or { panic("Uh oh no login cringe") }

	mut last_heartbeat := time.now().unix_time_milli()
	println(last_heartbeat)
	for {
		if time.now().unix_time_milli() - last_heartbeat > 30000 {
			last_heartbeat = time.now().unix_time_milli()
			websocket.write_string('{ "op": 3 }')?
			println("Sent heartbeat")
		}
	}
}

// login to the websocket
fn login(mut c websocket.Client, auth_token string) ? {
	println("Logging in...")
	c.write_string('{"op": 2, "d": { "token": "$auth_token" }}')? // dont actually send this
	c.write_string('{ "op": 3 }')?
}


fn on_message(mut c websocket.Client, msg &websocket.Message) ? {
	mut payload := msg.payload.bytestr().replace('$', '0x24')
	println("Packet: " + payload)
	cringe := json2.raw_decode(payload)?
	packet := cringe.as_map()
	op := packet["op"].int() // packet opcode
	println("Cringe Packet ID: $op")
	// message is a struct containing a .payload field which is []byte
	// we need to convert it to a string
}


/*
import client
import structs as s
import os
import zztkm.vdotenv
import x.json2

fn main() {
	vdotenv.load()

    bot_token := os.getenv('TOKEN')
    
	mut cl := client.new_client()
	cl.bot = false

	cl.on('ready', fn (recvr voidptr, args voidptr, client &client.Client) {
		println('test: ready')
	})

	cl.on('open', fn (recvr voidptr, args voidptr, cl &client.Client) {
		println('test: websocket open')
	})

	cl.on('close', fn (recvr voidptr, reason &client.ClosedReason, cl &client.Client) {
		println('test: websocket closed. Reason: $reason.reason, code: $reason.code')
	})
	
	cl.on('error', on_error)

	cl.on('message', fn (recvr voidptr, msg &s.Message, cl &client.Client) {
		println(msg.content)
	})

	cl.login(true, bot_token)
	// cl.run()
	//ws.login(wstest,"token goes here")
}


fn on_error(recvr voidptr, err voidptr, client &client.Client) {
	println(err)
}
*/