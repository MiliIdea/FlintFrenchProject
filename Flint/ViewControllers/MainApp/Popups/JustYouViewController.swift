//
//  JustYouViewController.swift
//  Flint
//
//  Created by MILAD on 4/25/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class JustYouViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func understood(_ sender: Any) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

}
