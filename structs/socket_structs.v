module structs

import x.json2
import net.websocket

pub struct WSMessage {
pub mut:
	seq int
	op  int
	e   string
	d   map[string]json2.Any
}

pub fn parse_socket_message(message &websocket.Message) ?WSMessage {
	// websocket message content | byte array -> string | replace `$` with its hex because json2 doesnt like `$`
	mut payload := message.payload.bytestr().replace('$', '0x24')

	mut parsed_json := json2.raw_decode(payload) ?
	mut obj_map := parsed_json.as_map()
	
	mut msg := WSMessage{}

	msg.seq = obj_map['seq'].int()
	msg.op = obj_map['op'].int()
	msg.e = obj_map['e'].str()
	msg.d = obj_map['d'].as_map()

	return msg
}
// what even is this code for
// parsing of websocket packets should be handeled by a parsing module, or maybe a static method of the struct, if supported.
// structs.Message.parse(json data) -> Message
// or just the message constructor?
/*
// socket_msg_parse Parses a websocket message into a WSMessage
pub fn socket_msg_parse(msg &websocket.Message) ?&WSMessage {
	/*
	println('socket_msg_parse')
	
	test := json2.raw_decode(msg.payload.bytestr())?

	mut jdata := test.as_map()
    mut opcode := jdata['op'].int()
	mut data := jdata['d'].str()
    
	println(' $test , $jdata , $opcode $data ')
	*/
	mut msg_pay_str := msg.payload.bytestr().replace('$', '0x24')
	mut new_msg := &WSMessage{}

	mut obj := json2.raw_decode(msg_pay_str) ?
	mut obj_map := obj.as_map()

	new_msg.seq = obj_map['seq'].int()
	new_msg.op = obj_map['op'].int()
	new_msg.e = obj_map['e'].str()
	new_msg.d = obj_map['d'].as_map()

	return new_msg
}

// ready_state_parse Parses the websocket INIT_STATE event JSON
pub fn ready_state_parse(data map[string]json2.Any) ReadyState {
	ready_state := ReadyState{
		user: User{}
		settings: Setting{}
		relationships: Relationship{}
		read_state: ReadState{}
		private_rooms: [PrivateRoom{}]
		presences: Presence{}
		house_memberships: [HouseMembership{}]
		house_ids: ['hello']
	}

	return ready_state
}

// message_create_parse Parses the websocket MESSAGE_CREATE event JSON
pub fn message_create_parse(data map[string]json2.Any, mut client &Client) Message {
	mut message := Message{}

	message.timestamp = data['timestamp'].str()
	message.room_id = data['room_id'].str()
	message.mentions = [Mention{}]
	message.member = Member{
		user: User{}
		roles: [Role{}]
	}
	message.id = data['id'].str()
	message.house_id = data['house_id'].str()
	if typeof(data['exploding_age']).name == 'int' {
		message.exploding_age = data['exploding_age'].int()
	} else {
		message.exploding_age = 0
	}
	message.exploding = data['exploding'].bool()
	message.device_id = data['device_id'].str()
	message.content = data['content'].str()
	message.bucket = data['bucket'].int()
	message.author_id = data['author_id'].str()
	message.author = Author{}

	return message
}




// socket_msg_create Is an unused function you shouldn't worry about
pub fn socket_msg_create(opcode int, data string) string {
	mut new_msg := map[string]json2.Any{}
	new_msg['op'] = opcode
	new_msg['d'] = data

	return new_msg.str()
}

// makeopcode Is an unused function you shouldn't worry abCreates the json to send to server
fn makeopcode(opcode int, data map[string]json2.Any) string {
	mut inst := map[string]json2.Any{}
	inst['op'] = opcode
	inst['d'] = data
	return inst.str()
}
*/