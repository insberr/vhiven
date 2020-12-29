> **vhiven** - Hiven bot/self bot/api module for V  
> **Status** - Progress haulted until Hiven has api/websocket docs  

# vhiven
Hiven bot/self bot/api module for V

Currently this module does not function. It is still in the very early development stages  

### Current Stage
_Could almost say its in v0.0.1_
Got the connection to the websocket and the eventbus to work  
Next is to login and keep a connection to the websocket, and parse the data sent to json


## Example
This is only a reference and may not be the actual structure  
For the most up to date example go to [example.v](/example.v)  
For the current structure go to [test_websocket.v](/test_websocket.v)

```v
module main

import insberr.vhiven

fn main() {
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
}
```

### Help
Get help and info on my development [Discord server](https://discord.gg/PSNKV6EB9A) or [Hiven house](https://hiven.house/4kjf9j)


## Maintainers
- [Insberr](https://github.com/insberr/)
- [Wackery](https://github.com/webmsgr/)


## License
**vhiven** is released under the GPL-3.0 License. Read [here](/LICENSE) for more information.
