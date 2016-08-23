//
//  ManageOrganizationViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/30/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class ManageOrganizationViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    
    let currentUser = User.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerLB.text = checkLanguage("manage_orgranization")
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

extension ManageOrganizationViewController: YALTabBarInteracting {
    func extraRightItemDidPress() {
        print("Add new employee pressed")
        if currentUser?.Group != "Admin" {
            //Show error
            let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_denied_add_employee"), delegate: self, cancelButtonTitle: checkLanguage("ok"))
            alert.show()
        } else {
            self.performSegueWithIdentifier("AddEmployeeSegue", sender: nil)
        }
        
    }
    
    func extraLeftItemDidPress() {
        print("ABC")
    }
}
