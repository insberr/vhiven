module main

import insberr.vhiven

// This file is not meant to be run in the module itself

fn main() {
	mut client := vhiven.new_client()

	client.bot = false // tells the module that this is being used for a self bot

	client.on('ready', fn (client &vhiven.Client) {
		println('ready!')
	})

	client.on('message', fn (client &vhiven.Client, msg &vhiven.Message) {
		// Do something
		println('hi')
	}) 

	client.login('TOKEN')
}
