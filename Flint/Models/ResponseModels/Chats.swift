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
    let user : Int?
    let target : Int?
    let channel : String?
    let created_at : Int?
    let last_message_at : Int?
    let last_message : String?
    let last_message_type : Int?
    let type : Int?
    let user_avatar : String?
    let user_second_avatar : String?
    let user_name : String?
    let target_avatar : String?
    let target_second_avatar : String?
    let target_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case user = "user"
        case target = "target"
        case channel = "channel"
        case created_at = "created_at"
        case last_message_at = "last_message_at"
        case last_message = "last_message"
        case last_message_type = "last_message_type"
        case type = "type"
        case user_avatar = "user_avatar"
        case user_second_avatar = "user_second_avatar"
        case user_name = "user_name"
        case target_avatar = "target_avatar"
        case target_second_avatar = "target_second_avatar"
        case target_name = "target_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user = try values.decodeIfPresent(Int.self, forKey: .user)
        target = try values.decodeIfPresent(Int.self, forKey: .target)
        channel = try values.decodeIfPresent(String.self, forKey: .channel)
        created_at = try values.decodeIfPresent(Int.self, forKey: .created_at)
        last_message_at = try values.decodeIfPresent(Int.self, forKey: .last_message_at)
        last_message = try values.decodeIfPresent(String.self, forKey: .last_message)
        last_message_type = try values.decodeIfPresent(Int.self, forKey: .last_message_type)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        user_avatar = try values.decodeIfPresent(String.self, forKey: .user_avatar)
        user_second_avatar = try values.decodeIfPresent(String.self, forKey: .user_second_avatar)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        target_avatar = try values.decodeIfPresent(String.self, forKey: .target_avatar)
        target_second_avatar = try values.decodeIfPresent(String.self, forKey: .target_second_avatar)
        target_name = try values.decodeIfPresent(String.self, forKey: .target_name)
    }

}
