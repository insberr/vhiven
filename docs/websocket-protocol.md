**Please refer to this repo's wiki, [here](https://github.com/insberr/vhiven/wiki/Hiven-WebSocket-Docs) for the most up to date docs**



# Hiven websocket protocol
Based on [this](https://github.com/hivenapp/hiven.js/blob/master/lib/)

# Basics

The websocket protocol uses json as its medium
The json is seperated into two parts:

* The opcode
* The data (optional)

The json data looks like this
```json
{ "op": 0, "d": { "arg1": "val1", "arg2": "val2" } }
```
NOTE: There are multiple urls for sending data too, most of the time its `wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json` however for some it uses `wss://us-east1-rtc-staging.hiven.io` (most likely the second url is for voice stuff, idk)
The WS object in the source code ([this](https://github.com/hivenapp/hiven.js/blob/master/lib/Websocket/index.ts#L15)) always connects to the first one

# TODO
Add descriptions and arguments to the events

# Known opcodes

## Client -> Server

### Opcode 2
Login, sent after connection

**User account**
```json
{ "op": 2, "d": { "token": "USER_TOKEN" } }
```

**Bot account**
```json
{ "op": 2, "d": { "token": "Bot BOT_TOKEN" } }
```


### Opcode 3
Heartbeat response. Send this in response to op 1

```json
{ "op": 3 }
```


### Opcode 4
Sent to obtain a "voice token" [ref](https://github.com/hivenapp/hiven.js/blob/9095720105152b720dde799c9aa2afdc91caef92/lib/Collections/Room.ts#L110)


### Opcode 5
Connect/Disconnect from a voice? 


#### Arguments
* room_id: null / a room id (null = disconnect)
* muted: Bool, weather you are muted


### Opcode 7
Request House Members, you can use this to request a chunk of house members
```json
{
  "op": 7,
  "d": {
    "house_id": "string",
    "user_ids": "string[]"
  }
}
```


### Opcode 8
Voice chat heartbeat???


## Server -> Client Events
These events use a different format to the opcodes
```json
{
	"seq": 12, // I have no clue what this number is for
	"op": 0,
    "e": "event", // Event 
    "d": "data" // data
}
```
see [here](https://github.com/hivenapp/hiven.js/blob/master/lib/Client.ts#L85)


### INIT_STATE
TODO
### ROOM_CREATE
TODO
### ROOM_UPDATE
TODO
### ROOM_DELETE
TODO

### MESSAGE_CREATE
Example
```json
{
	"timestamp": 1.609373513434e+12,
	"room_id": "186895456276575850",
	"mentions": [],
	"member": {
		"user_id": "180209587218018563",
		"user": {
			"username": "insberr",
			"user_flags": "0",
			"name": "Insberr",
			"id": "180209587218018563",
			"icon": "c85c66ceaa5cef0a5828aca83982d2b891c7bffe.png",
			"header": "0c9e5f01e82bff9dacefddc35b31827287fd5300.png",
			"bot": false
		},
		"roles": null,
		"presence": "online",
		"last_permission_update": null,
		"joined_at": "2020-11-16T15:16:48.283Z",
		"id": "180209587218018563",
		"house_id": "180337488663933943"
	},
	"id": "196417215514276050",
	"house_id": "180337488663933943",
	"exploding_age": null,
	"exploding": false,
	"device_id": "196398509589525017",
	"content": "test",
	"bucket": 54,
	"author_id": "180209587218018563",
	"author": {
		"username": "insberr",
		"user_flags": "0",
		"name": "Insberr",
		"id": "180209587218018563",
		"icon": "c85c66ceaa5cef0a5828aca83982d2b891c7bffe.png",
		"header": "0c9e5f01e82bff9dacefddc35b31827287fd5300.png"
	}
}
```


### MESSAGE_UPDATE
TODO
### MESSAGE_DELETE
TODO
### TYPING_START
TODO
### HOUSE_JOIN
TODO
### HOUSE_MEMBER_JOIN
TODO
### HOUSE_MEMBER_LEAVE
TODO
### CALL_CREATE
TODO 
### PRESENCE_UPDATE
TODO
### HOUSE_MEMBERS_CHUNK
TODO
### BATCH_HOUSE_MEMBER_UPDATE
TODO