// Language: V
module main
import os
import zztkm.vdotenv
import structs
import client

fn main() { 
	vdotenv.load()
	bot_token := os.getenv('INSBERR_TOKEN')
	mut cl := client.create_client(false)
	cl.on_message = on_message
	cl.run(bot_token) or {}

}

fn on_message(msg structs.Message, mut cl client.Client) {
	println("In Onmessage in the client!")
	if msg.member.user.name != "insbit" {
		println("Sending gamer message")
		cl.send_message("Hello $msg.member.user.name! You said '$msg.content'", msg.room_id) or { panic("failure!") }
	}
}
/*
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
	
	/*
		// idk what happened with this in the conflicts
		wsm := structs.parse_socket_message(msg)?
		println("Cringe packet id: $wsm.op")
	*/
}
*/

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