//
//  ManageBeaconViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/13/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class ManageBeaconViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLB.text = checkLanguage("manage_beacon")
        self.view.backgroundColor = UIColor.MKColor.LightGreen
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Other methods
    func checkLanguage(key: String) -> String {
        //Get language setting
        let defaults = NSUserDefaults.standardUserDefaults()
        var language = "en"
        if let lg = defaults.stringForKey("Language"){
            language = lg
        }
        let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        let string = bundle?.localizedStringForKey(key, value: nil, table: nil)
        return string!
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


extension ManageBeaconViewController: YALTabBarInteracting {
    func extraRightItemDidPress() {
        print("Add new beacon pressed")
        self.performSegueWithIdentifier("AddNewBeaconSegue", sender: nil)
    }
}
