//
//  BirthDateViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class BirthDateViewController: UIViewController {

    
    
    @IBOutlet weak var buttonPresenter: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.maximumDate = Date()
//        setDate("")
        datePicker.backgroundColor = UIColor.white
        datePicker.alpha = 0
        buttonPresenter.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //min 18 max 55
        datePicker.minimumDate = Date.init(timeIntervalSinceNow: -1 * (55 * 31104000))
        datePicker.maximumDate = Date.init(timeIntervalSinceNow: -1 * (18 * 31104000))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        
        if(buttonPresenter.title(for: .normal) == ""){
            self.view.makeToast("s'il vous plaît définir la date de naissance")
            return
        }
        print(Int(self.datePicker.date.timeIntervalSince1970))
        GlobalFields.userInfo.BIRTHDATE = Int(self.datePicker.date.timeIntervalSince1970)
        
        let vC : ManOrWomanViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ManOrWomanViewController"))! as! ManOrWomanViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.datePicker.alpha = 0
    }
    @IBAction func showPicker(_ sender: Any) {
        self.datePicker.alpha = 1
    }
    
    @IBAction func setDate(_ sender: Any) {
        
        var dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale.init(identifier: "fr")
        var strDate = dateFormatter.string(from: datePicker.date)
        self.buttonPresenter.setTitle(strDate, for: .normal)
        
    }
    
    
}
