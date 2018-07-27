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
import Toast_Swift

class MainInvitationViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate , CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout{

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
    
    @IBOutlet var cancelInviteButton: UIButton!
    
    
    
    
    var inviteID : Int? = nil
    
    var viewType : InvitationPageTypes = .NormalInviteAcception
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    var usersList : [GetUserListForInviteRes] = [GetUserListForInviteRes]()
    
    var cells : [String] = [String]()
    
    var presentIndex : Int = 0
    
    var inviteInfo : InviteInfoRes?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelInviteButton.alpha = 0
        
        likeButton.alpha = 0
        
        dislikeButton.alpha = 0
        
        okButton.alpha = 0
        
        likeButton.cornerRadius = self.likeButton.frame.width / 2
        dislikeButton.cornerRadius = self.dislikeButton.frame.width / 2
        superLikeButton.cornerRadius = self.superLikeButton.frame.width / 2
        circleReconfirmButton2.layer.cornerRadius = self.circleReconfirmButton2.frame.width / 2
        reconfirmButton1.layer.cornerRadius = self.reconfirmButton1.frame.width / 2
        refuseButton.layer.cornerRadius = self.refuseButton.frame.width / 2
        
        collectionView.register(UINib(nibName: "FirsPageInvitationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirsPageInvitationCollectionViewCell")
        
        collectionView.register(UINib(nibName: "PartyPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PartyPageCollectionViewCell")
        
        collectionView.register(UINib(nibName: "DescriptionPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DescriptionPageCollectionViewCell")
        
        locationManager = CLLocationManager();
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
        //check confirmation View
//        self.configureView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(self.viewType == .AddPersonToInvite){
            generateCellsArray()
            self.configureView()
            collectionView.dataSource = self
            collectionView.delegate = self
            
        }else if(self.inviteID != nil){
            //inja bayad check beshe getinviteinfo chi hastesh
            let l = GlobalFields.showLoading(vc: self)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            request(URLs.getInviteInfo, method: .post , parameters: GetInviteInfoRequestModel.init(invite: inviteID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<InviteInfoRes>>) in
                
                let res = response.result.value
                l.disView()
                if(res?.data != nil){
                    self.inviteInfo = res?.data
                    self.generateCellsArray()
                    self.configureView()
                    self.collectionView.dataSource = self
                    self.collectionView.delegate = self
                    self.collectionView.reloadData()
                    if(!GlobalFields.defaults.bool(forKey: "isShowAfterParty") && self.viewType == .AfterParty){
                        GlobalFields.defaults.set(true, forKey: "isShowAfterParty")
                        let vC : TheDayAfterViewController = (self.storyboard?.instantiateViewController(withIdentifier: "TheDayAfterViewController"))! as! TheDayAfterViewController
                        self.addChildViewController(vC)
                        vC.view.frame = self.view.frame
                        self.view.addSubview(vC.view)
                        vC.didMove(toParentViewController: self)
                    }
                }
                
            }
        }

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.likeButton.frame.size.height = self.likeButton.frame.width
//        self.likeButton.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.dislikeButton.frame.size.height = self.dislikeButton.frame.width
//        self.dislikeButton.layer.cornerRadius = self.dislikeButton.frame.height / 2
        if(self.viewType == .AddPersonToInvite){
            self.inviteTitle.layer.backgroundColor = GlobalFields.inviteMoodColor?.cgColor
        }
    }

    func configureView(){
        
        self.dislikeButton.setImage(UIImage.init(named: "dis"), for: [])
        self.dislikeButton.setImage(UIImage.init(named: "dis-1"), for: .highlighted)
        
        
        if(self.viewType != .AddPersonToInvite){
            
            self.cancelInviteButton.alpha = 0
            self.cancelInviteButton.isEnabled = false
            self.inviteTitle.text = inviteInfo?.main?.title
            self.inviteTitle.layer.borderWidth = 1
            self.inviteTitle.layer.borderColor = GlobalFields.getTypeColor(type: (inviteInfo?.main?.type)!).cgColor
            self.inviteTitle.layer.backgroundColor = GlobalFields.getTypeColor(type: (inviteInfo?.main?.type)!).cgColor
//            self.inviteTitle.backgroundColor = GlobalFields.getTypeColor(type: (inviteInfo?.main?.type)!)
            self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
            
            switch (inviteInfo?.main?.type)! {
            case 1:
                likeButton.setBackgroundImage(UIImage.init(named: "z"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "z-1"), for: .highlighted)
                superLikeButton.alpha = 0
                break
            case 2:
                likeButton.setBackgroundImage(UIImage.init(named: "t"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "t-1"), for: .highlighted)
                superLikeButton.setBackgroundImage(UIImage.init(named: "cg"), for: .normal)
                break
            case 3:
                likeButton.setBackgroundImage(UIImage.init(named: "e"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "e-1"), for: .highlighted)
                superLikeButton.setBackgroundImage(UIImage.init(named: "cr"), for: .normal)
                break
            case 4:
                likeButton.setBackgroundImage(UIImage.init(named: "r"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "r-1"), for: .highlighted)
                superLikeButton.setBackgroundImage(UIImage.init(named: "cy"), for: .normal)
                break
                
            default:
                likeButton.setBackgroundImage(UIImage.init(named: "z"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "z-1"), for: .highlighted)
            }
            
            
            
            inviteNumber.text = Int((inviteInfo?.main?.people_count)!).description + " personne"
            
            // distance calculation
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double((inviteInfo?.main?.location_lat)!)!, longitude: Double((inviteInfo?.main?.location_lng)!)!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "à moins d’1km"
            }else{
                disDesc = "à " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
            }
            
            invitePosition.text = disDesc
            
            self.confirmationWhoAcceptedLabel.alpha = 0
            
            let w = Date.init(timeIntervalSince1970: TimeInterval((inviteInfo?.main?.exact_time)!))
            
            self.inviteTime.text = w.toStringWithRelativeTime(strings : [.nowPast : "maintenant",.secondsPast: "Maintenant",.minutesPast: "Maintenant"])
            
        }else{
            self.cancelInviteButton.alpha = 1
            self.cancelInviteButton.isEnabled = true
            var type : Int = 0
            switch GlobalFields.inviteMood! {
            case "LetsSeeWhatHappens":
                type = 3
                break
            case "Friendly":
                type = 4
                break
            case "Business":
                type = 2
                break
            default:
                type = 1
            }
            
//            if(!GlobalFields.defaults.bool(forKey: "EqualityViewController") && type == 1){
//                GlobalFields.defaults.set(true, forKey: "EqualityViewController")
//                let vC : EqualityViewController = (self.storyboard?.instantiateViewController(withIdentifier: "EqualityViewController"))! as! EqualityViewController
//                addChildViewController(vC)
//                vC.view.frame = self.view.frame
//                self.view.addSubview(vC.view)
//                vC.didMove(toParentViewController: self)
//            }
            self.inviteTitle.text = GlobalFields.inviteTitle
            self.inviteTitle.layer.borderWidth = 1
            self.inviteTitle.layer.borderColor = GlobalFields.inviteMoodColor?.cgColor
            self.inviteTitle.layer.backgroundColor = GlobalFields.inviteMoodColor?.cgColor
            self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
            
            inviteNumber.text = ((GlobalFields.inviteNumber?.description) ?? "1") + " personne"
            
            switch (type) {
            case 1:
                likeButton.setBackgroundImage(UIImage.init(named: "z"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "z-1"), for: .highlighted)
                superLikedImage.alpha = 0
                superLikeButton.alpha = 0
                break
            case 2:
                likeButton.setBackgroundImage(UIImage.init(named: "t"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "t-1"), for: .highlighted)
                superLikeButton.setBackgroundImage(UIImage.init(named: "cg"), for: .normal)
                superLikedImage.image = UIImage.init(named: "wg")
                break
            case 3:
                likeButton.setBackgroundImage(UIImage.init(named: "e"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "e-1"), for: .highlighted)
                superLikeButton.setBackgroundImage(UIImage.init(named: "cr"), for: .normal)
                superLikedImage.image = UIImage.init(named: "wr")
                break
            case 4:
                likeButton.setBackgroundImage(UIImage.init(named: "r"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "r-1"), for: .highlighted)
                superLikeButton.setBackgroundImage(UIImage.init(named: "cy"), for: .normal)
                superLikedImage.image = UIImage.init(named: "wy")
                break
                
            default:
                likeButton.setBackgroundImage(UIImage.init(named: "z"), for: [])
                likeButton.setBackgroundImage(UIImage.init(named: "z-1"), for: .highlighted)
            }
            
            // distance calculation
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: (GlobalFields.inviteLocation?.latitude)!, longitude: (GlobalFields.inviteLocation?.longitude)!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "à moins d’1km"
            }else{
                disDesc = "à " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
            }
            
            invitePosition.text = disDesc
            
            self.confirmationWhoAcceptedLabel.alpha = 0
            
            let w = GlobalFields.inviteExactTime

            self.inviteTime.text = w?.toStringWithRelativeTime(strings : [.nowPast : "maintenant ",.secondsPast: "Maintenant",.minutesPast: "Maintenant"])
            
        }
        
