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
import UICircularProgressRing
import DCKit

class SparksViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource , UINavigationControllerDelegate{
    
    
    

    @IBOutlet weak var profilesCollectionView: UICollectionView!
    
    @IBOutlet weak var chatTable: UITableView!
    
    var pendingList : [Pending_list] = [Pending_list]()
    var chatList : [Chats] = [Chats]()
    var messageList : [Message_list] = [Message_list]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.delegate = self
        
        self.profilesCollectionView.delegate = self
        self.profilesCollectionView.dataSource = self
        
        self.chatTable.delegate = self
        self.chatTable.dataSource = self
        
        
        
        chatTable.register(UINib(nibName: "SparksTableViewCell", bundle: nil), forCellReuseIdentifier: "SparksTableViewCell")
        
        
        profilesCollectionView.register(UINib(nibName: "ProfileChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileChatCollectionViewCell")
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.callChatListRest(showLoading: true)
        IQKeyboardManager.sharedManager().enable = true
        self.navigationController?.delegate = self
        GlobalFields.defaults.set(false, forKey: "showChatBadge")
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if(fromVC.isKind(of: MainProfileViewController.self)){
            return nil
        }else if(fromVC.isKind(of: FirstMapViewController.self)){
            return nil
        }else if(toVC.isKind(of: FirstMapViewController.self)){
            let t = TransitionManager()
            t.coef = -1
            return t
        }else if(toVC.isKind(of: MainProfileViewController.self)){
            let t = TransitionManager()
            t.coef = -1
            return t
        }else{
            return nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callChatListRest(showLoading : Bool){
        self.pendingList.removeAll()
        self.chatList.removeAll()
        self.messageList.removeAll()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        var l : LoadingViewController? = nil
        if(showLoading){
            l = GlobalFields.showLoading(vc: self)
        }
        request(URLs.getMyChats, method: .post , parameters: GetMyChatsRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<GetMyChatsRes>>) in
            
            let res = response.result.value
            if(showLoading){
                l?.disView()
            }
            //update mishe tableo collection
            if(res?.status == "success"){
                self.pendingList = (res?.data?.pending_list) ?? [Pending_list]()
                self.chatList = (res?.data?.chats) ?? [Chats]()
                self.messageList = (res?.data?.message_list) ?? [Message_list]()
                self.profilesCollectionView.reloadData()
                self.chatTable.reloadData()
                if(res?.data == nil){
                    self.chatTable.alpha = 0
                }else{
                    if(self.chatList.isEmpty && self.messageList.isEmpty){
                        self.chatTable.alpha = 0
                    }else{
                        self.chatTable.alpha = 1
                    }
                }
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
        return 113 / 675 * self.view.frame.height
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
            cell.noSeenView.alpha = 0
            
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
            cell.noSeenView.alpha = 0
            if(c.seen_at == 0 && (c.user?.description)! != GlobalFields.ID.description){
                cell.noSeenView.alpha = 1
            }
            
            cell.noSeenView.clipsToBounds = true
            cell.noSeenView.frame.size.height = cell.noSeenView.frame.size.width
            cell.noSeenView.cornerRadius = cell.noSeenView.frame.height / 2
            cell.noSeenView.backgroundColor = GlobalFields.getTypeColor(type: c.type!)
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
            let c : Chats = self.chatList[indexPath.item - self.messageList.count]
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
            
            if(c.channel != nil && c.channel != ""){
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let l = GlobalFields.showLoading(vc: self)
                request(URLs.getChatChannel, method: .post , parameters: GetChatChannelRequestModel.init(ID: c.id!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<GetChatChannelRes>>) in
                    l.disView()
                    let res = response.result.value
                    if(res?.status == "success"){
                        vC.channel = (res?.data?.channel)!
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else{
                        self.view.makeToast(res?.message)
                    }
                    
                }
            }else{
                self.navigationController?.pushViewController(vC, animated: true)
            }
            
        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.pendingList.count < 3){
            return 3
        }
        return self.pendingList.count
    }
    
    @objc func callSelect(sender : DCBorderedButton){
        self.collectionView(self.profilesCollectionView, didSelectItemAt: .init(item: sender.tag - 1, section: 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProfileChatCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileChatCollectionViewCell", for: indexPath as IndexPath) as! ProfileChatCollectionViewCell
        cell.imageProfileButton.addTarget(self, action: #selector(callSelect), for: .touchUpInside)
        cell.imageProfileButton.tag = indexPath.item + 1
        cell.ringView.frame.size.width = cell.ringView.frame.height
        cell.imageProfileButton.frame.size = .init(width: cell.ringView.frame.height - 20, height: cell.ringView.frame.height - 20)
        cell.imageProfileButton.setImage(UIImage.init(named: ""), for: .normal)
        cell.imageProfileButton.frame.origin.x = cell.ringView.frame.origin.x + (cell.ringView.frame.height / 2) - (cell.imageProfileButton.frame.width / 2)
        
        cell.imageProfileButton.frame.origin.y = cell.ringView.frame.origin.y + (cell.ringView.frame.height / 2) - (cell.imageProfileButton.frame.width / 2)
        
        if(indexPath.item > self.pendingList.count - 1){
            
            cell.nameLabel.text = ""
            cell.imageProfileButton.alpha = 1
            cell.imageProfileButton.backgroundColor = UIColor("#E2E2E2")
            cell.ringView.setProgress(value: 100.0 , animationDuration: 0)
            cell.ringView.innerCapStyle = .square
            cell.ringView.innerRingWidth = 10
            cell.ringView.innerRingColor = UIColor("#E2E2E2")
            
        }else{
            let c : Pending_list = self.pendingList[indexPath.item]
            var name : String = ""
            var avatar : String = ""
            var recAt : Int = 0
            cell.ringView.innerRingWidth = 10
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
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if(indexPath.item <= self.pendingList.count - 1){
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
        
    
    
    
    
}












