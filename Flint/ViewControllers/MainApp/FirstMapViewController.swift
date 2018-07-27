//
//  FirstMapViewController.swift
//  flint
//
//  Created by MILAD on 4/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import MapKit
import MapKitGoogleStyler
import CoreLocation
import UIColor_Hex_Swift
import Alamofire
import CodableAlamofire
import DCKit
import BvMapCluster
import ClusterKit
import Kingfisher
import AFDateHelper
import TransitionTreasury
import OneSignal


class FirstMapViewController: UIViewController ,MKMapViewDelegate , UINavigationControllerDelegate , CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var invitationButton: DCBorderedButton!
    
    @IBOutlet weak var lighterButton: DCBorderedButton!
    
    @IBOutlet weak var invitationAwating: DCBorderedButton!
    
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var shadowView: UIView!
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    var myInvites : [MyInvites] = [MyInvites]()
    
    var type : MapPageTypes = .NormalMap
    
    // MARK: goDate Fields
    @IBOutlet weak var messageButton: DCBorderedButton!
    
    @IBOutlet weak var ownerImageButton: DCBorderedButton!
    
    // MARK: AboutLastNight Fields
    
    @IBOutlet weak var aboutLastNightView: UIView!
    
    @IBOutlet weak var lastNightButton: DCBorderedButton!
    
    @IBOutlet weak var inviteTitle: UILabel!
    
    @IBOutlet weak var inviteNumber: UILabel!
    
    @IBOutlet weak var invitePosition: UILabel!
    
    @IBOutlet weak var inviteTime: UILabel!
    
    @IBOutlet weak var directionButton: UIButton!
    
    @IBOutlet var centerMapButton: UIButton!
    
    @IBOutlet var whoAcceptedLabel: UILabel!
    
    @IBOutlet var chatButton: UIButton!
    
    
    var l : LoadingViewController?
    
    
    var isThereOtherInvite : Bool = false
    var ownInvite : MyInvites? = nil
    var otherInvite : MyInvites? = nil
    
    @IBOutlet var otherInviteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.delegate = self
        
        mapView.delegate = self
        self.ownerImageButton.backgroundColor = GlobalFields.getTypeColor(type: 1)
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 400
        self.mapView.clusterManager.algorithm = algorithm
        self.mapView.clusterManager.marginFactor = 1
        self.mapView.clusterManager.maxZoomLevel = 16
        self.otherInviteButton.alpha = 0

        GlobalFields.userInfo.AVATAR = GlobalFields.loginResData?.avatar
        GlobalFields.userInfo.BIO = GlobalFields.loginResData?.bio
        GlobalFields.userInfo.BIRTHDATE = GlobalFields.loginResData?.birthdate
        GlobalFields.userInfo.GENDER = GlobalFields.loginResData?.gender
        GlobalFields.userInfo.JOB = GlobalFields.loginResData?.job
        GlobalFields.userInfo.USERNAME = GlobalFields.loginResData?.username
        GlobalFields.userInfo.NAME = GlobalFields.loginResData?.name
        GlobalFields.userInfo.TOKEN = GlobalFields.loginResData?.token
        GlobalFields.userInfo.STUDIES = GlobalFields.loginResData?.studies
        
        // Fallback on earlier versions
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        configureTileOverlay()
        
        self.ownerImageButton.frame.size.height = self.ownerImageButton.frame.size.width
        self.ownerImageButton.layer.cornerRadius = self.ownerImageButton.frame.height / 2
        self.ownerImageButton.cornerRadius = self.ownerImageButton.frame.height / 2
        
        self.messageButton.frame.size.height = self.messageButton.frame.size.width
        self.messageButton.layer.cornerRadius = self.messageButton.frame.height / 2
        self.messageButton.cornerRadius = self.messageButton.frame.height / 2
        
        self.invitationButton.frame.size.height = self.invitationButton.frame.size.width
        self.invitationButton.layer.cornerRadius = self.invitationButton.frame.height / 2
        self.invitationButton.cornerRadius = self.invitationButton.frame.height / 2
        
        
        ownerImageButton.titleLabel?.numberOfLines = 1
        ownerImageButton.titleLabel?.minimumScaleFactor = 0.5
        ownerImageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        messageButton.titleLabel?.numberOfLines = 1
        messageButton.titleLabel?.minimumScaleFactor = 0.5
        messageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        messageButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        messageButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        messageButton.layer.shadowOpacity = 1.0
        messageButton.layer.masksToBounds = false
        
        
        
        invitationButton.titleLabel?.numberOfLines = 1
        invitationButton.titleLabel?.minimumScaleFactor = 0.5
        invitationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        invitationButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        invitationButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        invitationButton.layer.shadowOpacity = 1.0
        invitationButton.layer.masksToBounds = false
        
        
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.masksToBounds = false
        
        self.showInviteBadge(num: 0)
        for v in self.messageButton.subviews {
            v.isUserInteractionEnabled = true
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.sendMessage(_:))))
        }

        Timer.scheduledTimer(timeInterval: 120 , target: self, selector: #selector(callGetMyInvitesRest), userInfo: nil, repeats: true)

        
        if(locationManager.location != nil){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        GlobalFields.setAnalytics("FirstMapViewController")
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            GlobalFields.oneSignalId = userId
            if(GlobalFields.USERNAME != nil && GlobalFields.USERNAME != "" && GlobalFields.TOKEN != nil && GlobalFields.TOKEN != ""){
                self.updateOneSignal(id : userId)
            }
        })
        callGetActiveInvites(showLoading: true)
        self.navigationController?.delegate = self
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)

            self.updateLocationServer(locCor: center)
            GlobalFields.myLocation = center
            
            for an in self.mapView.annotations{
                if(an is MyAnnotation){
                    if((an as! MyAnnotation).identifier == "myPosition"){
                        self.mapView.removeAnnotation(an)
                    }
                }
            }
            let marker = MyAnnotation()
            marker.coordinate = (self.locationManager.location?.coordinate)!
            marker.identifier = "myPosition"
            mapView.addAnnotation(marker)

        }else{

        }
        if(!GlobalFields.defaults.bool(forKey: "showChatBadge")){
            self.hideChatBadge()
        }else{
            self.showChatBadge()
        }
        
        self.updateInviteBadge()
        for v in self.messageButton.subviews {
            v.isUserInteractionEnabled = true
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.sendMessage(_:))))
        }
        self.moveCenter("")
        
    }

    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if(fromVC.isKind(of: MainProfileViewController.self)){
            return nil
        }else if(fromVC.isKind(of: SparksViewController.self)){
            return nil
        }else if(toVC.isKind(of: SparksViewController.self)){
            let t = TransitionManager()
            t.coef = 1
            return t
        }else if(toVC.isKind(of: MainProfileViewController.self)){
            let t = TransitionManager()
            t.coef = -1
            return t
        }else{
            return nil
        }
        
    }
    
    
    func getInviteInfo(inv : MyInvites){
        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getInviteInfo, method: .post , parameters: GetInviteInfoRequestModel.init(invite: inv.invite_id!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<InviteInfoRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.data != nil){
                self.setTopView(inv : res?.data)
            }
            
        }
    }
    
    
    @objc func showAll(){
        self.mapView.fitAll()
    }
    
    func configureView(){
        
        if(type == .Awaiting){
            
            self.invitationAwating.alpha = 1
            var type : Int = 1
            if(isThereOtherInvite && self.ownInvite != nil){
                type = (ownInvite?.type)!
            }else if(isThereOtherInvite && self.ownInvite == nil){
                type = (otherInvite?.type!)!
            }else if(ownInvite != nil){
                type = (ownInvite?.type)!
            }
            self.invitationAwating.backgroundColor = GlobalFields.getTypeColor(type: type)
            self.invitationButton.alpha = 0
            self.lighterButton.alpha = 0
            self.messageButton.alpha = 0
            self.ownerImageButton.alpha = 0
            self.aboutLastNightView.alpha = 0
            self.whoAcceptedLabel.alpha = 0
            self.inviteTitle.alpha = 0
            self.inviteNumber.alpha = 0
            self.invitePosition.alpha = 0
            self.inviteTime.alpha = 0
            self.cancelButton.alpha = 0
            self.mapView.frame.origin.y = 96 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            self.centerMapButton.alpha = 1
            self.centerMapButton.isEnabled = true
            self.directionButton.alpha = 0
            shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowView.layer.shadowOpacity = 1.0
            shadowView.layer.masksToBounds = false
            
        }else if(type == .GoDate){
            
            shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowView.layer.shadowOpacity = 0.0
            shadowView.layer.masksToBounds = true
            self.messageButton.alpha = 1
            self.showInviteBadge(num: 0)
            self.ownerImageButton.alpha = 1
            self.invitationAwating.alpha = 0
            self.invitationButton.alpha = 0
            self.lighterButton.alpha = 0
            self.aboutLastNightView.alpha = 0
            self.mapView.frame.origin.y = 202 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            self.whoAcceptedLabel.alpha = 1
            self.whoAcceptedLabel.frame.origin.y = self.mapView.frame.origin.y - self.whoAcceptedLabel.frame.height
            //inja bayad getinviteinfo nemud
            
            var inv : MyInvites? = nil
            if(self.otherInvite == nil && self.ownInvite != nil){
                inv = ownInvite
            }else if(self.otherInvite != nil && self.ownInvite == nil){
                inv = otherInvite
            }else if(ownInvite != nil){
                inv = ownInvite
            }
            
            self.myInvites.removeAll()
            self.myInvites.append(inv!)
            setMarkers()
            self.getInviteInfo(inv: inv!)
            self.centerMapButton.alpha = 0
            self.centerMapButton.isEnabled = false
            self.updateInviteBadge()
            
        }else if(type == .NormalMap){
            
            self.invitationAwating.alpha = 0
            self.invitationButton.alpha = 1
            self.lighterButton.alpha = 0
            self.messageButton.alpha = 0
            self.ownerImageButton.alpha = 0
            self.aboutLastNightView.alpha = 0
            self.whoAcceptedLabel.alpha = 0
            self.mapView.frame.origin.y = 96 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            self.centerMapButton.alpha = 1
            self.centerMapButton.isEnabled = true
            self.directionButton.alpha = 0
            self.inviteTitle.alpha = 0
            self.inviteNumber.alpha = 0
            self.invitePosition.alpha = 0
            self.inviteTime.alpha = 0
            self.cancelButton.alpha = 0
            shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowView.layer.shadowOpacity = 1.0
            shadowView.layer.masksToBounds = false
            
        }else if(type == .AboutLastNight){
            
            self.invitationAwating.alpha = 0
            self.invitationButton.alpha = 0
            self.lighterButton.alpha = 0
            self.messageButton.alpha = 0
            self.ownerImageButton.alpha = 0
            self.whoAcceptedLabel.alpha = 0
            self.aboutLastNightView.alpha = 1
            self.mapView.frame.origin.y = 96 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            self.centerMapButton.alpha = 1
            self.centerMapButton.isEnabled = true
            self.directionButton.alpha = 0
            shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowView.layer.shadowOpacity = 1.0
            shadowView.layer.masksToBounds = false
            self.inviteTitle.alpha = 0
            self.inviteNumber.alpha = 0
            self.invitePosition.alpha = 0
            self.inviteTime.alpha = 0
            self.cancelButton.alpha = 0
            
        }
        
        
        if(isThereOtherInvite && self.ownInvite != nil){
            self.otherInviteButton.frame.origin.y = self.mapView.frame.origin.y
            self.otherInviteButton.alpha = 1
            shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowView.layer.shadowOpacity = 0.0
            shadowView.layer.masksToBounds = true
        }else{
            self.otherInviteButton.frame.origin.y = self.mapView.frame.origin.y
            self.otherInviteButton.alpha = 0
        }
        
    }
    
    func setTopView(inv : InviteInfoRes!){
        
        
        if(inv.main?.type?.description == 1.description){
            self.ownerImageButton.setTitle("🎉" , for: .normal)
            self.ownerImageButton.backgroundColor = GlobalFields.getTypeColor(type: 1)
            self.ownerImageButton.normalBackgroundColor = GlobalFields.getTypeColor(type: 1)
            self.whoAcceptedLabel.text = "Invitation acceptée!"
        }else{
            if(GlobalFields.ID.description == (inv.main?.owner?.description)!){
                //owner khodeti
                self.ownerImageButton.kf.setImage(with: URL.init(string:
                    URLs.imgServer + inv.users![0].avatar!), for: .normal)
                self.whoAcceptedLabel.text = inv.users![0].name! + " a accepté votre invitation!"
            }else{
                //owner tu usere
                self.ownerImageButton.kf.setImage(with: URL.init(string:
                    URLs.imgServer + (inv.main?.owner_avatar!)!), for: .normal)
                self.whoAcceptedLabel.text = "Invitation acceptée!"
            }
           
        }
        
        self.inviteTitle.text = inv?.main?.title
        self.inviteTitle.layer.borderWidth = 1
        let col : UIColor = GlobalFields.getTypeColor(type: inv!.main!.type!)
        self.inviteTitle.layer.borderColor = col.cgColor
//        self.inviteTitle.backgroundColor = col
        self.inviteTitle.layer.backgroundColor = col.cgColor
        self.inviteTitle.textColor = UIColor.white
        self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.inviteTitle.alpha = 1
        self.inviteNumber.alpha = 1
        self.invitePosition.alpha = 1
        self.inviteTime.alpha = 1
        self.cancelButton.alpha = 1
        GlobalFields.inviteMoodColor = col
        self.ownerImageButton.normalBorderColor = col
        
        inviteNumber.text = (inv?.main?.people_count?.description)! + " personne"
        
        // distance calculation
        let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double((inv.main?.location_lat) ?? "35.673609")!, longitude: Double((inv.main?.location_lng ?? "51.215621")!)!))
        
        var disDesc : String = ""
        if(Double((myLoc?.description) ?? "0")! / 1000 < 1){
            disDesc = "à moins d’1km"
        }else{
            disDesc = "à " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
        }
        
        invitePosition.text = disDesc
        
        self.directionButton.alpha = 1
        
        let w = inv?.main?.exact_time
        self.inviteTime.text = Date.init(timeIntervalSince1970: Double(w!)).toStringWithRelativeTime(strings : [.nowPast: "Maintenant" ,.secondsPast: "Maintenant" , .oneHourPast : "ll y a 1 heure"])

        
    }
    
    
    func callGetActiveInvites(showLoading : Bool = false){
        
        if(showLoading == true){
            self.l = GlobalFields.showLoading(vc: self)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getActiveInvite, method: .post , parameters: OpenLighterRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<ActiveInviteRes>>) in
            
            let res = response.result.value
            
            print(res?.status)
            if(res?.status! == "success"){
                if(res?.data != nil){
                    if(res?.data?.owned_invitation != nil && res?.data?.other_invitations != nil){
                        if(self.l != nil){
                            self.l?.disView()
                            self.l = nil
                        }
                        self.ownInvite = res?.data?.owned_invitation!
                        self.otherInvite = res?.data?.other_invitations!
                        self.isThereOtherInvite = true
                        self.manageInvitesView(invite: res?.data?.owned_invitation!, res: res?.data!, isOther: false)
                    }else if(res?.data?.owned_invitation != nil && res?.data?.other_invitations == nil){
                        if(self.l != nil){
                            self.l?.disView()
                            self.l = nil
                        }
                        self.ownInvite = res?.data?.owned_invitation!
                        self.otherInvite = nil
                        self.isThereOtherInvite = false
                        self.manageInvitesView(invite: res?.data?.owned_invitation!, res: res?.data!, isOther: false)
                    }else if(res?.data?.owned_invitation == nil && res?.data?.other_invitations != nil){
                        if(self.l != nil){
                            self.l?.disView()
                            self.l = nil
                        }
                        self.ownInvite = nil
                        self.otherInvite = res?.data?.other_invitations!
                        self.isThereOtherInvite = true
                        self.manageInvitesView(invite: res?.data?.other_invitations!, res: res?.data!, isOther: true)
                    }else{
                        self.ownInvite = nil
                        self.otherInvite = nil
                        self.type = .NormalMap
                        self.configureView()
                        self.callGetMyInvitesRest()
                    }
                    
                }else{
                    self.type = .NormalMap
                    self.configureView()
                    self.callGetMyInvitesRest()
                }
            }else if(res?.errCode == -1){
                if(self.l != nil){
                    self.l?.disView()
                    self.l = nil
                }
                GlobalFields.USERNAME = ""
                GlobalFields.TOKEN = ""
                GlobalFields.PASSWORD = nil
                GlobalFields.USERNAME = nil
                GlobalFields.TOKEN = nil
                GlobalFields.ID = nil
                GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                
                var isInStack = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: IntroViewController.self) {
                        isInStack = true
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                if(!isInStack){
                    
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    var homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
                    var nav = UINavigationController(rootViewController: homeViewController)
                    nav.setNavigationBarHidden(true, animated: false)
                    nav.setToolbarHidden(true, animated: false)
                    appdelegate.window!.rootViewController = nav
                }
            }else{
                self.type = .NormalMap
                self.configureView()
                self.callGetMyInvitesRest()
            }
            self.mapView.fitAll()
            
        }
        
    }
    
    func manageInvitesView(invite : MyInvites! , res : ActiveInviteRes! , isOther : Bool!){
        
        self.cancelButton.alpha = 0
        self.cancelButton.isEnabled = false
        if(invite.status == 1){ // submit
//            let interval = Double((invite.available_at)!) - Date().timeIntervalSince1970 + (30 * 60)
            let interval2 = Double((invite.available_at)!) - Date().timeIntervalSince1970 - (5 * 60)
            if(interval2 <= 0){
                callCancelDate(invite: invite.invite_id!)
            }else{
                if(!GlobalFields.defaults.bool(forKey: "cancel:" + (invite.invite_id?.description)!)){
                    GlobalFields.defaults.set(true, forKey: "cancel:" + (invite.invite_id?.description)!)
                    LocalNotifications().sendNotifyToMySelf(data: ["type" : "cancel" , "invite" : (invite.invite_id?.description)!], sendAfterXSec: interval2)
                }
            }
            self.type = .Awaiting
            self.configureView()
            self.callGetMyInvitesRest()
            self.setMarkers()
            
        }else if(invite.status == 2){ //afterLike
            let interval2 = Double((invite.available_at)!) - Date().timeIntervalSince1970 - (5 * 60)
//            let interval = Double((invite.available_at)!) - Date().timeIntervalSince1970 + (30 * 60)
            if(interval2 <= 0){
                callCancelDate(invite: invite.invite_id!)
            }else{
                if(!GlobalFields.defaults.bool(forKey: "cancel:" + (invite.invite_id?.description)!)){
                    GlobalFields.defaults.set(true, forKey: "cancel:" + (invite.invite_id?.description)!)
                    LocalNotifications().sendNotifyToMySelf(data: ["type" : "cancel" , "invite" : (invite.invite_id?.description)!], sendAfterXSec: interval2)
                }
            }
            if((invite.owner?.description)! == GlobalFields.ID.description){
                self.type = .Awaiting
                self.configureView()
                self.callGetMyInvitesRest()
                self.setMarkers()
            }else{
                self.type = .GoDate
                self.configureView()
                self.setMarkers()
            }
            
        }else if(invite.status == 3){
            //show confirmation popup by owner
            let interval = Double((invite.available_at)!) - Date().timeIntervalSince1970 - (5 * 60)
            
            if(interval < 0){
                callCancelDate(invite: invite.invite_id!)
            }else{
                if(!GlobalFields.defaults.bool(forKey: "cancel:" + (invite.invite_id?.description)!)){
                    GlobalFields.defaults.set(true, forKey: "cancel:" + (invite.invite_id?.description)!)
                    LocalNotifications().sendNotifyToMySelf(data: ["type" : "cancel" , "invite" : (invite.invite_id?.description)!], sendAfterXSec: interval)
                }
            }
            
            if(GlobalFields.ID.description != (invite.owner?.description)!){
                self.type = .GoDate
                self.configureView()
                self.setMarkers()
            }else{
                let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
                vC.inviteID = invite.invite_id
                vC.viewType = .ConfirmInvite
                self.configureView()
                self.navigationController?.pushViewController(vC, animated: true)
            }
            
        }else if(invite.status == 4){
            self.cancelButton.alpha = 1
            self.cancelButton.isEnabled = true
            GlobalFields.defaults.set(false, forKey: "isntShowJustYouPopup")
            //set notify for reconfirm
            //nabayd ejazeye invite sakhtan bedam
            //invite ham nemitune bebine
            let interval = Double((invite.available_at)!) - Date().timeIntervalSince1970 - (5 * 60)
            
            if(interval < 0){
                callCancelDate(invite: invite.invite_id!)
            }else{
                if(!GlobalFields.defaults.bool(forKey: "cancel:" + (invite.invite_id?.description)!)){
                    GlobalFields.defaults.set(true, forKey: "cancel:" + (invite.invite_id?.description)!)
                    LocalNotifications().sendNotifyToMySelf(data: ["type" : "cancel" , "invite" : (invite.invite_id?.description)!], sendAfterXSec: interval)
                }
            }
            if(GlobalFields.defaults.bool(forKey: "reconfirm") ){
                self.type = .GoDate
                self.configureView()
                self.setMarkers()
                
            }else{
                print(Date().timeIntervalSince1970)
                print(invite.available_at)
                print(Double((invite.available_at)!) - Date().timeIntervalSince1970)
                let interval = Double((invite.available_at)!) - Date().timeIntervalSince1970 - (40 * 60)
                if(interval <= 0){
                    //alan bayad neshun bedim reConfirmo
                    let vC : WarningReconfirmViewController = (self.storyboard?.instantiateViewController(withIdentifier: "WarningReconfirmViewController"))! as! WarningReconfirmViewController
                    vC.invite = invite
                    
                    self.navigationController?.pushViewController(vC, animated: true)
                    
                }else{
                    if(!GlobalFields.defaults.bool(forKey: "invite:" + (invite.invite_id?.description)!)){
                        GlobalFields.defaults.set(true, forKey: "invite:" + (invite.invite_id?.description)!)
                        LocalNotifications().sendNotifyToMySelf(title: "Reconfirmer", message: "Il faut la reconfirmer votre présence à votre rendez-vous! Il se tient dans moins de 30mn! ", subTitle: "", data: ["type" : "reconfirm" , "invite" : (invite.invite_id?.description)! ], sendAfterXSec: interval)
                    }
                }
                self.type = .GoDate
                self.configureView()
                self.setMarkers()
            }
            
        }else if(invite.status == 5){
            self.cancelButton.alpha = 1
            self.cancelButton.isEnabled = true
//            if(!GlobalFields.defaults.bool(forKey: "isntShowJustYouPopup") && invite.type == 1){
//                GlobalFields.defaults.set(true, forKey: "isntShowJustYouPopup")
//                let vC : JustYouViewController = (self.storyboard?.instantiateViewController(withIdentifier: "JustYouViewController"))! as! JustYouViewController
//                addChildViewController(vC)
//                vC.view.frame = self.view.frame
//                self.view.addSubview(vC.view)
//                vC.didMove(toParentViewController: self)
//            }
//            else if(!GlobalFields.defaults.bool(forKey: "dontShowEquality") && invite.type != 1){
//                let vC : EqualityPaymentViewController = (self.storyboard?.instantiateViewController(withIdentifier: "EqualityPaymentViewController"))! as! EqualityPaymentViewController
//                addChildViewController(vC)
//                vC.view.frame = self.view.frame
//                self.view.addSubview(vC.view)
//                vC.didMove(toParentViewController: self)
//            }
            
            
            GlobalFields.defaults.set(false, forKey: "reconfirm")
            self.type = .GoDate
            self.configureView()
            self.setMarkers()
            //set notify for 12 min after exact time invite
            let interval = Double((invite.available_at)!) - Date().timeIntervalSince1970 + (12 * 60)
//          inja bayad baraye 10min bad az availbel time finish set konam
            let interval2 = Double((invite.available_at)!) - Date().timeIntervalSince1970 + (10 * 60)

            if(interval2 <= 0){
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                request(URLs.finishDate, method: .post , parameters: GetInviteInfoRequestModel.init(invite: (invite.invite_id)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                    
                    let res2 = response.result.value
                    
                    if(res2?.data != nil){
                        self.goPoll(invID: invite.id!)
                    }
                    
                }
                
            }else{
                
                LocalNotifications().sendNotifyToMySelf(data: ["type" : "finish" , "invite" : (invite.invite_id?.description)!], sendAfterXSec: interval2)
            }
            if(interval <= 0){
                //alan bayad neshun bedim reConfirmo
                self.goPoll(invID: invite.id!)
                
            }else{
                
                if(!(GlobalFields.defaults.object(forKey: "pollNotify") != nil && (GlobalFields.defaults.object(forKey: "pollNotify") as! String) == (invite.invite_id?.description)!)){
                    GlobalFields.defaults.setValue((invite.invite_id?.description)!, forKey: "pollNotify")
                    LocalNotifications().sendNotifyToMySelf(title: "Vous avez un sondage", message: "Comment s'est passé votre rendez-vous? Veuillez donner votre avis sur ce dernier pour pouvoir commencer à parler à la personne rencontrée !", subTitle: "", data: ["type" : "poll" , "invite" : (invite.invite_id?.description)!], sendAfterXSec: interval)
                }
                
                
            }
            
            self.updateInviteBadge()
        }else if(invite.status == 6){
            
            GlobalFields.defaults.set(false, forKey: "isntShowJustYouPopup")
            GlobalFields.defaults.set(false, forKey: "reconfirm")
            //show poll popup
            self.goPoll(invID: invite.invite_id)
            self.updateInviteBadge()
        }else if(invite.status == 7){
            
            GlobalFields.defaults.set(false, forKey: "isntShowJustYouPopup")
            GlobalFields.defaults.set(false, forKey: "reconfirm")
            // faqat baraye party karbord dareq
            if(invite.type == 1){
                self.type = .AboutLastNight
                self.configureView()
                self.callGetMyInvitesRest()
            }else{
                self.type = .NormalMap
                self.configureView()
                self.callGetMyInvitesRest()
            }
            self.updateInviteBadge()
        }else{
            GlobalFields.defaults.set(false, forKey: "isntShowJustYouPopup")
            GlobalFields.defaults.set(false, forKey: "reconfirm")
            self.type = .NormalMap
            self.configureView()
            self.callGetMyInvitesRest()
        }
    }
    
    func callCancelDate(invite : Int){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite:invite ).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success"){
                GlobalFields.defaults.set(true, forKey: invite.description)
                self.viewDidAppear(false)
            }
            
        }
    }
    
    func goPoll(invID : Int!){
        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getInviteInfo, method: .post , parameters: GetInviteInfoRequestModel.init(invite: invID).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<InviteInfoRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.data != nil){
                let vC : PollViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PollViewController"))! as! PollViewController
                //TODO inja bayad datahayi k niazaro ferestad
                vC.invite = res?.data
                vC.inviteID = invID
                self.navigationController?.pushViewController(vC, animated: true)
            }else{
                
            }
            
        }
    }
    
    
    
    @IBAction func clickOnOtherInvite(_ sender: Any) {
        let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
        vC.inviteID = self.otherInvite?.invite_id
        vC.viewType = .ShowProfile
        self.configureView()
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    
    
    @IBAction func clickInvitationAwating(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        l = GlobalFields.showLoading(vc: self)
        let inv = self.ownInvite!
        request(URLs.getUsersListForInvite, method: .post , parameters: GetUsersListForInviteRequestModel.init(invite: inv.invite_id!, page: 1, perPage: 100, lat: inv.latitude!, long: inv.longitude!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetUserListForInviteRes]>>) in
            
            let res = response.result.value
            self.l?.disView()
            
            let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
            vC.inviteID = inv.invite_id
            if(res?.data != nil && (res?.data?.count)! > 0){
                vC.usersList = (res?.data)!
                vC.viewType = .AddPersonToInvite
                GlobalFields.inviteTitle = inv.title
                GlobalFields.inviteNumber = inv.people_count
                GlobalFields.inviteExactTime = Date.init(timeIntervalSince1970: TimeInterval(inv.exact_time!))
                GlobalFields.inviteMoodColor = GlobalFields.getTypeColor(type: inv.type!)
                GlobalFields.inviteLocation = CLLocationCoordinate2D.init(latitude: Double(inv.latitude!)!, longitude: Double(inv.longitude!)!)
                switch inv.type! {
                case 1:
                    GlobalFields.inviteMood = "Party"
                    break
                case 2:
                    GlobalFields.inviteMood = "Business"
                    break
                case 3:
                    GlobalFields.inviteMood = "LetsSeeWhatHappens"
                    break
                case 4:
                    GlobalFields.inviteMood = "Friendly"
                    break
                default:
                    GlobalFields.inviteMood = "Party"
                }
                GlobalFields.invite = inv.invite_id
                
                self.navigationController?.pushViewController(vC, animated: true)
            }else{
                //users not found!
                self.view.makeToast("Aucun utilisateur disponible actuellement.")
                self.callCancelDate(invite: inv.invite_id!)
            }
        }
        
    }
    
    
    @IBAction func goInvitation(_ sender: Any) {
        
        
        let vC : ActivityTypeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivityTypeViewController"))! as! ActivityTypeViewController
        
        if(self.locationManager.location != nil){
            GlobalFields.myLocation = self.locationManager.location?.coordinate
        }
        
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    @IBAction func moveCenter(_ sender: Any) {
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    @IBAction func goFire(_ sender: Any) {
        
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
        
    }

    
    
    @objc func callGetMyInvitesRest(){
        self.myInvites.removeAll()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getMyInvites, method: .post , parameters: GetMyInvitesRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[MyInvites]>>) in
            
            let res = response.result.value
            if(self.l != nil){
                self.l?.disView()
                self.l = nil
            }
            if(res?.status == "success" && res?.data != nil && (res?.data?.count)! > 0){
                self.myInvites = (res?.data)!
                self.setMarkers()
            }else{
                // TODO hich inviti nadari
            }
        }
    }
    
    func setMarkers(){
    
        self.mapView.clusterManager.annotations.removeAll()
        
        if(self.type != .GoDate){
            
            for pin in self.myInvites {
                
                let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(pin.latitude!)!, longitude: Double(pin.longitude!)!)
                self.mapView.clusterManager.annotations.append(ClustrableAnnotation.init(coordinate: coordinate, identifier: (pin.invite_id?.description) ?? (pin.id?.description)!))
            }
            
        }
        
        if(self.ownInvite != nil && (self.ownInvite?.status)! > 3){
            let pin = ownInvite
            let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(pin!.latitude!)!, longitude: Double(pin!.longitude!)!)
            self.mapView.clusterManager.annotations.append(ClustrableAnnotation.init(coordinate: coordinate, identifier: (pin!.invite_id?.description) ?? (pin?.id?.description)!))
        }
        
        if(self.otherInvite != nil && self.ownInvite == nil){
            let pin = otherInvite
            let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(pin!.latitude!)!, longitude: Double(pin!.longitude!)!)
            self.mapView.clusterManager.annotations.append(ClustrableAnnotation.init(coordinate: coordinate, identifier: (pin!.invite_id?.description) ?? (pin?.id?.description)!))
        }
        
        self.mapView.fitAll()
        
    }
    
    // MARK: -GoDateMode Methodes
    
    
    @IBAction func goGoogleDirection(_ sender: Any) {
        
        var lat = ""
        
        var long = ""
        
        if(self.ownInvite != nil){
            lat = (ownInvite?.latitude)!
            long = (ownInvite?.longitude)!
        }else{
            lat = (otherInvite?.latitude)!
            long = (otherInvite?.longitude)!
        }
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")! )) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")! )
            
        } else {
            
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees.init(Double(lat)!), CLLocationDegrees.init(Double(long)!))
            let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.02))
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
//            mapItem.name = theLocationName
            mapItem.openInMaps(launchOptions: options)
            NSLog("Can't use comgooglemaps://");
        }
    
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
        if(ownInvite != nil){
            vC.inviteID = self.ownInvite!.invite_id
            vC.type = self.ownInvite!.type!
        }else{
            vC.inviteID = self.otherInvite!.invite_id
            vC.type = self.otherInvite!.type!
        }
        vC.chatTypeMode = .Invites

        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    func updateInviteBadge(){
        var invID : Int?
        if(ownInvite != nil && (ownInvite?.status)! >= 4){
            invID = self.ownInvite!.invite_id
        }else if(otherInvite != nil && (otherInvite?.status)! >= 4){
            invID = self.otherInvite!.invite_id
        }
        if(invID == nil){
            self.showInviteBadge(num: 0)
            return
        }
        self.showInviteBadge(num: 0)
        var badgeNumber = 0
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getInviteMessage, method: .post , parameters: GetInviteInfoRequestModel.init(invite: invID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response2 : DataResponse<ResponseModel<[GetInviteMessageRes]>>) in
            let res2 = response2.result.value
            if(res2?.status == "success"){
                if(res2?.data != nil){
                    for m in (res2?.data)! {
                        if((m.user?.description)! != GlobalFields.ID.description){
                            if(m.seen_at == 0){
                                badgeNumber += 1
                            }
                        }
                    }
                    if(badgeNumber == 0){
                        self.hideInviteBadge()
                    }else{
                        self.showInviteBadge(num: badgeNumber)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func goInvitedUserProfile(_ sender: Any) {
        //TODO bayad check beshe
        let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
        if(ownInvite != nil){
            vC.inviteID = self.ownInvite?.invite_id
        }else{
            vC.inviteID = self.otherInvite?.invite_id
        }
        vC.viewType = .ShowProfile
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    
    @IBAction func goAboutLastNight(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        var inv : MyInvites?
        if(ownInvite != nil){
            inv = ownInvite
        }else if(ownInvite == nil && otherInvite != nil){
            inv = otherInvite
        }
        if(inv == nil){
            return
        }
        
        request(URLs.getConfirmListForInvite, method: .post , parameters: GetConfirmListForInviteRequestModel.init(invite: (inv?.invite_id)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetUserListForInviteRes]>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
                
                vC.inviteID = inv?.invite_id
                vC.viewType = .AfterParty
                
                if(res?.data == nil){
                    self.type = .NormalMap
                    self.callGetMyInvitesRest()
                    self.configureView()
                }else{
                    vC.usersList = (res?.data)!
                    var count = 0
                    for u in (res?.data)! {
                        if(u.id?.description == GlobalFields.ID.description){
                            vC.usersList.remove(at: count)
                        }
                        count += 1
                    }
                    self.navigationController?.pushViewController(vC, animated: true)
                }
                
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
        
    }
    
    
    
    // MARK: -mapView Delegate
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            
            self.updateLocationServer(locCor: center)
            GlobalFields.myLocation = center
            
            for an in self.mapView.annotations{
                if(an is MyAnnotation){
                    if((an as! MyAnnotation).identifier == "myPosition"){
                        self.mapView.removeAnnotation(an)
                    }
                }
            }
            let marker = MyAnnotation()
            marker.coordinate = (self.locationManager.location?.coordinate)!
            marker.identifier = "myPosition"
            mapView.addAnnotation(marker)
            
        }
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print(annotation)
        print(annotation.title)
        print(annotation.coordinate)
        print(annotation.debugDescription)
        var reuseId = ""
        if(annotation is MyAnnotation){
            let annotationIdentifier = (annotation as! MyAnnotation).identifier
            var annotationView: MKAnnotationView?
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier!) {
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            }
            else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            if((annotation as! MyAnnotation).identifier == "myPosition"){
                
                if let annotationView = annotationView {
                    // Configure your annotation view here
                    annotationView.canShowCallout = true
                    annotationView.image = UIImage(named: "MyPositionMarker")
                    annotationView.frame.size = .init(width: 30 , height: 30)
                }
                
                return annotationView
            }
        }
        
        
        
        if let cluster = annotation as? CKCluster, cluster.count > 1 {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            for c in cluster.annotations {
                print(c.coordinate)
            }
            if clusterView == nil {
                var pinImage : String = ""
                var frame : CGRect = CGRect()
                var emoji : String = ""
                frame = .init(x: 0, y: 0, width: 64, height: 93)
                emoji = "💥"
                pinImage = "CL-PINS"
                let flAnnot : FlintAnnotation = FlintAnnotation.init(frame: frame)
                flAnnot.setCharacteristics(pinImage : pinImage , emoji: emoji)
                clusterView = MKAnnotationView.init(frame: frame)
                clusterView?.image = self.imageWithView(view: flAnnot)
            } else {
                clusterView?.annotation = annotation
            }
            return clusterView
            
        } else {
            
            if(annotation is CKCluster){
                guard !(annotation is MKUserLocation) else {
                    return nil
                }
                var identifier : String = ""
                for p in self.myInvites {

                    print(annotation.coordinate)
                    print(p)
                    
                    var minLat = 9
                    
                    if((p.latitude?.count)! < annotation.coordinate.latitude.description.count){
                        minLat = (p.latitude?.count)!
                    }else{
                        minLat = annotation.coordinate.latitude.description.count
                    }
                    
                    var minLong = 9
                    
                    if((p.longitude?.count)! < annotation.coordinate.longitude.description.count){
                        minLong = (p.longitude?.count)!
                    }else{
                        minLong = annotation.coordinate.longitude.description.count
                    }
                    
                    if(annotation != nil && p.latitude?.substring(to: .init(encodedOffset: minLat)) == annotation.coordinate.latitude.description.substring(to: .init(encodedOffset: minLat)) && p.longitude?.substring(to: .init(encodedOffset: minLong)) == annotation.coordinate.longitude.description.substring(to: .init(encodedOffset: minLong))){
                        identifier = (p.invite_id?.description) ?? (p.id?.description)!
                    }
                }
                
                let annotationIdentifier = identifier
                var annotationView: MKAnnotationView?
                if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                    annotationView = dequeuedAnnotationView
                    annotationView?.annotation = annotation
                }
                else {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                    annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                }
                
                if let annotationView = annotationView {
                    var pinImage : String = ""
                    var frame : CGRect = CGRect()
                    var emoji : String = ""
                    for p in self.myInvites {
                        if((p.invite_id?.description) ?? (p.id?.description)! == identifier){
                            //1 => party , 2 => Business , 3 => LetsSee , 4 => Friendly
                            //            2-1 => SuperBus, 2-1 => SuperLets, 2-1 => SuperFriend
                            if(p.type == 1){
                                frame = .init(x: 0, y: 0, width: 64, height: 93)
                                emoji = p.emoji!
                                pinImage = "N-P"
                                continue
                            }else if(p.type == 2 && p.superliked_at ?? p.superliked == 0){
                                frame = .init(x: 0, y: 0, width: 45, height: 62)
                                emoji = p.emoji!
                                pinImage = "N-B"
                                continue
                            }else if(p.type == 2 && p.superliked_at ?? p.superliked != 0){
                                frame = .init(x: 0, y: 0, width: 51, height: 95)
                                emoji = p.emoji!
                                pinImage = "S-B"
                                continue
                            }else if(p.type == 3 && p.superliked_at ?? p.superliked == 0){
                                frame = .init(x: 0, y: 0, width: 45, height: 62)
                                emoji = p.emoji!
                                pinImage = "N-L"
                                continue
                            }else if(p.type == 3 && p.superliked_at ?? p.superliked != 0){
                                frame = .init(x: 0, y: 0, width: 51, height: 95)
                                emoji = p.emoji!
                                pinImage = "S-L"
                                continue
                            }else if(p.type == 4 && p.superliked_at ?? p.superliked == 0){
                                frame = .init(x: 0, y: 0, width: 45, height: 62)
                                emoji = p.emoji!
                                pinImage = "N-F"
                                continue
                            }else if(p.type == 4 && p.superliked_at ?? p.superliked != 0){
                                frame = .init(x: 0, y: 0, width: 51, height: 95)
                                emoji = p.emoji!
                                pinImage = "S-F"
                                continue
                            }
                        }
                    }
                    if(emoji != "" && pinImage != ""){
                        let flAnnot : FlintAnnotation = FlintAnnotation.init(frame: frame)
                        flAnnot.setCharacteristics(pinImage : pinImage , emoji: emoji)
                        annotationView.image = self.imageWithView(view: flAnnot)
                        annotationView.tag = Int(identifier)!
                    }
                }
                return annotationView
                
            }else{
                var annotationView: MKAnnotationView? = MKAnnotationView(annotation: annotation, reuseIdentifier: "?")
                annotationView?.frame.size = .init(width: 0, height: 0)
                return annotationView
            }
            
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print(view.tag)
        
        if let cluster = view.annotation as? CKCluster, cluster.count > 1 {
//            mapView.showCluster(cluster, animated: true)
            var invites : [MyInvites] = [MyInvites]()
            for a in cluster.annotations{
                for p in self.myInvites{
                    if(a.coordinate.latitude.description == p.latitude && a.coordinate.longitude.description == p.longitude && !invites.contains{ $0 == p }){
                        invites.append(p)
                    }
                }
            }
            
            let vC : BigPinViewController = (self.storyboard?.instantiateViewController(withIdentifier: "BigPinViewController"))! as! BigPinViewController
            vC.invites = invites
            self.navigationController?.pushViewController(vC, animated: true)
        } else {
            if(view.tag != 0 ){
                for p in self.myInvites {
                    if(p.invite_id ?? p.id == view.tag){
                        let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
                        vC.inviteID = p.invite_id
                        if(p.type == 1){
                            vC.viewType = .PartyInviteAcception
                        }else{
                            vC.viewType = .NormalInviteAcception
                        }
                        if(self.type == .GoDate){
                            vC.viewType = .ShowProfile
                            
                            GlobalFields.inviteTitle = p.title
                            
                            GlobalFields.inviteNumber = p.people_count ?? 1
                            
                            GlobalFields.inviteAddress = ""
                            
                            GlobalFields.inviteExactTime = Date().addingTimeInterval(Double(p.when!) * 60.0 * 30.0)
                            
                            
                            var u : GetUserListForInviteRes? = .init()
                            u?.avatar1 = p.owner_avatar
                            u?.avatar2 = p.owner_seocond_avatar
                            u?.bio = p.owner_bio
                            u?.birthdate = p.owner_birthdate
                            u?.gender = p.gender
                            u?.job = p.owner_job
                            u?.name = p.owner_name
                            u?.st_x = p.longitude
                            u?.st_y = p.latitude
                            u?.studies = p.owner_studies
                            
                            vC.usersList.removeAll()
                            vC.usersList.append(u!)
                            
                        }
                        GlobalFields.myInvite = p
                        self.navigationController?.pushViewController(vC, animated: true)
                    }
                }
            }
        }
        
        
        
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.clusterManager.updateClustersIfNeeded()
        let coordinate = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        var span = mapView.region.span
        if span.latitudeDelta < 0.0001 { // MIN LEVEL
            span = MKCoordinateSpanMake(0.0001, 0.0001)
        } else if span.latitudeDelta > 0.6 { // MAX LEVEL
            span = MKCoordinateSpanMake(0.6, 0.6)
        }
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated:true)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    //function to convert the given UIView into a UIImage
    func imageWithView(view:UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    
    @IBAction func cancelInvite(_ sender: Any) {
        
        let vC : CancelInviteInMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CancelInviteInMapViewController"))! as! CancelInviteInMapViewController
        
        var inv : MyInvites? = nil
        if(self.otherInvite == nil && self.ownInvite != nil){
            inv = ownInvite
        }else if(self.otherInvite != nil && self.ownInvite == nil){
            inv = otherInvite
        }else if(ownInvite != nil){
            inv = ownInvite
        }
        
        vC.inviteID = (inv?.invite_id)!
        
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    
    
    //final functions
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "map_style", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.add(tileOverlay)
    }
    
    
    @IBAction func goMessage(_ sender: Any) {
        let vC : SparksViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SparksViewController"))! as! SparksViewController
        
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    
    func updateLocationServer(locCor : CLLocationCoordinate2D){
        
        let loc: CLLocation = CLLocation(latitude:locCor.latitude, longitude: locCor.longitude)
        let ceo: CLGeocoder = CLGeocoder()
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    //                    self.setAddressAndLocation()
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if(placemarks == nil){
                    return
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality!
                    }
                    
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    request(URLs.updateUserLocation, method: .post , parameters: UpdateUserLocationRequestModel.init(lat: (locCor.latitude.description), long: (locCor.longitude.description) , city : pm.locality ?? "" , hood : pm.thoroughfare ?? "").getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                        
                        let res = response.result.value
                        
                        
                    }
                    
                }
        })
        
    }
    func updateOneSignal(id : String!){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.updateOneSignal, method: .post , parameters: UpdateOneSignalRequestModel.init(PLAYER_ID: id).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            
        }
    }
    
    
    func showChatBadge(){
        GlobalFields.defaults.set(true, forKey: "showChatBadge")
        self.chatButton.addBadge(number: " " , r : 5)
        for v in self.chatButton.subviews {
            v.isUserInteractionEnabled = true
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.goMessage(_:))))
        }
    }
    
    func showInviteBadge(num : Int){
        if(messageButton.alpha == 0){
            return
        }else{
            if(num == 0){
                let w = self.messageButton.frame.width
                self.messageButton.addBadge(number: "0" , r : 12 , withOffset: .init(x: 3 / 4 * w , y: 0 ))
            }else{
                GlobalFields.defaults.set(true, forKey: "showInviteBadge")
                let w = self.messageButton.frame.width
                self.messageButton.addBadge(number: num.description , r : 12 , withOffset: .init(x: 3 / 4 * w , y: 0 ))
            }
            for v in self.messageButton.subviews {
                v.isUserInteractionEnabled = true
                v.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.sendMessage(_:))))
            }
        }
    }
    
    
    func hideChatBadge(){
        GlobalFields.defaults.set(false, forKey: "showChatBadge")
        self.chatButton.viewWithTag(77)?.removeFromSuperview()
        self.chatButton.removeBadge()
    }
    
    func hideInviteBadge(){
        GlobalFields.defaults.set(false, forKey: "showInviteBadge")
        self.messageButton.removeBadge()
    }
    
    
}

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIButton {
    
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    private var supBadgeView : UIView?  {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? UIView
        } else {
            return nil
        }
    }
    
    func addBadge(number: String , r : Int = 0, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        
        badgeLayer?.removeFromSuperlayer()
        supBadgeView?.removeFromSuperview()
        let supBadge = UIView()
        supBadge.tag = 77
        supBadge.frame = .init(x: 0 , y: 0 , width: self.frame.width, height: self.frame.height)
        supBadge.backgroundColor = UIColor.clear
        
        let badge2 = CAShapeLayer()
        let radius2 = self.frame.width / 2
        let location2 = CGPoint(x: radius2, y: radius2)
        if(number != " "){
            badge2.drawCircleAtLocation(location: location2, withRadius: radius2, andColor: UIColor.clear , filled: true)
            badge2.borderWidth = 1
            badge2.cornerRadius = self.frame.width / 2
            badge2.borderColor = UIColor("#26BD00").cgColor
            badge2.frame = .init(x: 0 , y: 0 , width: self.frame.width, height: self.frame.height)
        }
        
        supBadge.clipsToBounds = false
        supBadge.alpha = 1
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(r)
        let location = CGPoint(x: (offset.x + radius), y: (offset.y  + radius))
        if(number != "0"){
            badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        }
        supBadge.layer.addSublayer(badge2)
        supBadge.layer.addSublayer(badge)

        
        let label = CATextLayer()
        label.string = number
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 14
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y + 2), size: CGSize(width: 8, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        if(number == "0"){
            label.foregroundColor = filled ? UIColor.clear.cgColor : color.cgColor
        }
        badge.addSublayer(label)
        if(number != "0"){
            objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        // Save Badge as UIBarButtonItem property
        self.addSubview(supBadge)
        self.bringSubview(toFront: supBadge)
        objc_setAssociatedObject(self, &handle, supBadge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if(number == "0"){
            removeBadge()
        }
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}


extension CALayer {
    
    func bringToFront() {
        guard let sLayer = superlayer else {
            return
        }
        removeFromSuperlayer()
        print(sLayer.sublayers?.count)
        sLayer.insertSublayer(self, at: UInt32(sLayer.sublayers?.count ?? 0))
    }
    
    func sendToBack() {
        guard let sLayer = superlayer else {
            return
        }
        removeFromSuperlayer()
        sLayer.insertSublayer(self, at: 0)
    }
}


extension MKMapView {
    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRectNull;
        for annotation in annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect       = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.01, 0.01);
            zoomRect            = MKMapRectUnion(zoomRect, pointRect);
        }
        if(annotations != nil && annotations.count > 1){
            setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(100, 100, 100, 100), animated: true)
        }
        
    }
    
    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect:MKMapRect  = MKMapRectNull
        
        for annotation in annotations {
            let aPoint          = MKMapPointForCoordinate(annotation.coordinate)
            let rect            = MKMapRectMake(aPoint.x, aPoint.y, 0.01, 0.01)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
}


