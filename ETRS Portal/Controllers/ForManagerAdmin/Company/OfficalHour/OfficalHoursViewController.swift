//
//  OfficalHoursViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/18/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class OfficalHoursViewController: UIViewController {
    
    var backButton: MKButton = MKButton()
    
    var activityIndicatorView: NVActivityIndicatorView?
    var blurView: UIVisualEffectView?
    
    var officalHourObjects = [CompanyOfficalHour]()

    @IBOutlet weak var headerLB: UILabel!
    
    @IBOutlet weak var startClock: BEMAnalogClockView!
    @IBOutlet weak var endClock: BEMAnalogClockView!
    @IBOutlet weak var startLB: UILabel!
    @IBOutlet weak var endLB: UILabel!
    
    @IBOutlet weak var setStartHoursBT: MKButton!
    @IBOutlet weak var setEndHoursBT: MKButton!
    
    var setStartActivityIndicatorView: NVActivityIndicatorView?
    var setEndActivityIndicatorView: NVActivityIndicatorView?
    
    override func viewDidAppear(animated: Bool) {
        showIndicatorActivity()
        fetchOfficalHoursFromParse()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.MKColor.BlueGrey
        headerLB.text = checkLanguage("offical_hours")
        configBackButton()
        createTimeClock()
        configLabel()
        configButtons()
    }
    
    func showIndicatorActivity() {
        //Create the visual effect
        //You can choose between ExtraLight, Light and Dark
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Dark)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        blurView.center = self.view.center
        self.view.addSubview(blurView)
        self.blurView = blurView
        
        let vibrancyView: UIVisualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        vibrancyView.frame = blurView.frame
        vibrancyView.center = blurView.center
        blurView.contentView.addSubview(vibrancyView)
        
        let activityTypes: NVActivityIndicatorType = .BallTrianglePath
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
            type: activityTypes)
        activityIndicatorView.center = self.view.center
        vibrancyView.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        self.activityIndicatorView?.hidden = false
        self.activityIndicatorView?.startAnimation()
        self.view.userInteractionEnabled = false
    }
    
    func closeIndicatorActivity() {
        self.blurView?.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    func fetchOfficalHoursFromParse() {
        let query = CompanyOfficalHour.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                self.officalHourObjects = objects as! [CompanyOfficalHour]
                self.provideHourToView()
            }
        })
    }
    
    func provideHourToView() {
        let startArray = officalHourObjects[0].Start!.characters.split {$0 == ":"}.map { String($0) }
        let startHour = startArray[0]
        let startMinute = startArray[1]
        //print(startHour + " " + startMinute)
        let endArray = officalHourObjects[0].End!.characters.split {$0 == ":"}.map { String($0) }
        let endHour = endArray[0]
        let endMinute = endArray[1]
        //print(endHour + " " + endMinute)
        startClock.hours = Int(startHour)!
        startClock.minutes = Int(startMinute)!
        endClock.hours = Int(endHour)!
        endClock.minutes = Int(endMinute)!
        startClock.updateTimeAnimated(true)
        endClock.updateTimeAnimated(true)
        closeIndicatorActivity()
    }

    func configBackButton() {
        // Back Button
        backButton.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Red
        backButton.cornerRadius = 20.0
        backButton.backgroundLayerCornerRadius = 20.0
        backButton.maskEnabled = false
        backButton.rippleLocation = .Center
        backButton.ripplePercent = 1.75
        backButton.layer.shadowOpacity = 0.75
        backButton.layer.shadowRadius = 3.5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        //backButton.setImage(UIImage(named: "Close"), forState: UIControlState.Normal)
        //backButton.setTitle("X", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
    }
    
    func backButtonClick(button:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createTimeClock() {
        
        startClock.delegate = self
        startClock.enableShadows = true
        startClock.realTime = false
        startClock.currentTime = false
        startClock.borderColor = UIColor.whiteColor()
        startClock.borderWidth = 3
        startClock.faceBackgroundColor = UIColor.whiteColor()
        startClock.faceBackgroundAlpha = 0.0
        startClock.digitFont = UIFont(name: "HelveticaNeue-Thin", size: 17)
        startClock.digitColor = UIColor.whiteColor()
        startClock.enableDigit = true
        startClock.secondHandAlpha = 0
        startClock.setTimeViaTouch = true
        startClock.militaryTime = true
        
        endClock.delegate = self
        endClock.enableShadows = true
        endClock.realTime = false
        endClock.currentTime = false
        endClock.borderColor = UIColor.whiteColor()
        endClock.borderWidth = 3
        endClock.faceBackgroundColor = UIColor.whiteColor()
        endClock.faceBackgroundAlpha = 0.0
        endClock.digitFont = UIFont(name: "HelveticaNeue-Thin", size: 17)
        endClock.digitColor = UIColor.whiteColor()
        endClock.enableDigit = true
        endClock.secondHandAlpha = 0
        endClock.setTimeViaTouch = true
        endClock.militaryTime = true
    }
    
    func configLabel() {
        let startHour = startClock.hours
        let startMinute = startClock.minutes
        let endHour = endClock.hours
        let endMinute = endClock.minutes
        
        startLB.text = NSString(format: "%02d:%02d", startHour,startMinute) as String
        endLB.text = NSString(format: "%02d:%02d", endHour,endMinute) as String
    }
    
    func configButtons() {
        setStartHoursBT.setTitle(checkLanguage("set_start_hours"), forState: .Normal)
        setEndHoursBT.setTitle(checkLanguage("set_end_hours"), forState: .Normal)
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
    
    // Create Activity Indicator
    func createActivityIndicator(setButton: MKButton) {
        let activityTypes: NVActivityIndicatorType = .BallTrianglePath
        let frame = setButton.frame
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
            type: activityTypes)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimation()
        
        switch setButton {
        case setStartHoursBT:
            self.setStartActivityIndicatorView = activityIndicatorView
        case setEndHoursBT:
            self.setEndActivityIndicatorView = activityIndicatorView
        default:
            break
        }
    }
    
    func deactiveButton(button: MKButton) {
        UIView.transitionWithView(button, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            // Body closure
            button.enabled = false
            button.hidden = true
        }, completion: nil)
    }
    
    func activeButton(button: MKButton, flag: String) {
        UIView.transitionWithView(button, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            switch flag {
            case "Start":
                self.setStartActivityIndicatorView?.removeFromSuperview()
            case "End":
                self.setEndActivityIndicatorView?.removeFromSuperview()
            default:
                break
            }
            }, completion: { (success) -> Void in
                // Body closure
                button.enabled = true
                button.hidden = false
        })
    }
    
    func saveOfficalHour(flag: String) {
        switch flag {
        case "Start":
            for object in officalHourObjects {
                object.Start = String(self.startClock.hours) + ":" + String(self.startClock.minutes)
                object.saveEventually()
            }
            self.activeButton(setStartHoursBT, flag: "Start")
        case "End":
            for object in officalHourObjects {
                object.End = String(self.endClock.hours) + ":" + String(self.endClock.minutes)
                object.saveEventually()
            }
            self.activeButton(setEndHoursBT, flag: "End")
        default:
            break
        }
    }
    
    //MARK: Event
    @IBAction func setStartBTEvent(sender: AnyObject) {
        deactiveButton(setStartHoursBT)
        createActivityIndicator(setStartHoursBT)
        saveOfficalHour("Start")
    }
    @IBAction func setEndBTEvent(sender: AnyObject) {
        deactiveButton(setEndHoursBT)
        createActivityIndicator(setEndHoursBT)
        saveOfficalHour("End")
    }
}

extension OfficalHoursViewController: BEMAnalogClockDelegate {
    func currentTimeOnClock(clock: BEMAnalogClockView!, hours: String!, minutes: String!, seconds: String!) {
        if clock.tag == 1 {
            let startHours = Int(hours)
            let startMinutes = Int(minutes)
            self.startLB.text = NSString(format: "%02d:%02d", startHours! , startMinutes!) as String
        }
        
        if clock.tag == 2 {
            let endHours = Int(hours)
            let endMinutes = Int(minutes)
            self.endLB.text = NSString(format: "%02d:%02d", endHours! , endMinutes!) as String
        }
    }
    
    func analogClock(clock: BEMAnalogClockView!, graduationLengthForIndex index: Int) -> CGFloat {
        if ((index % 5) == 0) {
            return 15
        } else {
            return 5
        }
    }

}
