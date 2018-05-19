/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Users : Codable {
	let user : Int?
	let accepted_at : Int?
	let name : String?
	let bio : String?
	let birthdate : Int?
	let job : String?
	let studies : String?
	let avatar : String?
	let second_avatar : String?
	let confirmed_at : Int?
	let liked_at : Int?
	let owner_reconfirm_at : Int?
	let user_reconfirm_at : Int?
	let superliked_at : Int?
	let hood : String?
	let city : String?
	let longitude : Double?
	let latitude : Double?

	enum CodingKeys: String, CodingKey {

		case user = "user"
		case accepted_at = "accepted_at"
		case name = "name"
		case bio = "bio"
		case birthdate = "birthdate"
		case job = "job"
		case studies = "studies"
		case avatar = "avatar"
		case second_avatar = "second_avatar"
		case confirmed_at = "confirmed_at"
		case liked_at = "liked_at"
		case owner_reconfirm_at = "owner_reconfirm_at"
		case user_reconfirm_at = "user_reconfirm_at"
		case superliked_at = "superliked_at"
		case hood = "hood"
		case city = "city"
		case longitude = "longitude"
		case latitude = "latitude"
	}


}
