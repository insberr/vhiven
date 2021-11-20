module rest

import net.http

const api = 'https://api.hiven.io/v1'


/*
pub fn rest_new_request(token string, method http.Method, path string) ?http.Response {
	mut req := http.new_request(method, api + path, '') ?
	req.add_custom_header('Authorization', '$token')?
	return req.do()
}
*/
//fn rest_send(client Client, room_id string, content string) ? {

pub fn rest_send(token string, room_id string, content string)? {
	//mut res := http.post_json('https://api.hiven.io/v1/rooms/$room_id/messages', '{"headers": {"Authorization": "$token","Content-Type": "application/json"},"body": {"content":"$content"}}') ?
	//mut res := rest_new_request(token, http.Method.post, '/rooms/$room_id/messages') ?
	mut req := http.new_request(http.Method.post, api + '/rooms/$room_id/messages', '') ?
	req.add_custom_header('Authorization', token)?
	req.add_custom_header('Content-Type', "application/json")?
	req.data = '{"content":"$content"}'
	mut res := req.do()?
	println(res)
}

/*
fetch('https://api.hiven.io/v1/rooms/313544106225695554/messages', {
	method:'POST',
	headers:{
		'Content-Type':'application/json',
		Authorization:window.localStorage.getItem('hiven-auth')},
		body:JSON.stringify({content:'bot name'})
	})
*/