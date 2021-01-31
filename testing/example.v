module main

import insberr.vhiven
import zztkm.vdotenv

// This file is not meant to be run in the module itself

fn main() {
	vdotenv.load()
    bot_token := os.getenv('TOKEN')

	mut client := vhiven.new_client()

	client.cl.on('ready', fn (recvr voidptr, data &vhiven.ReadyState, cl &vhiven.Client) {
		println('ready')
	})

	client.cl.on('message', fn (recvr voidptr, msg &vhiven.Message, cl &vhiven.Client) {
		println(msg.content)
	})
	
	client.cl.on('error', fn (recvr voidptr, error &vhiven.Error, cl &vhiven.Client) {
		println('error: $error.e')
	})

	client.login(bot_token)
}
