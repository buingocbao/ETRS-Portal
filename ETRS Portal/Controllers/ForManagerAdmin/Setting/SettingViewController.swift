//
//  SettingViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/19/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    
    @IBOutlet weak var changeLanguageBT: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.MKColor.Cyan
        headerLB.text = checkLanguage("setting")
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
    
    func showPopupWithTransitionStyle(transitionStyle: STPopupTransitionStyle, rootViewController: UIViewController) {
        let popupController = STPopupController(rootViewController: rootViewController)
        popupController.cornerRadius = 4
        popupController.transitionStyle = transitionStyle
        popupController.presentInViewController(self)
    }
    
    //MAKR: Event
    @IBAction func changeLanguageBTEvent(sender: AnyObject) {
        self.showPopupWithTransitionStyle(STPopupTransitionStyle.SlideVertical, rootViewController: ChangeLanguageViewController(nibName: nil, bundle: nil))
    }
    

}
