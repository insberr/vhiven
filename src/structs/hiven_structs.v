module structs

pub struct User {
pub mut:
	username string
	id string
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

pub struct Message {
pub mut:
	content string
	user &User
	house &House
	room &Room
}
