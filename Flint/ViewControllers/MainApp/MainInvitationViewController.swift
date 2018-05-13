//
//  MainInvitationViewController.swift
//  Flint
//
//  Created by MILAD on 4/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit
import Alamofire
import CodableAlamofire
import Kingfisher
import CoreLocation
import UIColor_Hex_Swift

class MainInvitationViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate , CLLocationManagerDelegate{

    @IBOutlet weak var likeButton: DCBorderedButton!
    
    @IBOutlet weak var superLikeButton: DCBorderedButton!
    
    @IBOutlet weak var dislikeButton: DCBorderedButton!
    
    @IBOutlet weak var inviteTitle: UILabel!
    
    @IBOutlet weak var inviteNumber: UILabel!
    
    @IBOutlet weak var invitePosition: UILabel!
    
    @IBOutlet weak var inviteTime: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var superLikedImage: UIImageView!
    
    
    // MARK: -ConfirmationField
    
    @IBOutlet weak var confirmationField: UIView!
    
    @IBOutlet weak var confirmationWhoAcceptedLabel: UILabel!
    
    @IBOutlet weak var reconfirmButton1: UIButton!
    
    @IBOutlet weak var circleReconfirmButton2: UIButton!
    
    @IBOutlet weak var refuseButton: UIButton!
    
    
    
    var viewType : InvitationPageTypes = .NormalInviteAcception
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    var usersList : [GetUserListForInviteRes] = [GetUserListForInviteRes]()
    
    var cells : [String] = [String]()
    
