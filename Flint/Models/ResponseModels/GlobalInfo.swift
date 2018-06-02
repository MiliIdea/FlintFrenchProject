/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct GlobalInfo : Codable {
	let title : String?
	let emoji : String?
	let image : String?
	let location_lng : String?
	let location_lat : String?
	let type : Int?
	let status : Int?
	let people_count : Int?
	let exact_time : Int?
	let available_at : Int?
	let created_at : Int?
	let when : Int?
	let owner : Int?
	let owner_name : String?
	let owner_birth : Int?
	let owner_bio : String?
	let owner_studies : String?
	let owner_job : String?
	let owner_avatar : String?
	let owner_second_avatar : String?
	let owner_x : String?
	let owner_y : String?
	let owner_city : String?
	let owner_hood : String?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case emoji = "emoji"
		case image = "image"
		case location_lng = "location_lng"
		case location_lat = "location_lat"
		case type = "type"
		case status = "status"
		case people_count = "people_count"
		case exact_time = "exact_time"
		case available_at = "available_at"
		case created_at = "created_at"
		case when = "when"
		case owner = "owner"
		case owner_name = "owner_name"
		case owner_birth = "owner_birth"
		case owner_bio = "owner_bio"
		case owner_studies = "owner_studies"
		case owner_job = "owner_job"
		case owner_avatar = "owner_avatar"
		case owner_second_avatar = "owner_second_avatar"
		case owner_x = "owner_x"
		case owner_y = "owner_y"
		case owner_city = "owner_city"
		case owner_hood = "owner_hood"
	}


}
