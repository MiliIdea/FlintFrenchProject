//
//  ViewController.swift
//  Flint
//
//  Created by MILAD on 4/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Sample request with codable Alomofire
 
     let decoder = JSONDecoder()
     decoder.dateDecodingStrategy = .secondsSince1970
     request(URLs.login, method: .post , parameters: LoginRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
     
     let res = response.result.value
     
     
     }
 
 */
    
 /*
    
     let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
     self.navigationController?.pushViewController(vC, animated: true)
    
    
   */
    
    
    

}

