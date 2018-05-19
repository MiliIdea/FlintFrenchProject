//
//  LoadingViewController.swift
//  Flint
//
//  Created by MILAD on 5/8/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Lottie
import DCKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lottieView: UIView!
    
    @IBOutlet weak var loadingBackView: DCBorderedView!
    
    @IBOutlet var background: UIView!
    
    var animationView :  LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingBackView.frame.origin.y = self.view.frame.height
        background.alpha = 0
        runLoading()
        // Do any additional setup after loading the view.
    }
    
    func runLoading(){
        
        UIView.animate(withDuration: 0.2, delay: 0.2 , options: .curveEaseInOut, animations: {
            self.loadingBackView.frame.origin.y = (self.view.frame.height / 2) - (3 * (self.loadingBackView.frame.height / 5))
            self.background.alpha = 1
        },completion : nil)
        
        self.animationView = LOTAnimationView(name: "loading")
        
        self.animationView?.frame.size = self.lottieView.frame.size
        
        self.animationView?.frame.origin = .init(x: 0, y: 0)
        
        self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.animationView?.alpha = 1
        
        self.lottieView.addSubview(self.animationView!)
        
        self.animationView?.loopAnimation = true
        
        self.animationView?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func disView(){
        UIView.animate(withDuration: 0.2, delay: 0 , options: .curveEaseInOut, animations: {
            self.loadingBackView.frame.origin.y = self.view.frame.height
            self.background.alpha = 0
        }){ completion in 
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
        
    }
    
    func dis(s : Int){
        Timer.scheduledTimer(timeInterval: TimeInterval(s), target: self, selector: #selector(disView), userInfo: nil, repeats: false)
    }
    

}
