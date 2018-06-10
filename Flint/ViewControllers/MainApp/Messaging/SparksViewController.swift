//
//  SparksViewController.swift
//  Flint
//
//  Created by MILAD on 4/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import UIColor_Hex_Swift
import Kingfisher
import IQKeyboardManagerSwift
import TransitionTreasury

class SparksViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource , NavgationTransitionable{
    
    var tr_pushTransition: TRNavgationTransitionDelegate?
    
    

    @IBOutlet weak var profilesCollectionView: UICollectionView!
    
    @IBOutlet weak var chatTable: UITableView!
    
    var pendingList : [Pending_list] = [Pending_list]()
    var chatList : [Chats] = [Chats]()
    var messageList : [Message_list] = [Message_list]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profilesCollectionView.delegate = self
        self.profilesCollectionView.dataSource = self
        
        self.chatTable.delegate = self
        self.chatTable.dataSource = self
        
        chatTable.register(UINib(nibName: "SparksTableViewCell", bundle: nil), forCellReuseIdentifier: "SparksTableViewCell")
        
        
        profilesCollectionView.register(UINib(nibName: "ProfileChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileChatCollectionViewCell")
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.callChatListRest()
        IQKeyboardManager.sharedManager().enable = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callChatListRest(){
        self.pendingList.removeAll()
        self.chatList.removeAll()
        self.messageList.removeAll()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.getMyChats, method: .post , parameters: GetMyChatsRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<GetMyChatsRes>>) in
            
            let res = response.result.value
            l.disView()
            //update mishe tableo collection
            if(res?.status == "success"){
                
                self.pendingList = (res?.data?.pending_list) ?? [Pending_list]()
                self.chatList = (res?.data?.chats) ?? [Chats]()
                self.messageList = (res?.data?.message_list) ?? [Message_list]()
                self.profilesCollectionView.reloadData()
                self.chatTable.reloadData()
                
            }
        }
    }
    
    
    
    
    
    
    
    @IBAction func goProfile(_ sender: Any) {
        var isThereBack : Bool = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MainProfileViewController.self) {
                isThereBack = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        if(!isThereBack){
            let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
            self.navigationController?.pushViewController(vC, animated: true)
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FirstMapViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatList.count + self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145 / 675 * self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatTable.dequeueReusableCell(withIdentifier: "SparksTableViewCell" , for: indexPath) as! SparksTableViewCell
        print(indexPath.row)
        if(indexPath.row + 1 <= self.messageList.count){
            //in message list
            print(indexPath.row)
            let c : Message_list = self.messageList[indexPath.row]
            
            cell.profileImage.frame.size = CGSize.init(width: 66 / 375 * self.view.frame.width, height: 66 / 375 * self.view.frame.width)
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
            cell.profileImage.clipsToBounds = true
            let w = cell.profileImage.frame.width
            let h = cell.profileImage.frame.height
            let w2 = cell.ringView.frame.width
            let h2 = cell.ringView.frame.height
            let p = cell.ringView.frame.origin
            cell.profileImage.frame.origin = CGPoint.init(x: p.x + w2 / 2 - w / 2, y: p.y + h2 / 2 - h / 2)
            
            cell.lastText.text = c.text
            if(GlobalFields.ID.description == (c.user?.description)!){
                cell.nameLabel.text = c.target_name
                cell.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + c.target_avatar!))
            }else{
                cell.nameLabel.text = c.user_name
                cell.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + c.user_avatar!))
            }
            
            let diffMin = Calendar.current.dateComponents([.minute], from: Date.init(timeIntervalSince1970: Double(c.created_at!)) , to: Date()).minute
            cell.ringView.setProgress(value: 100.0 - CGFloat(Double(Double(diffMin!) / (24.0 * 60.0)) * 100), animationDuration: 0)
            cell.ringView.innerCapStyle = .square
            cell.ringView.innerRingColor = GlobalFields.getTypeColor(type: c.type!)
            
        }else{
            //in chats
            let c : Chats = self.chatList[indexPath.row - (self.messageList.count)]
            cell.profileImage.frame.size = CGSize.init(width: 86 / 375 * self.view.frame.width, height: 86 / 375 * self.view.frame.width)
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
            cell.profileImage.clipsToBounds = true
            let w = cell.profileImage.frame.width
            let h = cell.profileImage.frame.height
            let w2 = cell.ringView.frame.width
            let h2 = cell.ringView.frame.height
            let p = cell.ringView.frame.origin
            cell.profileImage.frame.origin = CGPoint.init(x: p.x + w2 / 2 - w / 2, y: p.y + h2 / 2 - h / 2)
            cell.lastText.text = c.last_message
            cell.ringView.alpha = 0
            cell.profileImage.layer.borderWidth = 2
            cell.profileImage.layer.borderColor = GlobalFields.getTypeColor(type: c.type!).cgColor
            if((c.user?.description)! == GlobalFields.ID.description){
                cell.nameLabel.text = c.target_name
                cell.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + c.target_avatar!))
            }else{
                cell.nameLabel.text = c.user_name
                cell.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + c.user_avatar!))
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row + 1 <= self.messageList.count){
            //in messageList
            let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
            let c : Message_list = self.messageList[indexPath.item]
            var name : String = ""
            var avatar : String = ""
            var recAt : Int = 0
            var target : Int = 0
            if((c.user?.description)! == GlobalFields.ID.description){
                name = c.target_name!
                avatar = c.target_avatar!
                recAt = c.created_at!
                target = c.target!
                vC.isSendedOneMessage = true
            }else{
                name = c.user_name!
                avatar = c.user_avatar!
                recAt = c.created_at!
                target = c.user!
                vC.isSendedOneMessage = false
            }
            vC.type = c.type!
            vC.chatID = c.id
            vC.targetId = target
            vC.chatTypeMode = .Messages
            vC.inviteID = c.invite
            vC.name = name
            vC.imageAddress = avatar
            vC.diffMin = Calendar.current.dateComponents([.minute], from: Date.init(timeIntervalSince1970: Double(c.created_at!)) , to: Date()).minute
 
            self.navigationController?.pushViewController(vC, animated: true)
            
        }else{
            //in chatList
            let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
            let c : Chats = self.chatList[indexPath.item]
            vC.type = c.type!
            vC.chatTypeMode = .Chats
            vC.isSendedOneMessage = false
            vC.channel = c.channel
            vC.chatID = c.id
            if((c.user?.description)! == GlobalFields.ID.description){
                vC.imageAddress = c.target_avatar
                vC.targetId = c.target
            }else{
                vC.imageAddress = c.user_avatar
                vC.targetId = c.user
            }
            
            self.navigationController?.pushViewController(vC, animated: true)
            
        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pendingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProfileChatCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileChatCollectionViewCell", for: indexPath as IndexPath) as! ProfileChatCollectionViewCell
        let c : Pending_list = self.pendingList[indexPath.item]
        var name : String = ""
        var avatar : String = ""
        var recAt : Int = 0
        if((c.owner?.description)! == GlobalFields.ID.description){
            name = c.user_name!
            avatar = c.user_avatar!
            recAt = c.reconfirm_at!
        }else{
            name = c.owner_name!
            avatar = c.owner_avatar!
            recAt = c.owner_reconfirm_at!
        }
        cell.nameLabel.text = name
        cell.imageProfileButton.kf.setImage(with: URL.init(string: URLs.imgServer + avatar), for: .normal)
        
        let diffMin = Calendar.current.dateComponents([.minute], from: Date.init(timeIntervalSince1970: Double(recAt)) , to: Date()).minute
        print(CGFloat(Double(Double(diffMin!) / (24.0 * 60.0)) * 100))
        cell.ringView.setProgress(value: 100.0 - CGFloat(Double(Double(diffMin!) / (24.0 * 60.0)) * 100), animationDuration: 0)
        cell.ringView.innerCapStyle = .square
        cell.ringView.innerRingColor = GlobalFields.getTypeColor(type: c.invite_type!)
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
        let c : Pending_list = self.pendingList[indexPath.item]
        var name : String = ""
        var avatar : String = ""
        var target : Int = 0
        var recAt : Int = 0
        if((c.owner?.description)! == GlobalFields.ID.description){
            name = c.user_name!
            avatar = c.user_avatar!
            target = c.user!
            recAt = c.reconfirm_at!
        }else{
            name = c.owner_name!
            avatar = c.owner_avatar!
            target = c.owner!
            recAt = c.reconfirm_at!
        }
        vC.type = c.invite_type!
        vC.inviteID = c.invite
        vC.imageAddress = avatar
        vC.name = name
        vC.targetId = target
        vC.chatTypeMode = .Pendings
        vC.isSendedOneMessage = false
        vC.diffMin = Calendar.current.dateComponents([.minute], from: Date.init(timeIntervalSince1970: Double(recAt)) , to: Date()).minute
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    
    
    
}












