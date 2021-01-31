module rest

import net.http

pub fn send(room_id string, content string, token string) {
	mut res := http.post_json('https://api.hiven.io/v1/rooms/$room_id/messages',
		'{"headers": {"Authorization": "$token"},"body": {"content":"$content"}}') or { return }
	println(res)
}

pub fn test() {
	println('rest tested (not really)')
}
