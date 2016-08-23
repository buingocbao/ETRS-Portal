//
//  ManageCenterViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/18/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class ManageCenterViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    
    @IBOutlet weak var officalHourBT: MKButton!
    @IBOutlet weak var kpiBT: MKButton!
    @IBOutlet weak var exportBT: MKButton!
    @IBOutlet weak var otherButton3: MKButton!
    @IBOutlet weak var otherButton4: MKButton!
    @IBOutlet weak var otherButton5: MKButton!
    
    let transition = BubbleTransition()
    var touchButton: String = ""
    let currentUser = User.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.MKColor.Teal
        
        headerLB.text = checkLanguage("manage_company")
        
        configButtons()
    }

    func configButtons() {
        officalHourBT.cornerRadius = 50.0
        officalHourBT.rippleLocation = .Center
        officalHourBT.layer.shadowOpacity = 0.75
        officalHourBT.layer.shadowRadius = 3.5
        officalHourBT.layer.shadowColor = UIColor.blackColor().CGColor
        officalHourBT.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        kpiBT.cornerRadius = 50.0
        kpiBT.rippleLocation = .Center
        kpiBT.layer.shadowOpacity = 0.75
        kpiBT.layer.shadowRadius = 3.5
        kpiBT.layer.shadowColor = UIColor.blackColor().CGColor
        kpiBT.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        otherButton5.cornerRadius = 50.0
        otherButton5.rippleLocation = .Center
        otherButton5.layer.shadowOpacity = 0.75
        otherButton5.layer.shadowRadius = 3.5
        otherButton5.layer.shadowColor = UIColor.blackColor().CGColor
        otherButton5.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        exportBT.cornerRadius = 50.0
        exportBT.rippleLocation = .Center
        exportBT.layer.shadowOpacity = 0.75
        exportBT.layer.shadowRadius = 3.5
        exportBT.layer.shadowColor = UIColor.blackColor().CGColor
        exportBT.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        otherButton3.cornerRadius = 50.0
        otherButton3.rippleLocation = .Center
        otherButton3.layer.shadowOpacity = 0.75
        otherButton3.layer.shadowRadius = 3.5
        otherButton3.layer.shadowColor = UIColor.blackColor().CGColor
        otherButton3.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        otherButton4.cornerRadius = 50.0
        otherButton4.rippleLocation = .Center
        otherButton4.layer.shadowOpacity = 0.75
        otherButton4.layer.shadowRadius = 3.5
        otherButton4.layer.shadowColor = UIColor.blackColor().CGColor
        otherButton4.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    //MARK: Event
    @IBAction func officalHoursBTEvent(sender: AnyObject) {
        if currentUser?.Group != "Admin" {
            //Show error
            let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_denied_add_employee"), delegate: self, cancelButtonTitle: checkLanguage("ok"))
            alert.show()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.touchButton = "OfficalHours"
        }
    }
    @IBAction func kpiBTEvent(sender: AnyObject) {
        self.touchButton = "KPI"
    }
    @IBAction func exportBTEvent(sender: AnyObject) {
        self.touchButton = "Export"
    }
    
}

extension ManageCenterViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        switch touchButton {
        case "OfficalHours":
            transition.startingPoint = officalHourBT.center
            transition.bubbleColor = UIColor.MKColor.BlueGrey
        case "KPI":
            transition.startingPoint = kpiBT.center
            transition.bubbleColor = UIColor.MKColor.BlueGrey
        case "Export":
            transition.startingPoint = exportBT.center
            transition.bubbleColor = UIColor.MKColor.BlueGrey
        default:
            break
        }
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        switch touchButton {
        case "OfficalHours":
            transition.startingPoint = officalHourBT.center
            transition.bubbleColor = UIColor.MKColor.BlueGrey
        case "KPI":
            transition.startingPoint = kpiBT.center
            transition.bubbleColor = UIColor.MKColor.BlueGrey
        case "Export":
            transition.startingPoint = exportBT.center
            transition.bubbleColor = UIColor.MKColor.BlueGrey
        default:
            break
        }
        return transition
    }
}
