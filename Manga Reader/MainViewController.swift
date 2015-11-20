//
//  MainViewController.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-07-07.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("MainViewController viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func open(sender: AnyObject) {
        if let vc = self.frostedViewController{
            vc.presentMenuViewController()
        } else {
            print("No frosted")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navi = storyboard.instantiateViewControllerWithIdentifier("navmain") as! UINavigationController
            // Do any additional setup after loading the view.
            
            let menu = storyboard.instantiateViewControllerWithIdentifier("menu") as! Menu
            
            
            var containerView = REFrostedViewController(contentViewController: navi, menuViewController: menu)
            
            
        }
        
        
    }
}
