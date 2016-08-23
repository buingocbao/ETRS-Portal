//
//  TimeRecordViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/9/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import CryptoSwift

class TimeRecordViewController: UIViewController, BEMAnalogClockDelegate {
    
    var timeClock:BEMAnalogClockView?
    var dateLabel:UILabel?
    var checkButton:MKButton?
    let currentUser = User.currentUser()
    var beacon:Beacon!
    
    var countDownLB: UILabel?
    var countNum:Int = 60
    
    // ProximityContentManagerDelegate
    var proximityContentManager: ProximityContentManager?
    var beaconDetail: EstimoteCloudBeaconDetails?
    
    let beaconManager = ESTBeaconManager()
    var beaconRegion = CLBeaconRegion()
    var lastProximity: CLProximity! = CLProximity.Unknown
    var lastFoundBeacon: CLBeacon! = CLBeacon()
    
    var activityIndicatorView: NVActivityIndicatorView?
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timeClock!.reloadClock()
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackgroundView()
        configCountDown()
        createTimeClock()
        createDateLabel()
        createButtons()
        createActivityIndicator()
        decryptBeaconInfo()
        configProximityManager()
    }
    
    func createBackgroundView(){
        self.view.backgroundColor = UIColor.MKColor.Blue
    }
    
    // Create Count down
    func configCountDown() {
        let countDownLB = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 100))
        countDownLB.text = String(countNum)
        countDownLB.textColor = UIColor.whiteColor()
        countDownLB.layer.masksToBounds = true
        countDownLB.layer.borderWidth = 0.5
        countDownLB.layer.borderColor = UIColor.whiteColor().CGColor
        countDownLB.textAlignment = .Center
        countDownLB.font = UIFont(name: "HelveticaNeue-Light", size: 80)
        self.view.addSubview(countDownLB)
        self.view.bringSubviewToFront(countDownLB)
        self.countDownLB = countDownLB
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCountDownLB"), userInfo: nil, repeats: true)
    }
    
    func updateCountDownLB() {
        if countNum > 0 {
            self.countDownLB?.text = String(countNum--)
        } else if countNum == 0 {
            self.view.userInteractionEnabled = false
            self.activityIndicatorView?.hidden = false
            self.activityIndicatorView?.startAnimation()
            PFUser.logOutInBackground()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func createTimeClock() {
        let timeClock = BEMAnalogClockView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        timeClock.center = self.view.center
        timeClock.enableShadows = true
        timeClock.realTime = true
        timeClock.currentTime = true
        timeClock.borderColor = UIColor.whiteColor()
        timeClock.borderWidth = 3
        timeClock.faceBackgroundColor = UIColor.whiteColor()
        timeClock.faceBackgroundAlpha = 0.0
        timeClock.digitFont = UIFont(name: "HelveticaNeue-Thin", size: 17)
        timeClock.digitColor = UIColor.whiteColor()
        timeClock.enableDigit = true
        self.view.addSubview(timeClock)
        self.timeClock = timeClock
    }
    
    func createDateLabel() {
        let currentDay = NSDate.today().day
        let currentMonth = NSDate.today().month
        let currentYear = NSDate.today().year
        let weekday = NSDate.today().weekday
        var monthByString = ""
        switch currentMonth {
        case 1:
            monthByString = checkLanguage("january")
        case 2:
            monthByString = checkLanguage("february")
        case 3:
            monthByString = checkLanguage("march")
        case 4:
            monthByString = checkLanguage("april")
        case 5:
            monthByString = checkLanguage("may")
        case 6:
            monthByString = checkLanguage("june")
        case 7:
            monthByString = checkLanguage("july")
        case 8:
            monthByString = checkLanguage("august")
        case 9:
            monthByString = checkLanguage("september")
        case 10:
            monthByString = checkLanguage("october")
        case 11:
            monthByString = checkLanguage("november")
        case 12:
            monthByString = checkLanguage("december")
        default:
            return
        }
        var weekdayByString = ""
        switch weekday {
        case 1:
            weekdayByString = checkLanguage("sunday")
        case 2:
            weekdayByString = checkLanguage("monday")
        case 3:
            weekdayByString = checkLanguage("tuesday")
        case 4:
            weekdayByString = checkLanguage("wednesday")
        case 5:
            weekdayByString = checkLanguage("thursday")
        case 6:
            weekdayByString = checkLanguage("friday")
        case 7:
            weekdayByString = checkLanguage("saturday")
        default:
            return
        }
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dateLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 22)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.textAlignment = .Center
        dateLabel.text = "\(weekdayByString), \(monthByString) \(currentDay), \(currentYear)"
        self.view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let botConstraintLBDate = NSLayoutConstraint(item: timeClock!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: dateLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        let xCenterConstraintLBDate = NSLayoutConstraint(item: dateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: timeClock!, attribute: .CenterX, multiplier: 1, constant: 0)
        let widthConstraintLBDate = NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width)
        let heightConstraintLBDate = NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        view.addConstraints([botConstraintLBDate, xCenterConstraintLBDate, widthConstraintLBDate, heightConstraintLBDate])
        self.dateLabel = dateLabel
    }
    
    func createButtons() {
        // Check in Button
        let checkButton = MKButton()
        checkButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/3, height: 50)
        checkButton.center = self.view.center
        checkButton.layer.shadowOpacity = 0.55
        checkButton.layer.shadowRadius = 5.0
        checkButton.layer.shadowColor = UIColor.blackColor().CGColor
        checkButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        checkButton.backgroundColor = UIColor.MKColor.Blue
        checkButton.setTitle(checkLanguage("check"), forState: UIControlState.Normal)
        checkButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        checkButton.addTarget(self, action: "checkButtonTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintBTCheckin = NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.timeClock!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let xCenterConstraintBTCheckin = NSLayoutConstraint(item: checkButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.timeClock!, attribute: .CenterX, multiplier: 1, constant: 0)
        let widthConstraintBTCheckin = NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2)
        let heightConstraintBTCheckin = NSLayoutConstraint(item: checkButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        view.addConstraints([topConstraintBTCheckin, xCenterConstraintBTCheckin, widthConstraintBTCheckin, heightConstraintBTCheckin])
        self.checkButton = checkButton
        self.checkButton?.hidden = true
    }
    
    // Create Activity Indicator
    func createActivityIndicator() {
        let activityTypes: NVActivityIndicatorType = .BallTrianglePath
        let frame = self.checkButton!.frame
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
            type: activityTypes)
        self.view.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        self.activityIndicatorView?.hidden = true
    }
    
    func checkButtonTouch() {
        self.activityIndicatorView?.startAnimation()
        self.activityIndicatorView?.hidden = false
        deactiveButton(self.checkButton!)
        
        print(self.beaconDetail?.beaconName)
        let day = NSDate.today().day
        let month = NSDate.today().month
        let year = NSDate.today().year
        
        //let daymonthyear = "\(day)-\(month)-\(year)"
        
        let queryTR = TimeRecording.query()// PFQuery(className: "TimeRecording")
        queryTR!.whereKey("Employee", equalTo: currentUser!.username!)
        queryTR!.whereKey("Day", equalTo: day)
        queryTR!.whereKey("Month", equalTo: month)
        queryTR!.whereKey("Year", equalTo: year)
        queryTR!.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
            if error == nil {
                //Have record for today
                //TODO: Can check some error here
                //1: Don't have StartTimeRecord but have Date
                //2: Don't have StartTimeRecord but have EndTimeRecord
                //3: Have StartTimeRecord but dont have EndTimeRecord <-- normal status.
                self.checkRecordStatus(object as! TimeRecording)
            } else {
                //Don't have record for today
                self.showAlert("status", message: "have_no_record_message", handler: "have_no_record_handle", isHaveCancel: true)
            }
        })
    }
    
    func checkIn() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Day, .Month, .Year], fromDate: date)
        let hour = String(components.hour)
        let minute = String(components.minute)
        let day = String(NSDate.today().day)
        let month = String(NSDate.today().month)
        let year = String(NSDate.today().year)
        
        let daymonthyear = "\(day)-\(month)-\(year)"
        let hourminute = "\(hour):\(minute)"
        
        let timeRecord = TimeRecording()
        timeRecord.Employee = currentUser!.username!
        //timeRecord.Date = daymonthyear
        timeRecord.StartTimeRecord = hourminute
        timeRecord.Group = currentUser!.Group
        timeRecord.Day = NSDate.today().day
        timeRecord.Month = NSDate.today().month
        timeRecord.Year = NSDate.today().year
        //Set ACL for object Time Record
        let timeRecordACL = PFACL()
        //Read ACL
        timeRecordACL.setPublicReadAccess(false)
        timeRecordACL.setReadAccess(true, forUser: currentUser!)
        timeRecordACL.setReadAccess(true, forRoleWithName: "Admin")
        timeRecordACL.setReadAccess(true, forRoleWithName: "Manager")
        //Write ACL
        timeRecordACL.setPublicWriteAccess(false)
        timeRecordACL.setWriteAccess(true, forUser: currentUser!)
        timeRecordACL.setWriteAccess(true, forRoleWithName: "Admin")
        timeRecordACL.setWriteAccess(false, forRoleWithName: "Manager")
        timeRecord.ACL = timeRecordACL
        let integrityData = "PortalDevice_\(self.beacon.UUID)_\(self.beacon.Major)_\(self.beacon.Minor)_\(self.currentUser!.username)_\(self.currentUser!.Group)_\(daymonthyear)_\(hourminute)_In"
        timeRecord.Integrity = makeIntegrityData(integrityData)
        timeRecord.saveEventually { (succeeded, error) -> Void in
            if succeeded {
                print("Saved check in successfully")
                self.showAlert(self.checkLanguage("success"), message: self.checkLanguage("success_check_in"), handler: "", isHaveCancel: false)
                self.activityIndicatorView?.stopAnimation()
                self.activityIndicatorView?.hidden = true
                self.deactiveButton(self.checkButton!)
            } else {
                print(error)
                let message = self.checkLanguage("error_check_in") + String(error)
                self.showAlert(self.checkLanguage("error"), message: message, handler: "", isHaveCancel: false)
                self.activityIndicatorView?.stopAnimation()
                self.activityIndicatorView?.hidden = true
                self.deactiveButton(self.checkButton!)
            }
        }
    }
    
    func checkOut() {
        let day = NSDate.today().day
        let month = NSDate.today().month
        let year = NSDate.today().year
        
        let query = TimeRecording.query()
        query?.whereKey("Employee", equalTo: currentUser!.username!).whereKey("Day", equalTo: day).whereKey("Month", equalTo: month).whereKey("Year", equalTo: year)
        query?.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
            if error == nil {
                let date = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Hour, .Minute, .Day, .Month, .Year], fromDate: date)
                let hour = String(components.hour)
                let minute = String(components.minute)
                
                let hourminute = "\(hour):\(minute)"
                
                let objectTR = object as! TimeRecording
                objectTR.EndTimeRecord = hourminute
                let integrityData = "PortalDevice_\(self.beacon.UUID)_\(self.beacon.Major)_\(self.beacon.Minor)_\(self.currentUser?.username)_\(self.currentUser?.Group)_\(objectTR.Day)-\(objectTR.Month)-\(objectTR.Year)_\(objectTR.StartTimeRecord)_In_\(hourminute)_Out"
                objectTR.Integrity = self.makeIntegrityData(integrityData)
                objectTR.saveEventually { (succeeded, error) -> Void in
                    if succeeded {
                        print("Saved check out successfully")
                        self.showAlert(self.checkLanguage("success"), message: self.checkLanguage("success_check_out"), handler: "", isHaveCancel: false)
                        self.activityIndicatorView?.stopAnimation()
                        self.activityIndicatorView?.hidden = true
                        self.deactiveButton(self.checkButton!)
                    } else {
                        print(error)
                        let message = self.checkLanguage("error_check_in") + String(error)
                        self.showAlert(self.checkLanguage("error"), message: message, handler: "", isHaveCancel: false)
                        self.activityIndicatorView?.stopAnimation()
                        self.activityIndicatorView?.hidden = true
                        self.deactiveButton(self.checkButton!)
                    }
                }
            }
        })
    }
    
    func makeIntegrityData(data: String) -> String {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let encryptedData = data.aesEncrypt(key, iv: iv)
        //let decryptedData = encryptedData.aesDecrypt(key, iv: iv)
        //print(decryptedData)
        return encryptedData
    }
    
    func checkRecordStatus(objectTR: TimeRecording) {
        //3: Have StartTimeRecord but dont have EndTimeRecord <-- normal status.
        if objectTR.StartTimeRecord != nil && objectTR.EndTimeRecord == nil {
            let message = self.checkLanguage("have_checkin_no_checkout_message1") + objectTR.StartTimeRecord! + self.checkLanguage("have_checkin_no_checkout_message2")
            self.showAlert(self.checkLanguage("status"), message: message, handler: "have_checkin_no_checkout_handle", isHaveCancel: true)
        }
        //4: Have both StartTimeRecord and EndTimeRecord
        if objectTR.StartTimeRecord != nil && objectTR.EndTimeRecord != nil {
            let message = self.checkLanguage("have_checkin_and_checkout_message1") + objectTR.StartTimeRecord! + self.checkLanguage("have_checkin_and_checkout_message2") + objectTR.EndTimeRecord! + self.checkLanguage("have_checkin_and_checkout_message3")
            self.showAlert(self.checkLanguage("status"), message: message, handler: "", isHaveCancel: false)
        }
    }
    
    func showAlert(title: String, message: String, handler: String, isHaveCancel: Bool) {
        let alert = UIAlertController (title: checkLanguage(title), message: checkLanguage(message), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: checkLanguage("ok"), style: .Default, handler: { (alert) -> Void in
            switch handler {
            case "have_no_record_handle":
                self.checkIn()
            case "have_checkin_no_checkout_handle":
                self.checkOut()
            default:
                self.activityIndicatorView?.stopAnimation()
                self.activityIndicatorView?.hidden = true
                self.deactiveButton(self.checkButton!)
                return
            }
        }))
        if isHaveCancel {
            alert.addAction(UIAlertAction(title: checkLanguage("cancel"), style: .Default, handler: { (alert) -> Void in
                self.activityIndicatorView?.stopAnimation()
                self.activityIndicatorView?.hidden = true
                self.deactiveButton(self.checkButton!)
            }))
        }
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func decryptBeaconInfo() {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let beaconInfo = currentUser?.Beacon.aesDecrypt(key, iv: iv)
        print(beaconInfo)
        var componentArray = beaconInfo!.characters.split {$0 == "_"}.map { String($0) }
        let beacon = Beacon()
        beacon.UUID = componentArray[0]
        beacon.Major = componentArray[1]
        beacon.Minor = componentArray[2]
        self.beacon = beacon
        print(self.beacon)
    }
    
    func deactiveButton(button: MKButton) {
        UIView.transitionWithView(button, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            // Body closure
            button.enabled = false
            button.hidden = true
            }, completion: nil)
    }
    
    func activeButton(button: MKButton) {
        UIView.transitionWithView(button, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            //
            button.enabled = true
            button.hidden = false
            }, completion: nil)
    }
}

