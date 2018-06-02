/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Pending_list : Codable {
    let user : Int?
    let user_name : String?
    let user_avatar : String?
    let user_second_avatar : String?
    let invite : Int?
    let invite_type : Int?
    let invite_available_at : Int?
    let created_at : Int?
    let accepted_at : Int?
    let liked_at : Int?
    let superliked_at : Int?
    let owner_confirm_at : Int?
    let reconfirm_at : Int?
    let owner_reconfirm_at : Int?
    let owner : Int?
    let owner_name : String?
    let owner_avatar : String?
    let owner_second_avatar : String?
    
    enum CodingKeys: String, CodingKey {
        
        case user = "user"
        case user_name = "user_name"
        case user_avatar = "user_avatar"
        case user_second_avatar = "user_second_avatar"
        case invite = "invite"
        case invite_type = "invite_type"
        case invite_available_at = "invite_available_at"
        case created_at = "created_at"
        case accepted_at = "accepted_at"
        case liked_at = "liked_at"
        case superliked_at = "superliked_at"
        case owner_confirm_at = "owner_confirm_at"
        case reconfirm_at = "reconfirm_at"
        case owner_reconfirm_at = "owner_reconfirm_at"
        case owner = "owner"
        case owner_name = "owner_name"
        case owner_avatar = "owner_avatar"
        case owner_second_avatar = "owner_second_avatar"
    }
    

}
