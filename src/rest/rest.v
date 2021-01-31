module vhiven

import net.http

fn rest_send(client Client, room_id string, content string) ? {
	mut res := http.post_json('https://api.hiven.io/v1/rooms/$room_id/messages', '{"headers": {"Authorization": "$rest.client.token"},"body": {"content":"$content"}}') ?
	println(res)
}
