//
//  WarningReconfirmViewController.swift
//  Flint
//
//  Created by MILAD on 4/30/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import UIColor_Hex_Swift
import CoreLocation

class WarningReconfirmViewController: UIViewController ,CLLocationManagerDelegate{

    
    @IBOutlet weak var inviteNumber: UILabel!
    @IBOutlet weak var invitePosition: UILabel!
    @IBOutlet weak var inviteTime: UILabel!
    @IBOutlet weak var inviteTitle: UILabel!
    var locationManager : CLLocationManager = CLLocationManager()
    
    var invite : MyInvites? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configure()
    }

    
    func configure(){
        
        self.inviteTitle.text = invite?.title
        self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.inviteTitle.layer.borderWidth = 1
        self.inviteTitle.layer.borderColor = GlobalFields.getTypeColor(type: (invite?.type)!).cgColor
        self.inviteTitle.layer.backgroundColor = GlobalFields.getTypeColor(type: (invite?.type)!).cgColor
        
        
        inviteNumber.text = ((invite?.people_count?.description) ?? "1") + " personne"
        
        // distance calculation
        let myLoc = locationManager.location?.distance(from: CLLocation.init(latitude: Double((invite!.latitude)!)!, longitude: Double((invite!.longitude)!)!))
        
        var disDesc : String = ""
        if(Double((myLoc?.description) ?? "0")! / 1000 < 1){
            disDesc = "à moins d’1km"
        }else{
            disDesc = "à " + String(Double((myLoc?.description)!)! / 1000).split(separator: ".")[0] + "km"
        }
        
        invitePosition.text = disDesc
        
        let w = Date.init(timeIntervalSince1970: TimeInterval((invite?.exact_time)!))
        
        self.inviteTime.text = w.toStringWithRelativeTime(strings : [.nowPast : "maintenant",.secondsPast: "Maintenant",.minutesPast: "Maintenant"])
    }
    
    
    @IBAction func reconfirm(_ sender: Any) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.reconfirmInvitation, method: .post , parameters: ConfirmUserForInviteRequestModel.init(invite: invite?.invite_id?.description).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.status == "success"){
                
                //inja k reconfirm mishe bayad bere tu map ba dokmeye messaging
                self.navigationController?.popViewController(animated: true)
                GlobalFields.defaults.set(true, forKey: "reconfirm")
                
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
    }
    
    @IBAction func refuse(_ sender: Any) {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        let l = GlobalFields.showLoading(vc: self)
        request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: (invite?.invite_id!)!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.status == "success"){
                
                self.navigationController?.popViewController(animated: true)
                
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
        
    }
    
}
