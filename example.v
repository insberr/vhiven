import insberr.vhiven

// This file is not meant to be run in the module itself

mut client := vhiven.new_client()

client.bot = false // tells the module that this is being used for a self bot

client.on('ready', fn () {
	println('ready!')
})

client.on('someevent', fn (eventargs) {
	// Do something
	println('hi')
}) 

client.login('TOKEN')


