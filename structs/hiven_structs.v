module structs
import x.json2


pub struct User {
pub mut:
	username   string
	user_flags string
	name       string
	id         i64
	icon       string
	header     string
	bot        bool
}

pub fn (mut u User) from_json(j json2.Any) {
	je := j.as_map()
	u.username = je["username"].str()
	u.name = je["name"].str()
	u.id = je["id"].str().i64()
	u.icon = je["icon"].str()
	u.header = je["header"].str()
	u.user_flags = je["flags"].str()
}

pub struct Room {
	name string
	id   string
}

pub struct House {
pub mut:
	name  string
	id    string
	rooms []&Room
}

pub struct Mention {
pub:
	user_id string
}

pub struct Member {
pub mut:
	user_id                i64
	user                   User
	roles                  []Role
	presence               string // could be enum
	last_permission_update i64
	joined_at              string
}

pub fn (mut a Member) from_json(j json2.Any) {
	je := j.as_map()
	if je["user"].str() == "" {
		println("no user found, flat tree")
		a.user = User{}
		a.user.from_json(j)
		a.user_id = a.user.id
	} else {
		a.user = User{}
		println("USER")
		a.user.from_json(je["user"])
		a.presence = je["presence"].str()
		a.last_permission_update = je["last_permission_update"].str().i64()
		a.user_id = je["user_id"].str().i64()
	}
}


pub struct Role {
pub:
	id i64
}

pub struct PrivateRoom {
pub mut:
	room_id string
}

pub struct Presence {
pub mut:
	username   string
	user_flags string
	name       string
	id         string
	bot        string
	presence   string
}

pub struct HouseMembership {
pub mut:
	user_id                string
	roles                  string
	last_permission_update string
	joined_at              string
	house_id               string
}

pub struct Setting {
pub mut:
	setting string
}

pub struct Relationship {
pub mut:
	relation string
}

pub struct ReadState {
pub mut:
	message_id    string
	mention_count int
}

// Events
pub struct ReadyState {
pub mut:
	user              &User
	settings          &Setting
	relationships     &Relationship
	read_state        &ReadState
	private_rooms     []&PrivateRoom
	presences         &Presence
	house_memberships []&HouseMembership
	house_ids         []string
}

pub struct Message {
pub mut:
	timestamp     i64
	room_id       i64
	mentions      []Mention
	member        Member
	id            i64
	house_id      i64
	exploding_age i64
	exploding     bool
	device_id     i64
	content       string
}
pub fn (mut msg Message) from_json(f json2.Any) {
    obj := f.as_map()
	msg.content = obj["content"].str()
	msg.timestamp = obj["timestamp"].str().i64()
	msg.room_id = obj["room_id"].str().i64()
	msg.device_id = obj["device_id"].str().i64()
	msg.exploding = obj["exploding"].bool()
	msg.exploding_age = obj["exploding_age"].str().i64()
	msg.house_id = obj["house_id"].str().i64()
	msg.id = obj["id"].str().i64()
	if !(obj["member"] is json2.Null) { 
		// memb
		println("member")
		msg.member = json2.decode<Member>(obj["member"].json_str()) or { panic("Could not parse member") }
	} else {
		println("no member")
		msg.member = json2.decode<Member>(obj["author"].json_str()) or { panic("Could not parse member") } // this sets the author
	}
	// author should hopefully exist always, i will cry if it doesn't
	
}
/*
pub fn (mut msg Message) send(content string) {
	rest_send()
}
*/