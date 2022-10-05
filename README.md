> **vhiven** - Hiven bot/self bot/api module for V  
> **Status** - Getting the actual v module part to work

# vhiven
**Unfortunatly Hiven no longer exists, an this is no longer maintained**
Hiven bot/self bot/api module for V.  

This module _should_ function now, but it is buggy.  

### Current Stage
Keeps a connection with the websocket now and should authenticate.  
Trying to get the module part of the module to work, else it wouldn't be a module : )  


### To Do
- [x] Keep a connection to the websocket
- [] Add rest api functions
- [] Parse all events


## Example
This is only a reference and may not be the actual structure  
For the most up to date example go to [example.v](/testing/example.v)  
For the current structure go to [test_websocket.v](/testing/test_websocket.v)

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
