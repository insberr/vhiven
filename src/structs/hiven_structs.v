module structs

pub struct User {
pub:
	username   string
	user_flags string
	name       string
	id string
	icon string
	header string
	bot bool
}

pub struct Room {
	name string
	id string
}

pub struct House {
pub mut:
	name string
	id string
	rooms []&Room
}

pub struct Mention {
pub:
	user_id string
}

pub struct Member {
pub:
	user_id string
	user &User
	roles []&Role
	presence string
	last_permission_update string
	joined_at string
	id string
	house_id string
}

pub struct Author {
pub:
	username string
	user_flags string
	name string
	icon string
	header string
}

pub struct Role {
pub:
	id string
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
	user_id   string
	roles     string
	last_permission_update string
	joined_at string
	house_id  string
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
	message_id string
	mention_count int
}

// Events
pub struct Init {
pub mut:
	user           &User
	settings       map[string]&Setting
	relationships  map[string]&Relationship
	read_state     map[string]&ReadState
	private_rooms  []&PrivateRoom
	presences      map[string]&Presence
	house_memberships map[string]&HouseMembership
	house_ids      []string
}

pub struct Message {
pub:
	timestamp string
	room_id   string
	mentions  []&Mention
	member    &Member
	id        string
	house_id  string
	exploding_age int
	exploding bool
	device_id string
	content   string
	bucket    int
	author_id string
	author    &Author
}




