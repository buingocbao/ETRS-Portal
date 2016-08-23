//
//  AddBeaconViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/16/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class AddBeaconViewController: UIViewController {
    
    @IBOutlet weak var headerLB: UILabel!
    @IBOutlet weak var newBeaconCollectionView: UICollectionView!
    
    var backButton: MKButton = MKButton()
    
    var beaconManager: ESTBeaconManager!
    var region: CLBeaconRegion!
    var beaconArray: NSArray = NSArray()
    var beacon = CLBeacon()
    
    @IBOutlet weak var beaconInfoContainer: UIView!
    @IBOutlet weak var beaconColorBT: MKButton!
    @IBOutlet weak var beaconUUID: UILabel!
    @IBOutlet weak var beaconMajorMinor: UILabel!
    @IBOutlet weak var beaconContextBT: MKButton!
    @IBOutlet weak var beaconStatusBT: MKButton!
    @IBOutlet weak var beaconDescriptionLB: UILabel!
    @IBOutlet weak var beaconDescriptionTextView: UITextView!
    @IBOutlet weak var beaconSaveBT: MKButton!
    
    var alwaysActivityIndicatorView: NVActivityIndicatorView?
    var activityIndicatorView: NVActivityIndicatorView?
    var blurView: UIVisualEffectView?
    
    var kbHeight: CGFloat!
    
    var beaconStatus:Bool = false
    var beaconContext:String = "No"
    var beaconColor:String = "No"
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "EstimoteBeacons")
        self.beaconManager = ESTBeaconManager()
        self.beaconManager.delegate = self
        self.startRanginBeacons()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.region)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newBeaconCollectionView.dataSource = self
        newBeaconCollectionView.delegate = self
        
        headerLB.text = checkLanguage("add_beacon")
        beaconSaveBT.setTitle(checkLanguage("add"), forState: .Normal)
        beaconDescriptionLB.text = checkLanguage("beacon_descriptionLB")
        
        configBackButton()
        configView()
        configActivityIndicator()
        configContainer()
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
    
    func configView() {
        beaconContextBT.maskEnabled = true
        beaconContextBT.layer.borderWidth = 1
        beaconContextBT.layer.borderColor = UIColor.MKColor.Blue.CGColor
        beaconContextBT.backgroundColor = .clearColor()
        
        beaconStatusBT.maskEnabled = true
        beaconStatusBT.layer.borderWidth = 1
        beaconStatusBT.layer.borderColor = UIColor.MKColor.Blue.CGColor
        beaconStatusBT.backgroundColor = .clearColor()
        
        beaconSaveBT.maskEnabled = true
        beaconSaveBT.layer.cornerRadius = 5
    }
    
    func configActivityIndicator() {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:self.view.frame.width-10-30, y: 10, width: 30, height: 30), type: NVActivityIndicatorType.BallTrianglePath, color: UIColor.whiteColor(), size: CGSize(width: 30, height: 30))
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.alwaysActivityIndicatorView = activityIndicatorView
        self.alwaysActivityIndicatorView!.startAnimation()
    }
    
    func configContainer() {
        self.beaconInfoContainer.alpha = 0
        self.beaconInfoContainer.userInteractionEnabled = false
    }
    
    func startRanginBeacons() {
        if ESTBeaconManager.authorizationStatus() == .NotDetermined {
            self.beaconManager.requestAlwaysAuthorization()
        } else if ESTBeaconManager.authorizationStatus() == .Denied {
            //Show error
            let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_denied_beacon"), delegate: self, cancelButtonTitle: checkLanguage("ok"))
            alert.show()
        } else if ESTBeaconManager.authorizationStatus() == .Restricted {
            //Show error
            let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_restricted_beacon"), delegate: self, cancelButtonTitle: checkLanguage("ok"))
            alert.show()
        }
    }
    
    // MARK : Other methods
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height-20
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    //MARK: Event
    @IBAction func contextBTEvent(sender: AnyObject) {
        self.assignContextBTTouch()
    }
    
    func assignContextBTTouch() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ContextTableVC") as! PickContextTableViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(200, 150)
        popover!.permittedArrowDirections = UIPopoverArrowDirection.Up
        popover!.delegate = self
        popover!.sourceView = beaconContextBT
        popover!.sourceRect = CGRectMake(beaconContextBT.frame.width/2,beaconContextBT.frame.height,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    @IBAction func statusBTEvent(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.beaconStatusBT.alpha = 0
            self.beaconStatusBT.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    if self.beaconStatus == false {
                        let title = self.checkLanguage("status") + ": " + "ACTIVE"
                        self.beaconStatusBT.setTitle(title, forState: .Normal)
                        self.beaconStatus = true
                    } else {
                        let title = self.checkLanguage("status") + ": " + "INACTIVE"
                        self.beaconStatusBT.setTitle(title, forState: .Normal)
                        self.beaconStatus = false
                    }
                    self.beaconStatusBT.alpha = 1
                    self.beaconStatusBT.enabled = true
                })
        })
    }
    
    @IBAction func saveBTEvent(sender: AnyObject) {
        print("Saving Beacon")
        self.showIndicatorActivity()
        if self.beaconContext == "No" {
            self.closeIndicatorActivity()
            //Show error
            let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_context_beacon"), delegate: self, cancelButtonTitle: checkLanguage("ok"))
            alert.show()
        } else if self.beaconColor == "No" {
            self.closeIndicatorActivity()
            //Show error
            let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_color_beacon"), delegate: self, cancelButtonTitle: checkLanguage("ok"))
            alert.show()
        } else {
            findBeacon()
        }
    }
    
    func findBeacon() {
        let query = Beacon.query()
        query?.whereKey("UUID", equalTo: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        query?.whereKey("Major", equalTo: String(self.beacon.major))
        query?.whereKey("Minor", equalTo: String(self.beacon.minor))
        query?.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
            if error == nil {
                //Exist beacon
                print(object)
                self.closeIndicatorActivity()
                //Show error
                let alert = UIAlertView(title: self.checkLanguage("error"), message: self.checkLanguage("error_exist_beacon") + "\(object!)", delegate: self, cancelButtonTitle: self.checkLanguage("ok"))
                alert.show()
                
            } else {
                //No beacon found
                print(error)
                self.addNewBeacon()
            }
        })
    }
    
    func addNewBeacon() {
        let beaconObject = Beacon()
        beaconObject.UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        beaconObject.Major = String(beacon.major)
        beaconObject.Minor = String(beacon.minor)
        beaconObject.Color = self.beaconColor
        beaconObject.Context = self.beaconContext
        beaconObject.Status = self.beaconStatus
        beaconObject.Description = self.beaconDescriptionTextView.text
        beaconObject.saveInBackgroundWithBlock { (succeed, error) -> Void in
            if succeed {
                print("Successfully save beacon")
                //Show succeed
                let alert = UIAlertView(title: self.checkLanguage("success"), message: self.checkLanguage("success_add_beacon"), delegate: self, cancelButtonTitle: self.checkLanguage("ok"))
                alert.show()
            } else {
                print("Error: \(error)")
                //Show error
                let alert = UIAlertView(title: self.checkLanguage("error"), message: self.checkLanguage("error_add_beacon") + "\(error)", delegate: self, cancelButtonTitle: self.checkLanguage("ok"))
                alert.show()
            }
            self.closeIndicatorActivity()
        }
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
    
    @IBAction func beaconColorBTEvent(sender: AnyObject) {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ColorTableVC") as! PickColorTableViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(200, 200)
        popover!.permittedArrowDirections = UIPopoverArrowDirection.Left
        popover!.delegate = self
        popover!.sourceView = beaconColorBT
        popover!.sourceRect = CGRectMake(beaconColorBT.frame.width,beaconColorBT.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
}

extension AddBeaconViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.beaconArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewBeaconCell", forIndexPath: indexPath) as! NewBeaconCollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        let beacon = self.beaconArray.objectAtIndex(indexPath.row) as! CLBeacon

        cell.beaconMajorMinor.text = "Major: \(beacon.major) - Minor: \(beacon.minor)"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.newBeaconCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.beaconInfoContainer.alpha = 0
            self.beaconInfoContainer.userInteractionEnabled = false
            }, completion: { (finished) -> Void in
                //
                //Provide information for container
                let beacon = self.beaconArray.objectAtIndex(indexPath.row) as! CLBeacon
                self.beacon = beacon
                self.beaconUUID.text = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
                self.beaconMajorMinor.text = "Major: \(beacon.major) - Minor: \(beacon.minor)"
                let title = self.checkLanguage("status") + ": " + "INACTIVE"
                self.beaconStatusBT.setTitle(title, forState: .Normal)
                self.beaconInfoContainer.alpha = 1
                self.beaconInfoContainer.userInteractionEnabled = true
        })
    }
}

