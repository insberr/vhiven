# Rest API Docs

Taken from [here](https://github.com/FrostbyteSpace/easyhiven.js/blob/main/TODO.md) and [here](https://github.com/hivenapp/hiven.js/tree/master/lib)

# Basics

Endpoint: https://api.hiven.io/v1

# Headers

The authorization header is set to your token

# TODO
Add return format stuff (what does each endpoint return?)

# API

## Houses
### POST /houses 
creates a house 
- name: string
- icon: base64
### DELETE /houses/:id 
deletes a house
### PATCH /houses/:id 
edit a house
- name: string
- icon: base64 
### POST /houses/:id/entities
adds an entity (only category so far) 
- name: string
- type: int 
    - 1: Category
### DELETE /houses/:id/entities/:id 
deletes a category, has to be empty

### POST /houses/:id/invites 
creates an invite 
- max_uses: int
- max_age: int (most likely unix time but not sure)
### GET /invites/:code 
fetches an invite
### POST /invites/:code 
uses an invite

## Rooms
### POST /houses/:id/rooms 
creates a room 
- name: string
- parent_entity_id?(category/house): string 
### DELETE /houses/:id/rooms/:id 
deletes a room

### POST /rooms/:id/typing 
starts typing in a room
### POST /rooms/:id/call 
start a call
### POST /rooms/:id/call/decline
decline a call 
### PUT /rooms/:id/recipients/:id
adds a user to a group DM

## messages
### POST /rooms/:id/media_messages
creates an attachment message 
- form { file: named file }
### POST /rooms/:id/messages 
creates a text message 
- content: string
### DELETE /rooms/:id/messages/:id 
deletes a message
### PATCH /rooms/:id/messages/:id 
edits a message 
- content: string
### GET /rooms/:id/messages 
gets messages from a room  
- ?before=id (Query string param)
### DELETE /houses/:id/rooms/:id/messages/:id 
deletes a house message
### POST /rooms/:id/messages/:id/ack 
mark as read, probably
ack = short for acknowledge? 

## Users
### GET /users/:@username 
gets an account
### GET /relationships/:id/mutual-friends 
gets your mutual friends with an account

## \@me
### PATCH /users/@me 
edits your account 
- bio: string
- name: string
- icon: base64?
- header: base64?
- location: string
- website: string
### GET /users/@me 
gets your account
### GET /streams/@me/mentions 
gets your mentions
### GET /streams/@me/feed 
gets your feed
### POST /users/@me/rooms 
adds a DM room 
- recipient: string
### POST /users/@me/rooms 
adds a group DM room 
- recipients: string[]
### DELETE /users/@me/houses/:id 
leaves a house
### DELETE /users/@me/rooms/:id 
leaves a group DM
### DELETE /relationships/@me/friends/:id 
unfriends someone
### GET /relationships/@me/friends 
get your friends
### POST /relationships/@me/friend-requests 
sends a friend request to someone 
- user_id: string
### DELETE /relationships/@me/friend-requests/:id 
cancels a friend request
### GET /relationships/@me/friend-requests 
get your current friend requests
### PUT /relationships/@me/blocked/:id 
blocks a user
### DELETE /relationships/@me/blocked/:id 
unblocks a user
### PUT relationships/@me/restricted/:id 
restricts a user
### DELETE relationships/@me/restricted/:id 
unrestricts a user?
### PUT /users/@me/settings/room_overrides/:id 
changes room settings
- notification_preference: int
    - 0: all
    - 1: mentions
    - 2: none




