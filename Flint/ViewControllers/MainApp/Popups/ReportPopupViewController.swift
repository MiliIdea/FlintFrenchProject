//
//  ReportPopupViewController.swift
//  Flint
//
//  Created by MILAD on 4/29/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit
import Alamofire
import CodableAlamofire
import Toast_Swift

class ReportPopupViewController: UIViewController {

    
    @IBOutlet weak var backView: DCBorderedView!
    @IBOutlet weak var rUSureView: UIView!
    @IBOutlet weak var reportView: UIView!
    
    var tagReport : Int = 0
    var tagMessage : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rUSureView.alpha = 0
        reportView.alpha = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func report(_ sender: Any) {
        rUSureView.alpha = 0
        reportView.alpha = 1
        switch (sender as! UIButton).tag {
        case 1:
            tagReport = 1
            tagMessage = (sender as! UIButton).title(for: .normal)!
        case 2:
            tagReport = 2
            tagMessage = (sender as! UIButton).title(for: .normal)!
        case 3:
            tagReport = 3
            tagMessage = (sender as! UIButton).title(for: .normal)!
        case 4:
            tagReport = 4
            tagMessage = (sender as! UIButton).title(for: .normal)!
        default:
            return
        }
    }
    
    
    @IBAction func deleteMatch(_ sender: Any) {
        rUSureView.alpha = 0
        reportView.alpha = 1
        tagReport = 5
        tagMessage = (sender as! UIButton).title(for: .normal)!
    }
    
    
    @IBAction func yes(_ sender: Any) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.reportUser, method: .post , parameters: ReportUserRequestModel.init(targetUser: (self.parent as! MessagePageViewController).targetId!, reason: 1, txt: tagMessage).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            l.disView()
            let res = response.result.value
            if(res?.status == "success"){
                self.parent!.navigationController?.popViewController(animated: true)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
    }
    
    @IBAction func backToChat(_ sender: Any) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    

}
