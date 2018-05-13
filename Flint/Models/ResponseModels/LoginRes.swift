/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
class LoginRes : NSObject, Codable , NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id,  forKey: "id");
        aCoder.encode(self.username,    forKey: "username");
        aCoder.encode(self.token,    forKey: "token");
        aCoder.encode(self.email,    forKey: "email");
        aCoder.encode(self.name,forKey: "name");
        aCoder.encode(self.gender,   forKey: "gender");
        aCoder.encode(self.status,   forKey: "status");
        aCoder.encode(self.avatar,   forKey: "avatar");
        aCoder.encode(self.second_avatar,   forKey: "second_avatar");
        aCoder.encode(self.looking_for,   forKey: "looking_for");
        aCoder.encode(self.selfie,   forKey: "selfie");
        aCoder.encode(self.new_pin_notif,   forKey: "new_pin_notif");
        aCoder.encode(self.lighter,   forKey: "lighter");
        aCoder.encode(self.invite_accepted_notification,   forKey: "invite_accepted_notification");
        aCoder.encode(self.message_notification,   forKey: "message_notification");
        aCoder.encode(self.vibration,   forKey: "vibration");
        aCoder.encode(self.min_age,   forKey: "min_age");
        aCoder.encode(self.max_age,   forKey: "max_age");
        aCoder.encode(self.birthdate,   forKey: "birthdate");
        aCoder.encode(self.bio,   forKey: "bio");
        aCoder.encode(self.job,   forKey: "job");
        aCoder.encode(self.studies,   forKey: "studies");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id  = aDecoder.decodeObject(forKey: "id") as! Int?
        self.username  = aDecoder.decodeObject(forKey: "username") as! String?
        self.token  = aDecoder.decodeObject(forKey: "token") as! String?
        self.email  = aDecoder.decodeObject(forKey: "email") as! String?
        self.name  = aDecoder.decodeObject(forKey: "name") as! String?
        self.gender  = aDecoder.decodeObject(forKey: "gender") as! String?
        self.status  = aDecoder.decodeObject(forKey: "status") as! Int?
        self.avatar  = aDecoder.decodeObject(forKey: "avatar") as! String?
        self.second_avatar  = aDecoder.decodeObject(forKey: "second_avatar") as! String?
        self.looking_for  = aDecoder.decodeObject(forKey: "looking_for") as! Int?
        self.selfie  = aDecoder.decodeObject(forKey: "selfie") as! String?
        self.new_pin_notif  = aDecoder.decodeObject(forKey: "new_pin_notif") as! Bool?
        self.lighter  = aDecoder.decodeObject(forKey: "lighter") as! Bool?
        self.invite_accepted_notification  = aDecoder.decodeObject(forKey: "invite_accepted_notification") as! Bool?
        self.message_notification  = aDecoder.decodeObject(forKey: "message_notification") as! Bool?
        self.vibration  = aDecoder.decodeObject(forKey: "vibration") as! Bool?
        self.min_age  = aDecoder.decodeObject(forKey: "min_age") as! Int?
        self.max_age  = aDecoder.decodeObject(forKey: "max_age") as! Int?
        self.birthdate  = aDecoder.decodeObject(forKey: "birthdate") as! Int?
        self.bio  = aDecoder.decodeObject(forKey: "bio") as! String?
        self.job  = aDecoder.decodeObject(forKey: "job") as! String?
        self.studies  = aDecoder.decodeObject(forKey: "studies") as! String?
        self.sounds  = aDecoder.decodeObject(forKey: "sounds") as! Bool?
    }
    

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
