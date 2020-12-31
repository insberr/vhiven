> **vhiven** - Hiven bot/self bot/api module for V  
> **Status** - Slow but somehow getting there  

# vhiven
Hiven bot/self bot/api module for V

This module does not function yet. It is still in the very early development stages  

### Current Stage
Successfully got it to login, but I need it to keep the connection  
Somewhat parses messages from the MESSAGE_CREATE event  


### To Do
- [] Keep a connection to the websocket
- [] Add rest api functions


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
Get help and info on my [Discord server](https://discord.gg/PSNKV6EB9A) or [Hiven house](https://hiven.house/4kjf9j)


## Maintainers
- [Insberr](https://github.com/insberr/)
- [Wackery](https://github.com/webmsgr/)


## License
**vhiven** is released under the GPL-3.0 License. Read [here](/LICENSE) for more information.
