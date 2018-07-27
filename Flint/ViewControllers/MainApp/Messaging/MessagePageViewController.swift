//
//  MessagePageViewController.swift
//  Flint
//
//  Created by MILAD on 4/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import PusherSwift
import Kingfisher
import UICircularProgressRing
import IQKeyboardManagerSwift
import Chatto
import ChattoAdditions

class MessagePageViewController: UIViewController {

    @IBOutlet weak var messageLocView: UIView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet var botBackButton: UIButton!
    
    @IBOutlet var backLabel: UILabel!
    
    @IBOutlet var ringView: UICircularProgressRingView!
    
    var diffMin : Int?
    
    var name : String?         ///////////ALL MODES
    
    var imageAddress : String?         ///////////ALL MODES
    
    var chatTypeMode : ChatPageTypes = .Invites
    
    var isSendedOneMessage : Bool = false
    
    var isSendedThreeMessage : Bool = false
    
    var type : Int = 1 //type Business , lets see ,friendly          ///////////ALL MODES
    
    var inviteID : Int?          ///////////INVITE MODE , MESSAGE MODE , PENDING MODE
    
    var targetId : Int?          ///////////CHAT MODE
    
    var channel : String?          ///////////CHAT MODE
    
    var chatID : Int?          ///////////CHAT MODE
    