//Estimote Beacon functions
extension TimeRecordViewController: ProximityContentManagerDelegate, ESTBeaconManagerDelegate {
    func configProximityManager() {
        print(self.beacon.UUID)
        print(Int(self.beacon.Minor))
        print(Int(self.beacon.Major))
        let beaconUUID = self.beacon!.UUID
        let beaconMajor = CLBeaconMajorValue(Int(self.beacon.Major)!)
        let beaconMinor = CLBeaconMajorValue(Int(self.beacon.Minor)!)
        self.proximityContentManager = ProximityContentManager(
            beaconIDs: [
                BeaconID(UUIDString: beaconUUID, major: beaconMajor, minor: beaconMinor)
            ],
            beaconContentFactory: EstimoteCloudBeaconDetailsFactory())
        self.proximityContentManager!.delegate = self
        self.proximityContentManager!.startContentUpdates()
        
        self.beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: beaconUUID)!, major: beaconMajor, minor: beaconMinor, identifier: "Ranging ETRS Beacon")
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
    }
    
    func proximityContentManager(proximityContentManager: ProximityContentManager, didUpdateContent content: AnyObject?) {
        if let beaconDetails = content as? EstimoteCloudBeaconDetails {
            print("You're in \(beaconDetails.beaconName)'s range!")
            self.beaconDetail = beaconDetails
            self.activeButton(self.checkButton!)
        } else {
            print("No beacons in range.")
            self.deactiveButton(self.checkButton!)
            //self.isCheckShouldHidden = true
        }
    }
    
    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if let closestBeacon = beacons.first as? CLBeacon {
            if closestBeacon != lastFoundBeacon || lastProximity != closestBeacon.proximity  {
                lastFoundBeacon = closestBeacon
                lastProximity = closestBeacon.proximity
                
                switch lastFoundBeacon.proximity {
                case CLProximity.Immediate:
                    print("Immediate")
                    //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.activeButton(self.checkButton!)
                    
                case CLProximity.Near:
                    print("Near")
                    //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.activeButton(self.checkButton!)
                    
                case CLProximity.Far:
                    print("Far")
                    //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.activeButton(self.checkButton!)
                    
                default:
                    print("Can't find any Beacon")
                    //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                    self.deactiveButton(self.checkButton!)
                }
            }
        }
    }
    
}