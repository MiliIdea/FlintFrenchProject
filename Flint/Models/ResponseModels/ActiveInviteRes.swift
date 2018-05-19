//
//  ActiveInviteRes.swift
//  Flint
//
//  Created by MehrYasan on 5/17/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct ActiveInviteRes : Codable {
    
    let owned_invitation : MyInvites?
    
    let other_invitations : MyInvites?
    
    enum CodingKeys: String, CodingKey {
        
        case owned_invitation = "owned_invitation"
        
        case other_invitations = "other_invitations"
        
    }
    
    
}
