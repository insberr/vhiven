module opcodes
import x.json2

fn makeopcode(opcode int, data map[string]json2.Any) string { // Creates the json to send to server
	mut inst := map[string]json2.Any
	inst['op'] = opcode
	inst['data'] = data
	return inst.str()
}

pub fn login(token string) string {
	mut data := map[string]json2.Any
	data["token"] = token
	return makeopcode(2,data)
} // calling opcodes.login(token) will create a login opcode

