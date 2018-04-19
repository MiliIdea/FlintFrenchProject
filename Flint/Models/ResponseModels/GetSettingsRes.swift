/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct GetSettingsRes : Codable {
	let looking_for : Int?
	let new_pin_notif : Bool?
	let lighter : Bool?
	let invite_accepted_notification : Bool?
	let message_notification : Bool?
	let vibration : Bool?
	let sounds : Bool?
	let min_age : Int?
	let max_age : Int?

	enum CodingKeys: String, CodingKey {

		case looking_for = "looking_for"
		case new_pin_notif = "new_pin_notif"
		case lighter = "lighter"
		case invite_accepted_notification = "invite_accepted_notification"
		case message_notification = "message_notification"
		case vibration = "vibration"
		case sounds = "sounds"
		case min_age = "min_age"
		case max_age = "max_age"
	}

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        looking_for = try values.decodeIfPresent(Int.self, forKey: .looking_for)
//        new_pin_notif = try values.decodeIfPresent(Bool.self, forKey: .new_pin_notif)
//        lighter = try values.decodeIfPresent(Bool.self, forKey: .lighter)
//        invite_accepted_notification = try values.decodeIfPresent(Bool.self, forKey: .invite_accepted_notification)
//        message_notification = try values.decodeIfPresent(Bool.self, forKey: .message_notification)
//        vibration = try values.decodeIfPresent(Bool.self, forKey: .vibration)
//        sounds = try values.decodeIfPresent(Bool.self, forKey: .sounds)
//        min_age = try values.decodeIfPresent(Int.self, forKey: .min_age)
//        max_age = try values.decodeIfPresent(Int.self, forKey: .max_age)
//    }

}