        switch self.viewType{
            
        case  .AddPersonToInvite :
            
            self.confirmationField.alpha = 0
            self.likeButton.alpha = 1
            self.dislikeButton.alpha = 1
            self.okButton.alpha = 1
            if(GlobalFields.inviteMood! == "Party"){
                self.superLikeButton.alpha = 0
            }else{
                self.superLikeButton.alpha = 1
            }
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
            self.okButton.alpha = 0
            break
          
        case .ConfirmInvite:
            
            self.confirmationField.alpha = 1
            self.likeButton.alpha = 0
            self.dislikeButton.alpha = 0
            self.superLikeButton.alpha = 0
            self.reconfirmButton1.alpha = 1
            self.circleReconfirmButton2.alpha = 1
            self.refuseButton.alpha = 1
            self.collectionView.frame.origin.y = self.confirmationField.frame.origin.y - self.collectionView.frame.height
            self.okButton.alpha = 0
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
            self.okButton.alpha = 0
            break
            
        case .AfterParty :
            self.superLikeButton.alpha = 0
            self.likeButton.alpha = 1
            self.dislikeButton.alpha = 1
            self.superLikedImage.alpha = 0
            self.confirmationWhoAcceptedLabel.alpha = 0
            self.okButton.alpha = 0
            
        case .NormalInviteAcception :
            self.superLikeButton.alpha = 0
            self.likeButton.alpha = 1
            self.dislikeButton.alpha = 1
            if(GlobalFields.myInvite?.superliked_at != 0){
                self.superLikedImage.alpha = 1
            }
            
            self.confirmationWhoAcceptedLabel.alpha = 0
            self.okButton.alpha = 0
            
            //set superliked image
            
        case .PartyInviteAcception :
            self.superLikeButton.alpha = 0
            self.likeButton.alpha = 1
            self.dislikeButton.alpha = 1
            if(GlobalFields.myInvite?.superliked_at == 1){
                self.superLikedImage.alpha = 1
            }
            
            self.confirmationWhoAcceptedLabel.alpha = 0
            self.okButton.alpha = 0
            
            //set superliked image
            
        default :
            self.collectionView.alpha = 1
            
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
    
    func like2(){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.acceptInvite, method: .post , parameters: AcceptInviteRequestModel.init(invite: (GlobalFields.myInvite?.invite_id)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.status == "success"){
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: FirstMapViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else{
                let vC : TooLateViewController = (self.storyboard?.instantiateViewController(withIdentifier: "TooLateViewController"))! as! TooLateViewController
                self.addChildViewController(vC)
                vC.view.frame = self.view.frame
                self.view.addSubview(vC.view)
                vC.didMove(toParentViewController: self)
                self.view.makeToast(res?.message)
            }
            
        }
    }
    
    @IBAction func like(_ sender: Any) {
        
        if(self.viewType == .AfterParty){
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            var user = self.usersList[presentIndex]
            let l = GlobalFields.showLoading(vc: self)
            request(URLs.likeUser, method: .post , parameters: LikeUserRequestModel.init(targetUser: user.id!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                l.disView()
                let res = response.result.value
                
                if(res?.status == "success"){
                    self.goNext()
                }else if(res?.errCode == -2){
                    self.view.makeToast(res?.message)
                    self.goNext()
                }
                
            }
            
        }else if(self.viewType == .NormalInviteAcception || self.viewType == .PartyInviteAcception){
            
            if((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2])?.isKind(of: FirstMapViewController.self))!{
                if(((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]) as! FirstMapViewController).ownInvite != nil){
                    let vC : OneAtATimeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "OneAtATimeViewController"))! as! OneAtATimeViewController
                    
                    self.addChildViewController(vC)
                    vC.view.frame = .init(origin: .init(x: 0, y: 0), size: self.view.frame.size)  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                    self.view.addSubview(vC.view)
                }else{
                    like2()
                }
            }
            
        }else{
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            var user = self.usersList[presentIndex]
            let l = GlobalFields.showLoading(vc: self)
            request(URLs.likePersonForInvite, method: .post , parameters: LikePersonForInviteRequestModel.init(invite: GlobalFields.invite!, targetUser: user.id!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                l.disView()
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
            
            let l = GlobalFields.showLoading(vc: self)
            request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: (GlobalFields.myInvite?.invite_id)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                l.disView()
                let res = response.result.value
                
                if(res?.status == "success"){
                    GlobalFields.defaults.set(true, forKey: (GlobalFields.myInvite?.invite_id?.description)!)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else{
            if(self.viewType == .AfterParty){
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                request(URLs.setAboutLastNight, method: .post , parameters: UploadImageRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                    
                }
            }
            self.goNext()
        }
    }
    
    @IBAction func superLike(_ sender: Any) {
        
        if(!GlobalFields.defaults.bool(forKey: "TheOneSpecialPersonViewController")){
            GlobalFields.defaults.set(true, forKey: "TheOneSpecialPersonViewController")
            let vC : TheOneSpecialPersonViewController = (self.storyboard?.instantiateViewController(withIdentifier: "TheOneSpecialPersonViewController"))! as! TheOneSpecialPersonViewController
            addChildViewController(vC)
            vC.view.frame = self.view.frame
            self.view.addSubview(vC.view)
            vC.didMove(toParentViewController: self)
        }else{
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            var user = self.usersList[presentIndex]
            let l = GlobalFields.showLoading(vc: self)
            request(URLs.superlikeForInvite, method: .post , parameters: SuperLikePersonForInviteRequestModel.init(invite: GlobalFields.invite!, targetUser: user.id!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                l.disView()
                let res = response.result.value
                
                if(res?.status == "success"){
                    self.ok("")
                }else{
                    self.view.makeToast(res?.message)
                }
                
            }
        }
        
        
        
    }
    
    @IBAction func cancelInvite(_ sender: Any) {
        
        let vC : CancelInviteViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CancelInviteViewController"))! as! CancelInviteViewController
        print(GlobalFields.invite!)
        vC.inviteID = GlobalFields.invite!
        addChildViewController(vC)
        vC.view.frame = self.view.frame
        self.view.addSubview(vC.view)
        vC.didMove(toParentViewController: self)
        
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
            if(self.usersList[presentIndex].id?.description == GlobalFields.ID.description){
                goNext()
            }else{
                self.collectionView.reloadData()
            }
        }else{
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: FirstMapViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        
        self.collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .left, animated: true)
        
    }
    
    
    @objc func callReportPopup(){
        
        var target : Int = 0
        if(self.viewType != .AddPersonToInvite){
            
            var user = inviteInfo?.main
            if((user?.owner!.description)! == GlobalFields.ID.description){
                target = (inviteInfo?.users![0].user)!
            }else{
                target = (user?.owner!)!
            }
        }else{
            var user = self.usersList[presentIndex]
            target = 	user.id!
        }
        
        
        let vC : ReportInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ReportInvitationViewController"))! as! ReportInvitationViewController
        addChildViewController(vC)
        vC.target = target
        vC.view.frame = self.view.frame
        self.view.addSubview(vC.view)
        vC.didMove(toParentViewController: self)
        
    }
    
    
    
    
    // MARK: - Confirmation Method
    
    
    
    
    @IBAction func refuse(_ sender: Any) {
        
        if(self.viewType == .ShowProfile){
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: self.inviteID!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                GlobalFields.defaults.set(true, forKey: (self.inviteID?.description)!)
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
        
    }
    
    @IBAction func reConfirm(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        
        request(URLs.confirmInvitation, method: .post , parameters: ConfirmUserForInviteRequestModel.init(invite: self.inviteID?.description).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
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
        let cell31 = "F"
        
        if(self.viewType == .AddPersonToInvite || self.viewType == .AfterParty){
            
            let user = self.usersList[presentIndex]
            
            cells.append(cell1)
            
            if(user.avatar2 != nil && user.avatar2 != "" && user.avatar2 != "avatar.png" && user.avatar2 != "img/avatar.jpeg"){
                cells.append(cell1)
            }
            
            cells.append(cell2)
        }else{
            
            let user = inviteInfo?.main
            
            cells.append(cell1)
            
            if(user?.type != 1){
                //party nabashe
                //bayad check konim khodesh owner hast ya na
                if((user?.owner!.description)! == GlobalFields.ID.description){//TODO : loginResData bayad check beshe
                    //yani owner khodeshe bayad akse usero neshun
                    
                    if(inviteInfo?.users![0].second_avatar != nil && inviteInfo?.users![0].second_avatar != "" && inviteInfo?.users![0].second_avatar != "avatar.png" && inviteInfo?.users![0].second_avatar != "img/avatar.jpeg"){
                        cells.append(cell1)
                    }
                }else{
                    //owner khodesh nis
                    if(user?.owner_second_avatar != nil && user?.owner_second_avatar != "" && user?.owner_second_avatar != "avatar.png" && user?.owner_second_avatar != "img/avatar.jpeg"){
                        cells.append(cell1)
                    }
                }
            }else{
                //party bashe
                if(user?.owner_second_avatar != nil && user?.owner_second_avatar != "" && user?.owner_second_avatar != "avatar.png" && user?.owner_second_avatar != "img/avatar.jpeg"){
                    cells.append(cell1)
                }
            }
            
            cells.append(cell2)
            
            if(user?.type == 1){
                cells.append(cell3)
            }
            if(inviteInfo?.users != nil && (inviteInfo?.users?.count)! > 6){
                cells.append(cell31)
            }
            
        }
        
    }
    
    // MARK: - collection delegate
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell1 : FirsPageInvitationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirsPageInvitationCollectionViewCell", for: indexPath as IndexPath) as! FirsPageInvitationCollectionViewCell
        let cell3 : PartyPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartyPageCollectionViewCell", for: indexPath as IndexPath) as! PartyPageCollectionViewCell
        let cell2 : DescriptionPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionPageCollectionViewCell", for: indexPath as IndexPath) as! DescriptionPageCollectionViewCell
        
        cell1.frame.size.width = self.view.frame.width
        cell1.frame.size.height = self.collectionView.frame.height
        cell2.frame.size.width = self.view.frame.width
        cell2.frame.size.height = self.collectionView.frame.height
        cell3.frame.size.width = self.view.frame.width
        cell3.frame.size.height = self.collectionView.frame.height
        
        if(self.viewType != .AddPersonToInvite && self.viewType != .AfterParty){
            
            var user = inviteInfo?.main
            
            var birth : Int?
            var lat : String?
            var long : String?
            var avat : String?
            var secAvatar : String?
            var name : String?
            var bio : String?
            var city : String?
            
            print(GlobalFields.ID.description)
            print((user?.owner!.description)!)
            if((user?.owner!.description)! == GlobalFields.ID.description){
                //yani owner khodeshe
                birth = inviteInfo?.users![0].birthdate
                lat = inviteInfo?.users![0].latitude
                long = inviteInfo?.users![0].longitude
                avat = inviteInfo?.users![0].avatar
                secAvatar = inviteInfo?.users![0].second_avatar
                name = inviteInfo?.users![0].name
                bio =  inviteInfo?.users![0].bio
                city = inviteInfo?.users![0].city
            }else{
                //yani owner khodesh nis
                birth = user?.owner_birth
                lat = user?.owner_y
                long = user?.owner_x
                avat = user?.owner_avatar
                secAvatar = user?.owner_second_avatar
                name = user?.owner_name
                bio = user?.owner_bio
                city = user?.owner_city
            }
            
            
            // age calculation
            let now = Date()
            let birthday: Date = Date(timeIntervalSince1970: TimeInterval(birth!))
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            let age = ageComponents.year!
            
            // distance calculation
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double((lat) ?? "35.673609")!, longitude: Double((long) ?? "51.215621")!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "à moins d’1km"
            }else{
                disDesc = "à " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
            }
            
            if(self.cells[indexPath.item] == "F"){
                cell1.ageLabel.text = age.description
                cell1.nameLabel.text = name
                cell1.distanceLabel.text = disDesc
                if(indexPath.item == 0){
                    cell1.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + (avat)!))
                }else{
                    cell1.profileImage.kf.setImage(with: URL.init(string: URLs.imgServer + (secAvatar!)))
                }
                return cell1
            }else if(self.cells[indexPath.item] == "S"){
                cell2.name.text = name ?? "" + ", " + age.description
                cell2.distance.text = disDesc
                cell2.bioText.text = bio
                cell2.city.text = city
                cell2.reportButton.addTarget(self, action: #selector(self.callReportPopup), for: .touchUpInside)
                return cell2
            }else if(self.cells[indexPath.item] == "T"){
                cell3.distanceLabel.text = disDesc
                var i = 1
                for u in (inviteInfo?.users)!{
                    if(u.user?.description == GlobalFields.ID.description){
                        continue
                    }
                    (cell3.viewWithTag(i) as! UIImageView).kf.setImage(with: URL.init(string: URLs.imgServer + u.avatar!))
                    (cell3.viewWithTag(i) as! UIImageView).alpha = 1
                    (cell3.viewWithTag(i) as! UIImageView).layer.cornerRadius = (cell3.viewWithTag(i) as! UIImageView).frame.height / 2
                    (cell3.viewWithTag(i) as! UIImageView).clipsToBounds = true
                    (cell3.viewWithTag(i + 6) as! UILabel).text = u.name
                    (cell3.viewWithTag(i + 6) as! UILabel).alpha = 1
                    i += 1
                }
                cell3.reportButton.addTarget(self, action: #selector(self.callReportPopup), for: .touchUpInside)
                return cell3
            }else if(self.cells[indexPath.item] == "F"){
                cell3.distanceLabel.text = disDesc
                var i = 1
                for u in (inviteInfo?.users)!{
                    if(i > 6){
                        if(u.user?.description == GlobalFields.ID.description){
                            continue
                        }
                        (cell3.viewWithTag(i - 6) as! UIImageView).kf.setImage(with: URL.init(string: URLs.imgServer + u.avatar!))
                        (cell3.viewWithTag(i - 6) as! UIImageView).alpha = 1
                        (cell3.viewWithTag(i - 6) as! UIImageView).layer.cornerRadius = (cell3.viewWithTag(i - 6) as! UIImageView).frame.height / 2
                        (cell3.viewWithTag(i - 6) as! UIImageView).clipsToBounds = true
                        (cell3.viewWithTag(i + 6 - 6) as! UILabel).text = u.name
                        (cell3.viewWithTag(i + 6 - 6) as! UILabel).alpha = 1
                    }
                    i += 1
                }
                cell3.reportButton.addTarget(self, action: #selector(self.callReportPopup), for: .touchUpInside)
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
            let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double(user.st_y!)!, longitude: Double(user.st_x!)!))
            
            var disDesc : String = ""
            if(Double((myLoc?.description)!)! / 1000 < 1){
                disDesc = "à moins d’1km"
            }else{
                disDesc = "à " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
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
                cell2.name.text = user.name ?? "" + ", " + (age?.description)!
                cell2.distance.text = disDesc
                cell2.bioText.text = user.bio
                cell2.city.text = ""
                cell2.reportButton.addTarget(self, action: #selector(self.callReportPopup), for: .touchUpInside)
                return cell2
            }
            
        }
        
        return cell1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width, height: self.collectionView.frame.height)
    }
    
}
