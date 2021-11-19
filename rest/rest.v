module rest

import net.http

import net.http

const api = 'https://api.hiven.io/v1'


pub fn rest_new_request(token string, method http.Method, path string) ?http.Request {
	mut req := http.new_request(method, api + path, '') ?
	req.add_header('Authorization', '$token')
	return req
}

fn rest_send(client Client, room_id string, content string) ? {
	mut res := http.post_json('https://api.hiven.io/v1/rooms/$room_id/messages', '{"headers": {"Authorization": "$rest.client.token"},"body": {"content":"$content"}}') ?
	println(res)
}
