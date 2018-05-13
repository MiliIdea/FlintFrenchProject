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

class WarningReconfirmViewController: UIViewController {

    
    @IBOutlet weak var inviteNumber: UILabel!
    @IBOutlet weak var invitePosition: UILabel!
    @IBOutlet weak var inviteTime: UILabel!
    @IBOutlet weak var inviteTitle: UILabel!
    
    var user : GetUserListForInviteRes?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func reconfirm(_ sender: Any) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        request(URLs.confirmInvitation, method: .post , parameters: LikePersonForInviteRequestModel.init(invite: GlobalFields.invite!, targetUser: (user?.id!)!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                
                //inja k reconfirm mishe bayad bere tu map ba dokmeye messaging
                self.navigationController?.popViewController(animated: true)
                
                
            }
            
        }
    }
    
    @IBAction func refuse(_ sender: Any) {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        
        request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: GlobalFields.invite!).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
        
    }
    
}
