module structs

import x.json2
import x.websocket

pub struct WSMessage {
pub mut:
	op int
	d json2.Any
}

fn makeopcode(opcode int, data map[string]json2.Any) string { // Creates the json to send to server
	mut inst := map[string]json2.Any
	inst['op'] = opcode
	inst['d'] = data
	return inst.str()
}

// Parses websocket message into a string
pub fn socket_msg_parse(msg &websocket.Message) ?&WSMessage {
	/*
	println('socket_msg_parse')
	
	test := json2.raw_decode(msg.payload.bytestr())?

	mut jdata := test.as_map()
    mut opcode := jdata['op'].int()
	mut data := jdata['d'].str()
    
	println(' $test , $jdata , $opcode $data ')
	*/
	mut new_msg := &WSMessage{}

	mut obj := json2.raw_decode(msg.payload.bytestr())?
	mut msg_obj := obj.as_map()
	
    for k, v in msg_obj {
        match k {
            'op' { new_msg.op = v.int() }
            'd' { new_msg.d = v }
            else {}
        }
    }
	
	return new_msg
}

pub fn socket_msg_create(opcode int, data string) string {
	mut new_msg := map[string]json2.Any
	new_msg['op'] = opcode
	new_msg['d'] = data

	return new_msg.str()
}

pub fn login(token string) string {
	mut data := map[string]json2.Any
	data["token"] = token
	return makeopcode(2,data)
} // calling opcodes.login(token) will create a login opcode

