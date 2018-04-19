/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct LoginRes : Codable {
	let id : Int?
	let username : String?
	let token : String?
	let email : String?
	let name : String?
	let gender : String?
	let status : Int?
	let avatar : String?
	let second_avatar : String?
	let selfie : String?
	let looking_for : Int?
	let new_pin_notif : Bool?
	let lighter : Bool?
	let invite_accepted_notification : Bool?
	let message_notification : Bool?
	let vibration : Bool?
	let sounds : Bool?
	let min_age : Int?
	let max_age : Int?
	let birthdate : Int?
    let bio : String?
    let job : String?
    let studies : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case username = "username"
		case token = "token"
		case email = "email"
		case name = "name"
		case gender = "gender"
		case status = "status"
		case avatar = "avatar"
		case second_avatar = "second_avatar"
		case selfie = "selfie"
		case looking_for = "looking_for"
		case new_pin_notif = "new_pin_notif"
		case lighter = "lighter"
		case invite_accepted_notification = "invite_accepted_notification"
		case message_notification = "message_notification"
		case vibration = "vibration"
		case sounds = "sounds"
		case min_age = "min_age"
		case max_age = "max_age"
		case birthdate = "birthdate"
        case bio = "bio"
        case job = "job"
        case studies = "studies"
	}

}