    override func viewDidLoad() {
        
        //!!!!!!! qabl az in safhe tu SparksViewController create channel shode umade inja
        // vaqti click shode ru in chat isOcupied ham call shode
        // yani channeli k injas oke va mishe bash chat kard
        
        super.viewDidLoad()
        botBackButton.alpha = 0
        IQKeyboardManager.sharedManager().enable = false
        self.image.frame.size.height = self.image.frame.width
        self.image.layer.cornerRadius = self.image.frame.width / 2
        self.image.layer.masksToBounds = true
        self.backLabel.alpha = 0
        
        self.nameLabel.text = name ?? ""
        
        if(chatTypeMode == .Invites){
            if(inviteID != nil){
                self.callGetInviteInfo()
            }
        }else if(chatTypeMode == .Pendings){
            if(inviteID != nil){
                self.callGetPendings()
            }
        }else if(chatTypeMode == .Messages){
            if(inviteID != nil){
                self.callGetMessages()
            }
        }else if(chatTypeMode == .Chats){
            
            let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
            let controller = DemoChatViewController()
            controller.dataSource = dataSource
            controller.isSendedOneMessage = false
            self.image.kf.setImage(with: URL.init(string: URLs.imgServer + (imageAddress ?? "")))
            self.nameLabel.text = self.name
            controller.type = type
            controller.isOneTextMode = .Chats
            controller.targetId = targetId
            controller.chatID = chatID
            controller.channelName = channel
            //create channel and pass channel to controller
            addChildViewController(controller)
            controller.view.frame = .init(origin: .init(x: 0, y: 0), size: messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            messageLocView.addSubview(controller.view)
            
            let options = PusherClientOptions(
                host: .cluster("mt1")
            )
            
            let pusher = Pusher(key: GlobalFields.pusherID , options: options)
            pusher.connect()
            
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let l = GlobalFields.showLoading(vc: self)
            request(URLs.getChatMessage, method: .post , parameters: GetChatMessageRequestModel.init(ID: chatID!, PAGE: 1, PER_PAGE: 100).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetChatMessageRes]>>) in
                
                let res = response.result.value
                l.disView()
                if(res?.status == "success"){
                
                    if(res?.data != nil){
                        for m in (res?.data?.reversed())! {
                            
                            if((m.senderId?.description)! == GlobalFields.ID.description){
                                controller.dataSource.addTextMessage(m.text!)
                            }else{
                                controller.dataSource.addIncommingTextMessage(m.text!)
                            }
                            
                        }
                        self.seenMessage(chat: self.chatID!)
                    }
                
                    if(self.channel == nil){//ag qablan ba ham chat nadashtan

                        let cN : String = (Date().timeIntervalSince1970.description + (self.targetId?.description)!).components(separatedBy: ".").joined()
                        pusher.subscribe(cN)
                        //call create channel method
                        self.createChannel(pusher: pusher, channelName: cN ,controller : controller)

                    }else{
                        //call isOccupied? method
                        self.isOccupied(pusher: pusher, channelName: self.channel! ,controller : controller)

                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.image.layer.cornerRadius = self.image.frame.width / 2
    }
    
    func callGetInviteInfo(){
        
        let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
        let controller = DemoChatViewController()
        controller.dataSource = dataSource
        controller.isOneTextMode = .Invites
        self.image.kf.setImage(with: URL.init(string: URLs.imgServer + (imageAddress ?? "")))
        
        controller.type = type
        if(isSendedThreeMessage){//ag ye message ferestade shode bud
            //TODO servicesh bayad call beshe tu inja
            controller.isSendedThreeMessage = 3
        }
        if(isSendedOneMessage){//ag ye message ferestade shode bud
            //TODO servicesh bayad call beshe tu inja
            controller.isSendedOneMessage = true
        }
        controller.inviteID = inviteID
        
        addChildViewController(controller)
        controller.view.frame = .init(origin: .init(x: 0, y: 0), size: messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        messageLocView.addSubview(controller.view)
        
        
        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getInviteInfo, method: .post , parameters: GetInviteInfoRequestModel.init(invite: inviteID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<InviteInfoRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.data != nil){
                
                self.botBackButton.backgroundColor = GlobalFields.getTypeColor(type: (res?.data?.main?.type!)!)
                
                request(URLs.getInviteMessage, method: .post , parameters: GetInviteInfoRequestModel.init(invite: self.inviteID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response2 : DataResponse<ResponseModel<[GetInviteMessageRes]>>) in
                    
                    let res2 = response2.result.value
                    
                    if(res2?.status == "success"){
//                        if(res2?.data != nil || res2?.data?.count == 0){
//                            self.backLabel.alpha = 1
//                            if(res?.data?.main?.type == 1){
//                                self.backLabel.text = "Renseignez vos invités quant au lieu, horaire et conditions dans lesquelles se tiendront la soirée."
//                            }else{
//                                self.backLabel.text = "Décrivez vous, vos habits ainsi que l’endroit où vous l’attendez dans un seul message."
//                                self.backLabel.text = "Vous avez 3 messages pour vous retrouver, renseignez l’autre sur : \n- comment vous êtes habillé(e) \n- l’endroit où vous vous trouvez \n- votre heure d’arrivée"
//                            }
//                        }
                        
                        if(res2?.data != nil){
                            if(res2?.data?.count != 0){
                                self.backLabel.alpha = 0
                            }else{
                                self.backLabel.textAlignment = .left
                                self.backLabel.alpha = 1
                            }
                            var myMessage : Int = 0
                            for m in (res2?.data)! {
                                if((m.user?.description)! == GlobalFields.ID.description){
                                    myMessage += 1
                                    if(myMessage >= 3){
                                        controller.isSendedThreeMessage = 3
                                        self.botBackButton.alpha = 1
                                    }
                                    controller.isSendedThreeMessage = myMessage
                                    controller.isSendedOneMessage = true
                                    controller.dataSource.addTextMessage(m.text!)
                                }else{
                                    if(self.type == 1){
                                        controller.dataSource.addIncommingTextMessage(m.name! + " : " + m.text!)
                                    }else{
                                        controller.dataSource.addIncommingTextMessage(m.text!)
                                    }
                                    if(m.seen_at == 0){
                                        self.seenMessageInvite(m : m)
                                    }
                                }
                            }
                            
                        }
                        
                        controller.didMove(toParentViewController: self)
                        
                        if(res?.data?.main?.type == 1){
                            //ag party bud bayad akse bala doros she
                            
                            self.image.backgroundColor = GlobalFields.getTypeColor(type: 1)
                            self.image.image = UIImage.init(named: "party-popper")
                            self.image.contentMode = .center
                            
                            self.nameLabel.alpha = 0
                        }else{
                            self.nameLabel.alpha = 1
                            if((res?.data?.main?.owner!.description)! != GlobalFields.ID.description){
                                self.image.kf.setImage(with: URL.init(string: URLs.imgServer + (res?.data?.main?.owner_avatar ?? "")))
                                self.nameLabel.text = res?.data?.main?.owner_name
                            }else{
                                self.image.kf.setImage(with: URL.init(string: URLs.imgServer + (res?.data?.users![0].avatar ?? "")))
                                self.nameLabel.text = res?.data?.users![0].name
                            }
                            
                        }
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
                
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func seenMessageInvite(m : GetInviteMessageRes){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.seenInviteMessage, method: .post , parameters: SeenInviteRequestModel.init(message: m.id, invite: self.inviteID).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
        }
    }
    
    func callGetPendings(){
        //inja k  hich datayi vojud nadare
        let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
        let controller = DemoChatViewController()
        controller.dataSource = dataSource
        controller.isOneTextMode = .Pendings
        self.image.kf.setImage(with: URL.init(string: URLs.imgServer + (imageAddress ?? "")))

        self.ringView.alpha = 1
        print(CGFloat(Double(Double(diffMin!) / (24.0 * 60.0)) * 100))
        self.ringView.setProgress(value: 100.0 - CGFloat(Double(Double(diffMin!) / (24.0 * 60.0)) * 100), animationDuration: 0)
        self.ringView.innerCapStyle = .square
        self.ringView.innerRingColor = GlobalFields.getTypeColor(type: type)
        
        controller.type = type
        controller.targetId = self.targetId
        if(isSendedOneMessage){//ag ye message ferestade shode bud
            //TODO servicesh bayad call beshe tu inja
            controller.isSendedOneMessage = true
        }
        controller.inviteID = inviteID
        
        addChildViewController(controller)
        controller.view.frame = .init(origin: .init(x: 0, y: 0), size: messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        messageLocView.addSubview(controller.view)
        self.backLabel.textAlignment = .center
        self.backLabel.text = "Vous devez envoyer le premier message sous 24h ou y répondre pour activer la relation"
        controller.didMove(toParentViewController: self)
    }
    
    func callGetMessages(){
        
        let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
        let controller = DemoChatViewController()
        controller.dataSource = dataSource
        controller.isOneTextMode = .Messages
        self.image.kf.setImage(with: URL.init(string: URLs.imgServer + (imageAddress ?? "")))
        self.ringView.alpha = 1
        print(CGFloat(Double(Double(diffMin!) / (24.0 * 60.0)) * 100))
        self.ringView.setProgress(value: 100.0 - CGFloat(Double(Double(diffMin!) / (24.0 * 60.0)) * 100), animationDuration: 0)
        self.ringView.innerCapStyle = .square
        self.ringView.innerRingColor = GlobalFields.getTypeColor(type: type)
        controller.type = type
        controller.targetId = self.targetId
        if(isSendedOneMessage){//ag ye message ferestade shode bud
            //TODO servicesh bayad call beshe tu inja
            controller.isSendedOneMessage = true
        }
        controller.inviteID = inviteID
        
        addChildViewController(controller)
        controller.view.frame = .init(origin: .init(x: 0, y: 0), size: messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        messageLocView.addSubview(controller.view)
        
        
        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getHoureMessage, method: .post , parameters: GetMessagesRequestModel.init(invite: inviteID! , target : self.targetId!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetInviteMessageRes]>>) in
            
            l.disView()
            let res = response.result.value
            
            if(res?.data != nil || res?.data?.count == 0){
                
                self.backLabel.alpha = 1
                self.backLabel.textAlignment = .center
                self.backLabel.text = "Vous devez envoyer le premier message sous 24h ou y répondre pour activer la relation"
                
            }
            
            if(res?.data != nil){
                if(res?.data?.count != 0){
                    self.backLabel.alpha = 0
                }
//                var messages : [DemoTextMessageModel] = [DemoTextMessageModel]()
                for m in (res?.data)! {
                    if((m.user?.description)! == GlobalFields.ID.description){
                        controller.isSendedOneMessage = true
                        self.botBackButton.backgroundColor = GlobalFields.getTypeColor(type: self.type)
                        self.botBackButton.alpha = 1
                        controller.chatInputPresenter.chatInputBar.alpha = 0
                        controller.dataSource.addTextMessage(m.text!)
                    }else{
                        controller.dataSource.addIncommingTextMessage(m.text!)
                    }
                }
                
            }
            
            controller.didMove(toParentViewController: self)
            
        }
        
    }
    
    func callGetChats(){
        
    }
    
    func seenMessage(chat : Int){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.seenMessage, method: .post , parameters: SeenMessageRequestModel.init(chat: chat).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
        }
    }
    
    
    func createChannel(pusher : Pusher , channelName : String , controller : DemoChatViewController){
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.createChannel, method: .post , parameters: CreateChannelRequestModel.init(CHANNEL: channelName, TARGET: self.targetId!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                //tu javabe response ag success bud ino call mikonim
                controller.channelName = self.channel!
                self.addChildViewController(controller)
                controller.view.frame = .init(origin: .init(x: 0, y: 0), size: self.messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                self.messageLocView.addSubview(controller.view)
                
                controller.didMove(toParentViewController: self)
            }
            
        }
        
    }
    
    func isOccupied(pusher : Pusher , channelName : String , controller : DemoChatViewController){
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.isOccupied, method: .post , parameters: IsOccupiedRequestModel.init(CHANNEL: channelName).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value

            if(res?.status == "success"){
                
                controller.channelName = self.channel!
                self.addChildViewController(controller)
                controller.view.frame = .init(origin: .init(x: 0, y: 0), size: self.messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                self.messageLocView.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
                controller.callBinding()
                
                
            }else{
                let ch = (Date().timeIntervalSince1970.description + (self.targetId?.description)!).components(separatedBy: ".").joined()
                request(URLs.updateChannel, method: .post , parameters: UpdateChannelRequestModel.init(CHANNEL: ch, CHAT: self.chatID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                    
                    let res = response.result.value
                    
                    if(res?.status == "success"){
                        controller.channelName = ch
                        self.channel = ch
                        self.addChildViewController(controller)
                        controller.view.frame = .init(origin: .init(x: 0, y: 0), size: self.messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                        self.messageLocView.addSubview(controller.view)
                        controller.channelName = self.channel!
                        controller.didMove(toParentViewController: self)
                        controller.callBinding()
                    }
                    
                }
                
            }
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showReport(_ sender: Any) {
        
        let vC : ReportPopupViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ReportPopupViewController"))! as! ReportPopupViewController
        addChildViewController(vC)
        vC.view.frame = self.view.frame
        self.view.addSubview(vC.view)
        vC.didMove(toParentViewController: self)
        
    }
    
    

}