extension AddBeaconViewController: ESTBeaconManagerDelegate, ESTUtilityManagerDelegate {
    func beaconManager(manager: AnyObject!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != .NotDetermined && status != .Denied {
            self.beaconManager.startRangingBeaconsInRegion(self.region)
        }
    }
    
    func beaconManager(manager: AnyObject!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        //Show error
        let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_ranging_beacon"), delegate: self, cancelButtonTitle: checkLanguage("ok"))
        alert.show()
    }
    
    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        self.beaconArray = beacons
        self.newBeaconCollectionView.reloadData()
    }
    
    func utilityManager(manager: ESTUtilityManager!, didDiscoverBeacons beacons: [AnyObject]!) {
        self.beaconArray = beacons
        self.newBeaconCollectionView.reloadData()
    }
}

extension AddBeaconViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}

extension AddBeaconViewController: PickContextTableViewControllerDelegate {
    func updateAssignButtonToChosenContext(context: String) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.beaconContextBT.alpha = 0
            self.beaconContextBT.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.beaconContextBT.setTitle(context, forState: .Normal)
                    self.beaconContext = context
                    self.beaconContextBT.alpha = 1
                    self.beaconContextBT.enabled = true
                })
        })
    }
}

extension AddBeaconViewController: PickColorTableViewControllerDelegate {
    func updateAssignButtonToChosenColor(color: String) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.beaconColorBT.alpha = 0
            self.beaconColorBT.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.beaconColor = color
                    self.beaconColorBT.setImage(UIImage(named: "Beacon-\(color)"), forState: .Normal)
                    self.beaconColorBT.alpha = 1
                    self.beaconColorBT.enabled = true
                })
        })
    }
}
