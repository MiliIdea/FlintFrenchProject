//
//  CancelInviteViewController.swift
//  Flint
//
//  Created by MehrYasan on 6/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import Toast_Swift
import DCKit

class CancelInviteViewController: UIViewController {

    var inviteID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yes(_ sender: Any) {
        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: self.inviteID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            l.disView()
            let res = response.result.value
            if(res?.status == "success"){
                GlobalFields.defaults.set(true, forKey: (self.inviteID?.description)!)
                (self.parent as! MainInvitationViewController).ok("")
                self.view.endEditing(true)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
        
    }
    
    @IBAction func no(_ sender: Any) {
        self.view.endEditing(true)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    

}
