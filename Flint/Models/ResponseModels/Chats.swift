/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Chats : Codable {
	let id : Int?
	let channel : String?
	let created_at : Int?
	let last_message : String?
	let last_message_at : Int?
	let user : Int?
	let target : Int?
	let target_name : String?
	let target_avatar : String?
	let user_avatar : String?
	let user_name : String?
	let last_message_type : Int?
	let last_seen : Int?
	let last_seen_at : Int?
	let type : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case channel = "channel"
		case created_at = "created_at"
		case last_message = "last_message"
		case last_message_at = "last_message_at"
		case user = "user"
		case target = "target"
		case target_name = "target_name"
		case target_avatar = "target_avatar"
		case user_avatar = "user_avatar"
		case user_name = "user_name"
		case last_message_type = "last_message_type"
		case last_seen = "last_seen"
		case last_seen_at = "last_seen_at"
		case type = "type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		channel = try values.decodeIfPresent(String.self, forKey: .channel)
		created_at = try values.decodeIfPresent(Int.self, forKey: .created_at)
		last_message = try values.decodeIfPresent(String.self, forKey: .last_message)
		last_message_at = try values.decodeIfPresent(Int.self, forKey: .last_message_at)
		user = try values.decodeIfPresent(Int.self, forKey: .user)
		target = try values.decodeIfPresent(Int.self, forKey: .target)
		target_name = try values.decodeIfPresent(String.self, forKey: .target_name)
		target_avatar = try values.decodeIfPresent(String.self, forKey: .target_avatar)
		user_avatar = try values.decodeIfPresent(String.self, forKey: .user_avatar)
		user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
		last_message_type = try values.decodeIfPresent(Int.self, forKey: .last_message_type)
		last_seen = try values.decodeIfPresent(Int.self, forKey: .last_seen)
		last_seen_at = try values.decodeIfPresent(Int.self, forKey: .last_seen_at)
		type = try values.decodeIfPresent(Int.self, forKey: .type)
	}

}