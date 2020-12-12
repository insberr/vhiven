module eventbus

import eventbus

pub struct USER {
	username string
	user_flags int
	name string
	id int
	bot bool
}

pub struct READ_STATE {
	message_id int
	mention_count int
}

pub struct INIT_STATE_EVENT {
	user USER
	read_state map[string]READ_STATE
}
