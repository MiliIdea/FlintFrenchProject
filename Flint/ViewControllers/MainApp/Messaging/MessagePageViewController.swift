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

class MessagePageViewController: UIViewController {

    @IBOutlet weak var messageLocView: UIView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var name : String?         ///////////ALL MODES
    var imageAddress : String?         ///////////ALL MODES
    
    var isOneTextMode : Bool = false
    
    var isSendedOneMessage : Bool = false
    
    var type : Int = 1 //type Business , lets see ,friendly          ///////////ALL MODES
    
    var inviteID : Int?          ///////////INVITE MODE
    
    var targetId : Int?          ///////////CHAT MODE
    
    var channel : String?          ///////////CHAT MODE
    
    var chatID : Int?          ///////////CHAT MODE
    
    override func viewDidLoad() {
        
        //!!!!!!! qabl az in safhe tu SparksViewController create channel shode umade inja
        // vaqti click shode ru in chat isOcupied ham call shode
        // yani channeli k injas oke va mishe bash chat kard
        
        super.viewDidLoad()
        
        self.image.frame.size.height = self.image.frame.width
        self.image.layer.cornerRadius = self.image.frame.width / 2
        
        self.nameLabel.text = name ?? ""
        self.image.kf.setImage(with: URL.init(string: URLs.imgServer + (imageAddress ?? "")))
        
        
        let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
        let controller = DemoChatViewController()
        controller.dataSource = dataSource

        controller.type = type
        
        if(isOneTextMode){
            controller.isOneTextMode = true
            if(isSendedOneMessage){//ag ye message ferestade shode bud
                //TODO servicesh bayad call beshe tu inja
                controller.isSendedOneMessage = true
            }
            controller.inviteID = inviteID
            
            addChildViewController(controller)
            controller.view.frame = .init(origin: .init(x: 0, y: 0), size: messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            messageLocView.addSubview(controller.view)
            
            controller.didMove(toParentViewController: self)
            
        }else{
            controller.targetId = targetId
            //create channel and pass channel to controller
            
            let options = PusherClientOptions(
                host: .cluster("mt1")
            )
            
            let pusher = Pusher(key: "6a39f8875e90a2c2cec5", options: options)
            pusher.connect()
            
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            request(URLs.getChatMessage, method: .post , parameters: GetChatMessageRequestModel.init(ID: chatID!, PAGE: 1, PER_PAGE: 100).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetChatMessageRes]>>) in
                
                let res = response.result.value
                
                if(res?.status == "success"){
                
                    if(res?.data != nil){
                        for m in (res?.data)! {
                            
                            if(m.senderId == 1){
                                dataSource.addTextMessage(m.text!)
                            }else{
                                dataSource.addIncommingTextMessage(m.text!)
                            }
                            
                        }
                    }
                    
                    if(self.channel == nil){//ag qablan ba ham chat nadashtan
                        
                        let cN : String = Date().timeIntervalSince1970.description + (self.targetId?.description)!
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
            //TODO inja bayad doros beshe
            
            
            
            
            if(res?.status == "success"){
                
                controller.channelName = self.channel!
                self.addChildViewController(controller)
                controller.view.frame = .init(origin: .init(x: 0, y: 0), size: self.messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                self.messageLocView.addSubview(controller.view)
                
                controller.didMove(toParentViewController: self)
            }else{
                //TODO chatido bayad inja pass dad
                //inja yani occupied nis
                
                
                
                request(URLs.updateChannel, method: .post , parameters: UpdateChannelRequestModel.init(CHANNEL: channelName, CHAT: self.chatID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                    
                    let res = response.result.value
                    
                    if(res?.status == "success"){
                        controller.channelName = self.channel!
                        self.addChildViewController(controller)
                        controller.view.frame = .init(origin: .init(x: 0, y: 0), size: self.messageLocView.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                        self.messageLocView.addSubview(controller.view)
                        
                        controller.didMove(toParentViewController: self)
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
    }
    
    

}