    var presentIndex : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.register(UINib(nibName: "FirsPageInvitationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirsPageInvitationCollectionViewCell")
        
        collectionView.register(UINib(nibName: "PartyPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PartyPageCollectionViewCell")
        
        collectionView.register(UINib(nibName: "DescriptionPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DescriptionPageCollectionViewCell")
        
        
        locationManager.delegate = self
        
        
        //check confirmation View
        self.configureView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        generateCellsArray()
        self.configureView()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.inviteTitle.layer.backgroundColor = GlobalFields.inviteMoodColor?.cgColor
        self.likeButton.frame.size.height = self.likeButton.frame.width
        self.likeButton.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.dislikeButton.frame.size.height = self.dislikeButton.frame.width
        self.dislikeButton.layer.cornerRadius = self.dislikeButton.frame.height / 2
    }

    func configureView(){
        
        
        if(self.viewType == .AddPersonToInvite || self.viewType == .ReconfirmInvite || self.viewType == .ShowProfile){
            self.inviteTitle.text = GlobalFields.inviteTitle
            self.inviteTitle.layer.borderWidth = 1
            self.inviteTitle.layer.borderColor = GlobalFields.inviteMoodColor?.cgColor
            self.inviteTitle.backgroundColor = UIColor.clear
            
            inviteNumber.text = ((GlobalFields.inviteNumber?.description) ?? "1") + " person"
            
            // distance calculation
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: (GlobalFields.inviteLocation?.latitude)!, longitude: (GlobalFields.inviteLocation?.longitude)!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "less than 1km"
            }else{
                disDesc = "about " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
            }
            
            invitePosition.text = disDesc
            
            self.confirmationWhoAcceptedLabel.alpha = 0
            
            let w = GlobalFields.inviteExactTime

            self.inviteTime.text = w?.toStringWithRelativeTime(strings : [.nowPast: "right now"])
            
            switch self.viewType{
                
            case  .AddPersonToInvite :
                
                self.confirmationField.alpha = 0
                self.likeButton.alpha = 1
                self.dislikeButton.alpha = 1
                self.superLikeButton.alpha = 1
                break
                
            case .ReconfirmInvite :
                
                self.confirmationField.alpha = 1
                self.likeButton.alpha = 0
                self.dislikeButton.alpha = 0
                self.superLikeButton.alpha = 0
                self.reconfirmButton1.alpha = 1
                self.circleReconfirmButton2.alpha = 1
                self.refuseButton.alpha = 1
                self.collectionView.frame.origin.y = self.confirmationField.frame.origin.y - self.collectionView.frame.height
                break
                
                
            case .ShowProfile :
                self.confirmationField.alpha = 1
                self.likeButton.alpha = 0
                self.dislikeButton.alpha = 0
                self.superLikeButton.alpha = 0
                self.reconfirmButton1.alpha = 0
                self.circleReconfirmButton2.alpha = 0
                self.collectionView.frame.origin.y = self.confirmationField.frame.origin.y - self.collectionView.frame.height
                self.refuseButton.alpha = 1
                self.refuseButton.setTitle("Retour", for: .normal)
                break
                
                
            default :
                
                self.confirmationField.alpha = 0
                self.likeButton.alpha = 1
                self.dislikeButton.alpha = 1
                self.superLikeButton.alpha = 1
                
            }
            
        }else if(self.viewType == .NormalInviteAcception || self.viewType == .PartyInviteAcception){
            
            self.inviteTitle.text = GlobalFields.myInvite?.title
            self.inviteTitle.layer.borderWidth = 1
            var col : UIColor = GlobalFields.getTypeColor(type: (GlobalFields.myInvite?.type)!)
            self.inviteTitle.layer.borderColor = col.cgColor
            self.inviteTitle.backgroundColor = col
            self.inviteTitle.textColor = UIColor.white
            
            inviteNumber.text = (GlobalFields.myInvite?.people_count?.description)! + " person"
            
            // distance calculation
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double((GlobalFields.myInvite?.latitude)!)!, longitude: Double((GlobalFields.myInvite?.longitude)!)!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "less than 1km"
            }else{
                disDesc = "about " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
            }
            
            invitePosition.text = disDesc
            
            let w = GlobalFields.myInvite?.when
            if(w == 0){
                self.inviteTime.text = "Right now"
            }else{
                let date : Date = Date().addingTimeInterval(Double(w!) * 60.0 * 30.0)
                let dateFormatterGet : DateFormatter = DateFormatter()
                dateFormatterGet.dateFormat = "HH:mm"
                self.inviteTime.text = dateFormatterGet.string(from: date)
            }
            
            
            self.superLikeButton.alpha = 0
            
            if(GlobalFields.myInvite?.superliked_at == 1){
                self.superLikedImage.alpha = 1
            }
            
            self.confirmationWhoAcceptedLabel.alpha = 0
            self.okButton.alpha = 0
            
            //set superliked image
            
        }
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goProfile(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goMessaging(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func like(_ sender: Any) {
        
        
        if(self.viewType == .NormalInviteAcception || self.viewType == .PartyInviteAcception){
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            
            request(URLs.acceptInvite, method: .post , parameters: AcceptInviteRequestModel.init(invite: (GlobalFields.myInvite?.invite_id)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                
                let res = response.result.value
                
                if(res?.status == "success"){
                    self.navigationController?.popViewController(animated: true)
                    (self.navigationController?.topViewController as! FirstMapViewController)
                    //TODO bayad bere tu safheye map ba message
                }
                
            }
        }else{
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            var user = self.usersList[presentIndex]
            
            request(URLs.likePersonForInvite, method: .post , parameters: LikePersonForInviteRequestModel.init(invite: GlobalFields.invite!, targetUser: user.id!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                
                let res = response.result.value
                
                if(res?.status == "success"){
                    self.goNext()
                }
                
            }
        }
        
    }
    
    @IBAction func dislike(_ sender: Any) {
        
        if(self.viewType == .NormalInviteAcception || self.viewType == .PartyInviteAcception){
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            
            request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: (GlobalFields.myInvite?.invite_id)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                
                let res = response.result.value
                
                if(res?.status == "success"){
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else{
            self.goNext()
        }
    }
    
    @IBAction func superLike(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        var user = self.usersList[presentIndex]
        
        request(URLs.superlikeForInvite, method: .post , parameters: SuperLikePersonForInviteRequestModel.init(invite: GlobalFields.invite!, targetUser: user.id!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                self.ok("")
            }
            
        }
        
    }
    
    
    @IBAction func ok(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FirstMapViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    
    
    func goNext(){
        
        if(presentIndex + 1 <= self.usersList.count - 1){
            presentIndex += 1
            if(GlobalFields.defaults.integer(forKey: "seenPage") != nil){
                GlobalFields.defaults.set(GlobalFields.defaults.integer(forKey: "seenPage") + 1, forKey: "seenPage")
            }else{
                GlobalFields.defaults.set( 1, forKey: "seenPage")
            }
            if(GlobalFields.defaults.integer(forKey: "seenPage") == 3){
                let vC : StopShowInviteGaideViewController = (self.storyboard?.instantiateViewController(withIdentifier: "StopShowInviteGaideViewController"))! as! StopShowInviteGaideViewController
                addChildViewController(vC)
                vC.view.frame = self.view.frame
                self.view.addSubview(vC.view)
                vC.didMove(toParentViewController: self)
            }
            self.collectionView.reloadData()
        }else{
            //call page bad
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            request(URLs.getUsersListForInvite, method: .post , parameters: GetUsersListForInviteRequestModel.init(invite: GlobalFields.invite!, page: 1, perPage: 100, lat: (GlobalFields.inviteLocation?.latitude.description)!, long: (GlobalFields.inviteLocation?.longitude.description)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetUserListForInviteRes]>>) in
                
                let res = response.result.value
                if(res?.data != nil && (res?.data?.count)! > 0){
                    for r in (res?.data)!{
                        self.usersList.append(r)
                    }
                    self.viewType = .AddPersonToInvite
                    self.presentIndex += 1
                    self.collectionView.reloadData()
                }else{
                    //TODO : bayad alert bedim k kasi nis doret
                    return
                }
            }

            
        }
        
    }
    
    
    
    // MARK: - Confirmation Method
    
    
    
    
    @IBAction func refuse(_ sender: Any) {
        
        if(self.viewType == .ShowProfile){
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        var user = self.usersList[presentIndex]
        
        request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: GlobalFields.invite!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
        
    }
    
    @IBAction func reConfirm(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        var user = self.usersList[presentIndex]
        
        request(URLs.confirmInvitation, method: .post , parameters: LikePersonForInviteRequestModel.init(invite: GlobalFields.invite!, targetUser: user.id!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                
                //inja k reconfirm mishe bayad bere tu map ba dokmeye messaging
                self.navigationController?.popViewController(animated: true)
                
                
            }
            
        }
        
    }
    
    func generateCellsArray(){
        cells.removeAll()
        let cell1 = "F"
        let cell2 = "S"
        let cell3 = "T"
        
        if(self.viewType == .NormalInviteAcception || self.viewType == .PartyInviteAcception){
            
            let user = GlobalFields.myInvite
            
            cells.append(cell1)
            
            if(GlobalFields.myInvite?.owner_seocond_avatar != nil || GlobalFields.myInvite?.owner_seocond_avatar != ""){
                cells.append(cell1)
            }
            
            cells.append(cell2)
            
            if(self.viewType == .PartyInviteAcception){
                cells.append(cell3)
            }
            
        }else{
            
            let user = self.usersList[presentIndex]
            
            cells.append(cell1)
            
            if(user.avatar2 != nil && user.avatar2 != ""){
                cells.append(cell1)
            }
            
            cells.append(cell2)
        }
        
    }
    
    // MARK: - collection delegate
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell1 : FirsPageInvitationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirsPageInvitationCollectionViewCell", for: indexPath as IndexPath) as! FirsPageInvitationCollectionViewCell
        let cell3 : PartyPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartyPageCollectionViewCell", for: indexPath as IndexPath) as! PartyPageCollectionViewCell
        let cell2 : DescriptionPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionPageCollectionViewCell", for: indexPath as IndexPath) as! DescriptionPageCollectionViewCell
        
        if(self.viewType == .NormalInviteAcception || self.viewType == .PartyInviteAcception){
            
            var user = GlobalFields.myInvite
            
            // age calculation
            let now = Date()
            let birthday: Date = Date(timeIntervalSince1970: TimeInterval(user!.owner_birthdate!))
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            let age = ageComponents.year!
            
            // distance calculation
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double((user?.latitude)!)!, longitude: Double((user?.longitude)!)!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "less than 1km"
            }else{
                disDesc = "about " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
            }
            
            if(self.cells[indexPath.item] == "F"){
                cell1.ageLabel.text = user?.owner_age?.description
                cell1.nameLabel.text = user?.owner_name
                cell1.distanceLabel.text = disDesc
                if(indexPath.item == 0){
                    cell1.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + (user?.owner_avatar!)!))
                }else{
                    cell1.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + (user?.owner_seocond_avatar!)!))
                }
                return cell1
            }else if(self.cells[indexPath.item] == "S"){
                cell2.age.text = user?.owner_age?.description
                cell2.name.text = user?.owner_name
                cell2.distance.text = disDesc
                cell2.bioText.text = user?.owner_bio
                cell2.city.text = ""

                return cell2
            }else if(self.cells[indexPath.item] == "T"){
                
                return cell3
            }
            
            
        }else{
            var user = self.usersList[presentIndex]
            var age : Int? = 0
            
            
            if(user.birthdate != nil){
                // age calculation
                let now = Date()
                let birthday: Date = Date(timeIntervalSince1970: TimeInterval(user.birthdate!))
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                age = ageComponents.year!
            }
            
            
            // distance calculation
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double(user.st_x!)!, longitude: Double(user.st_y!)!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "less than 1km"
            }else{
                disDesc = "about " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
            }
            
            
            if(self.cells[indexPath.item] == "F"){
                
                cell1.ageLabel.text = age?.description
                cell1.nameLabel.text = user.name
                cell1.distanceLabel.text = disDesc
                if(indexPath.item == 0){
                    cell1.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + (user.avatar1!)))
                }else{
                    cell1.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + (user.avatar2!)))
                }
                return cell1
            }else if(self.cells[indexPath.item] == "S"){
                cell2.age.text = age?.description
                cell2.name.text = user.name
                cell2.distance.text = disDesc
                cell2.bioText.text = user.bio
                cell2.city.text = ""
                
                return cell2
            }
            
        }
        
        return cell1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calculateCollectionPageNumber()
    }
    
    func calculateCollectionPageNumber() -> Int{
        if(self.viewType == .NormalInviteAcception || self.viewType == .PartyInviteAcception){
            var count : Int = 2
            if(GlobalFields.myInvite?.owner_seocond_avatar != nil || GlobalFields.myInvite?.owner_seocond_avatar != ""){
               count += 1
            }
            if(self.viewType == .PartyInviteAcception){
                count += 1
            }
            return count
            
        }else{
            var user = self.usersList[presentIndex]
            var count : Int = 2
            if(user.avatar2 != nil || user.avatar2 != ""){
                count += 1
            }
            return count
        }
    }
    
}
