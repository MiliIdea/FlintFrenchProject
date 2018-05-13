/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Message_list : Codable {
	let id : Int?
	let user : Int?
	let created_at : Int?
	let seen : Int?
	let seen_at : Int?
	let answer : String?
	let target : Int?
	let target_name : String?
	let target_avatar : String?
	let user_avatar : String?
	let user_name : String?
	let answered_at : Int?
	let type : Int?
	let status : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user = "user"
		case created_at = "created_at"
		case seen = "seen"
		case seen_at = "seen_at"
		case answer = "answer"
		case target = "target"
		case target_name = "target_name"
		case target_avatar = "target_avatar"
		case user_avatar = "user_avatar"
		case user_name = "user_name"
		case answered_at = "answered_at"
		case type = "type"
		case status = "status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		user = try values.decodeIfPresent(Int.self, forKey: .user)
		created_at = try values.decodeIfPresent(Int.self, forKey: .created_at)
		seen = try values.decodeIfPresent(Int.self, forKey: .seen)
		seen_at = try values.decodeIfPresent(Int.self, forKey: .seen_at)
		answer = try values.decodeIfPresent(String.self, forKey: .answer)
		target = try values.decodeIfPresent(Int.self, forKey: .target)
		target_name = try values.decodeIfPresent(String.self, forKey: .target_name)
		target_avatar = try values.decodeIfPresent(String.self, forKey: .target_avatar)
		user_avatar = try values.decodeIfPresent(String.self, forKey: .user_avatar)
		user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
		answered_at = try values.decodeIfPresent(Int.self, forKey: .answered_at)
		type = try values.decodeIfPresent(Int.self, forKey: .type)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
	}

}