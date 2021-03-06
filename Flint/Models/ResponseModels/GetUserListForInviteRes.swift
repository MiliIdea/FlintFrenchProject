/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct GetUserListForInviteRes : Codable {
	var st_x : String?
	var st_y : String?
	var name : String?
	var gender : String?
	var avatar1 : String?
	var avatar2 : String?
	var birthdate : Int?
	var job : String?
	var studies : String?
	var bio : String?
	var id : Int?
	var updated_at : Int?

	enum CodingKeys: String, CodingKey {

		case st_x = "st_x"
		case st_y = "st_y"
		case name = "name"
		case gender = "gender"
		case avatar1 = "avatar1"
		case avatar2 = "avatar2"
		case birthdate = "birthdate"
		case job = "job"
		case studies = "studies"
		case bio = "bio"
		case id = "id"
		case updated_at = "updated_at"
	}
    
    init() {
        
    }

}
