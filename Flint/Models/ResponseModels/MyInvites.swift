/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct MyInvites : Codable , Equatable{
    static func ==(lhs: MyInvites, rhs: MyInvites) -> Bool {
       
        return lhs.invite_id ?? lhs.id == rhs.invite_id ?? rhs.id
        
    }


	let invite_id : Int?
    let id : Int?
	let liked_at : Int?
	let available_at : Int?
	let superliked_at : Int?
    let superliked : Int?
	let confirm : Int?
	let accepted_at : Int?
	let confirmed_at : Int?
	let title : String?
	let emoji : String?
	let image : String?
	let type : Int?
	let people_count : Int?
	let exact_time : Int?
	let when : Int?
	let owner : Int?
	let owner_name : String?
	let owner_bio : String?
	let owner_avatar : String?
    let owner_seocond_avatar : String?
	let owner_job : String?
	let owner_age : Int?
    let age : Int?
	let owner_birthdate : Int?
	let owner_studies : String?
	let status : Int?
	let longitude : String?
	let latitude : String?
	let owner_gender : String?
    let gender : String?

	enum CodingKeys: String, CodingKey {

		case invite_id = "invite_id"
        case id = "id"//
		case liked_at = "liked_at"
		case available_at = "available_at"
		case superliked_at = "superliked_at"//
        case superliked = "superliked"
		case confirm = "confirm"
		case accepted_at = "accepted_at"
		case confirmed_at = "confirmed_at"
		case title = "title"
		case emoji = "emoji"
		case image = "image"
		case type = "type"
		case people_count = "people_count"
		case exact_time = "exact_time"
		case when = "when"
		case owner = "owner"
		case owner_name = "owner_name"
		case owner_bio = "owner_bio"
		case owner_avatar = "owner_avatar"
        case owner_seocond_avatar = "owner_seocond_avatar"
		case owner_job = "owner_job"
		case owner_age = "owner_age"
        case age = "age"//
		case owner_birthdate = "owner_birthdate"
		case owner_studies = "owner_studies"
		case status = "status"
		case longitude = "longitude"
		case latitude = "latitude"
		case owner_gender = "owner_gender"
        case gender = "gender"//
	}

}
