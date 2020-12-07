# Hiven websocket protocol
Based on [this](https://github.com/hivenapp/hiven.js/blob/master/lib/)

# Basics

The websocket protocol uses json as its medium
The json is seperated into two parts:

NOTE: There are multiple urls for sending data too, most of the time its `wss://swarm-dev.hiven.io/socket?encoding=json&compression=text_json` however for some it uses `wss://us-east1-rtc-staging.hiven.io` (most likely the second url is for voice stuff, idk)

* The opcode
* The data (optional)

The json data looks like this
```json
{"op":0, "data":{"arg1":"val1","arg2":"val2"}}
```

# Known opcodes

## Client -> Server

### Opcode 2
Most likely login

#### Arguments:
* token: A token


### Opcode 3
Heartbeat, looks like response to server heartbeat

### Opcode 4
Sent to obtain a "voice token" [ref](https://github.com/hivenapp/hiven.js/blob/9095720105152b720dde799c9aa2afdc91caef92/lib/Collections/Room.ts#L110)

#### Arguments
An id, most likely for the voice token.

### Opcode 5
Connect/Disconnect from a voice? 

#### Arguments
* room_id: null / a room id (null = disconnect)
* muted: Bool, weather you are muted

### Opcode 8
Voice chat heartbeat???


## Server -> Client

### Opcode 1
Heartbeat ping, also sets the interval in which heartbeats are sent
