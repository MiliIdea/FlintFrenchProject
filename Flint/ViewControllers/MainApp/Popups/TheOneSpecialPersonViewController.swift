//
//  TheOneSpecialPersonViewController.swift
//  Flint
//
//  Created by MILAD on 4/25/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class TheOneSpecialPersonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func send(_ sender: Any) {
        //TODO bayad dataye superlike send beshe va bere tu map
        (self.parent as! MainInvitationViewController).superLike("")
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func back(_ sender: Any) {
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
