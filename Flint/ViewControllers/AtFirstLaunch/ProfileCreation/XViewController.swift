//
//  XViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class XViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func men(_ sender: Any) {
        GlobalFields.userInfo.LOOKING_FOR = 0
        callRest()
    }
    
    @IBAction func women(_ sender: Any) {
        GlobalFields.userInfo.LOOKING_FOR = 1
        callRest()
    }
    
    @IBAction func both(_ sender: Any) {
        GlobalFields.userInfo.LOOKING_FOR = 2
        callRest()
    }
    
    func callRest(){
        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        print(GlobalFields.userInfo.getParams())
        request(URLs.editUserInfo, method: .post , parameters: GlobalFields.userInfo.getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.status! == "success"){
                GlobalFields.defaults.set(true, forKey: "isRegisterCompleted")
                GlobalFields.TOKEN = res?.data?.token
                GlobalFields.USERNAME = res?.data?.username
                GlobalFields.ID = res?.data?.id
                GlobalFields.loginResData = res?.data
                let vC : NotificationPermissionViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NotificationPermissionViewController"))! as! NotificationPermissionViewController
                self.navigationController?.pushViewController(vC, animated: true)
            }
            
        }
    }
    

}
