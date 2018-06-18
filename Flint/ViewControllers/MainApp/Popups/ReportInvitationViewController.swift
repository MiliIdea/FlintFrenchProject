//
//  ReportInvitationViewController.swift
//  Flint
//
//  Created by MehrYasan on 6/13/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import Toast_Swift

class ReportInvitationViewController: UIViewController {

    var target : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setReport(_ sender: Any) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.reportUser, method: .post , parameters: ReportUserRequestModel.init(targetUser: self.target!, reason: 0, txt: (sender as! UIButton).title(for: .normal)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success"){
                self.view.endEditing(true)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
