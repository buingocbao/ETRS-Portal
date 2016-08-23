//
//  ChangeLanguageViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/19/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: UIViewController {

    var jaBT: MKButton!
    var enBT: MKButton!
    var viBT: MKButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = checkLanguage("language")
        self.contentSizeInPopup = CGSizeMake(500, 300)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.MKColor.Grey
        configButtons()
    }
    
    func configButtons() {
        jaBT = MKButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        jaBT.backgroundColor = UIColor.whiteColor()
        jaBT.setTitle("日本語", forState: UIControlState.Normal)
        jaBT.setTitleColor(UIColor.MKColor.Red, forState: UIControlState.Normal)
        jaBT.addTarget(self, action: "jaButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(jaBT)
        
        viBT = MKButton(frame: CGRect(x: 0, y: self.jaBT.frame.height, width: self.view.frame.width, height: 100))
        viBT.backgroundColor = UIColor.MKColor.Red
        viBT.setTitle(checkLanguage("Tiếng Việt"), forState: UIControlState.Normal)
        viBT.setTitleColor(UIColor.MKColor.Yellow, forState: UIControlState.Normal)
        viBT.addTarget(self, action: "viButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(viBT)
        
        enBT = MKButton(frame: CGRect(x: 0, y: self.jaBT.frame.height + self.viBT.frame.height, width: self.view.frame.width, height: 100))
        enBT.backgroundColor = UIColor.MKColor.Blue
        enBT.setTitle(checkLanguage("English"), forState: UIControlState.Normal)
        enBT.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        enBT.addTarget(self, action: "enButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(enBT)
    }
    
    func jaButtonClick() {
        print("Japanese")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("ja", forKey: "Language")
        showHomePage()
    }
    
    func viButtonClick() {
        print("Vietnamese")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("vi", forKey: "Language")
        showHomePage()
    }
    
    func enButtonClick() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("en", forKey: "Language")
        showHomePage()
    }
    
    func showHomePage() {
        let alert = UIAlertController(title: self.checkLanguage("success"), message: self.checkLanguage("changed_language_success"), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: self.checkLanguage("ok"), style: .Default, handler: { (alert) -> Void in
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
            self.presentViewController(loginVC, animated: true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
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
