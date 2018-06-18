//
//  URLs.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class URLs {
    
    static let server = "http://api-flint.com/web/index.php?r=flint/"
//    static let server = "http://185.125.206.203/~apiflint/web/index.php?r=flint/"
    
    static let imgServer = "http://api-flint.com/web/"
//    static let imgServer = "http://185.125.206.203/~apiflint/web/"
    
    static let login = server + "login"
    
    static let register = server + "register"
    
    static let loginWithFacebook = server + "facebook-login"
    
    static let registerWithFacebook = server + "register-with-facebook"
    
    static let forgotPassword = server + "forget-password"
    
    static let changePassword = server + "change-password"
    
    static let resetPassword = server + "reset-password"
    
    static let activeUser = server + "active-user"
    
    static let resendActivationCode = server + "resend-activation-code"
    
    static let updateUserLocation = server + "update-user-location"
    
    static let changeUserSettings = server + "change-user-settings"
    
    static let getUserSettings = server + "get-user-settings"
    
    static let deleteAccount = server + "delete-account"
    
    static let editUserInfo = server + "edit-user-info"
    
    static let uploadImage = server + "upload-image"
    
    static let createInvitation = server + "create-invitation"
    
    static let acceptInvite = server + "accept-invite"
    
    static let openLighter = server + "open-lighter"
    
    static let getNearetsLighter = server + "get-nearest-lighter"
    
    static let fireLighter = server + "fire-lighter"
    
    static let getUsersListForInvite = server + "get-users-list-for-invite"
    
    static let likePersonForInvite = server + "like-person-for-invite"
    
    static let likeUser = server + "like-user"
    
    static let superlikeForInvite = server + "super-like-person-for-invite"
    
    static let cancelInvite = server + "cancel-invite"
    
    static let confirmInvitation = server + "confirm-invite"
    
    static let reconfirmInvitation = server + "reconfirm-invite"
    
    static let getConfirmListForInvite = server + "get-invite-reconfirm-list"
    
    static let confirmUser = server + "confirm-user"
    
    static let reportUser = server + "report-user"
    
    static let afterDatePoll = server + "invite-poll"
    
    static let getPartyPeopleAfterParty = server + "get-party-people"
    
    static let matchPartyPeople = server + "match-party-people"
    
    static let getInviteInfo = server + "get-invite-info"
    
    static let getMyInvites = server + "get-my-invites"
    
    static let searchInlocation = server + "search-in-location"
    
    static let getActiveInvite = server + "get-user-active-invitation"
    
    static let getMyChats = server + "get-message-list"
    
    static let sendInviteMessage = server + "send-invite-message"
    
    static let createChannel = server + "create-channel"
    
    static let updateChannel = server + "update-user-channel"
    
    static let isOccupied = server + "is-channel-occupied"
    
    static let getChatMessage = server + "get-chat-messages"
    
    static let getInviteMessage = server + "get-invite-message"
    
    static let finishDate = server + "finish-date"
    
    static let getHoureMessage = server + "get-message"
    
    static let sendHoureMessage = server + "send-message"
    
    static let sendChatMessage = server + "send-chat-message"
    
    static let forgetCode = server + "check-forget-code"
    
    static let updateOneSignal = server + "update-onesignal"
    
    static let getChatChannel = server + "get-chat-channel"
    
    static let logout = server + "logout"
    
}
