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

class FirstMapViewController: UIViewController ,MKMapViewDelegate{

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var invitationButton: DCBorderedButton!
    
    @IBOutlet weak var lighterButton: DCBorderedButton!
    
    @IBOutlet weak var invitationAwating: DCBorderedButton!
    
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
    
    var l : LoadingViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 400
        self.mapView.clusterManager.algorithm = algorithm
        self.mapView.clusterManager.marginFactor = 1
        self.mapView.clusterManager.maxZoomLevel = 16

        
        // Fallback on earlier versions
        locationManager.requestAlwaysAuthorization()
        
        configureTileOverlay()
        
//        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        configureView()
        callGetActiveInvites()
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            
            let marker = MyAnnotation()
            marker.coordinate = (self.locationManager.location?.coordinate)!
            marker.identifier = "myPosition"
            mapView.addAnnotation(marker)
            
            
        }else{
            //TODO error bayad bede k locationeto roshan kon nadaram
        }
        
    }

    
    func configureView(){
        
        if(type == .Awaiting){
            
            self.invitationAwating.alpha = 1
            self.invitationAwating.backgroundColor = GlobalFields.getTypeColor(type: self.myInvites[0].type!)
            self.invitationButton.alpha = 0
            self.lighterButton.alpha = 0
            self.messageButton.alpha = 0
            self.ownerImageButton.alpha = 0
            self.aboutLastNightView.alpha = 0
            self.mapView.frame.origin.y = 96 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            
        }else if(type == .GoDate){
            
            self.messageButton.alpha = 1
            self.ownerImageButton.alpha = 1
            self.invitationAwating.alpha = 0
            self.invitationButton.alpha = 0
            self.lighterButton.alpha = 0
            self.aboutLastNightView.alpha = 0
            self.mapView.frame.origin.y = 202 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            self.ownerImageButton.kf.setImage(with: URL.init(string:
                URLs.imgServer + self.myInvites[0].owner_avatar!), for: .normal)
            self.setTopView()
            
        }else if(type == .NormalMap){
            
            self.invitationAwating.alpha = 0
            self.invitationButton.alpha = 1
            self.lighterButton.alpha = 1
            self.messageButton.alpha = 0
            self.ownerImageButton.alpha = 0
            self.aboutLastNightView.alpha = 0
            self.mapView.frame.origin.y = 96 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            
        }else if(type == .AboutLastNight){
            
            self.invitationAwating.alpha = 0
            self.invitationButton.alpha = 0
            self.lighterButton.alpha = 0
            self.messageButton.alpha = 0
            self.ownerImageButton.alpha = 0
            self.aboutLastNightView.alpha = 1
            self.mapView.frame.origin.y = 96 * self.view.frame.height / 667
            self.mapView.frame.size.height = self.view.frame.height - self.mapView.frame.origin.y
            
        }
        
    }
    
    func setTopView(){
        
        let inv = self.myInvites[0]
        
        self.inviteTitle.text = inv.title
        self.inviteTitle.layer.borderWidth = 1
        let col : UIColor = GlobalFields.getTypeColor(type: inv.type!)
        self.inviteTitle.layer.borderColor = col.cgColor
        self.inviteTitle.backgroundColor = col
        self.inviteTitle.textColor = UIColor.white
        GlobalFields.inviteMoodColor = col
        self.ownerImageButton.normalBorderColor = col
        
        inviteNumber.text = (inv.people_count?.description)! + " person"
        
        invitePosition.text = ""
        
        let w = inv.when
        if(w == 0){
            self.inviteTime.text = "Right now"
        }else{
            let date : Date = Date().addingTimeInterval(Double(w!) * 60.0 * 30.0)
            let dateFormatterGet : DateFormatter = DateFormatter()
            dateFormatterGet.dateFormat = "HH:mm"
            self.inviteTime.text = dateFormatterGet.string(from: date)
        }
        
    }
    
    
    func callGetActiveInvites(){
        
        l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getActiveInvite, method: .post , parameters: OpenLighterRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<MyInvites>>) in
            
            let res = response.result.value
            /*
             Invitation Status :
             0 failed
             1 submit ( ready for like by owner ) // inja invite sakhte shode bayad like kone
             2 after like ( ready for accept by users ) // inja like karde montazere accept kardane usere
             3 after accept ( ready for confirm by owner ) // inja owner bayad confirm kone
             4 after confirm ( ready for reconfirm by owner and users )
             5 after reconfirm ( Done )
             6 after date ( ready for poll )
             7 after poll
             */
            self.l?.disView()
            if(res?.status == "success"){
                if(res?.data != nil){
                    if(res?.data?.status == 1 || res?.data?.status == 2){ // submit - afterLike
                        self.myInvites.removeAll()
                        self.myInvites.append((res?.data!)!)
                        self.type = .Awaiting
                        self.configureView()
//                        self.setMarkers()
                    }else if(res?.data?.status == 3){
                        //show confirmation popup by owner
                        let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
                        vC.viewType = .ConfirmInvite
                        self.configureView()
                        self.navigationController?.pushViewController(vC, animated: true)
                        
                    }else if(res?.data?.status == 4){
                        //set notify for reconfirm
                        //nabayd ejazeye invite sakhtan bedam
                        //invite ham nemitune bebine
                        let interval = Double((res?.data?.exact_time)!) - Date().timeIntervalSince1970 - (30 * 60)
                        if(interval < 0){
                            //alan bayad neshun bedim reConfirmo
                            let vC : WarningReconfirmViewController = (self.storyboard?.instantiateViewController(withIdentifier: "WarningReconfirmViewController"))! as! WarningReconfirmViewController
                            //TODO inja bayad datahayi k niazaro ferestad
//                            vC.user ??
                            
                            self.navigationController?.pushViewController(vC, animated: true)
                            
                        }else{
                            
                            LocalNotifications().pushLocalNotification(info: ["Type" : "reConfirm" ,"invite" : res?.data], title: "ReConfirm", subtitle: (res?.data?.title)!, body: "", timeInterval: interval, identifier: "reConfirm")
                            
                        }
                        self.type = .GoDate
                        self.myInvites.removeAll()
                        self.myInvites.append((res?.data)!)
                        self.configureView()
                        self.setMarkers()
                        
                    }else if(res?.data?.status == 5){
                        self.type = .GoDate
                        self.myInvites.removeAll()
                        self.myInvites.append((res?.data)!)
                        self.configureView()
                        self.setMarkers()
                        //set notify for 30 min after exact time invite
                        let interval = Double((res?.data?.exact_time)!) - Date().timeIntervalSince1970 + (30 * 60)
                        LocalNotifications().pushLocalNotification(info: ["Type" : "poll" ,"invite" : res?.data], title: "Poll", subtitle: (res?.data?.title)!, body: "", timeInterval: interval, identifier: "poll")
                        
                    }else if(res?.data?.status == 6){
                        //show poll popup
                        let vC : PollViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PollViewController"))! as! PollViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                        
                    }else if(res?.data?.status == 7){
                        // faqat baraye party karbord dareq
                        if(res?.data?.type == 1){
                            self.myInvites.removeAll()
                            self.myInvites.append((res?.data)!)
                            self.type = .AboutLastNight
                            self.configureView()
                        }
                    }else{
                        self.type = .NormalMap
                        self.configureView()
                        self.callGetMyInvitesRest()
                    }
                }else{
                    self.type = .NormalMap
                    self.configureView()
                    self.callGetMyInvitesRest()
                }
            }
            
        }
        
    }
    
    
    @IBAction func clickInvitationAwating(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        l = GlobalFields.showLoading(vc: self)
        request(URLs.getUsersListForInvite, method: .post , parameters: GetUsersListForInviteRequestModel.init(invite: self.myInvites[0].invite_id!, page: 1, perPage: 100, lat: self.myInvites[0].latitude!, long: self.myInvites[0].longitude!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetUserListForInviteRes]>>) in
            
            let res = response.result.value
            self.l?.disView()
            
            let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
            if(res?.data != nil && (res?.data?.count)! > 0){
                vC.usersList = (res?.data)!
                vC.viewType = .AddPersonToInvite
                GlobalFields.inviteTitle = self.myInvites[0].title
                GlobalFields.inviteNumber = self.myInvites[0].people_count
                GlobalFields.inviteExactTime = Date.init(timeIntervalSince1970: TimeInterval(self.myInvites[0].exact_time!))
                GlobalFields.inviteMoodColor = GlobalFields.getTypeColor(type: self.myInvites[0].type!)
                GlobalFields.inviteLocation = CLLocationCoordinate2D.init(latitude: Double(self.myInvites[0].latitude!)!, longitude: Double(self.myInvites[0].longitude!)!)
                
                GlobalFields.invite = self.myInvites[0].invite_id
                
                self.navigationController?.pushViewController(vC, animated: true)
            }else{
                
            }
        }
        
    }
    
    
    @IBAction func goInvitation(_ sender: Any) {
        let vC : ActivityTypeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivityTypeViewController"))! as! ActivityTypeViewController
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    @IBAction func goFire(_ sender: Any) {
        
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
        
    }

    
    
    func callGetMyInvitesRest(){
        self.myInvites.removeAll()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getMyInvites, method: .post , parameters: GetMyInvitesRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[MyInvites]>>) in
            
            let res = response.result.value
           
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
        
        for pin in self.myInvites {
            
            let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(pin.latitude!)!, longitude: Double(pin.longitude!)!)
            self.mapView.clusterManager.annotations.append(ClustrableAnnotation.init(coordinate: coordinate, identifier: (pin.invite_id?.description) ?? (pin.id?.description)!))
        }
        
    }
    
    // MARK: -GoDateMode Methodes
    
    
    @IBAction func goGoogleDirection(_ sender: Any) {
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        let vC : MessagePageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MessagePageViewController"))! as! MessagePageViewController
        vC.isOneTextMode = true
        vC.isSendedOneMessage = true
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    @IBAction func goInvitedUserProfile(_ sender: Any) {
        //TODO bayad check beshe
        
        
    }
    
    
    @IBAction func goAboutLastNight(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getConfirmListForInvite, method: .post , parameters: GetConfirmListForInviteRequestModel.init(invite: self.myInvites[0].invite_id!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetUserListForInviteRes]>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
                if(res?.data == nil){
                    self.type = .NormalMap
                    self.callGetMyInvitesRest()
                    self.configureView()
                }else{
                    vC.usersList = (res?.data)!
                    self.navigationController?.pushViewController(vC, animated: true)
                }
                
            }
            
        }
        
    }
    
    
    
    // MARK: -mapView Delegate
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
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
                    if(p.latitude == annotation.coordinate.latitude.description && p.longitude == annotation.coordinate.longitude.description){
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
                            }else if(p.type == 2 && p.superliked_at ?? p.superliked == 1){
                                frame = .init(x: 0, y: 0, width: 51, height: 95)
                                emoji = p.emoji!
                                pinImage = "S-B"
                                continue
                            }else if(p.type == 3 && p.superliked_at ?? p.superliked == 0){
                                frame = .init(x: 0, y: 0, width: 45, height: 62)
                                emoji = p.emoji!
                                pinImage = "N-L"
                                continue
                            }else if(p.type == 3 && p.superliked_at ?? p.superliked == 1){
                                frame = .init(x: 0, y: 0, width: 51, height: 95)
                                emoji = p.emoji!
                                pinImage = "S-L"
                                continue
                            }else if(p.type == 4 && p.superliked_at ?? p.superliked == 0){
                                frame = .init(x: 0, y: 0, width: 45, height: 62)
                                emoji = p.emoji!
                                pinImage = "N-F"
                                continue
                            }else if(p.type == 4 && p.superliked_at ?? p.superliked == 1){
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
                return nil
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
                            u?.st_x = p.latitude
                            u?.st_y = p.longitude
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
    
    
}


