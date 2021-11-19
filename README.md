> **vhiven** - Hiven bot/self bot/api module for V  
> **Status** - Remaking this because we like pain

# vhiven
Hiven bot/self bot/api module for V.  

This module _should_ function now, but it is buggy.  

### Current Stage
Keeps a connection with the websocket now and should authenticate.  
Trying to get the module part of the module to work, else it wouldn't be a module : )  


### To Do
- [x] Keep a connection to the websocket
- [ ] Add the ability to send messages
- [ ] Add rest api functions
- [ ] Parse all events


## Example
This is only a reference and may not be the actual structure  
For the most up to date example go to [example.v](/testing/example.v)  

```v
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
```

### Help
Get help and info on my [Discord server](https://discord.gg/PSNKV6EB9A) or [Hiven house](https://hiven.house/4kjf9j)


## Maintainers
- [Insberr](https://github.com/insberr/)
- [Wackery](https://github.com/webmsgr/)


## License
**vhiven** is released under the GPL-3.0 License. Read [here](/LICENSE) for more information.
