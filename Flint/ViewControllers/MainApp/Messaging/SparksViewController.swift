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

class SparksViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource {
    

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
        request(URLs.getMyChats, method: .post , parameters: GetMyChatsRequestModel.init(page: 1, per_page: 100).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<GetMyChatsRes>>) in
            
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
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatList.count + self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375 / 675 * self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatTable.dequeueReusableCell(withIdentifier: "SparksTableViewCell" , for: indexPath) as! SparksTableViewCell
        
        if(indexPath.row + 1 > self.messageList.count){
            //in message list
            print(indexPath.row)
            let c : Message_list = self.messageList[indexPath.row]
            
            cell.lastText.text = c.answer
            cell.nameLabel.text = c.target_name
            cell.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + c.target_avatar!))
            let diffMin = Calendar.current.dateComponents([.minute], from: Date.init(timeIntervalSince1970: Double(c.answered_at!)) , to: Date()).minute
            cell.ringView.setProgress(value: CGFloat(Double(diffMin! / (24 * 60)) * 100), animationDuration: 0)
            cell.ringView.innerRingColor = GlobalFields.getTypeColor(type: c.type!)
            
        }else{
            //in chats
            let c : Chats = self.chatList[indexPath.row - (self.messageList.count - 1)]
            
            cell.lastText.text = c.last_message
            cell.nameLabel.text = c.target_name
            cell.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + c.target_avatar!))
            cell.ringView.alpha = 0
            cell.profileImage.layer.borderWidth = 2
            cell.profileImage.layer.borderColor = GlobalFields.getTypeColor(type: c.type!).cgColor
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row + 1 > self.messageList.count){
            //in messageList
            let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
            let c : Message_list = self.messageList[indexPath.item]
            vC.type = c.type!
            vC.chatID = c.id
            vC.targetId = c.target
            vC.isOneTextMode = true
            // asnwer dar vaqe my message hast
            if(c.answer == nil){
                vC.isSendedOneMessage = false
            }else{
                vC.isSendedOneMessage = true
            }
            
            self.navigationController?.pushViewController(vC, animated: true)
        }else{
            //in chatList
            let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
            let c : Chats = self.chatList[indexPath.item]
            vC.type = c.type!
            vC.isOneTextMode = false
            vC.isSendedOneMessage = false
            vC.channel = c.channel
            vC.image.kf.setImage(with: URL.init(string: URLs.imgServer + c.target_avatar!))
            vC.chatID = c.id
            vC.targetId = c.target
            
            self.navigationController?.pushViewController(vC, animated: true)
            
        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pendingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProfileChatCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileChatCollectionViewCell", for: indexPath as IndexPath) as! ProfileChatCollectionViewCell
        let c : Pending_list = self.pendingList[indexPath.item]
        cell.nameLabel.text = c.name
        cell.imageProfileButton.kf.setImage(with: URL.init(string: URLs.imgServer + c.avatar!), for: .normal)
        
        let diffMin = Calendar.current.dateComponents([.minute], from: Date.init(timeIntervalSince1970: Double(c.available_at!)) , to: Date()).minute
        
        cell.ringView.setProgress(value: CGFloat(Double(diffMin! / (24 * 60)) * 100), animationDuration: 0)
        
        cell.ringView.innerRingColor = GlobalFields.getTypeColor(type: c.type!)
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
        let c : Pending_list = self.pendingList[indexPath.item]
        vC.type = c.type!
        vC.inviteID = c.id
        vC.imageAddress = c.avatar
        vC.name = c.name
        vC.isOneTextMode = true
        vC.isSendedOneMessage = false
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    
}












